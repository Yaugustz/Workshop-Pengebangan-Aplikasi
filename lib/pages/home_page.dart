import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_page.dart'; // Import halaman login

class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false, // Menghilangkan tombol back bawaan
      ),
      // Menggunakan SingleChildScrollView agar layar bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Kartu untuk menampilkan seluruh data profil
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileRow('Nama Lengkap', user.namaLengkap),
                    const Divider(),
                    _buildProfileRow('Username', user.username),
                    const Divider(),
                    _buildProfileRow('Alamat', user.alamat),
                    const Divider(),
                    _buildProfileRow('Email', user.email),
                    const Divider(),
                    _buildProfileRow('Tanggal Lahir', user.tglLahir),
                    const Divider(),
                    _buildProfileRow('Jenis Kelamin', user.jenisKelamin),
                    const Divider(),
                    _buildProfileRow('No. HP', user.noHp),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Tombol Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 45),
                backgroundColor: Colors.redAccent, // Memberikan warna merah khas tombol keluar
                foregroundColor: Colors.white, // Warna teks putih
              ),
              onPressed: () {
                // Menghapus riwayat navigasi dan kembali ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi bantuan (helper) agar penulisan baris profil lebih rapi dan konsisten
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // Lebar tetap untuk label agar titik duanya sejajar
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const Text(' : ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}