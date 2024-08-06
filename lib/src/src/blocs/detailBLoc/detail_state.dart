import 'package:equatable/equatable.dart';
import '../../models/vehicleDetail.dart';

abstract class DetailState extends Equatable {
  const DetailState();
}

class DetailLoadingState extends DetailState {
  @override
  List<Object> get props => [];
}

class DetailSuccessState extends DetailState {
  final VehicleDetail vehicleDetailData;

  const DetailSuccessState({required this.vehicleDetailData});

  @override
  List<Object> get props => [vehicleDetailData];
}

class DetailErrorState extends DetailState {
  @override
  List<Object> get props => [];
}
