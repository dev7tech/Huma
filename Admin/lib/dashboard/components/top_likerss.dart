import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/likers_info_detail.dart';
import 'package:hookup4u_admin/model/likers_info_model.dart';
import 'package:hookup4u_admin/providers/likers_data_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/custom_skeleton.dart';

class TopLikers extends StatelessWidget {
  const TopLikers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analyticProvider = Provider.of<LikedDocProvider>(context);
    List<LikersInfoModel> analyticData = analyticProvider.likedDocs;
    List<LikersInfoModel> filteredAnalyticData =
        analyticData.where((item) => item.count! > 5).toList();

    bool isLoading = analyticProvider.isLoading;

    return Container(
      height: 360,
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
                'Top Likers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),
              Text(
                'Total Likes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: isLoading
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5, // Show 5 skeleton items
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            CustomSkeleton(
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            const SizedBox(width: appPadding),
                            Expanded(
                              child: CustomSkeleton(
                                height: 20,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : filteredAnalyticData.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No Top Likers Founds"),
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredAnalyticData.length,
                          itemBuilder: (context, index) =>
                              TolikersInfoDetailpLikers(
                            info: filteredAnalyticData[index],
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }
}
