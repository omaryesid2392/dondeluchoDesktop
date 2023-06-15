import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';
import 'package:intl/intl.dart';
import 'package:dondelucho/models/user_model.dart';

import 'package:dondelucho/ui/screens/Services/takeRequest.dart';
import 'package:dondelucho/session.dart';

import '../../../app_theme.dart';
import '../CalculateItems.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:provider/provider.dart';

class DetailRequest extends StatefulWidget {
  final RequestModel r;
  final String uidRequest;
  DetailRequest(this.r, {Key key, this.uidRequest}) : super(key: key);

  @override
  _DetailRequestState createState() => _DetailRequestState(r);
}

class _DetailRequestState extends State<DetailRequest> {
  TransformationController _controller = TransformationController();
  RequestModel r;
  bool _loading = false;
  _DetailRequestState(this.r);
  ModelUser2 _user;
  var _edad;
  StatusBloc _statusBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSession();
    calcularEdad();
  }

  initSession() async {
    _user = await SessionSharepreferences().getUser();
    setState(() {
      _user;
    });
  }

  calcularEdad() async {
    print('@@@@@@@@@@@@@@@@');
    // print(r.fechaNacimiento.toString());
    //  _edad = CalculateItems().calcularEdad(r.fechaNacimiento.toDate());
  }

  @override
  Widget build(BuildContext context) {
    _statusBloc = Provider.of<StatusBloc>(context);
    final _size = MediaQuery.of(context).size;

    //print(r.cel);
    return Scaffold(
      appBar: AppBar(
        title: Text("Información Requerimiento"),
        // actions: <Widget>[
        //   Expanded(
        //     child: Center(
        //       child: Container(
        //         //color: Colors.blue,
        //         alignment: Alignment.centerRight,
        //         child: Image.asset("assets/images/logo_white.png"),
        //         width: 130.0,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
            children: [
              r.isTaked ? _cardClient(_size) : Container(),
              _cardService(_size),
              _btnRaisedButton(_size)
            ],
          )),
        ],
      ),
    );
  }

  Widget _btnRaisedButton(_size) {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black12,
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: [
                  widget.uidRequest != null
                      ? Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                            shape: StadiumBorder(),
                            color: PRIMARY_COLOR,
                            textColor: Colors.white,
                            child: _loading == false
                                ? Text('Cancelar Servicio')
                                : CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });

                              await NoTakeRequest(r, _user);
                              setState(() {
                                _loading = false;
                              });
                              _statusBloc.setUidRequest = true;
                              Navigator.pop(context);
                            },
                          ),
                        )
                      : Container(),
                  widget.uidRequest != null
                      ? VerticalDivider(
                          width: 15,
                        )
                      : Container(),
                  Center(
                    child: r.isTaked == false
                        ? Container(
                            margin: EdgeInsets.only(top: 40.0),
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                              shape: StadiumBorder(),
                              color: PRIMARY_COLOR,
                              textColor: Colors.white,
                              child: _loading == false
                                  ? _statusBloc.take == false
                                      ? Text('Aceptar Solicitud')
                                      : Text(
                                          'Terminar Pendientes',
                                          style: TextStyle(color: Colors.white),
                                        )
                                  : CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                              onPressed: _statusBloc.take == false
                                  ? () async {
                                      bool confirm = await CalculateItems()
                                          .cacularAmount(_user, r);
                                      if (confirm) {
                                        _statusBloc.setTake = true;

                                        setState(() {
                                          _loading = true;
                                        });
                                        print(_user.uid);
                                        await TakeRequest(r, _user);
                                        _statusBloc.setCurrentIndex = 2;
                                        _statusBloc.setUidRequest = true;

                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        AlertWidget().alertAcount(context);
                                      }
                                    }
                                  : null,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 40.0),
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                              shape: StadiumBorder(),
                              color: PRIMARY_COLOR,
                              textColor: Colors.white,
                              child: _loading == false
                                  ? Text('Cerrar Servicio')
                                  : CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      setState(() {
                                        _loading = true;
                                      });

                                      await AlertWidget()
                                          .alertTerminateRequestConfirm(
                                              context, r, _statusBloc);
                                      setState(() {
                                        _loading = false;
                                      });

                                      // print(r.active.toString());
                                      // await Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           TerminateRequests(r)),
                                      // );
                                      //Navigator.pop(context);
                                    },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardClient(_size) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
            title: Text(
              'Información Paciente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: dondeluchoAppTheme.primaryColor,
              ),
            ),
            //subtitle: Text( ''),
          ),
          // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text('Nombre: ${r.nameCustomer}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              //subtitle: Text( ''),
              leading: Icon(
                Icons.person_rounded,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          // Divider(
          //   color: Colors.black,
          // ),
          // ListTile(
          //     contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
          //     title: Text(
          //       'Direccion: ${r.direction}',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     leading: Icon(
          //       Icons.location_on,
          //       color: DraviMedicAppTheme.primaryColor,
          //       size: 30,
          //     )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(
                'Telefono: ${r.cel}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.phone,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text('Edad: ${_edad} Años',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              //subtitle: Text( ''),
              leading: Icon(
                Icons.timer,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _cardService(_size) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
            title: Text(
              'Información Servicio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: dondeluchoAppTheme.primaryColor,
              ),
            ),
            //subtitle: Text( ''),
          ),
          // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(DateFormat.yMMMd().format(DateTime.now()).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              //subtitle: Text( ''),
              leading: Icon(
                Icons.calendar_today,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(
                'Direccion: ${r.direction}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.location_on,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(
                'Servicio: ${r.category}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.file_copy,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(
                'Descripion: ${r.description}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.attach_file,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 25, 0),
              title: Text(
                'Valor: ' + money.format(double.parse(r.offer.toString())),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.money_off_rounded,
                color: dondeluchoAppTheme.primaryColor,
                size: 30,
              )),
          Divider(
            color: Colors.black,
          ),
          r.attached != null ? screen() : Container()
        ],
      ),
    );
  }

  Widget screen() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value = Matrix4.identity();
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          _controller.value = Matrix4.identity();
        });
      },
      child: InteractiveViewer(
        transformationController: _controller,
        maxScale: 5.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 300,
            width: 400,
            child: Image(
              image: NetworkImage(r.attached),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: dondeluchoAppTheme.background,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}
