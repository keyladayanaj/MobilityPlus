import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const HomeButton(), title: const Text('Entrar na sua conta')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Que bom ter você aqui!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: AppColors.navy)),
              const SizedBox(height: 8),
              const Text('Entre para acessar suas preferências e recursos personalizados.', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 28),
              TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)), validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido.' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _password, obscureText: _obscure, decoration: InputDecoration(labelText: 'Senha', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined))), validator: (v) => v == null || v.length < 6 ? 'A senha deve ter pelo menos 6 caracteres.' : null),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Entrar', onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Autenticação ainda não conectada ao backend.')));
                }
              }),
              const SizedBox(height: 16),
              Center(child: TextButton(onPressed: () => context.go('/register'), child: const Text('Não tem conta? Cadastre-se'))),
            ],
          ),
        ),
      ),
    ),
  );
}
