import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Explore',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }
}