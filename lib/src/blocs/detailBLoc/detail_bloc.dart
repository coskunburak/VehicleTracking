import 'package:bloc_yapisi/src/models/vehicle.dart';
import 'package:bloc_yapisi/src/utils/global.dart';
import '../../models/vehicleDetail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/vehicle_repository.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final VehicleRepository vehicleRepository = VehicleRepository();

  DetailBloc() : super(DetailLoadingState()) {
    on<GetVehicleDetail>((event, emit) async {
      emit(DetailLoadingState());
      await Future.delayed(const Duration(milliseconds: 1555));
      try {
        final VehicleDetail vehicleDetail =
        await vehicleRepository.getVehicleDetail(deviceId: event.deviceId);
        final Vehicle? vehicle = list.firstWhere(
              (v) => v.id == event.deviceId,
          orElse: () => Vehicle(plate: 'Unknown', id: event.deviceId),
        );
        emit(DetailSuccessState(
          vehicleDetailData: vehicleDetail,
          vehiclePlate: vehicle!.plate,
        ));
      } catch (e) {
        emit(DetailErrorState());
      }
    });
  }
}

