import 'package:just_weather/core/api_client.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class WeatherApiService {
  WeatherApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> getWeatherByQuery(String query) async {
    return _client.get(
      '/v1/forecast.json',
      query: {'q': query, 'days': '7', 'aqi': 'no', 'alerts': 'no'},
    );
  }

  Future<List<WeatherLocation>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    final result = await _client.getList(
      '/v1/search.json',
      query: {'q': query},
    );

    final list = result
        .cast<Map<String, dynamic>>()
        .map((e) => WeatherLocation.fromJson(e))
        .toList();

    return list.take(5).toList();
  }
}
