import 'dart:convert';

import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionSharepreferences {
  SharedPreferences _refe;
  //********************  EMPIEZAN NOTIFICATIONS *****************************/
  getNotifications() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getInt('notifications') ?? 0;
  }

  Future<void> setNotifications(int notifications) async {
    _refe = await SharedPreferences.getInstance();
    int conteoNotifications = await getNotifications();
    if (conteoNotifications != 0) {
      await _refe.setInt('notifications', conteoNotifications + notifications);
    } else {
      await _refe.setInt('notifications', notifications);
    }
    //notifyListeners();
  }

  //********************  TERMINA NOTIFICATIONS   ************************/

  //********************  EMPIEZA EL MODO AGENTE O CUSTOMER *****************************/
  getModo() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getString('modo') ?? 'CUSTOMER';
  }

  Future<void> setModo(String modo) async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setString('modo', modo);
    //notifyListeners();
  }

  //********************  TERMINA ELMODO AGENTE O CUSTOMER  ************************/

  //********************  EMPIEZA EL SONIDO DE NOTIFICACIONES *****************************/
  getAudio() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getBool('audio') ?? false;
  }

  Future<void> setAudio(bool audio) async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setBool('audio', audio);
    //notifyListeners();
  }

  //********************  TERMINA EL SONIDO DE NOTIFICACIONES ************************/
  //********************  EMPIEZA EL TAKEREQUEST *****************************/
  getTake() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getBool('take') ?? false;
  }

  Future<void> setTake(bool take) async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setBool('take', take);
    //notifyListeners();
  }

  //********************  TERMINA EL TAKEREQUEST ************************/
  //******************** EMPIEZA GUARDANDO LATITUD Y LONGITUD *****************************/
  setLatitude(double latitude) async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.setDouble('latitude', latitude);
  }

  latitude() async {
    _refe = await SharedPreferences.getInstance();
    return _refe.getDouble('latitude');
  }

  setLongitude(double longitude) async {
    _refe = await SharedPreferences.getInstance();
    return _refe.setDouble('longitude', longitude);
  }

  longitude() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getDouble('longitude');
  }
  //********************  TERMINA GUARDANDO LATITUD Y LONGITUD ************************/

  //********************  EMPIEZA EL MODO OSCURO *****************************/
  setOscuro(bool oscuro) async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.setBool('oscuro', oscuro) ?? false;
  }
  //********************  TERMINA EL MODO OSCURO ************************/

  //********************  EMPIEZA EL USER *****************************/
  Future<ModelUser2> getUser() async {
    ModelUser2 userModel;
    _refe = await SharedPreferences.getInstance();
    String userString = await _refe.getString('USER') ?? null;
    if (userString != null) {
      userModel = ModelUser2.fromMap(jsonDecode(userString));
    }
    return userModel;
  }

  Future<ModelEstablecimientos> getEstablecimientos() async {
    ModelEstablecimientos modelEstable;
    _refe = await SharedPreferences.getInstance();
    String estableci = await _refe.getString('ESTABLECIMIENTOS') ?? null;
    if (estableci != null) {
      modelEstable = ModelEstablecimientos.fromMap(jsonDecode(estableci));
    }
    return modelEstable;
  }

  get user {
    return _refe.getString('USER') ?? null;
  }

  Future<void> setUser(ModelUser2 user) async {
    String userModelString = user.toJson();
    _refe = await SharedPreferences.getInstance();
    await _refe.setString('USER', userModelString);
  }

  Future<void> setEstablecimientos(
      ModelEstablecimientos establecimiento) async {
    String establecimientoModelString =
        modelEstablecimientosToMap(establecimiento);
    _refe = await SharedPreferences.getInstance();
    await _refe.setString('ESTABLECIMIENTOS', establecimientoModelString);
  }

  Future<void> logOut() async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setString('USER', '');
    await _refe.setString('ESTABLECIMIENTOS', '');
  }

  //********************  TERMINA EL USER *****************************/

  //********************  EMPIEZA ACTIVO *****************************//
  getActivo() async {
    _refe = await SharedPreferences.getInstance();
    return await _refe.getBool('activo') ?? false;
  }

  get activo {
    return _refe.getBool('activo') ?? false;
  }

  Future<void> setActivo(bool activo) async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setBool('activo', activo);
    // notifyListeners();
  }

  /********************  TERMINA EL ACTIVO *****************************/
  //********************  EMPIEZA SETTING *****************************//
  getSetting() async {
    _refe = await SharedPreferences.getInstance();
    return _refe.getString('clave') ?? 'dondelucho';
  }

  get setting {
    return _refe.getString('clave') ?? 'dondelucho';
  }

  Future<void> setSetting(String clave) async {
    _refe = await SharedPreferences.getInstance();
    await _refe.setString('clave', clave);
  }

  /********************  TERMINA EL SETTING *****************************/

}
