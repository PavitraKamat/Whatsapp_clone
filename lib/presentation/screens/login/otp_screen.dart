import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phonenumber;
  final String verificationId;

  const OTPScreen({
    Key? key,
    required this.phonenumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            UiHelper.CustomText(
              text: "Verifying your number",
              height: 20,
              color: Color(0XFF00A884),
              fontweight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            UiHelper.CustomText(
              text: "Enter OTP sent to +91${widget.phonenumber}",
              height: 15,
            ),
            const SizedBox(height: 30),
            Pinput(
              length: 6,
              controller: otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: Color.fromARGB(255, 77, 147, 132)),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: Colors.grey.shade200,
                ),
              ),
              onCompleted: (pin) => verifyOTP(context, pin),
            ),
            const SizedBox(height: 30),
            UiHelper.CustomButton(
              callback: () => verifyOTP(context, otpController.text.trim()),
              buttonname: "Verify",
            ),
          ],
        ),
      ),
    );
  }

  void verifyOTP(BuildContext context, String otp) async {
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid 6-digit OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP verification failed")),
      );
    }
  }
}
