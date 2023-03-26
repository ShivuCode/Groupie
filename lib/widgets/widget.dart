import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: mainColor, width: 2)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: mainColor, width: 2)),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: mainColor, width: 2)),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 12),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action:
        SnackBarAction(label: "OK", onPressed: () {}, textColor: Colors.white),
  ));
}
