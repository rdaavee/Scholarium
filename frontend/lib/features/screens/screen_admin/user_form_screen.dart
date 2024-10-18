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
  final TextEditingController professorController = TextEditingController();
  late AdminBloc _adminBloc;
  String? selectedHkType;
  String? selectedRole;
  String? accountStatus;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    _adminBloc = AdminBloc(adminRepository, globalRepository);
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
      professorController.text = user.professor?.toString() ?? '';
      selectedRole = user.role?.toString();
      accountStatus = user.status?.toString();
      selectedHkType = user.hkType?.toString() ?? 'Select HK Type';
    } else {
      selectedHkType = 'Select HK Type';
      selectedRole = 'Select User Role';
      accountStatus = 'Select Account Status';
      selectedGender = 'Select Gender';
    }
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
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'First Name',
                        controller: firstNameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Middle Name',
                        controller: middleNameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Last Name',
                        controller: lastNameController,
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
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Password',
                        controller: passwordController,
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
                        options: [
                          'Select Account Status',
                          'Active',
                          'Inactive'
                        ],
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
                  CustomTextField(
                    labelText: 'Professor',
                    controller: professorController,
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
    if (schoolIdController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        accountStatus == "Select Account Status" ||
        selectedGender == "Select Gender") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    if (selectedRole == "Student" && selectedHkType == "Select HK Type") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please indicate HK type.')),
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
      professor: professorController.text,
      hkType: selectedRole == "Student" ? selectedHkType : '',
      status: accountStatus,
    );

    if (widget.schoolId == null) {
      _adminBloc.add(CreateUserEvent(newUser));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      _adminBloc.add(UpdateUserEvent(widget.schoolId!, newUser));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
      Navigator.pop(context, true);
    }
  }
}
