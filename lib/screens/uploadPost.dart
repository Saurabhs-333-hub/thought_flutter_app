import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/utils/utils.dart';

class UploadPost extends StatefulWidget {
  const UploadPost({super.key});

  @override
  State<UploadPost> createState() => _UploadPostState();
}

bool isLoading = false;
double updatedfont = 20.0;
String updatedvalue = "";
Uint8List? _file;
late Color _color1 = Color.fromARGB(255, 0, 0, 0);
late Color _color2 = Color.fromARGB(255, 0, 0, 0);
late Color color3 = Color.fromARGB(125, 255, 255, 255);
final TextEditingController _textInputController = TextEditingController();
final TextEditingController creatorText = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
ScreenshotController screenshotController = ScreenshotController();

class _UploadPostState extends State<UploadPost> {
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

  void postImage(
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().uploadPost(_textInputController.text.trim(),
          _file!, uid, username, profilePic, email);
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

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                    _selectImage(context);
                  },
                  child: isLoading == true
                      ? CircularProgressIndicator()
                      : Text("Choose Image"),
                ),
              ),
            ),
            SizedBox(
              height: 600,
              child: _file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!), fit: BoxFit.cover)),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.8,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            gradient: _color1 == null || _color2 == null
                                ? LinearGradient(
                                    colors: [Colors.black, Colors.black])
                                : LinearGradient(colors: [_color1, _color2])),
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
                    postImage(
                      user!.uid,
                      user.username,
                      user.profilePic,
                      user.email,
                    );
                  },
                  child: isLoading == true
                      ? CircularProgressIndicator()
                      : Text("Upload Post"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
