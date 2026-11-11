import 'package:flutter/material.dart';
import '../../models/place.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place? place;

  @override
  Widget build(BuildContext context) {
    final item = place;
    if (item == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Local não encontrado. Volte e selecione um local da lista.')));
    }
    return Scaffold(appBar: AppBar(leading: const HomeButton(), title: const Text('Detalhes do local')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(height: 150, decoration: BoxDecoration(color: const Color(0xFFDFF5F8), borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.storefront_outlined, color: AppColors.blue, size: 72)),
        const SizedBox(height: 20),
        Text(item.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: AppColors.navy)),
        Text(item.category, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 16),
        const Text('Endereço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(item.address),
        const SizedBox(height: 16),
        const Text('Acessibilidade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(item.hasAccessibilityTags ? Icons.info_outline : Icons.help_outline, color: AppColors.blue),
          title: Text(item.hasAccessibilityTags ? 'Há tags relacionadas à acessibilidade' : 'Informações não disponíveis'),
          subtitle: Text(item.hasAccessibilityTags
            ? 'O OpenStreetMap contém algumas marcações. Verifique os detalhes antes da visita.'
            : 'Não há dados suficientes para afirmar que este local é acessível.'),
        ),
        const SizedBox(height: 12),
        Text(item.description, style: const TextStyle(color: AppColors.muted, height: 1.5)),
        const SizedBox(height: 18),
        const Text('Fonte: OpenStreetMap / Nominatim. Confirme as condições diretamente com o estabelecimento.',
          style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SelectableText('Coordenadas: ${item.latitude}, ${item.longitude}'),
      ]),
    );
  }
}
