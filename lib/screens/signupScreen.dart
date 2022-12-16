// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thought/resources/authMethods.dart';
import 'package:thought/responsive/mobileScreen.dart';
import 'package:thought/responsive/responsive_layout_screen.dart';
import 'package:thought/responsive/webScreen.dart';
import 'package:thought/screens/loginScreen.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
      print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://source.unsplash.com/random"),
                          ),
                    IconButton(
                        icon: Icon(Icons.image_rounded), onPressed: selectImage)
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextFieldInput(
                  hintText: "Enter Your Username",
                  textEditingController: _usernameController,
                  textInputType: TextInputType.name,
                  isPass: false,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFieldInput(
                  hintText: "Enter Your Bio",
                  textEditingController: _bioController,
                  textInputType: TextInputType.multiline,
                  isPass: false,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFieldInput(
                  hintText: "Enter Your Email",
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  isPass: false,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFieldInput(
                  hintText: "Enter Your Password",
                  textEditingController: _passwordController,
                  textInputType: TextInputType.emailAddress,
                  isPass: true,
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    String res = await AuthMethods().signUpUser(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        username: _usernameController.text.trim(),
                        bio: _bioController.text.trim(),
                        file: _image!);
                    setState(() {
                      loading = false;
                    });
                    if (res != 'success') {
                      showSnackBar(context, res);
                    } else {
                      showSnackBar(context, "success");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => ResponsiveLayout(
                              webScreenLayout: WebScreenLayout(),
                              mobileScreenLayout: MobileScreenLayout()))));
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  splashColor: secondaryColor,
                  child: Container(
                      width: 60,
                      height: 76,
                      child: loading
                          ? Center(child: CircularProgressIndicator())
                          : Center(child: Text("Sign Up"))),
                ),
                Row(
                  children: [
                    Text("Already have an Account?"),
                    CupertinoButton(
                        child: Text("Sign in"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        })
                  ],
                )
              ],
            )),
      )),
    );
  }
}
