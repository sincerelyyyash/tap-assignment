import 'package:flutter_test/flutter_test.dart';
import 'package:tap_assignment/models/company.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Company', () {
    test('should create company from json correctly', () {
      final json = {
        'logo': 'https://example.com/logo.png',
        'isin': 'INE001A01036',
        'rating': 'AAA',
        'company_name': 'Test Company',
        'tags': ['Finance', 'Banking'],
      };

      final company = Company.fromJson(json);

      expect(company.logo, 'https://example.com/logo.png');
      expect(company.isin, 'INE001A01036');
      expect(company.rating, 'AAA');
      expect(company.companyName, 'Test Company');
      expect(company.tags, ['Finance', 'Banking']);
    });

    test('should convert company to json correctly', () {
      const company = Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE001A01036',
        rating: 'AAA',
        companyName: 'Test Company',
        tags: ['Finance', 'Banking'],
      );

      final json = company.toJson();

      expect(json['logo'], 'https://example.com/logo.png');
      expect(json['isin'], 'INE001A01036');
      expect(json['rating'], 'AAA');
      expect(json['company_name'], 'Test Company');
      expect(json['tags'], ['Finance', 'Banking']);
    });

    test('should support equality comparison', () {
      const company1 = Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE001A01036',
        rating: 'AAA',
        companyName: 'Test Company',
        tags: ['Finance', 'Banking'],
      );

      const company2 = Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE001A01036',
        rating: 'AAA',
        companyName: 'Test Company',
        tags: ['Finance', 'Banking'],
      );

      const company3 = Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE002A01018',
        rating: 'AAA',
        companyName: 'Test Company',
        tags: ['Finance', 'Banking'],
      );

      expect(company1, equals(company2));
      expect(company1, isNot(equals(company3)));
      expect(company1.hashCode, equals(company2.hashCode));
      expect(company1.hashCode, isNot(equals(company3.hashCode)));
    });

    test('should support copyWith functionality', () {
      const originalCompany = Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE001A01036',
        rating: 'AAA',
        companyName: 'Test Company',
        tags: ['Finance', 'Banking'],
      );

      final updatedCompany = originalCompany.copyWith(
        rating: 'AA+',
        companyName: 'Updated Company',
      );

      expect(updatedCompany.logo, originalCompany.logo);
      expect(updatedCompany.isin, originalCompany.isin);
      expect(updatedCompany.rating, 'AA+');
      expect(updatedCompany.companyName, 'Updated Company');
      expect(updatedCompany.tags, originalCompany.tags);
    });

    test('should handle empty tags list', () {
      final json = {
        'logo': 'https://example.com/logo.png',
        'isin': 'INE001A01036',
        'rating': 'AAA',
        'company_name': 'Test Company',
        'tags': <String>[],
      };

      final company = Company.fromJson(json);
      expect(company.tags, isEmpty);
    });

    test('should throw FormatException for invalid json', () {
      final invalidJson = {
        'logo': 'https://example.com/logo.png',
        // Missing required fields
      };

      expect(() => Company.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });
  });

  group('CompanyResponse', () {
    test('should create company response from json correctly', () {
      final json = {
        'data': [
          {
            'logo': 'https://example.com/logo1.png',
            'isin': 'INE001A01036',
            'rating': 'AAA',
            'company_name': 'Company 1',
            'tags': ['Finance'],
          },
          {
            'logo': 'https://example.com/logo2.png',
            'isin': 'INE002A01018',
            'rating': 'AA+',
            'company_name': 'Company 2',
            'tags': ['Technology'],
          },
        ],
      };

      final response = CompanyResponse.fromJson(json);

      expect(response.data, hasLength(2));
      expect(response.data[0].companyName, 'Company 1');
      expect(response.data[1].companyName, 'Company 2');
    });

    test('should convert company response to json correctly', () {
      const response = CompanyResponse(
        data: [
          Company(
            logo: 'https://example.com/logo.png',
            isin: 'INE001A01036',
            rating: 'AAA',
            companyName: 'Test Company',
            tags: ['Finance'],
          ),
        ],
      );

      final json = response.toJson();

      expect(json['data'], hasLength(1));
      expect(json['data'], isA<List<Company>>());
      expect(json['data'][0].companyName, 'Test Company');
    });

    test('should handle empty data array', () {
      final json = {'data': <Map<String, dynamic>>[]};

      final response = CompanyResponse.fromJson(json);
      expect(response.data, isEmpty);
    });

    test('should support equality comparison', () {
      const response1 = CompanyResponse(
        data: [
          Company(
            logo: 'https://example.com/logo.png',
            isin: 'INE001A01036',
            rating: 'AAA',
            companyName: 'Test Company',
            tags: ['Finance'],
          ),
        ],
      );

      const response2 = CompanyResponse(
        data: [
          Company(
            logo: 'https://example.com/logo.png',
            isin: 'INE001A01036',
            rating: 'AAA',
            companyName: 'Test Company',
            tags: ['Finance'],
          ),
        ],
      );

      expect(response1, equals(response2));
      expect(response1.hashCode, equals(response2.hashCode));
    });

    test('should support copyWith functionality', () {
      const originalResponse = CompanyResponse(
        data: [
          Company(
            logo: 'https://example.com/logo.png',
            isin: 'INE001A01036',
            rating: 'AAA',
            companyName: 'Test Company',
            tags: ['Finance'],
          ),
        ],
      );

      final updatedResponse = originalResponse.copyWith(data: []);

      expect(updatedResponse.data, isEmpty);
      expect(originalResponse.data, hasLength(1));
    });
  });
}
