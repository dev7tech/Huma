// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import '../../model/user_model.dart';

// class InfoWidget extends StatelessWidget {
//   bool isLargeScreen;
//   final User userIndex;
// InfoWidget({super.key, required this.userIndex});

//   @override
//   Widget build(BuildContext context) {
//     return     Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: isLargeScreen
//                       ? const EdgeInsets.only(right: 50)
//                       : const EdgeInsets.all(1),
//                   child: Container(
//                     alignment: Alignment.center,
//                     height: MediaQuery.of(context).size.height,
//                     width: isLargeScreen
//                         ? MediaQuery.of(context).size.width * .35
//                         : MediaQuery.of(context).size.width * .45,
//                     child: GridView.count(
//                         physics: const ScrollPhysics(),
//                         crossAxisCount: 3,
//                         childAspectRatio: 1,
//                         //     MediaQuery.of(context).size.aspectRatio * .4,
//                         crossAxisSpacing: 4,
//                         padding: const EdgeInsets.all(10),
//                         children: List.generate(9, (index) {
//                           return Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child:
//                                       // widget.userIndex.imageUrl[0] != null
//                                       //     ?
//                                       Container(
//                                     decoration: widget.userIndex.imageUrl!
//                                                     .length >
//                                                 index &&
//                                             widget.userIndex.imageUrl![index] !=
//                                                 null
//                                         ? BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             // image: DecorationImage(
//                                             //     fit: BoxFit.cover,
//                                             //     image: NetworkImage(
//                                             //       widget.userIndex.imageUrl[index],
//                                             //     )),
//                                           )
//                                         : BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             border: Border.all(
//                                                 style: BorderStyle.solid,
//                                                 width: 1,
//                                                 color: Colors.grey),
//                                           ),
//                                     child: Stack(
//                                       children: <Widget>[
//                                         widget.userIndex.imageUrl!.length >
//                                                     index &&
//                                                 widget.userIndex
//                                                         .imageUrl![index] !=
//                                                     null
//                                             ? Container(
//                                                 decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                       fit: BoxFit.cover,
//                                                       image: NetworkImage(
//                                                         widget.userIndex
//                                                             .imageUrl![index],
//                                                       )),
//                                                 ),
//                                               )
//                                             : Container(),
//                                         // Center(
//                                         //     child: widget.userIndex.imageUrl.length >
//                                         //                 index &&
//                                         //             widget.userIndex
//                                         //                     .imageUrl[index] ==
//                                         //                 null
//                                         //         ? CupertinoActivityIndicator(
//                                         //             radius: 10,
//                                         //           )
//                                         //         : Container()),
//                                       ],
//                                     ),
//                                   ))
//                               //: Container()),
//                               );
//                         })),
//                   ),
//                 ),
//                 Expanded(
//                     child: Column(
//                   children: [
//                     ListTile(
//                       dense: true,
//                       title: const Text("Username"),
//                       subtitle: Text(widget.userIndex.name!),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("Gender"),
//                       subtitle: Text(widget.userIndex.gender!),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("Phone Number"),
//                       subtitle: Text(widget.userIndex.phoneNumber!),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("age"),
//                       subtitle: Text('${widget.userIndex.age}'),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("Maximum Distance"),
//                       subtitle: Text(widget.userIndex.maxDistance.toString()),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("Age Range"),
//                       subtitle: Text(widget.userIndex.ageRange.toString()),
//                     ),

//                     //  ListTile(
//                     //   title: Text("User_id"),
//                     //   subtitle: Text(widget.userIndex.id),
//                     // ),
//                   ],
//                 )),
//                 Expanded(
//                     child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ListTile(
//                       dense: true,
//                       title: const Text("About"),
//                       subtitle:
//                           Text(widget.userIndex.editInfo!["about"] ?? "----"),
//                     ),
//                     ListTile(
//                       dense: true,
//                       title: const Text("University"),
//                       subtitle: Text(widget.userIndex.editInfo!['university']),
//                     ),
//                     ListTile(
//                         dense: true,
//                         title: const Text("Job title"),
//                         subtitle: Text(
//                             widget.userIndex.editInfo!["job_title"] ?? "----")),
//                     ListTile(
//                         dense: true,
//                         title: const Text("Company"),
//                         subtitle: Text(
//                             widget.userIndex.editInfo!["company"] ?? "----")),
//                     ListTile(
//                         dense: true,
//                         title: const Text("Living in"),
//                         subtitle: Text(
//                             widget.userIndex.editInfo!["living_in"] ?? "----")),
//                     ListTile(
//                       dense: true,
//                       title: const Text("Address"),
//                       subtitle: Text(widget.userIndex.address!),
//                     ),
//                   ],
//                 )),
//               ],
//             );
//   }
// }