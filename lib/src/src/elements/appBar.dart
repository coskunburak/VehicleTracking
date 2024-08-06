import 'package:bloc_yapisi/src/pages/user.dart';
import 'package:bloc_yapisi/src/pages/weathersearch.dart';
import 'package:bloc_yapisi/src/pages/login.dart'; // Login sayfasının importu
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
                    builder: (context) => const UserPage()
                ));
          },
          icon: const Icon(Icons.person, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Login()
                ));
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.red),
        ),
      ],
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
