import 'package:flutter/material.dart';
import 'package:journease/authentication/startpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Navigate to StartPage after 3 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen image here
            Image.asset(
              'assets/images/logo.png', // Add your splash image path
              height: 300,
              width: 300,
            ),
            // SizedBox(height: 20),
            // Text(
            //   "JournEase",
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: 10),
            CircularProgressIndicator(), // Optional: Add a loading indicator
          ],
        ),
      ),
    );
  }
}
