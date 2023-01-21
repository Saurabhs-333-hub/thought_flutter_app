import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:thought/screens/imagemaker.dart';
import 'package:thought/screens/menuScreen.dart';
import 'package:thought/screens/thoughts.dart';

class FlutterZoomDrawerDemo extends StatefulWidget {
  @override
  _FlutterZoomDrawerDemoState createState() => _FlutterZoomDrawerDemoState();
}

class _FlutterZoomDrawerDemoState extends State<FlutterZoomDrawerDemo> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        borderRadius: 24,
        style: DrawerStyle.defaultStyle,
        // showShadow: true,
        openCurve: Curves.fastOutSlowIn,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        duration: const Duration(milliseconds: 500),
        // angle: 0.0,
        menuBackgroundColor: Color.fromARGB(0, 63, 81, 181),
        menuScreen: MenuScreen(),
        mainScreen: Thoughts(),
        // borderRadius: 24.0,
        showShadow: true,
        angle: 0.0,
        // boxShadow: [
        //   BoxShadow(color: Colors.white, spreadRadius: 4),
        //   BoxShadow(color: Color.fromARGB(255, 214, 20, 20), spreadRadius: 2)
        // ],
        // backgroundColor: Color.fromARGB(255, 101, 15, 200),
        // slideWidth: MediaQuery.of(context).size.width *
        //     (ZoomDrawer.isRTL() ? .45 : 0.65),
        // openCurve: Curves.fastOutSlowIn,
        // closeCurve: Curves.bounceIn,
      ),
    );
  }
}
