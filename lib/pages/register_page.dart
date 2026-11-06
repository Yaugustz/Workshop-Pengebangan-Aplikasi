import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../database/database_helper.dart';
import 'navbar.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _tglLahirController = TextEditingController();
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _alamatController = TextEditingController();

  String? _selectedGender;
  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _tglLahirController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Fungsi register yang disatukan dengan debugging terminal & try-catch SQLite
  Future<void> _register() async {
    // 1. Cek validasi form UI
    if (_formKey.currentState!.validate()) {
      debugPrint("DEBUG: Validasi Form Berhasil!");

      try {
        UserModel newUser = UserModel(
          namaLengkap: _namaController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          tglLahir: _tglLahirController.text.trim(),
          jenisKelamin: _selectedGender!, 
          noHp: _noHpController.text.trim(),
          password: _passwordController.text.trim(),
          alamat: _alamatController.text.trim(),
        );

        // 2. Eksekusi penyimpanan ke Database SQLite
        debugPrint("DEBUG: Mencoba menyimpan data ke database SQLite...");
        int resultId = await DatabaseHelper.instance.insertUser(newUser);
        debugPrint("DEBUG: Berhasil disimpan! ID user baru: $resultId");

        // 3. Notifikasi sukses
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil Disimpan ke Database!')),
        );

        // 4. Pindah ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: newUser),
          ),
        );
      } catch (e) {
        // Tangkap error jika database gagal menyimpan
        debugPrint("DEBUG ERROR SQLite: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan ke database: $e')),
        );
      }
    } else {
      debugPrint("DEBUG: Validasi Form Gagal! Periksa kembali kolom input.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data form dengan benar!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama lengkap tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Username tidak boleh kosong';
                  if (value.length < 4) return 'Username minimal 4 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
                  if (!value.contains('@') || !value.contains('.')) return 'Masukkan format email yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tglLahirController,
                readOnly: true,
                onTap: () => _pilihTanggal(context),
                decoration: const InputDecoration(labelText: 'Tanggal Lahir', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                validator: (value) => value == null || value.isEmpty ? 'Silakan pilih tanggal lahir' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin', border: OutlineInputBorder()),
                items: ['Laki-laki', 'Perempuan'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
                validator: (value) => value == null || value.isEmpty ? 'Silakan pilih jenis kelamin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noHpController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                decoration: const InputDecoration(labelText: 'No. HP', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'No. HP tidak boleh kosong';
                  if (value.length < 10) return 'No. HP minimal 10 digit';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscurePassword = !_isObscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                  if (value.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Verifikasi Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                  if (value != _passwordController.text) return 'Password dan Konfirmasi Password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
                onPressed: _register,
                child: const Text('Register'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Sudah punya akun? Login di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}