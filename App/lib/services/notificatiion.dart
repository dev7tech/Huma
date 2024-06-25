// ignore_for_file: use_build_context_synchronously
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class NotificationData {
  // static final firebaseInstance = FirebaseMessaging.instance;
  static Future<void> showCallkitIncoming(
      String channelId, String name, String avatar, String? callType) async {
    final params = CallKitParams(
      id: channelId,
      nameCaller: name,
      appName: 'Hookup4u2',
      avatar: avatar,
      handle: callType,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#FF3A5A',
        actionColor: '#4CAF50',
      ),
      // ios: const IOSParams(
      //   iconName: 'CallKitLogo',
      //   handleType: 'generic',
      //   supportsVideo: true,
      //   maximumCallGroups: 2,
      //   maximumCallsPerCallGroup: 1,
      //   audioSessionMode: 'default',
      //   audioSessionActive: true,
      //   audioSessionPreferredSampleRate: 44100.0,
      //   audioSessionPreferredIOBufferDuration: 0.005,
      //   supportsDTMF: true,
      //   supportsHolding: true,
      //   supportsGrouping: false,
      //   supportsUngrouping: false,
      //   ringtonePath: 'system_ringtone_default',
      // ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static checkcallState(channelId) async {
    // // bool iscalling = await firebaseFireStoreInstance
    // //     .collection("calls")
    // //     .doc(channelId)
    // //     .get()
    // //     .then((value) {
    //   return value.data()!["calling"] ?? false;
    // });
    // return iscalling;
    return false;
  }
}
