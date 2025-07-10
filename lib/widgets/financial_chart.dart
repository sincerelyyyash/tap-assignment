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

    // Find the maximum value for scaling, ensuring it's positive
    final maxValue = currentData
        .map((e) => e.value.abs()) // Use absolute values for scaling
        .reduce((a, b) => a > b ? a : b);

    // Ensure maxValue is at least 1 to prevent division by zero
    final safeMaxValue = maxValue > 0 ? maxValue : 1;

    // Calculate dynamic Y-axis labels
    final yAxisLabels = _generateYAxisLabels(safeMaxValue);

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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          isEbitdaSelected = true;
                          _selectedData = null;
                          _selectedIndex = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isEbitdaSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
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
                        onTap: () => setState(() {
                          isEbitdaSelected = false;
                          _selectedData = null;
                          _selectedIndex = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !isEbitdaSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
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
                // Dynamic Y-axis labels
                SizedBox(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: yAxisLabels
                        .map((label) => _buildYAxisLabel(label))
                        .toList(),
                  ),
                ),

                const SizedBox(width: 12),

                // Chart bars and matching month labels
                Expanded(
                  child: Column(
                    children: [
                      // Chart area with bars and interactive pointer
                      SizedBox(
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Horizontal grid lines for Y-axis ranges
                            ...yAxisLabels.asMap().entries.map((entry) {
                              final index = entry.key;
                              // Y-axis labels are arranged from top to bottom (highest to lowest)
                              // So index 0 = top (highest value), index 1 = middle, index 2 = bottom (lowest)
                              final topPosition =
                                  (index / (yAxisLabels.length - 1)) * 120.0;

                              return Positioned(
                                left: 0,
                                right: 0,
                                top: topPosition - 0.5, // Center the 1px line
                                child: Container(
                                  height: 1,
                                  child: CustomPaint(
                                    painter: _DashedLinePainter(
                                      color: Colors.grey.shade400,
                                      isHorizontal: true,
                                      strokeWidth: 1.0,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            // Bars row with tap tracking
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 160,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: currentData.asMap().entries.map((
                                    entry,
                                  ) {
                                    final idx = entry.key;
                                    final data = entry.value;
                                    final chartHeight = 120.0;
                                    final normalizedHeight =
                                        ((data.value.abs() / safeMaxValue) *
                                                chartHeight)
                                            .clamp(1.0, chartHeight);
                                    final isSelected = _selectedIndex == idx;

                                    return GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedData = data;
                                        _selectedIndex = idx;
                                      }),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Bar
                                            Container(
                                              width: 16,
                                              height: normalizedHeight,
                                              decoration: BoxDecoration(
                                                color: isEbitdaSelected
                                                    ? Colors.black87
                                                    : const Color(0xFF2563EB),
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(2),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            // Vertical dotted line indicator when bar is selected
                            if (_selectedIndex != null)
                              Positioned(
                                left: () {
                                  // Simple direct calculation for line between bars
                                  final chartWidth =
                                      MediaQuery.of(context).size.width - 120;

                                  // Each bar section takes equal width
                                  final sectionWidth =
                                      chartWidth / currentData.length;

                                  // Position line at the end of current bar's section (between bars)
                                  return (_selectedIndex! + 1) * sectionWidth -
                                      1;
                                }(),
                                top: 0,
                                bottom: 0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Month labels horizontally on top
                                    Container(
                                      width:
                                          60, // Further reduced to prevent overflow
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (_selectedIndex! <
                                              currentData.length - 1) ...[
                                            Flexible(
                                              child: Text(
                                                currentData[_selectedIndex!]
                                                    .month
                                                    .substring(0, 3),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Flexible(
                                              child: Text(
                                                currentData[_selectedIndex! + 1]
                                                    .month
                                                    .substring(0, 3),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Add padding between month names and line
                                    const SizedBox(height: 6),
                                    // Vertical dotted line - extends full height
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        child: CustomPaint(
                                          painter: _DashedLinePainter(
                                            color: Colors.grey.shade500,
                                            isHorizontal: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Month labels row, aligned under bars
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width - 160,
                          ),
                          child: Row(
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
                        ),
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

  List<String> _generateYAxisLabels(int maxValue) {
    // Generate 3 Y-axis labels based on maxValue
    final step = (maxValue / 3).ceil();
    final topValue = step * 3;
    final midValue = step * 2;
    final bottomValue = step;

    return [
      _formatValue(topValue),
      _formatValue(midValue),
      _formatValue(bottomValue),
    ];
  }

  String _formatValue(int value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹$value';
    }
  }

  Widget _buildYAxisLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }
}

// Custom painter for vertical dashed line
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isHorizontal;
  final double strokeWidth;
  _DashedLinePainter({
    this.color = Colors.grey,
    this.isHorizontal = false,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    if (isHorizontal) {
      const dashWidth = 4.0;
      const dashSpace = 4.0;
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
        x += dashWidth + dashSpace;
      }
    } else {
      const dashHeight = 4.0;
      const dashSpace = 4.0;
      double y = 0;
      while (y < size.height) {
        canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
        y += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
