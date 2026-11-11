import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/place.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';

enum _LoadState { initial, loading, success, error }

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _api = ApiService();
  final _searchController = TextEditingController(text: 'parques e estabelecimentos em São Paulo');
  _LoadState _state = _LoadState.initial;
  List<Place> _places = [];
  String? _error;
  String _query = 'parques e estabelecimentos em São Paulo';
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() { _state = _LoadState.loading; _error = null; });
    try {
      final result = await _api.searchPlaces(_query);
      if (!mounted) return;
      setState(() { _places = result; _state = _LoadState.success; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Não foi possível carregar os locais. Verifique sua conexão e tente novamente.'; _state = _LoadState.error; });
    }
  }

  @override
  void dispose() {
    _api.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const HomeButton(), title: const Text('Explorar locais'), actions: [
        IconButton(tooltip: 'Atualizar', onPressed: _loadPlaces, icon: const Icon(Icons.refresh)),
      ]),
      bottomNavigationBar: const MainNavigationBar(currentIndex: 1),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (v) { _query = v; _loadPlaces(); },
              decoration: const InputDecoration(
                hintText: 'Buscar local ou endereço',
                prefixIcon: Icon(Icons.search),
              ),
            )),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: () { _query = _searchController.text; _loadPlaces(); },
              icon: const Icon(Icons.arrow_forward)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(children: [
            const Icon(Icons.info_outline, size: 16, color: AppColors.muted),
            const SizedBox(width: 6),
            Expanded(child: Text('Dados do OpenStreetMap. Acessibilidade deve ser confirmada no local.',
              style: Theme.of(context).textTheme.bodySmall)),
          ]),
        ),
        Expanded(child: _buildContent()),
      ]),
    );
  }

  Widget _buildContent() {
    if (_state == _LoadState.initial || _state == _LoadState.loading) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(), SizedBox(height: 12), Text('Buscando locais...'),
      ]));
    }
    if (_state == _LoadState.error) {
      return Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(
        mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cloud_off_outlined, size: 52, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(_error ?? 'Ocorreu um erro.', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(onPressed: _loadPlaces, icon: const Icon(Icons.refresh), label: const Text('Tentar novamente')),
        ],
      )));
    }
    if (_places.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.search_off, size: 48), const SizedBox(height: 8),
        const Text('Nenhum local encontrado.'),
        TextButton(onPressed: _loadPlaces, child: const Text('Buscar novamente')),
      ]));
    }
    return RefreshIndicator(onRefresh: _loadPlaces, child: ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        final favorite = _favorites.contains(place.id);
        return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: const CircleAvatar(backgroundColor: Color(0xFFE3F7FA),
            child: Icon(Icons.place_outlined, color: AppColors.blue)),
          title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${place.category}\\n${place.address}', maxLines: 3, overflow: TextOverflow.ellipsis),
          isThreeLine: true,
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(tooltip: favorite ? 'Remover favorito' : 'Favoritar',
              onPressed: () => setState(() { favorite ? _favorites.remove(place.id) : _favorites.add(place.id); }),
              icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : AppColors.muted)),
            const Icon(Icons.chevron_right),
          ]),
          onTap: () => context.push('/place/${Uri.encodeComponent(place.id)}', extra: place),
        ));
      },
    ));
  }
}
