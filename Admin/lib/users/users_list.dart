// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u_admin/constants/constants.dart';
import 'package:hookup4u_admin/model/user_model.dart';
import 'package:hookup4u_admin/users/user_info.dart';
import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/snackbar.dart';
import '../data/repo.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<Users> {
  CollectionReference collectionReference =
      firebaseInstance.collection("Users");
  @override
  void initState() {
    _getuserList();
    super.initState();
  }

  TextEditingController searchctrlr = TextEditingController();
  bool isLargeScreen = false;

  int? totalDoc;
  DocumentSnapshot? lastVisible;
  int documentLimit = 25;
  List<User> user = [];
  bool sort = true;
  // int start = 0;
  // int end = 25;
  Future _getuserList() async {
    collectionReference
        .orderBy("user_DOB", descending: true)
        .get()
        .then((value) {
      totalDoc = value.docs.length;
    });
    if (lastVisible != null) {
      await collectionReference
          .orderBy("user_DOB", descending: true)
          .startAfterDocument(lastVisible!)
          .limit(documentLimit)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          snackbar('No more data available', context);
          debugPrint("no more data");
          return;
        }
        lastVisible = value.docs[value.docs.length - 1];
        for (var doc in value.docs) {
          //todo new change regarding data length
          if (doc.data().toString().isNotEmpty) {
            User temp = User.fromDocument(doc);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    } else {
      await collectionReference
          //.where('userId', isGreaterThan: '')
          .limit(documentLimit)
          .orderBy('user_DOB', descending: true)
          .get()
          .then((value) {
        lastVisible = value.docs[value.docs.length - 1];
        for (var doc in value.docs) {
          if (doc.data().toString().isNotEmpty) {
            User temp = User.fromDocument(doc);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    }
  }

  Widget userlists(List<User> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: sort,
                  sortColumnIndex: 2,
                  columnSpacing: MediaQuery.of(context).size.width * .063,
                  columns: [
                    const DataColumn(
                      label: Text("Images"),
                    ),
                    const DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                        label: const Text("Gender"),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }),
                    const DataColumn(label: Text("Phone Number")),
                    const DataColumn(label: Text("User_id")),
                    const DataColumn(label: Text("view")),
                  ],
                  rows: list
                      .getRange(
                          list.length >= documentLimit
                              ? list.length - documentLimit
                              : 0,
                          list.length)
                      .map(
                        (index) => DataRow(cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 18,
                                child: index.imageUrl![0] != null
                                    ? Image.network(
                                        index.imageUrl![0],
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                            ),
                            // onTap: () {
                            //   // write your code..
                            // },
                          ),
                          DataCell(
                            Text(index.name!),
                          ),
                          DataCell(
                            Text(index.gender!),
                          ),
                          DataCell(
                            Text(index.phoneNumber!),
                          ),
                          DataCell(
                            Row(
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    index.id!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.content_copy,
                                      size: 20,
                                    ),
                                    tooltip: "copy",
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                        text: index.id!,
                                      ));
                                    })
                              ],
                            ),
                          ),
                          DataCell(
                            IconButton(
                                icon: const Icon(Icons.fullscreen),
                                tooltip: "open profile",
                                onPressed: () async {
                                  var isdelete = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Info(index)));
                                  if (isdelete != null && isdelete) {
                                    snackbar('Deleted', context);

                                    setState(() {
                                      searchctrlr.clear();
                                      searchReasultfuture = null;
                                      user.removeWhere(
                                          (element) => element.id == index.id);
                                    });
                                  }
                                }),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
            searchReasultfuture != null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 12,
                            ),
                            onPressed: () {
                              setState(() {
                                if (list.length > documentLimit) {
                                  list.removeRange(
                                    list.length - documentLimit,
                                    list.length,
                                  );
                                }
                              });
                            }),
                        Text(
                            "${list.length >= documentLimit ? list.length - documentLimit : 0}-${list.length - 1} of $totalDoc  "),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  _getuserList()
                                      .then((value) => Navigator.pop(context));
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor),
                                  ));
                                });
                          },
                        )
                      ],
                    ),
                  )
          ],
        ));
  }

  List<User> results = [];
  Future<QuerySnapshot>? searchReasultfuture;

  searchuser(String query) {
    Future<QuerySnapshot>? users;
    String queryType =
        Repo.classifyString(query); // Store the result in a variable

    debugPrint("query is $queryType");

    if (query.trim().isNotEmpty) {
      if (queryType == 'phone') {
        users = collectionReference
            .where(
              'phoneNumber',
              isEqualTo: query,
            )
            .get();
      } else if (queryType == 'userId') {
        users = collectionReference
            .where(
              'userId',
              isEqualTo: query,
            )
            .get();
      } else if (queryType == 'name') {
        users = collectionReference
            .where(
              'UserName',
              isEqualTo: query,
            )
            .get();
      }

      setState(() {
        searchReasultfuture = users;
      });
    }
  }

  Widget buildSearchresults() {
    return FutureBuilder(
      future: searchReasultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                )),
              ),
              const Text("Searching......"),
            ],
          );
          //
        }
        if (snapshot.data!.docs.isNotEmpty) {
          results.clear();
          for (var doc in snapshot.data!.docs) {
            if (doc.data().toString().isNotEmpty) {
              User usert2 = User.fromDocument(doc);
              results.add(usert2);
            }
          }
          return userlists(results);
        }
        return const Center(child: Text("no data found"));
      },
    );
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
              text: "Search by name,userId or phone number",
              searchcontroller: searchctrlr,
              submittap: searchuser,
              isIconShow: true,
              prefixtap: () => searchuser(searchctrlr.text),
              sufixtap: () {
                searchctrlr.clear();
                setState(() {
                  searchReasultfuture = null;
                });
              },
            ),
            const SizedBox(
              height: appPadding,
            ),
            Container(
              color: bgColor.withOpacity(0.5),
              child: searchReasultfuture == null
                  ? user.isNotEmpty
                      ? userlists(user)
                      : const Center(child: Text('No User Found!'))
                  : buildSearchresults(),
            ),
          ],
        ),
      ),
    ));
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 2) {
      if (ascending) {
        user.sort((a, b) => a.gender!.compareTo(b.gender!));
      } else {
        user.sort((a, b) => b.gender!.compareTo(a.gender!));
      }
    }
  }
}
