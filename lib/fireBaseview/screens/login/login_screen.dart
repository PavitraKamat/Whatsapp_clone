import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/view/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleMode() {
    setState(() => isLogin = !isLogin);
  }

  void handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    try {
      final authService =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      if (isLogin) {
        await authService.signIn(email, password);
      } else {
        await authService.signUp(name, phone, email, password);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void handleGoogleSignIn() async {
    final authService =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    User? user = await authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Image.asset(
              "assets/images/loginBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Icon(Icons.lock_outline,
                            size: 80, color: Color(0xFF00A884)),
                        SizedBox(height: 15),
                        Text(
                          isLogin ? "Welcome Back" : "Create an Account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25),
                        if (!isLogin)
                          _buildTextField(
                              "Full Name", nameController, Icons.person),
                        if (!isLogin)
                          _buildTextField(
                              "Phone Number", phoneController, Icons.phone),
                        _buildTextField("Email", emailController, Icons.email),
                        _buildTextField(
                            "Password", passwordController, Icons.lock,
                            isObscure: true),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: handleAuth,
                          child: Text(isLogin ? "Sign In" : "Sign Up"),
                        ),
                        TextButton(
                          onPressed: toggleMode,
                          child: Text(isLogin
                              ? "Create an account"
                              : "Already have an account? Sign In"),
                        ),
                        Row(children: [
                          Expanded(
                              child: Divider(
                                  color: const Color.fromARGB(
                                      255, 133, 133, 133))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 133, 133, 133))),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: handleGoogleSignIn,
                          child: Image.asset('assets/images/google.png',
                              height: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isObscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: Colors.teal),
          prefixIcon: Icon(icon),
          fillColor: const Color.fromARGB(172, 245, 245, 245),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: const Color.fromARGB(
                      255, 221, 221, 221))), // Border color when not focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.teal, width: 2), // Border color when focused
          ),
        ),
      ),
    );
  }
}
