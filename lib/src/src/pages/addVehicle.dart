import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_bloc.dart';
import 'package:bloc_yapisi/src/blocs/mapBLoC/map_bloc.dart';
import 'package:bloc_yapisi/src/repositories/vehicle_repository.dart';

import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_event.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_state.dart';

import '../widgets/build_text.dart';

class AddVehicle extends StatelessWidget {
  final Map<String, dynamic>? vehicleData;
  final _formKey = GlobalKey<FormState>();

  AddVehicle({super.key, this.vehicleData}) {
    _fuelTankLevelController =
        TextEditingController(text: vehicleData?['fuelTankLevel']?.toString());
    _longitudeController =
        TextEditingController(text: vehicleData?['longitude']?.toString());
    _latitudeController =
        TextEditingController(text: vehicleData?['latitude']?.toString());
    _speedController =
        TextEditingController(text: vehicleData?['speed']?.toString());
    _deviceIdController =
        TextEditingController(text: vehicleData?['deviceId']?.toString());
    _kmController = TextEditingController(text: vehicleData?['km']?.toString());
    _sensorsController =
        TextEditingController(text: vehicleData?['sensors']?.toString());
    _plateController =
        TextEditingController(text: vehicleData?['plate']?.toString());
  }

  late final TextEditingController _fuelTankLevelController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _speedController;
  late final TextEditingController _deviceIdController;
  late final TextEditingController _kmController;
  late final TextEditingController _sensorsController;
  late final TextEditingController _plateController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddvehicleBloc(vehicleRepository: VehicleRepository()),
      child: BlocProvider(
        create: (context) => MapBloc(),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: appBar(context: context, title: "Araç Kayıt"),
            body: BlocConsumer<AddvehicleBloc, AddVehicleState>(
              listener: (context, state) {
                if (state is AddVehicleSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Araç başarıyla kaydedildi!')),
                  );
                  Navigator.pop(context);
                } else if (state is UnAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hata: ${state.error}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is Loading) {
                  return pageLoading();
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        BlocBuilder<AddvehicleBloc, AddVehicleState>(
                          builder: (context, state) {
                            bool isActive = state is IsActiveChanged
                                ? state.isActive
                                : true;

                            return Padding(
                              padding: const EdgeInsets.only(right: 55.0),
                              child: SwitchListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.key,
                                        color: Colors.brown[900],
                                        size: 35,
                                      ),
                                    ),
                                    Text('Kontak Durumu'),
                                  ],
                                ),
                                value: isActive,
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.redAccent,
                                onChanged: (bool value) {
                                  context
                                      .read<AddvehicleBloc>()
                                      .add(ToggleIsActive(isActive: value));
                                },
                              ),
                            );
                          },
                        ),
                        buildTextFormField(
                          controller: _plateController,
                          labelText: 'Plaka',
                          keyboardType: TextInputType.text,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter plate number'
                              : null,
                          icon: Icons.car_crash,
                          iconColor: Colors.grey,
                        ),
                        buildTextFormField(
                          controller: _fuelTankLevelController,
                          labelText: 'Yakıt Seviyesi',
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter fuel tank level'
                              : null,
                          icon: Icons.gas_meter,
                          iconColor: Colors.green,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextFormField(
                                controller: _latitudeController,
                                labelText: 'Enlem',
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter latitude'
                                        : null,
                                icon: Icons.location_on,
                                iconColor: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: buildTextFormField(
                                controller: _longitudeController,
                                labelText: 'Boylam',
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter longitude'
                                        : null,
                                icon: Icons.location_on,
                                iconColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        BlocConsumer<MapBloc, MapState>(
                          listener: (context, mapState) {
                            if (mapState is MapVisibleState) {
                              _latitudeController.text =
                                  mapState.latitude.toString();
                              _longitudeController.text =
                                  mapState.longitude.toString();
                            } else if (mapState is LocationErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(mapState.message)),
                              );
                            }
                          },
                          builder: (context, mapState) {
                            if (mapState is LocationLoadingState) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: pageLoading(),
                              );
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<MapBloc>()
                                          .add(FetchLocation());
                                    },
                                    child: const Text('Mevcut Konumu Al'),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        buildTextFormField(
                          controller: _speedController,
                          labelText: 'Hız',
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter speed'
                              : null,
                          icon: Icons.speed,
                          iconColor: Colors.orange,
                        ),
                        buildTextFormField(
                          controller: _deviceIdController,
                          labelText: 'Cihaz ID',
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter device ID'
                              : null,
                          icon: Icons.devices,
                          iconColor: Colors.purple,
                        ),
                        buildTextFormField(
                          controller: _kmController,
                          labelText: 'KM',
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter KM'
                              : null,
                          icon: Icons.track_changes,
                          iconColor: Colors.red,
                        ),
                        buildTextFormField(
                          controller: _sensorsController,
                          labelText: 'Sensors',
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter sensors'
                              : null,
                          icon: Icons.sensors,
                          iconColor: Colors.teal,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final fuelTankLevel =
                                  double.parse(_fuelTankLevelController.text);
                              final longitude =
                                  double.parse(_longitudeController.text);
                              final latitude =
                                  double.parse(_latitudeController.text);
                              final speed = double.parse(_speedController.text);
                              final deviceId =
                                  int.parse(_deviceIdController.text);
                              final km = int.parse(_kmController.text);
                              final isActive =
                                  context.read<AddvehicleBloc>().isActive;
                              final sensors =
                                  int.parse(_sensorsController.text);
                              final plate = _plateController.text;

                              context.read<AddvehicleBloc>().add(
                                    AddVehicleRequsted(
                                      fuelTankLevel: fuelTankLevel,
                                      longitude: longitude,
                                      latitude: latitude,
                                      speed: speed,
                                      deviceId: deviceId,
                                      km: km,
                                      isActive: isActive,
                                      sensors: sensors,
                                      plate: plate,
                                    ),
                                  );
                            }
                          },
                          child: Text('Kaydet'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


}
