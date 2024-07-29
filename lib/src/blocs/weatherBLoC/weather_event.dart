import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent {
  final String city;

  const GetWeather(this.city);

  @override
  List<Object> get props => [city];
}

class ToggleSearch extends WeatherEvent {
  const ToggleSearch();

  @override
  List<Object> get props => [];
}

class GetCitySuggestions extends WeatherEvent {
  final String query;

  const GetCitySuggestions(this.query);

  @override
  List<Object> get props => [query];
}
