import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class GetVehicleDetail extends DetailEvent {
  final int deviceId;

  const GetVehicleDetail({required this.deviceId});

  @override
  List<dynamic> get props => [];
}
