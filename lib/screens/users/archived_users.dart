import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jbl/screens/users/detail_user.dart'; 

class ArchivedUsersScreen extends StatefulWidget {
  @override
  _ArchivedUsersScreenState createState() => _ArchivedUsersScreenState();
}

class _ArchivedUsersScreenState extends State<ArchivedUsersScreen> {
  late List<dynamic> users;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArchivedUsers();
  }

  Future<void> fetchArchivedUsers() async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/users/archived/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch archived users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching archived users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Users | JBL'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  title: Text('${user['first_name']} ${user['last_name']}'),
                  subtitle: Text(user['email']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(userId: user['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
