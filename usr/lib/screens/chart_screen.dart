import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/fmea_item.dart';

class RpnChartScreen extends StatelessWidget {
  final List<FmeaItem> items;

  const RpnChartScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Sort items by RPN descending for Pareto analysis
    final sortedItems = List<FmeaItem>.from(items)
      ..sort((a, b) => b.rpn.compareTo(a.rpn));

    // Take top 10 for clarity if list is long
    final displayItems = sortedItems.take(10).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'تحلیل نموداری RPN (۱۰ ریسک برتر)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'اولویت‌بندی بر اساس نمره ریسک',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: displayItems.isEmpty
                  ? const Center(child: Text('داده‌ای برای نمایش وجود ندارد'))
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 1000, // Max possible RPN is 10 * 10 * 10 = 1000
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String label = displayItems[group.x.toInt()].failureMode;
                              return BarTooltipItem(
                                '$label\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: (rod.toY - 1).toString(),
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                int index = value.toInt();
                                if (index < 0 || index >= displayItems.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    (index + 1).toString(), // Show rank number
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 200,
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: const Color(0xff37434d)),
                        ),
                        barGroups: displayItems.asMap().entries.map((entry) {
                          int index = entry.key;
                          FmeaItem item = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: item.rpn.toDouble(),
                                color: _getColorForRpn(item.rpn),
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            // Legend
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(Colors.green, 'ریسک پایین (<100)'),
                _buildLegendItem(Colors.orange, 'ریسک متوسط (100-300)'),
                _buildLegendItem(Colors.red, 'ریسک بالا (>300)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Color _getColorForRpn(int rpn) {
    if (rpn > 300) return Colors.red;
    if (rpn > 100) return Colors.orange;
    return Colors.green;
  }
}
