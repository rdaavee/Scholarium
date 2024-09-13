class UserModel {
  final int? id;
  final String schoolID;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String profilePicture;
  final String gender;
  final String contact;
  final String address;
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
    required this.profilePicture,
    required this.role,
    required this.gender,
    required this.contact,
    required this.address,
    required this.hkType,
    required this.status,
    required this.token,
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
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
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
      'profile_picture': profilePicture,
      'gender': gender,
      'contact': contact,
      'address': address,
      'role': role,
      'hk_type': hkType,
      'status': status,
      'token': token,
    };
  }
}
