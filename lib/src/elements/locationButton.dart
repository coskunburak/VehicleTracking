import 'package:flutter/material.dart';

Widget locationButton({required Function onPressed, required String title}) =>
    Center(
        child: ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0c3143)
      ),
      child: Text(title,style: TextStyle(color: Colors.white),),
    ));
