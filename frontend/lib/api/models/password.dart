class PasswordModel {
  final String? email;
  final String? code;
  final String? newPassword;

  PasswordModel(
      {required this.email, required this.code, required this.newPassword});

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      email: json['email'] ?? '',
      code: json['code'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }
}
