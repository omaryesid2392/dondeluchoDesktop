//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_user.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../SettingSharepreferences.dart';

class EditProfile extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  EditProfile({Key key, this.navigatorKey}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  StatusBloc _statusBloc;
  ModelUser2 _user;
  String image = "";
  int genero = 0;
  bool _loading = false;
  DateTime _fechaSelec;
  String _fecha;

  String _prefUser;
  final _controllerInputName = new TextEditingController();
  final _controllerInputCelular = new TextEditingController();
  final _controllerInputCelular2 = new TextEditingController();
  final _controllerInputDescription = new TextEditingController();
  final _controllerInputGenero = new TextEditingController();
  final _controllerInputDireccion = new TextEditingController();
  final _controllerFecha = new TextEditingController();

  @override
  void initState() {
    super.initState();
    initPreUser();
    // TODO: implement initState
  }

  initPreUser() async {
    _user = await SessionSharepreferences().getUser();

    setState(() {
      _controllerInputName.text = _user.name;
      _controllerFecha.text;
      _controllerInputCelular.text =
          _user.cel == null ? '' : _user.cel.toString();

      _controllerInputDescription.text = _user.cel;
      _controllerInputDireccion.text = _user.direction;
      _user;
    });
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      print('Valido');

      // final Firestore _db = Firestore.instance;
      // DocumentReference _ref = _db.collection('users').document(_user.uid);
      // _ref.setData({
      //   'cel': _controllerInputCelular.text,
      //   'name': _controllerInputName.text,
      //   'cel2': _controllerInputCelular2.text,
      //   'fechaNacimiento': _fechaSelec,
      //   'description': _controllerInputDescription.text,
      //   'direction': _controllerInputDireccion.text,
      // }, merge: true);
      _user.name = _controllerInputName.text;
      _user.cel = _controllerInputCelular.text;
      // await Session().setUser(user);
      // await Session().setFechaNacimiento(_fechaSelec.toString());
    } else {
      SnackBar snac = SnackBar(
        content: Text(
          ' Verifique la información suministrada!!!',
          textAlign: TextAlign.center,
        ),
      );
      _statusBloc.globalKey.currentState.showSnackBar(snac);
      print('No Valido');
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    _statusBloc = Provider.of<StatusBloc>(context);
    final _size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Editar perfil"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              tooltip: "Actualizar perfil",
              iconSize: 30,
              onPressed: () async {
                final form = _formKey
                    .currentState; // validando el estado actual de la clave
                if (_controllerInputCelular.text.length == 10 &&
                    _controllerInputCelular2.text.length == 10 &&
                    _controllerInputCelular2.text !=
                        _controllerInputCelular.text &&
                    _controllerInputName.text != "" &&
                    _controllerInputDireccion.text != "" &&
                    _controllerFecha.text != '') {
                  // final Firestore _db = Firestore.instance;
                  // DocumentReference _ref =
                  //     _db.collection('users').document(_user.uid);
                  // _ref.setData({
                  //   'name': _controllerInputName.text,
                  //   'cel': _controllerInputCelular.text,
                  //   'cel2': _controllerInputCelular2.text,
                  //   'fechaNacimiento': _fechaSelec,
                  //   'direction': _controllerInputDireccion.text,
                  // }, merge: true);
                  _user.name = _controllerInputName.text;
                  _user.cel = _controllerInputCelular.text;
                  _user.cel = _controllerInputCelular.text;
                  await Session().setUser(_user);

                  AlertWidget().alertDateSave(context: context);
                } else if (form
                    .validate()) // valiadmos si el formulario es valido
                {
                } else {
                  SnackBar snac = SnackBar(
                    content: Text(
                      ' Verifique la información suministrada!!!',
                      textAlign: TextAlign.center,
                    ),
                  );
                  _scaffoldKey.currentState.showSnackBar(snac);
                }
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 10.0, bottom: 100),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Wrap(
                          spacing: 15.0,
                          alignment: WrapAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                _user != null
                                    ? _loading == false
                                        ? CircleAvatar(
                                            backgroundColor: PRIMARY_COLOR,
                                            backgroundImage:
                                                _statusBloc.rol == "ADMIN"
                                                    ? _user.photoURL != null
                                                        ? NetworkImage(
                                                            _user.photoURL)
                                                        : null
                                                    : null,
                                            child: _statusBloc.rol == "ADMIN"
                                                ? _user.photoURL != null
                                                    ? Text(
                                                        "",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 100.0,
                                                      )
                                                : Text(
                                                    "LC",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                            maxRadius: 60.0,
                                            minRadius: 45.0,
                                          )
                                        : Center(
                                            child: CircularProgressIndicator())
                                    : Center(
                                        child: CircularProgressIndicator()),
                                _statusBloc.rol == "ADMIN"
                                    ? IconButton(
                                        color: PRIMARY_COLOR,
                                        iconSize: 40,
                                        icon: Icon(Icons
                                            .photo_size_select_actual_outlined),
                                        onPressed: () {
                                          filePicker();
                                          setState(() {
                                            image;
                                          });
                                        })
                                    : Container(),
                                _statusBloc.rol == "ADMIN"
                                    ? Text("Actualizar Foto")
                                    : Text("")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: _size.width * 0.6,
                                  margin:
                                      EdgeInsets.only(bottom: 12.0, top: 25),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        // se valida si el Email esta vacio
                                        return 'Campo requerido:';
                                      }
                                      return null;
                                    },
                                    controller: _controllerInputName,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.person,
                                          color: PRIMARY_COLOR),
                                      labelText: "Nombre Completo",
                                      hintText: "Nombre",
                                      contentPadding:
                                          EdgeInsets.only(bottom: 5.0),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: _size.width * 0.6,
                                //   child: TextField(
                                //     controller: _controllerInputName,
                                //     decoration: InputDecoration(
                                //         hintText: "Apellido",
                                //         contentPadding: EdgeInsets.only(bottom: 5.0)),
                                //   ),
                                // )
                              ],
                            )
                          ],
                        ),
                        _buildInfoPersonal(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // _statusBloc.modo == "AGENT" ? _btnGuardar() : Text(""),
            _statusBloc.rol == "ADMIN" ? _bntsFloatingActionButton() : Text(""),
          ],
        ),
      ),
    );
  }

  Widget _fechaNacimiento() {
    return Container(
      // margin: Ed,
      // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: double.infinity,
      // height: 100.0,
      child: Row(
        children: [
          // Expanded(
          //   child: GestureDetector(
          //     onTap: () {
          //       DatePicker.showDatePicker(context,
          //           showTitleActions: true,
          //           minTime: DateTime(1940, 1, 1),
          //           maxTime: DateTime(2050, 1, 1), onChanged: (date) {
          //         print('change $date');
          //         setState(() {
          //           _fechaSelec = date;
          //           _fecha = DateFormat.yMMMMd().format(date);
          //           _controllerFecha.text = _fecha;
          //         });
          //         print(_fecha);
          //       }, onConfirm: (date) {
          //         print('confirm $date');

          //         setState(() {
          //           _fechaSelec = date;
          //           _fecha = DateFormat.yMMMMd().format(date);
          //           _controllerFecha.text = _fecha;
          //         });
          //         print('xxxxxx ' + _fecha);
          //       }, currentTime: DateTime.now(), locale: LocaleType.es);
          //     },
          //     child: Container(
          //       child: TextFormField(
          //         validator: (value) {
          //           if (value.isEmpty) {
          //             // se valida si el Email esta vacio
          //             return 'Campo requerido:';
          //           }
          //         },
          //         enabled: false,
          //         controller: _controllerFecha,
          //         keyboardType: TextInputType.datetime,
          //         decoration: InputDecoration(
          //             icon: Icon(Icons.timer, color: PRIMARY_COLOR),
          //             hintText: 'Fecha.',
          //             labelText: 'Fecha nacimiento'),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildInfoPersonal() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Información Personal",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
          ),
          TextFormField(
              keyboardType: TextInputType.phone,
              controller: _controllerInputCelular,
              decoration: InputDecoration(
                  icon: Icon(Icons.phone, color: PRIMARY_COLOR),
                  hintText: 'Teléfono Celular',
                  labelText: 'Teléfono Celular'),
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  // se valida si el Email esta vacio
                  return 'Campo requerido:';
                }
                if (value.length != 10) {
                  // se valida si el Email esta vacio
                  return 'Debe contener 10 caracteres:';
                }
              }),
          TextFormField(
            // ignore: missing_return
            validator: (value) {
              if (value.isEmpty) {
                // se valida si el Email esta vacio
                return 'Campo requerido:';
              } else if (value.length != 10) {
                // se valida si el Email esta vacio
                return 'Debe contener 10 caracteres:';
              } else if (value == _controllerInputCelular.text) {
                // se valida si el Email esta vacio
                return 'Ingrese un número telefónico diferente al anterior:';
              }
            },
            keyboardType: TextInputType.phone,
            controller: _controllerInputCelular2,
            decoration: InputDecoration(
                icon: Icon(Icons.phone, color: PRIMARY_COLOR),
                hintText: 'Contacto de Emergencia',
                labelText: 'Contacto de Emergencia'),
          ),
          // TextField(
          //   controller: _controllerInputName,
          //   decoration: InputDecoration(
          //     labelText: "Email",
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     _genero();
          //   },
          //   child: TextField(
          //     enabled: false,
          //     controller: _controllerInputGenero,
          //     decoration: InputDecoration(
          //       labelText: "Genero",
          //     ),
          //   ),
          // ),
          //_genero(),
          _statusBloc.rol == "ADMIN"
              ? TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      // se valida si el Email esta vacio
                      return 'Campo requerido:';
                    }
                    if (value.length < 30) {
                      // se valida si el Email esta vacio
                      return 'Descripción muy corta:';
                    }
                  },
                  controller: _controllerInputDescription,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    icon: Icon(Icons.description, color: PRIMARY_COLOR),
                    hintText:
                        "Ej: Médico general con habilidades para trato con pacientes mayores de 45 años hipertensos y diabéticos, capaz de brindar atención integral al usuario...\netc.",
                    labelText: "Describa brevemente su Perfil",
                    //suffixText: "Añadir Contacto"
                  ),
                  maxLines: 5,
                )
              : Text(""),
          _fechaNacimiento(),

          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                // se valida si el Email esta vacio
                return "Campo requerido";
              }
            },
            controller: _controllerInputDireccion,
            decoration: InputDecoration(
                icon: Icon(Icons.directions_walk, color: PRIMARY_COLOR),
                hintText: 'Dirección.',
                labelText: 'Dirección'),
          )
        ],
      ),
    );
  }

  filePicker() async {
    // File _file;
    // String _fileName;
    // String _phhotoReferencia;
    // final Firestore _db = Firestore.instance;

    // try {
    //   File _result = await FilePicker.getFile(
    //     type: FileType.custom,
    //     allowedExtensions: ['png', 'jpg', 'jpeg', 'gif'],
    //     onFileLoading: (_result) {},
    //   );

    //   if (_result != null) {
    //     _file = File(_result.path);

    //     _fileName = _file.toString().split('/').last;
    //     // print(_fileName.split('.').first);
    //     // print(_result.path);
    //     print('Archivo Seleccionado');
    //     if (_fileName.split('.').last == "png'" ||
    //         _fileName.split('.').last == "jpeg'" ||
    //         _fileName.split('.').last == "jpg'" ||
    //         _fileName.split('.').last == "gif'" ||
    //         _fileName.split('.').last == "png" ||
    //         _fileName.split('.').last == "jpeg" ||
    //         _fileName.split('.').last == "jpg" ||
    //         _fileName.split('.').last == "gif") {
    //       setState(() {
    //         _loading = true;
    //       });
    //       StorageReference _guardar = FirebaseStorage.instance
    //           .ref()
    //           .child(_user.uid + '/perfil/photoURL');
    //       StorageUploadTask save = _guardar.putFile(_file);
    //       _phhotoReferencia =
    //           await (await save.onComplete).ref.getDownloadURL();

    //       DocumentReference _ref = _db.collection('users').document(_user.uid);
    //       await _ref.setData({
    //         'photoURL': _phhotoReferencia,
    //       }, merge: true);
    //       setState(() {
    //         _user.photoURL = _phhotoReferencia;
    //         _loading = false;
    //       });
    //     } else {
    //       print('Formato válido');
    //       AlertWidget().alertFormat(context);
    //     }
    //   } else {
    //     print('Seleccione un archivo');
    //   }
    // } catch (e) {
    //   print('Formato de archivo no válido');
    //   AlertWidget().alertFormat(context);
    // }
  }

  Widget _genero() {
    return Container(
      // margin: EdgeInsets.fromLTRB(50, 0, 10, 0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Genero:  ',
            style: TextStyle(
              fontSize: 15,
              color: PRIMARY_COLOR,
            ),
          ),
          Text(
            'M',
            style: TextStyle(
              fontSize: 15,
              color: PRIMARY_COLOR,
            ),
          ),
          Radio(
              value: 1,
              groupValue: genero,
              activeColor: PRIMARY_COLOR,
              onChanged: (T) {
                print(T);
                setState(() {
                  genero = T;
                  _controllerInputGenero.text = T == 1 ? "M" : "F";
                });
              }),
          Text(
            'F',
            style: TextStyle(
              fontSize: 15,
              color: PRIMARY_COLOR,
            ),
          ),
          Radio(
              value: 2,
              groupValue: genero,
              activeColor: PRIMARY_COLOR,
              onChanged: (T) {
                print(T);
                setState(() {
                  genero = T;
                });
              }),
        ],
      ),
    );
  }

  Widget _bntsFloatingActionButton() {
    return Positioned(
      right: 5,
      bottom: 5,
      child: Container(
        //color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1", // para solucionar el error de erors
              backgroundColor: PRIMARY_COLOR,
              onPressed: () async {
                validador();
                await AlertWidget().alertDateSave(context: context);
                ModelUser2 user = await SessionSharepreferences().getUser();
              },
              child: Icon(
                Icons.file_upload_outlined,
                size: 35,
              ),
            ),
            Text("Guardar"),
          ],
        ),
      ),
    );
  }

  // Widget _btnGuardar() {
  //   return Container(
  //     //color: Colors.amber,
  //     alignment: Alignment.bottomRight,
  //     margin: EdgeInsets.only(top: 0.0, left: 10, right: 10, bottom: 10),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding:
  //               const EdgeInsets.only(top: 20, left: 30, right: 10, bottom: 10),
  //           child: Text(
  //             "Editar Perfil:",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 color: PRIMARY_COLOR_DARK,
  //                 fontSize: 25.0,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         // Column(
  //         //   //mainAxisAlignment: MainAxisAlignment.start,
  //         //   // crossAxisAlignment: CrossAxisAlignment.center,
  //         //   children: [
  //         //     IconButton(
  //         //       iconSize: 35,
  //         //       color: PRIMARY_COLOR,
  //         //       icon: Icon(Icons.save_rounded),
  //         //       // padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
  //         //       // child: !_loading
  //         //       //     ? Text('Actualizar')
  //         //       //     : CircularProgressIndicator(
  //         //       //         valueColor: AlwaysStoppedAnimation(Colors.white),
  //         //       //       ),
  //         //       onPressed: () async {
  //         //         validador();
  //         //       },
  //         //     ),
  //         //     Text("Guardar"),
  //         //   ],
  //         // ),
  //       ],
  //     ),
  //   );
  // }
}
