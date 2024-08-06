import 'package:flutter/material.dart';

Widget locationButton({required Function onPressed, required String title}) =>
    Center(
        child: ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(title),
    ));
