import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/preferences_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/brand_mark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _continue();
  }

  Future<void> _continue() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    final completed = await PreferencesService().hasCompletedOnboarding();
    if (!mounted) return;
    context.go(completed ? '/access' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy, AppColors.blue, AppColors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 104),
            const SizedBox(height: 22),
            const Text('Mobility+', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Mobilidade inclusiva para todos.', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 36),
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
          ],
        ),
      ),
    ),
  );
}
