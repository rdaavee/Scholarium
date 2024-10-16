import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/delete_confirmation_dialog.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/profile_modal_bottom_sheet.dart';

class UserDataTable extends StatelessWidget {
  final List<UserModel> filteredUsers;
  final AdminBloc adminBloc;

  const UserDataTable({
    super.key,
    required this.filteredUsers,
    required this.adminBloc,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 17,
        // ignore: deprecated_member_use
        dataRowHeight: 70,
        dataTextStyle: const TextStyle(fontSize: 10),
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              '',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Role',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Actions',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: filteredUsers
            .asMap()
            .map((index, user) {
              return MapEntry(
                index,
                DataRow(
                  cells: [
                    DataCell(
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: user.profilePicture != null
                            ? NetworkImage(user.profilePicture!)
                            : null,
                      ),
                    ),
                    DataCell(
                      Text('${user.firstName} ${user.lastName}'),
                    ),
                    DataCell(
                      Text(user.role.toString()),
                    ),
                    DataCell(
                      Text(
                        user.status.toString(),
                        style: TextStyle(
                          color: user.status == 'Active'
                              ? Colors.green
                              : Colors.red,
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
                                if (result == 'Profile') {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    builder: (BuildContext context) {
                                      return ProfileModalBottomSheet(
                                        name:
                                            '${user.firstName} ${user.lastName}',
                                        schoolId: user.schoolID.toString(),
                                        role: user.role.toString(),
                                        isActive: user.status == 'Active',
                                      );
                                    },
                                  );
                                } else if (result == 'Edit') {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return Dialog(
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(20.0),
                                  //       ),
                                  //       child: SizedBox(
                                  //         width: double
                                  //             .infinity, // Adjusts to the width of the screen
                                  //         height: MediaQuery.of(context)
                                  //                 .size
                                  //                 .height *
                                  //             .93, // 80% of screen height
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(10.0),
                                  //           child: Column(
                                  //             children: [
                                  //               const Text(
                                  //                 'Edit User',
                                  //                 style: TextStyle(
                                  //                   fontSize: 20,
                                  //                   fontWeight: FontWeight.bold,
                                  //                   color: ColorPalette.primary,
                                  //                 ),
                                  //               ),
                                  //               const SizedBox(height: 15),
                                  //               Expanded(
                                  //                 child: BlocProvider.value(
                                  //                   value: adminBloc,
                                  //                   child: UserFormWidget(
                                  //                     schoolId: user.schoolID
                                  //                         .toString(),
                                  //                     index: index,
                                  //                     filteredUsers:
                                  //                         filteredUsers,
                                  //                     isRole:
                                  //                         user.role.toString(),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // );
                                } else if (result == 'Delete') {
                                  DeleteConfirmationDialog.show(
                                    context,
                                    adminBloc,
                                    user.schoolID.toString(),
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Profile',
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }
}
