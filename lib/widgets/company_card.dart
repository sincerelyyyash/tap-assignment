import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../models/company.dart';
import 'highlighted_text.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  final String searchQuery;
  final VoidCallback? onTap;
  final bool showDivider;

  const CompanyCard({
    super.key,
    required this.company,
    required this.searchQuery,
    this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Haptics.vibrate(HapticsType.selection);
              onTap?.call();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange.shade100,
                    ),
                    child: company.logo.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              company.logo,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.orange.shade200,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'INFRA\nMARKET',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 6,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade800,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'INFRA\nMARKET',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                                height: 1.1,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Company details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ISIN
                        HighlightedText(
                          text: company.isin,
                          highlight: searchQuery,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          highlightStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0x29D97706),
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Rating and Company name
                        Row(
                          children: [
                            Text(
                              company.rating,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: HighlightedText(
                                text: company.companyName,
                                highlight: searchQuery,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 12,
                                  backgroundColor: Color(0x29D97706),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow icon
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
            indent: 72,
            endIndent: 16,
          ),
      ],
    );
  }
}
