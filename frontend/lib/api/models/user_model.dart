class UserModel {
  final String schoolID;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String role;
  final String status;
  final String token;

  UserModel({
    required this.schoolID,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      schoolID: map['schoolID'],
      email: map['email'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      role: map['role'],
      status: map['status'],
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolID': schoolID,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'role': role,
      'status': status,
      'token': token,
    };
  }
}
