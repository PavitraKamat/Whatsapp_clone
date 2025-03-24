import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtsp_clone/view/components/uihelper.dart';
import 'package:wtsp_clone/view/screens/home/home_screen.dart';
import 'package:wtsp_clone/view/screens/login/login_screen.dart';
import 'package:wtsp_clone/view/screens/onboarding/onBoarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      await FirebaseAuth.instance.currentUser?.reload();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/whatsapp 1.png"),
            SizedBox(height: 10),
            UiHelper.CustomText(
                text: "Whatsapp", height: 18, fontweight: FontWeight.bold)
          ],
        ),
      ),
    );
  }
}
