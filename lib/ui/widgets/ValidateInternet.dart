import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> validateIntenrnet() async {
  bool respuesta = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    respuesta = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    respuesta = true;
  } else if (connectivityResult == ConnectivityResult.ethernet) {
    respuesta = true;
  }
  return respuesta;
}
