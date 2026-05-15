// lib/core/models/weather_model.dart
class WeatherData {
  final double temperature;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature_2m'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: json['weather_code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature_2m': temperature,
      'wind_speed_10m': windSpeed,
      'precipitation': precipitation,
      'weather_code': weatherCode,
    };
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double precipitation;
  final double maxWindSpeed;
  final int weatherCode;
  final int alertLevel;
  final String alertLabel;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
    required this.maxWindSpeed,
    required this.weatherCode,
    required this.alertLevel,
    required this.alertLabel,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      maxWindSpeed: (json['maxWindSpeed'] as num).toDouble(),
      weatherCode: json['weatherCode'] as int,
      alertLevel: json['alertLevel'] as int,
      alertLabel: json['alertLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'precipitation': precipitation,
      'maxWindSpeed': maxWindSpeed,
      'weatherCode': weatherCode,
      'alertLevel': alertLevel,
      'alertLabel': alertLabel,
    };
  }
}

class WeatherResponse {
  final String city;
  final WeatherData? current;
  final List<ForecastDay>? forecast;

  WeatherResponse({
    required this.city,
    this.current,
    this.forecast,
  });

  factory WeatherResponse.fromCurrentJson(Map<String, dynamic> json) {
    return WeatherResponse(
      city: json['city'],
      current: WeatherData.fromJson(json['data']),
      forecast: null,
    );
  }

  factory WeatherResponse.fromForecastJson(Map<String, dynamic> json) {
    final forecastList = (json['forecast'] as List)
        .map((item) => ForecastDay.fromJson(item))
        .toList();
    return WeatherResponse(
      city: json['city'],
      current: null,
      forecast: forecastList,
    );
  }
}
