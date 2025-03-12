import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';
import 'package:wtsp_clone/presentation/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate splash duration
    final user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      // Ensure widget is still active
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => user != null ? HomeScreen() : LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: CircularProgressIndicator()), // Show loading indicator
    );
  }
}
