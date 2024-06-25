import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/radial_painter.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../providers/gender_data_provider.dart';

class UsersByGender extends StatelessWidget {
  const UsersByGender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double menPercentage =
        Provider.of<GenderDataProvider>(context).menPercentage;
    double womenPercentage =
        Provider.of<GenderDataProvider>(context).womenPercentage;
    double otherPercentage =
        Provider.of<GenderDataProvider>(context).otherPercentage;
    return Padding(
      padding: const EdgeInsets.only(top: appPadding),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: secondryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users by gender',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              height: 180,
              margin: const EdgeInsets.all(appPadding),
              padding: const EdgeInsets.all(appPadding),
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  menPercentage: menPercentage,
                  womenPercentage: womenPercentage,
                  otherPercentage: otherPercentage,
                  width: 18.0,
                ),
                child: SizedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 35.0, fontWeight: FontWeight.w600),
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          FadeAnimatedText(
                              '${(womenPercentage * 100).toStringAsFixed(0)}%',
                              fadeOutBegin: 0.9,
                              fadeInEnd: 0.7,
                              duration: const Duration(seconds: 3),
                              textStyle: const TextStyle(color: Colors.purple)),
                          FadeAnimatedText(
                              '${(menPercentage * 100).toStringAsFixed(0)}%',
                              fadeOutBegin: 0.9,
                              fadeInEnd: 0.7,
                              duration: const Duration(seconds: 3),
                              textStyle: const TextStyle(color: Colors.blue)),
                          FadeAnimatedText(
                              '${(otherPercentage * 100).toStringAsFixed(0)}%',
                              fadeOutBegin: 0.9,
                              fadeInEnd: 0.7,
                              duration: const Duration(seconds: 3),
                              textStyle:
                                  TextStyle(color: Colors.green.shade400)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    height: 20,
                    textStyle: TextStyle(fontSize: 12, color: secondryColor),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    message: '${(menPercentage * 100).toStringAsFixed(2)}%',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.blue,
                          size: 10,
                        ),
                        const SizedBox(
                          width: appPadding / 2,
                        ),
                        Text(
                          'Men',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Tooltip(
                    height: 20,
                    textStyle: TextStyle(fontSize: 12, color: secondryColor),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    message: '${(womenPercentage * 100).toStringAsFixed(2)}%',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.purple,
                          size: 10,
                        ),
                        const SizedBox(
                          width: appPadding / 2,
                        ),
                        Text(
                          'Women',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Tooltip(
                    height: 20,
                    textStyle: TextStyle(fontSize: 12, color: secondryColor),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    message: '${(otherPercentage * 100).toStringAsFixed(2)}%',
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.green.shade400,
                          size: 10,
                        ),
                        const SizedBox(
                          width: appPadding / 2,
                        ),
                        Text(
                          'Other',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
