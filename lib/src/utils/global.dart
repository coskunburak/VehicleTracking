import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';
String apiKey="baf35198716c4b8d9a7123131241807";
Color appBarBackgroundColor = Colors.white;
Color loadingColor = Colors.blue;
List<Vehicle> list = [
  Vehicle(plate: '39 ST 437', id: 0),
  Vehicle(plate: '43 ACL 750', id: 1),
  Vehicle(plate: '42 ADE 999', id: 2),
  Vehicle(plate: '43 EA 376', id: 3),
  Vehicle(plate: '10 KR 333', id: 4),
  Vehicle(plate: '42 E 7777', id: 5),
];

List<VehicleDetail> vehicleDetailList = [
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 29.9857 ,
      latitude: 39.4200 ,
      deviceId: 0,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 20,
      longitude: 29,
      latitude: 41,
      deviceId: 1,
      km: 132.857,
      speed: 80),
  VehicleDetail(
      fuelTankLevel: 30,
      longitude: 41.2658,
      latitude: 39.9056,
      deviceId: 2,
      km: 132.857,
      speed: 70),
  VehicleDetail(
      fuelTankLevel: 40,
      longitude: 41,
      latitude: 29,
      deviceId: 3,
      km: 132.857,
      speed: 60),
  VehicleDetail(
      fuelTankLevel: 50,
      longitude: 41,
      latitude: 29,
      deviceId: 4,
      km: 132.857,
      speed: 50),
  VehicleDetail(
      fuelTankLevel: 60,
      longitude: 41,
      latitude: 29,
      deviceId: 5,
      km: 132.857,
      speed: 40),
];
