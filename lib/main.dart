import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/contact_provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/controller/navigation_service.dart';
import 'package:wtsp_clone/controller/onetoone_chat_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseController/select_contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/view/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WhatsAppClone());
}

class WhatsAppClone extends StatelessWidget {
  const WhatsAppClone({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FireBaseContactsProvider()),
        ChangeNotifierProvider(create: (context) => ContactsProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(
            create: (context) => OnetoonechatProvider(contactId: "123")),
        ChangeNotifierProvider(
          create: (context) {
            User? firebaseUser = FirebaseAuth.instance.currentUser;
            UserModel userModel = firebaseUser != null
                ? UserModel.fromFirebaseUser(firebaseUser)
                : UserModel(
                    uid: '',
                    firstName: 'Guest',
                    email: '',
                    photoURL: '',
                    phone: '');
            //print('userdetails ${userModel.firstName}');
            return FireBaseOnetoonechatProvider(user: userModel);
          },
        ),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => SelectContactProvider()),
        ChangeNotifierProvider(create: (context) => StatusProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Clone',
        theme: ThemeData(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
        ),
        navigatorKey: NavigationService.navigatorKey,
        home: SplashScreen(),
      ),
    );
  }
}
