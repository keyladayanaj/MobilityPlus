import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


/// Atalho consistente para voltar ao início a partir de telas secundárias.
class HomeButton extends StatelessWidget {
  const HomeButton({super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Voltar ao início',
    onPressed: () => context.go('/home'),
    icon: const Icon(Icons.home_outlined),
  );
}

/// Menu principal compartilhado entre Início, Locais, Rotas e Perfil.
class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key, required this.currentIndex});
  final int currentIndex;

  void _navigate(BuildContext context, int index) {
    const routes = ['/home', '/places', '/routes', '/profile'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: (index) => _navigate(context, index),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
      NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Locais'),
      NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Rotas'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
    ],
  );
}
