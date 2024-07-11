import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnarchiveUserScreen extends StatelessWidget {
  final String userId;

  UnarchiveUserScreen({required this.userId});

  Future<void> unarchiveUser(BuildContext context) async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/users/$userId/unarchive');
      var response = await http.post(url);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to unarchive user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error unarchiving user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unarchive User | HRMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Are you sure you want to unarchive this user?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => unarchiveUser(context),
              child: Text('Unarchive User'),
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
