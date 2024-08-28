class UpdatePasswordModel {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const UpdatePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> map) {
    return UpdatePasswordModel(
      oldPassword: map['oldPassword'] as String,
      newPassword: map['newPassword'] as String,
      confirmPassword: map['confirmPassword'] as String,
    );
  }
}