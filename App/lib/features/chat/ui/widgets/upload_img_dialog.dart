import 'package:flutter/material.dart';

class UploadImageDialog extends StatefulWidget {
  final VoidCallback onCancel;

  const UploadImageDialog({super.key, required this.onCancel});

  @override
  State<UploadImageDialog> createState() => _UploadImageDialogState();
}

class _UploadImageDialogState extends State<UploadImageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Cancel'),
            onTap: () {
              widget.onCancel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
