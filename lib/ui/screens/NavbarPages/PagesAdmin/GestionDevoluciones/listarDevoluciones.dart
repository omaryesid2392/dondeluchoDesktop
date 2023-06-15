import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/devoluciones_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:provider/provider.dart';

class listarDevolucion extends StatefulWidget {
  const listarDevolucion({Key key}) : super(key: key);

  @override
  _listarDevolucionState createState() => _listarDevolucionState();
}

class _listarDevolucionState extends State<listarDevolucion> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  StatusBloc _statusBloc;
  List<modeloDevolucion> _listVentas = [];
  ModelUser2 _user;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      listaDevoluciones();
    }
  }

  listaDevoluciones() async {
    await Future.delayed(Duration(seconds: 2));
    AlertWidget().alertProcesando(context);
    try {
      var status = await ServicesServicesHTTP().listarDevoluciones();
      if (status['status'] != 'Error') {
        if (status['data'].length > 0) {
          _listVentas = status['data'];
        } else {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                '>>>> No se encontraron facturas devueltas en el momento <<<<',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
        }

        setState(() {
          _listVentas;
        });
      } else {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              status['data'],
              textAlign: TextAlign.center,
            ),
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snac);
      }
    } catch (e) {
      print(e);
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _statusBloc = Provider.of<StatusBloc>(context);

    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
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
      width: MediaQuery.of(context).size.width * 0.8,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Lista de devoluciones recientes',
                style: dondeluchoAppTheme.title),
            //filtroPor(),
            // _buildProductosEncontrado(),
            SingleChildScrollView(
              child: Visibility(
                  visible: _listVentas.length != 0,
                  child: _buildListaVentas(_listVentas)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaVentas(List<modeloDevolucion> listVentas) {
    return listVentas.length != 0
        ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
                children: listVentas.map(
              (ventas) {
                //_listServicesAgent[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.production_quantity_limits),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Id cliente: ${ventas.idCliente}',
                            style: dondeluchoAppTheme.title,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Vendedor: ${ventas.idVendedor}',
                          //   style: dondeluchoAppTheme.subtitle,
                          //   textAlign: TextAlign.center,
                          // ),
                          // Text(
                          //   'Productos',
                          //   style: dondeluchoAppTheme.subtitle,
                          //   textAlign: TextAlign.center,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                ventas.listProductosDetalle.map((producto) {
                              return ListTile(
                                leading: Text(producto.cant.toString()),
                                title: Text(producto.producto.name +
                                    '\n' +
                                    producto.producto.description),
                                subtitle: Text(
                                  "Precio: ${money.format(producto.producto?.vPublico)}",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 12.0),
                                ),
                              );
                            }).toList(),
                          ),
                          Text(
                            "Fecha venta:  (${new DateTime.fromMillisecondsSinceEpoch(num.parse(ventas.fechaVenta))})",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                          Text(
                            "Fecha devolución:  (${new DateTime.fromMillisecondsSinceEpoch(ventas.fechaDevolucion)})",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Descuento: ${money.format(ventas?.descuento)}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.0),
                              ),
                              VerticalDivider(
                                color: Colors.redAccent,
                              ),
                              Text(
                                "Total: ${money.format(ventas.total - ventas.descuento)}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.0),
                              ),
                            ],
                          )
                          // FittedBox(
                          //   fit: BoxFit.contain,
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "vC: ${money.format(ventas?.vCompra)}  ",
                          //         style: TextStyle(
                          //             color: dondeluchoAppTheme.primaryColor,
                          //             fontSize: 16.0),
                          //       ),
                          //       Text(
                          //         "vmV: ${money.format(ventas?.vMinVenta)}  ",
                          //         style: TextStyle(
                          //             color: dondeluchoAppTheme.primaryColor,
                          //             fontSize: 16.0),
                          //       ),
                          //       Text(
                          //         "vP: ${money.format(ventas?.vPublico)}",
                          //         style: TextStyle(
                          //             color: dondeluchoAppTheme.primaryColor,
                          //             fontSize: 16.0),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Text(
                          //   'Stock: ' + ventas.cant.toString(),
                          //   style: TextStyle(color: Colors.red, fontSize: 18.0),
                          // ),
                        ],
                      ),
                      // trailing: FittedBox(
                      //   fit: BoxFit.contain,
                      //   alignment: Alignment.center,
                      //   child: IconButton(
                      //       onPressed: () async {
                      //         await AlertWidget().aletFacturaDelete(
                      //             context, ventas, _scaffoldKey);

                      //         _listVentas.removeWhere((element) =>
                      //             element.numeroFactura ==
                      //             ventas.numeroFactura);
                      //         setState(() {
                      //           _listVentas;
                      //         });
                      //       },
                      //       color: Colors.red,
                      //       icon: Icon(Icons.delete)),
                      // ),
                    ),
                    Divider(
                      color: Colors.black54,
                    )
                  ],
                );
              },
            ).toList()),
          )
        : Center(
            child: Text(
              "<<<< Listado Vacío >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }
}
