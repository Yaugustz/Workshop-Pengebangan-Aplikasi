import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Pesan',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }
}