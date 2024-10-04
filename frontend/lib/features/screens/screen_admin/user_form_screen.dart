import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';

class UserFormScreen extends StatefulWidget {
  final String? schoolId; 
  const UserFormScreen({super.key, this.schoolId});

  @override
  UserFormScreenState createState() => UserFormScreenState();
}

class UserFormScreenState extends State<UserFormScreen> {
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
  String? selectedHkType;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc(AdminRepositoryImpl()),
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(
          title: widget.schoolId == null
              ? "Create Student or Professor"
              : "Update Student or Professor",
          isBackButton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if (widget.schoolId == null) _buildTextField('School ID', schoolIdController),
              _buildTextField('First Name', firstNameController),
              _buildTextField('Middle Name', middleNameController),
              _buildTextField('Last Name', lastNameController),
              _buildEmailField('Email', emailController),
              _buildTextField('Password', passwordController),
              _buildTextField('Gender', genderController),
              _buildTextField('Address', addressController),
              _buildContactField('Contact No.', contactController),
              _buildDropdown('HK Type'),
              _buildTextField('Professor', professorController),
              _buildTextField('Role', roleController),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String labelText) {
    List<String> hkTypes = ['HK 25', 'HK 50', 'HK 75'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          status: 'Active',
        );

        if (widget.schoolId == null) {
          context.read<AdminBloc>().add(CreateUserEvent(newUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully!')),
          );
        } else {
          context.read<AdminBloc>().add(UpdateUserEvent(widget.schoolId!, newUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: const Text('Submit'),
    );
  }
}
