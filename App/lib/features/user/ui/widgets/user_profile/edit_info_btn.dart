import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/common/routes/route_name.dart';

class EditInfoBtn extends StatelessWidget {
  const EditInfoBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
        top: 30,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: <Widget>[
            FloatingActionButton(
                heroTag: UniqueKey(),
                splashColor: secondaryColor,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.edit,
                  color: secondaryColor,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.editProfileScreen);
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Edit Info".tr().toString(),
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
