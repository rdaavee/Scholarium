import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/screens/screen_admin/create_screen.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/features/widgets/custom_floating_button.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRoleDropdown(),
              _buildStatusRadioButtons(),
              Expanded(
                child: _buildUserListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    List<String> roles = [
      'All Users',
      'Student',
      'Professor',
      'Admin',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Select Role',
          border: OutlineInputBorder(),
        ),
        value: selectedRole,
        items: roles.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedRole = newValue;
          });
          adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
        },
        hint: const Text('Select Role'),
      ),
    );
  }

  Widget _buildStatusRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Any',
              groupValue: statusFilter,
              onChanged: (value) {
                setState(() {
                  statusFilter = value!;
                });
                adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
              },
            ),
            const Text('Any'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Active',
              groupValue: statusFilter,
              onChanged: (value) {
                setState(() {
                  statusFilter = value!;
                });
                adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
              },
            ),
            const Text('Active'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Inactive',
              groupValue: statusFilter,
              onChanged: (value) {
                setState(() {
                  statusFilter = value!;
                });
                adminBloc.add(FetchUsersEvent(selectedRole, statusFilter));
              },
            ),
            const Text('Inactive'),
          ],
        ),
      ],
    );
  }

  Widget _buildUserListView() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminListScreenSuccessState) {
          List<UserModel> allUsers = state.filteredUsers;
          List<UserModel> filteredUsers = allUsers.where((user) {
            bool matchesRole = (selectedRole == null ||
                selectedRole == 'All Users' ||
                user.role == selectedRole);
            bool matchesStatus =
                (statusFilter == 'Any' || user.status == statusFilter);
            return matchesRole && matchesStatus;
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              UserModel user = filteredUsers[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text('Role: ${user.role}'),
                trailing: Text('Status: ${user.status}'),
              );
            },
          );
        } else if (state is AdminErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No users found.'));
      },
    );
  }
}
