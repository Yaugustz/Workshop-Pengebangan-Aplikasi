import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Pengaturan',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }
}