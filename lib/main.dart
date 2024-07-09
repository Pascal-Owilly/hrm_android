import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JBL App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Set the initial screen to HomeScreen
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin': (context) => AdminDashboardScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

