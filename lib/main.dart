// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wtsp_clone/controller/chat_controller.dart';
// import 'package:wtsp_clone/controller/contact_provider.dart';
// import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
// import 'package:wtsp_clone/controller/home_provider.dart';
// import 'package:wtsp_clone/controller/onetoone_chat_provider.dart';
// import 'package:wtsp_clone/controller/profile_provider.dart';
// import 'package:wtsp_clone/presentation/screens/splash/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   //await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//   runApp(WhatsAppClone());
// }

// class WhatsAppClone extends StatelessWidget {
//   const WhatsAppClone({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ContactsProvider()),
//         ChangeNotifierProvider(create: (context) => HomeProvider()),
//         ChangeNotifierProvider(
//           create: (context) => OnetoonechatProvider(
//             contactId: "123",
//             chatController: ChatController(),
//           ),
//         ),
//         ChangeNotifierProvider(create: (context) => ProfileProvider()),
//         //ChangeNotifierProvider(create: (_) => AuthPhoneProvider()),
//         ChangeNotifierProvider(create: (context) => GoogleSignInProvider())
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'WhatsApp Clone',
//         theme: ThemeData(
//           primaryColor: Colors.teal,
//           scaffoldBackgroundColor: Colors.white,
//         ),
//         home: SplashScreen(),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/chat_controller.dart';
import 'package:wtsp_clone/controller/contact_provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/controller/onetoone_chat_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/presentation/screens/home/home_screen.dart';
import 'package:wtsp_clone/presentation/screens/login/login_screen.dart';
import 'package:wtsp_clone/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(WhatsAppClone());
}

class WhatsAppClone extends StatelessWidget {
  const WhatsAppClone({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactsProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(
          create: (context) => OnetoonechatProvider(
            contactId: "123",
            chatController: ChatController(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Clone',
        theme: ThemeData(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: AuthCheck(), // Auth state check
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // Show splash screen while checking auth state
        } else if (snapshot.hasData) {
          return HomeScreen(); // User is logged in, go to home
        } else {
          return LoginScreen(); // User is logged out, go to login
        }
      },
    );
  }
}
