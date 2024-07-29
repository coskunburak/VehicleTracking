import '../../models/vehicleDetail.dart';
import 'package:equatable/equatable.dart';

abstract class DetailState extends Equatable {
  const DetailState();
}

class DetailLoadingState extends DetailState {
  @override
  List<dynamic> get props => [];
}

class DetailSuccessState extends DetailState {
  const DetailSuccessState({
    required this.vehicleDetailData,
    required this.vehiclePlate,
  });

  final VehicleDetail vehicleDetailData;
  final String vehiclePlate;

  @override
  List<dynamic> get props => [vehicleDetailData, vehiclePlate];
}


class DetailErrorState extends DetailState {
  @override
  List<dynamic> get props => [];
}
