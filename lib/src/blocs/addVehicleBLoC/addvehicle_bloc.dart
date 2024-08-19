import 'package:aractakip2/src/blocs/addVehicleBLoC/addvehicle_event.dart';
import 'package:aractakip2/src/blocs/addVehicleBLoC/addvehicle_state.dart';
import 'package:aractakip2/src/repositories/vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddvehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState> {
  final VehicleRepository vehicleRepository;
  bool isActive = true; // default value

  AddvehicleBloc({required this.vehicleRepository}) : super(UnAuthenticated(error: '')) {
    on<FetchVehiclesDetail>(_onFetchVehiclesDetail);
    on<AddVehicleRequsted>(_onAddVehicleRequested);
    on<ToggleIsActive>(_onToggleIsActive);
    on<LoadVehicleDetails>(_onLoadVehicleDetails);
  }

  void _onFetchVehiclesDetail(FetchVehiclesDetail event, Emitter<AddVehicleState> emit) async {
    emit(Loading());
    try {
      await for (final vehicle in vehicleRepository.getVehiclePlatesStream()) {
        emit(VehicleDetailsLoaded(vehicle));
      }
    } catch (e) {
      emit(VehicleDetailError("Failed to fetch vehicle plates"));
    }
  }

  void _onAddVehicleRequested(AddVehicleRequsted event, Emitter<AddVehicleState> emit) async {
    emit(Loading());
    try {
      await vehicleRepository.addVehicleToFirestore(
        fuelTankLevel: event.fuelTankLevel,
        longitude: event.longitude,
        latitude: event.latitude,
        speed: event.speed,
        deviceId: event.deviceId,
        km: event.km,
        isActive: event.isActive,
        sensors: event.sensors,
        plate: event.plate,
      );
      emit(AddVehicleSuccess());
    } catch (e) {
      emit(UnAuthenticated(error: e.toString()));
    }
  }

  void _onToggleIsActive(ToggleIsActive event, Emitter<AddVehicleState> emit) {
    isActive = event.isActive;
    emit(IsActiveChanged(isActive: isActive));
  }

  void _onLoadVehicleDetails(LoadVehicleDetails event, Emitter<AddVehicleState> emit) async {
    emit(Loading());
    try {
      final vehicle = await vehicleRepository.getVehicleDetail(event.plate);
      emit(VehicleDetailsLoaded(vehicle as List<String>));
    } catch (e) {
      emit(UnAuthenticated(error: e.toString()));
    }
  }
}

class IsActiveChanged extends AddVehicleState {
  final bool isActive;

  IsActiveChanged({required this.isActive});

  @override
  List<Object> get props => [isActive];
}
