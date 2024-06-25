import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatelessWidget {
  final String message;

  const Loading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: LoadingIndicator(
                indicatorType: Indicator.lineScale,
                colors: [Colors.grey.shade600, Colors.grey.shade300, Colors.grey.shade500],
                strokeWidth: 2,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.black),
          ),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
