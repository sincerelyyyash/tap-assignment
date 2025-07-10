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

    // Find all matches
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

    // If no actual matches found, return simple Text widget
    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    // Sort matches by start position
    matches.sort((a, b) => a['start']!.compareTo(b['start']!));

    // Build TextSpans
    final spans = <TextSpan>[];
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

      // Add highlighted match
      spans.add(
        TextSpan(
          text: text.substring(start, end),
          style:
              highlightStyle ??
              const TextStyle(
                color: Color(0xFFD97706),
                fontWeight: FontWeight.bold,
                backgroundColor: Color(0x29D97706),
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
