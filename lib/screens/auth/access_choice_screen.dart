import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/primary_button.dart';

class AccessChoiceScreen extends StatelessWidget {
  const AccessChoiceScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const BrandMark(size: 82),
            const SizedBox(height: 18),
            const Text('Mobility+', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 8),
            const Text('Como você deseja continuar?', style: TextStyle(fontSize: 18, color: AppColors.muted)),
            const SizedBox(height: 36),
            PrimaryButton(label: 'Explorar sem conta', icon: Icons.explore_outlined, onPressed: () => context.go('/accessibility')),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login), label: const Text('Entrar'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: () => context.go('/register'),
              icon: const Icon(Icons.person_add_alt_1), label: const Text('Criar uma conta'),
            ),
            const Spacer(),
            const Text('Você pode se cadastrar depois.', style: TextStyle(color: AppColors.muted)),
          ],
        ),
      ),
    ),
  );
}
