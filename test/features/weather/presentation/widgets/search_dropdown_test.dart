import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/search_dropdown.dart';
import 'package:just_weather/features/weather/application/search_controller.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

void main() {
  WeatherLocation makeLocation(String name, String country) {
    return WeatherLocation(
      name: name,
      country: country,
      lat: 0,
      lon: 0,
      timezone: 'UTC',
    );
  }

  group('SearchDropdown', () {
    testWidgets(
      'cuando el campo NO tiene foco, no muestra nada (SizedBox.shrink)',
      (tester) async {
        final focusNode = FocusNode();

        final state = SearchState(
          query: '',
          isLoading: false,
          results: const [],
          recent: const [],
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchDropdown(
                focusNode: focusNode,
                searchState: state,
                onSelectLocation: (_) {},
                onClearAll: () {},
                onDeleteRecent: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Búsqueda...'), findsNothing);
        expect(find.text('Sin resultados'), findsNothing);
        expect(find.text('Búsquedas recientes'), findsNothing);
      },
    );

    testWidgets(
      'cuando hay query, está cargando y hay foco, muestra "Búsqueda..."',
      (tester) async {
        final focusNode = FocusNode();

        final state = SearchState(
          query: 'Bog',
          isLoading: true,
          results: const [],
          recent: const [],
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Focus(
                    focusNode: focusNode,
                    onFocusChange: (_) {
                      setState(() {});
                    },
                    child: SearchDropdown(
                      focusNode: focusNode,
                      searchState: state,
                      onSelectLocation: (_) {},
                      onClearAll: () {},
                      onDeleteRecent: (_) {},
                    ),
                  );
                },
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Búsqueda...'), findsOneWidget);

        focusNode.dispose();
      },
    );

    testWidgets('cuando hay query, error y foco, muestra mensaje de error', (
      tester,
    ) async {
      final focusNode = FocusNode();

      final state = SearchState(
        query: 'Bog',
        isLoading: false,
        results: const [],
        recent: const [],
        error: 'Error searching',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Focus(
                  focusNode: focusNode,
                  onFocusChange: (_) {
                    setState(() {});
                  },
                  child: SearchDropdown(
                    focusNode: focusNode,
                    searchState: state,
                    onSelectLocation: (_) {},
                    onClearAll: () {},
                    onDeleteRecent: (_) {},
                  ),
                );
              },
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(find.text('Error searching'), findsOneWidget);

      focusNode.dispose();
    });

    testWidgets(
      'cuando hay query, sin resultados y con foco, muestra "Sin resultados"',
      (tester) async {
        final focusNode = FocusNode();

        final state = SearchState(
          query: 'Bog',
          isLoading: false,
          results: const [],
          recent: const [],
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Focus(
                    focusNode: focusNode,
                    onFocusChange: (_) {
                      setState(() {});
                    },
                    child: SearchDropdown(
                      focusNode: focusNode,
                      searchState: state,
                      onSelectLocation: (_) {},
                      onClearAll: () {},
                      onDeleteRecent: (_) {},
                    ),
                  );
                },
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Sin resultados'), findsOneWidget);
      },
    );

    testWidgets(
      'cuando hay query, resultados y foco, muestra lista de resultados y llama onSelectLocation',
      (tester) async {
        final focusNode = FocusNode();

        final locations = [
          makeLocation('Bogotá', 'Colombia'),
          makeLocation('Madrid', 'Spain'),
        ];

        WeatherLocation? tapped;

        final state = SearchState(
          query: 'Bo',
          isLoading: false,
          results: locations,
          recent: const [],
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Focus(
                    focusNode: focusNode,
                    onFocusChange: (_) {
                      setState(() {});
                    },
                    child: SearchDropdown(
                      focusNode: focusNode,
                      searchState: state,
                      onSelectLocation: (loc) {
                        tapped = loc;
                      },
                      onClearAll: () {},
                      onDeleteRecent: (_) {},
                    ),
                  );
                },
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Bogotá, Colombia'), findsOneWidget);
        expect(find.text('Madrid, Spain'), findsOneWidget);

        await tester.tap(find.text('Madrid, Spain'));
        await tester.pumpAndSettle();

        expect(tapped, isNotNull);
        expect(tapped!.name, 'Madrid');
      },
    );

    testWidgets(
      'cuando no hay query, no hay recientes y hay foco, no muestra nada',
      (tester) async {
        final focusNode = FocusNode();

        final state = SearchState(
          query: '',
          isLoading: false,
          results: const [],
          recent: const [],
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Focus(
                focusNode: focusNode,
                child: SearchDropdown(
                  focusNode: focusNode,
                  searchState: state,
                  onSelectLocation: (_) {},
                  onClearAll: () {},
                  onDeleteRecent: (_) {},
                ),
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Búsquedas recientes'), findsNothing);
        expect(find.text('Borrar todo'), findsNothing);
      },
    );

    testWidgets(
      'cuando no hay query y hay recientes, muestra card de "Búsquedas recientes" y callbacks funcionan',
      (tester) async {
        final focusNode = FocusNode();

        final recent = [
          makeLocation('Bogotá', 'Colombia'),
          makeLocation('Madrid', 'Spain'),
        ];

        bool cleared = false;
        WeatherLocation? deleted;
        WeatherLocation? tappedRecent;

        final state = SearchState(
          query: '',
          isLoading: false,
          results: const [],
          recent: recent,
          error: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Focus(
                    focusNode: focusNode,
                    onFocusChange: (_) {
                      setState(() {});
                    },
                    child: SearchDropdown(
                      focusNode: focusNode,
                      searchState: state,
                      onSelectLocation: (loc) {
                        tappedRecent = loc;
                      },
                      onClearAll: () {
                        cleared = true;
                      },
                      onDeleteRecent: (loc) {
                        deleted = loc;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Búsquedas recientes'), findsOneWidget);
        expect(find.text('Borrar todo'), findsOneWidget);
        expect(find.text('Bogotá, Colombia'), findsOneWidget);
        expect(find.text('Madrid, Spain'), findsOneWidget);
        await tester.tap(find.text('Borrar todo'));
        await tester.pumpAndSettle();
        expect(cleared, isTrue);

        await tester.tap(find.text('Madrid, Spain'));
        await tester.pumpAndSettle();
        expect(tappedRecent, isNotNull);
        expect(tappedRecent!.name, 'Madrid');

        final deleteIconFinder = find
            .widgetWithIcon(IconButton, Icons.delete_outline)
            .first;
        await tester.tap(deleteIconFinder);
        await tester.pumpAndSettle();

        expect(deleted, isNotNull);
        expect(deleted!.name, 'Bogotá');
      },
    );
  });
}
