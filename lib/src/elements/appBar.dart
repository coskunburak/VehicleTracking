import 'package:bloc_yapisi/src/pages/user.dart';
import 'package:bloc_yapisi/src/pages/weathersearch.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({
  required BuildContext context,
  required String title,
}) =>
    AppBar(
      centerTitle: true,
      backgroundColor: appBarBackgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Weathersearch()
                ));
          },
          icon: const Icon(Icons.wind_power_rounded, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserPage()
                ));
          },
          icon: const Icon(Icons.person, color: Colors.blue),
        ),
      ],
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
