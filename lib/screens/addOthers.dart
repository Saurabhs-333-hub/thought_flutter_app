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
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';

class AddOthers extends StatefulWidget {
  const AddOthers({super.key});

  @override
  State<AddOthers> createState() => AddOthersState();
}

class AddOthersState extends State<AddOthers> {
  Uint8List? _file;
  final TextEditingController _textInputController = TextEditingController();
  bool isLoading = false;

  String? value;
  double? updatedvalue;
  String? updatedfont;
  String? updatedUpload;
  String? updatedTextStyle;

  late Color _color1 = Color.fromARGB(255, 0, 0, 0);
  late Color _color2 = Color.fromARGB(255, 0, 0, 0);
  late Color color3 = Color.fromARGB(125, 255, 255, 255);
  final _controller = CircleColorPickerController();
  // void postImage(String uid, String username, String profilePic, String email,
  //     String size, String font) async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await FirestoreMethods().uploadPost(_textInputController.text.trim(),
  //         _file!, uid, username, profilePic, email, size, font);
  //     // if (res == 'success') {
  //     //   showSnackBar(context, "success");
  //     // } else {
  //     //   showSnackBar(context, res);
  //     // }
  //     setState(() {
  //       isLoading = false;
  //       _file = null;
  //       _textInputController.text = "";
  //     });
  //     showSnackBar(context, 'success');
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  void factImage(
      String uid,
      String username,
      String profilePic,
      String email,
      String size,
      String font,
      String color1,
      String color2,
      String color3) async {
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
          font,
          color1,
          color2,
          color3);
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
        description: Text("Your Fact is Posted....",
            style: TextStyle(color: Colors.black)),
        borderRadius: 40,
      ).show(context);
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
          size,
          font,
          color1,
          color2);
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
        description: Text("Your Story is Posted....",
            style: TextStyle(color: Colors.black)),
        borderRadius: 40,
      ).show(context);
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
    final List<String> google = ['1', '2', '3', '4'];
    // String? value;
    return Scaffold(
      appBar: AppBar(
          title: Text("AddOthers"),
          backgroundColor: Colors.transparent,
          actions: [
            // SizedBox(
            //   child: DropdownButton<String>(
            //     // alignment: Alignment.topCenter,
            //     // isExpanded: true,
            //     items: google.map(buildItem).toList(),
            //     value: value,
            //     onChanged: (value) => {
            //       setState(() => {
            //             this.value = value,
            //             updatedTextStyle = value,
            //             print(updatedTextStyle)
            //           }),
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(40))),
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
                                        items: items.map(buildItem).toList(),
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
                                        items:
                                            fontStyle.map(buildItem).toList(),
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
                                      onPressed: () => showModalBottomSheet(
                                        // enableDrag: true,
                                        isScrollControlled: true,
                                        barrierColor:
                                            Color.fromARGB(58, 7, 7, 255),
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                              setState(() {
                                                        _color1 = color;
                                                      }),
                                                      pickerColor: Colors.black,
                                                      colorPickerWidth: 200,
                                                      pickerAreaBorderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      paletteType: PaletteType
                                                          .rgbWithBlue,
                                                      enableAlpha: true,
                                                      // showLabel: true,
                                                      // size: Size(240, 240),
                                                      // thumbSize: 40,
                                                      // strokeWidth: 2,
                                                    ),
                                                  ),
                                                  Text(_color1.toString()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text("Color1"),
                                    ),
                                    CupertinoButton(
                                      onPressed: () => showModalBottomSheet(
                                        // enableDrag: true,
                                        isScrollControlled: true,
                                        barrierColor:
                                            Color.fromARGB(58, 7, 7, 255),
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                              setState(() {
                                                        _color2 = color;
                                                      }),
                                                      pickerColor: Colors.black,
                                                      colorPickerWidth: 200,
                                                      pickerAreaBorderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      paletteType: PaletteType
                                                          .rgbWithBlue,
                                                      enableAlpha: true,
                                                      // showLabel: true,
                                                      // size: Size(240, 240),
                                                      // thumbSize: 40,
                                                      // strokeWidth: 2,
                                                    ),
                                                  ),
                                                  Text(_color1.toString()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text("Color2"),
                                    ),
                                    CupertinoButton(
                                      onPressed: () => showModalBottomSheet(
                                        // enableDrag: true,
                                        isScrollControlled: true,
                                        barrierColor:
                                            Color.fromARGB(58, 7, 7, 255),
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                              setState(() {
                                                        color3 = color;
                                                      }),
                                                      pickerColor: Colors.black,
                                                      colorPickerWidth: 200,
                                                      pickerAreaBorderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      paletteType: PaletteType
                                                          .rgbWithBlue,
                                                      enableAlpha: true,
                                                      // showLabel: true,
                                                      // size: Size(240, 240),
                                                      // thumbSize: 40,
                                                      // strokeWidth: 2,
                                                    ),
                                                  ),
                                                  Text(color3.toString()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text("Text Color"),
                                    )
                                  ],
                                ),
                              ],
                            )));
                      });
                },
                child: Icon(Icons.arrow_circle_down)),
          ]),
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
                              image:
                                  DecorationImage(image: MemoryImage(_file!))),
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
                        labelStyle: GoogleFonts.playfairDisplaySc(),
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
                            decorationColor: primaryColor, color: color3)
                        : TextStyle(
                            decorationColor: primaryColor,
                            color: color3,
                            fontSize: updatedvalue,
                            letterSpacing: google == '2' ? 20.0 : 10.0,
                            fontStyle: updatedfont == 'FontStyle.italic'
                                ? FontStyle.italic
                                : FontStyle.normal)),
              )),
            ]),
            Expanded(
              child: Row(
                children: [
                  Column(
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
                              factImage(
                                  user!.uid,
                                  user.username,
                                  user.profilePic,
                                  user.email,
                                  updatedvalue.toString(),
                                  updatedfont.toString(),
                                  _color1.toString(),
                                  _color2.toString(),
                                  color3.toString());
                            },
                            child: isLoading == true
                                ? CircularProgressIndicator()
                                : Text("Upload Fact"),
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
                            splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Color.fromARGB(0, 255, 193, 7),
                            hoverColor: Color.fromARGB(0, 255, 193, 7),
                            onTap: () {
                              storyImage(
                                  user!.uid,
                                  user.username,
                                  user.profilePic,
                                  user.email,
                                  updatedvalue.toString(),
                                  updatedfont.toString(),
                                  _color1.toString(),
                                  _color2.toString());
                            },
                            child: isLoading == true
                                ? CircularProgressIndicator()
                                : Text("Upload Story"),
                          ),
                        ),
                      ),
                      // CupertinoButton(
                      //     child: isLoading == true
                      //         ? CircularProgressIndicator()
                      //         : Text("Upload Poem"),
                      //     onPressed: () {
                      //       storyImage(
                      //           user!.uid,
                      //           user.username,
                      //           user.profilePic,
                      //           user.email,
                      //           updatedvalue.toString(),
                      //           updatedfont.toString());
                      //     }),
                    ],
                  ),
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
