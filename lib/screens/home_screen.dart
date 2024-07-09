import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/board.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
          color: Color.fromRGBO(119, 54, 151, 1), 
        ),
        constraints: BoxConstraints.expand(), // Ensure container fills entire screen
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carousel
              SizedBox(
                height: 300, // Adjust height as needed
                child: CarouselWidget(),
              ),
              SizedBox(height: 20.0),
              // Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to login screen
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 30.0,
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Text(
                  'Get started →',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        CarouselItem(
          title: 'Employee Management',
          subtitle: 'Efficiently manage your workforce with our comprehensive HRMS.',
        ),
        CarouselItem(
          title: 'Time Tracking',
          subtitle: 'Track attendance and time records effortlessly.',
        ),
        CarouselItem(
          title: 'Company Management',
          subtitle: 'Streamline operations with powerful administrative tools.',
        ),
      ],
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String title;
  final String subtitle;

  CarouselItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

