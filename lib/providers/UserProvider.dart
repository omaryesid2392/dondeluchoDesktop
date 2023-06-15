// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:dondelucho/blocs/UserBloc.dart';
// import 'package:dondelucho/models/user_model.dart';
// import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
// import 'package:dondelucho/providers/PushNotificationProvider.dart';
// import 'package:dondelucho/session.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:dondelucho/pref_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Firestore _db = Firestore.instance;

//   Stream<FirebaseUser> streamFirebase =
//       FirebaseAuth.instance.onAuthStateChanged;
//   Stream<FirebaseUser> get authStatus => streamFirebase;

//   String _rol;
//   String _token = '';
//   String _uid;

//   // SettingShareprefences rols;

//   UserModel _user;

//   get rol => _rol;
//   get token => _token;
//   get uid => _uid;
//   UserModel get user => _user;

//   set setRol(String rol) {
//     _rol = rol;
//     notifyListeners();
//   }

//   set setToken(String token) {
//     _token = token;
//     notifyListeners();
//   }

//   set setUID(String uid) {
//     _uid = uid;
//     notifyListeners();
//   }

//   setUser(UserModel user) {
//     _user = user;
//     notifyListeners();
//   }

//   @override
//   void dispose() {}

//   void logOut() {
//     _auth.signOut();
//     notifyListeners();
//   }

//   Future<UserModel> loginUser({String email, String password}) async {
//     try {
//       AuthResult res = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseUser user = res.user;
//       DocumentReference ref = _db.collection('users').document(user.uid);
//       DocumentSnapshot dataUser = await ref.get();
//       UserModel users = UserModel.fromSnapshot(dataUser);

//       if (user != null) {
//         await updateUserData(dataUser);
//       }

//       return users;
//     } catch (e) {
//       print(" ########################################## ");

//       print("Ingrersó al error:  $e");
//       return null;
//       //throw new AuthException(e.code, e.message);
//     }
//   }

//   //************COMIENZA LA INSTANCIA DE REGISTRO POR EMAIL*****************/
//   Future<FirebaseUser> registroEmail(
//       String email, String password, String name, num id) async {
//     AuthResult userCredencial;
//     FirebaseUser
//         user; // se crea el usuario que va a recibir los datos para ser guardados al firestore

//     // try {
//     userCredencial = await _auth.createUserWithEmailAndPassword(
//         email: email.toString().trim(), password: password);

//     user = userCredencial.user;
//     //_status = AuthStatus.Authenticated;
//     //notifyListeners();
//     DocumentReference userRef = _db
//         .collection('users')
//         .document(user.uid); // se reciben el id del usuario
//     final iDdocumento =
//         userRef.documentID; // se obtiene el id de la coleccion de ese usuario

//     userRef.setData(
//       {
//         // se setean los datos o actualizan los datos en caso que se haya cambiado alguno como la foto de perfil, etc.

//         'id': id,
//         'uid': user.uid,
//         'email': email,
//         'lastSign': DateTime.now(),
//         'photoURL': user.photoUrl,
//         'displayName': name,
//         'rol': 'EMPLOYEE'
//       },
//     );
//     DocumentReference ref = _db.collection('users').document(iDdocumento);
//     DocumentSnapshot dataUser = await ref.get();
//     if (dataUser.exists) {
//       final user = UserModel.fromSnapshot(dataUser);
//       await Session().setUserId(dataUser.data['id'].toString());
//       await Session()
//           .setFechaNacimiento(dataUser.data['fechaNacimiento'].toString());
//       await Session().setUser(user);
//       this.setUser(user);
//       await PushNotificationProvider().initNotifications(user.uid);
//       //
//     }
//   }

// //************TERMINA LA INSTANCIA REGISTRO  CON EMAIL*****************/

//   Future updateUserData(DocumentSnapshot dataUser) async {
//     UserModel user;

