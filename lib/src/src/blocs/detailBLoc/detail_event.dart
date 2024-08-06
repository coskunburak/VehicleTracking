import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class GetVehicleDetail extends DetailEvent {
  final String plate;

  const GetVehicleDetail({required this.plate});

  @override
  List<Object> get props => [plate];
}
