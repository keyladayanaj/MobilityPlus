import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _accepted = false;

  @override
  void dispose() { _name.dispose(); _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Criar sua conta')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v == null || v.trim().length < 3 ? 'Informe seu nome.' : null),
              const SizedBox(height: 14),
              TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)), validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido.' : null),
              const SizedBox(height: 14),
              TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline)), validator: (v) => v == null || v.length < 6 ? 'Use pelo menos 6 caracteres.' : null),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _accepted,
                onChanged: (v) => setState(() => _accepted = v ?? false),
                title: const Text('Li e aceito os termos de uso e a política de privacidade.'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 18),
              PrimaryButton(label: 'Cadastrar', onPressed: () {
                if (_formKey.currentState!.validate() && _accepted) {
                  context.go('/accessibility');
                } else if (!_accepted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aceite os termos para continuar.')));
                }
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
