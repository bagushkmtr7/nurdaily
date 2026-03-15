import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/api_service.dart';
import '../../core/constants.dart';
import '../admin/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() {
    // Firebase otomatis inget login lu Ham, gak perlu SharedPreferences lagi
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminDashboardScreen()));
      });
    }
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      // Ini manggil fungsi Firebase yang kita buat di ApiService
      await _api.signIn(_emailController.text.trim(), _passwordController.text.trim());
      
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminDashboardScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Login: Email/Password salah!')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Takmir')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 80, color: AppColors.primary),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController, 
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin, 
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('MASUK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
