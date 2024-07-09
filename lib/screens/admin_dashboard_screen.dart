import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package
import 'dart:convert'; // Import for JSON decoding
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/common_layout.dart';
import '../screens/sidebar.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Initialize variables to store data fetched from endpoints
  int allUsersCount = 0;
  int hrManagersCount = 0;
  int accountManagersCount = 0;
  int clientsCount = 0;
  int employeesCount = 0;
  int administratorsCount = 0;

  // Method to fetch data from Django endpoints
  Future<void> fetchData() async {
    try {
      // Example endpoint URLs (replace with your actual Django endpoints)
      var allUsersUrl = Uri.parse('https://your-django-api/all_users');
      var hrManagersUrl = Uri.parse('https://your-django-api/hr_managers');
      var accountManagersUrl = Uri.parse('https://your-django-api/account_managers');
      var clientsUrl = Uri.parse('https://your-django-api/clients');
      var employeesUrl = Uri.parse('https://your-django-api/employees');
      var administratorsUrl = Uri.parse('https://your-django-api/administrators');

      // Make GET requests
      var allUsersResponse = await http.get(allUsersUrl);
      var hrManagersResponse = await http.get(hrManagersUrl);
      var accountManagersResponse = await http.get(accountManagersUrl);
      var clientsResponse = await http.get(clientsUrl);
      var employeesResponse = await http.get(employeesUrl);
      var administratorsResponse = await http.get(administratorsUrl);

      // Parse JSON responses
      var allUsersData = jsonDecode(allUsersResponse.body);
      var hrManagersData = jsonDecode(hrManagersResponse.body);
      var accountManagersData = jsonDecode(accountManagersResponse.body);
      var clientsData = jsonDecode(clientsResponse.body);
      var employeesData = jsonDecode(employeesResponse.body);
      var administratorsData = jsonDecode(administratorsResponse.body);

      // Update state variables with fetched data
      setState(() {
        allUsersCount = allUsersData['count'];
        hrManagersCount = hrManagersData['count'];
        accountManagersCount = accountManagersData['count'];
        clientsCount = clientsData['count'];
        employeesCount = employeesData['count'];
        administratorsCount = administratorsData['count'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      title: 'Jawabu Best Limited Administration',
      titleStyle: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFFD9D9D9), // Example: Customize text color
      ),
      drawer: CustomSidebar(),
      child: Stack(
        children: [
          Container(
            color: Colors.blueGrey[50],
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  CardWidget(
                    icon: MdiIcons.accountMultiple,
                    title: 'All Users',
                    count: allUsersCount.toString(),
                    url: '/users_all',
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CardWidget(
                          icon: MdiIcons.accountAlert,
                          title: 'HR Managers',
                          count: hrManagersCount.toString(),
                          url: '/hr_all',
                        ),
                      ),
                      Expanded(
                        child: CardWidget(
                          icon: MdiIcons.accountCog,
                          title: 'Account Managers',
                          count: accountManagersCount.toString(),
                          url: '/account_manager_all',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CardWidget(
                          icon: MdiIcons.accountGroup,
                          title: 'Clients',
                          count: clientsCount.toString(),
                          url: '/clnt_all',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CardWidget(
                          icon: MdiIcons.accountBoxMultiple,
                          title: 'Employees',
                          count: employeesCount.toString(),
                          url: '/employee_all',
                        ),
                      ),
                      Expanded(
                        child: CardWidget(
                          icon: MdiIcons.accountSupervisor,
                          title: 'Administrators',
                          count: administratorsCount.toString(),
                          url: '/admin_list',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'New Employees',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Picture')),
                              DataColumn(label: Text('First name')),
                              DataColumn(label: Text('Last name')),
                              DataColumn(label: Text('Mobile')),
                            ],
                            rows: [
                              DataRow(
                                cells: [
                                  DataCell(
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: AssetImage('assets/images/auth/default_profile.svg'),
                                    ),
                                  ),
                                  DataCell(Text('John')),
                                  DataCell(Text('Doe')),
                                  DataCell(
                                    Text('1234567890'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final String url;

  CardWidget({
    required this.icon,
    required this.title,
    required this.count,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, url);
      },
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color.fromARGB(255, 249, 250, 251), // Background color
        shadowColor: Color.fromRGBO(249, 249, 249, 0.7), // Box shadow color with opacity
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(icon, color: Color(0xFF773697)), // Icon color
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF773697), // Title color
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                count,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007BFF), // Count color
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Total Count',
                style: TextStyle(
                  color: Color(0xFFC2C2C2), // URL color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

