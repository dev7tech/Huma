import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/responsive.dart';

import '../../constants/constants.dart';
import '../../model/likers_info_model.dart';
import '../../users/user_info.dart';

class TolikersInfoDetailpLikers extends StatelessWidget {
  const TolikersInfoDetailpLikers({Key? key, required this.info})
      : super(key: key);

  final LikersInfoModel info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Info(info.userIndex!)));
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(appPadding / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  info.svgSrc!,
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width * 0.1
                          : null,
                      child: Text(
                        info.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      '${info.count!}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
