import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hookup4u2/common/utils/app_exit.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/conversation_bloc.dart';
import 'package:hookup4u2/features/chat/ui/screens/conversations_page.dart';
import 'package:hookup4u2/models/user_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../common/constants/colors.dart';

import '../../../../common/providers/theme_provider.dart';
import '../../../../common/utils/blockedby_admin.dart';
import '../../../user/ui/screens/user_profile.dart';
import '../screens/home_page.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("Handling a background message: ${message.messageId}");

//   if (message.data['type'] == 'Call') {
//     NotificationData.showCallkitIncoming(message.data['channel_id'], message.data['senderName'],
//         message.data['senderPicture'], message.notification?.body);
//   }
// }

class TabBarScreen extends StatelessWidget {
  const TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final profile = context.select((RegistrationBloc bloc) => bloc.state.profile);

    // return Homepage(
    //   items: {},
    //   isPurchased: false,
    // );
    // return const ProfilePage(isPurchased: false, items: {}, purchases: []);
    return const Tabbar("active", false);
    // return Scaffold(
    //     body: Container(
    //   width: double.maxFinite,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text('Signed In as ${profile?.userName}'),
    //       const SizedBox(height: 20),
    //       IconButton(
    //           onPressed: () {
    //             context.read<AuthBloc>().add(AuthLogoutRequested());
    //           },
    //           icon: Icon(Icons.logout)),
    //     ],
    //   ),
    // ));
  }
}

class Tabbar extends StatefulWidget {
  final bool? isPaymentSuccess;
  final String? plan;
  const Tabbar(this.plan, this.isPaymentSuccess, {super.key});
  @override
  TabbarState createState() => TabbarState();
}

//_
class TabbarState extends State<Tabbar> with WidgetsBindingObserver {
  // CollectionReference callRef = firebaseFireStoreInstance.collection("calls");
  List<UserModel> users = [];
  int swipedcount = 0;

  String? currentUuid;
  String textEvents = "";
  List<PurchaseDetails> purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final InAppPurchase iap = InAppPurchase.instance;
  bool isPuchased = false;

