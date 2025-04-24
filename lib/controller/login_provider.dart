import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/view/screens/home/home_screen.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool get isLogin => _isLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  
  void toggleLoginMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
  
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
  
  Future<void> handleAuth(
    BuildContext context,
    GoogleSignInProvider authProvider,
    ProfileProvider profileProvider,
    FireBaseContactsProvider contactsProvider,
    FireBaseOnetoonechatProvider chatProvider
  ) async {
    if (!formKey.currentState!.validate()) return;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    try {
      if (_isLogin) {
        await authProvider.signIn(email, password, profileProvider, contactsProvider, chatProvider);
      } else {
        await authProvider.signUp(name, phone, email, password, profileProvider, contactsProvider, chatProvider);
      }
      
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
    }
  }
  
  Future<void> handleGoogleSignIn(
    BuildContext context,
    GoogleSignInProvider authProvider,
    ProfileProvider profileProvider,
    FireBaseContactsProvider contactsProvider,
    FireBaseOnetoonechatProvider chatProvider
  ) async {
    try {
      User? user = await authProvider.signInWithGoogle(profileProvider, contactsProvider, chatProvider);
      if (user != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
    }
  }
  
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(
            color: Color.fromARGB(255, 244, 67, 54),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.teal)),
          ),
        ],
        backgroundColor: const Color.fromARGB(239, 248, 247, 247),
      ),
    );
  }
  
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}