import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/vehicle_repository.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final VehicleRepository vehicleRepository;

  DetailBloc({required this.vehicleRepository}) : super(DetailLoadingState()) {
    on<GetVehicleDetail>((event, emit) async {
      emit(DetailLoadingState());
      try {
        final vehicleDetail = await vehicleRepository.getVehicleDetail(event.plate);
        emit(DetailSuccessState(vehicleDetailData: vehicleDetail));
      } catch (e) {
        emit(DetailErrorState());
      }
    });
  }
}
