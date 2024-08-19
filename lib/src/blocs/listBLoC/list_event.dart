import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class FetchVehicles extends ListEvent {}

class DeleteVehicle extends ListEvent {
  final String plate;

  DeleteVehicle(this.plate);

  @override
  List<Object> get props => [plate];
}

class UpdateVehicleList extends ListEvent {
  final List<String> plates;
  final List<Map<String, dynamic>> vehicleDetails;

  UpdateVehicleList({required this.plates, required this.vehicleDetails});

  @override
  List<Object> get props => [plates, vehicleDetails];
}
