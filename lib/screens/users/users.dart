import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  bool isLoading = true;
  int expandedIndex = -1; // Initially no item is expanded

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/users/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        setState(() {
          users = data.map((json) => User.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = -1; // Collapse if already expanded
      } else {
        expandedIndex = index; // Expand this item
      }
    });
  }

  void navigateToUserDetail(String userId) {
    Navigator.pushNamed(context, '/user_detail', arguments: userId);
  }

  void navigateToEditUser(String userId) {
    Navigator.pushNamed(context, '/user_edit', arguments: userId);
  }

  void navigateToArchiveUser(String userId) {
    Navigator.pushNamed(context, '/user_archive', arguments: userId);
  }

  void navigateToDeleteUser(String userId) {
    Navigator.pushNamed(context, '/user_delete', arguments: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users | JBL'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return InkWell(
                    onTap: () {
                      navigateToUserDetail(user.id.toString());
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.thumb),
                            ),
                            title: Text(user.username),
                            subtitle: Text('${user.firstName} ${user.lastName}\n${user.email}'),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                toggleExpanded(index); // Toggle expand/collapse for this item
                              },
                            ),
                          ),
                          if (expandedIndex == index)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility, color: Colors.green),
                                  onPressed: () {
                                    navigateToUserDetail(user.id.toString());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    navigateToEditUser(user.id.toString());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.archive, color: Colors.red),
                                  onPressed: () {
                                    navigateToArchiveUser(user.id.toString());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    navigateToDeleteUser(user.id.toString());
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

