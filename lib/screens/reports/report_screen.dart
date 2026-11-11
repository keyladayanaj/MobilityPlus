import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/primary_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _description = TextEditingController();
  String _type = 'Calçada irregular';

  @override
  void dispose() { _description.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Reportar barreira')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Ajude a tornar a cidade mais acessível.', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: AppColors.navy)),
      const SizedBox(height: 8),
      const Text('Informe um obstáculo encontrado. Não inclua dados pessoais de terceiros nas fotos.', style: TextStyle(color: AppColors.muted)),
      const SizedBox(height: 22),
      OutlinedButton.icon(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A seleção de fotos será implementada.'))),
        icon: const Icon(Icons.camera_alt_outlined), label: const Text('Adicionar foto'),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(76), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ),
      const SizedBox(height: 18),
      DropdownButtonFormField<String>(
        value: _type,
        decoration: const InputDecoration(labelText: 'Tipo de barreira'),
        items: const ['Calçada irregular', 'Ausência de rampa', 'Escada sem alternativa', 'Obstrução no caminho', 'Falta de sinalização tátil', 'Outro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => _type = v ?? _type),
      ),
      const SizedBox(height: 16),
      TextField(controller: _description, maxLines: 5, maxLength: 300, decoration: const InputDecoration(labelText: 'Descreva o problema', alignLabelWithHint: true)),
      const SizedBox(height: 16),
      PrimaryButton(label: 'Enviar relato', icon: Icons.send, onPressed: () {
        if (_description.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descreva a barreira antes de enviar.')));
          return;
        }
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Relato preparado'),
          content: const Text('O formulário está validado. O envio será habilitado quando a API estiver conectada.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
        ));
      }),
    ]),
  );
}
