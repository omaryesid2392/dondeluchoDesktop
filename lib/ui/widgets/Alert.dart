import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_user.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/models/venta_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/screens/Profiles/EditProfiles.dart';
import 'package:dondelucho/ui/widgets/btnDraggableScrollableSheet%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app_theme.dart';
import 'PrintPos.dart';

class AlertWidget {
  Widget _buildSuccessService() {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: CircleAvatar(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: PRIMARY_COLOR,
          maxRadius: 30.0,
        ),
      ),
      Text(
        "¡¡¡ Datos guardados exitosamente !!!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: PRIMARY_COLOR,
          fontSize: 25,
        ),
      ),
      Scaffold(
        body: PDFScreen(),
      )
    ]);
  }

  Future alertCommentAgent(BuildContext _context, ModelUser agent,
      double rating, String comment, String nameCustomer) async {
    // if (rating >= 3 && comment != '') {
    //   await Firestore.instance.collection('comment').document().setData({
    //     'agentUid': agent.uid,
    //     'comment': comment,
    //     'nameCustomer': nameCustomer,
    //     'rating': rating,
    //     'createdAt': DateTime.now(),
    //   });
    //   await Firestore.instance.collection('users').document(agent.uid).setData({
    //     'rating': agent.rating != null ? (agent.rating + rating) / 2 : rating,
    //   }, merge: true);
    // } else if (rating < 3 && comment != '') {
    //   await Firestore.instance.collection('comment').document().setData({
    //     'agentUid': agent.uid,
    //     'comment': comment,
    //     'nameCustomer': nameCustomer,
    //     'rating': rating,
    //     'createdAt': DateTime.now(),
    //   });
    // }
    Navigator.pop(_context);

    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "¡¡¡Gracias, tú opinión es muy importante para nosotros. !!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            // content: Text(
            //   "Para poder aceptar requerimientos es necesario actualizar información.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
              ),
            ],
          );
        });
  }

  Widget _buildSuccessServiceTerminate({String option}) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: CircleAvatar(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: PRIMARY_COLOR,
          maxRadius: 30.0,
        ),
      ),
      Text(
        option == null
            ? "¡¡¡Cierre de Servicio Exitoso !!!"
            : "¡¡¡Factura elimina exitosamente !!!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: PRIMARY_COLOR,
          fontSize: 18,
        ),
      ),
    ]);
  }

  alertNotificatioAgentSpecific(BuildContext context2, double height,
      double width, RequestModel request) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context2,
        isDismissible: false,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            child: Container(
              color: Colors.white,
              height: height,
              width: width,
              //color: Colors.red,
              child:
                  BtnDraggableScrollableSheet(request: request, cont: context2),
            ),
          );
        });
  }

  aletProductDelete(BuildContext _context, String uidProduct) {
    return showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Está seguro de eliminar el registro?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            // content: Text(
            //   "Apartir de la fecha del envío de tú solicitud, en un maxímo 48 horas recibirás una notificación.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  Navigator.pop(_context);
                },
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "SI",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () async {
                  // await ServicesServices().deleteProduct(uidProduct);
                  // Navigator.pop(context);
                  // _buildSuccessServiceTerminate();
                },
              ),
            ],
          );
        });
  }

  Future<bool> aletFacturaDelete(BuildContext _context, modeloVenta venta,
      GlobalKey<ScaffoldState> scaffolKey) {
    return showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Alerta va a dar de baja a la factura Nro ${venta.numeroFactura} \n Está seguro de eliminar el registro?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            // content: Text(
            //   "Apartir de la fecha del envío de tú solicitud, en un maxímo 48 horas recibirás una notificación.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  Navigator.pop(_context);
                  return false;
                },
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "SI",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () async {
                  String res = '';
                  print('Valido');

                  AlertWidget().alertProcesando(context);
                  List<Map<String, dynamic>> listProductoDetalleFormateada = [];

                  for (var i = 0; i < venta.listProductosDetalle.length; i++) {
                    var obj = {
                      "cant": venta.listProductosDetalle[i].cant,
                      "producto": {
                        'vcompra':
                            venta.listProductosDetalle[i].producto.vCompra,
                        'name': venta.listProductosDetalle[i].producto.name,
                        'codproduct':
                            venta.listProductosDetalle[i].producto.codProduct,
                        'description':
                            venta.listProductosDetalle[i].producto.description,
                        'vpublico':
                            venta.listProductosDetalle[i].producto.vPublico,
                        'imei': venta.listProductosDetalle[i].producto.imei,
                      }
                    };
                    listProductoDetalleFormateada.add(obj);
                  }

                  final data = {
                    "uid": venta.uid,
                    "descuento": venta.descuento.toString(),
                    "sede": venta.sede,
                    "numerofactura": venta.numeroFactura,
                    "idcliente": venta.idCliente,
                    "idemployee": venta.idEmployee,
                    "total": venta.total.toString(),
                    "fechaventa": venta.fechaVenta.toString(),
                    "listproductodetalle":
                        jsonEncode(listProductoDetalleFormateada),
                  };
                  print(venta.uid);
                  try {
                    res = await ServicesServicesHTTP()
                        .deleteVenta(detalleVenta: data);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    SnackBar snac = SnackBar(
                      content: BounceInRight(
                        duration: Duration(milliseconds: 3000),
                        child: Text(
                          res,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    scaffolKey.currentState.showSnackBar(snac);
                  } catch (e) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    SnackBar snac = SnackBar(
                      content: BounceInRight(
                        duration: Duration(milliseconds: 3000),
                        child: Text(
                          res + '\n' + e.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    scaffolKey.currentState.showSnackBar(snac);
                  }
                  return true;
                },
              ),
            ],
          );
        });
  }

  aletProductSave(BuildContext _context, {bool error}) {
    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: error == null
                ? Text(
                    "¡¡¡ Registro exitoso. !!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 25,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "¡¡¡ Error de registro. !!!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'Usuario existente o verifique la conexión a internet, si el problema persiste comunicarse con el administrador de sistemas << GOLDEN SAS >>',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: PRIMARY_COLOR,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
            // content: Text(
            //   "Apartir de la fecha del envío de tú solicitud, en un maxímo 48 horas recibirás una notificación.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  Navigator.pop(_context);
                },
              ),
            ],
          );
        });
  }

  duration(BuildContext _context) async {
    await Future.delayed(Duration(seconds: 3));
    //Navigator.pop(_context);
  }

  alertFormAgent(BuildContext _context) {
    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text("No estás registrado como Agente Médico.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 25,
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.fromLTRB(50, 0, 50, 0) * 2,
                  //color: Colors.blueAccent,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "¿Deseas registrarte para recibir servicios?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.max,
                          children: [
                            FlatButton(
                              onPressed: () {
                                {
                                  Navigator.pop(_context);
                                }
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SI",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              color: PRIMARY_COLOR,
                              onPressed: () {
                                // Navigator.pop(_context);
                                // Navigator.push(
                                //   _context,
                                //   MaterialPageRoute(
                                //       builder: (context) => FormAgent()),
                                // );
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
          );
        });
  }

  alertFormPaciente(BuildContext _context) {
    return showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
                "Debes actualizar tú información para solicitar servicios.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 25,
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.fromLTRB(50, 0, 50, 0) * 2,
                  //color: Colors.blueAccent,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "¿Deseas continuar?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.max,
                          children: [
                            FlatButton(
                              onPressed: () {
                                {
                                  Navigator.pop(_context);
                                }
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SI",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              color: PRIMARY_COLOR,
                              onPressed: () async {
                                Navigator.pop(_context);
                                await Navigator.push(
                                  _context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                                //Navigator.pop(_context);
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
          );
        });
  }

  alertCancelRequest(
      BuildContext _context, String request, StatusBloc _statusBloc) {
    final _cancelType = TextEditingController();

    _cancelRequest(String text) async {
      // await Firestore.instance
      //     .collection('requests')
      //     .document(request)
      //     .setData({
      //   'active': false,
      //   'cancelType': text + " \nuid user" + request,
      // }, merge: true);
      _statusBloc.setTake = false;
      // _statusBloc.setValidateRequest = false;
      _statusBloc.setRequest = null;
      Navigator.pop(_context);
    }

    return showDialog(
        context: _context,
        builder: (_context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                contentPadding: EdgeInsets.all(20.0),
                title: Text(
                  "¡¡¡Seleccione el motivo de cancelación del servicio.!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 15,
                  ),
                ),
                content: Column(
                  children: [
                    FlatButton(
                      onPressed: () {
                        _cancelType.text = "Ya no necesito el servicio";
                        _cancelRequest(_cancelType.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text("Ya no necesito el servicio"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _cancelType.text = "No me gustó el perfíl del agente";
                        _cancelRequest(_cancelType.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text("No me gustó el perfíl del agente"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _cancelType.text = "Ya no es necesario el servicio";
                        _cancelRequest(_cancelType.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text("Ya no es necesario el servicio"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _cancelType.text = "Otro Motivo";
                        _cancelRequest(_cancelType.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text("Otro Motivo:"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // actions: <Widget>[
                //   FlatButton(
                //     onPressed: () async {
                //       print(_cancelType.text);
                //       // await Firestore.instance
                //       //     .collection('requests')
                //       //     .document(request)
                //       //     .setData({
                //       //   'agentId': null,
                //       //   'isTaked': false,
                //       //   'cancelType': _cancelType.text,
                //       // }, merge: true);
                //       // {
                //       //   Navigator.pop(_context);
                //       // }
                //     },
                //     child: Text(
                //       'OK',
                //       style: TextStyle(color: Colors.blue),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ],
              ),
            ),
          );
        });
  }

  alertANotification(BuildContext context) {
    return showDialog(
        // barrierColor: Colors.transparent,

        context: context,
        barrierDismissible: true,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: ListTile(
              title: Text(
                "Notificaciones Pendientes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 15,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pop(_context);
                },
                icon: Icon(
                  Icons.cancel_sharp,
                  color: dondeluchoAppTheme.primaryColor,
                  size: 40,
                ),
              ),
            ),
            content: Column(
              children: [
                Text(
                  "No hay notificaciones",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          );
        });
  }

  alertAcountAgent(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: ListTile(
              title: Text(
                "¡¡¡ Saldo Insuficiente !!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 25,
                ),
              ),
            ),
            content: Text(
              "Desea recargar?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 35.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "SI",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
                // child: Text(
                //   'SI',
                //   style: TextStyle(color: Colors.blue),
                //   textAlign: TextAlign.center,
                // ),
              ),
            ],
          );
        });
  }

  alertNoRequestTaked(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: ListTile(
              title: Text(
                "¡¡¡ Lo sentimos el agente no aceptó su solicitud: !!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 25,
                ),
              ),
            ),
            content: Text(
              "Intente con otra persona",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
              ),
            ],
          );
        });
  }

  alertNotificationNoAgent(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "¡¡¡ UPS !!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            content: Text(
              "No hay agentes cercanos a tú ubicación, por favor cancelar el servicio e intente más tarde",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
              ),
            ],
          );
        });
  }

  alertUpdateAgent(BuildContext _context, String modo) {
    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "¡¡¡Actualizar su información. !!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            content: modo == 'AGENT'
                ? Text(
                    "Para poder aceptar requerimientos es necesario actualizar información.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  )
                : Text(
                    "Para pedir servicios es necesario actualizar información.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                  }
                },
              ),
            ],
          );
        });
  }

  alertTerminateRequestConfirm(
      BuildContext _context, RequestModel r, StatusBloc _statusBloc) {
    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Está seguro de cerrar el servicio?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 18,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    {
                      Navigator.pop(_context);
                    }
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "SI",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: PRIMARY_COLOR,
                  onPressed: () {
                    {
                      // final Firestore _db = Firestore.instance;
                      // DocumentReference _ref =
                      //     _db.collection('requests').document(r.uid);
                      // _ref.setData({
                      //   'active': false,
                      // }, merge: true);
                      // Navigator.pop(_context);
                      // AlertWidget().alertTerminateRequest(_context);
                      // _statusBloc.setTake = false;
                    }
                  },
                  // child: Text(
                  //   'SI',
                  //   style: TextStyle(color: Colors.blue),
                  //   textAlign: TextAlign.center,
                  // ),
                ),
              ],
            ),
            // content: Text(
            //   "Favor seleccionar un formato correcto\n (PNG, JPG, JPEG, GIF).",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            // actions: <Widget>[
            //   FlatButton(
            //     onPressed: () {
            //       {
            //         Navigator.pop(_context);
            //       }
            //     },
            //     child: Text(
            //       'OK',
            //       style: TextStyle(color: Colors.blue),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ],
          );
        });
  }

  alertTerminateRequest(BuildContext _context) {
    return showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            content: _buildSuccessServiceTerminate(),
            // title: .Text(
            //   "¡¡¡Cierre de Servicio Exitoso !!!",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: PRIMARY_COLOR,
            //     fontSize: 18,
            //   ),
            // ),
            // content: Text(
            //   "Favor seleccionar un formato correcto\n (PNG, JPG, JPEG, GIF).",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.0),
            // ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(_context);
                    Navigator.pop(_context);
                  }
                },
              ),
            ],
          );
        });
  }

  alertAcount(BuildContext _context) {
    return showDialog(
        context: _context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "¡¡¡ No cuenta con saldo suficiente!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 18,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Desea Recargar?.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        {
                          Navigator.pop(_context);
                        }
                      },
                      child: Text(
                        'NO',
                        style: TextStyle(color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "SI",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: PRIMARY_COLOR,
                      onPressed: () {
                        {
                          // Navigator.pop(_context);
                          // Navigator.of(_context).push(
                          //   CupertinoPageRoute(
                          //       builder: (context) => MyWalletPage()),
                          // );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
            // actions: <Widget>[

            // ],
          );
        });
  }

  alertConfirmDelete({
    BuildContext context,
    ProductModel producto,
    GlobalKey<ScaffoldState> scaffoldKey,
    String sede,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Está seguro de eliminar el producto?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: PRIMARY_COLOR,
                  onPressed: () {
                    {
                      Navigator.pop(context);
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: PRIMARY_COLOR,
                  onPressed: () async {
                    {
                      alertProcesando(context);
                      try {
                        var objeto = {
                          'referencia': producto.uid,
                          'name': producto.name,
                        };
                        String status = await ServicesServicesHTTP()
                            .deleteProducto(
                                producto: objeto, uid: producto.uid);
                        print(status);
                        SnackBar snac = SnackBar(
                          content: BounceInRight(
                            duration: Duration(milliseconds: 3000),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        scaffoldKey.currentState.showSnackBar(snac);
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
                        scaffoldKey.currentState.showSnackBar(snac);
                      }

                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[],
          );
        });
  }

  alertConfirmDeleteUser(
      {BuildContext context,
      ModelUser2 userDelete,
      StatusBloc statusBloc,
      ModelUser2 user}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Está seguro de eliminar al usuario?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: PRIMARY_COLOR,
                  onPressed: () {
                    {
                      Navigator.pop(context);
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: PRIMARY_COLOR,
                  onPressed: () async {
                    {
                      alertProcesando(context);
                      try {
                        var objeto = {
                          'nameUser': user.name,
                          'uidUser': user.uid,
                          'idUserDelete': userDelete.id,
                          'uidDelete': userDelete.uid,
                          'nameUserDelte': userDelete.name,
                        };
                        String status = await ServicesServicesHTTP().deleteUser(
                            userDelete: objeto, uid: userDelete.uid);
                        print(status);
                        SnackBar snac = SnackBar(
                          content: BounceInRight(
                            duration: Duration(milliseconds: 3000),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        statusBloc.globalKey.currentState.showSnackBar(snac);
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
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[],
          );
        });
  }

  alertDateSave(
      {StatusBloc statusBloc,
      BuildContext context,
      List<ProductDetalle> listProductoDetalle,
      String idCliente,
      String idEmployee}) {
    return showDialog(
        context: context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            content: _buildSuccessService(),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Imprimir Factura",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () async {
                  {
                    // Navigator.pop(_context);
                    // Navigator.pop(_context);
                    // statusBloc.setVentaRealizada = true;
                    // printFactura();

                  }
                },
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () async {
                  {
                    Navigator.pop(_context);
                    Navigator.pop(_context);
                    statusBloc.setVentaRealizada = true;
                  }
                },
              ),
            ],
          );
        });
  }

  alertProcesando(BuildContext _context) {
    return showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RefreshProgressIndicator(),
                Divider(
                  height: 15,
                ),
                Text(
                  "Procesando....",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 18.0),
                ),
              ],
            ),
          );
        });
  }
}
