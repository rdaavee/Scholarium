import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/config/constants/colors.dart';

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
  String? selectedHkType;
  String? selectedRole;
  String? accountStatus;
  String? selectedGender;

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: ColorPalette.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField('School ID', schoolIdController),
            _buildTextField('First Name', firstNameController),
            _buildTextField('Middle Name', middleNameController),
            _buildTextField('Last Name', lastNameController),
            _buildEmailField('Email', emailController),
            _buildTextField('Password', passwordController),
            _buildDropdown(
              'Gender',
              ['Select Gender', 'Male', 'Female'],
              selectedGender,
              (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            _buildTextField('Address', addressController),
            _buildContactField('Contact No.', contactController),
            if (widget.isRole == 'Student')
              _buildDropdown(
                'HK Type',
                ['Select HK Type', 'HK 25', 'HK 50', 'HK 75'],
                selectedHkType,
                (newValue) {
                  setState(() {
                    selectedHkType = newValue;
                  });
                },
              ),
            if (widget.isRole == 'Student')
              _buildTextField('Professor', professorController),
            _buildDropdown(
              'Role',
              ['Select User Role', 'Student', 'Professor', 'Admin'],
              selectedRole,
              (roleValue) {
                setState(() {
                  selectedRole = roleValue;
                });
              },
            ),
            _buildDropdown(
              'Account Status',
              ['Select Account Status', 'Active', 'Inactive'],
              accountStatus,
              (statusValue) {
                setState(() {
                  accountStatus = statusValue;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        style: const TextStyle(
          fontSize: 13,
        ),
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildEmailField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        style: const TextStyle(
          fontSize: 13,
        ),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildContactField(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        style: const TextStyle(
          fontSize: 13,
        ),
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String labelText, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        value: selectedValue != null && selectedValue.isNotEmpty
            ? selectedValue
            : null,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(options[0]),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (schoolIdController.text.isEmpty ||
            firstNameController.text.isEmpty ||
            emailController.text.isEmpty ||
            accountStatus.toString() == "Select Account Status" ||
            selectedRole.toString() == "Select User Role" ||
            selectedHkType.toString() == "Select HK Type" ||
            selectedGender.toString() == "Select Gender") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please fill in all required fields.')),
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
          hkType: selectedHkType ?? '',
          status: accountStatus,
        );

        if (widget.schoolId == null) {
          context.read<AdminBloc>().add(CreateUserEvent(newUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully!')),
          );
          Navigator.pop(context, true);
        } else {
          context
              .read<AdminBloc>()
              .add(UpdateUserEvent(widget.schoolId!, newUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.btnColor,
        minimumSize: const Size(360, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
