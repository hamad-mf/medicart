import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Controller/login_screen_controller.dart';
import 'package:medicart/Controller/product_adding_screen_controller.dart';
import 'package:medicart/Controller/profile_selection_controller.dart';
import 'package:medicart/Controller/registration_screen_controller.dart';

import 'package:medicart/View/Common%20Screens/Splash%20Screen/splash_screen.dart';
import 'package:medicart/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegistrationScreenController(),),
        ChangeNotifierProvider(create: (context) => LoginScreenController(),),
        ChangeNotifierProvider(create: (context) => ProductAddingScreenController(),),
        ChangeNotifierProvider(create: (context) => ProfileSelectionController(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
