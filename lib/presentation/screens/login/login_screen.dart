import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = "+91";
  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> countryCodes = ["+91", "+1", "+44", "+61", "+81", "+49"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UiHelper.CustomText(
                  text: "Enter your phone number",
                  height: 20,
                  color: Color(0xFF00A884),
                  fontweight: FontWeight.bold,
                ),
                const SizedBox(height: 20),
                _buildInfoText(),
                const SizedBox(height: 35),
                _buildPhoneNumberField(),
                const SizedBox(height: 30),
                UiHelper.CustomButton(
                  callback: login,
                  buttonname: "Next",
                  backgroundColor: Color(0xFF00A884),
                ),
                const SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 20),
                _buildGoogleSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Column(
      children: [
        UiHelper.CustomText(
            text: "WhatsApp will need to verify your phone", height: 16),
        UiHelper.CustomText(
            text: "number. Carrier charges may apply.", height: 16),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: countryCode,
          onChanged: (String? newValue) {
            setState(() {
              countryCode = newValue!;
            });
          },
          items: countryCodes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(fontSize: 18, color: Color(0xFF00A884))),
            );
          }).toList(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: phoneController,
            maxLength: 10,
            decoration: InputDecoration(
              hintText: "Enter phone number",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00A884)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00A884)),
              ),
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return UiHelper.CustomButton(
      callback: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
      },
      buttonname: "Sign in with Google",
      backgroundColor: Colors.white,
      textColor: Colors.black,
      icon: Icon(Icons.g_mobiledata, size: 40),
    );
  }

  void login() async {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Enter a valid 10-digit phone number"),
            backgroundColor: Color(0xFF00A884)),
      );
      return;
    }

    String fullPhoneNumber = "$countryCode$phoneNumber";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Verification Failed: ${e.message}"),
                backgroundColor: Colors.red),
          );
        },
        codeSent: (String? verificationId, int? resendToken) {
          if (verificationId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phonenumber: phoneNumber,
                  verificationId: verificationId,
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red),
      );
    }
  }
}
