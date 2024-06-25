import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Map<String, int> dummyData = {
  '2023-07-25': 500,
  '2023-07-20': 105,
  '2023-07-19': 100,
  '2023-07-24': 270,
  '2023-07-18': 190,
  '2023-07-17': 209,
  '2023-07-16': 280,
  '2023-07-15': 208,
  '2023-07-13': 250,
  '2023-07-14': 260,
  '2023-07-12': 207,
  '2023-07-11': 200,
  '2023-07-22': 150,
  '2023-07-21': 109,
  '2023-07-23': 179,
  '2023-07-26': 170,
};

List<String> getLast15Days() {
  DateTime today = DateTime.now();
  List<String> last15Days = [];

  for (int i = 14; i >= 0; i--) {
    DateTime date = today.subtract(Duration(days: i));
    last15Days.add(DateFormat('yyyy-MM-dd').format(date));
  }

  return last15Days;
}

List<String> getLast7Days() {
  DateTime today = DateTime.now();
  List<String> last7Days = [];

  for (int i = 6; i >= 0; i--) {
    DateTime date = today.subtract(Duration(days: i));
    last7Days.add(DateFormat('yyyy-MM-dd').format(date));
  }

  return last7Days;
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

List<String> getLast5Years() {
  List<String> last5Years = [];
  DateTime today = DateTime.now();

  for (int i = 4; i >= 0; i--) {
    DateTime year = DateTime(today.year - i, today.month, 1);
    last5Years.add(DateFormat('yyyy').format(year));
  }

  return last5Years;
}

List<String> getLabelsForDateRange(DateTimeRange dateRange) {
  List<String> labels = [];
  int daysInRange = dateRange.duration.inDays;

  for (int i = 0; i < daysInRange; i++) {
    DateTime date = dateRange.start.add(Duration(days: i));
    labels.add(DateFormat('yyyy-MM-dd').format(date));
  }

  return labels;
}
