import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/users'); // Replace with your API endpoint
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          users = data['users'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User List',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to archived users screen
                        },
                        icon: Icon(Icons.archive, color: Colors.red),
                        label: Text('Archived Users'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Use backgroundColor instead of primary
                          foregroundColor: Colors.blue, // Use foregroundColor instead of onPrimary
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Profile')),
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('First Name')),
                          DataColumn(label: Text('Last Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: users.map((user) {
                          return DataRow(cells: [
                            DataCell(Image.network(user['thumb'] ?? 'https://example.com/default_profile.png', width: 100)),
                            DataCell(Text(user['username'])),
                            DataCell(Text(user['first_name'])),
                            DataCell(Text(user['last_name'])),
                            DataCell(Text(user['email'])),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility, color: Colors.green),
                                  onPressed: () {
                                    // View user details
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Edit user
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.archive, color: Colors.red),
                                  onPressed: () {
                                    // Archive user
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Delete user
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

