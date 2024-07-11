import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class EditClientScreen extends StatefulWidget {
  final String clientId; // Assuming you pass client ID to this screen

  EditClientScreen({required this.clientId});

  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial client data when the screen loads
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      var url = Uri.parse('https://your-api-endpoint.com/clients/${widget.clientId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Example of setting form data in FormBuilder
        _formKey.currentState?.patchValue({
          'name': data['name'],
          'department': data['department'],
          'branch': data['branch'],
          // Add more fields as needed
        });
      } else {
        print('Failed to fetch client details: ${response.statusCode}');
        // Handle error: show snackbar, retry option, etc.
      }
    } catch (e) {
      print('Error fetching client details: $e');
      // Handle error: show snackbar, retry option, etc.
    } finally {
      setState(() {
        _isLoading = false; // End loading state
      });
    }
  }

  Future<void> updateClient(Map<String, dynamic> formData) async {
    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      var url = Uri.parse('https://your-api-endpoint.com/clients/${widget.clientId}');
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Client updated successfully');
        // Optionally navigate back or show success dialog
      } else {
        // Handle failure, e.g., show an error message
        print('Failed to update client: ${response.statusCode}');
        // Handle error: show snackbar, retry option, etc.
      }
    } catch (e) {
      print('Error updating client: $e');
      // Handle error: show snackbar, retry option, etc.
    } finally {
      setState(() {
        _isLoading = false; // End loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Client'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Client',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: FormBuilderValidators.required(errorText: 'This field is required'),
                    ),
                    FormBuilderTextField(
                      name: 'department',
                      decoration: InputDecoration(
                        labelText: 'Department',
                      ),
                      validator: FormBuilderValidators.required(errorText: 'This field is required'),
                    ),
                    FormBuilderTextField(
                      name: 'branch',
                      decoration: InputDecoration(
                        labelText: 'Branch',
                      ),
                      validator: FormBuilderValidators.required(errorText: 'This field is required'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          final formData = _formKey.currentState?.value;
                          updateClient(formData!);
                        } else {
                          print('Form validation failed');
                        }
                      },
                      child: Text('Update Client'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

