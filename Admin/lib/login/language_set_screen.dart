import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final collectionReference = firebaseInstance.collection("Language");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: appPadding),
            child: CustomAppbarSecond(
              text: "Settings",
              searchcontroller: TextEditingController(text: ""),
              submittap: (p0) {},
              prefixtap: () {},
              sufixtap: () {},
              isIconShow: false,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Select Languages To Appear on App',
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center();
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // Language rows
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['english'] == true,
                      'English',
                      'english',
                    ),
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['spanish'] == true,
                      'Spanish',
                      'spanish',
                    ),
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['hindi'] == true,
                      'Hindi',
                      'hindi',
                    ),
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['russian'] == true,
                      'Russian',
                      'russian',
                    ),
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['german'] == true,
                      'German',
                      'german',
                    ),
                    _buildLanguageRow(
                      context,
                      snapshot.data!.docs.first['french'] == true,
                      'French',
                      'french',
                    ),

                    // Note
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Note: Long press the box to uncheck the option and press the box once to check the option',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRow(BuildContext context, bool isSelected,
      String languageName, String languageKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onLongPress: () {
              collectionReference
                  .doc('present_languages')
                  .set({languageKey: false}, SetOptions(merge: true));
            },
            onTap: () {
              collectionReference
                  .doc('present_languages')
                  .set({languageKey: true}, SetOptions(merge: true));
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 2),
                borderRadius: BorderRadius.circular(0),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )
                  : Container(),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 150,
            child: Text(
              languageName,
              style: const TextStyle(
                  fontSize: 16.0, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
