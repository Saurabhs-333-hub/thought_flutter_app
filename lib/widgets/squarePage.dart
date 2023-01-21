// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:thought/models/ImageInfo.dart';
import 'package:thought/models/TextInfo.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/screens/addOthers.dart';
import 'package:thought/screens/uploadPost.dart';
import 'package:thought/screens/uploadQuoteSuggestions.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/requestPermission.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/addText.dart';
import 'package:thought/widgets/imageText.dart';
import 'package:http/http.dart' as http;

late String resp;
Future<Fonts> googleFonts() async {
  final response = await http.get(Uri.parse(
      'https://www.googleapis.com/webfonts/v1/webfonts?key=AIzaSyAdg9aOi64GIzE0lxu4hvsSs5KfKSAEScs'));
  // print(response.body);
  // var list = json.decode(response.body).toString();
  // print(list as List);
  resp = response.body;
  // print(resp);
  if (response.statusCode == 200) {
    return Fonts.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Fonts {
  final String kind;
  final String items;
  final String family;

  Fonts({required this.kind, required this.items, required this.family});

  factory Fonts.fromJson(Map<String, dynamic> json) {
    return Fonts(
      kind: json['kind'],
      items: json['items'],
      family: json['items']['family'],
    );
  }
}

class ImageMaker1 extends StatefulWidget {
  // final String uid;
  const ImageMaker1({super.key});

  @override
  State<ImageMaker1> createState() => _ImageMaker1State();
}

class _ImageMaker1State extends State<ImageMaker1> {
  late Future<Fonts> googleFont;
  Uint8List? _file;
  List<ImageInfo1> _file1 = [];
  String file = 'sdfgbgfgdfgdf';
  int optionSelected = 0;
  bool selected = true;
  void checkOption(int index) {
    optionSelected = index;
    // print(optionSelected);
    // print(selected);
  }

  int index = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkOption(index);
    googleFont = googleFonts();
  }

  final TextEditingController _textInputController = TextEditingController();
  final TextEditingController creatorText = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();
  List<Map<String, dynamic>> images = [];
  late Color _color1 = Color.fromARGB(255, 0, 0, 0);
  late Color _color2 = Color.fromARGB(255, 0, 0, 0);
  late Color color3 = Color.fromARGB(125, 255, 255, 255);
  DraggableScrollableController scrollController =
      DraggableScrollableController();
  List<TextInfo> texts = [];
  int currentIndex = 0;
  int currentIndexImage = 0;
  Uint8List? image;
  saveToGallery(BuildContext context) {
    if (texts.isNotEmpty || texts.isEmpty) {
      screenshotController.capture().then((image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery.'),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  // var googleFont = GoogleFonts.getFont('Fira Sans');
  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  showSheet() {
    showModalBottomSheet(
        elevation: 0,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        backgroundColor: Colors.transparent,
        // constraints: BoxConstraints(maxHeight: 400),
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          // _color1.withOpacity(1),
                          // _color2.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
                child: Center(
                    child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  // crossAxisCount: 2,
                  children: [
                    CupertinoButton(
                      onPressed: () => showModalBottomSheet(
                        // enableDrag: true,
                        isScrollControlled: true,
                        barrierColor: Color.fromARGB(58, 7, 7, 255),
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
                                      onColorChanged: (Color color) =>
                                          setState(() {
                                        _color1 = color;
                                      }),
                                      pickerColor: Colors.black,
                                      colorPickerWidth: 200,
                                      pickerAreaBorderRadius:
                                          BorderRadius.circular(40),
                                      paletteType: PaletteType.rgbWithBlue,
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
                        barrierColor: Color.fromARGB(58, 7, 7, 255),
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
                                      onColorChanged: (Color color) =>
                                          setState(() {
                                        _color2 = color;
                                      }),
                                      pickerColor: Colors.black,
                                      colorPickerWidth: 200,
                                      pickerAreaBorderRadius:
                                          BorderRadius.circular(40),
                                      paletteType: PaletteType.rgbWithBlue,
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
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Increase Text Size",
                        onPressed: () {
                          increaseFontSize();
                        },
                        icon: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(118, 0, 0, 0),
                                borderRadius: BorderRadius.circular(60)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Icon(Icons.text_increase_rounded),
                            ))),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Decrease Text Size",
                        onPressed: () {
                          decreaseFontSize();
                        },
                        icon: Icon(Icons.text_decrease_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Align Left",
                        onPressed: () {
                          alignLeft();
                        },
                        icon: Icon(Icons.align_horizontal_left_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Align Center",
                        onPressed: () {},
                        icon: Icon(Icons.align_horizontal_center_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Align Right",
                        onPressed: () {
                          alignRight();
                        },
                        icon: Icon(Icons.align_horizontal_right_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Bold",
                        onPressed: () {
                          boldText();
                        },
                        icon: Icon(Icons.format_bold_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Italic",
                        onPressed: () {
                          italicText();
                        },
                        icon: Icon(Icons.format_italic_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Delete",
                        onPressed: () {
                          removeText();
                        },
                        icon: Icon(Icons.delete_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Save",
                        onPressed: () {
                          saveToGallery(context);
                        },
                        icon: Icon(Icons.save_alt_rounded)),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.amber),
                            elevation: MaterialStateProperty.all(20)),
                        tooltip: "Format",
                        onPressed: () {
                          addLinesToText();
                        },
                        icon: Icon(Icons.space_bar_rounded))
                  ],
                ))),
            controller: scrollController,
          );
        });
  }

  int index1 = 0;
  setCurrentIndexImage(BuildContext context, index) {
    setState(() {
      currentIndexImage = index1;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  changeIndexColor(BuildContext context, Color color) {
    setState(() {
      if (texts.isNotEmpty) texts[currentIndex].color = color;
    });
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  changeIndexImage(BuildContext context, String file, index) {
    List<int> list = utf8.encode(file);
    Uint8List bytes;
    index = index1;

    bytes = Uint8List.fromList(list);

    String outcome = utf8.decode(bytes);
    // _file1[i].file = bytes;
    _file1[currentIndex].file = bytes;
    print(_file1);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  increaseFontSize() {
    setState(() {
      if (texts.isNotEmpty)
        texts[currentIndex].fontSize = texts[currentIndex].fontSize += 2;
    });
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  decreaseFontSize() {
    setState(() {
      if (texts.isNotEmpty)
        texts[currentIndex].fontSize = texts[currentIndex].fontSize -= 2;
    });
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Selected For Styling")));
  }

  alignLeft() {
    setState(() {
      if (texts.isNotEmpty) texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      if (texts.isNotEmpty) texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      if (texts.isNotEmpty) texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts.isNotEmpty) {
        if (texts[currentIndex].fontWeight == FontWeight.bold) {
          texts[currentIndex].fontWeight = FontWeight.normal;
        } else {
          texts[currentIndex].fontWeight = FontWeight.bold;
        }
      }
    });
  }

  italicText() {
    setState(() {
      if (texts.isNotEmpty) {
        if (texts[currentIndex].fontStyle == FontStyle.italic) {
          texts[currentIndex].fontStyle = FontStyle.normal;
        } else {
          texts[currentIndex].fontStyle = FontStyle.italic;
        }
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts.isNotEmpty) {
        if (texts[currentIndex].text.contains('\n')) {
          texts[currentIndex].text =
              texts[currentIndex].text.replaceAll('\n', ' ');
        } else {
          texts[currentIndex].text =
              texts[currentIndex].text.replaceAll(' ', '\n');
        }
      }
    });
  }

  removeText() {
    setState(() {
      if (texts.isNotEmpty) texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  String? value;
  double? updatedvalue;
  String? updatedfont;
  String? updatedUpload;
  String? updatedTextStyle;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  final _controller = CircleColorPickerController();
  // void postImage(String uid, String username, String profilePic, String email,
  //     String size, String font) async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await FirestoreMethods().uploadPost(
  //       _textInputController.text.trim(),
  //       _file!,
  //       uid,
  //       username,
  //       profilePic,
  //       email,
  //     );
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
  //     CherryToast.success(
  //       // icon: Icons.,
  //       // themeColor: Color.fromARGB(255, 255, 255, 255),
  //       title: Text("Posted....", style: TextStyle(color: Colors.black)),
  //       toastPosition: Position.top,

  //       // autoDismiss:
  //       //     false,

  //       displayTitle: true,
  //       displayCloseButton: true,
  //       autoDismiss: true,
  //       // animationCurve:
  //       //     Cubic(
  //       //         40.0,
  //       //         20.0,
  //       //         40.0,
  //       //         20.0),
  //       animationType: AnimationType.fromLeft,
  //       displayIcon: true,
  //       // iconColor: Colors.red,
  //       // iconSize: 40,
  //       layout: ToastLayout.ltr,
  //       enableIconAnimation: true,
  //       description: Text("Your Post is Posted....",
  //           style: TextStyle(color: Colors.black)),
  //       borderRadius: 40,
  //     ).show(context);
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
      String textColor) async {
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

  // if (res == 'success') {
  //   showSnackBar(context, "success");
  // } else {
  //   showSnackBar(context, res);
  // }
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore.instance.collection('posts').get();

      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
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
                      try {
                        Uint8List file = await pickImage(ImageSource.gallery);
                        setState(() {
                          _file = file;
                        });
                      } catch (e) {
                        print(e.toString());
                      }
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

  addNewText() {
    setState(() {
      texts.add(TextInfo(
          text: _textInputController.text.trim(),
          left: 0,
          top: 0,
          color: color3,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.center));
    });
    Navigator.of(context).pop();
  }

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

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    // String? value;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("ImageMaker1"),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Tooltip(
                      message: "white",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.white),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.white)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "Black",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.black),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.black)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "amber",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.amber),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.amber)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "pink",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.pink),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.pink)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "red",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.red),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.red)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "green",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.green),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.green)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "blue",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.blue),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.blue)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "white",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.white),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.white)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "Black",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.black),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.black)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "amber",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.amber),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.amber)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "pink",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.pink),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.pink)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "red",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.red),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.red)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "green",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.green),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.green)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "blue",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.blue),
                          child: CircleAvatar(
                              maxRadius: 16, backgroundColor: Colors.blue)),
                    ),
                    Divider(
                      height: 10,
                      thickness: 4,
                      color: Colors.amber,
                      indent: 12,
                    ),
                    Tooltip(
                      message: "more colors",
                      child: GestureDetector(
                          onTap: () => changeIndexColor(context, Colors.blue),
                          child: Text("more....")),
                    )
                  ],
                ),
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: Stack(children: [
                SizedBox(
                  height: 400,
                  child: _file != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 400,
                            width: 400,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      : optionSelected != -1
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(children: [
                                Container(
                                    height: 400,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(file),
                                            opacity: 1,
                                            fit: BoxFit.cover))),
                              ]),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(children: [
                                Container(
                                    height: 400,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://source.unsplash.com/random'),
                                            opacity: 0,
                                            fit: BoxFit.cover))),
                                Container(
                                  height: 400,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      gradient:
                                          _color1 == null || _color2 == null
                                              ? LinearGradient(colors: [
                                                  Color.fromARGB(
                                                      168, 230, 230, 230),
                                                  Color.fromARGB(95, 46, 46, 46)
                                                ])
                                              : LinearGradient(
                                                  colors: [_color1, _color2])),
                                )
                              ]),
                            ),
                ),

                for (int i = 0; i < texts.length; i++)
                  Positioned(
                      left: texts[i].left,
                      top: texts[i].top,
                      child: GestureDetector(
                        onTap: () {
                          setCurrentIndex(context, i);
                          showSheet();
                        },
                        child: Draggable(
                            child: ImageText(textInfo: texts[i]),
                            feedback: ImageText(textInfo: texts[i]),
                            onDragEnd: (drag) {
                              final renderedBox =
                                  context.findRenderObject() as RenderBox;
                              Offset off =
                                  renderedBox.globalToLocal(drag.offset);
                              setState(() {
                                texts[i].top = off.dy;
                                texts[i].left = off.dx;
                              });
                            }),
                      )),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        child: Text(creatorText.text,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))
                    : SizedBox.shrink()
                // Divider(height: 20, color: Colors.white, thickness: 1),
                // Expanded(
                //     child: SizedBox(
                //   height: MediaQuery.of(context).size.height / 1.6,
                //   child: TextField(
                //       autocorrect: true,
                //       autofocus: true,
                //       cursorColor: Colors.white,
                //       controller: _textInputController,
                //       maxLines: 100,
                //       textAlign: TextAlign.center,
                //       scrollPhysics: BouncingScrollPhysics(),
                //       decoration: InputDecoration(
                //           label: Text("Write Your Story, Poem, Quote Or Thought"),
                //           labelStyle: TextStyle(color: Colors.white),
                //           floatingLabelAlignment: FloatingLabelAlignment.center,
                //           alignLabelWithHint: false,
                //           // focusColor: Colors.white,
                //           border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Colors.white,
                //                   width: 20,
                //                   style: BorderStyle.solid),
                //               borderRadius: BorderRadius.circular(20))),
                //       style: value == null
                //           ? GoogleFonts.poppins(
                //               decorationColor: primaryColor,
                //             )
                //           : GoogleFonts.poppins(
                //               decorationColor: primaryColor,
                //               fontSize: updatedvalue,
                //               fontStyle: updatedfont == 'FontStyle.italic'
                //                   ? FontStyle.italic
                //                   : FontStyle.normal)),
                // )),
              ]),
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
                    _selectImage(context);
                    optionSelected = -1;
                  },
                  child: Text("Choose Image"),
                ),
              ),
            ),
            isLoading
                ? SizedBox.shrink()
                : InkWell(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        builder: (context, scrollController) {
                          return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('quotePostSuggestions')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    !snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.data == null) {
                                  return Text("NO Data");
                                } else
                                  // ignore: curly_braces_in_flow_control_structures
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot snap =
                                          (snapshot.data! as dynamic)
                                              .docs[index];
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Container(
                                              // width: 60,
                                              // height: 60,
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 52, 52, 52),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                          ),
                                        );
                                      }
                                      return InkWell(
                                        onTap: () {
                                          checkOption(index);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            index == optionSelected;
                                            print(index == optionSelected);
                                            file = snap['postUrl'];
                                            print(file);
                                            _file = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            // height: 100,
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Container(
                                                      child: ClipRRect(
                                                        borderRadius: index ==
                                                                optionSelected
                                                            ? BorderRadius
                                                                .circular(100)
                                                            : BorderRadius
                                                                .circular(20),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              snap['postUrl']),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  index == optionSelected
                                                      ? Icon(Icons.check)
                                                      : SizedBox(
                                                          child: Text(
                                                              "Please Select"),
                                                        )
                                                ]),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                              });
                        },
                        controller: scrollController,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(66, 56, 56, 56)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Choose Image from Thoughts"),
                      ),
                    ),
                  ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              highlightColor: Color.fromARGB(0, 255, 193, 7),
              hoverColor: Color.fromARGB(0, 255, 193, 7),
              onTap: () {
                optionSelected = -1;
                showSheet();
              },
              child: Text("Options"),
            ),
            SizedBox(
                child: FutureBuilder<Fonts>(
                    future: googleFont,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(child: Text(resp[index].toString()));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    })),
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
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => UploadPost()));
                  },
                  child: isLoading == true
                      ? CircularProgressIndicator()
                      : Text("Checkout Image"),
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
                    showModalBottomSheet(
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        constraints: BoxConstraints(maxHeight: 800),
                        // anchorPoint: Offset(10000, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40))),
                        barrierColor: Color.fromARGB(75, 255, 255, 255),
                        backgroundColor: Color.fromARGB(102, 0, 0, 0),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.white,
                                  height: 40,
                                  thickness: 2,
                                  indent: 200,
                                  endIndent: 200,
                                ),
                                SizedBox(
                                  child: Text("Drag Down To Remove"),
                                  height: 40,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                  highlightColor:
                                      Color.fromARGB(0, 255, 193, 7),
                                  hoverColor: Color.fromARGB(0, 255, 193, 7),
                                  onTap: () {
                                    optionSelected = -1;
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(40))),
                                        backgroundColor: Colors.transparent,
                                        constraints:
                                            BoxConstraints(maxHeight: 400),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        _color1,
                                                        _color2
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end:
                                                          Alignment.topCenter)),
                                              child: Center(
                                                  child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: DropdownButton<
                                                            String>(
                                                          // alignment: Alignment.topCenter,
                                                          // isExpanded: true,
                                                          items: items
                                                              .map(buildItem)
                                                              .toList(),
                                                          value: value,
                                                          onChanged: (value) =>
                                                              {
                                                            setState(() => {
                                                                  this.value =
                                                                      value,
                                                                  updatedvalue =
                                                                      double.tryParse(
                                                                          value!),
                                                                }),
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: DropdownButton<
                                                            String>(
                                                          // alignment: Alignment.topCenter,
                                                          // isExpanded: true,
                                                          items: fontStyle
                                                              .map(buildItem)
                                                              .toList(),
                                                          value: value,
                                                          onChanged: (value) =>
                                                              {
                                                            setState(() => {
                                                                  this.value =
                                                                      value,
                                                                  updatedfont =
                                                                      value,
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
                                                          isScrollControlled:
                                                              true,
                                                          barrierColor:
                                                              Color.fromARGB(58,
                                                                  7, 7, 255),
                                                          context: context,
                                                          builder: (context) =>
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                // height: 400,
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          ColorPicker(
                                                                        // controller: _controller,
                                                                        onColorChanged:
                                                                            (Color color) =>
                                                                                setState(() {
                                                                          _color1 =
                                                                              color;
                                                                        }),
                                                                        pickerColor:
                                                                            Colors.black,
                                                                        colorPickerWidth:
                                                                            200,
                                                                        pickerAreaBorderRadius:
                                                                            BorderRadius.circular(40),
                                                                        paletteType:
                                                                            PaletteType.rgbWithBlue,
                                                                        enableAlpha:
                                                                            true,
                                                                        // showLabel: true,
                                                                        // size: Size(240, 240),
                                                                        // thumbSize: 40,
                                                                        // strokeWidth: 2,
                                                                      ),
                                                                    ),
                                                                    Text(_color1
                                                                        .toString()),
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
                                                          isScrollControlled:
                                                              true,
                                                          barrierColor:
                                                              Color.fromARGB(58,
                                                                  7, 7, 255),
                                                          context: context,
                                                          builder: (context) =>
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                // height: 400,
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          ColorPicker(
                                                                        // controller: _controller,
                                                                        onColorChanged:
                                                                            (Color color) =>
                                                                                setState(() {
                                                                          _color2 =
                                                                              color;
                                                                        }),
                                                                        pickerColor:
                                                                            Colors.black,
                                                                        colorPickerWidth:
                                                                            200,
                                                                        pickerAreaBorderRadius:
                                                                            BorderRadius.circular(40),
                                                                        paletteType:
                                                                            PaletteType.rgbWithBlue,
                                                                        enableAlpha:
                                                                            true,
                                                                        // showLabel: true,
                                                                        // size: Size(240, 240),
                                                                        // thumbSize: 40,
                                                                        // strokeWidth: 2,
                                                                      ),
                                                                    ),
                                                                    Text(_color1
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text("Color2"),
                                                      ),
                                                      CupertinoButton(
                                                        onPressed: () =>
                                                            showModalBottomSheet(
                                                          // enableDrag: true,
                                                          isScrollControlled:
                                                              true,
                                                          barrierColor:
                                                              Color.fromARGB(58,
                                                                  7, 7, 255),
                                                          context: context,
                                                          builder: (context) =>
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                // height: 400,
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          ColorPicker(
                                                                        // controller: _controller,
                                                                        onColorChanged:
                                                                            (Color color) =>
                                                                                setState(() {
                                                                          color3 =
                                                                              color;
                                                                        }),
                                                                        pickerColor:
                                                                            Colors.black,
                                                                        colorPickerWidth:
                                                                            200,
                                                                        pickerAreaBorderRadius:
                                                                            BorderRadius.circular(40),
                                                                        paletteType:
                                                                            PaletteType.rgbWithBlue,
                                                                        enableAlpha:
                                                                            true,
                                                                        // showLabel: true,
                                                                        // size: Size(240, 240),
                                                                        // thumbSize: 40,
                                                                        // strokeWidth: 2,
                                                                      ),
                                                                    ),
                                                                    Text(color3
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        child:
                                                            Text("Text Color"),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip:
                                                              "Increase Text Size",
                                                          onPressed: () {
                                                            increaseFontSize();
                                                          },
                                                          icon: Icon(Icons
                                                              .text_increase_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip:
                                                              "Decrease Text Size",
                                                          onPressed: () {
                                                            decreaseFontSize();
                                                          },
                                                          icon: Icon(Icons
                                                              .text_decrease_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Align Left",
                                                          onPressed: () {
                                                            alignLeft();
                                                          },
                                                          icon: Icon(Icons
                                                              .align_horizontal_left_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip:
                                                              "Align Center",
                                                          onPressed: () {},
                                                          icon: Icon(Icons
                                                              .align_horizontal_center_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip:
                                                              "Align Right",
                                                          onPressed: () {
                                                            alignRight();
                                                          },
                                                          icon: Icon(Icons
                                                              .align_horizontal_right_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Bold",
                                                          onPressed: () {
                                                            boldText();
                                                          },
                                                          icon: Icon(Icons
                                                              .format_bold_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Italic",
                                                          onPressed: () {
                                                            italicText();
                                                          },
                                                          icon: Icon(Icons
                                                              .format_italic_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Delete",
                                                          onPressed: () {
                                                            removeText();
                                                          },
                                                          icon: Icon(Icons
                                                              .delete_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Save",
                                                          onPressed: () {
                                                            saveToGallery(
                                                                context);
                                                          },
                                                          icon: Icon(Icons
                                                              .save_alt_rounded)),
                                                      IconButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          tooltip: "Format",
                                                          onPressed: () {
                                                            addLinesToText();
                                                          },
                                                          icon: Icon(Icons
                                                              .space_bar_rounded))
                                                    ],
                                                  ),
                                                ],
                                              )));
                                        });
                                  },
                                  child: Text("Options"),
                                ),
                                Container(
                                  height: 400,
                                  child: SizedBox(
                                    height: 400,
                                    child: TextField(
                                        autocorrect: true,
                                        autofocus: true,
                                        cursorColor: Colors.white,
                                        controller: _textInputController,
                                        maxLines: 60,
                                        textAlign: TextAlign.center,
                                        scrollPhysics: BouncingScrollPhysics(),
                                        decoration: InputDecoration(
                                            label: Text(
                                                "Write Your Story, Poem, Quote Or Thought"),
                                            labelStyle:
                                                TextStyle(color: color3),
                                            floatingLabelAlignment:
                                                FloatingLabelAlignment.center,
                                            alignLabelWithHint: false,
                                            // focusColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 20,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        style: value == null
                                            ? GoogleFonts.poppins(
                                                decorationColor: primaryColor,
                                                color: color3)
                                            : GoogleFonts.poppins(
                                                decorationColor: primaryColor,
                                                color: color3,
                                                fontSize: updatedvalue,
                                                fontStyle: updatedfont ==
                                                        'FontStyle.italic'
                                                    ? FontStyle.italic
                                                    : FontStyle.normal)),
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
                                      highlightColor:
                                          Color.fromARGB(0, 255, 193, 7),
                                      hoverColor:
                                          Color.fromARGB(0, 255, 193, 7),
                                      onTap: () {
                                        addNewText();
                                      },
                                      child: isLoading == true
                                          ? CircularProgressIndicator()
                                          : Text("Add Text"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: isLoading == true
                      ? CircularProgressIndicator()
                      : Text("Add Text"),
                ),
              ),
            ),
          ]),
        ));
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
