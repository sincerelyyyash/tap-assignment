import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:tap_assignment/main.dart';
import 'package:tap_assignment/blocs/company_search/company_search_bloc.dart';
import 'package:tap_assignment/repositories/company_repository.dart';
import 'package:tap_assignment/models/company.dart';

class MockCompanyRepository implements CompanyRepository {
  @override
  Future<List<Company>> getCompanies() async {
    return [
      const Company(
        logo: 'https://example.com/logo.png',
        isin: 'INE06E501754',
        rating: 'AAA',
        companyName: 'Test Company Limited',
        tags: ['Test'],
      ),
    ];
  }
}

void main() {
  setUp(() {
    GetIt.instance.reset();
    GetIt.instance.registerLazySingleton<CompanyRepository>(
      () => MockCompanyRepository(),
    );
    GetIt.instance.registerFactory<CompanySearchBloc>(
      () => CompanySearchBloc(GetIt.instance<CompanyRepository>()),
    );
  });

  testWidgets('Company search app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Check for app title in AppBar
    expect(find.text('Infrastructure Market'), findsOneWidget);
    // Check for search field placeholder
    expect(find.text('Search companies or ISIN'), findsOneWidget);
  });

  testWidgets('Search functionality test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Test');
    await tester.pumpAndSettle();
    expect(find.text('SEARCH RESULTS'), findsOneWidget);
  });

  testWidgets('Multi-term search functionality test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Test 1754');
    await tester.pumpAndSettle();
    expect(find.text('SEARCH RESULTS'), findsOneWidget);
  });
}
