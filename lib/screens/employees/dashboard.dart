import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserData(String token, String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token);
  await prefs.setString('userId', userId);
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

// Retrieve the token
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

class EmployeeDashboardScreen extends StatefulWidget {
  @override
  _EmployeeDashboardScreenState createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  DateTime selectedDate = DateTime.now();
  String keyword = '';
  double? latitude;
  double? longitude;
  bool clockedIn = false;
  List<dynamic> clockIns = []; 
  String? userId;

@override
void initState() {
  super.initState();
  fetchUserData();
  _getCurrentLocation();
  fetchClockIns();
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

  if (token == null || userId == null) {
    print('No token or user ID found');
    return;
  }

  try {
    final response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'first_in': DateFormat('HH:mm:ss').format(DateTime.now()),
        'last_out': DateFormat('HH:mm:ss').format(DateTime.now()),
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
    } else {
      print('Failed to clock in/out: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  Future<void> fetchClockIns() async {
    String apiUrl = 'http://127.0.0.1:8000/api/admin_clock-in/'; // Replace with your Django API URL for clock-ins
    final response = await http.get(Uri.parse(apiUrl));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Breadcrumb(),
              SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (clockedIn) ...[
                        ElevatedButton.icon(
                          onPressed: _clockInOrOut,
                          icon: Icon(Icons.logout),
                          label: Text('Clock Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF773697),
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
                            backgroundColor: Color(0xFFFDEB3D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 16.0),
                      Text(
                        'List of your clock-ins today',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(height: 16.0),
                      _buildAttendanceTable(),
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

