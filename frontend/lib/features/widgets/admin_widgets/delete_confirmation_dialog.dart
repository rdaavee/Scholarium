import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';

class DeleteConfirmationDialog {
  static void show(BuildContext context, AdminBloc adminBloc, String schoolId) {
    print('Showing delete confirmation dialog...');
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Confirm Deletion',
      desc: 'Are you sure you want to delete this user?',
      btnCancel: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Text(
          'Cancel',
          style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
        ),
      ),
      btnOk: ElevatedButton(
        onPressed: () {
          adminBloc.add(DeleteUserEvent(schoolId));
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: Text(
          'Confirm',
          style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
        ),
      ),
    ).show();
  }
}
