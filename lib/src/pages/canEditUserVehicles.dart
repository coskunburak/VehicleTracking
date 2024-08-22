import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repositories/vehicle_repository.dart';

class Canedituservehicles extends StatelessWidget {
  final String userId;

  const Canedituservehicles({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final VehicleRepository vehicleRepository = VehicleRepository();

    return Scaffold(
      appBar: appBar(context: context, title: "Araç Ekle Çıkar", isBack: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Kisiler').doc(userId).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final permissionId = userData['permissionId'].toString();

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('permissions').doc(permissionId).snapshots(),
            builder: (context, permissionSnapshot) {
              if (permissionSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (permissionSnapshot.hasError) {
                return Center(child: Text('Error: ${permissionSnapshot.error}'));
              }

              if (!permissionSnapshot.hasData || !permissionSnapshot.data!.exists) {
                return const Center(child: Text('Permissions not found'));
              }

              final permissionData = permissionSnapshot.data!.data() as Map<String, dynamic>;
              final userVehiclePlates = List<String>.from(permissionData['vehicleIdList'] ?? []);

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
                builder: (context, vehicleSnapshot) {
                  if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vehicleSnapshot.hasError) {
                    return Center(child: Text('Error: ${vehicleSnapshot.error}'));
                  }

                  if (!vehicleSnapshot.hasData || vehicleSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No vehicles found'));
                  }

                  final allVehiclePlates = vehicleSnapshot.data!.docs.map((doc) => doc['plate'] as String).toList();

                  return ListView.builder(
                    itemCount: allVehiclePlates.length,
                    itemBuilder: (context, index) {
                      final plate = allVehiclePlates[index];
                      final isVehicleAdded = userVehiclePlates.contains(plate);

                      return ListTile(
                        title: Text(plate),
                        trailing: IconButton(
                          icon: Icon(
                            isVehicleAdded ? Icons.remove : Icons.add,
                            color: isVehicleAdded ? Colors.red : Colors.green,
                          ),
                          onPressed: () async {
                            if (isVehicleAdded) {
                              await _removeVehicleFromUserPermissions(permissionId, plate);
                            } else {
                              await _addVehicleToUserPermissions(permissionId, plate);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _removeVehicleFromUserPermissions(String permissionId, String plate) async {
    final permissionDoc = FirebaseFirestore.instance.collection('permissions').doc(permissionId);
    final permissionSnapshot = await permissionDoc.get();
    if (permissionSnapshot.exists) {
      final permissionData = permissionSnapshot.data() as Map<String, dynamic>;
      List<dynamic> vehicleIdList = List.from(permissionData['vehicleIdList'] ?? []);
      vehicleIdList.remove(plate);
      await permissionDoc.update({'vehicleIdList': vehicleIdList});
    }
  }

  Future<void> _addVehicleToUserPermissions(String permissionId, String plate) async {
    final permissionDoc = FirebaseFirestore.instance.collection('permissions').doc(permissionId);
    final permissionSnapshot = await permissionDoc.get();
    if (permissionSnapshot.exists) {
      final permissionData = permissionSnapshot.data() as Map<String, dynamic>;
      List<dynamic> vehicleIdList = List.from(permissionData['vehicleIdList'] ?? []);
      if (!vehicleIdList.contains(plate)) {
        vehicleIdList.add(plate);
        await permissionDoc.update({'vehicleIdList': vehicleIdList});
      }
    }
  }
}
