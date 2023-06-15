import 'package:dondelucho/constant.dart';
import 'package:dondelucho/providers/UserProvider.dart';
import 'package:flutter/material.dart';

class DialogResetPassword extends StatefulWidget {
  const DialogResetPassword({Key key}) : super(key: key);

  @override
  _DialogResetPasswordState createState() => _DialogResetPasswordState();
}

class _DialogResetPasswordState extends State<DialogResetPassword> {
  bool _emailSended = false;

  @override
  Widget build(BuildContext context) {
    final _controllerEmail = new TextEditingController();
    // final userPovider = new UserProvider();

    return AlertDialog(
      title: Text(
        "Olvidé mi contraseña",
        style: TextStyle(fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _emailSended == false
              ? TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                      hintText: "Ej. ejemplo@gmail.com",
                      labelText: "Ingrese email"))
              : Text(
                  "Se ha enviado un correo electrónico para recuperación de contraseña, favor revisar correos no deseados y siga las instrucciones.",
                  style: TextStyle(color: PRIMARY_COLOR, fontSize: 14.0),
                  textAlign: TextAlign.center,
                )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            _emailSended ? "OK" : "Cancelar",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        !_emailSended
            ? FlatButton(
                child: Text("Reestablecer Contraseña",
                    style: TextStyle(color: PRIMARY_COLOR)),
                onPressed: () async {
                  print(_controllerEmail.text);

                  if (_controllerEmail.text != '') {
                    // Map info =
                    // await userPovider.resetPassword(_controllerEmail.text);
                    setState(() {
                      _emailSended = true;
                    });
                    _controllerEmail.text = '';

                    // if (info['ok']) {
                    //   setState(() {
                    //     _emailSended = true;
                    //   });
                    //   _controllerEmail.text = '';
                    // } else {
                    //   print("Error. " + info['msg']);
                    // }
                    await Future.delayed(Duration(seconds: 4));
                    Navigator.pop(context);
                  }
                },
              )
            : Container()
      ],
    );
  }
}
