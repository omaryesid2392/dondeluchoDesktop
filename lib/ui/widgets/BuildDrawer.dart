import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/HomeGestionFacturas.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/HomeGestionEstablecimientos.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/HomeGestionUsuarios.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/HomePageCategory.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/HomeProducto.dart';
import 'package:dondelucho/ui/screens/Profiles/EditProfiles.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dondelucho/constant.dart';
import 'package:provider/provider.dart';

import '../../session.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer({Key key}) : super(key: key);

  @override
  _BuildDrawerState createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  bool isActive = false;

  bool isAgent = false;

  ModelUser2 _user;
  StatusBloc _statusBloc;

  String _rol;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initSesion();
  }

  initSesion() async {
    _user = await SessionSharepreferences().getUser();
    _statusBloc.setRol = _user?.rol;
    print(_user.rol);
    print(_user.name);
    setState(() {
      _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _userProvider = Provider.of<UserProvider>(context);
    _statusBloc = Provider.of<StatusBloc>(context);

    _rol = _statusBloc.rol;
    // setState(() {});

    return Stack(
      children: [
        Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(_user?.name ?? ''),
                accountEmail:
                    Text(_rol != 'EMPLOYEE' ? 'Administrador' : 'Empleado'),
                //accountEmail: Text('Super Administrador'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _user?.name == null
                        ? "XX"
                        : _user.name.substring(0, 2).toUpperCase(),
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                  maxRadius: 30.0,
                ),
              ),

              Visibility(
                visible: _rol == 'EMPLOYEE',
                child: ListTile(
                    title: Text("Gestionar Perfil"),
                    leading: Icon(
                      Icons.person,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    }),
              ),

              // Agentes

              // Visibility(
              //   visible: _rol != 'EMPLOYEE',
              //   child: ListTile(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => Setting()),
              //         );
              //       },
              //       title: Text("Configuraciones"),
              //       leading: Icon(Icons.settings)),
              // ),
              Visibility(
                visible: _rol == 'SUPERADMIN',
                child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeGestionUsuarios()),
                      );
                    },
                    title: Text("Gestion de usuarios"),
                    leading: Icon(Icons.person_add_alt_sharp)),
              ),
              Visibility(
                visible: _rol == 'SUPERADMIN',
                child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeGestionEstablecimientos()),
                      );
                    },
                    title: Text("Gestion de establecimientos"),
                    leading: Icon(Icons.home_work)),
              ),
              Visibility(
                visible: _rol == 'SUPERADMIN',
                child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeGestionFacturas()),
                      );
                    },
                    title: Text("Gestion de facturas"),
                    leading: Icon(Icons.upload_file)),
              ),
              Visibility(
                visible: _rol != 'EMPLOYEE',
                child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeProducto()),
                      );
                    },
                    title: Text("Gestion de productos"),
                    leading: Icon(Icons.add_shopping_cart)),
              ),
              Visibility(
                visible: _rol != 'EMPLOYEE',
                child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePageCategory()),
                      );
                    },
                    title: Text("Gestion de categorias"),
                    leading: Icon(Icons.category)),
              ),

              Divider(),
              ListTile(
                title: Text("Centro de Ayuda"),
                leading: Icon(Icons.help_outline),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => null),
                  // );
                },
              ),
              // Visibility(
              //   visible: _rol == 'ADMIN',
              //   child: ListTile(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => TerminosCondicionesAgent()),
              //       );
              //     },
              //     title: Text("Términos y condiciones"),
              //     leading: Icon(Icons.info_outline),
              //   ),
              // ),
              // Visibility(
              //   visible: _rol == 'EMPLOYEE',
              //   child: ListTile(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => TerminosCondicionesCustomer()),
              //       );
              //     },
              //     title: Text("Términos y condiciones"),
              //     leading: Icon(Icons.info_outline),
              //   ),
              // ),
              Divider(),
              ListTile(
                title: Text("Cerrar Sesión"),
                leading: Icon(Icons.exit_to_app),
                onTap: () async {
                  await SessionSharepreferences().logOut();
                  Navigator.pushReplacementNamed(context, 'LoginPage');
                },
              ),
              Divider(),
            ],
          ),
        ),
        Positioned(
          height: 120,
          right: 5,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel_outlined,
              size: 40,
              color: Colors.white,
            ),
            iconSize: 50,
            //color: Colors.blue,
          ),
        ),
      ],
    );
  }

  bool claveValida = false;
  Future<bool> validateClave() {
    TextEditingController clave = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void autorizacion() async {
      final form = formKey.currentState;
      if (form.validate()) {
        Navigator.pop(context);
        setState(() {
          claveValida = true;
        });
      } else {
        print('No Valido');
        setState(() {
          claveValida = false;
        });
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: ListTile(
              title: Text("Ingrese clave de validación",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 25,
                  )),
              trailing: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                iconSize: 50,
                color: Colors.red,
              ),
            ),
            content: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextFormField(
                                style: TextStyle(fontSize: 25),
                                onEditingComplete: () => autorizacion(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // inputFormatters: <TextInputFormatter>[
                                //   WhitelistingTextInputFormatter.digitsOnly
                                // ],
                                validator: (value) {
                                  final intNumber = int.tryParse(value);
                                  if (value.isEmpty) {
                                    return 'Campo requerido:';
                                  } else if (value != 'dondelucho') {
                                    return 'la clave no es válida';
                                  }
                                  return null;
                                },
                                controller: clave,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.password_outlined,
                                      color: PRIMARY_COLOR),
                                  hintText: 'Clave',
                                  //labelText: 'Cantidad'
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //mainAxisSize: MainAxisSize.max,
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "VALIDAR",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  color: PRIMARY_COLOR,
                                  onPressed: () {
                                    autorizacion();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
