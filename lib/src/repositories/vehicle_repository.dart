import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vehicleDetail.dart';
import '../repositories/auth_repository.dart';

class VehicleRepository {
  final CollectionReference collectionVehicles =
  FirebaseFirestore.instance.collection("vehicles");
  final AuthRepository authRepository = AuthRepository();

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
    final userId = FirebaseAuth.instance.currentUser?.uid;

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

    if (userId != null) {
      await authRepository.addVehicleToUserPermissions(plate);
    }
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
        return {};
      }
    });
  }

  Future<void> deleteVehicle(String plate) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await collectionVehicles.doc(plate).delete();

    if (userId != null) {
      final userDoc =
      FirebaseFirestore.instance.collection('Kisiler').doc(userId);
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        String permissionId = userData['permissionId'].toString();

        final permissionDoc = FirebaseFirestore.instance
            .collection('permissions')
            .doc(permissionId);
        final permissionSnapshot = await permissionDoc.get();

        if (permissionSnapshot.exists) {
          final permissionData =
          permissionSnapshot.data() as Map<String, dynamic>;
          List<dynamic> vehicleIdList =
          List.from(permissionData['vehicleIdList'] ?? []);

          if (vehicleIdList.contains(plate)) {
            vehicleIdList.remove(plate);

            await permissionDoc.update({'vehicleIdList': vehicleIdList});
          }
        }
      }
    }
  }
}
