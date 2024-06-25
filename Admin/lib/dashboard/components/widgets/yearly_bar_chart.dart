import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class YearlyBarChart extends StatelessWidget {
  final Map<String, int> userCounts;
  final List<String> labels;
  const YearlyBarChart(
      {super.key, required this.userCounts, required this.labels});

  @override
  Widget build(BuildContext context) {
    return _buildYearlyBarChart(userCounts, labels);
  }
}

Widget _buildYearlyBarChart(Map<String, int> userCounts, List<String> labels) {
  return BarChart(
    BarChartData(
      borderData: FlBorderData(border: Border.all(width: 0)),
      groupsSpace: 15,
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipMargin: 0,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  rod.y.toString(),
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondryColor,
                    fontSize: 14,
                  ),
                );
              },
              tooltipBgColor: primaryColor.withOpacity(0.5))),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: lightTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            getTitles: (double value) {
              int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return labels[index];
              }
              return '';
            },
          ),
          leftTitles: SideTitles(showTitles: false)),
      barGroups: List.generate(
        labels.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              y: userCounts[labels[index]]?.toDouble() ?? 0.0,
              width: 20,
              colors: [
                userCounts[labels[index]] == 0
                    ? Colors.grey.withOpacity(0.5)
                    : primaryColor,
              ],
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    ),
  );
}
