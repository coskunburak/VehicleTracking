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

  List<Object> get props => [plate];

}