import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeDetailScreen extends StatefulWidget {
  final String employeeId;

  EmployeeDetailScreen({required this.employeeId});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late Map<String, dynamic> employee;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
  }

  Future<void> fetchEmployeeDetails() async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/employees/${widget.employeeId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          employee = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch employee details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employee details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${employee['first_name']}'s Profile"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumb(),
                 Card(
		  child: Padding(
		    padding: EdgeInsets.all(16.0),
		    child: Column(
		      crossAxisAlignment: CrossAxisAlignment.start,
		      children: [
			Text(
			  "${employee['first_name']}'s Profile",
			  style: TextStyle(
			    fontSize: 24,
			    fontWeight: FontWeight.bold,
			    color: Colors.blue,
			  ),
			),
			SizedBox(height: 8),
			Divider(),
				SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          PictureColumn(employee: employee),
          SizedBox(width: 16),
          Expanded(child: PersonalInfoColumn(employee: employee)),
          SizedBox(width: 16),
          Expanded(child: AdditionalInfoColumn(employee: employee)),
        ],
      ),
    ],
  ),
),


		      ],
		    ),
		  ),
		),

                ],
              ),
            ),
    );
  }
}

class Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BreadcrumbItem(title: 'Dashboard', route: '/dashboard'),
        BreadcrumbItem(title: 'Employee', route: '/employee_all'),
        BreadcrumbItem(title: 'View', route: ''),
      ],
    );
  }
}

class BreadcrumbItem extends StatelessWidget {
  final String title;
  final String route;

  BreadcrumbItem({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Row(
        children: [
          Text(title),
          SizedBox(width: 4),
          if (route.isNotEmpty) Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}

class PictureColumn extends StatelessWidget {
  final Map<String, dynamic> employee;

  PictureColumn({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.network(
            employee['thumb'] ?? 'http://127.0.0.1/static/hrms/images/auth/default_profile.svg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "(ID) ${employee['emp_id']}",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PersonalInfoColumn extends StatelessWidget {
  final Map<String, dynamic> employee;

  PersonalInfoColumn({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoTable(
            title: 'Personal Info.',
            data: {
              'First Name': employee['first_name'],
              'Last Name': employee['last_name'],
              'Phone Number': employee['phone_number'],
              'Emergency Contact': employee['emergency_contact'],
              'Email': employee['email'],
              'Gender': employee['gender'],
              'Department': employee['department'],
            },
          ),
        ],
      ),
    );
  }
}

class AdditionalInfoColumn extends StatelessWidget {
  final Map<String, dynamic> employee;

  AdditionalInfoColumn({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoTable(
            title: 'Additional Info.',
            data: {
              'Language': employee['language'],
              'Enrollment Date': employee['created_at'],
            },
          ),
          InfoTable(
            title: 'Privileges',
            data: {
              'Clock-in privileges': employee['clockin_privileges'],
            },
          ),
        ],
      ),
    );
  }
}

class InfoTable extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  InfoTable({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
		  title,
		  textAlign: TextAlign.center, 
		  style: TextStyle(
		    fontSize: 18,
		    fontWeight: FontWeight.bold,
		  ),
		),

            SizedBox(height: 8),
            ...data.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(entry.value),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
