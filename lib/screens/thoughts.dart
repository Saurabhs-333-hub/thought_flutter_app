// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreAdminMethods.dart';
import 'package:thought/screens/imagemaker.dart';
import 'package:thought/screens/loginScreen.dart';
import 'package:thought/widgets/factCard.dart';
import 'package:thought/widgets/postCard.dart';
import 'package:thought/widgets/squarePage.dart';
import 'package:thought/widgets/storyCard.dart';

class Thoughts extends StatefulWidget {
  // final snap;
  Thoughts({super.key});
  @override
  State<Thoughts> createState() => _ThoughtsState();
}

class _ThoughtsState extends State<Thoughts> {
  String? value;
  double? updatedvalue;
  String? updatedfont;
  final List<String> fontStyle = [
    'posts',
    'facts',
    'stories',
  ];
  bool posts = false;
  bool facts = false;
  bool stories = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(values1);
    readLoacationData();
    // print("run");
    print(value1);
  }

  var str;
  List value1 = [];
  List values1 = [];
  readLoacationData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('QGB0kPKhUygzD61irohdquifaCt2')
        .get()
        .then((value) {
      List<String> values = List.from((value.data() as dynamic)['following']);
      setState(() {
        // values1.add(values);
        values.forEach((element) {
          values1.add(element);
          str = element;
          value1.add(str);
          print(value1);
          setState(() {
            // value1.add(str);
            values1.add(element);
          });
        });
        // print(value1);
        setState(() {});
      });
      setState(() {});
      return value1;
    });
    return values1;
  }

  getData() async {
    // List any = [];
    // setState(() {
    //   // print(value1.toString());
    //   // return await values1.length;
    // });
    print(str);
    print(value1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // print(values1);
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    final snap;
    int index = 1;
    // final controller = ZoomDrawerController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
        ),
        title: Column(
          children: [
            Text("Thoughts"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // CupertinoButton(
                  //     child: Text("benjbfjbgferh"),
                  //     onPressed: () {
                  //       getData();
                  //     }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        posts = !posts;
                        facts = false;
                        stories = false;
                        posts ? updatedfont = 'posts' : updatedfont = '';
                        posts
                            ? Fluttertoast.showToast(
                                msg: "posts",
                                backgroundColor: Colors.black,
                                textColor: Colors.black)
                            : Fluttertoast.showToast(
                                msg: "Random Posts",
                                backgroundColor: Colors.black,
                                textColor: Colors.black);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 0, 16, 137),
                              Color.fromARGB(255, 115, 0, 121)
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Posts",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        facts = !facts;
                        posts = false;
                        stories = false;
                        facts ? updatedfont = 'facts' : updatedfont = '';
                        facts
                            ? Fluttertoast.showToast(
                                msg: "facts",
                                backgroundColor: Color.fromARGB(79, 0, 0, 0),
                                textColor: Colors.black)
                            : Fluttertoast.showToast(
                                msg: "Random Posts",
                                backgroundColor: Color.fromARGB(79, 0, 0, 0),
                                textColor: Colors.black);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 0, 16, 137),
                              Color.fromARGB(255, 115, 0, 121)
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Facts",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        stories = !stories;
                        posts = false;
                        facts = false;
                        stories ? updatedfont = 'stories' : updatedfont = '';
                        stories
                            ? Fluttertoast.showToast(
                                msg: "Stories",
                                backgroundColor: Color.fromARGB(79, 0, 0, 0),
                                textColor: Colors.black)
                            : Fluttertoast.showToast(
                                msg: "Random Posts",
                                backgroundColor: Color.fromARGB(79, 0, 0, 0),
                                textColor: Colors.black);
                      }),
                      // onSecondaryTap: () =>
                      //     Fluttertoast.showToast(msg: "Random Posts"),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 0, 16, 137),
                              Color.fromARGB(255, 115, 0, 121)
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Stories",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  )
                  // InkWell(
                  //     onTap: () async {
                  //       await FirebaseAuth.instance.signOut();
                  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //           builder: (context) => LoginScreen()));
                  //     },
                  //     child: Icon(Icons.logout_rounded)),
                  // Column(
                  //   children: [
                  //     InkWell(
                  //       onTap: () => setState(() {
                  //         updatedfont = 'posts';
                  //       }),
                  //       child: Text('posts'),
                  //     ),
                  //     FloatingActionButton(
                  //       backgroundColor: Colors.transparent,
                  //       onPressed: () {},
                  //       child: CupertinoButton(
                  //           child: Text("Facts!"),
                  //           onPressed: () {
                  //             Navigator.of(context).push(CupertinoPageRoute(
                  //                 builder: (context) => ImageMaker()));
                  //           }),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
        actions: [
          // SizedBox(
          //   child: DropdownButton<String>(
          //     // alignment: Alignment.topCenter,
          //     // isExpanded: true,
          //     items: fontStyle.map(buildItem).toList(),
          //     value: value,
          //     onChanged: (value) => {
          //       setState(() => {
          //             this.value = value,
          //             updatedfont = value,
          //           }),
          //     },
          //   ),
          // ),
        ],
      ),
      body: StreamBuilder(
        stream: updatedfont == 'posts'
            ? value1.isNotEmpty
                ? FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', whereIn: value1)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('posts')
                    // .where('uid', whereIn: [0])
                    .snapshots()
            : updatedfont == 'facts'
                ? value1.isNotEmpty
                    ? FirebaseFirestore.instance
                        .collection('facts')
                        .where('uid', whereIn: value1)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('facts')
                        // .where('uid', whereIn: [0])
                        .snapshots()
                : updatedfont == 'stories'
                    ? FirebaseFirestore.instance
                        .collection('stories')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('posts')
                        // .where('uid', whereIn: [0])
                        .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // snap: snapshot.data!.docs[index].data();
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => updatedfont == 'posts'
                ? PostCard(
                    snap: snapshot.data!.docs[index].data(),
                    // uid: widget.snap,
                  )
                : updatedfont == 'facts'
                    ? FactCard(snap: snapshot.data!.docs[index].data())
                    : updatedfont == 'stories'
                        ? StoryCard(snap: snapshot.data!.docs[index].data())
                        : PostCard(
                            snap: snapshot.data!.docs[index].data(),
                            // uid: widget.snap,
                          ),
          );
        },
      ),
    );
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        '$item',
        style: TextStyle(color: Colors.amber),
      ));
}
