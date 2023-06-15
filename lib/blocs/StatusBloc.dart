
import 'package:flutter/material.dart';

class StatusBloc extends ChangeNotifier {
  bool _status = false;
  String _rol = 'EMPLOYEE';
  bool _sonido = false;
  bool _oscuro = false;
  bool _take = false;
  double _latitude;
  double _longitude;
  double _distance;
  String _modo;
  int _currentIndex;
  dynamic _location;
  String _request;
  bool _ventaRealizada = false;
  int _localNotification = 0;
  bool _uidRequest;
  GlobalKey<ScaffoldState> _globalKey;
  BuildContext _context;
  int _notifications = 0;

  dynamic get isLocation => _location;
  double get isDistance => _distance;
  double get isLatitude => _latitude;
  double get isLongitude => _longitude;
  bool get isOscuro => _oscuro;
  bool get take => _take;
  bool get getSonido => _sonido;
  bool get isActive => _status;
  String get rol => _rol;
  String get modo => _modo;
  String get request => _request;
  int get currentIndex => _currentIndex;
  bool get ventaRealizada => _ventaRealizada;
  int get localNotification => _localNotification;
  bool get uidRequest => _uidRequest;
  GlobalKey<ScaffoldState> get globalKey => _globalKey;
  BuildContext get contexto => _context;
  int get notifications => _notifications;

  set setNotifications(int notifications) {
    _notifications = _notifications + notifications;
    notifyListeners();
  }

  set setContext(BuildContext context) {
    _context = context;
    //notifyListeners();
  }

  set setUidRequest(bool uidRequest) {
    _uidRequest = uidRequest;
    notifyListeners();
  }

  set setGlobalKey(GlobalKey<ScaffoldState> globalKey) {
    _globalKey = globalKey;
    // notifyListeners();
  }

  set setLocalNotification(int localNotification) {
    _localNotification = localNotification;
    notifyListeners();
  }

  set setDistance(double distance) {
    _distance = distance;
    notifyListeners();
  }

  set setVentaRealizada(bool ventaRealizada) {
    _ventaRealizada = ventaRealizada;
    notifyListeners();
  }

  set setRequest(String request) {
    _request = request;
    notifyListeners();
  }

  set setTake(bool take) {
    _take = take;
    notifyListeners();
  }

  set setCurrentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  set setLocation(dynamic location) {
    _location = location;
    notifyListeners();
  }

  set setLatitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set setLongitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  set setOscuro(bool oscuro) {
    _oscuro = oscuro;
    notifyListeners();
  }

  set setSonido(bool sonido) {
    _sonido = sonido;
    notifyListeners();
  }

  set setStatus(bool status) {
    _status = status;
    notifyListeners();
  }

  set setRol(String rol) {
    _rol = rol;
    notifyListeners();
  }

  set setModo(String modo) {
    _modo = modo;
    notifyListeners();
  }

  inactive() {
    _status = false;
  }

  activate() {
    _status = true;
  }

  inactiveSonido() {
    _sonido = false;
  }

  activateSonido() {
    _sonido = true;
  }
}
