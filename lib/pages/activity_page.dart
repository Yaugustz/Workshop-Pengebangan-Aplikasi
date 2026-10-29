import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Aktivitas',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }
}