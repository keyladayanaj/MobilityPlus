import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget _action(BuildContext context, IconData icon, String title, String route) =>
    InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE3EEF2))),
        child: Column(children: [
          Icon(icon, color: AppColors.blue, size: 32),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      ),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mobility+', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)), actions: [IconButton(tooltip: 'Perfil', onPressed: () => context.go('/profile'), icon: const Icon(Icons.person_outline))]),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Olá! 👋', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: AppColors.navy)),
        const SizedBox(height: 4),
        const Text('Como podemos ajudar no seu deslocamento?', style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 20),
        TextField(
          readOnly: true,
          onTap: () => context.go('/places'),
          decoration: const InputDecoration(hintText: 'Onde você deseja ir?', prefixIcon: Icon(Icons.search), suffixIcon: Icon(Icons.tune)),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.navy, AppColors.blue]), borderRadius: BorderRadius.circular(22)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.route, color: Colors.white, size: 34),
            const SizedBox(height: 12),
            const Text('Planeje uma rota acessível', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Encontre caminhos considerando suas preferências.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 14),
            FilledButton.tonal(onPressed: () => context.go('/routes'), child: const Text('Encontrar rota')),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('O que você deseja fazer?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.25,
          children: [
            _action(context, Icons.storefront_outlined, 'Locais inclusivos', '/places'),
            _action(context, Icons.map_outlined, 'Rotas acessíveis', '/routes'),
            _action(context, Icons.add_location_alt_outlined, 'Reportar barreira', '/report'),
            _action(context, Icons.favorite_border, 'Meus favoritos', '/profile'),
          ],
        ),
        const SizedBox(height: 22),
        const Text('Informação importante', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('As informações de acessibilidade devem ser verificadas no local. Consulte a data e a origem das avaliações antes de iniciar seu deslocamento.', style: TextStyle(color: AppColors.muted, height: 1.45)),
      ],
    ),
    bottomNavigationBar: const MainNavigationBar(currentIndex: 0),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Reportar barreira',
      onPressed: () => context.go('/report'),
      child: const Icon(Icons.add_a_photo_outlined),
    ),
  );
}
