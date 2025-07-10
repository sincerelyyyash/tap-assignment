import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(text, style: style);
    }

    // Split highlight into individual terms
    final searchTerms = highlight
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .toList();

    if (searchTerms.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();

    // Check if any search term matches
    final hasMatch = searchTerms.any((term) => lowerText.contains(term));
    if (!hasMatch) {
      return Text(text, style: style);
    }

    final spans = <InlineSpan>[];

    // Create a simpler approach: find all matches first, then build spans
    final matches = <Map<String, int>>[];

    for (final term in searchTerms) {
      int startIndex = 0;
      while (true) {
        final index = lowerText.indexOf(term, startIndex);
        if (index == -1) break;

        // Check if this match overlaps with existing matches
        bool overlaps = false;
        for (final match in matches) {
          final matchStart = match['start']!;
          final matchEnd = match['end']!;
          if ((index >= matchStart && index < matchEnd) ||
              (index + term.length > matchStart &&
                  index + term.length <= matchEnd) ||
              (index <= matchStart && index + term.length >= matchEnd)) {
            overlaps = true;
            break;
          }
        }

        if (!overlaps) {
          matches.add({'start': index, 'end': index + term.length});
        }

        startIndex = index + 1;
      }
    }

    // Sort matches by start position
    matches.sort((a, b) => a['start']!.compareTo(b['start']!));

    // Build spans
    int currentIndex = 0;
    for (final match in matches) {
      final start = match['start']!;
      final end = match['end']!;

      // Add text before match
      if (start > currentIndex) {
        spans.add(
          TextSpan(text: text.substring(currentIndex, start), style: style),
        );
      }

      // Add highlighted match with padding
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            decoration: BoxDecoration(
              color: highlightStyle?.backgroundColor ?? const Color(0x29D97706),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              text.substring(start, end),
              style:
                  (highlightStyle ??
                          const TextStyle(
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.bold,
                          ))
                      .copyWith(backgroundColor: Colors.transparent),
            ),
          ),
        ),
      );

      currentIndex = end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
