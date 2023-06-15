import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:dondelucho/ui/widgets/PrintPos.dart';
import 'package:dondelucho/ui/widgets/ValidateInternet.dart';
import 'package:provider/provider.dart';

import '../../../../app_theme.dart';
import '../../SettingSharepreferences.dart';

class facturarVentasDetalle extends StatefulWidget {
  final List<ProductDetalle> listProductoParamt;
  facturarVentasDetalle({Key key, this.listProductoParamt}) : super(key: key);

  @override
  State<facturarVentasDetalle> createState() => _facturarVentasDetalleState();
}

class _facturarVentasDetalleState extends State<facturarVentasDetalle> {
  List<ProductDetalle> _listProductosDetalleVenta1 = [];
  //List<ProductDetalle> _listProductosDetalleVenta2 = [];
  var rng = new Random();
  String nFactura;

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey();

  StatusBloc statusBloc;
  Size _size;
  TextEditingController _idCliente = TextEditingController();
  TextEditingController _descuentos = TextEditingController();

  ModelUser2 _cliente;
  ModelUser2 _user;
  String sede;
  String codigo;

  ModelEstablecimientos establecimientos;
  Establecimiento establecimiento;

  num total = 0;
  num total2 = 0;
  num vueltas = 0;
  num descuentoT = 0;

  Map<String, dynamic> Listvueltas = {};
  @override
  void initState() {
    super.initState();

    nFactura = (DateTime.now().year).toString() +
        (DateTime.now().month).toString() +
        (DateTime.now().day).toString() +
        (DateTime.now().minute).toString() +
        (DateTime.now().second).toString() +
        '-' +
        rng.nextInt(10000).toString();
    sesion();
    if (this.mounted) {
      print(widget.listProductoParamt[0].cant);
      _listProductosDetalleVenta1 = widget.listProductoParamt;
      // _listProductosDetalleVenta2 = _listProductosDetalleVenta1;

    }
  }

  @override
  void dispose() {
    super.dispose();
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
    setState(() {
      establecimiento;
      _user;
      codigo;
      sede;
    });
  }

