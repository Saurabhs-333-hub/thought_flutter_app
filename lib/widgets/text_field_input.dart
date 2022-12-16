// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType,
      this.isPass = false});

  final TextEditingController textEditingController;

  final bool isPass;

  final String hintText;

  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          filled: true,
          contentPadding: EdgeInsets.all(8.0)),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
