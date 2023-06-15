// import 'dart:async';

// import 'dart:io';

// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:dondelucho/session.dart';
// //import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';

// import 'UserProvider.dart';
// import 'package:http/http.dart' as http;

// class PushNotificationProvider {
//  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   // final _firebaseMessengeKey =
//   //     "AAAAifvvaWc:APA91bEXikmLBFatuEYe5kCzM_WV7SrY2d7oQTJZVgzq2IAs9ocpF2RNqQGPrmCPtKXkU-fEWgtMVWqcKT_l1yKmq9hXe4X9talyTXPzhlGpzQyJ0mAhvm2ac8orRrk3_LWqeIp8iMAY";

//   final _notificationsStreamController =
//       StreamController<List<String>>.broadcast();

//   Stream<List<String>> get notifications =>
//       _notificationsStreamController.stream;

//   UserProvider userProvider = new UserProvider();

//   AudioPlayer audioPlayer = AudioPlayer();

//   final localPath = '';

//   // // add it to your class as a static member
//   //   AudioCache player = AudioCache();
//   // or as a local variable
//   final player = AudioCache();
//   Future<void> initNotifications2() async {
//     _firebaseMessaging.requestNotificationPermissions();
//     _firebaseMessaging.getToken().then((token) async {
//       print("**** TOKEN ***");
//       print(token);
//     });

//     _firebaseMessaging.configure(onMessage: (info) async {
//       print("**** onMessage 2 ***");

//       print(info);
//       var arg = 'no-data';
//       var uidRequest = 'no-uidRequest';
//       if (Platform.isAndroid) {
//         arg = info['data']['type'] ?? 'no-data';
//         uidRequest = info['data']['uidRequest'] ?? 'no-uidRequest';

//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       if (Platform.isIOS) {
//         arg = info['type'] ?? 'no-data';
//         uidRequest = info['uidRequest'] ?? 'no-uidRequest';
//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       _notificationsStreamController.sink.add([arg, uidRequest]);
//       // call this method when desired
//     }, onResume: (info) async {
//       print("**** onResume m1 ***");
//       print(info);
//       var arg = 'no-data';
//       var uidRequest = 'no-uidRequest';
//       if (Platform.isAndroid) {
//         arg = info['data']['type'] ?? 'no-data';
//         uidRequest = info['data']['uidRequest'] ?? 'no-uidRequest';

//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       if (Platform.isIOS) {
//         arg = info['type'] ?? 'no-data';
//         uidRequest = info['uidRequest'] ?? 'no-uidRequest';
//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       _notificationsStreamController.sink.add([arg, uidRequest]);
//     }, onLaunch: (info) async {
//       print("**** onLaunch ***");
//       print(info);
//       var arg = 'no-data';
//       var uidRequest = 'no-uidRequest';
//       if (Platform.isAndroid) {
//         arg = info['data']['type'] ?? 'no-data';
//         uidRequest = info['data']['uidRequest'] ?? 'no-uidRequest';

//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       if (Platform.isIOS) {
//         arg = info['type'] ?? 'no-data';
//         uidRequest = info['uidRequest'] ?? 'no-uidRequest';
//         if (!await SettingShareprefences().getAudio()) {
//           player.play('new_service.mp3');
//         }
//       }
//       _notificationsStreamController.sink.add([arg, uidRequest]);
//     });
//   }

//   Future<void> initNotifications(String _uid) async {
//     _firebaseMessaging.requestNotificationPermissions();

//     //_firebaseMessaging.subscribeToTopic('agents');

//     _firebaseMessaging.getToken().then((token) async {
//       print("**** TOKEN ***");
//       print(token);

//       await UserProvider().setUserToken(token, _uid);

//       _firebaseMessaging.configure(onMessage: (info) async {
//         print("**** onMessage ***");
//         print(info);
//         var arg = 'no-data';
//         if (Platform.isAndroid) {
//           arg = info['data']['route'] ?? 'no-data';
//         }
//         _notificationsStreamController.sink.add([arg]);
//         // call this method when desired
//         player.play('new_service.mp3');
//       }, onResume: (info) async {
//         print("**** onResume ***");
//         print(info);
//         player.play('new_service.mp3');
//       }, onLaunch: (info) async {
//         print("**** onLaunch ***");
//         print(info);
//         player.play('new_service.mp3');
//       });
//     });
//   }

//   dispose() {
//     _notificationsStreamController?.close();
//   }

//   // Future<Map<String, dynamic>> sendPushToken(String token, Map data) async {
//   //   final msgData = {
//   //     'to': token,
//   //     'notification': {'title': data['title'], 'body': data['body']},
//   //     'data': data['data']
//   //   };

//   //   print(msgData);

//   //   // final res = await http.post(
//   //   //   'https://fcm.googleapis.com/fcm/send',
//   //   //   body: json.encode(msgData),
//   //   //   headers: {
//   //   //     HttpHeaders.authorizationHeader: "key=$_firebaseMessengeKey",
//   //   //     HttpHeaders.contentTypeHeader: "application/json"
//   //   //   },
//   //   // );

//   //   // print(res.body);

//   //   // Map<String, dynamic> decodeRes = json.decode(res.body);
//   //   // print(decodeRes);
//   //   // return {'ok': true, 'msg':decodeRes};
//   // }
// }
