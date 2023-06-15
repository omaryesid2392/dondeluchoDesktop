import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';

import '../../../../../session.dart';
import '../../../SettingSharepreferences.dart';

class CreateNewUsers extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const CreateNewUsers({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _CreateNewUsersState createState() => _CreateNewUsersState();
}

class _CreateNewUsersState extends State<CreateNewUsers> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  List listRol = [
    'EMPLEADO',
    'PROVEEDOR',
    'CLIENTE',
    'ADMINISTRADOR',
    'SUPER ADMINISTRADOR'
  ];
  String rolSelect = 'Seleccione rol del usuario';

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _direction = TextEditingController();
  TextEditingController _celular = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _loading = false;
  String status;

  String sede = 'Seleccione sede';
  String codigo;
  ModelEstablecimientos establecimientos;
  ModelUser2 user;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    initSession();
  }

  initSession() async {
    user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    print(establecimientos.establecimientos[0].name);
    setState(() {});
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      setState(() {
        _loading = true;
      });
      String rol = designerRol(rolSelect);

      AlertWidget().alertProcesando(context);
      var newUser;
      if (rol == 'PROVEEDOR' || rol == 'CLIENT') {
        newUser = {
          'id': _id.text,
          'email': _email.text,
          'name': _name.text,
          'password': _password.text,
          'direction': _direction.text,
          'cel': _celular.text,
          'rol': rol,
        };
      } else if (rol == 'EMPLOYEE' || rol == 'ADMIN' || rol == 'SUPERADMIN') {
        if (sede == 'Seleccione sede') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Seleccione sede donde desea inscribir al usuario',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          return;
        } else {
          newUser = {
            'id': _id.text,
            'email': _email.text,
            'name': _name.text,
            'password': _password.text,
            'direction': _direction.text,
            'cel': _celular.text,
            'rol': rol,
            'uidEstablecimiento': establecimientos.uid,
            'sede': codigo,
          };
        }
      }
      try {
        status = await ServicesServicesHTTP().createUsuario(user: newUser);
      } catch (e) {
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
        setState(() {
          _loading = false;
        });
        Navigator.pop(context);

        return;
      }
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);

      if (status == 'Error') {
        await AlertWidget().aletProductSave(context, error: true);
        return;
      } else {
        await AlertWidget().aletProductSave(context);
      }
      _celular.text = '';
      _id.text = '';
      _name.text = '';
      _email.text = '';
      _direction.text = '';
      _password.text = '';
    } else {
      print('No es valido');
    }
  }

  designerRol(String rol) {
    if (rol == 'EMPLEADO') {
      return 'EMPLOYEE';
    } else if (rol == 'PROVEEDOR') {
      return 'PROVEEDOR';
    } else if (rol == 'CLIENTE') {
      return 'CLIENT';
    } else if (rol == 'ADMINISTRADOR') {
      return 'ADMIN';
    } else if (rol == 'SUPER ADMINISTRADOR') {
      return 'SUPERADMIN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Form(
              key:
                  _formKey, // asignamos una key al formulario creada globalmente en el constructor del widget
              child: SingleChildScrollView(child: _buildForm())),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            _rolUser(),
            Visibility(
                visible: rolSelect != 'Seleccione rol del usuario' &&
                        rolSelect == 'EMPLEADO' ||
                    rolSelect == 'ADMINISTRADOR' ||
                    rolSelect == 'SUPER ADMINISTRADOR',
                child: _listSedes()),
            _nameUser(),
            _idUser(),
            _emailUser(),
            _passwordUser(),
            _celularUser(),
            _direccionUser(),

            _btn(),
            SizedBox(
              height: 50,
            )
            // divider(),
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: !_loading
            ? Text('Guardar usuario')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: rolSelect == 'Seleccione rol del usuario'
            ? null
            : () {
                validador();
              },
      ),
    );
  }

  Widget _rolUser() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Icon(Icons.category, color: PRIMARY_COLOR),
          Text(
            '    ',
            style: TextStyle(
              fontSize: 15,
              color: PRIMARY_COLOR,
            ),
          ),
          SizedBox(
            height: 45.0,
            //margin: EdgeInsets.fromLTRB(5, 0, 5.0, 5.0),
            child: DropdownButton(
                //isExpanded: false,
                style: TextStyle(color: PRIMARY_COLOR),
                items: listRol.map((element) {
                  return DropdownMenuItem(
                    // onTap: () {

                    // },
                    value: element,
                    child: Text(element),
                  );
                }).toList(),
                hint: Text(
                  rolSelect,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onChanged: (dato) {
                  setState(() {
                    rolSelect = dato;
                  });
                }),
          ),
          //),
        ],
      ),
    );
  }

  Widget _listSedes() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Icon(Icons.category_outlined, color: PRIMARY_COLOR),
          Text(
            '    ',
            style: TextStyle(
              fontSize: 15,
              color: PRIMARY_COLOR,
            ),
          ),
          SizedBox(
            height: 45.0,
            child: establecimientos == null
                ? Text('')
                : DropdownButton(
                    style: TextStyle(color: PRIMARY_COLOR),
                    items: establecimientos.establecimientos
                        .map((Establecimiento element) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            sede = element.name;
                            codigo = element.codigo;
                          });
                        },
                        value: element.name,
                        child: Text(element.name),
                      );
                    }).toList(),
                    hint: Text(
                      sede,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onChanged: (dato) {
                      // setState(() {
                      //   sede = dato;
                      // });
                    }),
          ),
          //),
        ],
      ),
    );
  }

  Widget _idUser() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          } else if (value.length > 12) {
            return 'Verifique el número de identificación';
          }
          return null;
        },
        controller: _id,
        keyboardType: TextInputType.number,
        // maxLength: 10,
        decoration: InputDecoration(
            icon: Icon(Icons.person, color: PRIMARY_COLOR),
            hintText: 'Número de identificación',
            labelText: 'Número de identificación'),
      ),
    );
  }

  Widget _emailUser() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (!RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
              .hasMatch(value)) {
            return 'Correo electrónico no válido.';
          }

          return null;
        },
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: PRIMARY_COLOR),
            hintText: 'Email',
            labelText: 'Ingrese email'),
      ),
    );
  }

  Widget _passwordUser() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (value.length < 6) {
            return 'Contraseńa debe tener mínimo 6 caracteres';
          }

          return null;
        },
        controller: _password,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            icon: Icon(Icons.password, color: PRIMARY_COLOR),
            hintText: 'Password',
            labelText: 'Password'),
      ),
    );
  }

  Widget _nameUser() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }

          return null;
        },
        controller: _name,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.person, color: PRIMARY_COLOR),
            hintText: 'Nombre completo',
            labelText: 'Nombre completo'),
      ),
    );
  }

  Widget _celularUser() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (value.length < 10) {
            return 'Debe contener 10 caracteres';
          }

          return null;
        },
        controller: _celular,
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
            icon: Icon(Icons.phone_android, color: PRIMARY_COLOR),
            hintText: 'Número de celular',
            labelText: 'Número de celular'),
      ),
    );
  }

  Widget _direccionUser() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        // key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }
          return null;
        },
        controller: _direction,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.location_on, color: PRIMARY_COLOR),
            hintText: 'Dirección residencial del usuario',
            labelText: 'Dirección residencial del usuario'),
      ),
    );
  }
}
