import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:dondelucho/ui/widgets/ValidateInternet.dart';
import 'package:provider/provider.dart';

import '../../../../../app_theme.dart';
import '../../../SettingSharepreferences.dart';

class DeleteProducto extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  final Animation animation;
  final ProductModel product;

  DeleteProducto(
      {Key key,
      this.animationController,
      this.animation,
      this.product,
      this.scaffoldKey})
      : super(key: key);

  @override
  _DeleteProductoState createState() => _DeleteProductoState();
}

class _DeleteProductoState extends State<DeleteProducto> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _loading = false;
  List<ProductModel> _listProductos = [];
  StatusBloc statusBloc;
  ModelEstablecimientos establecimientos;

  TextEditingController _codBarra = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buscarSede();
  }

  _buscarSede() async {
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {
      establecimientos;
    });
  }

  void _buscarProducto() async {
    try {
      _listProductos =
          await ServicesServicesHTTP().buscarProducto(producto: _codBarra.text);
      print(_listProductos[0].name);

      setState(() {
        _listProductos;
      });
    } catch (e) {
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Producto no encontrado',
            textAlign: TextAlign.center,
          ),
        ),
      );
      statusBloc.globalKey.currentState.showSnackBar(snac);
    }
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      setState(() {
        _loading = true;
      });
      print('Valido');
      String status;
      AlertWidget().alertProcesando(context);
      await _buscarProducto();
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
    statusBloc = Provider.of<StatusBloc>(context);

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
            _searchProduct(),
            Visibility(
              visible: _listProductos.length != 0,
              child: _buildListProducts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchProduct() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
        children: [
          Text('Producto a eliminar', style: dondeluchoAppTheme.title),
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
              width: MediaQuery.of(context).size.width * 0.3,
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
                    hintText: 'Ingrese codigo producto a eliminar',
                    labelText: 'Ingrese codigo producto a eliminar'),
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
        // SizedBox(
        //   height: 15,
        // ),
        // _buildListProducts(_listProductos),
      ],
    );
  }

  Widget _buildListProducts() {
    return _listProductos.length != 0
        ? Column(
            children: _listProductos.map(
            (productos) {
              String sede = '';
              for (var i = 0;
                  i < establecimientos.establecimientos.length;
                  i++) {
                if (establecimientos.establecimientos[i].codigo ==
                    productos.sede) {
                  sede = establecimientos.establecimientos[i].name;
                }
              }
              return GestureDetector(
                onTap: () => null,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.production_quantity_limits),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      title: Text(
                        productos?.name,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            'Sede: ' + sede.toUpperCase(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                onPressed: () async {
                                  if (await validateIntenrnet()) {
                                    await AlertWidget().alertConfirmDelete(
                                        scaffoldKey: widget.scaffoldKey,
                                        context: context,
                                        producto: productos);
                                    setState(() {
                                      _listProductos = [];
                                    });
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
                                    _scaffoldKey.currentState
                                        .showSnackBar(snac);
                                  }
                                },
                                color: Colors.red,
                                icon: Icon(Icons.delete_forever_outlined)),
                          ],
                        ),
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
            child: Text(
              "<<<< Esperando producto >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }
}
