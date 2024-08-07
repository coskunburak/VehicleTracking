import 'package:bloc_yapisi/src/blocs/mapBLoC/map_bloc.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/locationButton.dart';
import 'package:bloc_yapisi/src/pages/addVehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../widgets/info_card.dart';
import '../repositories/vehicle_repository.dart'; // Import your VehicleRepository

class VehicleDetailScreen extends StatefulWidget {
  final String plate;

  const VehicleDetailScreen({Key? key, required this.plate}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveToVehicleLocation(double latitude, double longitude) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: Scaffold(
        appBar: appBar(context: context, title: 'Araç Detayları'),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vehicles')
              .doc(widget.plate)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.exists) {
              final vehicle = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.car_rental_sharp, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Plate: ${vehicle['plate']}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),

                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddVehicle(vehicleData: vehicle),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit_note, color: Colors.redAccent, size: 30),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.key, color: Colors.deepPurple),
                                SizedBox(width: 8),
                                Text(
                                  'Device ID: ${vehicle['deviceId']}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  vehicle['isActive']
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: vehicle['isActive']
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Active: ${vehicle['isActive'] ? 'Yes' : 'No'}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.sensors, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Sensors: ${vehicle['sensors']}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          BlocBuilder<MapBloc, MapState>(
                            builder: (context, mapState) {
                              if (mapState is MapVisibleState) {
                                return SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GoogleMap(
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            vehicle['latitude'],
                                            vehicle['longitude'],
                                          ),
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId('vehicle_location'),
                                            position: LatLng(
                                              vehicle['latitude'],
                                              vehicle['longitude'],
                                            ),
                                            infoWindow: const InfoWindow(
                                                title: 'Vehicle Location'),
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          BlocBuilder<MapBloc, MapState>(
                            builder: (context, mapState) {
                              return locationButton(
                                onPressed: () {
                                  if (mapState is MapVisibleState) {
                                    context
                                        .read<MapBloc>()
                                        .add(ToggleMapVisibility(
                                      latitude: mapState.latitude,
                                      longitude: mapState.longitude,
                                    ));
                                  } else if (mapState is MapHiddenState) {
                                    context
                                        .read<MapBloc>()
                                        .add(ToggleMapVisibility(
                                      latitude: vehicle['latitude'],
                                      longitude: vehicle['longitude'],
                                    ));
                                    _moveToVehicleLocation(
                                      vehicle['latitude'],
                                      vehicle['longitude'],
                                    );
                                  }
                                },
                                title: mapState is MapVisibleState
                                    ? "Konumu Gizle"
                                    : "Konuma Git",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('vehicles')
                          .doc(widget.plate)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data!.exists) {
                          final vehicle = snapshot.data!.data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 400,
                              height: 400,
                              child: KdGaugeView(
                                minSpeed: 0,
                                maxSpeed: 250,
                                speed: vehicle['speed'].toDouble(),
                                animate: true,
                                duration: const Duration(seconds: 1),
                                alertSpeedArray: const [40, 80, 90],
                                alertColorArray: const [
                                  Colors.orange,
                                  Colors.indigo,
                                  Colors.red
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 110.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.speed),
                                        Text(
                                          '${vehicle['km'].toString()}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text('Error loading data.'));
                        }
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.local_gas_station, color: Colors.red),
                        Icon(Icons.local_gas_station, color: Colors.green),
                      ],
                    ),
                    SfLinearGauge(
                      ranges: const [
                        LinearGaugeRange(
                          startValue: 0,
                          endValue: 100,
                          color: Colors.grey,
                        ),
                      ],
                      markerPointers: [
                        LinearShapePointer(
                          value: vehicle['fuelTankLevel'].toDouble(),
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(
                          value: vehicle['fuelTankLevel'].toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Error loading data.'));
            }
          },
        ),
      ),
    );
  }
}
