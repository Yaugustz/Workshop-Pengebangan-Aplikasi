import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'profile_page.dart';
import 'explore_page.dart';
import 'activity_page.dart';
import 'message_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Memasukkan halaman-halaman dari file terpisah ke dalam list
    final List<Widget> pages = [
      ProfilePage(user: widget.user),
      const ExplorePage(),
      const ActivityPage(),
      const MessagePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_currentIndex)),
        automaticallyImplyLeading: false,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Agar 5 item muat sejajar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Profil Pengguna';
      case 1:
        return 'Explore';
      case 2:
        return 'Aktivitas';
      case 3:
        return 'Pesan';
      case 4:
        return 'Pengaturan';
      default:
        return 'Home';
    }
  }
}