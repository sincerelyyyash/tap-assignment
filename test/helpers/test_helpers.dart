import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:tap_assignment/models/company.dart';
import 'package:tap_assignment/models/company_detail.dart';
import 'package:tap_assignment/repositories/company_repository.dart';
import 'package:tap_assignment/blocs/company_search/company_search_bloc.dart';
import 'package:tap_assignment/blocs/company_search/company_search_state.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_bloc.dart';

// Mock Classes
class MockCompanyRepository extends Mock implements CompanyRepository {}

class MockHttpClient extends Mock implements http.Client {}

// Test Data
final testCompanies = [
  const Company(
    logo: 'assets/images/placeholder.png',
    isin: 'US0378331005', // Apple Inc ISIN
    rating: 'AAA',
    companyName: 'Apple Inc.',
    tags: ['Technology', 'Consumer Electronics'],
  ),
  const Company(
    logo: 'assets/images/placeholder.png',
    isin: 'INE001A01036',
    rating: 'AAA',
    companyName: 'Reliance Industries Limited',
    tags: ['Energy', 'Petrochemicals'],
  ),
  const Company(
    logo: 'assets/images/placeholder.png',
    isin: 'INE002A01018',
    rating: 'AA+',
    companyName: 'Tata Consultancy Services',
    tags: ['IT', 'Services'],
  ),
  const Company(
    logo: 'assets/images/placeholder.png',
    isin: 'INE009A01021',
    rating: 'AA',
    companyName: 'Infosys Limited',
    tags: ['IT', 'Technology'],
  ),
];

final testCompanyDetail = CompanyDetail(
  logo: 'https://example.com/detail_logo.png',
  companyName: 'Test Company Limited',
  description: 'A comprehensive test company for unit testing',
  isin: 'INE123A01234',
  status: 'Active',
  prosAndCons: ProsAndCons(
    pros: ['Strong financial performance', 'Experienced management team'],
    cons: ['High debt levels', 'Market volatility risk'],
  ),
  financials: Financials(
    ebitda: [
      FinancialData(month: 'January', value: 10000000),
      FinancialData(month: 'February', value: 12000000),
      FinancialData(month: 'March', value: 15000000),
    ],
    revenue: [
      FinancialData(month: 'January', value: 50000000),
      FinancialData(month: 'February', value: 55000000),
      FinancialData(month: 'March', value: 60000000),
    ],
  ),
  issuerDetails: IssuerDetails(
    issuerName: 'Test Company Limited',
    typeOfIssuer: 'Corporate',
    sector: 'Technology',
    industry: 'Software',
    issuerNature: 'Private',
    cin: 'L12345AB2020PLC123456',
    leadManager: 'ABC Capital',
    registrar: 'XYZ Registrars',
    debentureTrustee: 'DEF Trustees',
  ),
);

// JSON Response Data
const testCompaniesJsonResponse = '''
{
  "data": [
    {
      "logo": "https://example.com/logo1.png",
      "isin": "INE001A01036",
      "rating": "AAA",
      "company_name": "Reliance Industries Limited",
      "tags": ["Energy", "Petrochemicals"]
    },
    {
      "logo": "https://example.com/logo2.png",
      "isin": "INE002A01018",
      "rating": "AA+",
      "company_name": "Tata Consultancy Services",
      "tags": ["IT", "Services"]
    }
  ]
}
''';

const testCompanyDetailJsonResponse = '''
{
  "logo": "https://example.com/detail_logo.png",
  "company_name": "Test Company Limited",
  "description": "A comprehensive test company for unit testing",
  "isin": "INE123A01234",
  "status": "Active",
  "pros_and_cons": {
    "pros": ["Strong financial performance", "Experienced management team"],
    "cons": ["High debt levels", "Market volatility risk"]
  },
  "financials": {
    "ebitda": [
      {"month": "January", "value": 10000000},
      {"month": "February", "value": 12000000},
      {"month": "March", "value": 15000000}
    ],
    "revenue": [
      {"month": "January", "value": 50000000},
      {"month": "February", "value": 55000000},
      {"month": "March", "value": 60000000}
    ]
  },
  "issuer_details": {
    "issuer_name": "Test Company Limited",
    "type_of_issuer": "Corporate",
    "sector": "Technology",
    "industry": "Software",
    "issuer_nature": "Private",
    "cin": "L12345AB2020PLC123456",
    "lead_manager": "ABC Capital",
    "registrar": "XYZ Registrars",
    "debenture_trustee": "DEF Trustees"
  }
}
''';

// Utility Functions
Widget createTestableWidget({
  required Widget child,
  CompanySearchBloc? companySearchBloc,
  CompanyDetailBloc? companyDetailBloc,
}) {
  // If no BLoCs are provided, just wrap in MaterialApp
  if (companySearchBloc == null && companyDetailBloc == null) {
    return MaterialApp(home: child);
  }

  // Create providers list only if BLoCs are provided
  final providers = <BlocProvider>[
    if (companySearchBloc != null)
      BlocProvider<CompanySearchBloc>.value(value: companySearchBloc),
    if (companyDetailBloc != null)
      BlocProvider<CompanyDetailBloc>.value(value: companyDetailBloc),
  ];

  return MaterialApp(
    home: MultiBlocProvider(providers: providers, child: child),
  );
}

http.Response createMockHttpResponse({
  required String body,
  int statusCode = 200,
  Map<String, String>? headers,
}) {
  return http.Response(
    body,
    statusCode,
    headers: headers ?? {'content-type': 'application/json'},
  );
}

// Setup and Teardown helpers
void setupMockHttpResponses(MockHttpClient mockClient) {
  // Default successful responses
  when(() => mockClient.get(any())).thenAnswer(
    (_) async => createMockHttpResponse(body: testCompaniesJsonResponse),
  );
}

void setupCompanyRepositoryMock(MockCompanyRepository mockRepository) {
  when(
    () => mockRepository.getCompanies(),
  ).thenAnswer((_) async => testCompanies);
}

// GetIt setup helpers
void setupGetItForTesting({CompanyRepository? mockRepository}) {
  // Reset GetIt
  GetIt.instance.reset();

  // Register mock repository
  final repository = mockRepository ?? MockCompanyRepository();
  if (repository is MockCompanyRepository) {
    setupCompanyRepositoryMock(repository);
  }

  GetIt.instance.registerLazySingleton<CompanyRepository>(() => repository);
  GetIt.instance.registerFactory<CompanySearchBloc>(
    () => CompanySearchBloc(GetIt.instance<CompanyRepository>()),
  );
  GetIt.instance.registerFactory<CompanyDetailBloc>(() => CompanyDetailBloc());
}

void tearDownGetIt() {
  GetIt.instance.reset();
}
