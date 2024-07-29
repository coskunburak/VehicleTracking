class Weather {
  final double tempC;
  final String name;

  Weather({required this.tempC, required this.name});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      tempC: json['current']['temp_c'],
      name: json['location']['name'],
    );
  }
}
