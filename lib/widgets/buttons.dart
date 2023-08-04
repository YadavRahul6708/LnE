import 'package:flutter/material.dart';

Widget buttonElevated(String buttonName, onPress,kTextStyle) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 1.0),
      ),
    ),
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8CECE),
        ),
        onPressed: onPress,
        child: Text(buttonName,style:kTextStyle)),
  );
}
