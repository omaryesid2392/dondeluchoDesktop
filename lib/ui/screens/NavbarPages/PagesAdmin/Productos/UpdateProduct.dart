import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/ui/widgets/ValidateInternet.dart';
import 'package:provider/provider.dart';

import '../../../../../app_theme.dart';
import '../../../SettingSharepreferences.dart';

class UpdateProducto extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  const UpdateProducto({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _UpdateProductoState createState() => _UpdateProductoState();
}

class _UpdateProductoState extends State<UpdateProducto> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  StatusBloc statusBloc;
  List<ProductModel> _listProductos = [];

  String _sede = 'Seleccione sede o local';
  String _sedeSelect;
  ModelEstablecimientos establecimientos;

  TextEditingController _valorCompra = TextEditingController();
  TextEditingController _valorMinVenta = TextEditingController();
  TextEditingController _valorPublico = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();
  TextEditingController _descripcion = TextEditingController();
  TextEditingController _codBarra = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    _buscarSede();
    super.initState();
  }

  _buscarSede() async {
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {
      establecimientos;
    });
  }

  void validador({String product}) async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (await validateIntenrnet()) {
      if (form.validate()) // valiadmos si el formulario es valido
      {
        AlertWidget().alertProcesando(context);
        if (product != null) {
          await listarProduct(product);
          Navigator.pop(context);
          return;
        } else {
          try {
            var objeto = {
              'codProduct': _codBarra.text,
              'uid': _listProductos[0].uid,
              'vCompra': _valorCompra.text,
              'vMinVenta': _valorMinVenta.text,
              'vPublico': _valorPublico.text,
              'cant': _cantidadController.text,
              'description': _descripcion.text,
            };

            print(objeto);
            print(_listProductos[0].uid);
            String status = await ServicesServicesHTTP().updateProducto(
                updateproducto: objeto, uid: _listProductos[0].uid);
            if (status != 'Error') {
              SnackBar snac = SnackBar(
                content: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: Text(
                    'Producto actualizado exitosamente !',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              statusBloc.globalKey.currentState.showSnackBar(snac);
              _listProductos = [];
              _codBarra.text = '';
              setState(() {
                _listProductos;
              });
            } else {
              SnackBar snac = SnackBar(
                content: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: Text(
                    'Error al actualizar producto, si el problema persiste favor comunicarse con GOLDEN SAS',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              statusBloc.globalKey.currentState.showSnackBar(snac);
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
            statusBloc.globalKey.currentState.showSnackBar(snac);
          }
          Navigator.pop(context);
          setState(() {
            _loading = false;
          });
        }
      } else {
        print('No es valido');
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
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

  Future<void> listarProduct(String product) async {
    if (_sede == 'Seleccione sede o local') {
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Seleccione sede o local para filtrar el producto',
            textAlign: TextAlign.center,
          ),
        ),
      );
      statusBloc.globalKey.currentState.showSnackBar(snac);
      setState(() {
        _loading = false;
      });
      return;
    }
    try {
      print(_sedeSelect);
      var codigo = {'sede': _sedeSelect};
      _listProductos = await ServicesServicesHTTP()
          .buscarProducto(producto: product, sede: codigo);
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
    if (_listProductos.length != 0) {
      print(_listProductos[0]);
      print(_listProductos[0].uid);
      _valorCompra.text = _listProductos[0].vCompra.toString();
      _valorMinVenta.text = _listProductos[0].vMinVenta.toString();
      _valorPublico.text = _listProductos[0].vPublico.toString();
      _cantidadController.text = _listProductos[0].cant.toString();
      _descripcion.text = _listProductos[0].description;
      setState(() {
        _listProductos;
      });
    } else {
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Producto no encontrado en la sede seleccionada, verifique código  suministrado',
            textAlign: TextAlign.center,
          ),
        ),
      );
      statusBloc.globalKey.currentState.showSnackBar(snac);
      setState(() {
        _listProductos = [];
      });
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);

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
      width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              _listProductos.length == 0
                  ? 'Actualice producto si es el mismo proveedor de lo contrario cree un producto nuevo'
                  : 'Actualizar producto << ${_listProductos[0].name} >>',
              style: dondeluchoAppTheme.title),
          _widgetSedes(establecimientos),
          _buildProductosEncontrado()
        ],
      ),
    );
  }

  Widget _buildProductosEncontrado() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 15.0),
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                onEditingComplete: () => validador(product: _codBarra.text),
                validator: (value) {
                  if (value.isEmpty) {
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
                  validador(product: _codBarra.text);
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
        Visibility(visible: _listProductos.length != 0, child: _buildForm()),
      ],
    );
  }

  Widget _buildForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: <Widget>[
            _ValorCompra(),
            _ValorMinVenta(),
            _ValorPublico(),
            _Cantidad(),
            _description(),
            _btn(),
            SizedBox(
              height: 30,
            )
            // divider(),
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: !_loading
            ? Text('Actualizar producto')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () {
          setState(() {
            _loading = true;
          });
          validador();
        },
      ),
    );
  }

  Widget _ValorMinVenta() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (num.parse(value) < num.parse(_valorCompra.text)) {
            // se valida si el Email esta vacio
            return 'Valor minimo de venta no puede ser menor al valor de compra';
          }

          return null;
        },
        controller: _valorMinVenta,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.attach_money_outlined, color: PRIMARY_COLOR),
            hintText: 'Valor Minimo de venta',
            labelText: 'Valor Minimo de venta'),
      ),
    );
  }

  Widget _ValorPublico() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        //key: _formKey,
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }
          if (num.parse(value) < num.parse(_valorMinVenta.text)) {
            // se valida si el Email esta vacio
            return 'Valor al público no puede ser menor al valor minimo de venta';
          }

          return null;
        },
        controller: _valorPublico,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.attach_money_outlined, color: PRIMARY_COLOR),
            hintText: 'Precio al publico',
            labelText: 'Precio al publico'),
      ),
    );
  }

  Widget _ValorCompra() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }

          return null;
        },
        controller: _valorCompra,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.attach_money_outlined, color: PRIMARY_COLOR),
            hintText: 'Valor Compra',
            labelText: 'Valor Compra'),
      ),
    );
  }

  Widget _Cantidad() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }

          return null;
        },
        controller: _cantidadController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.add_shopping_cart, color: PRIMARY_COLOR),
            hintText: 'Cantidad',
            labelText: 'Cantidad'),
      ),
    );
  }

  Widget _description() {
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
        maxLines: 3,
        controller: _descripcion,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.description, color: PRIMARY_COLOR),
            hintText: 'Describa su producto',
            labelText: 'Descripción del producto'),
      ),
    );
  }

  Widget _widgetSedes(ModelEstablecimientos establecimientos) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.5,
      //margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Icon(Icons.home_work_outlined, color: PRIMARY_COLOR),
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
              child: DropdownButton(
                  style: TextStyle(color: PRIMARY_COLOR),
                  items: establecimientos == null
                      ? null
                      : establecimientos.establecimientos.map((sedes) {
                          return DropdownMenuItem(
                            onTap: () => setState(() {
                              _sedeSelect = sedes.codigo;
                            }),
                            value: sedes.name,
                            child: Text(sedes.name.toUpperCase()),
                          );
                        }).toList(),
                  hint: Text(
                    _sede.toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onChanged: (dato) {
                    setState(() {
                      _sede = dato;
                    });
                  })),
          //),
        ],
      ),
    );
  }
}
