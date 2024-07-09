import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JBL Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/board.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Color(0xFF773697).withOpacity(1),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(), // Spacer at the top
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
			  padding: const EdgeInsets.symmetric(vertical: 16.0),
			  child: ClipRRect(
			    borderRadius: BorderRadius.circular(10.0), // Border radius of 10px
			    child: Image.asset(
			      'assets/images/jawabu_logo.jpeg',
			      width: 100.0,
			    ),
			  ),
			),

                      Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDEB3D),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person, color: Color(0xFF773697)),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF773697)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock, color: Color(0xFF773697)),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF773697)),
                                  ),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 16.0),

                             ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF773697),
                                foregroundColor: Color(0xFFFDEB3D),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/admin');
                              },
                              child: Text('Login'),
                            ),



                              TextButton(
				  onPressed: () {
				    // Handle password reset action
				  },
				  child: Column(
				    children: [
				      RichText(
					text: TextSpan(
					  children: [
					    TextSpan(
					      text: 'Forgot password?',
					      style: TextStyle(color: Color(0xFF2F8E92)),
					    ),
					    TextSpan(
					      text: ' Reset',
					      style: TextStyle(color: Color(0xFF773697)),
					    ),
					  ],
					),
				      ),
				      SizedBox(height: 8), // Space between text and divider
				      Divider(
					height: 1,
					color: Colors.transparent,
				      ),
				    ],
				  ),
				),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '© 2024 Jawabu Best Limited. All Rights Reserved.',
                    style: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 12.0,

                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
