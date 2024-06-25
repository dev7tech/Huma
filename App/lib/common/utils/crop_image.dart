import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CropMedia extends StatefulWidget {
  final String title;
  final File file;
  final String checkType;

  const CropMedia(
      {Key? key,
      required this.title,
      required this.file,
      required this.checkType})
      : super(key: key);

  @override
  CropMediaState createState() => CropMediaState();
}

class CropMediaState extends State<CropMedia> {
  CropController controller = CropController();

  @override
  void initState() {
    //controller.dispose();
    super.initState();
    controller = widget.checkType == 'profile'
        ? CropController(
            aspectRatio: 3 / 4,
            defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
          )
        : widget.checkType == 'addMedia'
            ? CropController(
                aspectRatio: 1,
                defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
              )
            : CropController();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Edit Photo'.tr().toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: _finished,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CropImage(
            controller: controller,
            image: Image.file(widget.file),
            minimumImageSize: 150,
          ),
        ),
      ),
      bottomNavigationBar: _buildButtons(widget.checkType),
    );
  }

  Widget _buildButtons(String checktype) {
    if (checktype == 'profile') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              controller.aspectRatio = 3.0 / 4.0;
              controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
            },
            child: const Text(
              "3:4",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.aspectRatio = 9.0 / 16.0;
              controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
            },
            child: const Text(
              "9:16",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _finished() async {
    final image = await controller.croppedBitmap();
    final data = await image.toByteData(format: ImageByteFormat.png);
    final bytes = data!.buffer.asUint8List();
    // final dir = await getApplicationDocumentsDirectory();
    // final path = dir.path;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    Random random = Random();
    int randomNumber = random.nextInt(1000);
    var filePath = '$tempPath/$randomNumber.png';
    File file = await File(filePath).writeAsBytes(bytes);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, file);
  }
}
