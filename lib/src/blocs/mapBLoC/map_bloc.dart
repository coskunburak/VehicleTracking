import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapHiddenState()) {
    on<ToggleMapVisibility>((event, emit) {
      if (state is MapHiddenState) {
        emit(MapVisibleState(
          latitude: event.latitude,
          longitude: event.longitude,
        ));
      } else {
        emit(MapHiddenState());
      }
    });
  }
}
