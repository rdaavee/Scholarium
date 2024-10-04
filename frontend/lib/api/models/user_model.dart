class UserModel {
  final int? id;
  final String? schoolID;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String profilePicture;
  final String gender;
  final String? password;
  final String contact;
  final String address;
  final String role;
  final String professor;
  final String hkType;
  final String status;
  final String? token;

  UserModel({
    this.id,
    this.schoolID,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profilePicture,
    required this.gender,
    this.password,
    required this.contact,
    required this.address,
    required this.role,
    required this.professor,
    required this.hkType,
    required this.status,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      schoolID: map['school_id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'] ?? '',
      profilePicture: map['profile_picture'] ?? '',
      gender: map['gender'] ?? '',
      password: map['password'] ?? '',
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? '',
      professor: map['professor'] ?? '',
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
      'profile_picture': profilePicture,
      'gender': gender,
      'password': password,
      'contact': contact,
      'address': address,
      'role': role,
      'professor': professor,
      'hk_type': hkType,
      'status': status,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, schoolID: $schoolID, email: $email, firstName: $firstName, middleName: $middleName, lastName: $lastName, role: $role, professor: $professor, status: $status)';
  }
}
