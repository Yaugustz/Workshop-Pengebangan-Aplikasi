class UserModel {
  final String namaLengkap;
  final String username;
  final String email;
  final String tglLahir;
  final String jenisKelamin;
  final String noHp;
  final String password;
  final String alamat;

  static List<UserModel> registeredUsers = [];
  // Constructor
  UserModel({
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.noHp,
    required this.password,
    required this.alamat,
  });
}