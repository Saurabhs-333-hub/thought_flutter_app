import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought/screens/addStories.dart';
import 'package:thought/screens/explorer.dart';
import 'package:thought/screens/profile.dart';
import 'package:thought/screens/stories.dart';
import 'package:thought/screens/thoughts.dart';
import 'package:thought/utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
                  color: _page == 4 ? Colors.white : Colors.black, size: 28),
              InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Icon(Icons.logout_rounded))
            ],
            onTap: navigationTapped),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            Thoughts(),
            Explorer(),
            AddStories(),
            Stories(),
            Profile(
              uid: FirebaseAuth.instance.currentUser!.uid,
            )
          ],
        ));
  }
}
