import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/vehicle.dart';
import '../../repositories/vehicle_repository.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final VehicleRepository vehicleRepository = VehicleRepository();


  ListBloc() : super(ListLoadingState()) {
    on<GetListVehicles>((event, emit) async {
      emit(ListLoadingState());
      await Future.delayed(const Duration(milliseconds: 1555));
      try {
        final List<Vehicle> vehicleList =
        await vehicleRepository.getVehicles(limit: event.limit);
        emit(ListSuccessState(listData: vehicleList));
      } catch (e) {
        emit(ListErrorState());
      }
    });




    on<DeleteVehicle>((event, emit) async {
      emit(DeleteLoading());
      await Future.delayed(const Duration(milliseconds: 1555));
      try {
        final List<Vehicle> vehicleList =
        await vehicleRepository.deleteVehicle(id: event.deviceId);
        emit(DeleteSuccess(listData: vehicleList));
      } catch (e) {
        emit(DelErrorState());
      }
    });
  }
}
