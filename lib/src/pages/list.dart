import 'package:bloc_yapisi/src/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/listBLoC/list_bloc.dart';
import '../blocs/listBLoC/list_event.dart';
import '../repositories/vehicle_repository.dart';
import 'package:bloc_yapisi/src/elements/addButton.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';

import '../widgets/list_body.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Liste",
          isBack: false),
      backgroundColor: bodyBackground,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Kisiler')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnap) {
          if (userSnap.data != null &&
              userSnap.hasData &&
              userSnap.data!.data() != null) {
            print(userSnap.data!.data());
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('permissions')
                  .doc(userSnap.data!.data()!['permissionId'].toString())
                  .snapshots(),
              builder: (context, permissionSnap) {
                if (permissionSnap.data != null &&
                    permissionSnap.hasData &&
                    permissionSnap.data!.data() != null) {
                  print(permissionSnap.data!.data());
                  print(permissionSnap.data!.data()!['vehicleIdList']);
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('vehicles')
                          .where('plate',
                              whereIn:
                                  permissionSnap.data!.data()!['vehicleIdList'])
                          .snapshots(),
                      builder: (context, vehicleSnap) {
                        if (vehicleSnap.hasData &&
                            vehicleSnap.data != null &&
                            vehicleSnap.data!.docs.length != 0){
                          vehicleSnap.data?.docs
                              .forEach((element) => print(element.data()));
                        }

                        return Container();
                      });
                } else
                  return Container();
              },
            );
          } else
            return Container();
        },
      ),
      floatingActionButton: addButton(context: context),
    );
  }
}
