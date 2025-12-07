import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class SearchState {
  final bool isLoading;
  final String query;
  final List<WeatherLocation> results;
  final List<WeatherLocation> recent;
  final String? error;

  SearchState({
    this.isLoading = false,
    this.query = '',
    this.results = const [],
    this.recent = const [],
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<WeatherLocation>? results,
    List<WeatherLocation>? recent,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      results: results ?? this.results,
      recent: recent ?? this.recent,
      error: error,
    );
  }
}

class SearchController extends StateNotifier<SearchState> {
  SearchController(this._repo) : super(SearchState());

  final WeatherRepository _repo;
  Timer? _debounce;

  void onQueryChanged(String value) {
    state = state.copyWith(query: value);

    _debounce?.cancel();
    if (value.trim().isEmpty) {
      state = state.copyWith(results: [], error: null, isLoading: false);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value);
    });
  }

  Future<void> _search(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repo.searchLocations(query);
      state = state.copyWith(isLoading: false, results: results);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error searching locations',
        results: [],
      );
    }
  }

  void addRecent(WeatherLocation loc) {
    final existing = state.recent.where(
      (r) => r.name == loc.name && r.country == loc.country,
    );
    if (existing.isNotEmpty) return;

    final updated = [loc, ...state.recent];
    state = state.copyWith(recent: updated.take(5).toList());
  }

  void clearAllRecent() {
    state = state.copyWith(recent: []);
  }

  void deleteRecent(WeatherLocation loc) {
    final updated = state.recent
        .where((r) => !(r.name == loc.name && r.country == loc.country))
        .toList();
    state = state.copyWith(recent: updated);
  }
}
