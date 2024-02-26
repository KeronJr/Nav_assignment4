import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:navigation_assignment_2/calculator/calculator_screen.dart';
import 'package:provider/provider.dart';

import 'drawer_navigation.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final GoogleSignInAccount user;

  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String _connectionStatus = 'Unknown'; // Track connectivity status

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // getConnectivity();
    super.initState();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initConnectivity(); // Initialize connectivity
  //   _listenForConnectivityChanges(); // Listen for connectivity changes
  // }

  // Future<void> _initConnectivity() async {
  //   bool isConnected = await InternetConnectionChecker().hasConnection;
  //   setState(() {
  //     _connectionStatus = isConnected ? 'Connected' : 'Disconnected';
  //   });
  // }

  // void _listenForConnectivityChanges() {
  //   InternetConnectionChecker().onStatusChange.listen((status) {
  //     setState(() {
  //       _connectionStatus = status == InternetConnectionStatus.connected
  //           ? 'Connected'
  //           : 'Disconnected';
  //     });
  //     _showConnectivitySnackbar(); // Show Snackbar for connectivity status
  //   });
  // }

  // void _showConnectivitySnackbar() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(_connectionStatus),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  int _selectedIndex = 0;
  final List<Widget> _screens = [
    ScreenOne(),
    CalculatorScreen(),
    ScreenThree(),
  ];

  // List of titles for the AppBar based on the tab index
  final List<String> _appBarTitles = ['Welcome Home', 'Calculator', 'About'];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]), // Dynamic title
      ),
      body: Column(
        children: [
          Expanded(
            child: _screens[_selectedIndex],
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabSelected,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Calculator',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              ),
            ],
          ),
        ],
      ),
      drawer: DrawerNavigation(
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context); // Close the drawer
        },
        selectedIndex: _selectedIndex,
        user: widget.user,
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Welcome to Keron's car dealership!\n\n"
            "Keron\'s Car Dealership is the best place to buy or sell a car."
            'At our dealership, we offer an extensive range of high-quality vehicles '
            'to suit every need and budget. Whether you are looking for a sleek sedan, '
            'a rugged SUV, or a powerful truck, we have something for everyone. Our '
            'friendly and knowledgeable staff are here to assist you every step of the way, '
            'from finding the perfect vehicle to securing the best financing options. '
            'Browse our inventory online or visit us in person today to experience '
            'the difference at our dealership!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Welcome to Keron's car dealership app! We are dedicated to providing our customers "
                'with the best car buying experience possible. Our dealership offers a wide selection '
                'of vehicles from leading manufacturers, ensuring that there is something for everyone '
                'in our inventory.\n\n'
                'At our dealership, we prioritize customer satisfaction above all else. Our team of '
                'knowledgeable sales professionals is committed to helping you find the perfect vehicle '
                'to suit your needs and budget. We also offer flexible financing options to make your '
                'car buying experience as convenient as possible.\n\n'
                'We invite you to explore our app and discover the many benefits of choosing our dealership '
                'for your next vehicle purchase.\n\n Thank you for considering us for all your automotive needs!\n',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Keron Junior\n"
                    "Managing Director.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
