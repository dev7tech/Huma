import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/monthly_bar_chart.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/weekly_bar_chart.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/yearly_bar_chart.dart';
import 'package:hookup4u_admin/constants/constants.dart';
import 'package:hookup4u_admin/providers/active_users_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/chart_labels.dart';
import '../../constants/enums.dart';
import '../../constants/responsive.dart';

class BarChartUsers extends StatefulWidget {
  final FilterType selectedFilter;
  final DateTimeRange dateRange;
  const BarChartUsers(
      {super.key, required this.selectedFilter, required this.dateRange});

  @override
  BarChartUsersState createState() => BarChartUsersState();
}

class BarChartUsersState extends State<BarChartUsers> {
  @override
  Widget build(BuildContext context) {
    final activeUsersdataProvider =
        Provider.of<ActiveUserProvider>(context, listen: false);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activeUsersdataProvider.fetchUserDataFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        } else if (snapshot.hasError) {
          return const Text('Error fetching data');
        } else {
          List<Map<String, dynamic>> userDataFromFirebase = snapshot.data ?? [];
          Map<String, int> userCounts =
              activeUsersdataProvider.countUsersByDate(
            userDataFromFirebase,
            widget.dateRange.start,
            widget.dateRange.end,
            widget.selectedFilter,
          );

          List<String> labels;
          if (widget.selectedFilter == FilterType.monthly) {
            return Padding(
              padding: const EdgeInsets.all(appPadding),
              child: MonthChart(
                userCounts: userCounts,
              ),
            );
          } else if (widget.selectedFilter == FilterType.yearly) {
            labels = getLast5Years();
            return Padding(
              padding: const EdgeInsets.all(appPadding),
              child: YearlyBarChart(userCounts: userCounts, labels: labels),
            );
          } else if (widget.selectedFilter == FilterType.range) {
            labels = getLabelsForDateRange(widget.dateRange);

            return Padding(
              padding: const EdgeInsets.all(appPadding),
              child: WeeklyChart(userCounts: userCounts, labels: labels),
            );
          } else {
            labels = !Responsive.isMobile(context)
                ? getLast15Days()
                : getLast7Days();
            return Padding(
              padding: const EdgeInsets.all(appPadding),
              child: WeeklyChart(userCounts: userCounts, labels: labels),
            );
          }
        }
      },
    );
  }
}
