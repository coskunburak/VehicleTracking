import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/vehicle_repository.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final VehicleRepository vehicleRepository;

  ListBloc(this.vehicleRepository) : super(ListInitial()) {
    on<FetchVehicles>(_onFetchVehicles);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  void _onFetchVehicles(FetchVehicles event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      await for (final plates in vehicleRepository.getVehiclePlatesStream()) {
        emit(ListLoaded(plates));
      }
    } catch (e) {
      emit(ListError("Failed to fetch vehicle plates"));
    }
  }

  Future<void> _onDeleteVehicle(
      DeleteVehicle event,
      Emitter<ListState> emit,
      ) async {
    try {
      await vehicleRepository.deleteVehicle(event.plate);
      // Listeyi güncelle
      final plates = await vehicleRepository.getVehiclePlatesStream().first;
      emit(ListLoaded(plates));
    } catch (e) {
      emit(ListError(e.toString()));
    }
  }
}
