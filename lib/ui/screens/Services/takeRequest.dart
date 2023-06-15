//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';

TakeRequest(RequestModel r, ModelUser2 user) async {
  print(r.offer);
  double desc = r.offer * 0.1;
  print(desc.toString());
  // num amount = user.amount - desc.toInt();
  // print(amount);

  // Firestore firestore = Firestore.instance;
  // await firestore.collection('requests').document(r.uid).updateData({
  //   'isTaked': true,
  //   'agentId': user.uid,
  // });

  await Session().setUser(user);
  SharedPreferences _ref = await SharedPreferences.getInstance();
  _ref.setBool('take', true);
}

NoTakeRequest(RequestModel r, ModelUser2 user) async {
  // Firestore firestore = Firestore.instance;
  // await firestore.collection('requests').document(r.uid).setData({
  //   'active': false,
  //   'noTaked': true,
  //   'agentId': user.uid,
  // }, merge: true);
}
