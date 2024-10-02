import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  CreateAnnouncementScreenState createState() =>
      CreateAnnouncementScreenState();
}

class CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
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
        appBar: const AppBarWidget(
            title: "Create Announcement", isBackButton: false),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTextField('Title', titleController),
              _buildTextField('Body', bodyController),
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
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final newAnnouncement = AnnouncementModel(
            title: titleController.text.toString(),
            body: bodyController.text.toString());

        context.read<AdminBloc>().add(CreateAnnouncementEvent(newAnnouncement));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement created successfully!')),
        );
      },
      child: const Text('Submit'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
    );
  }
}
