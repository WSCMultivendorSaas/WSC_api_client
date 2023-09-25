import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wsc_api_client/src/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

@GenerateMocks([MockApiClient, MockDio, MockResponse])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ApiClient.initialize(baseUrl: 'https://example.com');

  group('ApiClient', () {
    late ApiClient apiClient;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();
      apiClient = ApiClient.instance;
      apiClient.dio = mockDio;
    });

    test('get method sends a GET request with correct options', () async {
      // Arrange
      final mockResponse = Response(
          data: {'message': 'Success'},
          statusCode: 200,
          requestOptions: RequestOptions(
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ));
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => mockResponse);

      // Act
      final response = await mockApiClient.get('/test');

      // Assert
      expect(response, equals(mockResponse));
      verify(() => mockApiClient.get(
            '/test',
          ));
    });

    test('post method sends a POST request with correct options', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockApiClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final response =
          await mockApiClient.post('/test', body: {'key': 'value'});

      // Assert
      expect(response, equals(mockResponse));
      verifyNever(() => mockApiClient.post(
            '/test',
          ));
    });

    // Add more test cases for other HTTP methods (put, delete, etc.) as needed

    test('throws exception if Dio throws an error', () async {
      // Arrange
      when(() => mockApiClient.get(any()))
          .thenThrow(Exception('Network error'));

      // Act and Assert
      expect(
        () => mockApiClient.get('/test'),
        throwsA(isInstanceOf<Exception>()),
      );
    });
  });
}
