import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _hostelController = TextEditingController(text: 'Abheri');
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _hostelController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_hostelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your hostel ID to continue.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) context.go('/hostels/${_hostelController.text.trim()}/rooms');
  }

  InputDecoration _fieldDecoration(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF5E645F)),
        filled: true,
        fillColor: const Color(0xFFF6F7F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 42),
                  const Text('HOSTEL ID', style: TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(controller: _hostelController, textCapitalization: TextCapitalization.characters, decoration: _fieldDecoration('e.g. Abheri', Icons.apartment_outlined)),
                  const SizedBox(height: 22),
                  const Text('PASSWORD', style: TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(controller: _passwordController, obscureText: true, decoration: _fieldDecoration('Enter your password', Icons.lock_outline)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF173D32), foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56), elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
