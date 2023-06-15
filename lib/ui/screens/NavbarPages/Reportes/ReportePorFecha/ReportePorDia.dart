import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/models/venta_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../app_theme.dart';
import '../../../../../constant.dart';
import '../../../SettingSharepreferences.dart';

class ReportePorDia extends StatefulWidget {
  ReportePorDia({Key key}) : super(key: key);

  @override
  _ReportePorDiaState createState() => _ReportePorDiaState();
}

class _ReportePorDiaState extends State<ReportePorDia> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Size _size;

  String daySeleted;
  DateTime selectDay = DateTime.now();
  String fecha = '';

  List<modeloVenta> _listVentas = [];
  List<ProductDetalle> _listProductosDetalle = [];
  List<ProductDetalle> _listProductosDetalleTotal = [];

  ModelUser2 _user;
  String sede;
  String codigo;
  ModelEstablecimientos establecimientos;
  num total = 0;
  num invertido = 0;
  num caja = 0;
  num descuento = 0;

  @override
  void initState() {
    super.initState();
    initSesion();
  }

  @override
  void dispose() {
    super.dispose();

    //buscarReporte();
  }

  initSesion() async {
    _user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    if (_user?.rol == 'SUPERADMIN') {
      sede = establecimientos.establecimientos[0].name;
      codigo = establecimientos.establecimientos[0].codigo;
    } else {
      codigo = _user.sede;
    }
    setState(() {
      _user;
      codigo;
      sede;
    });
  }

  buscarReporte({DateTime diaSelect}) async {
    String diaFormat = '${diaSelect.year}-${diaSelect.month}-${diaSelect.day}';
    print(_user.id);
    print(_user.rol);

    var objeto = {
      'establecimiento': codigo,
      'fechaSelect': diaFormat,
      'rol': _user.rol,
      'idemployee': _user.id
    };
    try {
      AlertWidget().alertProcesando(context);
      _listVentas = await ServicesServicesHTTP()
          .reportesPorID(fechaSelect: objeto, id: '1');
      Navigator.pop(context);
      if (_listVentas.length == 0) {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'No se encontraron ventas en el día seleccionado.',
              textAlign: TextAlign.center,
            ),
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snac);
        _listProductosDetalleTotal = [];
        _listProductosDetalle = [];
      }
      setState(() {
        //_buildListVentasDetalle();
        _listVentas;
      });
    } catch (e) {
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 0.2;

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        shape: StadiumBorder(),
                        color: PRIMARY_COLOR,
                        textColor: Colors.white,
                        child: Text('>>> Selecciona fecha <<<'),
                        onPressed: () async {
                          calendart();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Visibility(
                        visible: _user?.rol == 'SUPERADMIN',
                        child: _listSedes())
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  width: size.width,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Stack(
                    //fit: StackFit.expand,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _listVentas.length != 0
                              ? Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Reporte del:  ${selectDay.day} / ${selectDay.month} / ${selectDay.year}  ",
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Text(''),
                          _buildHeard(),
                          Flexible(
                              child: Center(
                            child: Container(
                                padding: EdgeInsets.only(top: 10),
                                // height: ,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    _buildListVentasDetalle(),
                                    _listProductosDetalleTotal.length != 0
                                        ? _user.rol != 'SUPERADMIN'
                                            ? _buildTotalEmployee()
                                            : _buildTotalAdmin()
                                        : Text(''),
                                  ],
                                )),
                          ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _listSedes() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        children: [
          Text(
            'Seleccione lugar para el reporte',
            style: dondeluchoAppTheme.subtitle,
          ),
          Row(
            children: [
              Icon(Icons.home_work, color: PRIMARY_COLOR),
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
                        items: establecimientos?.establecimientos
                            .map((Establecimiento element) {
                          return DropdownMenuItem(
                            onTap: () {
                              setState(() {
                                sede = element?.name;
                                codigo = element?.codigo;
                              });
                            },
                            value: element?.name,
                            child: Text(element?.name),
                          );
                        }).toList(),
                        hint: Text(
                          sede,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onChanged: (dato) {
                          calendart();
                        }),
              ),
              //),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeard() {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.1),
        1: FractionColumnWidth(0.4),
        2: FractionColumnWidth(0.2),
        4: FractionColumnWidth(0.3),
      },
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text(
            'Cantidad',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Producto-Detalle',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Precio al público',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Fecha',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ])
      ],
    );
  }

  Widget _buildListVentasDetalle() {
    descuento = 0;
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: _listVentas.length != 0
            ? _listVentas.map((modeloVenta) {
                descuento = descuento + modeloVenta.descuento;
                return _buildListProductsFactura(
                    listProduct: modeloVenta.listProductosDetalle,
                    venta: modeloVenta);
              }).toList()
            : [Text('')]);
  }

  Widget _buildListProductsFactura(
      {List<ProductDetalle> listProduct, modeloVenta venta}) {
    DateTime fecha = DateTime.fromMillisecondsSinceEpoch(venta.fechaVenta);
    var fechaFormateada =
        '${fecha.year}-${fecha.month}-${fecha.day}  ${fecha.hour}:${fecha.minute}:${fecha.second}';
    return listProduct.length != 0
        ? SizedBox(
            //height: _size.height * 0.5,
            child: Column(
              children: [
                // Text(
                //   '| Cantidad  | Prodducto-Detalle | Valor |',
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 15.0,
                //       fontWeight: FontWeight.bold),
                // ),

                Table(
                  columnWidths: {
                    0: FractionColumnWidth(0.1),
                    1: FractionColumnWidth(0.4),
                    2: FractionColumnWidth(0.2),
                    4: FractionColumnWidth(0.3),
                  },
                  border: TableBorder.all(),
                  children: listProduct.map(
                    (productoDetalle) {
                      _listProductosDetalleTotal.add(productoDetalle);
                      return TableRow(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Center(
                              child: Text(
                                productoDetalle.cant.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //backgroundColor: PRIMARY_COLOR,
                          ),
                          Column(
                            children: [
                              Text(
                                productoDetalle.producto.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                productoDetalle.producto.description,
                                style: dondeluchoAppTheme.subtitle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          // ListTile(
                          //   title: Text(
                          //     productoDetalle.producto.name,
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //         fontSize: 15.0, fontWeight: FontWeight.bold),
                          //   ),
                          //   subtitle: Text(
                          //     productoDetalle.producto.description,
                          //     style: DraviMedicAppTheme.subtitle,
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),

                          Text(
                            " ${money.format(productoDetalle.producto.vPublico)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: dondeluchoAppTheme.primaryColor,
                                fontSize: 16.0),
                          ),
                          Text(
                            fechaFormateada,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: dondeluchoAppTheme.primaryColor,
                                fontSize: 16.0),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
                SizedBox(
                  height: 2.5,
                ),

                // Divider(
                //   color: Colors.black54,
                // ),
                // SizedBox(
                //   height: 35,
                // ),
              ],
            ),
          )
        : Center(
            child: Text(
              "<<<< Reporte sin datos >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }

  Widget _buildTotalEmployee() {
    total = 0;
    invertido = 0;
    caja = 0;
    print(_listProductosDetalleTotal.length);

    for (var i = 0; i < _listProductosDetalleTotal.length; i++) {
      print(_listProductosDetalleTotal[i].cant);
      print(_listProductosDetalleTotal[i].producto.vCompra);
      total = total +
          (_listProductosDetalleTotal[i].cant *
              _listProductosDetalleTotal[i].producto.vPublico);
      invertido = invertido +
          (_listProductosDetalleTotal[i].cant *
              _listProductosDetalleTotal[i].producto.vCompra);
    }
    caja = total - descuento;
    _listProductosDetalleTotal = [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.33),
              1: FractionColumnWidth(0.33),
              2: FractionColumnWidth(0.33),
            },
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Column(
                  children: [
                    Text(
                      'Total ventas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(total)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total descuentos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(descuento)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'En caja',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(caja)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAdmin() {
    total = 0;
    invertido = 0;
    caja = 0;
    print(_listProductosDetalleTotal.length);

    for (var i = 0; i < _listProductosDetalleTotal.length; i++) {
      print(_listProductosDetalleTotal[i].cant);
      print(_listProductosDetalleTotal[i].producto.vCompra);
      total = total +
          (_listProductosDetalleTotal[i].cant *
              _listProductosDetalleTotal[i].producto.vPublico);
      invertido = invertido +
          (_listProductosDetalleTotal[i].cant *
              _listProductosDetalleTotal[i].producto.vCompra);
    }
    caja = total - descuento;
    _listProductosDetalleTotal = [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.25),
              1: FractionColumnWidth(0.25),
              2: FractionColumnWidth(0.25),
              3: FractionColumnWidth(0.25),
            },
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Column(
                  children: [
                    Text(
                      'Total invertido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(invertido)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total en ventas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(total)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total descuentos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(descuento)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'En caja',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${money.format(caja)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ])
            ],
          ),
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.5),
              1: FractionColumnWidth(0.5),
            },
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Text(
                  'Ganancias del día',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${money.format(caja - invertido)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  calendart() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Selecciona fecha:'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime.now(),
                    focusedDay: selectDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: 'es_Col',
                    onDaySelected: (DateTime _seletDay, DateTime focusDay) {
                      setState(() {
                        selectDay = _seletDay;
                        //getHours();
                        print(selectDay);
                      });
                      Navigator.pop(context);
                      validateClave(diaSelect: selectDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectDay, date);
                    },
                    calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                            color: PRIMARY_COLOR, shape: BoxShape.circle)),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ));
        });
  }

  validateClave({DateTime diaSelect}) {
    TextEditingController clave = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void autorizacion() async {
      final form = formKey.currentState;
      if (form.validate()) {
        Navigator.pop(context);
        buscarReporte(diaSelect: diaSelect);
      } else {
        print('No Valido');
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
                                  } else if (value != 'demo') {
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
