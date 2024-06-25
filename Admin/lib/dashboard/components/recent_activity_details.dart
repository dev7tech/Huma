import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/snackbar.dart';
import '../../constants/custom_dailog.dart';
import '../../model/recent_activity_model.dart';
import '../../users/user_info.dart';

class RecentActivityDetail extends StatelessWidget {
  final RecentActivityModel info;
  final VoidCallback onUnblock;
  final Map<String, List<RecentActivityModel>> reportedByMap;

  const RecentActivityDetail({
    Key? key,
    required this.info,
    required this.reportedByMap,
    required this.onUnblock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(appPadding / 2),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Info(info.userIndex)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  info.imageUrl,
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${info.userName} has been ${info.activity == 'report' ? "reported" : "blocked"}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textColor,
                      ),
                    ),
                    Text(
                      info.timestamp.toString(),
                      style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                info.activity != 'report'
                    ? showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return CustomAlertDialog(
                              text: "Do you want to unblock ${info.userName}?",
                              onYesTap: () async {
                                onUnblock();
                                snackbar("Unblocked", context);

                                Navigator.pop(dialogContext);
                              },
                              onNoTap: () => Navigator.pop(dialogContext));
                        },
                      )
                    : Container();
              },
              child: Tooltip(
                height: 40,
                textStyle: TextStyle(fontSize: 16, color: secondryColor),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                message: info.activity == 'report'
                    ? _getReportersTooltip(info.userId)
                    : "Blocked By Admin",
                child: Icon(
                  info.activity == 'report'
                      ? Icons.report_outlined
                      : Icons.block_outlined,
                  color: primaryColor.withOpacity(0.8),
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getReportersTooltip(String victimId) {
    List<RecentActivityModel>? reporters = reportedByMap[victimId];
    if (reporters != null) {
      return "Reported by: ${reporters.map((reporter) => reporter.userName).join(', ')}";
    } else {
      return "Reported by user does not exists";
    }
  }
}
