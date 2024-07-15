import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    String url = 'http://127.0.0.1:8000/api/login/';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Login Response: $jsonResponse'); // Print entire JSON response

      String token = jsonResponse['token']; // Assuming token is here

      // Store token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      // Determine where to navigate based on the user's role
      String role = jsonResponse['role'].toLowerCase();
      switch (role) {
        case 'superuser':
          Navigator.pushNamed(context, '/admin');
          break;
        case 'employee':
          Navigator.pushNamed(context, '/employee/dashboard');
          break;
        case 'account_manager':
          Navigator.pushNamed(context, '/account-manager');
          break;
        case 'human_resource_manager':
          Navigator.pushNamed(context, '/hr-manager');
          break;
        default:
          // Handle other roles or scenarios
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown role. Please contact support.'),
            ),
          );
          break;
      }
    } else {
      // Handle error, show message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to login. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => loginUser(context),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

