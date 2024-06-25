import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? text;
  final Function? onYesTap;
  final Function? onNoTap;

  const CustomAlertDialog({Key? key, this.text, this.onYesTap, this.onNoTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.27,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 48,
                color: primaryColor,
              ),
              const Text(
                "Alert!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => onNoTap!(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "No",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () => onYesTap!(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
