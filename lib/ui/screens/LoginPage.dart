import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/providers/UserProvider.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/DialogResetPassword.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/ui/widgets/backgrounds.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  String _password;
  String _email;

  bool _loading = false;

  StatusBloc statusBloc;

  // final _controllerEmail = TextEditingController();
  // final _controllerPassword = TextEditingController();

  // UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            widgetBackground(),
            _logo(),
            //_buildTitle(),
            _buildForm(),
            Positioned(
                top: 40.0,
                left: 10.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'IntroPage');
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                )
                // child: Text('Regresar', style: TextStyle(color:Colors.white, fontSize: 9.0),))
                ),
          ],
        ));
  }

  Widget _logo() {
    return Positioned(
        top: 130.0,
        child:
            Image(width: 230.0, image: AssetImage('assets/images/logo.png')));
  }

  // Widget _buildTitle(){
  //   return Text("Bienvenidos nuevamente", style: TextStyle(fontSize: 22.0),);
  // }

  Widget _buildForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.only(top: 200.0),
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildInputEmail(),
              _buildInputPassword(),
              _buildForgotPassword(),
              _buildButtonSignIn(context),
              _buildDontHaveAccount()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        //controller: _controllerEmail,
        onSaved: (value) => _email = value,
        validator: (value) =>
            value.contains("@") ? null : 'Ingrese un email valido',
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
        //controller: _controllerPassword,
        onSaved: (value) => _password = value,
        validator: (value) =>
            value.length < 6 ? 'Debe ser mayor a 6 caracteres' : null,
        keyboardType: TextInputType.text,
        obscureText: _obscureText,
        decoration: InputDecoration(
            icon: Icon(Icons.lock, color: PRIMARY_COLOR),
            hintText: '',
            labelText: 'Contraseña',
            suffixIcon: IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                })),
      ),
    );
  }

  Widget _buildButtonSignIn(context) {
    // StatusBloc statusBloc = Provider.of<StatusBloc>(context);

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        child: !_loading
            ? Text('Ingresar')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () async {
          final form = _formKey.currentState;
          form.save();

          if (form.validate()) {
            setState(() {
              _loading = true;
            });

            // await Future.delayed(Duration(seconds: 3));
            var credenciales = {'email': _email, 'password': _password};
            try {
              ModelUser2 user = await ServicesServicesHTTP()
                  .login(credenciales: credenciales);
              print(user.rol);
              //if (this.mounted) {
              setState(() {
                _loading = false;
              });
              //}
              print('Usuario .......' + user.toString());
              if (user == null) {
                print("Error de autenticación");
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error de Autenticación"),
                        content: Text(
                          "Por favor verifique la información ingresada.\n o vefique conexión a internet.",
                          style: TextStyle(fontSize: 12.0),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: Text('OK'),
                          )
                        ],
                      );
                    });
              } else {
                print(user.rol);
                statusBloc.setRol = user.rol;
                Navigator.pushReplacementNamed(context, 'NavbarEmployeePage');
              }
            } catch (e) {
              setState(() {
                _loading = false;
              });
              SnackBar snac = SnackBar(
                content: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              _scaffoldKey.currentState.showSnackBar(snac);
            }
          } else {
            print("Campos requeridos!");
          }
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
          Text('Aún no tengo cuenta.'),
          InkWell(
            child: Text("Registrarse", style: TextStyle(color: PRIMARY_COLOR)),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'RegisterPage');
            },
          ),
        ],
      ),
    );
  }
}
