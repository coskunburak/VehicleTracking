import 'package:aractakip2/src/models/vehicleDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final int km;
  final bool isActive;
  final int sensors;
  final String plate;
  final String userId;
  Vehicle({
    required this.fuelTankLevel,
    required this.longitude,
    required this.latitude,
    required this.speed,
    required this.deviceId,
    required this.km,
    required this.isActive,
    required this.sensors,
    required this.plate,
    required this.userId,
  });


}
