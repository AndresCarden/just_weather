import 'package:flutter/material.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/application/search_controller.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class SearchDropdown extends StatelessWidget {
  const SearchDropdown({
    super.key,
    required this.focusNode,
    required this.searchState,
    required this.onSelectLocation,
    required this.onClearAll,
    required this.onDeleteRecent,
  });

  final FocusNode focusNode;
  final SearchState searchState;
  final void Function(WeatherLocation) onSelectLocation;
  final VoidCallback onClearAll;
  final void Function(WeatherLocation) onDeleteRecent;

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    final hasQuery = searchState.query.trim().isNotEmpty;

    if (!isFocused) return const SizedBox.shrink();

    if (hasQuery) {
      if (searchState.isLoading) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: Text('Búsqueda...', style: AppTextStyles.body),
        );
      }

      if (searchState.error != null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            searchState.error!,
            style: AppTextStyles.body.copyWith(color: Colors.red),
          ),
        );
      }

      if (searchState.results.isEmpty) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: Text('Sin resultados', style: AppTextStyles.body),
        );
      }

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: searchState.results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final loc = searchState.results[index];
            return ListTile(
              dense: true,
              title: Text(
                '${loc.name}, ${loc.country}',
                style: AppTextStyles.body,
              ),
              onTap: () => onSelectLocation(loc),
            );
          },
        ),
      );
    }

    if (searchState.recent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Text('Búsquedas recientes', style: AppTextStyles.body3),
                const Spacer(),
                TextButton(
                  onPressed: onClearAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: Colors.indigo.shade400,
                  ),
                  child: Text(
                    'Borrar todo',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: searchState.recent.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final loc = searchState.recent[index];
              return ListTile(
                dense: true,
                title: Text('${loc.name}, ${loc.country}'),
                onTap: () => onSelectLocation(loc),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: Colors.grey[600],
                  onPressed: () => onDeleteRecent(loc),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
