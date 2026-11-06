import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../database/database_helper.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel currentUser;
  int _openCount = 0; // Variabel untuk menyimpan jumlah buka aplikasi

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _incrementOpenCount(); // Panggil fungsi penghitung saat halaman dibuka
  }

  // Fungsi untuk menambah dan menyimpan jumlah buka aplikasi
  Future<void> _incrementOpenCount() async {
    final prefs = await SharedPreferences.getInstance();
    int count = (prefs.getInt('app_open_count') ?? 0) + 1;
    await prefs.setInt('app_open_count', count);
    setState(() {
      _openCount = count;
    });
  }

  // Fungsi untuk menampilkan form edit profil melayang dari bawah
  void _showEditBottomSheet(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _namaController = TextEditingController(text: currentUser.namaLengkap);
    final _alamatController = TextEditingController(text: currentUser.alamat);
    final _noHpController = TextEditingController(text: currentUser.noHp);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Alamat tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noHpController,
                  decoration: const InputDecoration(
                    labelText: 'No. HP',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'No. HP tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserModel updatedUser = UserModel(
                          id: currentUser.id,
                          namaLengkap: _namaController.text.trim(),
                          username: currentUser.username,
                          email: currentUser.email,
                          tglLahir: currentUser.tglLahir,
                          jenisKelamin: currentUser.jenisKelamin,
                          noHp: _noHpController.text.trim(),
                          password: currentUser.password,
                          alamat: _alamatController.text.trim(),
                        );

                        await DatabaseHelper.instance.updateUser(updatedUser);

                        setState(() {
                          currentUser = updatedUser;
                        });

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil berhasil diperbarui!')),
                        );
                      }
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text(
              'Smooth Ride with a Cutie :P',
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
                    _buildProfileRow('Nama Lengkap', currentUser.namaLengkap),
                    const Divider(),
                    _buildProfileRow('Username', currentUser.username),
                    const Divider(),
                    _buildProfileRow('Alamat', currentUser.alamat),
                    const Divider(),
                    _buildProfileRow('Email', currentUser.email),
                    const Divider(),
                    _buildProfileRow('Tanggal Lahir', currentUser.tglLahir),
                    const Divider(),
                    _buildProfileRow('Jenis Kelamin', currentUser.jenisKelamin),
                    const Divider(),
                    _buildProfileRow('No. HP', currentUser.noHp),
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
            const SizedBox(height: 20),
            // Teks indikator penghitung buka aplikasi ala laporan praktikum
            Text(
              'Aplikasi ini sudah dibuka $_openCount kali',
              style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditBottomSheet(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.edit, color: Colors.white),
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