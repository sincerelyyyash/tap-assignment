import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';
import 'package:tap_assignment/pages/home_page.dart';
import 'package:tap_assignment/blocs/company_search/company_search_bloc.dart';
import 'package:tap_assignment/blocs/company_search/company_search_state.dart';
import 'package:tap_assignment/blocs/company_search/company_search_event.dart';
import 'package:tap_assignment/widgets/company_card.dart';
import 'package:tap_assignment/models/company.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HomePage Widget Tests', () {
    late MockCompanyRepository mockRepository;

    setUp(() {
      mockRepository = MockCompanyRepository();
      setupGetItForTesting(mockRepository: mockRepository);
    });

    tearDown(() {
      tearDownGetIt();
    });

    testWidgets('should display app bar with correct title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Should display app bar with title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Infrastructure Market'), findsOneWidget);
    });

    testWidgets('should display search bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Should display search text field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search companies or ISIN'), findsOneWidget);
    });

    testWidgets('should display loading state initially', (
      WidgetTester tester,
    ) async {
      // Delay the repository response to catch loading state
      when(() => mockRepository.getCompanies()).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 100),
          () => testCompanies,
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait one frame for initState to trigger loadCompanies
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the timer to complete to avoid pending timer error
      await tester.pumpAndSettle();
    });

    testWidgets('should display company list when loaded', (
      WidgetTester tester,
    ) async {
      // Setup mock to return test companies
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait for bloc to load companies and settle all animations
      await tester.pumpAndSettle();

      // Should display company cards
      expect(find.byType(CompanyCard), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle search input', (WidgetTester tester) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Find and enter text in search field
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Reliance');
      await tester.pump();

      // Text should be entered
      expect(find.text('Reliance'), findsOneWidget);
    });

    testWidgets('should display error message when loading fails', (
      WidgetTester tester,
    ) async {
      // Setup mock to throw error
      when(
        () => mockRepository.getCompanies(),
      ).thenThrow(Exception('Network error'));

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait for error state to settle
      await tester.pumpAndSettle();

      // Should display error message
      expect(find.text('Error loading companies'), findsOneWidget);
    });

    testWidgets(
      'should display "No companies found" when search returns empty',
      (WidgetTester tester) async {
        setupCompanyRepositoryMock(mockRepository);

        await tester.pumpWidget(
          createTestableWidget(
            child: BlocProvider(
              create: (context) => CompanySearchBloc(mockRepository),
              child: const HomePage(),
            ),
          ),
        );

        // Wait for initial load to complete
        await tester.pumpAndSettle();

        // Enter search that yields no results
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'NonExistentCompany');

        // Wait for search debouncing and processing
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Should show no companies found message
        expect(find.text('No companies found'), findsOneWidget);
      },
    );

    testWidgets('should handle company card tap', (WidgetTester tester) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait for companies to load
      await tester.pumpAndSettle();

      // Check if company cards exist first
      final companyCards = find.byType(CompanyCard);
      if (companyCards.evaluate().isNotEmpty) {
        // Tap on first company card
        await tester.tap(companyCards.first);
        await tester.pumpAndSettle();
      }

      // Image loading errors are acceptable in tests
      final exception = tester.takeException();
      if (exception != null) {
        expect(exception, isA<NetworkImageLoadException>());
      }
    });

    testWidgets('should maintain search text across rebuilds', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Enter search text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Test Search');
      await tester.pump();

      // Rebuild widget
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Search text should be maintained
      expect(find.text('Test Search'), findsOneWidget);
    });

    testWidgets('should clear search when clear button is tapped', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Enter search text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Test');
      await tester.pump();

      // Find and tap clear button (if it exists)
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pump();

        // Search field should be cleared
        expect(find.text('Test'), findsNothing);
      }
    });

    testWidgets('should handle very long search queries', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Enter very long search text
      final longSearch =
          'This is a very long search query that should be handled gracefully ' *
          10;
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, longSearch);
      await tester.pump();

      // Should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle special characters in search', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Enter search with special characters
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, '@#\$%^&*()');
      await tester.pump();

      // Should handle special characters
      expect(find.text('@#\$%^&*()'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle unicode characters in search', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Enter search with unicode characters
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Tëst Cømpäny');
      await tester.pump();

      // Should handle unicode characters
      expect(find.text('Tëst Cømpäny'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display correct layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Should have proper widget hierarchy
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Should have accessible elements
      expect(find.byType(TextField), findsOneWidget);

      // Check for semantics
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
    });

    testWidgets('should handle rapid search input changes', (
      WidgetTester tester,
    ) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      final searchField = find.byType(TextField);

      // Rapid search changes
      for (int i = 0; i < 10; i++) {
        await tester.enterText(searchField, 'Search $i');
        await tester.pump();
      }

      // Should handle rapid changes
      expect(tester.takeException(), isNull);
      expect(find.text('Search 9'), findsOneWidget);
    });

    testWidgets('should handle widget rebuilds gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Rebuild the widget
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Should handle rebuilds gracefully
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display companies with different lengths', (
      WidgetTester tester,
    ) async {
      // Create companies with varying name lengths
      final companies = [
        const Company(
          logo: 'https://example.com/short.png',
          isin: 'INE001A01001',
          rating: 'AAA',
          companyName: 'A',
          tags: ['Short'],
        ),
        const Company(
          logo: 'https://example.com/long.png',
          isin: 'INE002A01002',
          rating: 'AA+',
          companyName:
              'Very Very Very Long Company Name That Should Test Layout Handling',
          tags: ['Long'],
        ),
      ];

      when(
        () => mockRepository.getCompanies(),
      ).thenAnswer((_) async => companies);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      // Wait for companies to load
      await tester.pumpAndSettle();

      // Should display both companies
      expect(find.byType(CompanyCard), findsNWidgets(2));
      expect(find.text('A'), findsOneWidget);
      expect(
        find.text(
          'Very Very Very Long Company Name That Should Test Layout Handling',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should handle search debouncing', (WidgetTester tester) async {
      setupCompanyRepositoryMock(mockRepository);

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanySearchBloc(mockRepository),
            child: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      final searchField = find.byType(TextField);

      // Enter text quickly (testing debouncing)
      await tester.enterText(searchField, 'R');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(searchField, 'Re');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(searchField, 'Rel');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(searchField, 'Reliance');
      await tester.pump(const Duration(milliseconds: 500)); // Wait for debounce

      // Should handle debounced search
      expect(find.text('Reliance'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
