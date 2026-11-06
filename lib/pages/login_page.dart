import 'package:flutter/material.dart';
import 'register_page.dart';
import '../models/user_model.dart';
import '../database/database_helper.dart'; // <-- Tambahkan import ini
import 'navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // UBAH MENJADI ASYNC UNTUK CEK DATABASE
  Future<void> _login() async {
    String inputUsername = _usernameController.text.trim();
    String inputPassword = _passwordController.text.trim();

    // Panggil fungsi login dari DatabaseHelper
    UserModel? loggedInUser = await DatabaseHelper.instance.loginUser(inputUsername, inputPassword);

    if (loggedInUser != null) {
      // Jika user ditemukan di database, masuk ke HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: loggedInUser)),
      );
    } else {
      // Jika tidak ditemukan / salah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau Password salah / belum terdaftar!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Belum punya akun? Register di sini'),
            ),
          ],
        ),
      ),
    );
  }
}