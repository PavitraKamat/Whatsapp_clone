// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
// import 'package:wtsp_clone/view/components/uihelper.dart';
// import 'package:wtsp_clone/view/screens/home/home_screen.dart';
// import 'otp_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   String countryCode = "+91";
//   Country selectedCountry = Country(
//       phoneCode: "91",
//       countryCode: "IN",
//       e164Sc: 0,
//       geographic: true,
//       level: 1,
//       name: "India",
//       example: "India",
//       displayName: "India",
//       displayNameNoCountryCode: "In",
//       e164Key: "");
//   String verificationId = "";
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //final List<String> countryCodes = ["+91", "+1", "+44", "+61", "+81", "+49"];

//   @override
//   void dispose() {
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 UiHelper.CustomText(
//                   text: "Enter your phone number",
//                   height: 20,
//                   color: Color.fromARGB(255, 108, 193, 149),
//                   fontweight: FontWeight.bold,
//                 ),
//                 const SizedBox(height: 20),
//                 _buildInfoText(),
//                 const SizedBox(height: 35),
//                 _buildPhoneNumberField(),
//                 const SizedBox(height: 30),
//                 UiHelper.CustomButton(
//                   callback: login,
//                   buttonname: "Next",
//                   backgroundColor: Color(0xFF00A884),
//                 ),
//                 const SizedBox(height: 20),
//                 Divider(thickness: 1, color: Colors.grey[300]),
//                 const SizedBox(height: 20),
//                 _buildGoogleSignInButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoText() {
//     return Column(
//       children: [
//         UiHelper.CustomText(
//             text: "WhatsApp will need to verify your phone", height: 16),
//         UiHelper.CustomText(
//             text: "number. Carrier charges may apply.", height: 16),
//       ],
//     );
//   }

//   Widget _buildPhoneNumberField() {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             showCountryPicker(
//               context: context,
//               countryListTheme: CountryListThemeData(bottomSheetHeight: 400),
//               showPhoneCode: true,
//               onSelect: (value) {
//                 setState(() {
//                   selectedCountry = value;
//                 });
//               },
//             );
//           },
//           child: Row(
//             children: [
//               Text(selectedCountry.flagEmoji,
//                   style: TextStyle(fontSize: 22)), // Display flag
//               const SizedBox(width: 5),
//               Text("+${selectedCountry.phoneCode}",
//                   style: TextStyle(fontSize: 18, color: Color(0xFF00A884))),
//               Icon(Icons.arrow_drop_down, color: Color(0xFF00A884)),
//             ],
//           ),
//         ),
//         const SizedBox(width: 5),
//         Expanded(
//           child: TextField(
//             keyboardType: TextInputType.phone,
//             controller: phoneController,
//             maxLength: 10,
//             decoration: InputDecoration(
//               hintText: "Enter phone number",
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Color(0xFF00A884)),
//               ),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Color(0xFF00A884)),
//               ),
//               counterText: "",
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGoogleSignInButton() {
//     return UiHelper.CustomButton(
//       callback: () async {
//         final provider =
//             Provider.of<GoogleSignInProvider>(context, listen: false);
//         User? user = await provider.googleLogin(); // Get the user after sign-in

//         if (user != null && user.email != null) {
//           // Navigate to HomeScreen
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//             (route) => false,
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text("Google Sign-In Failed"),
//                 backgroundColor: Colors.red),
//           );
//         }
//       },
//       buttonname: "Sign in with Google",
//       //backgroundColor: Colors.white,
//       textColor: Colors.white,
//       icon: Icon(Icons.g_mobiledata, size: 40),
//     );
//   }

//   void login() async {
//     String phoneNumber = phoneController.text.trim();
//     if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text("Enter a valid 10-digit phone number"),
//             backgroundColor: Color(0xFF00A884)),
//       );
//       return;
//     }
//     String fullPhoneNumber = "$countryCode$phoneNumber";
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: fullPhoneNumber,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text("Verification Failed: ${e.message}"),
//                 backgroundColor: Colors.red),
//           );
//         },
//         codeSent: (String? verificationId, int? resendToken) {
//           if (verificationId != null && verificationId.isNotEmpty) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OTPScreen(
//                   phonenumber: phoneNumber,
//                   verificationId: verificationId,
//                 ),
//               ),
//             );
//           }
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             this.verificationId = verificationId;
//           });
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text("Error: ${e.toString()}"),
//             backgroundColor: Colors.red),
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
// import 'otp_screen.dart';  // Import OTP Screen

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLogin = true;
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void toggleMode() {
//     setState(() {
//       isLogin = !isLogin;
//     });
//   }

//   void handleAuth() async {
//     if (!_formKey.currentState!.validate()) return;

//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String name = nameController.text.trim();
//     String phone = phoneController.text.trim();

//     try {
//       if (isLogin) {
//         // Login
//         await _auth.signInWithEmailAndPassword(email: email, password: password);
//       } else {
//         // Sign Up
//         await _auth.createUserWithEmailAndPassword(email: email, password: password);
//         await _auth.currentUser!.updateDisplayName(name); // Save name
//       }
//       Navigator.pushReplacementNamed(context, "/home"); // Navigate to home
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(e.toString()),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   void handleGoogleSignIn() async {
//     final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
//     User? user = await provider.googleLogin();
//     if (user != null) {
//       Navigator.pushReplacementNamed(context, "/home");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(isLogin ? "Sign In" : "Create Account",
//                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00A884))),
//                     const SizedBox(height: 20),

//                     if (!isLogin) _buildTextField("Full Name", nameController, Icons.person, false),
//                     if (!isLogin) _buildTextField("Phone Number", phoneController, Icons.phone, false),

//                     _buildTextField("Email", emailController, Icons.email, false),
//                     _buildTextField("Password", passwordController, Icons.lock, true),

//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: handleAuth,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF00A884),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: Text(isLogin ? "Sign In" : "Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
//                     ),

//                     TextButton(
//                       onPressed: toggleMode,
//                       child: Text(isLogin ? "Create an account" : "Already have an account? Sign In",
//                           style: TextStyle(color: Color(0xFF00A884))),
//                     ),

//                     const SizedBox(height: 20),

//                     Row(children: [
//                       Expanded(child: Divider(color: Colors.grey)),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text("OR", style: TextStyle(color: Colors.grey)),
//                       ),
//                       Expanded(child: Divider(color: Colors.grey)),
//                     ]),

//                     const SizedBox(height: 10),

//                     // Google Sign-In Icon
//                     GestureDetector(
//                       onTap: handleGoogleSignIn,
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.grey, width: 1.5),
//                         ),
//                         child: Image.asset('assets/google_icon.png', height: 40),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isObscure) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isObscure,
//         keyboardType: isObscure ? TextInputType.visiblePassword : TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty) return "$label cannot be empty";
//           if (label == "Email" && !value.contains("@")) return "Enter a valid email";
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Color(0xFF00A884)),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }
