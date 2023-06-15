import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/models/venta_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:dondelucho/ui/widgets/PrintPos.dart';
import 'package:dondelucho/ui/widgets/ValidateInternet.dart';
import 'package:provider/provider.dart';

class BuscarFactura extends StatefulWidget {
  const BuscarFactura({Key key}) : super(key: key);

  @override
  _BuscarFacturaState createState() => _BuscarFacturaState();
}

class _BuscarFacturaState extends State<BuscarFactura> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  StatusBloc _statusBloc;
  List<modeloVenta> _listVentas = [];
  ModelUser2 _user;
  ModelUser2 _cliente;
  Establecimiento establecimiento;
  ModelEstablecimientos establecimientos;

  String sede;
  String codigo;

  List<ProductDetalle> _listProductosDetalleVenta1 = [];

  TextEditingController _codigo = TextEditingController();

  bool _loading = false;
  String _filtrado = 'Buscar factura por ...';
  List<String> opction = [
    'Identificación del cliente',
    'Número de factura',
    'Código del producto'
  ];

  @override
  void initState() {
    super.initState();
    sesion();
  }

  sesion() async {
    _user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();

    if (_user.rol == 'SUPERADMIN') {
      sede = establecimientos.establecimientos[0].name;
      codigo = establecimientos.establecimientos[0].codigo;
      establecimiento = establecimientos.establecimientos[0];
    } else {
      codigo = _user.sede;
      for (var i = 0; i < establecimientos.establecimientos.length; i++) {
        if (establecimientos.establecimientos[i].codigo == codigo) {
          establecimiento = establecimientos.establecimientos[i];
        }
      }
    }
  }

  void validador({String product}) async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      String id;
      AlertWidget().alertProcesando(context);

      if (_filtrado == 'Buscar factura por ...') {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Favor seleccionar como desea filtrar su factura',
              textAlign: TextAlign.center,
            ),
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snac);
      } else {
        if (_filtrado == 'Identificación del cliente') {
          id = '1';
        } else if (_filtrado == 'Número de factura') {
          id = '2';
        } else {
          id = '3';
        }

        try {
          var objeto = {
            'codigo': _codigo.text,
          };
          Map status = await ServicesServicesHTTP()
              .filtrarVentas(codigo: objeto, id: id);
          if (status['status'] != 'Error') {
            if (status['data'].length > 0) {
              _listVentas = status['data'];
            } else {
              SnackBar snac = SnackBar(
                content: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: Text(
                    '>>>> No se encontraron facturas para esta especificación <<<<',
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
      }

      Navigator.pop(context);
      setState(() {
        _loading = false;
      });
    } else {
      print('No es valido');
      setState(() {
        _loading = false;
      });
    }
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
            Text('Seleccione como desea buscar la factura',
                style: dondeluchoAppTheme.title),
            filtroPor(),
            _buildProductosEncontrado(),
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

  Widget filtroPor() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: FittedBox(
        fit: BoxFit.contain,
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
              //margin: EdgeInsets.fromLTRB(5, 0, 5.0, 5.0),
              child: opction.length < 1
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButton(
                      //isExpanded: false,
                      style: TextStyle(color: PRIMARY_COLOR),
                      items: opction.map((element) {
                        return DropdownMenuItem(
                          // onTap: () {
                          //   //print(element.ref.path);
                          //   _categoryServices = element;
                          // },
                          value: element,
                          child: Text(element),
                        );
                      }).toList(),
                      hint: Text(
                        _filtrado,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      onChanged: (dato) {
                        setState(() {
                          _filtrado = dato;
                        });
                      }),
            ),
            //),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosEncontrado() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    onEditingComplete: () => validador(product: _codigo.text),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido:';
                      }
                      return null;
                    },
                    controller: _codigo,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20.0,
                      // fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                        icon: Icon(Icons.qr_code_rounded, color: PRIMARY_COLOR),
                        hintText: 'Ingrese número',
                        labelText: 'Ingrese número'),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      validador(product: _codigo.text);
                    },
                    icon: Icon(
                      Icons.search_sharp,
                      size: 45,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildListaVentas(List<modeloVenta> listVentas) {
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
                            "Fecha:  (${new DateTime.fromMillisecondsSinceEpoch(ventas.fechaVenta)})",
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
                      trailing: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () async {
                            if (await validateIntenrnet()) {
                              AlertWidget().alertProcesando(context);
                              ModelUser2 client = await ServicesServicesHTTP()
                                  .buscarUsuario(idUser: ventas.idCliente);
                              Navigator.pop(context);
                              _listProductosDetalleVenta1 = [];
                              _listProductosDetalleVenta1 =
                                  ventas.listProductosDetalle;
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PDFScreen(
                                          establecimiento: establecimiento,
                                          listProductoDetalleConDescuento:
                                              _listProductosDetalleVenta1,
                                          descuento: ventas.descuento,
                                          nFactura: ventas.numeroFactura,
                                          total: ventas.total,
                                          total2:
                                              ventas.total - ventas.descuento,
                                          vendedor: ventas.idEmployee,
                                          cliente: client,
                                          vueltas: {'vueltas': 0, 'dinero': 0},
                                        )),
                              );
                            } else {
                              SnackBar snac = SnackBar(
                                content: BounceInRight(
                                  duration: Duration(milliseconds: 3000),
                                  child: Text(
                                    'Sin conexión a internet, vuelva a intentarlo.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                              _scaffoldKey.currentState.showSnackBar(snac);
                            }
                          },
                          color: Colors.blue,
                          icon: Icon(Icons.picture_as_pdf_sharp),
                          iconSize: 150,
                        ),
                      ),
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