  @override
  void initState() {
    final profile = context.read<RegistrationBloc>().state.profile;
    context.read<ConversationBloc>().add(LoadConversationEvent(profile.id));

    super.initState();

// when any background message recieve

    // initFirebase(context);
    // listenerEvent(onEvent);
    // _getAccessItems();
    // _getpastPurchases();

    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess!) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final themeProvider =
            Provider.of<ThemeProvider>(context, listen: false);
        await Alert(
          context: context,
          style: AlertStyle(
              backgroundColor: Theme.of(context).primaryColor,
              titleStyle: TextStyle(
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black),
              descStyle: TextStyle(
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black)),
          type: AlertType.success,
          title: "Confirmation".tr().toString(),
          desc: "You have successfully subscribed to our"
              .tr(args: ["${widget.plan}"]),
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              width: 120,
              color: primaryColor,
              child: Text(
                "Ok".tr().toString(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription!.cancel();
    super.dispose();
  }

  // static initFirebase(BuildContext context) async {
  //   await Firebase.initializeApp();

  //   // when user tap on msg fron terminated state
  //   FirebaseMessaging.instance.getInitialMessage().then((message) async {
  //     debugPrint("RemoteMessage  ${message?.data}");
  //     if (message != null) {
  //       bool iscallling = await NotificationData.checkcallState(message.data['channel_id']);
  //       if (Platform.isIOS && message.data['type'] == 'Call') {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
  //       } else if (Platform.isAndroid) {
  //         if (message.data['type'] == 'Call' && iscallling) {
  //           NotificationData.showCallkitIncoming(
  //               message.data['channel_id'],
  //               message.data['senderName'],
  //               message.data['senderPicture'],
  //               message.notification?.body);
  //         }
  //       } else if (message.data['type'] == 'Call' && !iscallling) {
  //         Navigator.pushReplacementNamed(context, RouteName.tabScreen, arguments: "notification");
  //       } else {
  //         UserModel sender = UserModel.convertStringToUserModel(message.data['sender']);
  //         UserModel second = UserModel.convertStringToUserModel(message.data['second']);

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ChatPage(
  //                     sender: sender, second: second, chatId: message.data['channel_id'])));
  //       }
  //     } else {}
  //   });

  //   // when user tap on notification in background state
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //     debugPrint('onMessageOpenedApp data: ${message.data}');
  //     debugPrint('onMessageOpenedApp type: ${message.data['type']}');
  //     bool iscallling = await NotificationData.checkcallState(message.data['channel_id']);
  //     if (Platform.isIOS && message.data['type'] == 'Call') {
  //       if (iscallling) {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
  //       }
  //     } else if (Platform.isAndroid) {
  //       if (message.data['type'] == 'Call' && iscallling) {
  //         NotificationData.showCallkitIncoming(
  //             message.data['channel_id'],
  //             message.data['senderName'],
  //             message.data['senderPicture'],
  //             message.notification?.body);
  //       }

  //       // Handle the call based on the call type
  //     } else if (message.data['type'] == 'Call' && !iscallling) {
  //       Navigator.pushReplacementNamed(context, RouteName.tabScreen, arguments: "notification");
  //     } else {
  //       UserModel sender = UserModel.convertStringToUserModel(message.data['sender']);
  //       UserModel second = UserModel.convertStringToUserModel(message.data['second']);
  //       debugPrint("sender is ${message.data['sender']}");
  //       debugPrint("second  is $sender");
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   ChatPage(sender: sender, second: second, chatId: message.data['channel_id'])));
  //     }
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     debugPrint(
  //         'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
  //     if (Platform.isIOS && message.data['type'] == 'Call') {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
  //     } else if (Platform.isAndroid && message.data['type'] == 'Call') {
  //       NotificationData.showCallkitIncoming(message.data['channel_id'], message.data['senderName'],
  //           message.data['senderPicture'], message.notification?.body);
  //     }
  //   });
  // }

  // Map items = {};
  // _getAccessItems() async {
  //   firebaseFireStoreInstance.collection("Item_access").snapshots().listen((doc) {
  //     if (doc.docs.isNotEmpty) {
  //       items = doc.docs[0].data();
  //       debugPrint(doc.docs[0].data().toString());
  //     }
  //   });
  // }

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          //  _showPendingUI();
          debugPrint('===pending...  ${purchaseDetails.productID}');
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyPuchase(purchaseDetails.productID);

          break;
        case PurchaseStatus.error:
          debugPrint(purchaseDetails.error!.toString());

          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await iap.completePurchase(purchaseDetails);
      }
    });
  }

  // Future<void> _getpastPurchases() async {
  //   debugPrint('===past purchses----');
  //   bool isAvailable = await iap.isAvailable();
  //   if (isAvailable) {
  //     await iap.restorePurchases();
  //   }
  // }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    debugPrint('======**************');
    return purchases.firstWhere(
      (purchase) =>
          purchase.purchaseID != null && purchase.productID == productId,
      // orElse: () => null
    );
  }

  ///verifying pourchase of user
  Future<void> _verifyPuchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      debugPrint(purchase.productID);
      if (Platform.isIOS) {
        await iap.completePurchase(purchase);

        isPuchased = true;
      }
      isPuchased = true;
    } else {
      isPuchased = false;
    }
  }

  // getCurrentCall() async {
  //   //check current call from pushkit if possible
  //   var calls = await FlutterCallkitIncoming.activeCalls();
  //   if (calls is List) {
  //     if (calls.isNotEmpty) {
  //       debugPrint('DATA: $calls');
  //       currentUuid = calls[0]['id'];
  //       return calls[0];
  //     } else {
  //       currentUuid = "";
  //       return null;
  //     }
  //   }
  // }

  // Future<void> listenerEvent(Function? callback) async {
  //   try {
  //     FlutterCallkitIncoming.onEvent.listen((event) async {
  //       if (kDebugMode) {
  //         print('HOME: $event');
  //       }
  //       switch (event!.event) {
  //         case Event.actionCallIncoming:
  //           break;
  //         case Event.actionCallStart:
  //           break;
  //         case Event.actionCallAccept:
  //           await callRef.doc(event.body['id']).update({'response': "Pickup"});
  //           await FlutterRingtonePlayer.stop();
  //           checkAndNavigationCallingPage(event.body['id'], event.body['number']!);
  //           break;
  //         case Event.actionCallDecline:
  //           await FlutterCallkitIncoming.endAllCalls();
  //           await callRef.doc(event.body['id']).update({'response': 'Decline'});

  //           debugPrint('decilne incoming dart------------------------------------');

  //           break;
  //         case Event.actionCallEnded:
  //           await callRef.doc(event.body['id']).update({'response': 'Not-answer'});
  //           await FlutterCallkitIncoming.endAllCalls();
  //           break;
  //         case Event.actionCallTimeout:
  //           await FlutterCallkitIncoming.endAllCalls();
  //           await callRef.doc(event.body['id']).update({'response': 'Not-answer'});

  //           debugPrint('decilne incoming dart------------------------------------');
  //           break;
  //         case Event.actionCallCallback:
  //           break;
  //         case Event.actionCallToggleHold:
  //           break;
  //         case Event.actionCallToggleMute:
  //           break;
  //         case Event.actionCallToggleDmtf:
  //           break;
  //         case Event.actionCallToggleGroup:
  //           break;
  //         case Event.actionCallToggleAudioSession:
  //           break;
  //         case Event.actionDidUpdateDevicePushTokenVoip:
  //           break;
  //         case Event.actionCallCustom:
  //           break;
  //       }
  //       if (callback != null) {
  //         callback(event.toString());
  //       }
  //     });
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  // checkAndNavigationCallingPage(String channelId, String callType) async {
  //   var currentCall = await getCurrentCall();
  //   if (currentCall != null) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => CallPage(
  //                   callType: callType,
  //                   channelName: channelId,
  //                   role: ClientRoleType.clientRoleBroadcaster,
  //                 )));
  //   }
  // }

  // onEvent(event) {
  //   if (!mounted) return;
  //   setState(() {
  //     textEvents += "${event.toString()}\n";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // debugPrint("user print ${userProvider.currentUser.toString()}");
    // FirebaseMessaging.instance.getToken().then((token) async {
    //   debugPrint('Device Token FCM: $token');
    //   await firebaseFireStoreInstance
    //       .collection('Users')
    //       .doc(userProvider.currentUser!.id)
    //       .update({'pushToken': token});
    //   if (!isPuchased) {
    //     await firebaseFireStoreInstance
    //         .collection('Users')
    //         .doc(userProvider.currentUser!.id)
    //         .update({'isPremium': false});
    //   }
    // });

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body:

            // TODO: Replace with blocked check
            false
                // userProvider.currentUser!.isBlocked!
                ? const BlockByAdmin()
                : DefaultTabController(
                    length: 5,
                    initialIndex: false
                        // chatdata.contains('notification')
                        ? 4
                        : widget.isPaymentSuccess != null
                            ? widget.isPaymentSuccess!
                                ? 0
                                : 4
                            : 4,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        automaticallyImplyLeading: false,
                        title: TabBar(
                            labelColor: themeProvider.isDarkMode
                                ? primaryColor
                                : Colors.white,
                            indicatorColor: themeProvider.isDarkMode
                                ? primaryColor
                                : Colors.white,
                            unselectedLabelColor: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: const [
                              Tab(
                                icon: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.whatshot,
                                ),
                              ),
                              Tab(icon: Icon(Icons.explore)),
                              Tab(
                                icon: Icon(
                                  Icons.notifications,
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.message,
                                ),
                              )
                            ]),
                      ),
                      body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Center(
                            child: ProfilePage(
                                isPurchased: isPuchased,
                                items: const {},
                                purchases: purchases),
                          ),
                          Center(
                              child: Homepage(
                            items: const {},
                            isPurchased: isPuchased,
                          )),
                          const Center(child: Text('Explore map')),
                          const Center(child: Text('Notifications page')),
                          const ConversationsScreen(),
                          // Center(
                          //     child: ExploreMapWidget(
                          //   isPuchased: isPuchased,
                          //   currentUser: userProvider.currentUser!,
                          // )),
                          // const Center(child: Notifications()),
                          // const Center(child: MatchScreen()),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
