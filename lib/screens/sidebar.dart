import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF773697), Color(0xFF773697)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('assets/images/default_profile.svg'),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_new_employee');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFDEB3D)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Add employee',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      SizedBox(width: 5.0),
                      Icon(Icons.add),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/employee_bulk_upload');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFDEB3D)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Add Multiple',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      SizedBox(width: 5.0),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFF773697)),
            title: Text('Home', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Color(0xFF773697)),
            title: Text('Dashboard', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.business, color: Color(0xFF773697)),
            title: Text('Clients', style: TextStyle(color: Colors.black)),
            children: [
              ListTile(
                leading: Icon(Icons.view_list, color: Color(0xFF773697), size: 15.0),
                title: Text('View All Clients',
                style: TextStyle(fontSize: 12.0),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/list_clients');
                },
              ),
              ListTile(
                leading: Icon(Icons.add_business, color: Color(0xFF773697), size: 15.0),
                title: Text('New Client',
                style: TextStyle(fontSize: 12.0),
                ),
               
                
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/create_client');
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.people, color: Color(0xFF773697)),
            title: Text('Employee', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list_employees');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Color(0xFF773697)),
            title: Text('Attendance', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/attendance_admin_view');
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.assignment, color: Color(0xFF773697)),
            title: Text('Registration', style: TextStyle(color: Colors.black)),
            children: [
              ListTile(
		leading: Icon(Icons.app_registration, color: Color(0xFF773697), size: 15.0),
                title: Text('Register Admin',
                style: TextStyle(fontSize: 12.0),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin_register');
                },
              ),
              ListTile(
		leading: Icon(Icons.account_box, color: Color(0xFF773697), size: 15.0),
                title: Text('New Account Manager',
                style: TextStyle(fontSize: 12.0),
                ),

                onTap: () {
                  Navigator.pushReplacementNamed(context, '/account_manager_register');
                },
              ),
              ListTile(
		leading: Icon(Icons.person_add, color: Color(0xFF773697), size: 15.0),
                title: Text('New HR Manager',
                style: TextStyle(fontSize: 12.0),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/hr_register');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

