// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreAdminMethods.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/postsCard.dart';

class UploadQuoteSuggestions extends StatefulWidget {
  final String uid;
  const UploadQuoteSuggestions({super.key, required this.uid});

  @override
  State<UploadQuoteSuggestions> createState() => _UploadQuoteSuggestionsState();
}

File? _file;
File? imageFile;
bool isLoading = false;

class _UploadQuoteSuggestionsState extends State<UploadQuoteSuggestions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getData();
    setState(() {
      isLoading = false;
    });
  }

  getData() async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      await FirebaseFirestore.instance.collection('quotePostSuggestions').get();
      // setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    // setState(() {
    //   isLoading = false;
    // });
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
                      File? file = await pickImage(ImageSource.camera);
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
                      final file = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      final __file = file;
                      imageFile = __file != null ? File(__file.path) : null;
                      setState(() {
                        // _file = file;
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

  Future _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return imageFile != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Image.file(imageFile!)),
                FloatingActionButton(
                  heroTag: "tag1",
                  onPressed: () {
                    _cropImage();
                  },
                  child: Icon(Icons.post_add),
                ),
                FloatingActionButton(
                  heroTag: "tag2",
                  onPressed: () {
                    _selectImage(context);
                  },
                  child: Icon(Icons.post_add),
                ),
                CupertinoButton(
                  onPressed: () async {
                    await FirestoreAdminMethods()
                        .uploadQuotePostSuggestionsPost(imageFile!, user!.uid,
                            user.username, user.profilePic, user.email);
                    print("uploaded");
                  },
                  child: Text("Upload"),
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('quotePostSuggestions')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.data == null) {
                        return Text("NO Data");
                      } else
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Container(
                                    // width: 60,
                                    // height: 60,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 52, 52, 52),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image: NetworkImage(snap['postUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    })
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
            children: [
              CircularProgressIndicator(),
              FloatingActionButton(
                heroTag: "tag1",
                onPressed: () {
                  _cropImage();
                },
                child: Icon(Icons.post_add),
              ),
              FloatingActionButton(
                heroTag: "tag2",
                onPressed: () {
                  _selectImage(context);
                },
                child: Icon(Icons.post_add),
              ),
            ],
          ));
  }
}
