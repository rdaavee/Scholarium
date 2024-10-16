import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';

class DeleteConfirmationDialog {
  static Future<bool> show(BuildContext context, AdminBloc adminBloc, String schoolId) {
    print('Showing delete confirmation dialog...');
    // Use a Completer to manage the Future result
    Completer<bool> completer = Completer<bool>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Confirm Deletion',
      desc: 'Are you sure you want to delete this user?',
      btnCancel: ElevatedButton(
        onPressed: () {
          // Return false on cancel
          completer.complete(false);
          Navigator.of(context).pop(); 
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.white),
        ),
      ),
      btnOk: ElevatedButton(
        onPressed: () {
          adminBloc.add(DeleteUserEvent(schoolId)); 
          completer.complete(true);
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: Text(
          'Confirm',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ).show();

    return completer.future;
  }
}
