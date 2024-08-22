import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/models/weather.dart';
import 'package:bloc_yapisi/src/repositories/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository = WeatherRepository();
  bool aramaYapiliyorMu = false;

  WeatherBloc() : super(WeatherLoadingState()) {
    on<GetWeather>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        final Weather? weather = await weatherRepository.getWeather(event.city);
        if (weather != null) {
          emit(WeatherSuccessState(weatherDetailData: weather));
        } else {
          emit(WeatherErrorState());
        }
      } catch (e) {
        emit(WeatherErrorState());
      }
    });

    on<ToggleSearch>((event, emit) {
      aramaYapiliyorMu = !aramaYapiliyorMu;
      emit(SearchToggleState(aramaYapiliyorMu));
    });

    on<GetCitySuggestions>((event, emit) async {
      try {
        final List<String> cities =
            await weatherRepository.getCitySuggestions(event.query);
        emit(CitySuggestionsState(cities));
      } catch (e) {
        emit(WeatherErrorState());
      }
    });
  }
}
