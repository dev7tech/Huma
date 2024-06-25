import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/responsive.dart';
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';

class WeeklyChart extends StatelessWidget {
  final Map<String, int> userCounts;
  final List<String> labels;
  const WeeklyChart(
      {super.key, required this.userCounts, required this.labels});

  @override
  Widget build(BuildContext context) {
    return _buildWeeklyBarChart(userCounts, labels, context);
  }
}

Widget _buildWeeklyBarChart(
    Map<String, int> userCounts, List<String> labels, BuildContext context) {
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
                // Skip showing the title on mobile at odd indices
                if (Responsive.isMobile(context) && index % 2 != 0) {
                  return '|';
                }
                String date = labels[index];
                DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date);
                return DateFormat('MMM dd').format(dateTime);
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
