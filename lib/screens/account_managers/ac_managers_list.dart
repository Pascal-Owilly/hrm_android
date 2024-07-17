import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => AccountManagersListScreen(),
    },
  ));
}

class AccountManagersListScreen extends StatefulWidget {
  @override
  _AccountManagersListScreenState createState() => _AccountManagersListScreenState();
}

class _AccountManagersListScreenState extends State<AccountManagersListScreen> {
  List<dynamic> users = []; 

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Update method call to fetch users
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/account-managers/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        setState(() {
          users = data;
        });
      } else {
        print('Failed to fetch users'); // Adjust error message if needed
      }
    } catch (e) {
      print('Error fetching users: $e'); // Adjust error message if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All HRs | JBL'), // Update screen title
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
                    child: Breadcrumb(), // Keep breadcrumb as is if it suits your navigation
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
                        'All HR Managers',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    if (users.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user = users[index]; // Change variable name to user
                          return UserCard(user: user); // Update to UserCard
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('No users found.'),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (users.isNotEmpty)
                Pagination(), // Assuming pagination needs to be shown when users are present
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
              Navigator.pushNamed(context, '/admin');
            },
            child: Text('Dashboard'),
          ),
          SizedBox(width: 10),
          Text(
            'Hr Managers',
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

class UserCard extends StatelessWidget {
  final dynamic user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['avatar'] ?? 'default_image_url'),
        ),
        title: Text('${user['first_name']} ${user['last_name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'] ?? 'No email provided'),
            Text(user['phone_number'] ?? 'No mobile number provided'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text('View'),
                onTap: () {
			Navigator.pushNamed(
			  context,
			  '/user_detail',
			  arguments: user['id'].toString(),
			);
                },
              ),
            ),
            // Add more options as needed (Edit, Archive, Delete, etc.)
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
