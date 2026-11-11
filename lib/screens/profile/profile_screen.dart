import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/preferences_service.dart';
import '../../models/accessibility_profile.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Meu perfil')),
    bottomNavigationBar: const MainNavigationBar(currentIndex: 3),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const CircleAvatar(radius: 42, backgroundColor: Color(0xFFDDF5F8), child: Icon(Icons.person_outline, color: AppColors.blue, size: 48)),
      const SizedBox(height: 12),
      const Text('Visitante', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const Text('Explore sem cadastro', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
      const SizedBox(height: 24),
      Card(child: Column(children: [
        ListTile(leading: const Icon(Icons.tune), title: const Text('Preferências de acessibilidade'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/accessibility')),
        const Divider(height: 1),
        ListTile(leading: const Icon(Icons.description_outlined), title: const Text('Meus relatórios'), trailing: const Icon(Icons.chevron_right), onTap: () => context.go('/report')),
        const Divider(height: 1),
        ListTile(leading: const Icon(Icons.favorite_border), title: const Text('Favoritos'), trailing: const Icon(Icons.chevron_right), onTap: () => context.go('/places')),
      ])),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: () async {
          await PreferencesService().saveProfile(const AccessibilityProfile());
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferências locais redefinidas.')));
        },
        icon: const Icon(Icons.restart_alt), label: const Text('Redefinir preferências'),
      ),
      const SizedBox(height: 12),
      const Text('Mobility+ • Protótipo inicial', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
    ]),
  );
}
