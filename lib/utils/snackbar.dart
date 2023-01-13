import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:thought/screens/imagemaker.dart';

class EditImage extends State<ImageMaker> {
  int currentIndex = 0;
  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    CherryToast.success(
      // icon: Icons.,
      // themeColor: Color.fromARGB(255, 255, 255, 255),
      title: Text("Selected", style: TextStyle(color: Colors.black)),
      toastPosition: Position.top,

      // autoDismiss:
      //     false,

      displayTitle: true,
      displayCloseButton: true,
      autoDismiss: true,
      toastDuration: Duration(seconds: 2),
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
      description:
          Text("Selected For Editing", style: TextStyle(color: Colors.black)),
      borderRadius: 40,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox.shrink();
    // throw UnimplementedError();
  }
}
