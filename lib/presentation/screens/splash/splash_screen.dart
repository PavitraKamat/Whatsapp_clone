import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';
import 'package:wtsp_clone/presentation/widgets/uihelper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  Timer _navigateToHomeScreen() {
    return Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

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
