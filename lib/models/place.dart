class Place {
  final String id;
  final String name;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final Map<String, dynamic> rawTags;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.rawTags = const {},
  });

  factory Place.fromNominatim(Map<String, dynamic> json) {
    final tags = Map<String, dynamic>.from(json['extratags'] ?? const {});
    final displayName = (json['display_name'] ?? '').toString();
    final parts = displayName.split(',');
    final category = (json['type'] ?? json['class'] ?? 'Local').toString();
    return Place(
      id: '${json['osm_type'] ?? 'place'}-${json['osm_id'] ?? json['place_id']}',
      name: (json['name'] ?? (parts.isNotEmpty ? parts.first : 'Local encontrado')).toString(),
      category: _friendlyCategory(category),
      description: 'Local encontrado no OpenStreetMap. Os recursos de acessibilidade ainda precisam ser confirmados.',
      latitude: double.tryParse('${json['lat']}') ?? 0,
      longitude: double.tryParse('${json['lon']}') ?? 0,
      address: displayName,
      rawTags: tags,
    );
  }

  static String _friendlyCategory(String value) {
    const names = {
      'restaurant': 'Alimentação', 'cafe': 'Alimentação', 'fast_food': 'Alimentação',
      'hospital': 'Saúde', 'pharmacy': 'Saúde', 'clinic': 'Saúde',
      'museum': 'Cultura', 'library': 'Cultura', 'theatre': 'Cultura',
      'park': 'Lazer', 'supermarket': 'Comércio', 'shop': 'Comércio',
    };
    return names[value] ?? 'Local';
  }

  bool get hasAccessibilityTags => rawTags.keys.any((k) =>
      k.toLowerCase().contains('wheelchair') || k.toLowerCase().contains('toilet'));
}
