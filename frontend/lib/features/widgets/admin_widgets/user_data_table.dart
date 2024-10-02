import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/screens/screen_admin/user_form_screen.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/delete_confirmation_dialog.dart';

class UserDataTable extends StatelessWidget {
  final List<UserModel> filteredUsers;
  final AdminBloc adminBloc;

  const UserDataTable({
    Key? key,
    required this.filteredUsers,
    required this.adminBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        dataTextStyle: TextStyle(fontFamily: 'Manrope', fontSize: 11),
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
              label: Text(
            'Role',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
          DataColumn(
              label: Text(
            'Status',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
          DataColumn(
              label: Text(
            'Actions',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )),
        ],
        rows: filteredUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  '${user.firstName} ${user.lastName}',
                ),
              ),
              DataCell(
                Text(
                  user.role,
                ),
              ),
              DataCell(
                Text(
                  user.status,
                  style: TextStyle(
                    color: user.status == 'Active' ? Colors.green : Colors.red,
                    fontSize: 11,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: adminBloc,
                                  child: UserFormScreen(
                                      schoolId: user.schoolID.toString()),
                                ),
                              ),
                            );
                          } else if (result == 'Delete') {
                            DeleteConfirmationDialog.show(
                                context, adminBloc, user.schoolID.toString());
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
