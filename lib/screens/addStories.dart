// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/screens/addOthers.dart';
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
  String? updatedUpload;

  late Color _color1 = Color.fromARGB(255, 0, 0, 0);
  late Color _color2 = Color.fromARGB(255, 0, 0, 0);
  final _controller = CircleColorPickerController();
  void postImage(String uid, String username, String profilePic, String email,
      String size, String font) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadPost(
          _textInputController.text.trim(),
          _file!,
          uid,
          username,
          profilePic,
          email,
          _textInputController.text.trim());
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
      CherryToast.success(
        // icon: Icons.,
        // themeColor: Color.fromARGB(255, 255, 255, 255),
        title: Text("Posted....", style: TextStyle(color: Colors.black)),
        toastPosition: Position.top,

        // autoDismiss:
        //     false,

        displayTitle: true,
        displayCloseButton: true,
        autoDismiss: true,
        // animationCurve:
        //     Cubic(
        //         40.0,
        //         20.0,
        //         40.0,
        //         20.0),
        animationType: AnimationType.fromLeft,
        displayIcon: true,
        // iconColor: Colors.red,
        // iconSize: 40,
        layout: ToastLayout.ltr,
        enableIconAnimation: true,
        description: Text("Your Post is Posted....",
            style: TextStyle(color: Colors.black)),
        borderRadius: 40,
      ).show(context);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void factImage(
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadFact(
        _textInputController.text.trim(),
        _file!,
        uid,
        username,
        profilePic,
        email,
      );
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

  void storyImage(String uid, String username, String profilePic, String email,
      String size, String font, String color1, String color2) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadStory(
        _textInputController.text.trim(),
        // _file!,
        uid,
        username,
        profilePic,
        email,
      );
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
        backgroundColor: Color.fromARGB(95, 255, 255, 255),
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
    _controller.dispose();
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
    final List<String> upload = ['post', 'fact', 'story'];
    final List<String> fontStyle = [
      'FontStyle.italic',
      'FontStyle.normal',
    ];
    // String? value;
    return Scaffold(
      appBar: AppBar(
        title: Text("AddStories"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                child: _file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1.6,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.cover)),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1.6,
                          decoration: BoxDecoration(
                              gradient: _color1 == null || _color2 == null
                                  ? LinearGradient(
                                      colors: [Colors.black, Colors.black])
                                  : LinearGradient(colors: [_color1, _color2])),
                        ),
                      ),
              ),

              // Divider(height: 20, color: Colors.white, thickness: 1),
              Expanded(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
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
                        ? GoogleFonts.poppins(
                            decorationColor: primaryColor,
                          )
                        : GoogleFonts.poppins(
                            decorationColor: primaryColor,
                            fontSize: updatedvalue,
                            fontStyle: updatedfont == 'FontStyle.italic'
                                ? FontStyle.italic
                                : FontStyle.normal)),
              )),
            ]),
            Expanded(
                child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(66, 56, 56, 56)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Color.fromARGB(0, 255, 193, 7),
                      hoverColor: Color.fromARGB(0, 255, 193, 7),
                      onTap: () => _selectImage(context),
                      child: Text("Choose Image"),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(66, 56, 56, 56)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Color.fromARGB(0, 255, 193, 7),
                      hoverColor: Color.fromARGB(0, 255, 193, 7),
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
                                          colors: [_color1, _color2],
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
                                                          double.tryParse(
                                                              value!),
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
                                                      print(_color1)
                                                    }),
                                              },
                                            ),
                                          ),
                                          Divider(
                                            height: 40,
                                            thickness: 20,
                                            color: Colors.amber,
                                          ),
                                          CupertinoButton(
                                            onPressed: () =>
                                                showModalBottomSheet(
                                              // enableDrag: true,
                                              isScrollControlled: true,
                                              barrierColor:
                                                  Color.fromARGB(58, 7, 7, 255),
                                              context: context,
                                              builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: SizedBox(
                                                    // height: 400,
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: ColorPicker(
                                                            // controller: _controller,
                                                            onColorChanged:
                                                                (Color color) =>
                                                                    setState(
                                                                        () {
                                                              _color1 = color;
                                                            }),
                                                            pickerColor:
                                                                Colors.black,
                                                            colorPickerWidth:
                                                                200,
                                                            pickerAreaBorderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            paletteType:
                                                                PaletteType
                                                                    .rgbWithBlue,
                                                            enableAlpha: true,
                                                            // showLabel: true,
                                                            // size: Size(240, 240),
                                                            // thumbSize: 40,
                                                            // strokeWidth: 2,
                                                          ),
                                                        ),
                                                        Text(
                                                            _color1.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Text("Color1"),
                                          ),
                                          CupertinoButton(
                                            onPressed: () =>
                                                showModalBottomSheet(
                                              // enableDrag: true,
                                              isScrollControlled: true,
                                              barrierColor:
                                                  Color.fromARGB(58, 7, 7, 255),
                                              context: context,
                                              builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: SizedBox(
                                                    // height: 400,
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: ColorPicker(
                                                            // controller: _controller,
                                                            onColorChanged:
                                                                (Color color) =>
                                                                    setState(
                                                                        () {
                                                              _color2 = color;
                                                            }),
                                                            pickerColor:
                                                                Colors.black,
                                                            colorPickerWidth:
                                                                200,
                                                            pickerAreaBorderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            paletteType:
                                                                PaletteType
                                                                    .rgbWithBlue,
                                                            enableAlpha: true,
                                                            // showLabel: true,
                                                            // size: Size(240, 240),
                                                            // thumbSize: 40,
                                                            // strokeWidth: 2,
                                                          ),
                                                        ),
                                                        Text(
                                                            _color1.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Text("Color2"),
                                          )
                                        ],
                                      ),
                                    ],
                                  )));
                            });
                      },
                      child: Text("Options"),
                    ),
                  ),
                )
              ],
            )),
            Expanded(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(66, 56, 56, 56)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Color.fromARGB(0, 255, 193, 7),
                        hoverColor: Color.fromARGB(0, 255, 193, 7),
                        onTap: () {
                          postImage(
                              user!.uid,
                              user.username,
                              user.profilePic,
                              user.email,
                              updatedvalue.toString(),
                              updatedfont.toString());
                        },
                        child: isLoading == true
                            ? CircularProgressIndicator()
                            : Text("Upload Post"),
                      ),
                    ),
                  ),
                  CupertinoButton(
                      child: Text("Upload Others"),
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => AddOthers(),
                        ));
                      })
                ],
              ),
            )
          ],
        ),
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
