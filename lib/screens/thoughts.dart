// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart';
import 'package:thought/providers/userProvider.dart';
import 'package:thought/screens/imagemaker.dart';
import 'package:thought/screens/loginScreen.dart';
import 'package:thought/widgets/factCard.dart';
import 'package:thought/widgets/postCard.dart';
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
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    final snap;
    int index = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Thoughts"),
        actions: [
          InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout_rounded)),
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {},
            child: CupertinoButton(
                child: Text("Facts!"),
                onPressed: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => ImageMaker()));
                }),
          ),
          SizedBox(
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
        ],
      ),
      body: StreamBuilder(
        stream: updatedfont == 'posts'
            ? FirebaseFirestore.instance
                .collection('posts')
                // .where('uid', isEqualTo: user!.uid)
                .snapshots()
            : updatedfont == 'facts'
                ? FirebaseFirestore.instance.collection('facts').snapshots()
                : FirebaseFirestore.instance.collection('stories').snapshots(),
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
                    : StoryCard(snap: snapshot.data!.docs[index].data()),
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
