// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the timer when the screen loads
    Timer(Duration(seconds: 5), () {
      // After 3 seconds, navigate to the desired home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(), // Replace with your desired home screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff011826), // Customize the background color
        body: Center(
            child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              height: 400,
              width: 400,
              fit: BoxFit.cover,
            ),
            Text(
              'DIG DEEP',
              style: TextStyle(
                fontSize: 69,
                fontWeight: FontWeight.bold,
                // Customize the font size
                color: Colors.white, // Customize the text color
              ),
            ),
            Text(
              'Encrypt with ease,decrypt with DIG DEEP',
              style: TextStyle(
                fontSize: 14,
                // Customize the font size
                color: Colors.white, // Customize the text color
              ),
            )
          ],
        )));
  }
}
