import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class UserFormWidget extends StatefulWidget {
  final String? schoolId;
  const UserFormWidget({super.key, this.schoolId});

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
  String? selectedHkType;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc(AdminRepositoryImpl()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (widget.schoolId == null)
              _buildTextField('School ID', schoolIdController),
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
            SizedBox(
              height: 10,
            ),
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
        style: TextStyle(
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
        style: TextStyle(
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
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
        ),
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
          context
              .read<AdminBloc>()
              .add(UpdateUserEvent(widget.schoolId!, newUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.btnColor,
        minimumSize: const Size(287, 55),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          color: ColorPalette.accentBlack,
          fontFamily: 'Manrope',
          fontSize: 12,
        ),
      ),
    );
  }
}
