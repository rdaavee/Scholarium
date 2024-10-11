import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class UserFormWidget extends StatefulWidget {
  final String? schoolId;
  final int index;
  final String isRole;
  final List<UserModel> filteredUsers;
  const UserFormWidget({
    super.key,
    this.schoolId,
    required this.index,
    required this.filteredUsers,
    required this.isRole,
  });

  @override
  UserFormWidgetState createState() => UserFormWidgetState();
}

class UserFormWidgetState extends State<UserFormWidget> {
  final TextEditingController schoolIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController professorController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  String isActive = "";
  String? selectedHkType;
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();

    if (widget.filteredUsers.isNotEmpty) {
      schoolIdController.text =
          widget.filteredUsers[widget.index].schoolID.toString();
      firstNameController.text = widget.filteredUsers[widget.index].firstName;
      middleNameController.text = widget.filteredUsers[widget.index].middleName;
      lastNameController.text = widget.filteredUsers[widget.index].lastName;
      emailController.text = widget.filteredUsers[widget.index].email;
      passwordController.text =
          widget.filteredUsers[widget.index].password.toString();
      genderController.text = widget.filteredUsers[widget.index].gender;
      addressController.text = widget.filteredUsers[widget.index].address;
      contactController.text = widget.filteredUsers[widget.index].contact;
      professorController.text = widget.filteredUsers[widget.index].professor;
      roleController.text = widget.filteredUsers[widget.index].role;
      isActive = widget.filteredUsers[widget.index].status;
      _isSwitched = isActive.toLowerCase() == 'active';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AdminBloc(AdminRepositoryImpl(), GlobalRepositoryImpl()),
        ),
      ],
      child: Scaffold(
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
              _buildTextField('Gender', genderController),
              _buildTextField('Address', addressController),
              _buildContactField('Contact No.', contactController),
              if (widget.isRole == 'Student') _buildDropdown('HK Type'),
              if (widget.isRole == 'Student')
                _buildTextField('Professor', professorController),
              _buildTextField('Role', roleController),
              _buildSwitch('Account Status'),
              const SizedBox(height: 10),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        style: const TextStyle(
          fontFamily: 'Manrope',
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
          fontFamily: 'Manrope',
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
          fontFamily: 'Manrope',
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

  Widget _buildSwitch(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(labelText),
          Spacer(),
          Switch(
            value: _isSwitched,
            onChanged: (bool value) {
              setState(() {
                _isSwitched = value;
                isActive = value ? 'Active' : 'Inactive';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String labelText) {
    List<String> hkTypes = ['', 'HK 25', 'HK 50', 'HK 75'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        value: selectedHkType,
        items: hkTypes.map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedHkType = newValue;
          });
        },
        hint: const Text('Select HK Type'),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (schoolIdController.text.isEmpty ||
            firstNameController.text.isEmpty ||
            emailController.text.isEmpty) {
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
          gender: genderController.text,
          password: passwordController.text,
          contact: contactController.text,
          address: addressController.text,
          role: roleController.text,
          professor: professorController.text,
          hkType: selectedHkType ?? '',
          status: isActive,
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
          fontFamily: 'Manrope',
          fontSize: 12,
        ),
      ),
    );
  }
}
