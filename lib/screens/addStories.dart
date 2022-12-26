// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';

class AddStories extends StatefulWidget {
  const AddStories({super.key});

  @override
  State<AddStories> createState() => _AddStoriesState();
}

class _AddStoriesState extends State<AddStories> {
  Uint8List? _file;
  final TextEditingController _textInputController = TextEditingController();
  bool isLoading = false;

  String? value;
  double? updatedvalue;
  String? updatedfont;
  void postImage(String uid, String username, String profilePic, String email,
      String size) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadPost(_textInputController.text.trim(),
          _file!, uid, username, profilePic, email, size);
      // if (res == 'success') {
      //   showSnackBar(context, "success");
      // } else {
      //   showSnackBar(context, res);
      // }
      setState(() {
        isLoading = false;
        _file = null;
        _textInputController.text = "";
      });
      showSnackBar(context, 'success');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void factImage(String uid, String username, String profilePic, String email,
      String size, String font) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadFact(
          _textInputController.text.trim(),
          // _file!,
          uid,
          username,
          profilePic,
          email,
          size,
          font);
      // if (res == 'success') {
      //   showSnackBar(context, "success");
      // } else {
      //   showSnackBar(context, res);
      // }
      setState(() {
        isLoading = false;
        _file = null;
        _textInputController.text = "";
      });
      showSnackBar(context, 'success');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        backgroundColor: primaryColor,
        constraints: BoxConstraints(maxHeight: 200),
        context: context,
        builder: (context) {
          return Center(
            child: SizedBox(
              child: Column(
                children: [
                  InkWell(
                    child: Text(
                      "Take a Photo",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Uint8List file = await pickImage(ImageSource.camera);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                  Divider(),
                  InkWell(
                    child: Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Uint8List file = await pickImage(ImageSource.gallery);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                ],
              ),
              // width: 400,
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    final List<String> items = [
      '10',
      '12',
      '14',
      '16',
      '18',
      '20',
      '22',
      '24',
    ];
    final List<String> fontStyle = [
      'italic',
      'normal',
    ];
    // String? value;
    return Scaffold(
      appBar: AppBar(title: Text("AddStories"), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.add_circle_rounded),
            onPressed: () {
              _selectImage(context);
            },
          ),
        ),
      ]),
      body: Column(
        children: [
          SizedBox(
            child: _file != null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: MemoryImage(_file!))),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://source.unsplash.com/random"))),
                  ),
          ),
          Divider(height: 20, color: Colors.white, thickness: 1),
          Expanded(
              child: SizedBox(
            child: TextField(
                autocorrect: true,
                autofocus: true,
                cursorColor: Colors.white,
                controller: _textInputController,
                maxLines: 100,
                textAlign: TextAlign.center,
                scrollPhysics: BouncingScrollPhysics(),
                decoration: InputDecoration(
                    label: Text("Write Your Story, Poem, Quote Or Thought"),
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    alignLabelWithHint: false,
                    // focusColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 20,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20))),
                style: value == null
                    ? TextStyle(
                        decorationColor: primaryColor,
                      )
                    : TextStyle(
                        decorationColor: primaryColor,
                        fontSize: updatedvalue,
                      )),
          )),
          Expanded(
            child: Row(
              children: [
                CupertinoButton(
                    child: isLoading == true
                        ? CircularProgressIndicator()
                        : Text("Upload Post"),
                    onPressed: () {
                      postImage(user!.uid, user.username, user.profilePic,
                          user.email, updatedvalue.toString());
                    }),
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40))),
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints(maxHeight: 400),
                          context: context,
                          builder: (context) {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 47, 33, 243),
                                          Color.fromARGB(255, 208, 0, 255)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter)),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: DropdownButton<String>(
                                            // alignment: Alignment.topCenter,
                                            // isExpanded: true,
                                            items:
                                                items.map(buildItem).toList(),
                                            value: value,
                                            onChanged: (value) => {
                                              setState(() => {
                                                    this.value = value,
                                                    updatedvalue =
                                                        double.tryParse(value!),
                                                  }),
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          child: DropdownButton<String>(
                                            // alignment: Alignment.topCenter,
                                            // isExpanded: true,
                                            items: fontStyle
                                                .map(buildItem)
                                                .toList(),
                                            value: value,
                                            onChanged: (value) => {
                                              setState(() => {
                                                    this.value = value,
                                                    updatedfont = value,
                                                  }),
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )));
                          });
                    },
                    child: Icon(Icons.arrow_circle_down)),
                CupertinoButton(
                    child: isLoading == true
                        ? CircularProgressIndicator()
                        : Text("Upload Fact"),
                    onPressed: () {
                      factImage(user!.uid, user.username, user.profilePic,
                          user.email, updatedvalue.toString(), updatedfont!);
                    }),
                // CupertinoButton(
                //     child: isLoading == true
                //         ? CircularProgressIndicator()
                //         : Text("Upload Story"),
                //     onPressed: () {
                //       factImage(user!.uid, user.username, user.profilePic,
                //           user.email, updatedvalue.toString());
                //     }),
                // CupertinoButton(
                //     child: isLoading == true
                //         ? CircularProgressIndicator()
                //         : Text("Upload Poem"),
                //     onPressed: () {
                //       factImage(user!.uid, user.username, user.profilePic,
                //           user.email, updatedvalue.toString());
                //     }),
              ],
            ),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        '$item',
        style: TextStyle(color: Colors.amber),
      ));
  // DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
  //     value: item,
  //     child: Text(
  //       '$item',
  //       style: TextStyle(color: Colors.amber),
  //     ));
}
