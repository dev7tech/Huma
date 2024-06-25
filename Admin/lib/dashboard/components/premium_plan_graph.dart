import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class ViewLineChart extends StatefulWidget {
  const ViewLineChart({Key? key}) : super(key: key);

  @override
  ViewLineChartState createState() => ViewLineChartState();
}

class ViewLineChartState extends State<ViewLineChart> {
  List<Color> gradientColors = [
    primaryColor,
    secondryColor,
  ];

  List<FlSpot> chartData =
      List.generate(7, (index) => FlSpot(index.toDouble(), 0));

  // Function to fetch all users' subscription dates from Firestore
  Future<List<DateTime>> getAllSubscriptionDates() async {
    try {
      QuerySnapshot snapshot = await firebaseInstance.collection('Users').get();

      List<DateTime> subscriptionDates = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('subscriptionDate') == true) {
          Timestamp? subscriptionTimestamp = data['subscriptionDate'];
          if (subscriptionTimestamp != null) {
            subscriptionDates.add(subscriptionTimestamp.toDate());
          }
        }
      }
      // debugPrint("dates is $subscriptionDates");
      return subscriptionDates;
    } catch (e) {
      debugPrint("Error getting subscription dates: $e");
      return [];
    }
  }

  // Function to convert DateTime to the day of the week (e.g., "Sunday", "Monday", etc.)
  String getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'];
    return daysOfWeek[date.weekday - 1];
  }

  // Function to update chart data based on the user's subscription date
  Future<void> updateChartDataBasedOnSubscription() async {
    List<DateTime> subscriptionDates = await getAllSubscriptionDates();

    // Count the occurrences of each day of the week
    Map<int, int> counts = {
      for (var day in List.generate(7, (index) => index + 1)) day: 0
    };

    for (var date in subscriptionDates) {
      int dayOfWeek = date.weekday;
      counts[dayOfWeek] = (counts[dayOfWeek] ?? 0) + 1;
    }

    // Create a new list of FlSpot with updated 'y' values
    List<FlSpot> updatedChartData = List.generate(7, (index) {
      int day = index + 1;
      return FlSpot(day.toDouble(), counts[day]!.toDouble());
    });

    // Update the chartData with the new list
    if (mounted) {
      setState(() {
        chartData = updatedChartData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateChartDataBasedOnSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        appPadding,
        appPadding * 1.5,
        appPadding,
        appPadding,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      return LineTooltipItem(
                        flSpot.y.toString(),
                        const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14),
                      );
                    }).toList();
                  },
                  tooltipBgColor: primaryColor.withOpacity(0.4))),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (context, value) {
                return const TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
              },
              getTitles: (value) {
                switch (value.toInt()) {
                  case 1:
                    return 'Sun';
                  case 2:
                    return 'Mon';
                  case 3:
                    return 'Tue';
                  case 4:
                    return 'Wed';
                  case 5:
                    return 'Thr';
                  case 6:
                    return 'Fri';
                  case 7:
                    return 'Sat';
                }
                return '';
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 7,
          maxY: chartData
                  .reduce(
                      (value, element) => value.y > element.y ? value : element)
                  .y +
              1,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              colors: [primaryColor],
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                colors: gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                gradientFrom: const Offset(0, 0),
                gradientTo: const Offset(0, 1.75),
              ),
            )
          ],
        ),
      ),
    );
  }
}
