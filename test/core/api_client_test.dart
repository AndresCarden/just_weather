import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/core/api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late ApiClient api;

  setUp(() {
    mockClient = MockHttpClient();
    api = ApiClient(
      mockClient,
      baseUrl: 'https://api.fake.com',
      apiKey: 'ABC123',
    );
  });

  group('ApiClient.get()', () {
    test('retorna JSON cuando status 200', () async {
      // Arrange
      final fakeResponse = {'temp': 25};

      final expectedUri = Uri.parse(
        'https://api.fake.com/weather',
      ).replace(queryParameters: {'key': 'ABC123'});

      when(
        () => mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 200));

      // Act
      final result = await api.get('/weather');

      // Assert
      expect(result, fakeResponse);

      verify(() => mockClient.get(expectedUri)).called(1);
    });

    test('incluye query params correctamente', () async {
      final expectedUri = Uri.parse(
        'https://api.fake.com/search',
      ).replace(queryParameters: {'key': 'ABC123', 'q': 'London'});

      when(
        () => mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response('{}', 200));

      await api.get('/search', query: {'q': 'London'});

      verify(() => mockClient.get(expectedUri)).called(1);
    });

    test('lanza ApiException cuando status no 2xx', () async {
      final expectedUri = Uri.parse(
        'https://api.fake.com/fail',
      ).replace(queryParameters: {'key': 'ABC123'});

      when(
        () => mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response('Error', 404));

      expect(
        () => api.get('/fail'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });

  group('ApiClient.getList()', () {
    test('retorna lista JSON cuando status 200', () async {
      final fakeList = [1, 2, 3];

      final expectedUri = Uri.parse(
        'https://api.fake.com/numbers',
      ).replace(queryParameters: {'key': 'ABC123'});

      when(
        () => mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response(jsonEncode(fakeList), 200));

      final result = await api.getList('/numbers');

      expect(result, fakeList);
      verify(() => mockClient.get(expectedUri)).called(1);
    });

    test('lanza ApiException cuando status no 2xx', () async {
      final expectedUri = Uri.parse(
        'https://api.fake.com/error',
      ).replace(queryParameters: {'key': 'ABC123'});

      when(
        () => mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response('Oops', 500));

      expect(
        () => api.getList('/error'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
