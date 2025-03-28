import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/view/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleMode() {
    setState(() => isLogin = !isLogin);
  }

  void handleAuth(ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider) async {
    if (!_formKey.currentState!.validate()) return;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    try {
      final authService =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      if (isLogin) {
        await authService.signIn(
            email, password, profileProvider, contactsProvider);
      } else {
        await authService.signUp(
            name, phone, email, password, profileProvider, contactsProvider);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void handleGoogleSignIn(ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider) async {
    final authService =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    User? user =
        await authService.signInWithGoogle(profileProvider, contactsProvider);
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error",
            style: TextStyle(
                color: const Color.fromARGB(255, 244, 67, 54),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        content: Text(message, style: TextStyle(fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK", style: TextStyle(color: Colors.teal)),
          ),
        ],
        backgroundColor: const Color.fromARGB(239, 248, 247, 247),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final contactsProvider = Provider.of<FireBaseContactsProvider>(context);

    return Stack(
      children: [
        _backGroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _loginForm(profileProvider, contactsProvider),
        ),
      ],
    );
  }

  Positioned _backGroundImage() {
    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child:
            Image.asset("assets/images/loginBackground.jpg", fit: BoxFit.cover),
      ),
    );
  }

  SafeArea _loginForm(ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Color(0xFF00A884)),
                  SizedBox(height: 15),
                  Text(
                    isLogin ? "Welcome Back" : "Create an Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  if (!isLogin)
                    _buildTextField("Full Name", nameController, Icons.person,
                        validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Full Name is required";
                      }
                      return null;
                    }),
                  if (!isLogin)
                    _buildTextField(
                        "Phone Number", phoneController, Icons.phone,
                        isNumber: true, maxLength: 10, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone Number is required";
                      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return "Enter a valid 10-digit phone number";
                      }
                      return null;
                    }),
                  _buildTextField("Email", emailController, Icons.email,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  }),
                  _buildTextField("Password", passwordController, Icons.lock,
                      isObscure: !isPasswordVisible,
                      isPassword: true, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        handleAuth(profileProvider, contactsProvider),
                    child: Text(isLogin ? "Sign In" : "Sign Up"),
                  ),
                  TextButton(
                    onPressed: toggleMode,
                    child: Text(isLogin
                        ? "Create an account"
                        : "Already have an account? Sign In"),
                  ),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () =>
                        handleGoogleSignIn(profileProvider, contactsProvider),
                    child: Image.asset('assets/images/google.png', height: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isObscure = false,
      bool isNumber = false,
      bool isPassword = false,
      int? maxLength,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: Colors.teal),
          prefixIcon: Icon(icon),
          fillColor: Color.fromARGB(172, 245, 245, 245),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: isPassword
              ? IconButton(
                  icon:
                      Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
