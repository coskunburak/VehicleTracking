import 'package:aractakip2/src/pages/vehicleDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../elements/appBar.dart';

class Caneditvehicle extends StatefulWidget {
  const Caneditvehicle({super.key});

  @override
  State<Caneditvehicle> createState() => _CaneditvehicleState();
}

class _CaneditvehicleState extends State<Caneditvehicle> {
  final CollectionReference collectionVehicles =
  FirebaseFirestore.instance.collection("vehicles");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Admin Araç Düzenleme",isBack: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionVehicles.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Center(child: Text('No vehicles found'));
          }

          final vehicles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final data = vehicle.data() as Map<String, dynamic>;
              final plate = data['plate'] ?? 'No Plate Number';

              return ListTile(
                title: Text(plate),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailScreen(
                          plate: plate,
                        ),
                      ),
                    );
                  },
                ),
              );

            },
          );
        },
      ),
    );
  }
}
