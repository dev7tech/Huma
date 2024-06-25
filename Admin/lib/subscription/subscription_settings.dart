// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/constants.dart';
import '../constants/responsive.dart';
import '../constants/snackbar.dart';

class SubscriptionSettings extends StatefulWidget {
  const SubscriptionSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SubscriptionSettingsState createState() => _SubscriptionSettingsState();
}

class _SubscriptionSettingsState extends State<SubscriptionSettings> {
  TextEditingController freeRctlr = TextEditingController();
  TextEditingController paidRctlr = TextEditingController();
  TextEditingController freeSwipectlr = TextEditingController();
  final collectionReference = firebaseInstance.collection("Item_access");
  TextEditingController paidSwipectlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Map<String, dynamic> data = {};
  bool edit = false;

  @override
  void initState() {
    _getAccessItems();
    super.initState();
  }

  ///Get paid or free item range
  Map items = {};
  _getAccessItems() async {
    if (kDebugMode) {
      print(items.length);
    }
    collectionReference.snapshots().listen((doc) {
      items = doc.docs.first.data();
      //todo may cause error
      if (kDebugMode) {
        print(doc.docs.first.data().toString());
      }
      if (mounted) {
        setState(() {
          freeRctlr.text = items['free_radius'];
          paidRctlr.text = items['paid_radius'];
          freeSwipectlr.text = items['free_swipes'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbarSecond(
              text: "Subscription settings",
              searchcontroller: TextEditingController(text: ""),
              submittap: (p0) {},
              prefixtap: () {},
              sufixtap: () {},
              isIconShow: false,
            ),
            const SizedBox(
              height: appPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // if (!Responsive.isDesktop(context))
                    //   IconButton(
                    //     onPressed: context.read<Controller>().controlMenu,
                    //     icon: Icon(
                    //       Icons.menu,
                    //       color: textColor.withOpacity(0.5),
                    //     ),
                    //   ),
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ],
                ),
                !edit
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton.icon(
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                              textDirection: TextDirection.rtl,
                            ),
                            label: const Text(
                              "Edit",
                              style: TextStyle(color: textColor),
                            ),
                            onPressed: () async {
                              setState(() {
                                edit = true;
                              });
                            }),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            edit = false;
                          });
                        })
              ],
            ),
            Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.all(48.0)
                  : const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: edit
                                  ? TextFormField(
                                      controller: freeRctlr,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter this field';
                                        } else if (!isNumeric(value)) {
                                          return 'Enter an integar value';
                                        }
                                        return null;
                                      },
                                      autofocus: false,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                          helperText:
                                              "this is how it will appear in app",
                                          labelText: "Free Radius(Kms.)",
                                          hintText: "Free Radius(Kms.)",
                                          floatingLabelStyle:
                                              TextStyle(color: primaryColor),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          focusColor: primaryColor),
                                      onSaved: (value) {
                                        data['free_radius'] = value;
                                      },
                                    )
                                  : Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ListTile(
                                        dense: !Responsive.isDesktop(context),
                                        leading: Icon(
                                          Icons.location_searching,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: const Text(
                                          "Free radius access(in kms.)",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                            "${freeRctlr.text.isNotEmpty ? freeRctlr.text : "-----"} km"),
                                      ),
                                    )),
                          SizedBox(
                            width: !Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width * .1
                                : MediaQuery.of(context).size.width * .01,
                          ),
                          Expanded(
                              child: edit
                                  ? TextFormField(
                                      controller: paidRctlr,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter this field';
                                        } else if (!isNumeric(value)) {
                                          return 'Enter an integar value';
                                        }
                                        return null;
                                      },
                                      autofocus: false,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                          helperText:
                                              "this is how it will appear in app",
                                          labelText: "Paid Radius(Kms.)",
                                          hintText: "Paid Radius(Kms.)",
                                          floatingLabelStyle:
                                              TextStyle(color: primaryColor),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          focusColor: primaryColor),
                                      onSaved: (value) {
                                        data['paid_radius'] = value;
                                      },
                                    )
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 5,
                                      child: ListTile(
                                        dense: !Responsive.isDesktop(context),
                                        leading: Icon(
                                          Icons.location_searching,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: const Text(
                                            "Paid radius access(in kms.)",
                                            overflow: TextOverflow.ellipsis),
                                        subtitle: Text(
                                            "${paidRctlr.text.isNotEmpty ? paidRctlr.text : "-----"} km"),
                                      ),
                                    )),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: edit
                                ? TextFormField(
                                    controller: freeSwipectlr,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter this field';
                                      } else if (!isNumeric(value)) {
                                        return 'Enter an integar value';
                                      }
                                      return null;
                                    },
                                    autofocus: false,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                        helperText:
                                            "this is how it will appear in app",
                                        labelText: "Free Swipes",
                                        hintText: "Free Swipes",
                                        floatingLabelStyle:
                                            TextStyle(color: primaryColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor)),
                                        focusColor: primaryColor),
                                    onSaved: (value) {
                                      data['free_swipes'] = value;
                                    },
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 5,
                                    child: ListTile(
                                      dense: !Responsive.isDesktop(context),
                                      leading: Icon(
                                        Icons.filter_none,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: const Text(
                                          "Free swipes(in 24hrs.)",
                                          overflow: TextOverflow.ellipsis),
                                      subtitle: Text(
                                          '${freeSwipectlr.text.isNotEmpty ? freeSwipectlr.text : "-----"} swipes/24hrs.'),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: !Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width * .1
                                : MediaQuery.of(context).size.width * .01,
                          ),
                          Expanded(
                            child: edit
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: paidSwipectlr,
                                      readOnly: true,
                                      autofocus: false,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                          helperText:
                                              "this is how it will appear in app",
                                          hintText: "Unlimited(if paid user)",
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          floatingLabelStyle:
                                              TextStyle(color: primaryColor),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          focusColor: primaryColor),
                                    ),
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 5,
                                    child: ListTile(
                                      dense: !Responsive.isDesktop(context),
                                      leading: Icon(
                                        Icons.filter_none,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: const Text("Paid Swipes",
                                          overflow: TextOverflow.ellipsis),
                                      subtitle: const Text("Unlimited"),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      edit
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                    ),
                                    child: const Text(
                                      "Save Changes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        if (kDebugMode) {
                                          print(data);
                                        }
                                        setState(() {
                                          edit = false;
                                        });
                                        await collectionReference
                                            .doc('free-paid')
                                            .set(data, SetOptions(merge: true))
                                            .whenComplete(() => snackbar(
                                                "Updated Sucessfully",
                                                context));
                                      }
                                    }),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
