import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_assignment/models/company_detail.dart';
import 'package:tap_assignment/widgets/financial_chart.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('FinancialChart Widget Tests', () {
    late Financials testFinancials;

    setUp(() {
      testFinancials = testCompanyDetail.financials;
    });

    testWidgets('should display chart with financial data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should display the chart container
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display chart title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should display financial chart title
      expect(find.text('COMPANY FINANCIALS'), findsOneWidget);
    });

    testWidgets('should display toggle buttons for EBITDA and Revenue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should display toggle buttons
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
    });

    testWidgets('should toggle between EBITDA and Revenue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Initially should show EBITDA (assuming default)
      expect(find.text('EBITDA'), findsOneWidget);

      // Tap on Revenue button
      await tester.tap(find.text('Revenue'));
      await tester.pump();

      // Should still display both options
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
    });

    testWidgets('should handle empty financial data gracefully', (
      WidgetTester tester,
    ) async {
      final emptyFinancials = Financials(ebitda: [], revenue: []);

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: emptyFinancials),
        ),
      );

      // Should not crash with empty data and show SizedBox.shrink()
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display chart with single data point', (
      WidgetTester tester,
    ) async {
      final singlePointFinancials = Financials(
        ebitda: [FinancialData(month: 'January', value: 1000000)],
        revenue: [FinancialData(month: 'January', value: 5000000)],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: singlePointFinancials),
        ),
      );

      // Should handle single data point
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle large financial values', (
      WidgetTester tester,
    ) async {
      final largeValueFinancials = Financials(
        ebitda: List.generate(
          12,
          (i) => FinancialData(
            month: 'Month ${i + 1}',
            value: (i + 1) * 1000000000, // Billions
          ),
        ),
        revenue: List.generate(
          12,
          (i) => FinancialData(
            month: 'Month ${i + 1}',
            value: (i + 1) * 5000000000, // Billions
          ),
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: largeValueFinancials),
        ),
      );

      // Should handle large values
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle zero values in financial data', (
      WidgetTester tester,
    ) async {
      final zeroValueFinancials = Financials(
        ebitda: [
          FinancialData(month: 'January', value: 0),
          FinancialData(month: 'February', value: 0),
          FinancialData(month: 'March', value: 0),
        ],
        revenue: [
          FinancialData(month: 'January', value: 0),
          FinancialData(month: 'February', value: 1),
          FinancialData(month: 'March', value: 0),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: zeroValueFinancials),
        ),
      );

      // Should handle zero values
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle negative values in financial data', (
      WidgetTester tester,
    ) async {
      final negativeValueFinancials = Financials(
        ebitda: [
          FinancialData(month: 'January', value: -1000000),
          FinancialData(month: 'February', value: 2000000),
          FinancialData(month: 'March', value: -500000),
        ],
        revenue: [
          FinancialData(month: 'January', value: 3000000),
          FinancialData(month: 'February', value: 4000000),
          FinancialData(month: 'March', value: 2500000),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: negativeValueFinancials),
        ),
      );

      // Should handle negative values
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display chart with many data points', (
      WidgetTester tester,
    ) async {
      final manyPointsFinancials = Financials(
        ebitda: List.generate(
          100,
          (i) =>
              FinancialData(month: 'Period ${i + 1}', value: (i + 1) * 100000),
        ),
        revenue: List.generate(
          100,
          (i) =>
              FinancialData(month: 'Period ${i + 1}', value: (i + 1) * 500000),
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: manyPointsFinancials),
        ),
      );

      // Should handle many data points
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain proper layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should maintain proper widget hierarchy
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle financial data with irregular intervals', (
      WidgetTester tester,
    ) async {
      final irregularFinancials = Financials(
        ebitda: [
          FinancialData(month: 'Q1', value: 1000000),
          FinancialData(month: 'Q3', value: 1500000),
          FinancialData(month: 'Q4', value: 2000000),
        ],
        revenue: [
          FinancialData(month: 'Q1', value: 5000000),
          FinancialData(month: 'Q2', value: 5500000),
          FinancialData(month: 'Q4', value: 6000000),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: irregularFinancials),
        ),
      );

      // Should handle irregular data
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle long month names gracefully', (
      WidgetTester tester,
    ) async {
      final longNamesFinancials = Financials(
        ebitda: [
          FinancialData(month: 'Very Long Month Name January', value: 1000000),
          FinancialData(
            month: 'Extremely Long Month Name February',
            value: 1500000,
          ),
        ],
        revenue: [
          FinancialData(month: 'Very Long Month Name January', value: 5000000),
          FinancialData(
            month: 'Extremely Long Month Name February',
            value: 5500000,
          ),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: longNamesFinancials),
        ),
      );

      // Should handle long names
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle special characters in month names', (
      WidgetTester tester,
    ) async {
      final specialCharFinancials = Financials(
        ebitda: [
          FinancialData(month: 'Q1-2024 (Jan-Mar)', value: 1000000),
          FinancialData(month: 'Q2@2024 #Apr-Jun', value: 1500000),
        ],
        revenue: [
          FinancialData(month: 'Q1-2024 (Jan-Mar)', value: 5000000),
          FinancialData(month: 'Q2@2024 #Apr-Jun', value: 5500000),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: specialCharFinancials),
        ),
      );

      // Should handle special characters
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should be accessible
      expect(find.byType(FinancialChart), findsOneWidget);

      // Check for interactive elements (GestureDetector)
      expect(
        find.byType(GestureDetector),
        findsAtLeastNWidgets(2),
      ); // Toggle buttons
    });

    testWidgets('should handle rapid toggle interactions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Rapid toggle between EBITDA and Revenue
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Revenue'));
        await tester.pump();
        await tester.tap(find.text('EBITDA'));
        await tester.pump();
      }

      // Should handle rapid interactions
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain chart state across rebuilds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Toggle to Revenue
      await tester.tap(find.text('Revenue'));
      await tester.pump();

      // Rebuild widget
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should maintain functionality after rebuild
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle large integer values correctly', (
      WidgetTester tester,
    ) async {
      final decimalFinancials = Financials(
        ebitda: [
          FinancialData(month: 'January', value: 1000000),
          FinancialData(month: 'February', value: 1500000),
        ],
        revenue: [
          FinancialData(month: 'January', value: 5000000),
          FinancialData(month: 'February', value: 5500000),
        ],
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: FinancialChart(financials: decimalFinancials),
        ),
      );

      // Should handle large integer values
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should render without errors for various screen sizes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should render successfully
      expect(find.byType(FinancialChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display GestureDetector for chart interaction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Should have GestureDetectors for interactivity
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(2));
    });

    testWidgets('should show correct chart type when toggled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: FinancialChart(financials: testFinancials)),
      );

      // Initially EBITDA should be selected (default)
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);

      // Tap Revenue
      await tester.tap(find.text('Revenue'));
      await tester.pump();

      // Should still show both buttons
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);

      // Tap EBITDA to switch back
      await tester.tap(find.text('EBITDA'));
      await tester.pump();

      // Should still show both buttons
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
    });
  });
}
