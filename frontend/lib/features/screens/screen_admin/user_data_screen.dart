import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/user_form_modal.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/role_dropdown.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/status_dropdown.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/user_data_table.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  UserDataScreenState createState() => UserDataScreenState();
}

class UserDataScreenState extends State<UserDataScreen> {
  String? selectedRole = 'All Users';
  String statusFilter = 'Any';
  late AdminBloc adminBloc;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    adminBloc = AdminBloc(adminRepository, globalRepository);
    adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminBloc>.value(
      value: adminBloc,
      child: Scaffold(
        appBar: const AppBarWidget(
          title: "User List",
          isBackButton: false,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPalette.primary.withOpacity(0.6),
          onPressed: () async {
            // Await the result from the dialog
            final bool? isCompleted = await showDialog<bool>(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SizedBox(
                    width:
                        double.infinity, // Adjusts to the width of the screen
                    height: MediaQuery.of(context).size.height *
                        .93, // 80% of screen height
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            'Create User',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.primary,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: BlocProvider.value(
                              value: adminBloc,
                              child: UserFormWidget(
                                filteredUsers: [], index: 0, isRole: "Student",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );

            // Handle the result
            if (isCompleted == true) {
              adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
            } else {
              print('User creation failed or was canceled.');
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RoleDropdown(
                      selectedRole: selectedRole,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                        adminBloc
                            .add(FetchUsersEvent(selectedRole, statusFilter));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatusDropdown(
                      statusFilter: statusFilter,
                      onChanged: (newValue) {
                        setState(() {
                          statusFilter = newValue!;
                        });
                        adminBloc
                            .add(FetchUsersEvent(selectedRole, statusFilter));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state is AdminLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminListScreenSuccessState) {
                    List<UserModel> allUsers = state.filteredUsers;
                    List<UserModel> filteredUsers = allUsers.where((user) {
                      bool matchesRole = (selectedRole == null ||
                          selectedRole == 'All Users' ||
                          user.role == selectedRole);
                      bool matchesStatus = (statusFilter == 'Any' ||
                          user.status == statusFilter);
                      return matchesRole && matchesStatus;
                    }).toList();

                    return UserDataTable(
                      filteredUsers: filteredUsers,
                      adminBloc: adminBloc,
                    );
                  } else if (state is AdminErrorState) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No users found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
