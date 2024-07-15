import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientListScreen extends StatefulWidget {
  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Map<String, dynamic>> clients = [];

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      // Replace with your API endpoint
      var url = Uri.parse('http://127.0.0.1:8000/api/clients/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode JSON response
        var data = jsonDecode(response.body);

        setState(() {
          // Assuming the API response is a list of clients with 'name' and 'branch' fields
          clients = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch clients');
      }
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client | JBL'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            if (clients.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (ctx, index) {
                    final client = clients[index];
                    return Card(
			  elevation: 3,
			  margin: EdgeInsets.symmetric(vertical: 8.0),
			  child: ListTile(
			    title: Text(client['name']),
			    subtitle: Text(client['branch']),
			    trailing: IconButton(
			      icon: Icon(Icons.arrow_forward),
			      onPressed: () {
    				Navigator.pushNamed(context, '/single_client', arguments: client['id'].toString());

			      },
			    ),
			  ),
			);
                  },
                ),
              )
            else
              Center(
                child: CircularProgressIndicator(), // Show loading indicator
              ),
          ],
        ),
      ),
    );
  }
}

