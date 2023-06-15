import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:flutter/material.dart';

class CalculateItems {
  cacularAmount(ModelUser2 user, RequestModel r) async {
    // int amount = user.amount;
    int vdescontar = await (r.offer * 0.1).toInt();
    print(vdescontar);
    print('#############');
    //print(amount.toString());

    return true;
  }

  calcularEdad(DateTime fecha) {
    var edad;
    var fechaActual = DateTime.now().year;
    edad = fechaActual - fecha.year;
    print("Tu edad es $edad");

    return edad;
  }
}
