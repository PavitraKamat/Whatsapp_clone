import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phonenumber;
  final String verificationId;

  const OTPScreen(
      {Key? key, required this.phonenumber, required this.verificationId})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            UiHelper.CustomText(
                text: "Verifying your number",
                height: 20,
                color: Color(0XFF00A884),
                fontweight: FontWeight.bold),
            const SizedBox(height: 30),
            UiHelper.CustomText(
                text: "Enter OTP sent to +91${widget.phonenumber}", height: 15),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter OTP"),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: UiHelper.CustomButton(
        callback: () => verifyOTP(context),
        buttonname: "Verify",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void verifyOTP(BuildContext context) async {
    String otp = otpController.text.trim();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter a valid 6-digit OTP")));
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otp);
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP verification failed")));
    }
  }
}
