import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_message/message_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isSearching = false; // Track search field visibility

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final fetchedUsers = await messageService
          .fetchAllUsers(); // Ensure this returns List<UserModel>

      setState(() {
        _users.clear();
        _users.addAll(fetchedUsers);
        _filteredUsers = _users;
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
        backgroundColor: ColorPalette.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorPalette.accentWhite,
            size: 13.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: _isSearching
            ? TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: ColorPalette.accentWhite, fontSize: 13),
                ),
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontSize: 13,
                ),
              )
            : const Text(
                'Messages',
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  letterSpacing: 0.5,
                  fontSize: 15,
                ),
              ),
        actions: [
          IconButton(
            iconSize: 20,
            icon: Icon(
              _isSearching ? CupertinoIcons.xmark : CupertinoIcons.search,
              color: ColorPalette.accentWhite,
            ),
            onPressed: () {
              setState(
                () {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _filteredUsers = _users;
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(
                    child: Text(
                      'No users found.',
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return GestureDetector(
                        onTap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final schoolId =
                              prefs.getString("schoolID").toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessageScreen(
                                senderId: schoolId,
                                receiverId: user.schoolID.toString(),
                                receiverName: user.firstName.toString(),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            '${user.firstName} ${user.middleName} ${user.lastName}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            user.email.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[500]),
                          ),
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
