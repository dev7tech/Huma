// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u_admin/model/user_model.dart';
import 'package:hookup4u_admin/report/reported_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hookup4u_admin/users/user_info.dart';
import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/constants.dart';
import '../data/repo.dart';

class ReportedUserList extends StatefulWidget {
  const ReportedUserList({super.key});

  @override
  ReportedUserListState createState() => ReportedUserListState();
}

class ReportedUserListState extends State<ReportedUserList> {
  List? reportedUserProfileList;
  var user = [];
  DocumentSnapshot? lastVisible;
  bool sort = true;
  int? totalDoc;
  int? documentLimit = 25;
  TextEditingController searchctrlr = TextEditingController();
  CollectionReference collectionReference =
      firebaseInstance.collection("Users");

  @override
  void initState() {
    super.initState();
    fetchReportedUserList();
    getuserList();
  }

  fetchReportedUserList() async {
    dynamic resultant = await ReportedUser().getReportedUser();

    if (resultant == null) {
      if (kDebugMode) {
        print('unable to retrieve');
      }
    } else {
      if (mounted) {
        setState(() {
          reportedUserProfileList = resultant;
        });
      }
    }
    totalDoc = reportedUserProfileList!.length;
  }

  Future getuserList() async {
    await collectionReference.doc().get().then((value) {});

    for (int i = 0; i < reportedUserProfileList!.length; i++) {
      var reportedid = reportedUserProfileList![i]['victim_id'];
      var reportedby = reportedUserProfileList![i]['reported_by'];

      await collectionReference.doc(reportedid).get().then((valueUser) {
        collectionReference.doc(reportedby).get().then((report) {
          user.add({
            'Reportedby': report['UserName'],
            'UserData': User.fromDocument(valueUser),
            'ReportedBydata': User.fromDocument(report)
          });
          if (mounted) setState(() {});
        });
      });
    }
    return user;
  }

  Widget userlists(user) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: sort,
                sortColumnIndex: 2,
                columnSpacing: MediaQuery.of(context).size.width * .063,
                columns: const [
                  DataColumn(
                    label: Text("Images"),
                  ),
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Gender"),
                  ),

                  DataColumn(label: Text("Phone Number")),

                  DataColumn(label: Text("User_id")),
                  DataColumn(label: Text("Reported By")),
                  // DataColumn(label: Text("view")),
                ],
                rows: [
                  for (var i in user)
                    DataRow(cells: [
                      DataCell(
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 18,
                            child: i['UserData'].imageUrl[0] != null
                                ? Image.network(
                                    "${i['UserData'].imageUrl[0]}",
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text('');
                                    },
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      DataCell(
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Info(i['UserData'])));
                            },
                            child: Text("${i['UserData'].name}")),
                      ),
                      DataCell(
                        SizedBox(
                            width: 60, child: Text("${i['UserData'].gender}")),
                      ),

                      DataCell(
                        Text("${i['UserData'].phoneNumber}"),
                      ),

                      DataCell(
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                "${i['UserData'].id}",
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
                                    text: "${i['UserData'].id}",
                                  ));
                                })
                          ],
                        ),
                      ),
                      DataCell(
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Info(i['ReportedBydata'])));
                            },
                            child: Text("${i['Reportedby']}")),
                      ),
                      // DataCell(
                      //   IconButton(
                      //       icon: const Icon(Icons.fullscreen),
                      //       tooltip: "open profile",
                      //       onPressed: () async {
                      //         var isdelete = await Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     Info(i['UserData'])));
                      //         if (isdelete != null && isdelete) {
                      //           //todo new entry
                      //           if (!mounted) snackbar('Deleted', context);

                      //           setState(() {
                      //             searchctrlr.clear();
                      //             searchReasultfuture;
                      //             user.removeWhere((element) =>
                      //                 element.id == i['UserData'].id);
                      //           });
                      //         }
                      //       }),
                      // ),
                    ]),
                ],
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
                          onPressed: () {}),
                      Text(
                          "${user.length >= documentLimit ? user.length - documentLimit : 0}-${user.length - 1} of $totalDoc  "),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  var results = [];
  var r = [];
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
        }

        if (snapshot.data!.docs.isNotEmpty) {
          results.clear();
          for (var doc in snapshot.data!.docs) {
            if (doc.data().toString().contains('userId')) {
              var t = user.map((e) {
                String id = doc.get('userId') ?? "";
                if (id == e['UserData'].id) {
                  var reportername = e['Reportedby'];
                  var usert22 = User.fromDocument(doc);
                  results
                      .add({'UserData': usert22, 'Reportedby': reportername});
                  debugPrint("results is $results");
                }
              });
              if (kDebugMode) {
                print(t);
              }
            }
            debugPrint("false");
          }

          return userlists(results);
        }
        return const Center(child: Text("no data found"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbarSecond(
              text: "Search by name ,userId or phone number",
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
                      : const Center(child: Text('No Reported User Found!'))
                  : buildSearchresults(),
            ),
          ],
        ),
      ),
    );
  }
}
