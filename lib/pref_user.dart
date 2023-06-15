import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefUser {
  static final PrefUser _instance = new PrefUser._internal();

  factory PrefUser() {
    return _instance;
  }

  PrefUser._internal();

  SharedPreferences _pref;

  intPref() async {
    this._pref = await SharedPreferences.getInstance();
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getString('tokenPush') ?? '';
  }

  Future<String> getRol() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getString('rol') ?? '';
  }

  Future<String> setRol(String rol) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('rol', rol);
  }

  get token {
    return _pref.getString('tokenPush') ?? null;
  }

  set token(String token) {
    _pref.setString('tokenPush', token);
  }

  set displayName(String displayName) {
    _pref.setString('displayName', displayName);
  }

  set uid(String uid) {
    _pref.setString('uid', uid);
  }

  set service(String service) {
    _pref.setString('service', service);
  }

  get user {
    return _pref.getString('user');
  }

  get service {
    return _pref.getString('service');
  }

  get rol {
    return _pref.getString('rol');
  }

  set rol(String data) {
    _pref.setString('rol', data);
  }

  get displayName {
    return _pref.getString('displayName') ?? '';
  }

  get uid {
    return _pref.getString('uid');
  }

  Future<bool> hasToken() async {
    print('ingrese al has token');
    return _pref.getString('token') != null ? false : true;
  }

  set user(Map user) {
    String userData = json.encode(user);
    print(userData);
    _pref.setString('user', userData.toString());
  }
}
