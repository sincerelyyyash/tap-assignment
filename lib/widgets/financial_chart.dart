import 'package:flutter/material.dart';
import '../models/company_detail.dart';

class FinancialChart extends StatefulWidget {
  final Financials financials;

  const FinancialChart({super.key, required this.financials});

  @override
  State<FinancialChart> createState() => _FinancialChartState();
}

class _FinancialChartState extends State<FinancialChart> {
  bool isEbitdaSelected = true;
  FinancialData? _selectedData;
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final currentData = isEbitdaSelected
        ? widget.financials.ebitda
        : widget.financials.revenue;

    if (currentData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the maximum value for scaling
    final maxValue = currentData
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'COMPANY FINANCIALS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                // Pill-shaped segmented control
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => isEbitdaSelected = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isEbitdaSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'EBITDA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isEbitdaSelected
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => isEbitdaSelected = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !isEbitdaSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Revenue',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: !isEbitdaSelected
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Y-axis labels and chart with aligned labels
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildYAxisLabel('₹3L'),
                    const SizedBox(height: 20),
                    _buildYAxisLabel('₹2L'),
                    const SizedBox(height: 20),
                    _buildYAxisLabel('₹1L'),
                  ],
                ),

                const SizedBox(width: 12),

                // Chart bars and matching month labels
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Bars row with tap tracking
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: currentData.asMap().entries.map((
                                entry,
                              ) {
                                final idx = entry.key;
                                final data = entry.value;
                                final normalizedHeight =
                                    (data.value / maxValue) * 100;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedData = data;
                                    _selectedIndex = idx;
                                  }),
                                  child: _buildBar(
                                    data.month.substring(0, 1).toUpperCase(),
                                    normalizedHeight,
                                    isEbitdaSelected,
                                  ),
                                );
                              }).toList(),
                            ),
                            // Dashed year separator
                            CustomPaint(
                              size: const Size(1, 120),
                              painter: _DashedLinePainter(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            // Selected label positioned above tapped bar
                            if (_selectedIndex != null)
                              Align(
                                alignment: Alignment(
                                  currentData.length > 1
                                      ? -1.0 +
                                            2.0 *
                                                _selectedIndex! /
                                                (currentData.length - 1)
                                      : 0.0,
                                  -1.2,
                                ),
                                child: Text(
                                  _selectedData!.month,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Month labels row, aligned under bars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: currentData
                            .map(
                              (data) => Text(
                                data.month.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.blue.shade200) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildYAxisLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }

  Widget _buildBar(String month, double height, bool isEbitda) {
    return Container(
      width: 16,
      height: height,
      decoration: BoxDecoration(
        color: isEbitda ? Colors.grey.shade800 : Colors.blue.shade600,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
      ),
    );
  }
}

// Custom painter for vertical dashed line
class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
