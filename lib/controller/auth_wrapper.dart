import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/view/screens/home/home_screen.dart';
import 'package:wtsp_clone/view/screens/login/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return HomeScreen(); // If user is logged in, go to HomeScreen
        } else {
          return LoginScreen(); // Otherwise, stay in LoginScreen
        }
      },
    );
  }
}


// 