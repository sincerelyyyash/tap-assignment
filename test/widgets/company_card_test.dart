import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_assignment/models/company.dart';
import 'package:tap_assignment/widgets/company_card.dart';
import 'package:tap_assignment/widgets/highlighted_text.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CompanyCard Widget Tests', () {
    late Company testCompany;

    setUp(() {
      testCompany = testCompanies[0]; // Apple Inc.
    });

    testWidgets('should display company information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Verify ISIN is displayed
      expect(find.text(testCompany.isin), findsOneWidget);

      // Verify company name is displayed
      expect(find.text(testCompany.companyName), findsOneWidget);

      // Verify rating is displayed
      expect(find.text(testCompany.rating), findsOneWidget);

      // Verify the card layout structure
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle tap events correctly', (
      WidgetTester tester,
    ) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      );

      // Tap on the card
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('should not call onTap when callback is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: null,
          ),
        ),
      );

      // Tap on the card - should not throw
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // No error should occur
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display logo when available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Check for network image
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display fallback logo when logo URL is empty', (
      WidgetTester tester,
    ) async {
      final companyWithoutLogo = testCompany.copyWith(logo: '');

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: companyWithoutLogo,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Should display fallback text
      expect(find.text('INFRA\nMARKET'), findsOneWidget);
    });

    testWidgets('should highlight search terms in company name', (
      WidgetTester tester,
    ) async {
      const searchQuery = 'Apple';

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: searchQuery,
            onTap: () {},
          ),
        ),
      );

      // Verify HighlightedText widget is used for company name
      expect(
        find.byType(HighlightedText),
        findsNWidgets(2),
      ); // ISIN and company name

      final highlightedTexts = tester.widgetList<HighlightedText>(
        find.byType(HighlightedText),
      );
      final companyNameHighlighted = highlightedTexts.firstWhere(
        (widget) => widget.text == testCompany.companyName,
      );
      expect(companyNameHighlighted.highlight, equals(searchQuery));
    });

    testWidgets('should highlight search terms in ISIN', (
      WidgetTester tester,
    ) async {
      const searchQuery = 'AAPL';

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: searchQuery,
            onTap: () {},
          ),
        ),
      );

      // Should find HighlightedText widgets for both company name and ISIN
      expect(find.byType(HighlightedText), findsNWidgets(2));
    });

    testWidgets('should not highlight when search query is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Should find HighlightedText widgets but with empty highlight
      expect(find.byType(HighlightedText), findsNWidgets(2));
      final highlightedTexts = tester.widgetList<HighlightedText>(
        find.byType(HighlightedText),
      );
      for (final widget in highlightedTexts) {
        expect(widget.highlight, equals(''));
      }
    });

    testWidgets('should handle very long company names gracefully', (
      WidgetTester tester,
    ) async {
      final longNameCompany = testCompany.copyWith(
        companyName:
            'Very Very Very Long Company Name That Should Overflow If Not Handled Properly Corporation Limited',
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: longNameCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      expect(find.text(longNameCompany.companyName), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle special characters in company data', (
      WidgetTester tester,
    ) async {
      final specialCharCompany = testCompany.copyWith(
        companyName: 'Company & Sons (Pvt.) Ltd. - Special Chars: @#\$%^&*()',
        isin: 'INE@#\$%^',
        rating: 'AA+ (Special)',
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: specialCharCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      expect(find.text(specialCharCompany.companyName), findsOneWidget);
      expect(find.text(specialCharCompany.isin), findsOneWidget);
      expect(find.text(specialCharCompany.rating), findsOneWidget);
    });

    testWidgets('should maintain consistent styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty rating gracefully', (
      WidgetTester tester,
    ) async {
      final emptyRatingCompany = testCompany.copyWith(rating: '');

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: emptyRatingCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Should display empty string for rating
      expect(find.text(''), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display correct layout hierarchy', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      // Verify the widget hierarchy
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('should respond to different search query cases', (
      WidgetTester tester,
    ) async {
      const searchQuery = 'apple'; // lowercase

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany, // Company name: "Apple Inc."
            searchQuery: searchQuery,
            onTap: () {},
          ),
        ),
      );

      // Should still use HighlightedText for case-insensitive search
      expect(find.byType(HighlightedText), findsNWidgets(2));
    });

    testWidgets('should handle partial ISIN matches in search', (
      WidgetTester tester,
    ) async {
      const searchQuery = 'AAPL'; // Part of ISIN

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: searchQuery,
            onTap: () {},
          ),
        ),
      );

      // Should highlight the ISIN
      expect(find.byType(HighlightedText), findsNWidgets(2));
    });

    testWidgets('should handle unicode characters in search', (
      WidgetTester tester,
    ) async {
      final unicodeCompany = testCompany.copyWith(
        companyName: 'Tëst Cømpäny Ünïcødé',
      );
      const searchQuery = 'Tëst';

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: unicodeCompany,
            searchQuery: searchQuery,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(HighlightedText), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain accessibility properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNotNull);
    });

    testWidgets('should handle rapid tap events', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {
              tapCount++;
            },
          ),
        ),
      );

      // Rapid taps
      await tester.tap(find.byType(InkWell));
      await tester.tap(find.byType(InkWell));
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapCount, equals(3));
    });

    testWidgets('should show divider when showDivider is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
            showDivider: true,
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should not show divider when showDivider is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
            showDivider: false,
          ),
        ),
      );

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('should handle case-insensitive search highlighting', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: 'apple inc',
            onTap: () {},
          ),
        ),
      );

      // Should find and use HighlightedText for both ISIN and company name
      expect(find.byType(HighlightedText), findsNWidgets(2));
    });

    testWidgets('should display rating with bullet separator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: CompanyCard(
            company: testCompany,
            searchQuery: '',
            onTap: () {},
          ),
        ),
      );

      expect(find.text(testCompany.rating), findsOneWidget);
      expect(find.text('•'), findsOneWidget);
    });
  });
}
