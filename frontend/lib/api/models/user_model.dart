class UserModel {
  final int? id;
  final String schoolID;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String role;
  final String hkType;
  final String status;
  final String token;

  UserModel({
    this.id,
    required this.schoolID,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.role,
    required this.hkType,
    required this.status,
    required this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      schoolID: map['school_id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'] ?? '',
      role: map['role'] ?? '',
      hkType: map['hk_type'],
      status: map['status'] ?? '',
      token: map['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolID,
      'email': email,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'role': role,
      'hk_type': hkType,
      'status': status,
      'token': token,
    };
  }
}
