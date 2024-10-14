import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
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
  NotificationCreateMessageWidgetState createState() =>
      NotificationCreateMessageWidgetState();
}

class NotificationCreateMessageWidgetState
    extends State<NotificationCreateMessageWidget> {
  final globalRepository = GlobalRepositoryImpl();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  List<String?> selectedReceivers = [];
  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  void _fetchAllUsers() {
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NotificationsErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is NotificationsLoadedSuccessState) {
          usersList = state.users;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  _buildTextField('Title', titleController),
                  _buildTextField('Message', messageController),
                  _buildReceiverList(),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          );
        }

        return Container();
      },
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

  Widget _buildReceiverList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: usersList.map((user) {
          return CheckboxListTile(
            title: Text("${user.firstName} ${user.lastName}"),
            value: selectedReceivers.contains(user.schoolID),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedReceivers.add(user.schoolID);
                } else {
                  selectedReceivers.remove(user.schoolID);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
