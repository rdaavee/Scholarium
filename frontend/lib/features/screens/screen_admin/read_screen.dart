import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/user_form_screen.dart';
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
    adminBloc = AdminBloc(adminRepository);
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: adminBloc,
                  child: const UserFormScreen(),
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add_circle,
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
