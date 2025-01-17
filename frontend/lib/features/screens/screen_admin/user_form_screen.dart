import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/custom_dropdown.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/custom_textfield.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/submit_button.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';

class UserFormScreen extends StatefulWidget {
  final String? schoolId;
  final int index;
  final String isRole;
  final List<UserModel> filteredUsers;

  const UserFormScreen({
    super.key,
    this.schoolId,
    required this.index,
    required this.filteredUsers,
    required this.isRole,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final TextEditingController schoolIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  late AdminBloc _adminBloc;
  final adminRepositoryImpl = AdminRepositoryImpl();
  final List<Map<String, String>> professors = [];
  String? selectedHkType;
  String? selectedRole;
  String? accountStatus;
  String? selectedGender;
  String? selectedProfessor;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    _adminBloc = AdminBloc(adminRepository, globalRepository);
    _initialize();
    if (widget.filteredUsers.isNotEmpty) {
      final user = widget.filteredUsers[widget.index];
      schoolIdController.text = user.schoolID.toString();
      firstNameController.text = user.firstName.toString();
      middleNameController.text = user.middleName.toString();
      lastNameController.text = user.lastName.toString();
      emailController.text = user.email.toString();
      passwordController.text = user.password.toString();
      selectedGender = user.gender?.toString();
      addressController.text = user.address.toString();
      contactController.text = user.contact.toString();
      selectedRole = user.role?.toString();
      accountStatus = user.status?.toString();
      selectedHkType = user.hkType?.toString() ?? 'Select HK Type';
      selectedProfessor = user.profId ?? 'Select Professor';
    } else {
      selectedHkType = 'Select HK Type';
      selectedRole = 'Select User Role';
      accountStatus = 'Select Status';
      selectedProfessor = 'Select Professor';
      selectedGender = 'Select Gender';
    }
  }

  Future<void> _initialize() async {
    final users = await adminRepositoryImpl.fetchAllUsers();
    setState(() {
      professors.clear();
      professors.add({
        'school_id': "",
        'name': "Select Professor",
      });
      for (var user in users) {
        if (user.role == 'Professor') {
          professors.add({
            'school_id': user.schoolID.toString(),
            'name': "${user.firstName} ${user.lastName}",
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      bloc: _adminBloc,
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBarWidget(title: 'User Form Screen', isBackButton: true),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/create-user-img.png',
                    height: 240.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'First Name',
                        controller: firstNameController,
                        allowNumbers: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Middle Name',
                        controller: middleNameController,
                        allowNumbers: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Last Name',
                        controller: lastNameController,
                        allowNumbers: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Email',
                  controller: emailController,
                  isEmail: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'School ID',
                        controller: schoolIdController,
                        isReadOnly: widget.schoolId != null &&
                            widget.schoolId!.isNotEmpty,
                        isSchoolId: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Password',
                        controller: passwordController,
                        isPassword: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Address',
                        controller: addressController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Contact No.',
                        controller: contactController,
                        isPhone: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (widget.isRole == 'Student')
                      Expanded(
                        child: CustomDropdown(
                          labelText: 'HK Type',
                          options: [
                            'Select HK Type',
                            'HK 25',
                            'HK 50',
                            'HK 75'
                          ],
                          selectedValue: selectedHkType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedHkType = newValue;
                            });
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomDropdown(
                        labelText: 'Role',
                        options: [
                          'Select User Role',
                          'Student',
                          'Professor',
                          'Admin'
                        ],
                        selectedValue: selectedRole,
                        onChanged: (roleValue) {
                          setState(() {
                            selectedRole = roleValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        labelText: 'Gender',
                        options: ['Select Gender', 'Male', 'Female'],
                        selectedValue: selectedGender,
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomDropdown(
                        labelText: 'Account Status',
                        options: ['Select Status', 'Active', 'Inactive'],
                        selectedValue: accountStatus,
                        onChanged: (statusValue) {
                          setState(() {
                            accountStatus = statusValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (widget.isRole == 'Student')
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedProfessor != null &&
                            selectedProfessor != 'Select Professor'
                        ? selectedProfessor
                        : null,
                    hint: const Text(
                      "Select Professor",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    items: professors.map((professor) {
                      return DropdownMenuItem<String>(
                        value: professor['school_id'],
                        child: Text(
                          professor['name']!,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProfessor = value ?? 'Select Professor';
                      });
                    },
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    iconEnabledColor: Colors.black,
                    iconSize: 24,
                  ),
                const SizedBox(height: 20),
                SubmitButton(
                  buttonText: 'Submit',
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    // Check required fields and apply validations directly
    if (schoolIdController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        contactController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        accountStatus == "Select Account Status" ||
        selectedGender == "Select Gender" ||
        (emailController.text.contains('@gmail.com') &&
            !emailController.text.endsWith('up@phinmaed.com')) ||
        (!RegExp(r'^\d+$').hasMatch(contactController.text) ||
            contactController.text.length != 11) ||
        (passwordController.text.length < 8 ||
            !RegExp(r'[A-Z]').hasMatch(passwordController.text) ||
            !RegExp(r'[a-z]').hasMatch(passwordController.text) ||
            !RegExp(r'[0-9]').hasMatch(passwordController.text) ||
            !RegExp(r'[!@#%^&*(),.?":{}|<>]')
                .hasMatch(passwordController.text)) ||
        (selectedRole == "Student" && selectedHkType == "Select HK Type")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill in all required fields and validate your inputs.')),
      );
      return;
    }

    final newUser = UserModel(
      schoolID: schoolIdController.text,
      email: emailController.text,
      firstName: firstNameController.text,
      middleName: middleNameController.text,
      lastName: lastNameController.text,
      profilePicture: '',
      gender: selectedGender,
      password: passwordController.text,
      contact: contactController.text,
      address: addressController.text,
      role: selectedRole,
      professor: selectedProfessor,
      profId: selectedProfessor,
      hkType: selectedRole == "Student" ? selectedHkType : '',
      status: accountStatus,
    );

    try {
      Navigator.pop(context, newUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating or updating user: $e')),
      );
    }
  }
}
