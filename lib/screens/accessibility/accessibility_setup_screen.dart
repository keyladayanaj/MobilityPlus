import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/accessibility_profile.dart';
import '../../services/preferences_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/primary_button.dart';

class AccessibilitySetupScreen extends StatefulWidget {
  const AccessibilitySetupScreen({super.key});
  @override
  State<AccessibilitySetupScreen> createState() => _AccessibilitySetupScreenState();
}

class _AccessibilitySetupScreenState extends State<AccessibilitySetupScreen> {
  bool mobility = false, visual = false, hearing = false, cognitive = false;
  bool avoidStairs = false, preferRamps = false, highContrast = false;
  bool voiceGuidance = false, visualAlerts = false, simplified = false;

  Future<void> _continue() async {
    final profile = AccessibilityProfile(
      mobility: mobility, visual: visual, hearing: hearing, cognitive: cognitive,
      avoidStairs: avoidStairs, preferRamps: preferRamps,
      highContrast: highContrast, voiceGuidance: voiceGuidance,
      visualAlerts: visualAlerts, simplifiedInterface: simplified,
      screenReader: visual,
    );
    await PreferencesService().saveProfile(profile);
    if (mounted) context.go('/home');
  }

  Widget _choice(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) =>
    Card(child: CheckboxListTile(
      value: value, onChanged: (v) => onChanged(v ?? false),
      secondary: Icon(icon, color: AppColors.blue, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      controlAffinity: ListTileControlAffinity.trailing,
    ));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Personalize sua experiência')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Como podemos adaptar sua experiência?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 8),
          const Text('Selecione uma ou mais opções. Você poderá alterar tudo depois.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          _choice('Mobilidade física', 'Cadeira de rodas, muletas ou mobilidade reduzida', Icons.accessible_forward, mobility, (v) => setState(() => mobility = v)),
          _choice('Deficiência visual', 'Leitor de tela, áudio e alto contraste', Icons.visibility_outlined, visual, (v) => setState(() => visual = v)),
          _choice('Deficiência auditiva', 'Informações visuais e vibração', Icons.hearing, hearing, (v) => setState(() => hearing = v)),
          _choice('Apoio cognitivo', 'Linguagem simples e passos guiados', Icons.psychology_outlined, cognitive, (v) => setState(() => cognitive = v)),
          const SizedBox(height: 12),
          const Text('Preferências de deslocamento', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          SwitchListTile(title: const Text('Evitar escadas'), value: avoidStairs, onChanged: (v) => setState(() => avoidStairs = v)),
          SwitchListTile(title: const Text('Priorizar rampas'), value: preferRamps, onChanged: (v) => setState(() => preferRamps = v)),
          const SizedBox(height: 8),
          const Text('Ajustes da interface', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          SwitchListTile(title: const Text('Alto contraste'), value: highContrast, onChanged: (v) => setState(() => highContrast = v)),
          SwitchListTile(title: const Text('Orientações por voz'), value: voiceGuidance, onChanged: (v) => setState(() => voiceGuidance = v)),
          SwitchListTile(title: const Text('Alertas visuais'), value: visualAlerts, onChanged: (v) => setState(() => visualAlerts = v)),
          SwitchListTile(title: const Text('Interface simplificada'), value: simplified, onChanged: (v) => setState(() => simplified = v)),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Salvar preferências e continuar', onPressed: _continue),
          TextButton(onPressed: () => context.go('/home'), child: const Text('Fazer isso depois')),
        ],
      ),
    ),
  );
}
