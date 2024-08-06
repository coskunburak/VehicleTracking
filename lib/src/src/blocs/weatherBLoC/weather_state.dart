import 'package:bloc_yapisi/src/models/weather.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherLoadingState extends WeatherState {
  @override
  List<dynamic> get props => [];
}

class WeatherSuccessState extends WeatherState {
  const WeatherSuccessState({required this.weatherDetailData});

  final Weather weatherDetailData;

  @override
  List<dynamic> get props => [weatherDetailData];
}

class WeatherErrorState extends WeatherState {
  @override
  List<dynamic> get props => [];
}

class SearchToggleState extends WeatherState {
  final bool aramaYapiliyorMu;

  const SearchToggleState(this.aramaYapiliyorMu);

  @override
  List<Object> get props => [aramaYapiliyorMu];
}

class CitySuggestionsState extends WeatherState {
  final List<String> cities;

  const CitySuggestionsState(this.cities);

  @override
  List<Object> get props => [cities];
}
