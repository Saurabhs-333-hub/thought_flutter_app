// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thought/models/user.dart' as model;
import 'package:thought/providers/userProvider.dart';
import 'package:thought/responsive/webScreen.dart';
import 'package:thought/screens/addStories.dart';
import 'package:thought/screens/explorer.dart';
import 'package:thought/screens/profile.dart';
import 'package:thought/screens/stories.dart';
import 'package:thought/screens/thoughts.dart';
import 'package:thought/utils/colors.dart';
import 'package:thought/widgets/squarePage.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pageController;
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // getIds();
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(0, 26, 26, 46),
        bottomNavigationBar: CurvedNavigationBar(
            // key: navigationKey,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Color.fromARGB(255, 90, 64, 113),
            color: Color.fromARGB(255, 40, 40, 70),
            // animationCurve: Curves.easeIn,
            animationDuration: Duration(milliseconds: 400),
            height: 56,
            items: [
              Icon(_page == 0 ? Icons.home : Icons.home_outlined,
                  color: _page == 0 ? Colors.white : Colors.black, size: 28),
              Icon(_page == 1 ? Icons.search : Icons.search_rounded,
                  color: _page == 1 ? Colors.white : Colors.black, size: 28),
              Icon(
                  _page == 2
                      ? Icons.add_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  color: _page == 2 ? Colors.white : Colors.black,
                  size: _page == 2 ? 56 : 46),
              Icon(_page == 3 ? Icons.favorite : Icons.favorite_border_rounded,
                  color: _page == 3 ? Colors.white : Colors.black, size: 28),
              Icon(_page == 4 ? Icons.person : Icons.person_outline,
                  color: _page == 4 ? Colors.white : Colors.black, size: 28)
            ],
            onTap: navigationTapped),
        // appBar: AppBar(
        //   title: Text("$user"),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     CupertinoButton(
        //       child: Text("Sign Out!"),
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut();
        //       },
        //     ),
        //   ],
        // ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            Thoughts(),
            Explorer(),
            // AddStories(),
            ImageMaker1(),
            Stories(),
            Profile(
              uid: FirebaseAuth.instance.currentUser!.uid,
            )
          ],
        ));
  }
}
