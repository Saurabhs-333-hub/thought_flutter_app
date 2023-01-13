import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/resources/firestoreMethods.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/utils/utils.dart';
import 'package:thought/widgets/backup.dart';
import 'package:thought/widgets/factCard.dart';
// import 'package:thought/widgets/factsCard.dart';
import 'package:thought/widgets/followButton.dart';
import 'package:thought/widgets/likeAnimation.dart';
import 'package:thought/widgets/postCard.dart';
import 'package:thought/widgets/postsCard.dart';
import 'package:thought/widgets/storiesCard.dart';
import 'package:thought/widgets/storyCard.dart';
import 'package:intl/intl.dart';

// bool isrefreshing = false;

class Profile extends StatefulWidget {
  final String uid;
  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? value;
  double? updatedvalue;
  String? updatedfont;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isrefreshing = false;
  @override
  void initState() {
    super.initState();
    // isrefreshing = false;
    isrefreshing
        ? setState(() {
            // isLoading = true;
            getData();
            // isrefreshing = false;
            // isLoading = false;
          })
        : getData();
    // getData();
  }

  void refresh(bool newrefresh) {
    setState(() {
      isrefreshing = newrefresh;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      var factSnap = await FirebaseFirestore.instance
          .collection('facts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      var storySnap = await FirebaseFirestore.instance
          .collection('stories')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;
      isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> fontStyle = [
      'posts',
      'facts',
      'stories',
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    isLoading
                        ? Expanded(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                // backgroundImage: NetworkImage(userData['profilePic']),
                                radius: 60.0,
                              ),
                            ),
                          )
                        : Expanded(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userData['profilePic']),
                              radius: 60.0,
                            ),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : buildStatColumn(postLen, "posts"),
                              SizedBox(
                                width: 8,
                              ),
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : buildStatColumn(followers, "followers"),
                              SizedBox(
                                width: 8,
                              ),
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : buildStatColumn(following, "following")
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              isLoading
                                  ? Container(
                                      width: 60,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 52, 52, 52),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    )
                                  : Container(
                                      child: Text(userData['username']),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              isLoading
                                  ? Container(
                                      width: 100,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 52, 52, 52),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    )
                                  : Container(
                                      child: Text(userData['bio']),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                            backgroundColor: Colors.blue,
                            borderColor: Colors.transparent,
                            text: "Edit",
                            textColor: Colors.white)
                        : isFollowing
                            ? FollowButton(
                                backgroundColor: Colors.blue,
                                borderColor: Colors.transparent,
                                text: "UnFollow",
                                textColor: Colors.white,
                                function: (() async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                }),
                              )
                            : FollowButton(
                                backgroundColor: Colors.blue,
                                borderColor: Colors.transparent,
                                text: "Follow",
                                textColor: Colors.white,
                                function: (() async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                }),
                              ),
                    Expanded(
                      child: SizedBox(
                        child: DropdownButton<String>(
                          // alignment: Alignment.topCenter,
                          // isExpanded: true,
                          items: fontStyle.map(buildItem).toList(),
                          value: value,
                          onChanged: (value) => {
                            setState(() => {
                                  this.value = value,
                                  updatedfont = value,
                                }),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          updatedfont == 'posts'
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState ==
                    //     ConnectionState.waiting) {
                    //   return Center(
                    //     child: Container(
                    //       width: 300,
                    //       height: 300,
                    //       color: Colors.amber,
                    //     ),
                    //   );
                    // }

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
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                // isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return PostsCard(
                                    snap: snapshot.data!.docs[index].data(),
                                    onSonChanged: ((bool isrefreshing) =>
                                        refresh(isrefreshing)),
                                  );
                                }),
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
                  },
                )
              : updatedfont == 'facts'
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('facts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return Center(
                        //     child: Container(
                        //       // width: 100,
                        //       height: 200,
                        //       color: Color.fromARGB(255, 57, 57, 57),
                        //     ),
                        //   );
                        // }

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
                              return Center(
                                child: Container(
                                  // width: 60,
                                  // height: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 52, 52, 52),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              );
                            }
                            return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        // onTap: () =>
                                        child: FactsCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                          onSonChanged: ((bool isrefreshing) =>
                                              refresh(isrefreshing)),
                                        ),
                                      );
                                    }),
                                child: Container(child: Text(snap['facts'])));
                          },
                        );
                      },
                    )
                  : FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('stories')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

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
                              return Center(
                                child: Container(
                                  // width: 60,
                                  // height: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 52, 52, 52),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              );
                            }
                            return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StoriesCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                          onSonChanged: (bool isrefreshing) =>
                                              refresh(isrefreshing));
                                    }),
                                child: Container(child: Text(snap['stories'])));
                          },
                        );
                      },
                    )
        ],
      ),
    );
  }

  Column buildStatColumn(int nums, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nums.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
      value: item,
      enabled: true,
      child: Text(
        '$item',
        style: TextStyle(color: Colors.amber),
      ));
}





