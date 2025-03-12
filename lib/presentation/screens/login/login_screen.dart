import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = "+91";
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "In",
      e164Key: "");
  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //final List<String> countryCodes = ["+91", "+1", "+44", "+61", "+81", "+49"];

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

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
      children: [
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(bottomSheetHeight: 400),
              showPhoneCode: true,
              onSelect: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            );
          },
          child: Row(
            children: [
              Text(selectedCountry.flagEmoji,
                  style: TextStyle(fontSize: 22)), // Display flag
              const SizedBox(width: 5),
              Text("+${selectedCountry.phoneCode}",
                  style: TextStyle(fontSize: 18, color: Color(0xFF00A884))),
              Icon(Icons.arrow_drop_down, color: Color(0xFF00A884)),
            ],
          ),
        ),
        const SizedBox(width: 5),
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
      callback: () async {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        User? user = await provider.googleLogin(); // Get the user after sign-in

        if (user != null && user.email != null) {
          // Navigate to HomeScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Google Sign-In Failed"),
                backgroundColor: Colors.red),
          );
        }
      },
      buttonname: "Sign in with Google",
      //backgroundColor: Colors.white,
      textColor: Colors.white,
      icon: Icon(Icons.g_mobiledata, size: 40),
    );
  }

  void login() async {
    String phoneNumber = phoneController.text.trim();
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Enter a valid 10-digit phone number"),
            backgroundColor: Color(0xFF00A884)),
      );
      return;
    }
    
    String fullPhoneNumber = "$countryCode$phoneNumber";
    //String fullPhoneNumber = "${selectedCountry.phoneCode}$phoneNumber";
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
          if (verificationId != null && verificationId.isNotEmpty) {
            Navigator.pushReplacement(
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
