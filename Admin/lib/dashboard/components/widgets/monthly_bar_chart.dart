import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../../constants/responsive.dart';

class MonthChart extends StatelessWidget {
  final Map<String, int> userCounts;
  final List<String> labels;

  MonthChart({Key? key, required this.userCounts})
      : labels = getLast12Months(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("month data is $userCounts");
    return _buildMonthlyBarChart(userCounts, labels, context);
  }
}

List<String> getLast12Months() {
  List<String> last12Months = [];
  DateTime today = DateTime.now();

  for (int i = 11; i >= 0; i--) {
    DateTime month = DateTime(today.year, today.month - i, 1);
    last12Months.add(DateFormat('yyyy-MM').format(month));
  }

  return last12Months;
}

Widget _buildMonthlyBarChart(
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
                DateTime dateTime = DateFormat('yyyy-MM').parse(date);
                return DateFormat('MMM\nyyyy').format(dateTime);
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
