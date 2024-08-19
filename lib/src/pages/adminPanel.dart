import 'package:aractakip2/src/pages/canEditUser.dart';
import 'package:aractakip2/src/pages/canEditVehicle.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../elements/appBar.dart';
import '../repositories/auth_repository.dart';

class Adminpanel extends StatefulWidget {
  const Adminpanel({super.key});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: appBar(context: context, title: "Admin Panel",isBack: true),
      body: uid == null
          ? const Center(child: Text('User not logged in'))
          : FutureBuilder<Map<String, bool>>(
        future: Future.wait([
          AuthRepository().getCanEditUser(uid),
          AuthRepository().getCanEditVehicle(uid),
        ]).then((values) => {
          'canEditUser': values[0],
          'canEditVehicle': values[1],
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          bool canEditUser = snapshot.data?['canEditUser'] ?? false;

          bool canEditVehicle = snapshot.data?['canEditVehicle'] ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: canEditUser
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Canedituser(),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 100),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: const Text('Kullanıcılar'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: canEditVehicle
                          ? () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Caneditvehicle(),
                          ),
                        );

                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 100),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text('Araçlar'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
