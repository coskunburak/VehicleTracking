import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aractakip2/src/elements/addButton.dart';
import 'package:aractakip2/src/elements/appBar.dart';
import '../blocs/listBLoC/list_bloc.dart';
import '../blocs/listBLoC/list_event.dart';
import '../repositories/vehicle_repository.dart';
import '../widgets/list_body.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc(VehicleRepository()),
      child: Scaffold(
        appBar: appBar(context: context, title: "Liste", isBack: false),
        backgroundColor: Colors.grey[200], // Replace with your desired color
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Kisiler')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, userSnap) {
            if (userSnap.hasData && userSnap.data != null && userSnap.data!.data() != null) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('permissions')
                    .doc(userSnap.data!.data()!['permissionId'].toString())
                    .snapshots(),
                builder: (context, permissionSnap) {
                  if (permissionSnap.hasData && permissionSnap.data != null && permissionSnap.data!.data() != null) {
                    final vehicleIdList = permissionSnap.data!.data()!['vehicleIdList'] ?? [];

                    // Check if vehicleIdList is empty
                    if (vehicleIdList.isEmpty) {
                      return Center(child: Text('No vehicles found'));
                    }

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('vehicles')
                            .where('plate', whereIn: vehicleIdList)
                            .snapshots(),
                        builder: (context, vehicleSnap) {
                          if (vehicleSnap.hasData && vehicleSnap.data != null && vehicleSnap.data!.docs.isNotEmpty) {
                            final plates = vehicleSnap.data!.docs.map((e) => e['plate'] as String).toList();
                            final vehicleDetails = vehicleSnap.data!.docs.map((e) => e.data()).toList();

                            context.read<ListBloc>().add(UpdateVehicleList(
                              plates: plates,
                              vehicleDetails: vehicleDetails,
                            ));

                            return listScrollList(
                              onDelete: (index) {
                                final plateToDelete = plates[index];
                                context.read<ListBloc>().add(DeleteVehicle(plateToDelete));
                              },
                            );
                          } else {
                            return Center(child: Text('No vehicles found'));
                          }
                        }
                    );
                  } else {
                    return Center(child: Text('No permission data found'));
                  }
                },
              );
            } else {
              return Center(child: Text('No user data found'));
            }
          },
        ),
        floatingActionButton: addButton(context: context), // Ensure this is placed within Scaffold
      ),
    );
  }
}
