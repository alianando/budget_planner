import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import 'account_page.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  bool _isLoading = false;
  // bool _redirecting = false;
  late final TextEditingController _passController = TextEditingController();
  // late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _updatePassword(String paswordString) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final auth = supabase.auth;
      UserAttributes attributes = UserAttributes(password: paswordString);
      UserResponse res = await auth.updateUser(attributes);
      if (res.user != null) {
        if (mounted) {
          context.showSnackBar('Added password');

          _passController.clear();
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

    return;
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Add a password'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (_isLoading) return;
              _updatePassword(_passController.text.trim());
            },
            child: Text(_isLoading ? 'updating...' : 'Add password'),
          ),
        ],
      ),
    );
  }
}
