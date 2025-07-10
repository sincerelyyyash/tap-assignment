import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_bloc.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_event.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_state.dart';
import 'package:tap_assignment/models/company_detail.dart';

import '../helpers/test_helpers.dart';

// Create a testable implementation that accepts HTTP client
class TestableCompanyDetailBloc
    extends Bloc<CompanyDetailEvent, CompanyDetailState> {
  final http.Client httpClient;

  TestableCompanyDetailBloc(this.httpClient)
    : super(const CompanyDetailInitial()) {
    on<LoadCompanyDetail>(_onLoadCompanyDetail);
  }

  Future<void> _onLoadCompanyDetail(
    LoadCompanyDetail event,
    Emitter<CompanyDetailState> emit,
  ) async {
    try {
      emit(const CompanyDetailLoading());

      final response = await httpClient.get(
        Uri.parse('https://eo61q3zd4heiwke.m.pipedream.net/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final companyDetail = CompanyDetail.fromJson(data);
        emit(CompanyDetailLoaded(companyDetail));
      } else {
        emit(
          CompanyDetailError(
            'Failed to load company details: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      emit(CompanyDetailError('Error loading company details: $e'));
    }
  }
}

void main() {
  late TestableCompanyDetailBloc companyDetailBloc;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    companyDetailBloc = TestableCompanyDetailBloc(mockHttpClient);

    // Register fallback values for mocktail
    registerFallbackValue(Uri());
  });

  tearDown(() {
    companyDetailBloc.close();
  });

  group('CompanyDetailBloc', () {
    test('initial state should be CompanyDetailInitial', () {
      expect(companyDetailBloc.state, const CompanyDetailInitial());
    });

    group('LoadCompanyDetail Event', () {
      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, loaded] when LoadCompanyDetail succeeds',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async =>
                createMockHttpResponse(body: testCompanyDetailJsonResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          CompanyDetailLoaded(testCompanyDetail),
        ],
        verify: (_) {
          verify(
            () => mockHttpClient.get(
              Uri.parse('https://eo61q3zd4heiwke.m.pipedream.net/'),
            ),
          ).called(1);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when HTTP call returns 404',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(
              body: '{"error": "Not Found"}',
              statusCode: 404,
            ),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          const CompanyDetailError('Failed to load company details: 404'),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when HTTP call returns 500',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(
              body: '{"error": "Internal Server Error"}',
              statusCode: 500,
            ),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          const CompanyDetailError('Failed to load company details: 500'),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when HTTP call returns 401',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(
              body: '{"error": "Unauthorized"}',
              statusCode: 401,
            ),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          const CompanyDetailError('Failed to load company details: 401'),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when response body is invalid JSON',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: 'Invalid JSON'),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          CompanyDetailError(
            'Error loading company details: FormatException: Unexpected character (at character 1)\nInvalid JSON\n^\n',
          ),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when network error occurs',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(
            () => mockHttpClient.get(any()),
          ).thenThrow(http.ClientException('Network error'));
        },
        expect: () => [
          const CompanyDetailLoading(),
          const CompanyDetailError(
            'Error loading company details: ClientException: Network error',
          ),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, error] when timeout occurs',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(
            () => mockHttpClient.get(any()),
          ).thenThrow(Exception('Connection timeout'));
        },
        expect: () => [
          const CompanyDetailLoading(),
          const CompanyDetailError(
            'Error loading company details: Exception: Connection timeout',
          ),
        ],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, loaded] with partial data when response has missing fields',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const partialResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Partial Company",
            "description": "Partial description",
            "isin": "INE123456789",
            "status": "Active"
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: partialResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.companyName, 'Partial Company');
          expect(state.companyDetail.prosAndCons.pros, isEmpty);
          expect(state.companyDetail.financials.ebitda, isEmpty);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, loaded] when response has null nested objects',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const nullFieldsResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Test Company",
            "description": "Test description",
            "isin": "INE123456789",
            "status": "Active",
            "pros_and_cons": null,
            "financials": null,
            "issuer_details": null
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: nullFieldsResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.prosAndCons.pros, isEmpty);
          expect(state.companyDetail.financials.ebitda, isEmpty);
          expect(state.companyDetail.issuerDetails.issuerName, '');
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, loaded] with complex financial data',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          final complexResponse =
              '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Complex Company",
            "description": "Complex company with extensive data",
            "isin": "INE999999999",
            "status": "Active",
            "pros_and_cons": {
              "pros": ["Pro 1", "Pro 2", "Pro 3", "Pro 4", "Pro 5"],
              "cons": ["Con 1", "Con 2", "Con 3"]
            },
            "financials": {
              "ebitda": ${json.encode(List.generate(12, (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 10000000}))},
              "revenue": ${json.encode(List.generate(12, (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 50000000}))}
            },
            "issuer_details": {
              "issuer_name": "Complex Issuer",
              "type_of_issuer": "Public",
              "sector": "Technology",
              "industry": "Software",
              "issuer_nature": "Public",
              "cin": "L99999MH2020PLC999999",
              "lead_manager": "Complex Lead Manager",
              "registrar": "Complex Registrar",
              "debenture_trustee": "Complex Trustee"
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: complexResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.companyName, 'Complex Company');
          expect(state.companyDetail.prosAndCons.pros, hasLength(5));
          expect(state.companyDetail.prosAndCons.cons, hasLength(3));
          expect(state.companyDetail.financials.ebitda, hasLength(12));
          expect(state.companyDetail.financials.revenue, hasLength(12));
          expect(state.companyDetail.financials.ebitda[11].value, 120000000);
          expect(state.companyDetail.financials.revenue[11].value, 600000000);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'should use correct API endpoint',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async =>
                createMockHttpResponse(body: testCompanyDetailJsonResponse),
          );
        },
        verify: (_) {
          verify(
            () => mockHttpClient.get(
              Uri.parse('https://eo61q3zd4heiwke.m.pipedream.net/'),
            ),
          ).called(1);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'emits [loading, loaded] with empty financial arrays',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const emptyFinancialsResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Empty Financials Company",
            "description": "Company with no financial data",
            "isin": "INE000000000",
            "status": "Active",
            "pros_and_cons": {
              "pros": [],
              "cons": []
            },
            "financials": {
              "ebitda": [],
              "revenue": []
            },
            "issuer_details": {
              "issuer_name": "Empty Company",
              "type_of_issuer": "",
              "sector": "",
              "industry": "",
              "issuer_nature": "",
              "cin": "",
              "lead_manager": "",
              "registrar": "",
              "debenture_trustee": ""
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: emptyFinancialsResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.financials.ebitda, isEmpty);
          expect(state.companyDetail.financials.revenue, isEmpty);
          expect(state.companyDetail.prosAndCons.pros, isEmpty);
          expect(state.companyDetail.prosAndCons.cons, isEmpty);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles malformed financial data gracefully',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const malformedFinancialsResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Malformed Company",
            "description": "Company with malformed financial data",
            "isin": "INE111111111",
            "status": "Active",
            "pros_and_cons": {
              "pros": ["Good management"],
              "cons": ["High risk"]
            },
            "financials": {
              "ebitda": [
                {"month": "January", "value": "invalid_number"},
                {"month": "February"}
              ],
              "revenue": [
                {"value": 50000000},
                {"month": "February", "value": 55000000}
              ]
            },
            "issuer_details": {
              "issuer_name": "Malformed Issuer",
              "type_of_issuer": "Corporate",
              "sector": "Finance",
              "industry": "Banking",
              "issuer_nature": "Private",
              "cin": "L11111MH2020PLC111111",
              "lead_manager": "Lead Manager",
              "registrar": "Registrar",
              "debenture_trustee": "Trustee"
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async =>
                createMockHttpResponse(body: malformedFinancialsResponse),
          );
        },
        expect: () => [const CompanyDetailLoading(), isA<CompanyDetailError>()],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles very large dataset successfully',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          final largeDataResponse =
              '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Large Data Company",
            "description": "${'Very long description. ' * 100}",
            "isin": "INE555555555",
            "status": "Active",
            "pros_and_cons": {
              "pros": ${json.encode(List.generate(50, (i) => 'Advantage ${i + 1}'))},
              "cons": ${json.encode(List.generate(25, (i) => 'Disadvantage ${i + 1}'))}
            },
            "financials": {
              "ebitda": ${json.encode(List.generate(60, (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 1000000}))},
              "revenue": ${json.encode(List.generate(60, (i) => {'month': 'Month ${i + 1}', 'value': (i + 1) * 5000000}))}
            },
            "issuer_details": {
              "issuer_name": "Large Data Issuer",
              "type_of_issuer": "Public",
              "sector": "Technology",
              "industry": "Software",
              "issuer_nature": "Public",
              "cin": "L55555MH2020PLC555555",
              "lead_manager": "Large Lead Manager",
              "registrar": "Large Registrar",
              "debenture_trustee": "Large Trustee"
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: largeDataResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.prosAndCons.pros, hasLength(50));
          expect(state.companyDetail.prosAndCons.cons, hasLength(25));
          expect(state.companyDetail.financials.ebitda, hasLength(60));
          expect(state.companyDetail.financials.revenue, hasLength(60));
        },
      );
    });

    group('Edge Cases', () {
      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles empty response body',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => createMockHttpResponse(body: ''));
        },
        expect: () => [const CompanyDetailLoading(), isA<CompanyDetailError>()],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles response with only whitespace',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => createMockHttpResponse(body: '   \n\t  '));
        },
        expect: () => [const CompanyDetailLoading(), isA<CompanyDetailError>()],
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles response with single financial data point',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const singlePointResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Single Point Company",
            "description": "Company with single data point",
            "isin": "INE777777777",
            "status": "Active",
            "pros_and_cons": {
              "pros": ["Single pro"],
              "cons": ["Single con"]
            },
            "financials": {
              "ebitda": [{"month": "January", "value": 1000000}],
              "revenue": [{"month": "January", "value": 5000000}]
            },
            "issuer_details": {
              "issuer_name": "Single Point Issuer",
              "type_of_issuer": "Corporate",
              "sector": "Finance",
              "industry": "Banking",
              "issuer_nature": "Private",
              "cin": "L77777MH2020PLC777777",
              "lead_manager": "Lead Manager",
              "registrar": "Registrar",
              "debenture_trustee": "Trustee"
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: singlePointResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(state.companyDetail.financials.ebitda, hasLength(1));
          expect(state.companyDetail.financials.revenue, hasLength(1));
          expect(state.companyDetail.financials.ebitda[0].value, 1000000);
        },
      );

      blocTest<TestableCompanyDetailBloc, CompanyDetailState>(
        'handles financial data with zero values',
        build: () => companyDetailBloc,
        act: (bloc) => bloc.add(const LoadCompanyDetail()),
        setUp: () {
          const zeroValuesResponse = '''
          {
            "logo": "https://example.com/logo.png",
            "company_name": "Zero Values Company",
            "description": "Company with zero financial values",
            "isin": "INE888888888",
            "status": "Active",
            "pros_and_cons": {
              "pros": ["Some advantages"],
              "cons": ["Some disadvantages"]
            },
            "financials": {
              "ebitda": [
                {"month": "January", "value": 0},
                {"month": "February", "value": 0},
                {"month": "March", "value": 0}
              ],
              "revenue": [
                {"month": "January", "value": 0},
                {"month": "February", "value": 1},
                {"month": "March", "value": 0}
              ]
            },
            "issuer_details": {
              "issuer_name": "Zero Values Issuer",
              "type_of_issuer": "Corporate",
              "sector": "Finance",
              "industry": "Banking",
              "issuer_nature": "Private",
              "cin": "L88888MH2020PLC888888",
              "lead_manager": "Lead Manager",
              "registrar": "Registrar",
              "debenture_trustee": "Trustee"
            }
          }
          ''';
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => createMockHttpResponse(body: zeroValuesResponse),
          );
        },
        expect: () => [
          const CompanyDetailLoading(),
          isA<CompanyDetailLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as CompanyDetailLoaded;
          expect(
            state.companyDetail.financials.ebitda.every(
              (data) => data.value == 0,
            ),
            isTrue,
          );
          expect(state.companyDetail.financials.revenue[1].value, 1);
        },
      );
    });
  });
}
