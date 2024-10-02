import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';

class AnnouncementFormScreen extends StatefulWidget {
  final String? announcementId; 
  final AnnouncementModel? existingAnnouncement; 

  const AnnouncementFormScreen({super.key, this.announcementId, this.existingAnnouncement});

  @override
  AnnouncementFormScreenState createState() => AnnouncementFormScreenState();
}

class AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String? selectedHkType;

  @override
  void initState() {
    super.initState();
    if (widget.existingAnnouncement != null) {
      titleController.text = widget.existingAnnouncement!.title.toString();
      bodyController.text = widget.existingAnnouncement!.body.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(AdminRepositoryImpl()),
      child: Scaffold(
        appBar: AppBarWidget(
          title: widget.announcementId == null ? "Create Announcement" : "Update Announcement",
          isBackButton: true,
        ),
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
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final announcement = AnnouncementModel(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
          date: DateTime.now().toIso8601String().split('T').first, 
          time: DateTime.now().toIso8601String().split('T').last.split('.').first,
        );

        if (widget.announcementId == null) {
          context.read<AdminBloc>().add(CreateAnnouncementEvent(announcement));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Announcement created successfully!')),
          );
        } else {
          // Updating an existing announcement
          context.read<AdminBloc>().add(UpdateAnnouncementEvent(widget.announcementId!, announcement));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Announcement updated successfully!')),
          );
        }
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(widget.announcementId == null ? 'Create' : 'Update'),
    );
  }
}
