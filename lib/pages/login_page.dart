import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import 'account_page.dart';
import 'authenticate_email_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passController = TextEditingController();

  Future<void> _logIn() async {
    late AuthResponse res = AuthResponse();
    try {
      setState(() {
        _isLoading = true;
      });
      res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      if (mounted) {
        context.showSnackBar('Loged in');

        _emailController.clear();
        if (res.session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        }
      }
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: ListView(
          children: [
            const Text('Sign in with Email and password'),
            const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isLoading ? null : _logIn,
              child: Text(_isLoading ? 'checking...' : 'Log in'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                if (_isLoading) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthenticateEmailPage(),
                  ),
                );
              },
              child: const Text('Create a account'),
            ),
          ],
        ),
      ),
    );
  }
}
