import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';
String apiKey="baf35198716c4b8d9a7123131241807";
Color appBarBackgroundColor = Colors.white;
Color loadingColor = Colors.blue;

List<VehicleDetail> vehicleDetailList = [
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 29.9857 ,
      latitude: 39.4200 ,
      deviceId: 0,
      km: 132.857,
      speed: 120,
      isActive:true,
      sensors:1,
      plate: "39 ST 437"
  ),

];
