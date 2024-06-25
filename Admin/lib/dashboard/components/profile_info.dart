import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/captilized_image.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/notifications_dialod.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  String adminName = "Admin";
  String imageUrl = "";
  Future<AdminInfo> getAdminInfo() async {
    final DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection('Admin').doc('id_password').get();

    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>;

    String imageUrl = data['imageUrl'] ??
        ''; // Replace with the actual field name for image URL
    String name =
        data['name'] ?? 'Admin'; // Replace with the actual field name for name

    return AdminInfo(imageUrl: imageUrl, name: name);
  }

  void fetchAdminInfo() async {
    AdminInfo adminInfo = await getAdminInfo();
    if (mounted) {
      setState(() {
        adminName = adminInfo.name;
        imageUrl = adminInfo.imageUrl;
      });
    }
  }

  @override
  void initState() {
    fetchAdminInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const AdminScreen();
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: Image.asset(
              "assets/icons/cloud.png",
              height: 35,
              color: primaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: appPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: appPadding,
            vertical: appPadding / 2,
          ),
          child: Row(
            children: [
              CapitalizedAvatar(
                displayName: adminName,
                imageUrl: imageUrl,
                googleUser: imageUrl.isNotEmpty,
              ),
              if (!Responsive.isMobile(context))
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: appPadding / 2),
                  child: Text(
                    'Hi, $adminName',
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}

class AdminInfo {
  final String imageUrl;
  final String name;

  AdminInfo({required this.imageUrl, required this.name});
}
