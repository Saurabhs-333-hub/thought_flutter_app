// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/screens/commentsScreen.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/likeAnimation.dart';
import 'package:uuid/uuid.dart';

class FactCard extends StatefulWidget {
  final snap;
  FactCard({required this.snap, super.key});

  @override
  State<FactCard> createState() => FactCardState();
}

class FactCardState extends State<FactCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('facts')
          .doc(widget.snap['factId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    // final FontStyle font = widget.snap['font'].split("");
    String x = widget.snap['font'];
    String z = widget.snap['color1'];
    String c = z.replaceAll('"', '');
    var b = c.replaceAll('Color(', '');
    var f = b.replaceAll(')', '');
    String z_ = widget.snap['color2'];
    String c_ = z_.replaceAll('"', '');
    var b_ = c_.replaceAll('Color(', '');
    var f_ = b_.replaceAll(')', '');
    String z__ = widget.snap['textColor'];
    String c__ = z__.replaceAll('"', '');
    var b__ = c__.replaceAll('Color(', '');
    var f__ = b__.replaceAll(')', '');
    // print(f);
    var color1 = int.parse(f);
    var color2 = int.parse(f_);
    var color3 = int.parse(f__);
    // String z__ = widget.snap['color1'];
    // String c__ = z__.replaceAll('"', '');
    // var b__ = c__.replaceAll('MaterialColor(primary value: Color(', '');
    // var f__ = b__.replaceAll('))', '');
    // var color_ = f__.replaceAll('Color(', '');
    // var color__ = color_.replaceAll(')', '');
    // // var color3 = int.parse(color__);
    // // print(color3);
    // String z___ = widget.snap['color2'];
    // String c___ = z___.replaceAll('"', '');
    // var b___ = c___.replaceAll('MaterialColor(primary value: Color(', '');
    // var f___ = b___.replaceAll('))', '');
    // var color___ = f___.replaceAll('Color(', '');
    // var color____ = color___.replaceAll(')', '');
    // var color4 = int.parse(color____);
    // var color4 = int.parse(f___);
    // print(a);
    // print(color4);
    var y = x.replaceAll('"', '');
    // print("$y");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // decoration: color1 != null || color2 != null
        //     ? BoxDecoration(
        //         borderRadius: BorderRadius.circular(40),
        //         gradient:
        //             LinearGradient(colors: [Color(color1), Color(color2)]))
        //     : BoxDecoration(
        //         borderRadius: BorderRadius.circular(40),
        //         gradient: LinearGradient(
        //             colors: [Colors.black, Colors.transparent])),
        padding: EdgeInsets.all(10),
        child: Column(children: [
          GlassmorphicContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.8,
            borderRadius: 26,
            blur: 7,
            border: 2,
            linearGradient: color1 != null || color2 != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Color(color1),
                        Color(color2)
                      ],
                    stops: [
                        0.1,
                        1,
                      ])
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Color(0xff3340ff),
                        Color.fromARGB(255, 255, 255, 255)
                      ],
                    stops: [
                        0.1,
                        1,
                      ]),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFffffff).withOpacity(0.5),
                Color.fromARGB(141, 255, 255, 255).withOpacity(0.5),
              ],
            ),
            child: Stack(children: [
              Stack(alignment: Alignment.bottomLeft, children: [
                Stack(alignment: Alignment.bottomRight, children: [
                  Container(
                    child: Center(
                      child: InkWell(
                        onDoubleTap: () {
                          FirestoreMethods().likePost(widget.snap['factId'],
                              user!.uid, widget.snap['likes']);
                          setState(() {
                            isLikeAnimating = true;
                          });
                        },
                        child: Stack(alignment: Alignment.center, children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: isLikeAnimating ? 1 : 0,
                            child: LikeAnimation(
                              child: Icon(Icons.favorite,
                                  color: Colors.white, size: 100),
                              isAnimating: isLikeAnimating,
                              duration: Duration(milliseconds: 400),
                              onEnd: () {
                                setState(() {
                                  isLikeAnimating = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(widget.snap['facts'].toString(),
                                maxLines: 4,
                                softWrap: true,
                                style: widget.snap['size'] == null ||
                                        widget.snap['font'] == null ||
                                        widget.snap['textColor'] == null
                                    ? TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: y == 'FontStyle.italic'
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        color: Color(color3),
                                        fontSize: double.tryParse(
                                            widget.snap['size']))),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          visualDensity: VisualDensity(horizontal: 1),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(0, 0, 0, 0)),
                          splashFactory: NoSplash.splashFactory,
                          elevation: MaterialStateProperty.all(2.0),
                          shape: MaterialStateProperty.all(StadiumBorder())),
                      child: Text("Read More"),
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(37, 255, 255, 255),
                        border: Border.all(
                          color: Color.fromARGB(63, 255, 255, 255),
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.center,
                          width: 0.6,
                        ),
                        borderRadius: BorderRadius.circular(40)),
                    width: 140,
                    height: 40,
                    child: Center(
                      child: Row(
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes'].contains(user?.uid),
                            smallLike: true,
                            child: IconButton(
                                onPressed: () async {
                                  await FirestoreMethods().likePost(
                                      widget.snap['postId'],
                                      user!.uid,
                                      widget.snap['likes']);
                                },
                                icon: Icon(
                                  widget.snap['likes'].contains(user?.uid)
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  color: Colors.red,
                                )),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreeen(snap: widget.snap),
                                ));
                              },
                              icon: Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.send_rounded,
                                color: Colors.red,
                              )),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: IconButton(
                          //       onPressed: () {},
                          //       icon: Icon(
                          //         Icons.bookmark_border_rounded,
                          //         color: Colors.red,
                          //       )),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.snap['profilePic']),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text(widget.snap['username'])),
                    IconButton(
                        onPressed: () {
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
                                      gradient: LinearGradient(
                                          colors: [
                                        Color.fromARGB(255, 47, 33, 243),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter)),
                                  child: Center(
                                      child: SizedBox(
                                          child: Column(children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(20),
                                    //   // radius: 100,
                                    //   child: Image.network(widget.snap['factUrl']),
                                    // ),
                                    if (widget.snap['email'] ==
                                        FirebaseAuth
                                            .instance.currentUser!.email)
                                      ActionChip(
                                        label: Text("Delete"),
                                        avatar:
                                            Icon(Icons.delete_forever_rounded),
                                        autofocus: true,
                                        backgroundColor: Colors.teal,
                                        disabledColor: Colors.teal,
                                        shadowColor: Colors.teal,
                                        elevation: 4.0,
                                        pressElevation: 10.0,
                                        onPressed: () {
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                "Are You Sure?")),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ActionChip(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  CherryToast(
                                                                    icon: Icons
                                                                        .delete_rounded,
                                                                    themeColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    title: Text(
                                                                        "Deleted....",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                    toastPosition:
                                                                        Position
                                                                            .top,

                                                                    // autoDismiss:
                                                                    //     false,

                                                                    displayTitle:
                                                                        true,
                                                                    displayCloseButton:
                                                                        true,
                                                                    autoDismiss:
                                                                        true,
                                                                    // animationCurve:
                                                                    //     Cubic(
                                                                    //         40.0,
                                                                    //         20.0,
                                                                    //         40.0,
                                                                    //         20.0),
                                                                    animationType:
                                                                        AnimationType
                                                                            .fromLeft,
                                                                    displayIcon:
                                                                        true,
                                                                    iconColor:
                                                                        Colors
                                                                            .red,
                                                                    iconSize:
                                                                        40,
                                                                    layout:
                                                                        ToastLayout
                                                                            .ltr,
                                                                    enableIconAnimation:
                                                                        true,
                                                                    description: Text(
                                                                        "Your Fact is Deleted....",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                    borderRadius:
                                                                        40,
                                                                  ).show(
                                                                      context);
                                                                  await FirestoreMethods()
                                                                      .deleteFact(
                                                                          widget
                                                                              .snap['factId']);
                                                                },
                                                                label: Text(
                                                                    "Yes")),
                                                            ActionChip(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                label: Text(
                                                                    "Cancel")),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      )
                                  ]))),
                                );
                              });
                        },
                        icon: Icon(Icons.more_vert_rounded))
                  ],
                )),
              ),
            ]),
          ),
          Container(
            child: Column(children: [
              Text(
                "${widget.snap['likes'].length} likes",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Container(
                width: double.infinity,
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                      TextSpan(
                          text: widget.snap['username'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ])),
              ),
              Row(
                children: [
                  if (commentLen > 0)
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Text(
                          "View All $commentLen Comments!",
                          style: TextStyle(color: secondaryColor, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Text(
                          "There Are No Comments!",
                          style: TextStyle(color: secondaryColor, fontSize: 16),
                        ),
                      ),
                    ),
                  Container(
                    child: Text(
                      DateFormat.yMMMd()
                          .format(DateTime.parse(widget.snap['datePublished'])),
                      style: TextStyle(color: secondaryColor, fontSize: 8),
                    ),
                  ),
                ],
              )
            ]),
          )
        ]),
      ),
    );
  }
}
