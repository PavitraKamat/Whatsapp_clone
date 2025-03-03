import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';

class SplashScreen extends StatelessWidget {
  Future<void> _navigateToHome(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    _navigateToHome(context);

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
