import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_bloc.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_event.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_state.dart';
import 'package:bloc_yapisi/src/repositories/vehicle_repository.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _formKey = GlobalKey<FormState>();
  final _fuelTankLevelController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _speedController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _kmController = TextEditingController();
  final _sensorsController = TextEditingController();
  final _plateController = TextEditingController();

  @override
  void dispose() {
    _fuelTankLevelController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _speedController.dispose();
    _deviceIdController.dispose();
    _kmController.dispose();
    _sensorsController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddvehicleBloc(vehicleRepository: VehicleRepository()),
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
            bool isActive = state is IsActiveChanged ? state.isActive : true;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _fuelTankLevelController,
                      decoration: InputDecoration(labelText: 'Fuel Tank Level'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fuel tank level';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter longitude';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter latitude';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _speedController,
                      decoration: InputDecoration(labelText: 'Speed'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter speed';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _deviceIdController,
                      decoration: InputDecoration(labelText: 'Device ID'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter device ID';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _kmController,
                      decoration: InputDecoration(labelText: 'KM'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter KM';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<AddvehicleBloc, AddVehicleState>(
                      builder: (context, state) {
                        bool isActive = state is IsActiveChanged ? state.isActive : true;
                        return SwitchListTile(
                          title: Text('Is Active'),
                          value: isActive,
                          onChanged: (bool value) {
                            context.read<AddvehicleBloc>().add(ToggleIsActive(isActive: value));
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _sensorsController,
                      decoration: InputDecoration(labelText: 'Sensors'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sensors';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _plateController,
                      decoration: InputDecoration(labelText: 'Plate'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plate number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final fuelTankLevel = double.parse(_fuelTankLevelController.text);
                          final longitude = double.parse(_longitudeController.text);
                          final latitude = double.parse(_latitudeController.text);
                          final speed = double.parse(_speedController.text);
                          final deviceId = int.parse(_deviceIdController.text);
                          final km = double.parse(_kmController.text);
                          final isActive = context.read<AddvehicleBloc>().isActive;
                          final sensors = int.parse(_sensorsController.text);
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
    );
  }
}