  void validateCantidad() async {
    final form = formKey.currentState;

    if (await validateIntenrnet()) {
      if (form.validate()) {
        bool res = false;
        print('Valido');
        AlertWidget().alertProcesando(context);
        List<Map<String, dynamic>> listProductoDetalleFormateada = [];
        List<String> listCodigoProductos = [];

        for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
          //ProductModel pro = await validateImei(_listProductosDetalleVenta1[i].producto);
          var obj = {
            "cant": _listProductosDetalleVenta1[i].cant,
            "producto": {
              'vCompra': _listProductosDetalleVenta1[i].producto.vCompra,
              'name': _listProductosDetalleVenta1[i].producto.name,
              'codProduct': _listProductosDetalleVenta1[i].producto.codProduct,
              'description':
                  _listProductosDetalleVenta1[i].producto.description,
              'vPublico': _listProductosDetalleVenta1[i].producto.vPublico,
              'imei': _listProductosDetalleVenta1[i].producto.imei,
            }
          };
          listProductoDetalleFormateada.add(obj);
          listCodigoProductos
              .add(_listProductosDetalleVenta1[i].producto.codProduct);
        }
        print(listProductoDetalleFormateada);

        final data = {
          "descuento": descuentoT.toString(),
          "sede": codigo,
          "numeroFactura": nFactura,
          "idCliente": _cliente.id,
          "idEmployee": _user.id,
          "total": total.toString(),
          "listProductoDetalle": jsonEncode(listProductoDetalleFormateada),
          "listCodigoProductos": jsonEncode(listCodigoProductos),
          "vueltas": jsonEncode(Listvueltas),
        };
        res = await ServicesServicesHTTP().createNewVenta(detalleVenta: data);
        //res = true;
        if (res) {
          Navigator.pop(context);
          if (Listvueltas['vueltas'] == null) {
            Listvueltas = {'vueltas': 0, 'dinero': 0};
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PDFScreen(
                      establecimiento: establecimiento,
                      listProductoDetalleConDescuento:
                          _listProductosDetalleVenta1,
                      descuento: descuentoT,
                      nFactura: nFactura,
                      total: total,
                      total2: total2,
                      vendedor: _user.name,
                      cliente: _cliente,
                      vueltas: Listvueltas,
                    )),
          );
          Navigator.pop(context);
          statusBloc.setVentaRealizada = true;
        }
      } else {
        print('No Valido');
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Error al construir la factura.',
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
            'Sin conexión a internet, vuelva a intentarlo.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snac);
    }
  }

  validateImei() async {
    for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
      print(_listProductosDetalleVenta1[i].producto.imei);
      if (_listProductosDetalleVenta1[i].producto.refCategory ==
              'categories/FBcZ8qXx1GWmXtXKs1cd' &&
          _listProductosDetalleVenta1[i].producto.imei == '') {
        await showDialogAddImei(
            producto: _listProductosDetalleVenta1[i].producto, index: i);
      }
      print(i);
      print(_listProductosDetalleVenta1[i].producto.imei);
    }
    save();
  }

  save() {
    bool run = true;
    for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
      print(_listProductosDetalleVenta1[i].producto.imei);
      if (_listProductosDetalleVenta1[i].producto.refCategory ==
              'categories/FBcZ8qXx1GWmXtXKs1cd' &&
          _listProductosDetalleVenta1[i].producto.imei == '') {
        run = false;
      }
    }
    if (run) {
      print('ok ejecuto');
      validateCantidad();
    } else {
      print('ok no ha terminado');
    }
  }

  void showDialogAddImei({ProductModel producto, num index}) {
    final _formKeyNewPacient = GlobalKey<FormState>();
    TextEditingController _imei = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Para continuar agregue el imei del siguiente producto a la factura",
              style: dondeluchoAppTheme.title,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  producto.name + '\n' + producto.description,
                  textAlign: TextAlign.center,
                  style: dondeluchoAppTheme.body1,
                ),
                Form(
                  key: _formKeyNewPacient,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _imei,
                          onSaved: (value) => _imei.text = value,
                          // onEditingComplete: () {
                          //   final form = _formKeyNewPacient.currentState;
                          //   form.save();
                          //   if (form.validate()) {
                          //     _listProductosDetalleVenta1[index].producto.imei =
                          //         _imei.text;
                          //     setState(() {});
                          //     Navigator.pop(context);
                          //     save();
                          //   }
                          // },
                          validator: (value) =>
                              value.length > 0 ? null : 'Campo Requerido',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Ingrese imei",
                            labelStyle: TextStyle(fontSize: 19.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  }),
              FlatButton(
                child: Text("Añadir Imei +"),
                onPressed: () {
                  final form = _formKeyNewPacient.currentState;
                  form.save();
                  if (form.validate()) {
                    _listProductosDetalleVenta1[index].producto.imei =
                        _imei.text;
                    setState(() {});
                    Navigator.pop(context);
                    save();
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);
    _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Factura No: ' + nFactura),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _builsHeadFactura(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            _builsCuerpoFactura(),
                            _calcularVueltas(),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _cliente != null ? _btnSave() : Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listSedes() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        children: [
          Text(
            'Seleccione lugar de la venta',
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
                        items: establecimientos.establecimientos
                            .map((Establecimiento element) {
                          return DropdownMenuItem(
                            onTap: () {
                              setState(() {
                                establecimiento = element;
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
        ],
      ),
    );
  }

  Widget _builsHeadFactura() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Container(
                width: _size.width * 0.4,
                // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
                child: TextFormField(
                  autofocus: true,
                  onEditingComplete: () async {
                    AlertWidget().alertProcesando(context);
                    _cliente = await ServicesServicesHTTP()
                        .buscarUsuario(idUser: _idCliente.text);
                    Navigator.pop(context);
                    print(_cliente?.name);
                    if (_cliente == null) {
                      showDialogNewCliente(idCliente: _idCliente.text);
                    } else {
                      setState(() {});
                    }
                  },
                  keyboardAppearance: Brightness.dark,
                  style: dondeluchoAppTheme.title,
                  // inputFormatters: <TextInputFormatter>[
                  //   WhitelistingTextInputFormatter.digitsOnly
                  // ],

                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo requerido:';
                    }
                    return null;
                  },
                  controller: _idCliente,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person, color: PRIMARY_COLOR),
                      hintText:
                          'Nro de identificación del cliente "press ENTER"',
                      labelText:
                          'Nro de identificación del cliente "press ENTER"'),
                ),
              ),
            ),
            Visibility(visible: _user?.rol == 'SUPERADMIN', child: _listSedes())
          ],
        ),
        Visibility(
          visible: _cliente != null,
          child: _buildCliente(cliente: _cliente),
        )
      ],
    );
  }

  Widget _btnSave() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Finalizar venta",
          style: TextStyle(color: Colors.white),
        ),
      ),
      color: PRIMARY_COLOR,
      onPressed: () => validateImei(),
    );
  }

  Widget _buildCliente({ModelUser2 cliente}) {
    return cliente == null
        ? Text('')
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Cliente: ' + cliente.name,
                style: dondeluchoAppTheme.title,
              ),
            ),
          );
  }

  Widget _calcularVueltas() {
    TextEditingController _money = TextEditingController();

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
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          Text('Calcular vueltas',
              textAlign: TextAlign.center, style: dondeluchoAppTheme.title),
          Row(
            children: [
              Form(
                key: formKey2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    autofocus: true,
                    onEditingComplete: () {
                      validarVueltas(int.parse(_money.text));
                    },
                    keyboardAppearance: Brightness.dark,
                    style: dondeluchoAppTheme.title,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido:';
                      }
                      return null;
                    },
                    controller: _money,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        icon: Icon(Icons.attach_money_outlined,
                            color: PRIMARY_COLOR),
                        hintText: "${money.format(total2)}",
                        labelText: 'Ingrese dinero suministrado'),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    validarVueltas(int.parse(_money.text));
                  },
                  icon: Icon(
                    Icons.search_sharp,
                    size: 35,
                  ))
            ],
          ),
          Text('Vueltas : ${vueltas > 0 ? money.format(vueltas) : " "}',
              textAlign: TextAlign.center, style: dondeluchoAppTheme.title),
        ],
      ),
    );
  }

  validarVueltas(num money) {
    final form = formKey2.currentState;
    if (form.validate()) {
      print('ok');
      if (money < total2) {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Valor ingresado dede ser mayor al total a pagar',
              textAlign: TextAlign.center,
            ),
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snac);
        return;
      }
      vueltas = money - total2;
      Listvueltas = {
        'vueltas': vueltas,
        'dinero': money,
      };
      print(Listvueltas['vueltas']);
      setState(() {
        vueltas;
        Listvueltas;
      });
    } else {
      print('No valido');
    }
  }

  Widget _builsCuerpoFactura() {
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
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.3),
              //4: FractionColumnWidth(0.1),
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
                  'Valor',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ])
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.3),
            },
            border: TableBorder.all(),
            children: _listProductosDetalleVenta1.map(
              (productoDetalle) {
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
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          productoDetalle.producto.description,
                          style: dondeluchoAppTheme.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        descuento(producto: productoDetalle.producto);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " ${money.format(productoDetalle.producto.vPublico)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: dondeluchoAppTheme.primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
          SizedBox(
            height: 15,
          ),
          _buildTotal(),
          SizedBox(
            height: 35,
          ),
          _buildDescuento(),
          SizedBox(
            height: 15,
          ),
          _buildTotal2()
        ],
      ),
    );
  }

  descuento({ProductModel producto}) {
    final formKey3 = GlobalKey<FormState>();
    ProductDetalle productDetalle;

    void validateDescuento() {
      final form = formKey3.currentState;
      if (form.validate()) {
        print('Valido');
        for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
          if (_listProductosDetalleVenta1[i].producto.codProduct ==
              producto.codProduct) {
            num initValue = _listProductosDetalleVenta1[i].producto.vPublico;
            // _listProductosDetalleVenta1[i].producto.vPublico =
            //     int.parse(_descuentos.text);
            descuentoT = _listProductosDetalleVenta1[i].cant *
                (descuentoT + (initValue - int.parse(_descuentos.text)));
            print(descuentoT);
          }
        }
        print(_listProductosDetalleVenta1[0].producto);
        _descuentos.text = '';
        Navigator.pop(context);
        setState(() {});
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
              title: Text("Aplicar descuento al producto seleccionado",
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
              key: _scaffoldKey2,
              body: Form(
                key: formKey3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextFormField(
                                style: TextStyle(fontSize: 35),
                                onEditingComplete: () => validateDescuento(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // inputFormatters: <TextInputFormatter>[
                                //   WhitelistingTextInputFormatter.digitsOnly
                                // ],
                                validator: (value) {
                                  final intNumber = int.tryParse(value);
                                  if (value.isEmpty) {
                                    return 'Campo requerido:';
                                  } else if (num.parse(value) <
                                      producto.vMinVenta) {
                                    return 'Precio mínimo de venta ' +
                                        money.format(producto.vMinVenta);
                                  }

                                  return null;
                                },
                                controller: _descuentos,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    icon: Icon(
                                        Icons
                                            .do_not_disturb_on_total_silence_rounded,
                                        color: PRIMARY_COLOR),
                                    hintText: 'Valor mínimo ' +
                                        money.format(producto.vMinVenta),
                                    labelText: 'Nuevo precio'),
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
                                      "Aplicar descuento",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  color: PRIMARY_COLOR,
                                  onPressed: () {
                                    validateDescuento();
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

  Widget _buildTotal() {
    total = 0;
    for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
      total = total +
          (_listProductosDetalleVenta1[i].cant *
              _listProductosDetalleVenta1[i].producto.vPublico);
    }
    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.45),
        1: FractionColumnWidth(0.45),
      },
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text(
            'Total',
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
    );
  }

  Widget _buildTotal2() {
    total = 0;
    total2 = 0;
    for (var i = 0; i < _listProductosDetalleVenta1.length; i++) {
      total = total +
          (_listProductosDetalleVenta1[i].cant *
              _listProductosDetalleVenta1[i].producto.vPublico);
    }
    total2 = total - descuentoT;
    setState(() {});

    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.45),
        1: FractionColumnWidth(0.45),
      },
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text(
            'Valor a pagar',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Text(
            " ${money.format(total2)}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ])
      ],
    );
  }

  Widget _buildDescuento() {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.45),
        1: FractionColumnWidth(0.45),
      },
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text(
            'Descuento',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Text(
            " ${money.format(descuentoT)}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ])
      ],
    );
  }

  void showDialogNewCliente({String idCliente}) {
    bool _cargando = false;
    final _formKeyNewPacient = GlobalKey<FormState>();
    TextEditingController _id = TextEditingController();
    TextEditingController _nameCustomer = TextEditingController();
    TextEditingController _direction = TextEditingController();
    TextEditingController _celular = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _rol = TextEditingController();
    _rol.text = 'CLIENT';

    _id.text = idCliente;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Registre nuevo cliente",
              style: TextStyle(fontSize: 15.0),
            ),
            content: Form(
              key: _formKeyNewPacient,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // TextFormField(
                    //   onSaved: (value) => _alias = value,
                    //   validator: (value) =>
                    //       value.length > 0 ? null : 'Campo Requerido',
                    //   decoration: InputDecoration(
                    //       labelText: "Alias (Ej. Mi hermano, mi mama)",
                    //       labelStyle: TextStyle(fontSize: 13.0)),
                    // ),
                    TextFormField(
                      controller: _nameCustomer,
                      onSaved: (value) => _nameCustomer.text = value,
                      validator: (value) =>
                          value.length > 0 ? null : 'Campo Requerido',
                      decoration: InputDecoration(
                          labelText: "Nombre Completo",
                          labelStyle: TextStyle(fontSize: 13.0)),
                    ),
                    TextFormField(
                      controller: _id,
                      onSaved: (value) => _id.text = value,
                      validator: (value) =>
                          value.length > 0 ? null : 'Campo Requerido',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Documento de Identidad",
                        labelStyle: TextStyle(fontSize: 13.0),
                      ),
                    ),
                    // TextFormField(
                    //   controller: _email,
                    //   onSaved: (value) => _email.text = value,
                    //   validator: (value) =>
                    //       value.length > 0 ? null : 'Campo Requerido',
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: InputDecoration(
                    //     labelText: "Correo electrónico",
                    //     labelStyle: TextStyle(fontSize: 13.0),
                    //   ),
                    // ),
                    TextFormField(
                      controller: _celular,
                      onSaved: (value) => _celular.text = value,
                      validator: (value) =>
                          value.length > 0 ? null : 'Campo Requerido',
                      decoration: InputDecoration(
                          labelText: "Número de celular",
                          labelStyle: TextStyle(fontSize: 13.0),
                          suffixIcon: Icon(Icons.phone)),
                    ),
                    // TextFormField(
                    //   controller: _direction,
                    //   onSaved: (value) => _direction.text = value,
                    //   validator: (value) =>
                    //       value.length > 0 ? null : 'Campo Requerido',
                    //   decoration: InputDecoration(
                    //       labelText: "Dirección",
                    //       labelStyle: TextStyle(fontSize: 13.0),
                    //       suffixIcon: Icon(Icons.location_on)),
                    // )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: _cargando == false
                    ? Text("Añadir Cliente +")
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Divider(
                              height: 15,
                            ),
                            Text(
                              "Procesando....",
                              style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  decoration: TextDecoration.none,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),
                //color: PRIMARY_COLOR,
                textColor: PRIMARY_COLOR,
                onPressed: () async {
                  _cargando = true;
                  final form = _formKeyNewPacient.currentState;
                  form.save();
                  if (form.validate()) {
                    var user = {
                      'cel': _celular.text,
                      'name': _nameCustomer.text,
                      'email': _email.text,
                      'rol': _rol.text,
                      'id': _id.text,
                      'direction': _direction.text,
                    };
                    AlertWidget().alertProcesando(context);
                    String status =
                        await ServicesServicesHTTP().createUsuario(user: user);
                    if (status != 'Error') {
                      _cliente = ModelUser2.fromMap(user);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);

                    setState(() {});
                  }
                },
              )
            ],
          );
        });
  }
}
