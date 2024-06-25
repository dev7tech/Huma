import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../constants/responsive.dart';
import 'bar_chart_users.dart';

class ActiveUsersGaph extends StatefulWidget {
  const ActiveUsersGaph({Key? key}) : super(key: key);

  @override
  State<ActiveUsersGaph> createState() => _ActiveUsersGaphState();
}

class _ActiveUsersGaphState extends State<ActiveUsersGaph> {
  FilterType _selectedFilter = FilterType.weekly; // Default filter is weekly

  DateTimeRange dateTimeRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Users",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),
              Container(
                // Set your desired width for the dropdown button
                height: 35, // Set your desired height for the dropdown button
                decoration: BoxDecoration(
                  color: secondryColor, // Background color of dropdown button
                  border: Border.all(
                    color: primaryColor, // Border color of dropdown button
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                      12), // Border radius of dropdown button
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 6), // Customize horizontal padding
                child: DropdownButton<FilterType>(
                  iconSize: 20,
                  elevation: 5,
                  iconEnabledColor: primaryColor,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  underline: const SizedBox.shrink(),
                  value: _selectedFilter,
                  onChanged: (FilterType? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                    if (newValue == FilterType.range) {
                      pickDateRange();
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: FilterType.weekly,
                      child: !Responsive.isMobile(context)
                          ? const Text('15 Days')
                          : const Text('7 Days'),
                    ),
                    const DropdownMenuItem(
                      value: FilterType.monthly,
                      child: Text('Monthly'),
                    ),
                    const DropdownMenuItem(
                      value: FilterType.yearly,
                      child: Text('Yearly'),
                    ),
                    const DropdownMenuItem(
                      value: FilterType.range,
                      child: Text('Custom'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: BarChartUsers(
              selectedFilter: _selectedFilter,
              dateRange: dateTimeRange,
            ),
          )
        ],
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      helpText: "Please select a range within 15 days",
      initialDateRange: dateTimeRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: child,
              )
            ],
          ),
        );
      },
    );

    if (newDateRange == null) return; // pressed cancel

    // Check if the selected range is within 10 days
    if (newDateRange.end.difference(newDateRange.start).inDays > 15) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Selection"),
          content: const Text(
              "Please select a date range within 15 days.\nFor more data,consider selecting other dropdown options."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    } else {
      setState(() => dateTimeRange = newDateRange);
      debugPrint("new date range is $dateTimeRange");
    }
  }
}
