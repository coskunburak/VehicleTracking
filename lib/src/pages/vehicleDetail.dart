import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../blocs/detailBLoc/detail_bloc.dart';
import '../blocs/detailBLoc/detail_event.dart';
import '../blocs/detailBLoc/detail_state.dart';
import '../blocs/mapBloc/map_bloc.dart';
import '../elements/appBar.dart';
import '../elements/locationButton.dart';
import '../elements/pageLoading.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int deviceId;

  const VehicleDetailScreen({super.key, required this.deviceId});

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
    return Scaffold(
      appBar: appBar(title: "Detay Sayfa", context: context),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DetailBloc()..add(GetVehicleDetail(deviceId: widget.deviceId)),
          ),
          BlocProvider(
            create: (context) => MapBloc(),
          ),
        ],
        child: BlocConsumer<DetailBloc, DetailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is DetailLoadingState) {
              return pageLoading();
            } else if (state is DetailSuccessState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.directions_car),
                                const SizedBox(width: 8),
                                Text('Araç: ${state.vehiclePlate}'),
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
                                            state.vehicleDetailData.latitude,
                                            state.vehicleDetailData.longitude,
                                          ),
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId(
                                                'vehicle_location'),
                                            position: LatLng(
                                              state.vehicleDetailData.latitude,
                                              state.vehicleDetailData.longitude,
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
                                          latitude:
                                              state.vehicleDetailData.latitude,
                                          longitude:
                                              state.vehicleDetailData.longitude,
                                        ));
                                    _moveToVehicleLocation(
                                      state.vehicleDetailData.latitude,
                                      state.vehicleDetailData.longitude,
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
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: KdGaugeView(
                          minSpeed: 0,
                          maxSpeed: 200,
                          speed: state.vehicleDetailData.speed,
                          animate: true,
                          duration: const Duration(seconds: 1),
                          alertSpeedArray: const [40, 80, 90],
                          alertColorArray: const [
                            Colors.orange,
                            Colors.indigo,
                            Colors.red
                          ],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child:  Center(
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.speed),
                                  Text('${state.vehicleDetailData.km}',style:const TextStyle(fontSize: 20),),
                                ],
                              )

                            ),
                          ),
                        ),
                      ),
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
                          value: state.vehicleDetailData.fuelTankLevel,
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(
                          value: state.vehicleDetailData.fuelTankLevel,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is DetailErrorState) {
              return const Center(child: Text('Error'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
