import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 10),
          const Text(
            'Smooth Ride with a Cutie',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
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
          const SizedBox(height: 20),
          SizedBox(
            width: 130,
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Logout', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const Text(' : ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}