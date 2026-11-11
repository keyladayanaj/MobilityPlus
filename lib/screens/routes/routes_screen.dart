import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/primary_button.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _mapController = MapController();
  bool _avoidStairs = true;
  bool _preferRamps = true;
  bool _loading = false;
  String? _error;
  LatLng? _start;
  LatLng? _end;
  List<LatLng> _routePoints = [];
  double? _distanceKm;
  double? _durationMinutes;
  List<Map<String, dynamic>> _steps = [];
  bool _navigating = false;
  StreamSubscription<Position>? _positionSubscription;
  LatLng? _currentPosition;
  int _currentStepIndex = 0;

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    _positionSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<LatLng> _geocode(String address) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': address,
      'format': 'jsonv2',
      'limit': '1',
    });
    final response = await http.get(uri, headers: {
      'User-Agent': 'MobilityPlusFIAP/1.0 (educational project)',
      'Accept-Language': 'pt-BR',
    }).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Não foi possível localizar o endereço (HTTP ${response.statusCode}).');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    if (data.isEmpty) throw Exception('Endereço não encontrado: $address');
    final item = data.first as Map<String, dynamic>;
    return LatLng(double.parse(item['lat'].toString()), double.parse(item['lon'].toString()));
  }

  Future<void> _useCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Permissão de localização não concedida. Você pode digitar a origem manualmente.');
      }
      final position = await Geolocator.getCurrentPosition();
      _origin.text = '${position.latitude}, ${position.longitude}';
      if (mounted) setState(() {});
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _searchRoute() async {
    final origin = _origin.text.trim();
    final destination = _destination.text.trim();
    if (origin.isEmpty || destination.isEmpty) {
      _showMessage('Informe a origem e o destino para calcular a rota.');
      return;
    }
    setState(() { _loading = true; _error = null; _routePoints = []; _steps = []; _navigating = false; });
    try {
      final start = _isCoordinate(origin) ? _parseCoordinate(origin) : await _geocode(origin);
      final end = _isCoordinate(destination) ? _parseCoordinate(destination) : await _geocode(destination);
      final uri = Uri.https('router.project-osrm.org', '/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}', {
        'overview': 'full', 'geometries': 'geojson', 'steps': 'true',
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) throw Exception('O serviço de rotas não respondeu corretamente.');
      final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (json['code'] != 'Ok' || (json['routes'] as List).isEmpty) {
        throw Exception('Não foi possível calcular um trajeto entre esses endereços.');
      }
      final route = (json['routes'] as List).first as Map<String, dynamic>;
      final coordinates = (route['geometry']['coordinates'] as List)
          .map((point) => LatLng((point[1] as num).toDouble(), (point[0] as num).toDouble()))
          .toList();
      final legs = (route['legs'] as List?) ?? [];
      final parsedSteps = <Map<String, dynamic>>[];
      for (final leg in legs) {
        for (final step in ((leg as Map<String, dynamic>)['steps'] as List? ?? [])) {
          parsedSteps.add(Map<String, dynamic>.from(step as Map));
        }
      }
      if (!mounted) return;
      setState(() {
        _start = start;
        _end = end;
        _routePoints = coordinates;
        _distanceKm = (route['distance'] as num).toDouble() / 1000;
        _durationMinutes = (route['duration'] as num).toDouble() / 60;
        _steps = parsedSteps;
        _currentStepIndex = 0;
        _currentPosition = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && coordinates.isNotEmpty) {
          final bounds = LatLngBounds.fromPoints(coordinates);
          _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(36)));
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  String _instructionFor(Map<String, dynamic> step) {
    final maneuver = Map<String, dynamic>.from(step['maneuver'] as Map? ?? {});
    final type = (maneuver['type'] ?? 'continue').toString();
    final modifier = (maneuver['modifier'] ?? '').toString();
    final street = (step['name'] ?? '').toString();
    final streetText = street.isEmpty ? '' : ' na $street';
    if (type == 'depart') return 'Siga em frente$streetText';
    if (type == 'arrive') return 'Você chegou ao destino';
    if (type == 'turn') {
      final direction = modifier.isEmpty ? 'na direção indicada' : modifier == 'left' || modifier == 'slight left' ? 'à esquerda' : modifier == 'right' || modifier == 'slight right' ? 'à direita' : modifier == 'uturn' ? 'e faça o retorno' : 'em frente';
      return 'Vire $direction$streetText';
    }
    if (type == 'roundabout' || type == 'rotary') return 'Entre na rotatória$streetText';
    if (type == 'new name' || type == 'continue') return 'Continue$streetText';
    return 'Siga as instruções do trajeto$streetText';
  }

  double _metersToNextStep() {
    if (_steps.isEmpty || _currentStepIndex >= _steps.length) return 0;
    final maneuver = Map<String, dynamic>.from(_steps[_currentStepIndex]['maneuver'] as Map? ?? {});
    final location = maneuver['location'] as List?;
    if (location == null || location.length < 2 || _currentPosition == null) {
      return ((_steps[_currentStepIndex]['distance'] as num?) ?? 0).toDouble();
    }
    return const Distance().as(LengthUnit.Meter, _currentPosition!, LatLng((location[1] as num).toDouble(), (location[0] as num).toDouble()));
  }

  Future<void> _startNavigation() async {
    if (_routePoints.isEmpty) return;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Permita o acesso à localização para iniciar a navegação.');
      }
      final current = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _navigating = true;
        _currentPosition = LatLng(current.latitude, current.longitude);
        _currentStepIndex = 0;
      });
      await _positionSubscription?.cancel();
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 8),
      ).listen((position) {
        if (!mounted || !_navigating) return;
        final here = LatLng(position.latitude, position.longitude);
        var nextIndex = _currentStepIndex;
        // Avança quando o usuário chega próximo ao ponto da próxima manobra.
        if (_steps.isNotEmpty && nextIndex < _steps.length - 1) {
          final maneuver = Map<String, dynamic>.from(_steps[nextIndex]['maneuver'] as Map? ?? {});
          final location = maneuver['location'] as List?;
          if (location != null && location.length >= 2) {
            final target = LatLng((location[1] as num).toDouble(), (location[0] as num).toDouble());
            if (const Distance().as(LengthUnit.Meter, here, target) < 35) nextIndex++;
          }
        }
        setState(() {
          _currentPosition = here;
          _currentStepIndex = nextIndex;
        });
        _mapController.move(here, 16);
      }, onError: (_) {
        if (mounted) _showMessage('Não foi possível atualizar sua localização. Verifique a permissão do navegador.');
      });
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _stopNavigation() async {
    await _positionSubscription?.cancel();
    if (mounted) setState(() => _navigating = false);
  }

  bool _isCoordinate(String value) => RegExp(r'^\s*-?\d+(?:\.\d+)?\s*,\s*-?\d+(?:\.\d+)?\s*$').hasMatch(value);

  LatLng _parseCoordinate(String value) {
    final parts = value.split(',');
    return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Rotas acessíveis')),
    bottomNavigationBar: const MainNavigationBar(currentIndex: 2),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      TextField(
        controller: _origin,
        decoration: InputDecoration(
          labelText: 'Origem', prefixIcon: const Icon(Icons.my_location),
          suffixIcon: IconButton(tooltip: 'Usar minha localização', onPressed: _useCurrentLocation, icon: const Icon(Icons.gps_fixed)),
        ),
      ),
      const SizedBox(height: 12),
      TextField(controller: _destination, decoration: const InputDecoration(labelText: 'Destino', prefixIcon: Icon(Icons.location_on_outlined))),
      const SizedBox(height: 18),
      const Text('Preferências do percurso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Evitar escadas'), value: _avoidStairs, onChanged: (v) => setState(() => _avoidStairs = v)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Priorizar rampas'), value: _preferRamps, onChanged: (v) => setState(() => _preferRamps = v)),
      const SizedBox(height: 12),
      PrimaryButton(label: _loading ? 'Calculando...' : 'Buscar rota', icon: Icons.search, onPressed: _loading ? null : _searchRoute),
      if (_error != null) ...[
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.withValues(alpha: .08), borderRadius: BorderRadius.circular(12)), child: Text(_error!, style: const TextStyle(color: Colors.red))),
      ],
      if (_routePoints.isNotEmpty) ...[
        const SizedBox(height: 18),
        Container(height: 300, clipBehavior: Clip.antiAlias, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)), child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _start!, initialZoom: 13),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.mobilityplus.app'),
            PolylineLayer(polylines: [Polyline(points: _routePoints, strokeWidth: 5, color: AppColors.blue)]),
            MarkerLayer(markers: [
              Marker(point: _start!, width: 42, height: 42, child: const Icon(Icons.trip_origin, color: Colors.green, size: 34)),
              Marker(point: _end!, width: 42, height: 42, child: const Icon(Icons.location_on, color: Colors.red, size: 40)),
              if (_navigating && _currentPosition != null)
                Marker(point: _currentPosition!, width: 44, height: 44, child: const Icon(Icons.navigation, color: Colors.deepOrange, size: 38)),
            ]),
          ],
        )),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_distanceKm!.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Duração estimada: ${_durationMinutes!.round()} min'),
          const SizedBox(height: 8),
          const Text('Trajeto calculado pelo OSRM para deslocamento de carro. As preferências de escadas e rampas ainda não são aplicadas ao cálculo; confirme as condições de acessibilidade no local.'),
        ]))),
        if (!_navigating) ...[
          const SizedBox(height: 12),
          PrimaryButton(label: 'Iniciar navegação', icon: Icons.navigation, onPressed: _startNavigation),
        ] else ...[
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFFE3F7FA),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.navigation, color: AppColors.blue),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Navegação ativa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  TextButton(onPressed: _stopNavigation, child: const Text('Encerrar')),
                ]),
                const SizedBox(height: 8),
                Text(_steps.isNotEmpty && _currentStepIndex < _steps.length
                    ? _instructionFor(_steps[_currentStepIndex])
                    : 'Siga pelo trajeto indicado no mapa',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(_metersToNextStep() >= 1000
                    ? '${(_metersToNextStep() / 1000).toStringAsFixed(1)} km até a próxima instrução'
                    : '${_metersToNextStep().round()} m até a próxima instrução'),
                const SizedBox(height: 8),
                const Text('A posição é atualizada pelo GPS do dispositivo. Alertas de obstáculos e condições de acessibilidade ainda dependem de dados específicos e não são garantidos.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
              ]),
            ),
          ),
        ],
      ] else ...[
        const SizedBox(height: 22),
        Container(height: 180, decoration: BoxDecoration(color: const Color(0xFFE3F7FA), borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.map_outlined, size: 72, color: AppColors.blue))),
        const SizedBox(height: 12),
        const Text('Informe origem e destino para visualizar o trajeto no mapa.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
      ],
      const SizedBox(height: 12),
      const Text('Mapas: OpenStreetMap. Geocodificação: Nominatim. Cálculo de trajeto: OSRM. Uma rota calculada não representa garantia de acessibilidade.', style: TextStyle(fontSize: 12, color: AppColors.muted)),
    ]),
  );
}
