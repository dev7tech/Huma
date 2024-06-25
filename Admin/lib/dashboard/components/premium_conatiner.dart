import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/premium_plan_graph.dart';

import '../../constants/constants.dart';

class Premiums extends StatelessWidget {
  const Premiums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Purchase Behavior for Subscriptions",
            style: TextStyle(
              color: textColor,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: ViewLineChart(),
          )
        ],
      ),
    );
  }
}
