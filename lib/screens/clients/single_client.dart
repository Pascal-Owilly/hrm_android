import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../screens/sidebar.dart';

class ClientInfoScreen extends StatefulWidget {
  final String clientId; // pass client ID to this screen

  ClientInfoScreen({required this.clientId});

  @override
  _ClientInfoScreenState createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
  Map<String, dynamic>? client;
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchClientInfo();
  }

  Future<void> fetchClientInfo() async {
    try {
      // Fetch client details
      var clientUrl = Uri.parse('http://127.0.0.1:8000/api/clients/${widget.clientId}');
      var clientResponse = await http.get(clientUrl);

      if (clientResponse.statusCode == 200) {
        var clientData = jsonDecode(clientResponse.body);

        // Fetch employees associated with the client
        var employeesUrl = Uri.parse('http://127.0.0.1:8000/api/clients/${widget.clientId}/employees');
        var employeesResponse = await http.get(employeesUrl);

        if (employeesResponse.statusCode == 200) {
          var employeesData = jsonDecode(employeesResponse.body);

          setState(() {
            client = clientData;
            employees = employeesData['employees']; // Assuming 'employees' is a list in the response
          });
        } else {
          print('Failed to fetch employees: ${employeesResponse.statusCode}');
          setState(() {
            client = clientData; // Still update client even if employees fetching failed
          });
        }
      } else {
        print('Failed to fetch client details: ${clientResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching client details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Info | JBL'),
      ),
      drawer: CustomSidebar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: client != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${client!['name']} Client | ${client!['branch']} Branch',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (ModalRoute.of(context)?.settings.arguments == 'superuser')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_client',
                          arguments: client!['id'],
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Update Info'),
                    ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account Manager',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                client!['account_manager'] != null
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: client!['account_manager']['thumb'] != null
                                                ? NetworkImage(client!['account_manager']['thumb'])
                                                : AssetImage('assets/images/default_profile.png') as ImageProvider,
                                            radius: 50,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${client!['account_manager']['first_name']} ${client!['account_manager']['last_name']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${client!['account_manager']['email']}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${client!['account_manager']['phone_number']}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        'Account manager not assigned',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Associated Employees',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                employees.isNotEmpty
                                    ? Column(
                                        children: employees.map((employee) {
                                          return Card(
                                            elevation: 3,
                                            margin: EdgeInsets.symmetric(vertical: 8.0),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: employee['thumb'] != null
                                                    ? NetworkImage(employee['thumb'])
                                                    : AssetImage('assets/images/default_profile.png') as ImageProvider,
                                              ),
                                              title: Text(
                                                '${employee['first_name']} ${employee['last_name']}',
                                              ),
                                              subtitle: Text(
                                                '(${employee['emp_id']})',
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.arrow_forward),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/employee_view',
                                                    arguments: employee['id'],
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Center(
                                        child: Text(
                                          'No associated employees',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  FormBuilder(
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'client_name',
                          decoration: InputDecoration(labelText: 'Client Name'),
                          validator: FormBuilderValidators.required(
                              errorText: 'This field is required'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

