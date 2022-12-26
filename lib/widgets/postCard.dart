// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
          .collection('posts')
          .doc(widget.snap['postId'])
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(31, 38, 0, 255),
            borderRadius: BorderRadius.circular(40)),
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Container(
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                // radius: 100,
                                child: Image.network(
                                  widget.snap['postUrl'],
                                  width:
                                      MediaQuery.of(context).devicePixelRatio *
                                          60,
                                ),
                              ),
                              if (widget.snap['email'] ==
                                  FirebaseAuth.instance.currentUser!.email)
                                ActionChip(
                                  label: Text("Delete"),
                                  avatar: Icon(Icons.delete_forever_rounded),
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
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
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
                                                          onPressed: () async {
                                                            await FirestoreMethods()
                                                                .deletePost(widget
                                                                        .snap[
                                                                    'postId']);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          label: Text("Yes")),
                                                      ActionChip(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          label:
                                                              Text("Cancel")),
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
          InteractiveViewer(
            scaleEnabled: true,
            maxScale: 100,
            child: InkWell(
              onDoubleTap: () {
                FirestoreMethods().likePost(
                    widget.snap['postId'], user!.uid, widget.snap['likes']);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: 400,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(widget.snap['postUrl']),
                            // colorFilter:
                            //     ColorFilter.mode(Colors.white, BlendMode.color),
                            fit: BoxFit.cover)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                        // TextSpan(
                        //     text: widget.snap['username'].toString(),
                        //     style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.snap['thoughts'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: double.tryParse(widget.snap['size'])))
                      ])),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(Icons.favorite, color: Colors.white, size: 100),
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ]),
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user?.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user!.uid, widget.snap['likes']);
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
                      builder: (context) => CommentsScreeen(snap: widget.snap),
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
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.red,
                    )),
              ))
            ],
          ),
          Container(
            child: Column(children: [
              Text(
                "${widget.snap['likes'].length} likes",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              // Container(
              //   width: double.infinity,
              //   child: RichText(
              //       text: TextSpan(
              //           style: TextStyle(color: primaryColor),
              //           children: [
              //         TextSpan(
              //             text: widget.snap['username'].toString(),
              //             style: TextStyle(fontWeight: FontWeight.bold)),
              //         TextSpan(
              //             text: widget.snap['thoughts'].toString(),
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: double.tryParse(widget.snap['size'])))
              //       ])),
              // ),
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
