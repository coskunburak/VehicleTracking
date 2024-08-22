import 'package:bloc_yapisi/src/pages/adminPanel.dart';
import 'package:bloc_yapisi/src/pages/user.dart';
import 'package:bloc_yapisi/src/pages/weathersearch.dart';
import 'package:bloc_yapisi/src/pages/login.dart';
import 'package:bloc_yapisi/src/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar(
    {required BuildContext context,
    required String title,
    required bool isBack}) {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: StreamBuilder<int?>(
      stream: uid != null
          ? AuthRepository().getUserAuthorityLevelStream(uid)
          : Stream.value(null),
      builder: (context, snapshot) {
        int? authorityLevel = snapshot.data;

        return AppBar(
          centerTitle: false,
          backgroundColor: appBarBackgroundColor,
          leading: isBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Color(0xFF4a4b65)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : authorityLevel == 1
                  ? IconButton(
                      icon: const Icon(Icons.account_tree_sharp,
                          color: Color(0xFF4a4b65)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Adminpanel(),
                          ),
                        );
                      },
                    )
                  : null,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Weathersearch(),
                  ),
                );
              },
              icon: const Icon(Icons.wind_power_rounded,
                  color: Color(0xFF4a4b65)),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPage(),
                  ),
                );
              },
              icon: const Icon(Icons.person, color: Color(0xFF4a4b65)),
            ),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        );
      },
    ),
  );
}
