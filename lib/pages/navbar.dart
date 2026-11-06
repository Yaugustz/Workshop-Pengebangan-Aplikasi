import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isDarkMode = false; // Status mode gelap

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Memuat status tema saat aplikasi dibuka
  }

  // Fungsi untuk mengambil status tema dari SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  // Fungsi untuk mengubah dan menyimpan status tema
  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Membungkus MaterialApp atau menggunakan Theme di sini
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(_currentIndex)),
          automaticallyImplyLeading: false,
          actions: [
            // Tombol Switch / Ikon Mode Gelap di AppBar utama
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => _toggleTheme(!_isDarkMode),
              tooltip: 'Ubah Tema',
            ),
          ],
        ),
        body: _getPages()[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
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
      ),
    );
  }

  List<Widget> _getPages() {
    return [
      ProfilePage(user: widget.user),
      const ExplorePage(),
      const ActivityPage(),
      const MessagePage(),
      const SettingsPage(),
    ];
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