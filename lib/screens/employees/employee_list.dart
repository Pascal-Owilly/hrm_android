import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      var url = Uri.parse('https://your-api-endpoint.com/employees');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          employees = data['employees']; // Adjust according to your API response structure
        });
      } else {
        print('Failed to fetch employees');
      }
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Employees | JBL'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Breadcrumb(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'All Employees',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    if (employees.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          var employee = employees[index];
                          return EmployeeCard(employee: employee);
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('No employees found.'),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (employees.isNotEmpty)
                Pagination(), // Assuming pagination needs to be shown when employees are present
            ],
          ),
        ),
      ),
    );
  }
}

class Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin_dashboard');
            },
            child: Text('Dashboard'),
          ),
          SizedBox(width: 10),
          Text(
            'Employee',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            'All',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final dynamic employee;

  const EmployeeCard({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(employee['avatar'] ?? 'default_image_url'),
        ),
        title: Text('${employee['first_name']} ${employee['last_name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee['phone_number']),
            Text(
              employee['email'],
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text('View'),
                onTap: () {
                  Navigator.pushNamed(context, '/employee_view', arguments: employee['id']);
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pushNamed(context, '/user_update', arguments: employee['id']);
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.archive),
                title: Text('Archive'),
                onTap: () {
                  Navigator.pushNamed(context, '/user_archive', arguments: employee['id']);
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pushNamed(context, '/employee_delete', arguments: employee['id']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Previous'),
          ),
          SizedBox(width: 10),
          Text(
            'Page 1 of 1', // Replace with dynamic page info based on API response
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () {},
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => EmployeeListScreen(),
      '/admin_dashboard': (context) => Scaffold(body: Center(child: Text('Admin Dashboard'))),
      '/employee_view': (context) => Scaffold(body: Center(child: Text('Employee View'))),
      '/user_update': (context) => Scaffold(body: Center(child: Text('User Update'))),
      '/user_archive': (context) => Scaffold(body: Center(child: Text('User Archive'))),
      '/employee_delete': (context) => Scaffold(body: Center(child: Text('Employee Delete'))),
    },
  ));
}
