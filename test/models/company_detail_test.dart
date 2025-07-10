import 'package:flutter_test/flutter_test.dart';
import 'package:tap_assignment/models/company_detail.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CompanyDetail', () {
    test('should create company detail from json correctly', () {
      final json = {
        'logo': 'https://example.com/logo.png',
        'company_name': 'Test Company',
        'description': 'Test Description',
        'isin': 'INE123456789',
        'status': 'Active',
        'pros_and_cons': {
          'pros': ['Good management', 'Strong financials'],
          'cons': ['High debt', 'Market risk'],
        },
        'financials': {
          'ebitda': [
            {'month': 'Jan', 'value': 1000},
            {'month': 'Feb', 'value': 1200},
          ],
          'revenue': [
            {'month': 'Jan', 'value': 5000},
            {'month': 'Feb', 'value': 5200},
          ],
        },
        'issuer_details': {
          'issuer_name': 'Test Company',
          'type_of_issuer': 'Corporate',
          'sector': 'Technology',
          'industry': 'Software',
          'issuer_nature': 'Private',
          'cin': 'L12345MH2020PLC123456',
          'lead_manager': 'Lead Manager',
          'registrar': 'Registrar',
          'debenture_trustee': 'Trustee',
        },
      };

      final companyDetail = CompanyDetail.fromJson(json);

      expect(companyDetail.logo, 'https://example.com/logo.png');
      expect(companyDetail.companyName, 'Test Company');
      expect(companyDetail.description, 'Test Description');
      expect(companyDetail.isin, 'INE123456789');
      expect(companyDetail.status, 'Active');
      expect(companyDetail.prosAndCons.pros, [
        'Good management',
        'Strong financials',
      ]);
      expect(companyDetail.prosAndCons.cons, ['High debt', 'Market risk']);
      expect(companyDetail.financials.ebitda, hasLength(2));
      expect(companyDetail.financials.revenue, hasLength(2));
      expect(companyDetail.issuerDetails.issuerName, 'Test Company');
    });

    test('should handle missing fields with default values', () {
      final json = <String, dynamic>{};

      final companyDetail = CompanyDetail.fromJson(json);

      expect(companyDetail.logo, '');
      expect(companyDetail.companyName, '');
      expect(companyDetail.description, '');
      expect(companyDetail.isin, '');
      expect(companyDetail.status, '');
      expect(companyDetail.prosAndCons.pros, isEmpty);
      expect(companyDetail.prosAndCons.cons, isEmpty);
      expect(companyDetail.financials.ebitda, isEmpty);
      expect(companyDetail.financials.revenue, isEmpty);
    });

    test('should handle null nested objects', () {
      final json = {
        'logo': 'https://example.com/logo.png',
        'company_name': 'Test Company',
        'description': 'Test Description',
        'isin': 'INE123456789',
        'status': 'Active',
        'pros_and_cons': null,
        'financials': null,
        'issuer_details': null,
      };

      final companyDetail = CompanyDetail.fromJson(json);

      expect(companyDetail.prosAndCons.pros, isEmpty);
      expect(companyDetail.prosAndCons.cons, isEmpty);
      expect(companyDetail.financials.ebitda, isEmpty);
      expect(companyDetail.financials.revenue, isEmpty);
      expect(companyDetail.issuerDetails.issuerName, '');
    });
  });

  group('ProsAndCons', () {
    test('should create pros and cons from json correctly', () {
      final json = {
        'pros': ['Strong management', 'Good financials'],
        'cons': ['High debt', 'Market volatility'],
      };

      final prosAndCons = ProsAndCons.fromJson(json);

      expect(prosAndCons.pros, ['Strong management', 'Good financials']);
      expect(prosAndCons.cons, ['High debt', 'Market volatility']);
    });

    test('should handle empty lists', () {
      final json = {'pros': <String>[], 'cons': <String>[]};

      final prosAndCons = ProsAndCons.fromJson(json);

      expect(prosAndCons.pros, isEmpty);
      expect(prosAndCons.cons, isEmpty);
    });

    test('should handle missing fields with empty lists', () {
      final json = <String, dynamic>{};

      final prosAndCons = ProsAndCons.fromJson(json);

      expect(prosAndCons.pros, isEmpty);
      expect(prosAndCons.cons, isEmpty);
    });
  });

  group('Financials', () {
    test('should create financials from json correctly', () {
      final json = {
        'ebitda': [
          {'month': 'January', 'value': 10000},
          {'month': 'February', 'value': 12000},
        ],
        'revenue': [
          {'month': 'January', 'value': 50000},
          {'month': 'February', 'value': 55000},
        ],
      };

      final financials = Financials.fromJson(json);

      expect(financials.ebitda, hasLength(2));
      expect(financials.ebitda[0].month, 'January');
      expect(financials.ebitda[0].value, 10000);
      expect(financials.revenue, hasLength(2));
      expect(financials.revenue[0].month, 'January');
      expect(financials.revenue[0].value, 50000);
    });

    test('should handle empty financial data', () {
      final json = {
        'ebitda': <Map<String, dynamic>>[],
        'revenue': <Map<String, dynamic>>[],
      };

      final financials = Financials.fromJson(json);

      expect(financials.ebitda, isEmpty);
      expect(financials.revenue, isEmpty);
    });

    test('should handle missing fields with empty lists', () {
      final json = <String, dynamic>{};

      final financials = Financials.fromJson(json);

      expect(financials.ebitda, isEmpty);
      expect(financials.revenue, isEmpty);
    });
  });

  group('FinancialData', () {
    test('should create financial data from json correctly', () {
      final json = {'month': 'January', 'value': 15000};

      final financialData = FinancialData.fromJson(json);

      expect(financialData.month, 'January');
      expect(financialData.value, 15000);
    });

    test('should handle missing fields with default values', () {
      final json = <String, dynamic>{};

      final financialData = FinancialData.fromJson(json);

      expect(financialData.month, '');
      expect(financialData.value, 0);
    });

    test('should handle null values', () {
      final json = {'month': null, 'value': null};

      final financialData = FinancialData.fromJson(json);

      expect(financialData.month, '');
      expect(financialData.value, 0);
    });
  });

  group('IssuerDetails', () {
    test('should create issuer details from json correctly', () {
      final json = {
        'issuer_name': 'Test Issuer',
        'type_of_issuer': 'Corporate',
        'sector': 'Technology',
        'industry': 'Software',
        'issuer_nature': 'Private',
        'cin': 'L12345MH2020PLC123456',
        'lead_manager': 'Lead Manager',
        'registrar': 'Registrar',
        'debenture_trustee': 'Trustee',
      };

      final issuerDetails = IssuerDetails.fromJson(json);

      expect(issuerDetails.issuerName, 'Test Issuer');
      expect(issuerDetails.typeOfIssuer, 'Corporate');
      expect(issuerDetails.sector, 'Technology');
      expect(issuerDetails.industry, 'Software');
      expect(issuerDetails.issuerNature, 'Private');
      expect(issuerDetails.cin, 'L12345MH2020PLC123456');
      expect(issuerDetails.leadManager, 'Lead Manager');
      expect(issuerDetails.registrar, 'Registrar');
      expect(issuerDetails.debentureTrustee, 'Trustee');
    });

    test('should handle missing fields with default values', () {
      final json = <String, dynamic>{};

      final issuerDetails = IssuerDetails.fromJson(json);

      expect(issuerDetails.issuerName, '');
      expect(issuerDetails.typeOfIssuer, '');
      expect(issuerDetails.sector, '');
      expect(issuerDetails.industry, '');
      expect(issuerDetails.issuerNature, '');
      expect(issuerDetails.cin, '');
      expect(issuerDetails.leadManager, '');
      expect(issuerDetails.registrar, '');
      expect(issuerDetails.debentureTrustee, '');
    });

    test('should handle null values', () {
      final json = {
        'issuer_name': null,
        'type_of_issuer': null,
        'sector': null,
        'industry': null,
        'issuer_nature': null,
        'cin': null,
        'lead_manager': null,
        'registrar': null,
        'debenture_trustee': null,
      };

      final issuerDetails = IssuerDetails.fromJson(json);

      expect(issuerDetails.issuerName, '');
      expect(issuerDetails.typeOfIssuer, '');
      expect(issuerDetails.sector, '');
      expect(issuerDetails.industry, '');
      expect(issuerDetails.issuerNature, '');
      expect(issuerDetails.cin, '');
      expect(issuerDetails.leadManager, '');
      expect(issuerDetails.registrar, '');
      expect(issuerDetails.debentureTrustee, '');
    });
  });

  group('Integration Tests', () {
    test('should handle complex nested data correctly', () {
      final companyDetail = CompanyDetail.fromJson({
        'logo': 'https://example.com/logo.png',
        'company_name': 'Complex Test Company',
        'description': 'A company with complex nested data',
        'isin': 'INE999A99999',
        'status': 'Active',
        'pros_and_cons': {
          'pros': ['Multiple', 'Pros', 'Listed'],
          'cons': ['Multiple', 'Cons', 'Listed'],
        },
        'financials': {
          'ebitda': List.generate(
            12,
            (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 1000},
          ),
          'revenue': List.generate(
            12,
            (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 5000},
          ),
        },
        'issuer_details': {
          'issuer_name': 'Complex Issuer Name',
          'type_of_issuer': 'Public',
          'sector': 'Financial Services',
          'industry': 'Banking',
          'issuer_nature': 'Public',
          'cin': 'L99999MH2020PLC999999',
          'lead_manager': 'Complex Lead Manager',
          'registrar': 'Complex Registrar',
          'debenture_trustee': 'Complex Trustee',
        },
      });

      expect(companyDetail.prosAndCons.pros, hasLength(3));
      expect(companyDetail.prosAndCons.cons, hasLength(3));
      expect(companyDetail.financials.ebitda, hasLength(12));
      expect(companyDetail.financials.revenue, hasLength(12));
      expect(companyDetail.financials.ebitda[11].value, 12000);
      expect(companyDetail.financials.revenue[11].value, 60000);
    });
  });
}
