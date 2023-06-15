import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app_theme.dart';
import '../../../../../session.dart';
import '../../../SettingSharepreferences.dart';

class UpdateUsers extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  const UpdateUsers({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _UpdateUsersState createState() => _UpdateUsersState();
}

class _UpdateUsersState extends State<UpdateUsers> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  StatusBloc statusBloc;

  ModelUser2 _userUpdate;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _direction = TextEditingController();
  TextEditingController _celular = TextEditingController();
  TextEditingController _idUser = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _loading = false;
  String sede = 'Seleccione sede';
  String codigo;
  ModelEstablecimientos establecimientos;
  ModelUser2 user;

  String rolSelect = 'Seleccione rol del usuario';
  List listRol = [
    'EMPLEADO',
    'PROVEEDOR',
    'CLIENTE',
    'ADMINISTRADOR',
    'SUPER ADMINISTRADOR'
  ];

  @override
  void initState() {
    super.initState();
    initSession();
  }

  initSession() async {
    user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    print(establecimientos.establecimientos[0].name);
    setState(() {
      establecimientos;
      user;
    });
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
      String status;
      if (rol == 'PROVEEDOR' || rol == 'CLIENT') {
        newUser = {
          'id': _idUser.text,
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
          statusBloc.globalKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          Navigator.pop(context);
          return;
        } else {
          newUser = {
            'id': _idUser.text,
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
        status = await ServicesServicesHTTP()
            .updateUsuario(user: newUser, uid: _userUpdate.uid);
        print(status);
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
        statusBloc.globalKey.currentState.showSnackBar(snac);
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
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Error al actualizar el usuario, si el problema persiste comunicarse con el administrador de sistemas GOLDEN SAS',
              textAlign: TextAlign.center,
            ),
          ),
        );
        statusBloc.globalKey.currentState.showSnackBar(snac);
        return;
      } else {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Usuario actualizado exitosamente',
              textAlign: TextAlign.center,
            ),
          ),
        );
        statusBloc.globalKey.currentState.showSnackBar(snac);
      }
      setState(() {
        _userUpdate = null;
      });
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

  designerRol2(String rol) {
    if (rol == 'EMPLOYEE') {
      return 'EMPLEADO';
    } else if (rol == 'PROVEEDOR') {
      return 'PROVEEDOR';
    } else if (rol == 'CLIENT') {
      return 'CLIENTE';
    } else if (rol == 'ADMIN') {
      return 'ADMINISTRADOR';
    } else if (rol == 'SUPERADMIN') {
      return 'SUPER ADMINISTRADOR';
    }
  }

  Future<void> buscarUser(String idUser) async {
    AlertWidget().alertProcesando(context);
    try {
      _userUpdate = await ServicesServicesHTTP().buscarUsuario(idUser: idUser);
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
      statusBloc.globalKey.currentState.showSnackBar(snac);
    }
    Navigator.pop(context);

    if (_userUpdate != null) {
      rolSelect = designerRol2(_userUpdate.rol);
      if (_userUpdate.sede != '') {
        for (var i = 0; i < establecimientos.establecimientos.length; i++) {
          if (establecimientos.establecimientos[i].codigo == _userUpdate.sede) {
            sede = establecimientos.establecimientos[i].name;
          }
        }
      }

      _name.text = _userUpdate.name;
      _email.text = _userUpdate.email;
      _direction.text = _userUpdate.direction;
      _celular.text = _userUpdate.cel;
      _idUser.text = _userUpdate.id;
      _password.text = _userUpdate.password;
      codigo = _userUpdate.sede;
      setState(() {
        rolSelect;
        _userUpdate;
        sede;
      });
    } else {
      setState(() {
        _userUpdate = null;
      });
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Usuario no encontrado, verifique número de identificación suministrado',
            textAlign: TextAlign.center,
          ),
        ),
      );
      statusBloc.globalKey.currentState.showSnackBar(snac);
    }
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);

    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Form(
              key:
                  _formKey, // asignamos una key al formulario creada globalmente en el constructor del widget
              child: SingleChildScrollView(
                  child: Center(child: _searchProduct()))),
        ],
      ),
    );
  }

  Widget _searchProduct() {
    return Container(
      // padding: EdgeInsets.all(10.0),
      // margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.45,
      //height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Text('Actualizar usuario', style: dondeluchoAppTheme.title),
          _buildProductosEncontrado()
        ],
      ),
    );
  }

  Widget _buildProductosEncontrado() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                onEditingComplete: () => buscarUser(_idUser.text),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo requerido:';
                  }

                  return null;
                },
                controller: _idUser,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.person, color: PRIMARY_COLOR),
                    hintText: 'Ingrese número de identificación del usuario',
                    labelText: 'Ingrese identificación'),
              ),
            ),
            IconButton(
                onPressed: () {
                  buscarUser(_idUser.text);
                },
                icon: Icon(
                  Icons.search_sharp,
                  size: 45,
                )),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Visibility(visible: _userUpdate != null, child: _buildForm()),
      ],
    );
  }

  Widget _buildForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: <Widget>[
            _rolUser(),
            Visibility(
                visible: rolSelect != 'Seleccione rol del usuario' &&
                        rolSelect == 'EMPLEADO' ||
                    rolSelect == 'ADMINISTRADOR' ||
                    rolSelect == 'SUPER ADMINISTRADOR',
                child: _listSedes()),
            _nameUser(),
            //_identification(),
            _emailUser(),
            _passwordUser(),
            _celUser(),
            _directionUser(),
            _btn(),
            SizedBox(
              height: 30,
            )
            // divider(),
          ],
        ),
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
                    onTap: () {
                      //print(element.ref.path);
                      // _categoryServices = element;
                    },
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

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: !_loading
            ? Text('Actualizar usuario')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () {
          validador();
        },
      ),
    );
  }

  Widget _identification() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }

          return null;
        },
        controller: _idUser,
        keyboardType: TextInputType.number,
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
        enabled: false,
        style: TextStyle(color: Colors.grey),
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }

          return null;
        },
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(Icons.email, color: PRIMARY_COLOR),
            hintText: 'Email user',
            labelText: 'Email user'),
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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.person, color: PRIMARY_COLOR),
            hintText: 'Nombre completo',
            labelText: 'Nombre completo'),
      ),
    );
  }

  Widget _passwordUser() {
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
        controller: _password,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            icon: Icon(Icons.password, color: PRIMARY_COLOR),
            hintText: 'Password',
            labelText: 'Password'),
      ),
    );
  }

  Widget _celUser() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        // key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (value.length < 10) {
            // se valida si el Email esta vacio
            return 'Número de celular debe contener 10 dígitos';
          }
          return null;
        },
        maxLength: 10,
        controller: _celular,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.phone, color: PRIMARY_COLOR),
            hintText: 'Número de celular',
            labelText: 'Número de celular'),
      ),
    );
  }

  Widget _directionUser() {
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
            hintText: 'Dirección',
            labelText: 'Dirección'),
      ),
    );
  }
}
