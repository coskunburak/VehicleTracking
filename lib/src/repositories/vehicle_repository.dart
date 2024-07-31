import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';

class VehicleRepository {
  final CollectionReference collectionVehicles =
  FirebaseFirestore.instance.collection("vehicles");

  Future<void> addVehicleToFirestore(
      {required double fuelTankLevel,
        required double longitude,
        required double latitude,
        required double speed,
        required int deviceId,
        required double km,
        required bool isActive,
        required int sensors,
        required String plate}) async {
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

  Stream<List<String>> getVehiclePlatesStream() {
    return collectionVehicles.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['plate'] as String).toList();
    });
  }
  Future<void> deleteVehicle(String plate) async {
    await collectionVehicles.doc(plate).delete();
  }

}
