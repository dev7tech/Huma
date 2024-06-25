import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/top_likerss.dart';
import 'package:hookup4u_admin/dashboard/components/active_users.dart';
import 'package:hookup4u_admin/dashboard/components/users_by_gender.dart';
import 'package:hookup4u_admin/dashboard/components/premium_conatiner.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import 'analytic_cards.dart';
import 'widgets/custom_appbar.dart';
import 'recent_activity.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            const CustomAppbar(text: "Search by actions"),
            const SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const AnalyticCards(),
                          const SizedBox(
                            height: appPadding,
                          ),
                          const ActiveUsersGaph(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context))
                            const RecentActivity(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        flex: 2,
                        child: RecentActivity(),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Responsive.isMobile(context))
                                const Expanded(
                                  flex: 2,
                                  child: TopLikers(),
                                ),
                              if (!Responsive.isMobile(context))
                                const SizedBox(
                                  width: appPadding,
                                ),
                              const Expanded(
                                flex: 3,
                                child: Premiums(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) const TopLikers(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context))
                            const UsersByGender(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        flex: 2,
                        child: UsersByGender(),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
