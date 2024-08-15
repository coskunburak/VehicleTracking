part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class ToggleMapVisibility extends MapEvent {
  final double latitude;
  final double longitude;

  const ToggleMapVisibility({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class FetchLocation extends MapEvent {
  @override
  List<Object> get props => [];
}
