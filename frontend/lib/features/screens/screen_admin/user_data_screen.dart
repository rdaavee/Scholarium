import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/user_form_screen.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/role_dropdown.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/status_dropdown.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/user_data_table.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';

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
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
      context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
    });
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
            final UserModel newUser = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: adminBloc,
                  child: const UserFormScreen(
                    filteredUsers: [],
                    index: 0,
                    isRole: "Student",
                  ),
                ),
              ),
            );
            adminBloc.add(CreateUserEvent(
              newUser,
            ));
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () => _initialize(),
                child: BlocConsumer<AdminBloc, AdminState>(
                  bloc: adminBloc,
                  listener: (context, state) {
                    if (state is AdminCreateUserSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is AdminCreateUserErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AdminLoadingState) {
                      return LoadingCircular();
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
                        onUpdated: () {
                          adminBloc
                              .add(FetchUsersEvent(selectedRole, statusFilter));
                        },
                      );
                    } else if (state is AdminErrorState) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No users found.'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
