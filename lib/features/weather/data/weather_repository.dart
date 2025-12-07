import 'package:just_weather/features/weather/models/weather_models.dart';
import 'weather_api_service.dart';

abstract class WeatherRepository {
  Future<FullWeather> getWeather(String query);
  Future<List<WeatherLocation>> searchLocations(String query);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _service;

  WeatherRepositoryImpl(this._service);

  @override
  Future<FullWeather> getWeather(String query) async {
    final json = await _service.getWeatherByQuery(query);
    return FullWeather.fromJson(json);
  }

  @override
  Future<List<WeatherLocation>> searchLocations(String query) {
    return _service.searchLocations(query);
  }
}
