import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
}

class GetListVehicles extends ListEvent {
  final int limit;

  const GetListVehicles({required this.limit});

  @override
  List<dynamic> get props => [];
}


class DeleteVehicle extends ListEvent {
  final int deviceId;

  const DeleteVehicle({required this.deviceId});

  @override
  List<dynamic> get props => [];
}
