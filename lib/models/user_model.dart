class UserModel {
  final int? id; // Primary Key untuk SQLite (auto-increment)
  final String namaLengkap;
  final String username;
  final String email;
  final String tglLahir;
  final String jenisKelamin;
  final String noHp;
  final String password;
  final String alamat;

  // Constructor
  UserModel({
    this.id,
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.noHp,
    required this.password,
    required this.alamat,
  });

  // Konversi dari Object UserModel ke Map (Digunakan saat INSERT ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaLengkap': namaLengkap,
      'username': username,
      'email': email,
      'tglLahir': tglLahir,
      'jenisKelamin': jenisKelamin,
      'noHp': noHp,
      'password': password,
      'alamat': alamat,
    };
  }

  // Konversi dari Map SQLite ke Object UserModel (Digunakan saat SELECT dari database)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      namaLengkap: map['namaLengkap'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      tglLahir: map['tglLahir'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? '',
      noHp: map['noHp'] ?? '',
      password: map['password'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }
}