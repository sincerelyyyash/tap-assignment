import 'dart:convert';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:tap_assignment/repositories/company_repository.dart';
import 'package:tap_assignment/models/company.dart';
import '../helpers/test_helpers.dart';

// Create a testable implementation that accepts HTTP client
class TestableCompanyRepositoryImpl implements CompanyRepository {
  final http.Client httpClient;
  final String _baseUrl = 'https://eol122duf9sy4de.m.pipedream.net/';

  TestableCompanyRepositoryImpl(this.httpClient);

  @override
  Future<List<Company>> getCompanies() async {
    try {
      final response = await httpClient.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final companyResponse = CompanyResponse.fromJson(jsonData);
        return companyResponse.data;
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }
}

void main() {
  late MockHttpClient mockHttpClient;
  late TestableCompanyRepositoryImpl repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = TestableCompanyRepositoryImpl(mockHttpClient);

    // Register fallback values for mocktail
    registerFallbackValue(Uri());
  });

  group('CompanyRepository', () {
    group('getCompanies', () {
      test(
        'should return list of companies when HTTP call is successful',
        () async {
          // Arrange
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async =>
                createMockHttpResponse(body: testCompaniesJsonResponse),
          );

          // Act
          final result = await repository.getCompanies();

          // Assert
          expect(result, isA<List<Company>>());
          expect(result, hasLength(2));
          expect(result[0].companyName, 'Reliance Industries Limited');
          expect(result[1].companyName, 'Tata Consultancy Services');
          verify(
            () => mockHttpClient.get(
              Uri.parse('https://eol122duf9sy4de.m.pipedream.net/'),
            ),
          ).called(1);
        },
      );

      test(
        'should throw exception when HTTP call returns error status code',
        () async {
          // Arrange
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(
              body: '{"error": "Internal Server Error"}',
              statusCode: 500,
            ),
          );

          // Act & Assert
          expect(
            () async => await repository.getCompanies(),
            throwsA(
              predicate(
                (e) =>
                    e is Exception &&
                    e.toString().contains('Failed to load companies: 500'),
              ),
            ),
          );
        },
      );

      test('should throw exception when HTTP call returns 404', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(
            body: '{"error": "Not Found"}',
            statusCode: 404,
          ),
        );

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies: 404'),
            ),
          ),
        );
      });

      test('should throw exception when HTTP call returns 401', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(
            body: '{"error": "Unauthorized"}',
            statusCode: 401,
          ),
        );

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies: 401'),
            ),
          ),
        );
      });

      test(
        'should throw exception when response body is invalid JSON',
        () async {
          // Arrange
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: 'Invalid JSON'),
          );

          // Act & Assert
          expect(
            () async => await repository.getCompanies(),
            throwsA(
              predicate(
                (e) =>
                    e is Exception &&
                    e.toString().contains('Failed to load companies:'),
              ),
            ),
          );
        },
      );

      test('should throw exception when network error occurs', () async {
        // Arrange
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(http.ClientException('Network error'));

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies:'),
            ),
          ),
        );
      });

      test('should handle empty company list successfully', () async {
        // Arrange
        const emptyResponse = '{"data": []}';
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => createMockHttpResponse(body: emptyResponse));

        // Act
        final result = await repository.getCompanies();

        // Assert
        expect(result, isA<List<Company>>());
        expect(result, isEmpty);
      });

      test('should handle malformed data in response', () async {
        // Arrange
        const malformedResponse = '''
        {
          "data": [
            {
              "logo": "https://example.com/logo.png",
              "isin": "INE001A01036",
              "rating": "AAA"
              // Missing required fields
            }
          ]
        }
        ''';
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(body: malformedResponse),
        );

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies:'),
            ),
          ),
        );
      });

      test('should handle timeout exception', () async {
        // Arrange
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(Exception('Connection timeout'));

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies:'),
            ),
          ),
        );
      });

      test('should handle response with null data field', () async {
        // Arrange
        const nullDataResponse = '{"data": null}';
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(body: nullDataResponse),
        );

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies:'),
            ),
          ),
        );
      });

      test('should handle response with missing data field', () async {
        // Arrange
        const missingDataResponse = '{"message": "success"}';
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(body: missingDataResponse),
        );

        // Act & Assert
        expect(
          () async => await repository.getCompanies(),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Failed to load companies:'),
            ),
          ),
        );
      });

      test('should use correct URL for API call', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(body: testCompaniesJsonResponse),
        );

        // Act
        await repository.getCompanies();

        // Assert
        verify(
          () => mockHttpClient.get(
            Uri.parse('https://eol122duf9sy4de.m.pipedream.net/'),
          ),
        ).called(1);
      });

      test('should handle large dataset successfully', () async {
        // Arrange
        final largeDataResponse = {
          'data': List.generate(
            1000,
            (index) => {
              'logo': 'https://example.com/logo$index.png',
              'isin': 'INE${index.toString().padLeft(6, '0')}A01036',
              'rating': index % 2 == 0 ? 'AAA' : 'AA+',
              'company_name': 'Company $index',
              'tags': ['Tag${index % 5}'],
            },
          ),
        };

        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async =>
              createMockHttpResponse(body: json.encode(largeDataResponse)),
        );

        // Act
        final result = await repository.getCompanies();

        // Assert
        expect(result, hasLength(1000));
        expect(result[0].companyName, 'Company 0');
        expect(result[999].companyName, 'Company 999');
      });

      test('should handle response with partial data correctly', () async {
        // Arrange
        const partialDataResponse = '''
        {
          "data": [
            {
              "logo": "",
              "isin": "INE001A01036",
              "rating": "",
              "company_name": "Partial Company",
              "tags": []
            }
          ]
        }
        ''';
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => createMockHttpResponse(body: partialDataResponse),
        );

        // Act
        final result = await repository.getCompanies();

        // Assert
        expect(result, hasLength(1));
        expect(result[0].companyName, 'Partial Company');
        expect(result[0].logo, isEmpty);
        expect(result[0].rating, isEmpty);
        expect(result[0].tags, isEmpty);
      });
    });
  });
}
