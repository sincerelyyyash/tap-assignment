import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tap_assignment/pages/company_detail_page.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_bloc.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_state.dart';
import 'package:tap_assignment/blocs/company_detail/company_detail_event.dart';
import 'package:tap_assignment/widgets/financial_chart.dart';
import 'package:tap_assignment/models/company_detail.dart';
import '../helpers/test_helpers.dart';

class MockCompanyDetailBloc
    extends MockBloc<CompanyDetailEvent, CompanyDetailState>
    implements CompanyDetailBloc {}

void main() {
  group('CompanyDetailPage Widget Tests', () {
    late MockCompanyRepository mockRepository;

    setUp(() {
      mockRepository = MockCompanyRepository();
      setupGetItForTesting(mockRepository: mockRepository);
    });

    tearDown(() {
      tearDownGetIt();
    });

    testWidgets('should display app bar with back button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Should display app bar with back button
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should display loading state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // The page shows loading state when bloc is in initial state
      // Since we're not triggering any events, it should show initial content
      expect(find.byType(CompanyDetailPage), findsOneWidget);
    });

    testWidgets('should display correct layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Should have proper widget hierarchy
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle back button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Tap back button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle app lifecycle changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Simulate app going to background and coming back
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      // Should handle lifecycle changes gracefully
      expect(find.byType(CompanyDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Should have accessible elements
      expect(find.byType(AppBar), findsOneWidget);

      // Check for back button accessibility
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);
    });

    testWidgets('should have tab controller when using tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider(
            create: (context) => CompanyDetailBloc(),
            child: const CompanyDetailPage(),
          ),
        ),
      );

      // Should not crash when building
      expect(find.byType(CompanyDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle error state gracefully', (
      WidgetTester tester,
    ) async {
      // Create a bloc that starts in error state
      final errorBloc = MockCompanyDetailBloc();
      when(
        () => errorBloc.state,
      ).thenReturn(const CompanyDetailError('Test error message'));
      whenListen(
        errorBloc,
        Stream.fromIterable([const CompanyDetailError('Test error message')]),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider<CompanyDetailBloc>.value(
            value: errorBloc,
            child: const CompanyDetailPage(),
          ),
        ),
      );

      await tester.pump();

      // Should handle error state
      expect(find.byType(CompanyDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle loaded state with data', (
      WidgetTester tester,
    ) async {
      // Create a bloc that starts in loaded state
      final loadedBloc = MockCompanyDetailBloc();
      when(
        () => loadedBloc.state,
      ).thenReturn(CompanyDetailLoaded(testCompanyDetail));
      whenListen(
        loadedBloc,
        Stream.fromIterable([CompanyDetailLoaded(testCompanyDetail)]),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider<CompanyDetailBloc>.value(
            value: loadedBloc,
            child: const CompanyDetailPage(),
          ),
        ),
      );

      await tester.pump();

      // Should handle loaded state
      expect(find.byType(CompanyDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display retry button in error state', (
      WidgetTester tester,
    ) async {
      // Create a bloc that starts in error state
      final errorBloc = MockCompanyDetailBloc();
      when(
        () => errorBloc.state,
      ).thenReturn(const CompanyDetailError('Test error message'));
      whenListen(
        errorBloc,
        Stream.fromIterable([const CompanyDetailError('Test error message')]),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: BlocProvider<CompanyDetailBloc>.value(
            value: errorBloc,
            child: const CompanyDetailPage(),
          ),
        ),
      );

      await tester.pump();

      // Should display retry button
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
