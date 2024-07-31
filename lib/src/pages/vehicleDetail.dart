import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repositories/vehicle_repository.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String plate;

  const VehicleDetailScreen({Key? key, required this.plate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
      ),
      body: FutureBuilder(
        future: _getVehicleDetails(plate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final vehicle = snapshot.data as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plate: ${vehicle['plate']}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text('Fuel Tank Level: ${vehicle['fuelTankLevel']}'),
                  Text('Longitude: ${vehicle['longitude']}'),
                  Text('Latitude: ${vehicle['latitude']}'),
                  Text('Speed: ${vehicle['speed']}'),
                  Text('Device ID: ${vehicle['deviceId']}'),
                  Text('KM: ${vehicle['km']}'),
                  Text('Active: ${vehicle['isActive']}'),
                  Text('Sensors: ${vehicle['sensors']}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getVehicleDetails(String plate) async {
    final doc = await FirebaseFirestore.instance.collection('vehicles').doc(plate).get();
    return doc.data() ?? {};
  }
}
