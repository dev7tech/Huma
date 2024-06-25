// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/subscription/creat_package.dart';
import 'package:hookup4u_admin/constants/custom_dailog.dart';
import 'dart:core';
import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/constants.dart';
import '../constants/snackbar.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  final collectionReference = firebaseInstance.collection("Packages");
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    _getPackages();
    super.initState();
  }

  _getPackages() async {
    collectionReference
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((doc) {
      products.clear();
      for (var item in doc.docs) {
        products.add(item.data());
      }
      if (mounted) setState(() {});
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
                text: "Manage Packages",
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
                      Text(
                        "",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: primaryColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                          textDirection: TextDirection.rtl,
                        ),
                        label: const Text(
                          "Create new",
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () async {
                          if (products.length < 6) {
                            Map<String, dynamic> result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreatePackage(const {}, products)));

                            result['timestamp'] = FieldValue.serverTimestamp();
                            await collectionReference
                                .doc(result['id'])
                                .set(result, SetOptions(merge: true));
                          } else {
                            snackbar(
                                "You have created already max number of packages",
                                context);
                          }
                        }),
                  ),
                ],
              ),
              products.isNotEmpty
                  ? productlist(products)
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget productlist(List<Map<String, dynamic>> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * .08,
                  headingRowHeight: 40,
                  horizontalMargin: MediaQuery.of(context).size.width * .05,
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Sr.No.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Product id",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Title",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      "Description",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Status",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Edit/Deactivate",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Remove",
                      textAlign: TextAlign.center,
                    )),
                  ],
                  rows: list
                      .mapIndexed(
                        (index, i) => DataRow(cells: [
                          DataCell(
                            Text(
                              (i + 1).toString(),
                              //  products.indexOf(index).toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index['id'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index['title'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index["description"],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  index['status'] ? "Active" : "Deactivated",
                                  style: TextStyle(
                                      color: index['status']
                                          ? Colors.green
                                          : Colors.red),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                index['status']
                                    ? const Icon(
                                        Icons.done_outline,
                                        color: Colors.green,
                                        size: 13,
                                      )
                                    : const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 13,
                                      ),
                              ],
                            ),
                          ),
                          DataCell(
                            IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  var editDetails = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreatePackage(index, products)));
                                  if (editDetails != null) {
                                    collectionReference
                                        .doc(index['id'])
                                        .update(editDetails);
                                  }
                                }),
                          ),
                          DataCell(
                            IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                          text:
                                              "Do you want to delete this package ?",
                                          onYesTap: () async {
                                            await collectionReference
                                                .doc(index['id'])
                                                .delete()
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                            }).catchError((onError) {
                                              snackbar(onError, context);
                                            }).then((value) => snackbar(
                                                    "Deleted Successfully",
                                                    context));
                                          },
                                          onNoTap: () =>
                                              Navigator.pop(context));
                                    },
                                  );
                                }),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ));
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
