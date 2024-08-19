import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/vehicle_repository.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final VehicleRepository vehicleRepository;

  ListBloc(this.vehicleRepository) : super(ListInitial()) {
    on<FetchVehicles>(_onFetchVehicles);
    on<DeleteVehicle>(_onDeleteVehicle);
    on<UpdateVehicleList>(_onUpdateVehicleList); // Handle the new event
  }

  void _onFetchVehicles(FetchVehicles event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      await for (final plates in vehicleRepository.getVehiclePlatesStream()) {
        final vehicleDetails = await Future.wait(
          plates.map((plate) => vehicleRepository.getVehicleDetailStream(plate).first),
        );
        emit(ListLoaded(plates, vehicleDetails));
      }
    } catch (e) {
      emit(ListError("Failed to fetch vehicle plates: ${e.toString()}"));
    }
  }

  void _onUpdateVehicleList(UpdateVehicleList event, Emitter<ListState> emit) {
    emit(ListLoaded(event.plates, event.vehicleDetails));
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<ListState> emit) async {
    try {
      await vehicleRepository.deleteVehicle(event.plate);
      final plates = await vehicleRepository.getVehiclePlatesStream().first;
      final vehicleDetails = await Future.wait(
        plates.map((plate) => vehicleRepository.getVehicleDetailStream(plate).first),
      );
      emit(ListLoaded(plates, vehicleDetails));
    } catch (e) {
      emit(ListError(e.toString()));
    }
  }
}
