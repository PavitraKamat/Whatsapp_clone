import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wtsp_clone/view/components/uihelper.dart';
import 'package:wtsp_clone/view/screens/login/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset("assets/images/onboard.png"),
            Lottie.asset("assets/lottie/Animation - 1745905914256.json",
                width: 300),
            SizedBox(
              height: 20,
            ),
            UiHelper.CustomText(
                text: "Welcome to ChatApp",
                height: 20,
                color: Color(0XFF000000)),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UiHelper.CustomText(text: "Read out", height: 14),
                UiHelper.CustomText(
                    text: " Privacy Policy. ",
                    height: 14,
                    color: Color.fromARGB(255, 3, 151, 48)),
                UiHelper.CustomText(
                    text: "Tap ''Agree and continue''", height: 14),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UiHelper.CustomText(text: "to accept the ", height: 14),
                UiHelper.CustomText(
                    text: "Teams of Service",
                    height: 14,
                    color: Color.fromARGB(255, 3, 151, 48)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: UiHelper.CustomButton(
          callback: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          buttonname: "Agree and continue"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
