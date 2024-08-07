import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapHiddenState()) {
    on<ToggleMapVisibility>(_onToggleMapVisibility);
    on<FetchLocation>(_onFetchLocation);
  }

  void _onToggleMapVisibility(
      ToggleMapVisibility event, Emitter<MapState> emit) {
    if (state is MapHiddenState) {
      emit(MapVisibleState(
        latitude: event.latitude,
        longitude: event.longitude,
      ));
    } else {
      emit(MapHiddenState());
    }
  }

  void _onFetchLocation(FetchLocation event, Emitter<MapState> emit) async {
    emit(LocationLoadingState());
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      emit(MapVisibleState(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      emit(LocationErrorState(message: 'Konum alınamadı: ${e.toString()}'));
    }
  }
}
