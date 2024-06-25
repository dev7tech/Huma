import 'package:flutter/material.dart';

class CustomSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadiusGeometry borderRadius;

  const CustomSkeleton({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius,
      ),
    );
  }
}
