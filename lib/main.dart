import 'package:flutter/material.dart';
import 'screens/auth/admin_register.dart';
import 'screens/auth/login.dart';
import 'screens/auth/login.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin/attendance.dart';
import 'screens/employees/dashboard.dart';
import 'screens/employees/employee_create.dart';
import 'screens/employees/employee_bulk_upload.dart';
import 'screens/clients/client_create.dart';
import 'screens/clients/client_list.dart';
import 'screens/clients/single_client.dart';
import 'screens/clients/edit_client.dart';
import 'screens/employees/employee_list.dart';
import 'screens/employees/employee_detail.dart';
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
        
          case '/home':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/admin_register':
            return MaterialPageRoute(builder: (context) => RegisterScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/admin':
            return MaterialPageRoute(builder: (context) => AdminDashboardScreen());
          case '/users':
            return MaterialPageRoute(builder: (context) => UserListScreen());
          case '/admin_list':
            return MaterialPageRoute(builder: (context) => AdminListScreen());
          case '/attendance_admin_view':
            return MaterialPageRoute(builder: (context) => AttendanceScreen());
          case '/add_new_employee':
            return MaterialPageRoute(builder: (context) => NewEmployeeScreen());
          case '/employee_bulk_upload':
            return MaterialPageRoute(builder: (context) => EmployeeBulkUploadScreen());
          case '/create_client':
            return MaterialPageRoute(builder: (context) => NewClientScreen());
          case '/list_clients':
            return MaterialPageRoute(builder: (context) => ClientListScreen());
          case '/single_client':
            // Extract clientId from arguments if needed
            final clientId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => ClientInfoScreen(clientId: clientId ?? ''));
          case '/edit_client':
            // Extract clientId from arguments if needed
            final clientId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => EditClientScreen(clientId: clientId ?? ''));
          case '/employee/dashboard':
      	    return MaterialPageRoute(builder: (context) => EmployeeDashboardScreen());
          case '/list_employees':
            return MaterialPageRoute(builder: (context) => EmployeeListScreen());
          case '/user_detail':
            // Extract userId from arguments if needed
            final userId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => UserDetailScreen(userId: userId ?? ''));
          case '/employee_detail':
            // Extract userId from arguments if needed
            final employeeId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employeeId: employeeId ?? ''));
          case '/user_edit':
            // Extract userId from arguments if needed
            final userId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => EditUserScreen(userId: userId ?? ''));
          case '/user_archive':
            // Extract userId from arguments if needed
            final userId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => ArchiveUserScreen(userId: userId ?? ''));
          case '/user_unarchive':
            // Extract userId from arguments if needed
            final userId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => UnarchiveUserScreen(userId: userId ?? ''));
          case '/user_delete':
            // Extract userId from arguments if needed
            final userId = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => DeleteUserScreen(userId: userId ?? ''));
          case '/archived_users':
            return MaterialPageRoute(builder: (context) => ArchivedUsersScreen());
          default:
            return null;
        }
      },
    );
  }
}

