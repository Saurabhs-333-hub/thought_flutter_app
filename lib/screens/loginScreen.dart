// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thought/resources/authMethods.dart';
import 'package:thought/responsive/mobileScreen.dart';
import 'package:thought/responsive/responsive_layout_screen.dart';
import 'package:thought/responsive/webScreen.dart';
import 'package:thought/screens/signupScreen.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  Future signIn() async {
    try {
      // showBottomSheet(
      //     backgroundColor: Colors.transparent,
      //     context: context,
      //     builder: (context) {
      //       return Center(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             color: Color.fromARGB(67, 165, 105, 255),
      //             borderRadius: BorderRadius.circular(60),
      //             backgroundBlendMode: BlendMode.color,
      //           ),
      //           height: 100,
      //           width: 100,
      //           child: Center(
      //             child: CircularProgressIndicator(
      //               backgroundColor: Color.fromARGB(255, 0, 0, 0),
      //               color: Color.fromARGB(255, 225, 0, 255),
      //             ),
      //           ),
      //         ),
      //       );
      //     });
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(), password: _password.text.trim());
      // Navigator.of(context).pop();
      print(FirebaseAuth.instance.currentUser!.email);
      // if (res.toString() == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: ((context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout()))));
      // }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 26, 26, 46),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 40.0,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // Text("Hello Again!",
                    //     style: GoogleFonts.bebasNeue(
                    //         fontSize: 36,
                    //         color: Color.fromARGB(255, 255, 255, 255))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(198, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 43, 41, 86)),

                      child: TextField(
                        controller: _email,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 16)),
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(198, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 43, 41, 86)),
                      child: TextField(
                        controller: _password,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 16)),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     CupertinoPageRoute(builder: (context) {
                          //   return ForgotPassword();
                          // }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Forgot Password?",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 0, 140, 255))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(161, 37, 37, 104),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text("Sign In",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color:
                                        Color.fromARGB(255, 255, 255, 255)))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account? ",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255))),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen())),
                          child: Text("Register Now!",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 0, 140, 255))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
