import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/common/routes/route_name.dart';
import 'package:hookup4u2/features/user/models/profile.dart';

class SettingsBtn extends StatelessWidget {
  const SettingsBtn(
      {super.key,
      required this.profile,
      required this.isPurchased,
      required this.items});

  final Profile profile;
  final bool isPurchased;
  final Map items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            FloatingActionButton(
                splashColor: secondaryColor,
                heroTag: UniqueKey(),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.settings,
                  color: secondaryColor,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.settingPage,
                      arguments: {
                        "profile": profile,
                        "isPurchased": isPurchased,
                        "items": items
                      });
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Settings".tr().toString(),
                style: TextStyle(color: secondaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
