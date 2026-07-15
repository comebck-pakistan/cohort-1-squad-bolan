import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('HisaabAI', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      const Text('Track receivables. Collect with confidence.'),
                      const SizedBox(height: 32),
                      TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email'), validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email address.'),
                      const SizedBox(height: 16),
                      TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password'), validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters.'),
                      const SizedBox(height: 24),
                      FilledButton(onPressed: _submitting ? null : _signIn, child: Text(_submitting ? 'Signing in…' : 'Sign in')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref.read(authRepositoryProvider).signInWithEmail(_emailController.text.trim(), _passwordController.text);
      if (mounted) context.go('/dashboard');
    } on FirebaseAuthException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Unable to sign in.')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
