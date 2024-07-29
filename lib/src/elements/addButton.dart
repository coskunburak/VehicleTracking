import 'package:flutter/material.dart';

import '../utils/global.dart';

Widget addButton({required Function onPressed, required String title}) =>
    Center(
        child: ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(title),
    ));
