import 'package:dondelucho/providers/UserProvider.dart';
import 'package:dondelucho/ui/widgets/DialogResetPassword.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/ui/widgets/backgrounds.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //final userProvider = new UserProvider();
  final _formKey = GlobalKey<FormState>();

  //GlobalKey _keyInputName = new GlobalKey();
  final _controllerId = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  bool loading = false;
  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      print('Valido');
      final name = _controllerName.text;
      final email = _controllerEmail.text;
      final password = _controllerPassword.text;
      num id = num.parse(_controllerId.text);

      // await userProvider
      //     .registroEmail(email, password, name, id)
      //     .then(
      //       (value) => {
      //         // si todo sale bien en el registro muestre el mensaje y cambie de pantalla

      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             content: Text('Usuario Registrado Exitosamente',
      //                 textAlign: TextAlign.center),
      //           ),
      //         ),
      //         Navigator.pushReplacementNamed(context, 'NavbarEmploeePage'),
      //       },
      //     )
      //     .catchError((onError) {
      //   setState(() {
      //     loading = false;
      //   });
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           title: Text("Información incorrecta"),
      //           content: Text('Usuario existente o error de conexión'),
      //           actions: <Widget>[
      //             FlatButton(
      //               child: Text('Ok'),
      //               onPressed: () => Navigator.of(context).pop(),
      //             )
      //           ],
      //         );
      //       });
      // });
    } else {
      setState(() {
        loading = false;
      });
      print('No Valido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[widgetBackground_1(), _logo(), _buildForm()],
      ),
    ));
  }

  Widget _logo() {
    return Positioned(
        top: 100.0,
        child:
            Image(width: 230.0, image: AssetImage('assets/images/logo.png')));
  }

  Widget _buildForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(top: 200.0),
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildInputName(),
              _buildInputId(),
              _buildInputEmail(),
              _buildInputPassword(),
              _buildForgotPassword(),
              _buildButtonSignUp(),
              _buildDontHaveAccount()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          if (value.length < 5) {
            return 'Faltan Caracteres:';
          }
          return null;
        },
        controller: _controllerName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.person_outline, color: PRIMARY_COLOR),
            hintText: 'Ingrerse su nombre',
            labelText: 'Nombre Completo'),
      ),
    );
  }

  Widget _buildInputId() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        //key: _keyInputName,
        maxLength: 10,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          if (value.length < 5) {
            return 'Debe contener más de 5 caracteres:';
          }
          return null;
        },
        controller: _controllerId,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.person_search_sharp, color: PRIMARY_COLOR),
            hintText: '1051003......',
            labelText: 'Ingrese su identificación'),
      ),
    );
  }

  Widget _buildInputEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        //key: _keyInputEmail,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          return null;
        },
        controller: _controllerEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: PRIMARY_COLOR),
            hintText: 'ejemplo@gmail.com',
            labelText: 'E-mail'),
      ),
    );
  }

  Widget _buildInputPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        // key: _keyInputPassword,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          return null;
        },
        controller: _controllerPassword,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            icon: Icon(Icons.lock, color: PRIMARY_COLOR),
            hintText: '',
            labelText: 'Contraseña'),
      ),
    );
  }

  Widget _buildButtonSignUp() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        child: loading == false
            ? Text('Crear cuenta')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          validador();

          // if (info['ok'] == true) {
          //   Navigator.pushReplacementNamed(context, 'NavbarCustomerPage');
          // } else {
          //   showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           title: Text("Información incorrecta"),
          //           content: Text(info['msg']),
          //           actions: <Widget>[
          //             FlatButton(
          //               child: Text('Ok'),
          //               onPressed: () => Navigator.of(context).pop(),
          //             )
          //           ],
          //         );
          //       });
          // }

          //Navigator.pushReplacementNamed(context, 'HomePage');
        },
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: InkWell(
        child: Text(
          "¿Olvidé mi contraseña?",
          style: TextStyle(
              fontSize: 12.0,
              color: PRIMARY_COLOR,
              fontFamily: 'Helvetica Light'),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogResetPassword();
              });
        },
      ),
    );
  }

  Widget _buildDontHaveAccount() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30.0),
      child: Wrap(
        children: <Widget>[
          Text('Ya tengo cuento.'),
          InkWell(
            child: SizedBox(
              height: 20.0,
              child:
                  Text("Autenticarse", style: TextStyle(color: PRIMARY_COLOR)),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'LoginPage');
            },
          ),
        ],
      ),
    );
  }
}
