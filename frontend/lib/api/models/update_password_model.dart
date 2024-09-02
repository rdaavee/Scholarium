class UpdatePasswordModel {
  final bool success;
  final String message;

  UpdatePasswordModel({required this.success, required this.message});

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordModel(
      success: json['success'],
      message: json['message'] ?? '',
    );
  }
}
