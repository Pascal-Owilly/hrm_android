import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  UserDetailScreen({required this.userId});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard | JBL'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Image.network(user['thumb'] ?? 'https://example.com/default_profile.png'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user['first_name']} ${user['last_name']}\'s Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Divider(),
                            Text('Username: ${user['username']}'),
                            Text('Email: ${user['email']}'),
                            Text('Phone Number: ${user['phone_number']}'),
                            Text('Address: ${user['address']}'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('More', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Divider(),
                            Text('Clock-in privileges: ${user['clockin_privileges']}'),
                            Text('Emergency Contact: ${user['emergency_contact']}'),
                            Text('Gender: ${user['gender']}'),
                            Text('Department: ${user['department']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            ),
    );
  }
}
