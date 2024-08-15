import 'package:dio/dio.dart';
import '../models/weather.dart';
import '../utils/global.dart';

class WeatherRepository {
  Future<Weather?> getWeather(String city) async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = "application/json; charset=UTF-8";
    var response = await dio
        .get('http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city');

    if (response.statusCode == 200) {
      Weather weather = Weather.fromJson(response.data);
      return weather;
    } else {
      throw Exception('Error fetching weather data');
    }
  }

  Future<List<String>> getCitySuggestions(String query) async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = "application/json; charset=UTF-8";

    var response = await dio
        .get('http://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query');


    if (response.statusCode == 200) {
      var data = response.data as List;
      List<String> cities = data.map((item) => item['name'] as String).toList();
      return cities;
    } else {
      throw Exception('Error fetching city suggestions');
    }
  }
}
