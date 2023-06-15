import 'package:animate_do/animate_do.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
//import 'package:dondelucho/ui/screens/Services/ReadCode.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/ui/widgets/ValidateInternet.dart';

class CreateProducto extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const CreateProducto({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _CreateProductoState createState() => _CreateProductoState();
}

class _CreateProductoState extends State<CreateProducto> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  List<Category> _listCategorie = [];
  Category _categoryServices;
  // List<Subcategory> _listSubCategorie = [];
  List<ModelUser2> _listProveedores = [];
  List<Map<String, List<Subcategory>>> _listSubCategories = [];
  Subcategory _subCategoryServices;
  ModelEstablecimientos establecimientos;

  String _categoria = 'Seleccione una categoría';
  String _categories = 'Seleccione una opción';
  String _subCategoria = 'Seleccione una subcategoría';
  String _sede = 'Seleccione sede o local';
  String _proveedor = 'Seleccione un proveedor';
  ModelUser2 _userProveedor;
  bool mostrarProveedores = false;
  // var _listCategorie = [
  //   'Enfermería',
  //   'Medicina General',
  //   'Medicina Especializada',
  //   'Fisioterapia'
  // ];
  // final Firestore _db = Firestore.instance;

  TextEditingController _valorCompra = TextEditingController();
  TextEditingController _valorMinVenta = TextEditingController();
  TextEditingController _valorPublico = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();
  TextEditingController _descripcion = TextEditingController();
  TextEditingController _codBarra = TextEditingController();
  //TextEditingController _imei = TextEditingController();

  bool _loading = false;
  String status;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    _buscarSede();
    super.initState();
    _buscarCategory();
    _buscarProveedores();
  }

  _buscarSede() async {
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {
      establecimientos;
    });
  }

  void _buscarCategory() async {
    _listCategorie = await ServicesServicesHTTP().buscarCategorias();
    for (var i = 0; i < _listCategorie.length; i++) {
      List<Subcategory> subca = await ServicesServicesHTTP()
          .buscarSubcategorias(referencia: _listCategorie[i].ref);
      print(subca.length);

      if (subca.length > 0) {
        _listSubCategories.add({_listCategorie[i].name: subca});
      }
    }
    setState(() {
      _listCategorie;
    });
  }

  void _buscarSubcategory(String referencia, String subcategory) async {
    bool data = false;
    for (var i = 0; i < _listSubCategories.length; i++) {
      _listSubCategories[i].forEach((key, value) {
        if (key == _categoria) {
          for (var index = 0; index < value.length; index++) {
            if (_categories == value[index].name) {
              data = true;
              setState(() {
                _subCategoryServices = value[index];
                print(value[index]);
              });
            }
          }
        }
      });
    }
    if (!data) {
      setState(() {
        _subCategoryServices = null;
      });
    }
    // _subCategoryServices = await ServicesServicesHTTP()
    //     .buscarSubcategorias(referencia: referencia, subcategory: subcategory);

    // if (_subCategoryServices != null) {
    //   print(_subCategoryServices?.uid);
    //   print(_subCategoryServices?.ref);
    //   print(_subCategoryServices?.name);
    // } else {
    //   print('Error');
    // }

    // setState(() {
    //   _subCategoryServices;
    // });
  }

  void _buscarProveedores() async {
    _listProveedores = await ServicesServicesHTTP().buscarProveedores();
    setState(() {
      _listProveedores;
    });
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (await validateIntenrnet()) {
      if (form.validate()) // valiadmos si el formulario es valido
      {
        setState(() {
          _loading = true;
        });
        if (_categoria == 'Seleccione una categoría') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Seleccione una categoria',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          return;
        } else if (_categories == 'Seleccione una opción') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Falta información por seleccionar',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          return;
        } else if (_subCategoryServices != null &&
            _subCategoria == 'Seleccione una subcategoría') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Falta información por seleccionar',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          return;
        } else if (_sede == 'SSeleccione sede o local') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Seleccione sede o local de registro del producto',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          return;
        } else if (_proveedor == 'Seleccione un proveedor') {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'Seleccione un proveedor',
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          setState(() {
            _loading = false;
          });
          return;
        }

        AlertWidget().alertProcesando(context);
        print('Valido');
        //DocumentReference _ref = _db.collection('product').document();
        // await _ref.setData(
        String codigoSede;
        for (var i = 0; i < establecimientos.establecimientos.length; i++) {
          if (establecimientos.establecimientos[i].name == _sede) {
            codigoSede = establecimientos.establecimientos[i].codigo;
          }
        }
        final newProducto = {
          'refCategory': _categoryServices.ref,
          'name': _subCategoria != 'Seleccione una subcategoría'
              ? _subCategoria
              : _categories,
          'vCompra': _valorCompra.text,
          'vPublico': _valorPublico.text,
          'vMinVenta': _valorMinVenta.text,
          'cant': _cantidadController.text,
          'description': _descripcion.text,
          'proveedor': _userProveedor.name,
          'codProduct': _codBarra.text,
          'refSubCategory': _subCategoryServices?.ref ?? '',
          'sede': codigoSede
          // 'imei': _imei.text,
        };
        try {
          status = await ServicesServicesHTTP()
              .createNewProducto(newProducto: newProducto);
        } catch (e) {
          print(e);
        }
        setState(() {
          _loading = false;
        });
        Navigator.pop(context);
        print(status);

        if (status == 'Error') {
          await AlertWidget().aletProductSave(context, error: true);
          return;
        } else if (status == 'Producto guardado') {
          await AlertWidget().aletProductSave(context);
        } else {
          SnackBar snac = SnackBar(
            content: BounceInRight(
              duration: Duration(milliseconds: 3000),
              child: Text(
                status,
                textAlign: TextAlign.center,
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snac);
          return;
        }

        _cantidadController.text = '';
        _descripcion.text = '';
        _valorCompra.text = '';
        _valorMinVenta.text = '';
        _valorPublico.text = '';
        _codBarra.text = '';
        // _imei.text = '';
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

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 20.0,
            ),
            _categorie(),
            Visibility(
                child: _categoria != 'Seleccione una categoría'
                    ? categories(_categoryServices.categories)
                    : Text('')),
            _categories != 'Seleccione una opción' &&
                    _subCategoryServices != null
                ? _subCategories(_categoryServices.ref, _categories)
                : Text(''),
            // Visibility(
            //     child:
            _categories != 'Seleccione una opción' ? _proveerdores() : Text(''),
            Visibility(
                visible: establecimientos != null,
                child: _sedes(establecimientos)),
            _widgetReadCode(),
            _ValorCompra(),
            _ValorMinVenta(),
            _ValorPublico(),
            _Cantidad(),
            // Visibility(
            //     visible: _categoria == 'celulares', child: _WidgetImei()),
            _description(),
            _btn(),
            SizedBox(
              height: 50,
            )
            // divider(),
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: !_loading
            ? _proveedor == 'Seleccione un proveedor'
                ? Text('Falta Información')
                : Text('Guardar Producto')
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: _proveedor == 'Seleccione un proveedor'
            ? null
            : () {
                setState(() {
                  _loading = true;
                });
                validador();
              },
      ),
    );
  }

  Widget _categorie() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
            child: _listCategorie.length < 1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : DropdownButton(
                    //isExpanded: false,
                    style: TextStyle(color: PRIMARY_COLOR),
                    items: _listCategorie.map((Category element) {
                      return DropdownMenuItem(
                        onTap: () {
                          //print(element.ref.path);
                          _categoryServices = element;
                        },
                        value: element.name,
                        child: Text(element.name.toUpperCase()),
                      );
                    }).toList(),
                    hint: Text(
                      _categoria.toUpperCase(),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onChanged: (dato) {
                      setState(() {
                        _categories = 'Seleccione una opción';
                        _categoryServices;
                        _categoria = dato;
                      });

                      categories(_categoryServices.categories);
                    }),
          ),
          //),
        ],
      ),
    );
  }

  Widget categories(List<String> categories) {
    if (categories == null) {
      return Text('No data');
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
            child: DropdownButton(
                //isExpanded: false,
                style: TextStyle(color: PRIMARY_COLOR),
                items: categories.map((String element) {
                  return DropdownMenuItem(
                    onTap: () => setState(() {
                      _categories = element;
                    }),
                    value: element,
                    child: Text(element.toUpperCase()),
                  );
                }).toList(),
                hint: Text(
                  _categories.toUpperCase(),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onChanged: (dato) async {
                  _subCategoria = 'Seleccione una subcategoría';
                  _buscarSubcategory(_categoryServices.ref, _categories);
                  // _subCategories(_categoryServices.ref, _categories);
                }),
          ),
          //),
        ],
      ),
    );
  }

  Widget _subCategories(String reference, String category) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
              child: DropdownButton(
                  style: TextStyle(color: PRIMARY_COLOR),
                  items: _subCategoryServices.subcategories.map((element) {
                    return DropdownMenuItem(
                      //onTap: () => _subCategoryServices = element,
                      value: element,
                      child: Text(element.toUpperCase()),
                    );
                  }).toList(),
                  hint: Text(
                    _subCategoria.toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onChanged: (dato) {
                    setState(() {
                      _subCategoria = dato;
                    });
                  })),
          //),
        ],
      ),
    );
  }

  Widget _proveerdores() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Icon(Icons.person, color: PRIMARY_COLOR),
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
                items: _listProveedores.map((ModelUser2 element) {
                  return DropdownMenuItem(
                    onTap: () => _userProveedor = element,
                    value: element.name,
                    child: Text(element.name.toUpperCase()),
                  );
                }).toList(),
                hint: Text(
                  _proveedor.toUpperCase(),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onChanged: (dato) {
                  setState(() {
                    _proveedor = dato;
                  });
                }),
          ),
          //),
        ],
      ),
    );
  }

  Widget _sedes(ModelEstablecimientos establecimientos) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                            //onTap: () => _subCategoryServices = element,
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

  Widget _widgetReadCode() {
    return TextFormField(
      //key: _formKey,
      validator: (value) {
        if (value.isEmpty) {
          // se valida si el Email esta vacio
          return 'Campo requerido:';
        }

        return null;
      },
      controller: _codBarra,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          icon: Icon(Icons.confirmation_number, color: PRIMARY_COLOR),
          hintText: 'Ingrese código del producto',
          labelText: 'Ingrese código del producto'),
    );
  }

  Widget _ValorMinVenta() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: TextFormField(
        // inputFormatters: <TextInputFormatter>[
        //                         WhitelistingTextInputFormatter.digitsOnly
        //                       ],
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          } else if (num.parse(value) != 0 &&
              num.parse(value) < num.parse(_valorCompra.text)) {
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
        // inputFormatters: <TextInputFormatter>[
        //                         WhitelistingTextInputFormatter.digitsOnly
        //                       ],
        validator: (value) {
          if (value.isEmpty) {
            // se valida si el Email esta vacio
            return 'Campo requerido:';
          }
          if (num.parse(value) < num.parse(_valorCompra.text)) {
            // se valida si el Email esta vacio
            return 'Valor al público no puede ser menor al valor de compra';
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
        //                         WhitelistingTextInputFormatter.digitsOnly
        //                       ],
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
        //                         WhitelistingTextInputFormatter.digitsOnly
        //                       ],
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

  // Widget _WidgetImei() {
  //   return Container(
  //     // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
  //     child: TextFormField(
  //       // inputFormatters: <TextInputFormatter>[
  //       //                         WhitelistingTextInputFormatter.digitsOnly
  //       //                       ],
  //       validator: (value) {
  //         if (_categoria == 'celulares' && value.isEmpty) {
  //           return 'Campo requerido:';
  //         }
  //         return null;
  //       },
  //       controller: _imei,
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //           icon: Icon(Icons.phone_android, color: PRIMARY_COLOR),
  //           hintText: 'Ingrese Imei',
  //           labelText: 'Ingrese Imei'),
  //     ),
  //   );
  // }

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

  // Widget _fechaNacimiento() {
  //   return Container(
  //     // margin: Ed,
  //     // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //     width: double.infinity,
  //     // height: 100.0,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: GestureDetector(
  //             onTap: () {
  //               DatePicker.showDatePicker(context,
  //                   showTitleActions: true,
  //                   minTime: DateTime(1940, 1, 1),
  //                   maxTime: DateTime(2050, 1, 1), onChanged: (date) {
  //                 print('change $date');
  //                 setState(() {
  //                   _fechaSelec = date;
  //                   _fecha = DateFormat.yMMMMd().format(date);
  //                   _controllerFecha.text = _fecha;
  //                 });
  //                 print(_fecha);
  //               }, onConfirm: (date) {
  //                 print('confirm $date');

  //                 setState(() {
  //                   _fechaSelec = date;
  //                   _fecha = DateFormat.yMMMMd().format(date);
  //                   _controllerFecha.text = _fecha;
  //                 });
  //                 print('xxxxxx ' + _fecha);
  //               }, currentTime: DateTime.now(), locale: LocaleType.es);
  //             },
  //             child: Container(
  //               child: TextField(
  //                 enabled: false,
  //                 controller: _controllerFecha,
  //                 keyboardType: TextInputType.datetime,
  //                 decoration: InputDecoration(
  //                     icon: Icon(Icons.timer, color: PRIMARY_COLOR),
  //                     hintText: 'Fecha.',
  //                     labelText: 'Fecha nacimiento'),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
