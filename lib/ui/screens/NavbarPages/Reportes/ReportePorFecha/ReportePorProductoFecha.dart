import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/models/venta_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../SettingSharepreferences.dart';

//import 'package:file_picker/file_picker.dart';

class ReportePorProductoFecha extends StatefulWidget {
  const ReportePorProductoFecha({
    Key key,
  }) : super(key: key);

  @override
  _ReportePorProductoFechaState createState() =>
      _ReportePorProductoFechaState();
}

class _ReportePorProductoFechaState extends State<ReportePorProductoFecha> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  Size _size;
  final _controllerFecha = TextEditingController();
  final _controllerCodigoProducto = TextEditingController();

  List<modeloVenta> _listVentas = [];
  List<ProductDetalle> _listProductosDetalle = [];
  List<ProductDetalle> _listProductosDetalleTotal = [];
  DateTime _fechaSelec = DateTime.now();
  String _fecha;
  bool _loading = false;
  ModelUser2 _user;

  @override
  void initState() {
    super.initState();
    initSesion();
  }

  initSesion() async {
    _user = await SessionSharepreferences().getUser();
    setState(() {
      _user;
    });
  }

  buscarReporte({DateTime fechaSelect}) async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      String fechaFormat =
          '${fechaSelect.year}-${fechaSelect.month}-${fechaSelect.day}';
      var objeto = {
        'codigoProducto': _controllerCodigoProducto.text,
        'fechaSelect': fechaFormat
      };
      try {
        AlertWidget().alertProcesando(context);
        _listVentas = await ServicesServicesHTTP()
            .reportesPorID(fechaSelect: objeto, id: '3');
        print(_listVentas.length);
        Navigator.pop(context);
        if (_listVentas.length == 0) {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'No se encontraron ventas del producto en el mes seleccionado.',
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
    } else {
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Fecha y código de producto requeridos',
            textAlign: TextAlign.center,
          ),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snac);
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
          key: _formKey,
          // asignamos una key al formulario creada globalmente en el constructor del widget
          child: SingleChildScrollView(child: _buildForm())),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: _reportPorProducto(),
          ),
          divider(),
          _builCuerpo()
        ],
      ),
    );
  }

  Widget _builCuerpo() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      width: _size.width,
      height: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _listVentas.length != 0
              ? Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Reporte del:  ${_fechaSelec.month} / ${_fechaSelec.year}  ",
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
                            ? Text('')
                            : _buildTotal()
                        : Text(''),
                  ],
                )),
          ))
        ],
      ),
    );
  }

  Widget _buildHeard() {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.1),
        1: FractionColumnWidth(0.4),
        2: FractionColumnWidth(0.3),
        4: FractionColumnWidth(0.2),
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
            'Valor venta',
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
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: _listVentas.length != 0
              ? _listVentas.map((modeloVenta) {
                  return _buildListProductsFactura(
                      listProduct: modeloVenta.listProductosDetalle,
                      venta: modeloVenta);
                }).toList()
              : [Text('')]),
    );
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
                    2: FractionColumnWidth(0.3),
                    4: FractionColumnWidth(0.2),
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
                          // IconButton(
                          //     onPressed: () async {
                          //       _listProductosDetalle.removeWhere(
                          //           (element) => element == productoDetalle);
                          //       setState(() {});
                          //     },
                          //     color: Colors.red,
                          //     icon: Icon(Icons.delete)),
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

  Widget _buildTotal() {
    num total = 0;
    num invertido = 0;
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
    _listProductosDetalleTotal = [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.3),
              2: FractionColumnWidth(0.2),
              3: FractionColumnWidth(0.3),
            },
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Text(
                  'Valor invertido',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${money.format(invertido)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total en ventas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${money.format(total)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                  'Ganancias del mes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${money.format(total - invertido)}",
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

  Widget _btnBuscar() {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.3,
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: _controllerFecha.text == ''
            ? Text('Seleccione mes')
            : !_loading
                ? Text('Buscar')
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
        onPressed: () {
          // buscarReporte();
        },
      ),
    );
  }

  Widget _reportPorProducto() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    calendart();
                  },
                  child: Container(
                    child: TextFormField(
                      enabled: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo requerido';
                        }
                        return null;
                      },
                      controller: _controllerFecha,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today_sharp,
                              color: PRIMARY_COLOR),
                          hintText: '> Seleccione mes <',
                          labelText: '> Seleccione mes <'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          child: TextFormField(
            onEditingComplete: () => validateClave(fechaSelect: _fechaSelec),
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo requerido';
              }
              return null;
            },
            controller: _controllerCodigoProducto,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
                icon: Icon(Icons.shopping_cart_outlined, color: PRIMARY_COLOR),
                hintText: 'Ingrese código de producto',
                labelText: 'Ingrese código de producto'),
          ),
        ),
        IconButton(
            onPressed: () {
              validateClave(fechaSelect: _fechaSelec);
            },
            icon: Icon(
              Icons.search_sharp,
              size: 45,
            ))
      ],
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
                    focusedDay: _fechaSelec,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: 'es_Col',
                    onDaySelected: (DateTime _seletDay, DateTime focusDay) {
                      setState(() {
                        _fechaSelec = _seletDay;
                        //getHours();
                        print(_fechaSelec);
                      });
                      _fecha = DateFormat.yMMMM('es_ES').format(_fechaSelec);
                      _controllerFecha.text = _fecha;

                      Navigator.pop(context);
                      //buscarReporte(fechaSelect: _fechaSelec);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(_fechaSelec, date);
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

  validateClave({DateTime fechaSelect}) {
    TextEditingController clave = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void autorizacion() async {
      final form = formKey.currentState;
      if (form.validate()) {
        Navigator.pop(context);
        buscarReporte(fechaSelect: fechaSelect);
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
                                obscureText: true,
                                keyboardType: TextInputType.text,
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

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
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
