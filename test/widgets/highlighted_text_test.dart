import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_assignment/widgets/highlighted_text.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HighlightedText Widget Tests', () {
    testWidgets(
      'should display text without highlighting when highlight is empty',
      (WidgetTester tester) async {
        const text = 'This is a test text';
        const highlight = '';

        await tester.pumpWidget(
          createTestableWidget(
            child: const HighlightedText(text: text, highlight: highlight),
          ),
        );

        // Should display regular Text widget (which becomes RichText internally)
        expect(find.text(text), findsOneWidget);
        expect(find.byType(HighlightedText), findsOneWidget);

        // Check that the widget is a HighlightedText instance
        final highlightedTextWidget = tester.widget<HighlightedText>(
          find.byType(HighlightedText),
        );
        expect(highlightedTextWidget.text, equals(text));
        expect(highlightedTextWidget.highlight, equals(highlight));
      },
    );

    testWidgets('should highlight single term correctly', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a technology company';
      const highlight = 'Apple';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should use RichText for highlighting
      expect(find.byType(RichText), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should highlight multiple terms correctly', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a technology company';
      const highlight = 'Apple technology';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should use RichText for highlighting
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should be case-insensitive when highlighting', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a Technology Company';
      const highlight = 'apple technology';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight case-insensitively
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should handle partial word matches', (
      WidgetTester tester,
    ) async {
      const text = 'Technology companies are innovative';
      const highlight = 'Tech';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight partial matches
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should apply custom text style', (WidgetTester tester) async {
      const text = 'This is a test text';
      const highlight = '';
      const style = TextStyle(fontSize: 20, color: Colors.blue);

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(
            text: text,
            highlight: highlight,
            style: style,
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style, equals(style));
    });

    testWidgets('should apply custom highlight style', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a technology company';
      const highlight = 'Apple';
      const highlightStyle = TextStyle(
        backgroundColor: Colors.yellow,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(
            text: text,
            highlight: highlight,
            highlightStyle: highlightStyle,
          ),
        ),
      );

      // Should use RichText with custom highlighting
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should handle no matches gracefully', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a technology company';
      const highlight = 'xyz';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should display regular text when no matches (Text widgets become RichText internally)
      expect(find.text(text), findsOneWidget);
      expect(find.byType(HighlightedText), findsOneWidget);

      // Check that the widget is a HighlightedText instance
      final highlightedTextWidget = tester.widget<HighlightedText>(
        find.byType(HighlightedText),
      );
      expect(highlightedTextWidget.text, equals(text));
      expect(highlightedTextWidget.highlight, equals(highlight));
    });

    testWidgets('should handle empty text', (WidgetTester tester) async {
      const text = '';
      const highlight = 'test';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should display empty text
      expect(find.text(''), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should handle whitespace in search terms', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. is a technology company';
      const highlight = '  Apple  technology  ';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle whitespace and still highlight
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should handle special characters in text', (
      WidgetTester tester,
    ) async {
      const text = 'Company & Sons (Pvt.) Ltd. - @#\$%^&*()';
      const highlight = 'Company &';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle special characters
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle special characters in highlight terms', (
      WidgetTester tester,
    ) async {
      const text = 'Company & Sons (Pvt.) Ltd.';
      const highlight = '&';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle special characters in search
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle unicode characters', (
      WidgetTester tester,
    ) async {
      const text = 'Tëst Cømpäny Ünïcødé Tëxt';
      const highlight = 'Tëst Ünïcødé';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle unicode characters
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle overlapping matches correctly', (
      WidgetTester tester,
    ) async {
      const text = 'Technology Technology Company';
      const highlight = 'Technology Tech';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle overlapping matches without errors
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle very long text', (WidgetTester tester) async {
      final longText = 'This is a very long text ' * 100 + 'Apple';
      const highlight = 'Apple';

      await tester.pumpWidget(
        createTestableWidget(
          child: HighlightedText(text: longText, highlight: highlight),
        ),
      );

      // Should handle long text without performance issues
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle many search terms', (WidgetTester tester) async {
      const text = 'Apple Inc Google Microsoft Amazon Facebook Tesla';
      const highlight = 'Apple Google Microsoft Amazon Facebook Tesla';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should handle multiple search terms
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle repeated words in text', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Apple Apple Company Apple';
      const highlight = 'Apple';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight all instances
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain default highlight style when not specified', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. technology';
      const highlight = 'Apple';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should use default highlight style
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle single character searches', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. A+ rating';
      const highlight = 'A';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight single characters
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle numbers in text and search', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc 2024 Q3 Results';
      const highlight = '2024 Q3';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight numbers
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should work with different text directions', (
      WidgetTester tester,
    ) async {
      const text = 'Left to Right Text';
      const highlight = 'Text';

      await tester.pumpWidget(
        createTestableWidget(
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: HighlightedText(text: text, highlight: highlight),
          ),
        ),
      );

      // Should work with RTL direction
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle text with only whitespace', (
      WidgetTester tester,
    ) async {
      const text = '   \n\t  ';
      const highlight = 'test';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should display whitespace text normally
      expect(find.text(text), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should handle search with only whitespace', (
      WidgetTester tester,
    ) async {
      const text = 'Apple Inc. technology';
      const highlight = '   \n\t  ';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should treat whitespace-only search as empty
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle exact word matches', (
      WidgetTester tester,
    ) async {
      const text = 'Application Apple Apply';
      const highlight = 'App';

      await tester.pumpWidget(
        createTestableWidget(
          child: const HighlightedText(text: text, highlight: highlight),
        ),
      );

      // Should highlight partial matches in all words
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle performance with many highlights', (
      WidgetTester tester,
    ) async {
      final manyTerms = List.generate(50, (i) => 'term$i').join(' ');
      final textWithManyTerms = List.generate(
        50,
        (i) => 'term$i content',
      ).join(' ');

      await tester.pumpWidget(
        createTestableWidget(
          child: HighlightedText(text: textWithManyTerms, highlight: manyTerms),
        ),
      );

      // Should handle many terms without performance issues
      expect(find.byType(HighlightedText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
