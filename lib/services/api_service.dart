import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

/// Consulta real ao Nominatim/OpenStreetMap. O serviço não presume
/// que um local seja acessível: apenas apresenta dados mapeados.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<List<Place>> searchPlaces(String query) async {
    final term = query.trim().isEmpty ? 'estabelecimentos' : query.trim();
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': term,
      'format': 'jsonv2',
      'addressdetails': '1',
      'extratags': '1',
      'limit': '20',
    });
    final response = await _client.get(uri, headers: {
      'User-Agent': 'MobilityPlusFIAP/1.0 (educational project)',
      'Accept-Language': 'pt-BR',
    }).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('O serviço de locais respondeu com código ${response.statusCode}.');
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) throw const FormatException('Formato de resposta inesperado.');
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Place.fromNominatim)
        .toList();
  }

  void dispose() => _client.close();
}
