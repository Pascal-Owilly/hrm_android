import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteUserScreen extends StatelessWidget {
  final String userId;

  DeleteUserScreen({required this.userId});

  Future<void> deleteUser(BuildContext context) async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/users/$userId');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete User | HRMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Are you sure you want to delete this user?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => deleteUser(context),
              child: Text('Delete User'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
