import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/preferences_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _dontShowAgain = true;
  final _pages = const [
    _OnboardingData(Icons.route_rounded, 'Encontre rotas acessíveis', 'Planeje deslocamentos considerando suas necessidades de mobilidade.'),
    _OnboardingData(Icons.storefront_rounded, 'Descubra locais inclusivos', 'Consulte informações de locais e confirme os recursos de acessibilidade.'),
    _OnboardingData(Icons.diversity_3_rounded, 'Colabore com a cidade', 'Compartilhe avaliações e reporte barreiras para ajudar outras pessoas.'),
  ];

  Future<void> _finish() async {
    if (_dontShowAgain) {
      await PreferencesService().completeOnboarding();
    }
    if (mounted) context.go('/access');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(children: [
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _finish, child: const Text('Pular'))),
          Expanded(child: PageView.builder(
            controller: _controller, itemCount: _pages.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (context, index) {
              final item = _pages[index];
              return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset('assets/images/mobility_mark.png', width: 150, height: 150,
                  errorBuilder: (_, __, ___) => Icon(item.icon, size: 100, color: AppColors.blue)),
                const SizedBox(height: 32),
                Text(item.title, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: AppColors.navy)),
                const SizedBox(height: 14),
                Text(item.description, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.muted)),
              ]);
            },
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
            AnimatedContainer(duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 4), width: i == _page ? 24 : 8, height: 8,
              decoration: BoxDecoration(color: i == _page ? AppColors.blue : const Color(0xFFB7CDD8),
                borderRadius: BorderRadius.circular(10))))),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero, value: _dontShowAgain,
            onChanged: (v) => setState(() => _dontShowAgain = v ?? false),
            title: const Text('Não mostrar novamente'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          PrimaryButton(label: _page == 2 ? 'Começar' : 'Próximo', onPressed: () {
            if (_page == 2) { _finish(); }
            else { _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut); }
          }, icon: Icons.arrow_forward_rounded),
          if (_page > 0) TextButton(
            onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
            child: const Text('Voltar')),
        ]),
      )),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  const _OnboardingData(this.icon, this.title, this.description);
}
