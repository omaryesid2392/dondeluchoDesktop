import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';

import '../../../../../session.dart';
import '../../../SettingSharepreferences.dart';

class UpdateEstablecimiento extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const UpdateEstablecimiento(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _UpdateEstablecimientoState createState() => _UpdateEstablecimientoState();
}

class _UpdateEstablecimientoState extends State<UpdateEstablecimiento> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  TextEditingController _codigo = TextEditingController();
  TextEditingController _nit = TextEditingController();
  TextEditingController _direction = TextEditingController();
  TextEditingController _celular = TextEditingController();
  TextEditingController _nameEsta = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _loading = false;
  String status;

  String sede = 'Seleccione sede';
  ModelEstablecimientos establecimientos;
  ModelUser2 user;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  var rng = new Random();

  @override
  void initState() {
    super.initState();
    initSession();
  }

  initSession() async {
    user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {});
  }

  void validador({Establecimiento estableci}) async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      Establecimiento temp = Establecimiento.fromMap({
        'codigo': _codigo.text,
        'name': _nameEsta.text,
        'cel': _celular.text,
        'direction': _direction.text,
        'nit': _nit.text,
      });
      for (var i = 0; i < establecimientos.establecimientos.length; i++) {
        if (establecimientos.establecimientos[i].codigo == _codigo.text) {
          establecimientos.establecimientos[i] = temp;
        }
      }
      print(establecimientos.establecimientos[0].cel);

      setState(() {
        _loading = true;
      });

      AlertWidget().alertProcesando(context);
      String estableciFormat = modelEstablecimientosToMap(establecimientos);

      try {
        status = await ServicesServicesHTTP().updateEstablecimiento(
            establecimiento: {'data': estableciFormat},
            uid: establecimientos.uid);
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
        await Session().setEstablecimientos(establecimientos);
        AlertWidget().aletProductSave(context);
      }
      setState(() {
        sede = 'Seleccione sede';
      });
      // _celular.text = '';
      // _nameEsta.text = '';
      // _nit.text = '';
      // _direction.text = '';
      // _password.text = '';
    } else {
      print('No es valido');
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
            _listSedes(),
            Visibility(
                visible: sede != 'Seleccione sede', child: _buildCuerpo()),
            SizedBox(
              height: 50,
            )
            // divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildCuerpo() {
    return Column(
      children: [
        _nameEstablecimiento(),
        _nitEstablecimiento(),
        _celularEstablecimiento(),
        _direccionEstablecimiento(),
        _btn(),
      ],
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
            ? Text('Actualizar establecimiento')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () {
          validador();
        },
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
                            _celular.text = element.cel;
                            _direction.text = element.direction;
                            _nameEsta.text = element.name;
                            _nit.text = element.nit;
                            _codigo.text = element.codigo;
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

  Widget _nameEstablecimiento() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          return null;
        },
        controller: _nameEsta,
        keyboardType: TextInputType.text,
        // maxLength: 10,
        decoration: InputDecoration(
            icon: Icon(Icons.home_work, color: PRIMARY_COLOR),
            hintText: 'Nombre del establecimiento',
            labelText: 'Nombre del establecimiento'),
      ),
    );
  }

  Widget _nitEstablecimiento() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo requerido:';
          }
          return null;
        },
        controller: _nit,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.qr_code, color: PRIMARY_COLOR),
            hintText: 'Nit',
            labelText: 'Ingrese Nit'),
      ),
    );
  }

  Widget _celularEstablecimiento() {
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
            hintText: 'Número de celular del establecimiento',
            labelText: 'Número de celular del establecimiento'),
      ),
    );
  }

  Widget _direccionEstablecimiento() {
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
            hintText: 'Dirección residencial del establecimiento',
            labelText: 'Dirección residencial del establecimiento'),
      ),
    );
  }
}
