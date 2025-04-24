import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/controller/login_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool isLogin = true;
//   final _formKey = GlobalKey<FormState>();
//   bool isPasswordVisible = false;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void toggleMode() {
//     setState(() => isLogin = !isLogin);
//   }

//   void handleAuth(
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) async {
//     if (!_formKey.currentState!.validate()) return;

//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String name = nameController.text.trim();
//     String phone = phoneController.text.trim();

//     try {
//       final authService =
//           Provider.of<GoogleSignInProvider>(context, listen: false);
//       if (isLogin) {
//         await authService.signIn(
//             email, password, profileProvider, contactsProvider, chatProvider);
//       } else {
//         await authService.signUp(name, phone, email, password, profileProvider,
//             contactsProvider, chatProvider);
//       }
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } catch (e) {
//       _showErrorDialog(e.toString().replaceFirst('Exception: ', ''));
//     }
//   }

//   void handleGoogleSignIn(
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) async {
//     final authService =
//         Provider.of<GoogleSignInProvider>(context, listen: false);
//     User? user = await authService.signInWithGoogle(
//         profileProvider, contactsProvider, chatProvider);
//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Error",
//             style: TextStyle(
//                 color: const Color.fromARGB(255, 244, 67, 54),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold)),
//         content: Text(message, style: TextStyle(fontSize: 16)),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("OK", style: TextStyle(color: Colors.teal)),
//           ),
//         ],
//         backgroundColor: const Color.fromARGB(239, 248, 247, 247),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final contactsProvider = Provider.of<FireBaseContactsProvider>(context);
//     final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);

//     return Stack(
//       children: [
//         _backGroundImage(),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: _loginForm(profileProvider, contactsProvider, chatProvider),
//         ),
//       ],
//     );
//   }

//   Positioned _backGroundImage() {
//     return Positioned.fill(
//       child: ImageFiltered(
//         imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//         child:
//             Image.asset("assets/images/loginBackground.jpg", fit: BoxFit.cover),
//       ),
//     );
//   }

//   SafeArea _loginForm(
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Icon(Icons.lock_outline, size: 80, color: Color(0xFF00A884)),
//                   SizedBox(height: 15),
//                   Text(
//                     isLogin ? "Welcome Back" : "Create an Account",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 25),
//                   if (!isLogin)
//                     _buildTextField(
//                         "Full Name", nameController, CupertinoIcons.person,
//                         validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Full Name is required";
//                       }
//                       return null;
//                     }),
//                   if (!isLogin)
//                     _buildTextField(
//                         "Phone Number", phoneController, CupertinoIcons.phone,
//                         isNumber: true, maxLength: 10, validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Phone Number is required";
//                       } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                         return "Enter a valid 10-digit phone number";
//                       }
//                       return null;
//                     }),
//                   _buildTextField("Email", emailController, CupertinoIcons.mail,
//                       validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Email is required";
//                     } else if (!RegExp(
//                             r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                         .hasMatch(value)) {
//                       return "Enter a valid email";
//                     }
//                     return null;
//                   }),
//                   _buildTextField(
//                       "Password", passwordController, CupertinoIcons.lock,
//                       isObscure: !isPasswordVisible,
//                       isPassword: true, validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Password is required";
//                     } else if (value.length < 6) {
//                       return "Password must be at least 6 characters";
//                     }
//                     return null;
//                   }),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => handleAuth(
//                         profileProvider, contactsProvider, chatProvider),
//                     child: Text(isLogin ? "Sign In" : "Sign Up"),
//                   ),
//                   TextButton(
//                     onPressed: toggleMode,
//                     child: Text(isLogin
//                         ? "Create an account"
//                         : "Already have an account? Sign In"),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(child: Divider(color: Colors.grey)),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text("OR", style: TextStyle(color: Colors.grey)),
//                       ),
//                       Expanded(child: Divider(color: Colors.grey)),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   GestureDetector(
//                     onTap: () => handleGoogleSignIn(
//                         profileProvider, contactsProvider, chatProvider),
//                     child: Image.asset('assets/images/google.png', height: 30),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, TextEditingController controller, IconData icon,
//       {bool isObscure = false,
//       bool isNumber = false,
//       bool isPassword = false,
//       int? maxLength,
//       String? Function(String?)? validator}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isObscure,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         maxLength: maxLength,
//         decoration: InputDecoration(
//           labelText: label,
//           floatingLabelStyle: TextStyle(color: Colors.teal),
//           prefixIcon: Icon(icon),
//           fillColor: Color.fromARGB(172, 245, 245, 245),
//           filled: true,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon:
//                       Icon(isObscure ? Icons.visibility_off : Icons.visibility),
//                   onPressed: () {
//                     setState(() {
//                       isPasswordVisible = !isPasswordVisible;
//                     });
//                   },
//                 )
//               : null,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.teal, width: 2),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final contactsProvider = Provider.of<FireBaseContactsProvider>(context);
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        _buildBackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildLoginForm(
            context, 
            loginProvider,
            authProvider, 
            profileProvider, 
            contactsProvider, 
            chatProvider
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Image.asset("assets/images/loginBackground.jpg", fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildLoginForm(
      BuildContext context,
      LoginProvider loginProvider,
      GoogleSignInProvider authProvider,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: loginProvider.formKey,
              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Color(0xFF00A884)),
                  const SizedBox(height: 15),
                  Text(
                    loginProvider.isLogin ? "Welcome Back" : "Create an Account",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  if (!loginProvider.isLogin)
                    _buildTextField(
                      "Full Name", 
                      loginProvider.nameController, 
                      CupertinoIcons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Full Name is required";
                        }
                        return null;
                      }
                    ),
                  if (!loginProvider.isLogin)
                    _buildTextField(
                      "Phone Number", 
                      loginProvider.phoneController, 
                      CupertinoIcons.phone,
                      isNumber: true, 
                      maxLength: 10, 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone Number is required";
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return "Enter a valid 10-digit phone number";
                        }
                        return null;
                      }
                    ),
                  _buildTextField(
                    "Email", 
                    loginProvider.emailController, 
                    CupertinoIcons.mail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    }
                  ),
                  _buildPasswordField(context, loginProvider),
                  const SizedBox(height: 20),
                  _buildAuthButton(
                    context,
                    loginProvider,
                    authProvider, 
                    profileProvider, 
                    contactsProvider, 
                    chatProvider
                  ),
                  TextButton(
                    onPressed: loginProvider.toggleLoginMode,
                    child: Text(loginProvider.isLogin 
                      ? "Create an account" 
                      : "Already have an account? Sign In"
                    ),
                  ),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  _buildGoogleSignInButton(
                    context,
                    loginProvider,
                    authProvider, 
                    profileProvider, 
                    contactsProvider, 
                    chatProvider
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
      String label, 
      TextEditingController controller, 
      IconData icon,
      {bool isObscure = false,
      bool isNumber = false,
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
          floatingLabelStyle: const TextStyle(color: Colors.teal),
          prefixIcon: Icon(icon),
          fillColor: const Color.fromARGB(172, 245, 245, 245),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
  
  Widget _buildPasswordField(BuildContext context, LoginProvider loginProvider) {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: provider.passwordController,
          obscureText: !provider.isPasswordVisible,
          decoration: InputDecoration(
            labelText: "Password",
            floatingLabelStyle: const TextStyle(color: Colors.teal),
            prefixIcon: const Icon(CupertinoIcons.lock),
            fillColor: const Color.fromARGB(172, 245, 245, 245),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(provider.isPasswordVisible 
                ? Icons.visibility 
                : Icons.visibility_off
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            } else if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("OR", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildAuthButton(
      BuildContext context,
      LoginProvider loginProvider,
      GoogleSignInProvider authProvider,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) {
    return ElevatedButton(
      onPressed: () => loginProvider.handleAuth(
        context, 
        authProvider, 
        profileProvider, 
        contactsProvider, 
        chatProvider
      ),
      child: Text(loginProvider.isLogin ? "Sign In" : "Sign Up"),
    );
  }

  Widget _buildGoogleSignInButton(
      BuildContext context,
      LoginProvider loginProvider,
      GoogleSignInProvider authProvider,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) {
    return GestureDetector(
      onTap: () => loginProvider.handleGoogleSignIn(
        context, 
        authProvider, 
        profileProvider, 
        contactsProvider, 
        chatProvider
      ),
      child: Image.asset('assets/images/google.png', height: 30),
    );
  }
}