//     if (dataUser.exists) {
//       user = UserModel.fromSnapshot(dataUser);
//       await Session().setUserId(dataUser.data['id'].toString());
//       await Session().setUser(user);
//       this.setUser(user);
//       await PushNotificationProvider().initNotifications(user.uid);
//       //

//     }
//   }

//   Future<void> setUserToken(String token, String uid) async {
//     await Session().setTokenFCM(token);
//     await _db.collection('users').document(uid).updateData({'tokenFCM': token});
//   }

//   void signOut() {
//     _auth.signOut();
//   }

//   Future<Void> getProfile() async {
//     PrefUser _prefUser = new PrefUser();

//     final ref = await _db.collection('users').document(_prefUser.uid).get();

//     print(ref.data['rol']);
//     _prefUser.rol = ref.data['rol'].toString();

//     this.setRol = ref.data['rol'].toString();

//     notifyListeners();
//   }

//   final _firebaseKey = "AIzaSyCj2kH4gpK78KFH6V9SD8HtU1iRSVXVbBs";

//   final _pref = new PrefUser();

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final authData = {
//       'email': email,
//       'password': password,
//       'returnSecureToken': true
//     };

//     final res = await http.post(
//         'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
//         body: json.encode(authData));

//     Map<String, dynamic> decodeRes = json.decode(res.body);

//     print(decodeRes);
//     if (decodeRes.containsKey('idToken')) {
//       _pref.token = decodeRes['idToken'];
//       _pref.displayName = decodeRes['displayName'];
//       _pref.uid = decodeRes['localId'];
//       return {'ok': true, 'token': decodeRes['idToken']};
//     } else {
//       return {'ok': false, 'msg': decodeRes['error']['message']};
//     }
//   }

//   Future<Map<String, dynamic>> newUser(
//       String name, String email, String password) async {
//     final authData = {
//       'displayName': name,
//       'email': email,
//       'password': password,
//       'returnSecureToken': true
//     };

//     final res = await http.post(
//         'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
//         body: json.encode(authData));

//     Map<String, dynamic> decodeRes = json.decode(res.body);

//     print(decodeRes);
//     if (decodeRes.containsKey('idToken')) {
//       _pref.token = decodeRes['idToken'];
//       _pref.displayName = decodeRes['displayName'];
//       _pref.uid = decodeRes['localId'];

//       DocumentReference ref =
//           _db.collection('users').document(decodeRes['localId']);

//       ref.setData({'rol': 'customer'});

//       return {'ok': true, 'token': decodeRes['idToken']};
//     } else {
//       return {'ok': false, 'msg': decodeRes['error']['message']};
//     }
//   }

//   Future<Map<String, dynamic>> resetPassword(String email) async {
//     try {
//       _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       print(e);
//     }

//     // final resetData = {'requestType': "PASSWORD_RESET", 'email': email};

//     // final res = await http.post(
//     //     'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_firebaseKey',
//     //     body: json.encode(resetData));

//     // Map<String, dynamic> decodeRes = json.decode(res.body);

//     // if (decodeRes.containsKey('email')) {
//     //   _pref.token = decodeRes['idToken'];
//     //   _pref.displayName = decodeRes['displayName'];
//     //   return {'ok': true, 'token': decodeRes['idToken']};
//     // } else {
//     //   return {'ok': false, 'msg': decodeRes['error']['message']};
//     // }
//   }

//   Future<Map<String, dynamic>> lookUser(String idToken) async {
//     final lookData = {'idToken': idToken};

//     final res = await http.post(
//         'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_firebaseKey',
//         body: json.encode(lookData));

//     Map<String, dynamic> decodeRes = json.decode(res.body);

//     print(decodeRes);
//     if (decodeRes.containsKey('email')) {
//       _pref.token = decodeRes['idToken'];
//       _pref.displayName = decodeRes['displayName'];
//       return {'ok': true, 'token': decodeRes['idToken']};
//     } else {
//       return {'ok': false, 'msg': decodeRes['error']['message']};
//     }
//   }
// }
