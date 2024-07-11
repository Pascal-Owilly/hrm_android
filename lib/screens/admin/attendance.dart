import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  String keyword = '';
  double? latitude;
  double? longitude;
  bool clockedIn = false; // Example state, you should replace it with actual state from your backend
  List<Employee> presentStaffers = []; // Example list, you should replace it with actual data from your backend

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future<void> _clockInOrOut() async {
    // Replace with actual clock in/out logic and update the state accordingly
    setState(() {
      clockedIn = !clockedIn;
    });
  }

  Future<void> _filterByDate(DateTime date) async {
    // Implement the logic to filter attendance by date
  }

  Future<void> _searchByName(String keyword) async {
    // Implement the logic to search attendance by name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance | JBL'),
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
                            backgroundColor: Color(0xFF773697), // Use backgroundColor instead of primary
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
                            backgroundColor: Color(0xFFFDEB3D), // Use backgroundColor instead of primary
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 16.0),
                      Text(
                        'List of employee(s) that clocked-in today',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        
                          ElevatedButton(
                            onPressed: _downloadPDF,
                            child: Text('Download PDF'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: _downloadExcel,
                            child: Text('Download Excel'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      _buildFilterForm(),
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

  Widget _buildFilterForm() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by Date'),
              SizedBox(height: 8.0),
              Container(
                width: 150,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  initialValue: DateFormat('yyyy-MM-dd').format(selectedDate),
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                      _filterByDate(date);
                    }
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search by name'),
              SizedBox(height: 8.0),
              Container(
                width: 150,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchByName(keyword);
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable() {
    if (presentStaffers.isEmpty) {
      return Text('No employees data');
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
                _buildTableHeader('Name'),
                _buildTableHeader('Action(s)'),
              ],
            ),
            ...presentStaffers.map((staff) {
              return TableRow(
                children: [
                  _buildTableCell(staff.date),
                  _buildTableCell(staff.firstIn),
                  _buildTableCell(staff.lastOut),
                  _buildTableCell(staff.name),
                  _buildTableCell(staff.lastOut != null ? 'Clocked Out' : 'Clocked In', isButton: true),
                ],
              );
            }).toList(),
          ],
        ),
        // Add pagination controls if needed
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

  Widget _buildTableCell(String text, {bool isButton = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isButton
          ? ElevatedButton(
              onPressed: () {},
              child: Text(text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            )
          : Text(text),
    );
  }

  void _printAttendance() {
    // Implement print logic
  }

  void _downloadPDF() {
    // Implement download PDF logic
  }

  void _downloadExcel() {
    // Implement download Excel logic
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

class Employee {
  final String date;
  final String firstIn;
  final String lastOut;
  final String name;

  Employee({
    required this.date,
    required this.firstIn,
    required this.lastOut,
    required this.name,
  });
}

