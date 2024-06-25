import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../model/recent_activity_model.dart';
import '../../providers/recent_activity_provider.dart';
import '../../providers/selected_item_provider.dart';
import 'recent_activity_details.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({Key? key}) : super(key: key);

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  DateTime convertToDate(String input) {
    List<String> parts = input.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<RecentActivityProvider>(context, listen: false);
    return Container(
      height: 410,
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
                'Recent Activity',
                style: TextStyle(
                  color: textColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              InkWell(
                onTap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Reportuser');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: Future.wait([
                    userProvider.fetchReportedUsers(),
                    userProvider.fetchBlockedUsers(),
                    userProvider.fetchReportedByUsers()
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: primaryColor,
                      ));
                    } else if (snapshot.hasError) {
                      debugPrint("ERROR IS ${snapshot.error}");
                      return const Center(child: Text('Error to load'));
                    } else {
                      final List<RecentActivityModel> reportedUsers =
                          userProvider.reportedUsers;
                      final List<RecentActivityModel> blockedUsers =
                          userProvider.blockedUsers;

                      // Merge and sort the data by timestamp
                      List<RecentActivityModel> mergedData = [
                        ...reportedUsers,
                        ...blockedUsers
                      ];
                      mergedData.sort((a, b) => convertToDate(b.timestamp)
                          .compareTo(convertToDate(a.timestamp)));

                      // Get the victimId-to-reporters mapping from the provider
                      Map<String, List<RecentActivityModel>> reportedByMap =
                          userProvider.reportedByMap;

                      return mergedData.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No Recent Activity Founds"),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: mergedData.length,
                              itemBuilder: (context, index) =>
                                  RecentActivityDetail(
                                info: mergedData[index],
                                reportedByMap: reportedByMap,
                                onUnblock: () {
                                  setState(() {
                                    userProvider.unblockUser(
                                        mergedData[index].userId, context);
                                    userProvider.fetchBlockedUsers();
                                  });
                                },
                              ),
                            );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
