import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditUserScreen extends StatefulWidget {
  final String userId;

  EditUserScreen({required this.userId});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late Map<String, dynamic> user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/users/${widget.userId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          user = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> updateUser() async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/users/${widget.userId}');
      var response = await http.put(url, body: jsonEncode(user));

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User | JBL'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: user['first_name'],
                      decoration: InputDecoration(labelText: 'First Name'),
                      onChanged: (value) {
                        user['first_name'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: user['last_name'],
                      decoration: InputDecoration(labelText: 'Last Name'),
                      onChanged: (value) {
                        user['last_name'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: user['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (value) {
                        user['email'] = value;
                      },
                    ),
                    // Add more fields as needed
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updateUser,
                      child: Text('Update User'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
