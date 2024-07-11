import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin/attendance.dart';
import 'screens/employees/employee_create.dart';
import 'screens/employees/employee_bulk_upload.dart';
import 'screens/clients/client_create.dart';
import 'screens/clients/client_list.dart';
import 'screens/clients/single_client.dart';
import 'screens/clients/edit_client.dart';
import 'screens/employees/employee_list.dart';
import 'screens/users/users.dart';
import 'screens/users/detail_user.dart';
import 'screens/users/edit_user.dart';
import 'screens/users/archive_user.dart';
import 'screens/users/unarchive_user.dart';
import 'screens/users/delete_user.dart';
import 'screens/users/archived_users.dart';
import 'screens/admin/admin_list.dart';

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
        primaryColor: Color(0xFFFDEB3D),
      ),
      home: HomeScreen(), // Set the initial screen to HomeScreen
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/admin': (context) => AdminDashboardScreen(),
        '/users': (context) => UserListScreen(),
         '/admin_list': (context) => AdminListScreen(),
        '/attendance_admin_view': (context) => AttendanceScreen(),
        '/add_new_employee': (context) => NewEmployeeScreen(),
        '/employee_bulk_upload': (context) => EmployeeBulkUploadScreen(),
        '/create_client': (context) => NewClientScreen(),
        '/list_clients': (context) => ClientListScreen(),
        '/single_client': (context) => ClientInfoScreen(clientId: 'id'),
        '/edit_client': (context) => EditClientScreen(clientId: 'id'),
        '/list_employees': (context) => EmployeeListScreen(),
        '/user_detail': (context) => UserDetailScreen(userId: 'id'),
        '/user_edit': (context) => EditUserScreen(userId: 'id'),
        '/user_archive': (context) => ArchiveUserScreen(userId: 'id'),
        '/user_unarchive': (context) => UnarchiveUserScreen(userId: 'id'),
        '/user_delete': (context) => DeleteUserScreen(userId: 'id'),
        '/archived_users': (context) => ArchivedUsersScreen(),
      },
    );
  }
}

