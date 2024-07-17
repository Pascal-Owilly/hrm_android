import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/sidebar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> _clients = []; // List of clients
  DateTime selectedDate = DateTime.now();
  String keyword = '';
  double? latitude;
  double? longitude;
  bool clockedIn = false;
  List<dynamic> clockIns = []; 
  String? userId;
  String? imei;
  
Future<void> _getIMEI() async {
  if (await Permission.phone.request().isGranted) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      imei = androidInfo.id; // Using unique device ID as IMEI alternative
    });
  } else {
    print('Phone permission not granted');
  }
}

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Fetch dashboard data
    _getIMEI(); 
    fetchUserData();
  _getCurrentLocation();
  fetchClockIns();
  }
  

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }
  
  Future<void> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    userId = prefs.getString('userId') ?? '';
    if (userId?.isNotEmpty ?? false) {
      print('User ID: $userId');
    } else {
      print('No user ID found');
    }
  });
}


  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

Future<void> _clockInOrOut() async {
  final url = Uri.parse('http://127.0.0.1:8000/api/admin_clock-in/');
  final token = await getToken();

  try {
    final response = await http.post(
      url,
      body: jsonEncode({
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'first_in': DateFormat('HH:mm:ss').format(DateTime.now()),
        'last_out': DateFormat('HH:mm:ss').format(DateTime.now()),
        'imei': imei, // Send IMEI here
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        clockedIn = !clockedIn;
      });
      await fetchClockIns();
    } else {
      print('Failed to clock in/out: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


Future<void> fetchClockIns() async {
  String apiUrl = 'http://127.0.0.1:8000/api/admin_clock-in/';
  final token = await getToken();
  
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Successful API call
    setState(() {
      clockIns = jsonDecode(response.body);
    });
  } else {
    // Handle error
    print('Failed to load clock-ins: ${response.statusCode}');
  }
}

  Future<void> _fetchDashboardData() async {
    try {
      String? token = await getToken(); // Retrieve the authentication token

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/clients/assigned-to-me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body
        List<dynamic> responseData = json.decode(response.body);

        // Print the fetched clients for verification
        print('Fetched Clients:');
        responseData.forEach((client) {
          print('Client Name: ${client['name']}');
          print('Client Branch: ${client['branch']}');
          print('---');
        });

        // Update the state to reflect the fetched clients
        setState(() {
          _clients = responseData;
        });
      } else if (response.statusCode == 401) {
        // Unauthorized, attempt to refresh token
        await refreshToken();
        // Retry fetching data
        await _fetchDashboardData();
      } else {
        // Handle other HTTP status codes
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching client details: $e');
      // Handle errors here, such as setting _clients to empty list to avoid null reference
      setState(() {
        _clients = [];
      });
    }
  }

  Future<void> refreshToken() async {
    try {
      String? refreshToken = await getRefreshToken(); // Get refresh token from SharedPreferences

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/token/refresh/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        // Update SharedPreferences with new access token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String newToken = json.decode(response.body)['access'];
        await prefs.setString('authToken', newToken);
        // After token refresh, re-fetch dashboard data
        await _fetchDashboardData();
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
  }



  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
  Text(
    'Hello,', 
    style: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF773697), // Purple color
    ),
  ),
  SizedBox(height: 16.0),
  Text(
    'Clients Assigned to You',
    style: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF007BFF), // Blue color
    ),
  ),
  SizedBox(height: 8.0),
  Divider(
    color: Colors.black, // You can adjust the color of the divider as needed
    thickness: 1.5, // Adjust the thickness of the divider
  ),
  _buildClientList(), // Assuming _buildClientList() builds the list of clients
],

        ),
      ),
    );
  }

Widget _buildClientList() {
  if (_clients.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.warning, size: 50.0, color: Colors.grey),
          SizedBox(height: 20.0),
          Text(
            'No clients assigned yet',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  } else {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _clients.length,
          (index) {
            var client = _clients[index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 3,
                child: Container(
                  width: 250, // Adjust the width of the card as needed
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client['name'],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF773697), // Purple color
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        client['branch'],
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/single_client',
                            arguments: client['id'].toString(),
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007BFF), // Blue background color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Account Manager Dashboard'),
    ),
    drawer: CustomSidebar(),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
_buildClientList(),
            SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (clockedIn) ...[
                      ElevatedButton.icon(
                        onPressed: _clockInOrOut,
                        icon: Icon(Icons.logout),
                        label: Text('Clock Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: _clockInOrOut,
                        icon: Icon(Icons.check),
                        label: Text('Clock In'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16.0),
                    Text(
                      'List of your employees clock-ins today',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 16.0),
                    _buildAttendanceTable(),
                    SizedBox(height: 16.0),
                    Text(
                      'Assigned Clients',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 16.0),
                    _buildClientList(), // Add the client list here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAttendanceTable() {
  if (clockIns.isEmpty) {
    return Text('No clock-in data available');
  }

  return Column(
    children: [
      Table(
        border: TableBorder.all(),
        children: [
          TableRow(
            children: [
              _buildTableHeader('Date'),
              _buildTableHeader('First-In (Arrival)'),
              _buildTableHeader('Last-Out (Departure)'),
            ],
          ),
          ...clockIns.map((clockIn) {
            return TableRow(
              children: [
                _buildTableCell(clockIn['date']),
                _buildTableCell(clockIn['first_in']),
                _buildTableCell(clockIn['last_out']),
              ],
            );
          }).toList(),
        ],
      ),
    ],
  );
}

Widget _buildTableHeader(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildTableCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text),
  );
}
}

class Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/admin_dashboard');
          },
          child: Text(
            'Dashboard',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Text(' / Attendance'),
      ],
    );
  }
}


