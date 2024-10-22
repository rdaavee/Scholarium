import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/socket/socket_service.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class NotificationCreateMessageWidget extends StatefulWidget {
  final String? schoolId;
  final int index;
  final String isRole;

  const NotificationCreateMessageWidget({
    super.key,
    this.schoolId,
    required this.index,
    required this.isRole,
  });

  @override
  NotificationMessageWidgetState createState() =>
      NotificationMessageWidgetState();
}

class NotificationMessageWidgetState
    extends State<NotificationCreateMessageWidget> {
  final TextEditingController senderController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final globalRepository = GlobalRepositoryImpl();
  final studentRepositoty = StudentRepositoryImpl();
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await globalRepository.fetchUserProfile();
      senderController.text = user.schoolID.toString();
      senderNameController.text = user.firstName.toString();
      roleController.text = user.role.toString();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationsBloc(
              globalRepository, studentRepositoty, socketService),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _buildTextField('Sender', senderController),
              _buildTextField('Sender Name', senderNameController),
              _buildTextField('Receiver', receiverController),
              _buildTextField('Receiver Name', receiverNameController),
              _buildTextField('Role', roleController),
              _buildTextField('Title', titleController),
              _buildTextField('Message', messageController),
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
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (receiverController.text.isEmpty || titleController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please fill in all required fields.')),
          );
          return;
        }

        final notifications = NotificationsModel(
          sender: senderController.text,
          senderName: senderNameController.text,
          receiver: receiverController.text,
          receiverName: receiverNameController.text,
          role: roleController.text,
          title: titleController.text,
          message: messageController.text,
        );
        try {
          await globalRepository.createNotification(
              notification: notifications);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification created successfully!')),
          );
          Navigator.pop(context, true);
        } catch (error) {
          print(error);
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
