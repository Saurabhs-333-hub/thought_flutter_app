// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thought/responsive/mobileScreen.dart';
import 'package:thought/responsive/responsive_layout_screen.dart';
import 'package:thought/responsive/webScreen.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/responsive/mobileScreen.dart';
import 'package:thought/responsive/responsive_layout_screen.dart';
import 'package:thought/responsive/webScreen.dart';
import 'package:thought/screens/loginScreen.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "Android App",
    options: FirebaseOptions(
      apiKey: "AIzaSyAjU9_G6Cds-MZuF862rbwGR0MBsm3YYCw",
      storageBucket: "thoughts-e8b6e.appspot.com",
      appId: "1:808333496897:web:2987d8977d876a9e4a6cc0",
      messagingSenderId: "808333496897",
      projectId: "thoughts-e8b6e",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(create: (_) {
            return UserProvider();
          })
        ],
        builder: (context, child) {
          // No longer throws
          return MaterialApp(
              title: 'Thoughts',
              theme: ThemeData.dark()
                  .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
              // home: ResponsiveLayout(
              //     mobileScreenLayout: MobileScreenLayout(),
              //     webScreenLayout: WebScreenLayout()),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ResponsiveLayout(
                          webScreenLayout: WebScreenLayout(),
                          mobileScreenLayout: MobileScreenLayout());
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}"));
                      } else {
                        // return showSnackBar(context, "success");
                      }
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  return LoginScreen();
                },
              ));
        });
  }
}
