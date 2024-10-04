import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/features/screens/screen_message/message_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure you have this package

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  SearchUserScreenState createState() => SearchUserScreenState();
}

class SearchUserScreenState extends State<SearchUserScreen> {
  final AdminRepositoryImpl messageService = AdminRepositoryImpl();
  final List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    
    try {
      // Fetch users from the repository
      final fetchedUsers = await messageService
          .fetchAllUsers(); // Ensure this returns List<UserModel>

      // Assign fetched users to _users and _filteredUsers
      setState(() {
        _users.clear(); // Clear the previous list if necessary
        _users.addAll(fetchedUsers);
        _filteredUsers = _users; // Initialize filtered users with all users
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filteredUsers = _users.where((user) {
        final fullName = '${user.firstName} ${user.middleName} ${user.lastName}'
            .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return GestureDetector(
                        onTap: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final schoolId = prefs.getString("schoolID").toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                      senderId: schoolId,
                                      receiverId: user.schoolID.toString())));
                        },
                        child: ListTile(
                          title: Text(
                              '${user.firstName} ${user.middleName} ${user.lastName}'),
                          subtitle: Text(user.email),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
