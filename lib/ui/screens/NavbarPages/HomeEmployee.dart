import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesEmployee/ventasDetalle.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:provider/provider.dart';

import 'dart:math';
import '../../../session.dart';
import '../SettingSharepreferences.dart';

class HomeEmployee extends StatefulWidget {
  final AnimationController animationController;

  HomeEmployee({Key key, this.animationController}) : super(key: key);

  _HomeEmployeeState createState() => _HomeEmployeeState();
}

class _HomeEmployeeState extends State<HomeEmployee>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  final _formKey = GlobalKey<FormState>();

  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool searh = false;
  List<ProductModel> _listProductos = [];
  List<ProductDetalle> _listProductosDetalleSinFacturar = [];
  ModelEstablecimientos establecimientos;

  StatusBloc statusBloc;
  Size _size;
  TextEditingController _codBarra = TextEditingController();
  TextEditingController _cant = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  ModelUser2 _user;

  var rng = new Random();
  String nFactura;

  @override
  void initState() {
    super.initState();

    initSession();
  }

  initSession() async {
    _user = await SessionSharepreferences().getUser();
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {
      _user;
      establecimientos;
    });
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      print('Valido');
      AlertWidget().alertProcesando(context);
      await listarProduct(_codBarra.text);
      setState(() {
        searh = true;
      });
      Navigator.pop(context);
      if (_listProductos.length > 0) {
        for (var i = 0; i < _listProductos.length; i++) {
          print(_listProductos[i].sede);
          print(_user.sede);
          if (_listProductos[i].sede == _user.sede) {
            _agregarProductoFactura(producto: _listProductos[i]);
          }
        }
      }
    } else {
      print('No Valido');
    }
  }

  Future<void> listarProduct(String product) async {
    // print('-------->   '+ product);
    _listProductos =
        await ServicesServicesHTTP().buscarProducto(producto: product);
    print('-------->   ' + _listProductos.toString());
    // print(_listProductos[0].codProduct);
    if (_listProductosDetalleSinFacturar.length > 0 &&
        _listProductos.length > 0) {
      for (var i = 0; i < _listProductosDetalleSinFacturar.length; i++) {
        for (var index = 0; index < _listProductos.length; index++) {
          if (_listProductosDetalleSinFacturar[i].producto.codProduct ==
                  _listProductos[index].codProduct &&
              _listProductosDetalleSinFacturar[i].producto.sede ==
                  _listProductos[index].sede) {
            _listProductos[index].cant = _listProductos[index].cant -
                _listProductosDetalleSinFacturar[i].cant;
          }
        }
      }
    }

    setState(() {
      _listProductos;
    });
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);
    if (statusBloc.ventaRealizada) {
      _listProductos = [];
      _listProductosDetalleSinFacturar = [];
      statusBloc.setVentaRealizada = false;
    }
    _size = MediaQuery.of(context).size;
    if (_codBarra.text.isNotEmpty) {
      print('object');
    }

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          home(),
          Form(
            key: _formKey,
            child: _searchProduct(),
          ),
          _buildFactura()
        ],
      ),
    );
  }

  Widget _searchProduct() {
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
      width: _size.width * 0.45,
      height: _size.height * 0.8,
      child: Column(
        children: [
          Text('Producto', style: dondeluchoAppTheme.title),
          _buildListProductosEncontrados()
        ],
      ),
    );
  }

  Widget _buildListProductosEncontrados() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: _size.width * 0.3,
              // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: TextFormField(
                onEditingComplete: () => validador(),
                validator: (value) {
                  if (value.isEmpty) {
                    // se valida si el Email esta vacio
                    return 'Campo requerido:';
                  }

                  return null;
                },
                controller: _codBarra,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.qr_code_rounded, color: PRIMARY_COLOR),
                    hintText: 'Ingrese Codigo Producto',
                    labelText: 'Ingrese Codigo Producto'),
              ),
            ),
            IconButton(
                onPressed: () {
                  validador();
                },
                icon: Icon(
                  Icons.search_sharp,
                  size: 45,
                )),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        _buildListProducts(_listProductos),
      ],
    );
  }

  Widget _buildFactura() {
    return Stack(
      children: [
        Container(
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
          width: _size.width * 0.3,
          // height: _size.height * 0.8,
          child: Column(
            children: [
              Text(
                'Factura',
                style: dondeluchoAppTheme.title,
              ),
              SizedBox(
                height: 15,
              ),
              _buildListProductsFactura(
                  listProduct: _listProductosDetalleSinFacturar)
            ],
          ),
        ),
        Visibility(
          visible: _listProductosDetalleSinFacturar.length != 0,
          child: Positioned(bottom: 15, child: Center(child: _btnFacturar())),
        ),
      ],
    );
  }

  Widget _buildListProducts(List<ProductModel> listProduct) {
    return listProduct.length != 0
        ? Column(
            children: listProduct.map(
            (productos) {
              //_listServicesAgent[index];
              Establecimiento sede;
              for (var i = 0;
                  i < establecimientos.establecimientos.length;
                  i++) {
                if (establecimientos.establecimientos[i].codigo ==
                    productos.sede) {
                  sede = establecimientos.establecimientos[i];
                }
              }
              return GestureDetector(
                onTap: () {
                  if (productos.sede != _user.sede &&
                      _user.rol != 'SUPERADMIN') {
                    SnackBar snac = SnackBar(
                      content: BounceInRight(
                        duration: Duration(milliseconds: 3000),
                        child: Text(
                          'Usted no tiene permisos para vender éste producto',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snac);
                  } else {
                    _agregarProductoFactura(producto: productos);
                  }
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.production_quantity_limits),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      title: Text(
                        productos?.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            'Sede: ' + sede.name.toUpperCase(),
                            style: dondeluchoAppTheme.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            productos.description,
                            style: dondeluchoAppTheme.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Proveedor: ' + productos.proveedor.toString(),
                            style: dondeluchoAppTheme.subtitle,
                          ),
                          Text(
                            " ${money.format(productos?.vPublico)}",
                            style: TextStyle(
                                color: dondeluchoAppTheme.primaryColor,
                                fontSize: 16.0),
                          )
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Stock \n ${productos.cant}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: dondeluchoAppTheme.primaryColor,
                              fontSize: 16.0),
                        ),
                        // child: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: <Widget>[
                        //     IconButton(
                        //         onPressed: () async {
                        //           _agregarProductoFactura(producto: productos);
                        //         },
                        //         color: PRIMARY_COLOR,
                        //         icon: Icon(Icons.save_alt)),
                        //   ],
                        // ),
                      ),
                    ),
                    Divider(
                      color: Colors.black54,
                    )
                  ],
                ),
              );
            },
          ).toList())
        : Center(
            child: _listProductos.length == 0 && searh == false
                ? Text(
                    "<<<< Esperando productos >>>>",
                    style: TextStyle(color: PRIMARY_COLOR),
                  )
                : Text(
                    "<<<< Producto no encontrado >>>>",
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
          );
  }

  Widget _buildListProductsFactura(
      {List<ProductDetalle> listProduct, BuildContext context2}) {
    return listProduct.length != 0
        ? SizedBox(
            height: context2 == null
                ? _size.height * 0.7
                : MediaQuery.of(context2).size.height * 0.6,
            child: ListView(
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
                    0: FractionColumnWidth(0.2),
                    1: FractionColumnWidth(0.4),
                    2: FractionColumnWidth(0.3),
                    4: FractionColumnWidth(0.1),
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      Text(
                        'Cantidad',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Producto-Detalle',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Valor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ])
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Table(
                  columnWidths: {
                    0: FractionColumnWidth(0.1),
                    1: FractionColumnWidth(0.5),
                    2: FractionColumnWidth(0.3),
                    4: FractionColumnWidth(0.1),
                  },
                  border: TableBorder.all(),
                  children: listProduct.map(
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

                          Center(
                            child: Text(
                              " ${money.format(productoDetalle.producto.vPublico)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: dondeluchoAppTheme.primaryColor,
                                  fontSize: 16.0),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                _listProductosDetalleSinFacturar.removeWhere(
                                    (element) => element == productoDetalle);
                                setState(() {});
                              },
                              color: Colors.red,
                              icon: Icon(Icons.delete)),
                          // Divider(
                          //   color: Colors.black54,
                          // )
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
              ],
            ),
          )
        : Center(
            child: Text(
              "<<<< Factura sin productos >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }

  Widget _buildTotal() {
    num total = 0;
    for (var i = 0; i < _listProductosDetalleSinFacturar.length; i++) {
      total = total +
          (_listProductosDetalleSinFacturar[i].cant *
              _listProductosDetalleSinFacturar[i].producto.vPublico);
    }

    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.4),
        1: FractionColumnWidth(0.4),
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

  Widget _btnFacturar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => facturarVentasDetalle(
                        listProductoParamt: _listProductosDetalleSinFacturar)),
              );
            },
            padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
            child: Text('Facturar'),
            shape: StadiumBorder(),
            color: PRIMARY_COLOR,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  _agregarProductoFactura({ProductModel producto}) {
    final formKey = GlobalKey<FormState>();
    ProductDetalle productDetalle;
    String sede = '';
    for (var i = 0; i < establecimientos.establecimientos.length; i++) {
      if (establecimientos.establecimientos[i].codigo == producto.sede) {
        sede = establecimientos.establecimientos[i].name;
      }
    }

    void validateCantidad() async {
      final form = formKey.currentState;
      if (form.validate()) {
        print('Valido');
        productDetalle = ProductDetalle.fromMap2({
          'cant': num.parse(_cant.text),
          'producto': producto,
        });
        for (var index = 0; index < _listProductos.length; index++) {
          if (_listProductos[index].sede == producto.sede) {
            _listProductos[index].cant =
                _listProductos[index].cant - productDetalle.cant;
          }
        }

        bool validate = false;
        for (var i = 0; i < _listProductosDetalleSinFacturar.length; i++) {
          if (_listProductosDetalleSinFacturar[i].producto.codProduct ==
              productDetalle.producto.codProduct) {
            print(_listProductosDetalleSinFacturar[i].cant);
            _listProductosDetalleSinFacturar[i].cant =
                _listProductosDetalleSinFacturar[i].cant + productDetalle.cant;
            validate = true;
            print(_listProductosDetalleSinFacturar[i].cant);
          }
        }
        if (!validate) {
          _listProductosDetalleSinFacturar.add(productDetalle);
        }

        _buildListProductsFactura(
            listProduct: _listProductosDetalleSinFacturar);

        _cant.text = '';
        setState(() {});
        Navigator.pop(context);
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
              title: Text("Agregar producto a la factura",
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
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              producto.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25.0),
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                  'Descripción: ' + producto.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'Sede: ' + sede.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  'Stock: ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  producto.cant.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextFormField(
                              style: TextStyle(fontSize: 70),
                              onEditingComplete: () => validateCantidad(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // inputFormatters: <TextInputFormatter>[
                              //   WhitelistingTextInputFormatter.digitsOnly
                              // ],
                              validator: (value) {
                                final intNumber = int.tryParse(value);
                                if (value.isEmpty) {
                                  return 'Campo requerido:';
                                } else if (num.parse(value) > producto.cant) {
                                  return 'la cantidad supera el Stock actual';
                                } else if (num.parse(value) == 0) {
                                  return 'la cantidad debe ser mayor a 0';
                                }

                                return null;
                              },
                              controller: _cant,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                icon: Icon(Icons.add_shopping_cart,
                                    color: PRIMARY_COLOR),
                                hintText: 'Cantidad',
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
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "AGREGAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                color: PRIMARY_COLOR,
                                onPressed: () {
                                  validateCantidad();
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
          );
        });
  }
}
