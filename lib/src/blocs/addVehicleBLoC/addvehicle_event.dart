import 'package:equatable/equatable.dart';

abstract class AddVehicleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddVehicleRequsted extends AddVehicleEvent {
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final int km;
  final bool isActive;
  final int sensors;
  final String plate;

  @override
  List<Object> get props => [
        fuelTankLevel,
        longitude,
        latitude,
        speed,
        deviceId,
        km,
        isActive,
        sensors,
        plate
      ];

  AddVehicleRequsted(
      {required this.fuelTankLevel,
      required this.longitude,
      required this.latitude,
      required this.speed,
      required this.deviceId,
      required this.km,
      required this.isActive,
      required this.sensors,
      required this.plate});
}
class ToggleIsActive extends AddVehicleEvent {
  final bool isActive;

  ToggleIsActive({required this.isActive});

  @override
  List<Object> get props => [isActive];
}

class LoadVehicleDetails extends AddVehicleEvent {
  final String plate;

  LoadVehicleDetails({required this.plate});

  @override
  List<Object> get props => [plate];
}
class FetchVehiclesDetail extends AddVehicleEvent {}

/*class SaveVehicleRequested extends AddVehicleEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}*/

/*class ResetPasswordRequested extends AddVehicleEvent {
  final String email;

  ResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}*/
