part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapHiddenState extends MapState {
  @override
  List<Object> get props => [];
}

class MapVisibleState extends MapState {
  final double latitude;
  final double longitude;

  const MapVisibleState({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class LocationLoadingState extends MapState {
  @override
  List<Object> get props => [];
}

class LocationErrorState extends MapState {
  final String message;

  const LocationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
