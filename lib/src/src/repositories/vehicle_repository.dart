import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vehicleDetail.dart';

class VehicleRepository {
  final CollectionReference collectionVehicles =
  FirebaseFirestore.instance.collection("vehicles");

  Future<void> addVehicleToFirestore({
    required double fuelTankLevel,
    required double longitude,
    required double latitude,
    required double speed,
    required int deviceId,
    required int km,
    required bool isActive,
    required int sensors,
    required String plate,
  }) async {
    await collectionVehicles.doc(plate).set({
      'fuelTankLevel': fuelTankLevel,
      'longitude': longitude,
      'latitude': latitude,
      'speed': speed,
      'deviceId': deviceId,
      'km': km,
      'isActive': isActive,
      'sensors': sensors,
      'plate': plate,
    });
  }

  Future<VehicleDetail> getVehicleDetail(String plate) async {
    final doc = await collectionVehicles.doc(plate).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return VehicleDetail.fromFirestore(data);
    } else {
      throw Exception("Vehicle not found");
    }
  }

  Stream<List<String>> getVehiclePlatesStream() {
    return collectionVehicles.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['plate'] as String).toList();
    });
  }

  Stream<Map<String, dynamic>> getVehicleDetailStream(String plate) {
    return collectionVehicles.doc(plate).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    });
  }

  Future<void> deleteVehicle(String plate) async {
    await collectionVehicles.doc(plate).delete();
  }
}
