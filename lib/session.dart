import 'dart:convert';
import 'dart:developer';

import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/user_model.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  // Create storage
  var storage = new FlutterSecureStorage(mOptions: MacOsOptions.defaultOptions);

  /*************** ID USER **************** */
  setUserId(String id) async {
    // print(activo.toJson());
    await storage.write(key: 'id', value: id);
  }

  getUserId() async {
    final id = await storage.read(key: 'id');
    if (id == null) return null;
    return id;
  }

  /****************TERMINA ID USER****************/
  /*************** FECHA NACIMIENTO **************** */
  setFechaNacimiento(String fecha) async {
    await storage.write(key: 'fecha', value: fecha);
  }

  getFechaNacimiento() async {
    final fecha = await storage.read(key: 'fecha');
    if (fecha == null) return null;
    return fecha;
  }
  /****************TERMINA FECHA NACIMIENTO****************/

  setUser(ModelUser2 user) async {
    String use = user.toJson();
    log(use);
    print(jsonEncode(use));
    try {
      await storage.write(key: 'USER', value: use);
    } catch (e) {
      print(e);
    }
  }

  Future<ModelUser2> getUser() async {
    var res;
    ModelUser2 user;
    try {
      print('object');
      res = await storage.read(key: 'USER');

      print(res);
      final result = jsonDecode(res);
      print(result);
      if (result == null) return null;
      dynamic use = jsonDecode(res);

      user = ModelUser2.fromMap(use);
      print(user.rol);
    } catch (e) {
      print(e);
    }
    return user;
  }

  setEstablecimientos(ModelEstablecimientos establecimiento) async {
    String esta = modelEstablecimientosToMap(establecimiento);
    log(esta);
    print(esta);
    try {
      await storage.write(key: 'ESTABLECIMIENTO', value: esta);
    } catch (e) {
      print(e);
    }
  }

  Future<ModelEstablecimientos> getEstablecimientos() async {
    ModelEstablecimientos modelEstable;
    var res;
    try {
      res = await storage.read(key: 'ESTABLECIMIENTO');
      print(res);
      if (res == null) return null;
      modelEstable = ModelEstablecimientos.fromMap(jsonDecode(res));
      print(modelEstable);
    } catch (e) {
      print(e);
    }
    return modelEstable;
  }

  // Token for Notification

  setTokenFCM(String token) async {
    await storage.write(key: 'TOKEN_FCM', value: jsonEncode(token));
  }

  Future<String> getTokenFCM() async {
    final res = await storage.read(key: 'TOKEN_FCM');
    return jsonDecode(res);
  }

  // Token for Notification
  logOut() async {
    // await FirebaseAuth.instance.signOut();
    await storage.delete(key: 'USER');
    await storage.delete(key: 'ESTABLECIMIENTO');
  }
}
