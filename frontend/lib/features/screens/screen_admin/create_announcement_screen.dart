import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';

class AnnouncementFormScreen extends StatefulWidget {
  final String? announcementId;
  final AnnouncementModel? existingAnnouncement;

  const AnnouncementFormScreen(
      {super.key,
      this.announcementId,
      this.existingAnnouncement,
      required String role});

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
          title: widget.announcementId == null
              ? "Create Announcement"
              : "Update Announcement",
          isBackButton: true,
        ),
        body: Stack(
          children: [
            Container(
              color: ColorPalette.primary.withOpacity(0.6),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F3F4),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          _buildTextField('Title', titleController),
                          _buildTextField('Body', bodyController),
                          _buildSubmitButton(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
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
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Manrope',
            fontSize: 13,
          ),
          floatingLabelStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ColorPalette.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: ColorPalette.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          hoverColor: ColorPalette.primary,
        ),
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Manrope',
          fontSize: 13,
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
          time:
              DateTime.now().toIso8601String().split('T').last.split('.').first,
        );

        if (widget.announcementId == null) {
          context.read<AdminBloc>().add(CreateAnnouncementEvent(announcement));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Announcement created successfully!')),
          );
        } else {
          // Updating an existing announcement
          context.read<AdminBloc>().add(
              UpdateAnnouncementEvent(widget.announcementId!, announcement));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Announcement updated successfully!')),
          );
        }
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        minimumSize: const Size(360, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
      child: Text(
        widget.announcementId == null ? 'Create' : 'Update',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Manrope',
          fontSize: 11.5,
        ),
      ),
    );
  }
}
