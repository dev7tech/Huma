import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hookup4u_admin/constants/responsive.dart';

import '../../constants/constants.dart';
import '../../model/analytic_info_model.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({Key? key, required this.info}) : super(key: key);

  final AnalyticInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Add elevation for a shadow effect (optional)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: appPadding,
          vertical: appPadding / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.count}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: !Responsive.isMobile(context) ? 18 : 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(appPadding / 2),
                  height: !Responsive.isMobile(context) ? 40 : 30,
                  width: !Responsive.isMobile(context) ? 40 : 30,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    color: info.color,
                  ),
                ),
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: !Responsive.isMobile(context) ? 15 : 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
