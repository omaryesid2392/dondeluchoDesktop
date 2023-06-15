import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:provider/provider.dart';

import '../../../../../TitleView.dart';
import '../../../../../constant.dart';
import '../../../SettingSharepreferences.dart';

class BuscarProductForCategory extends StatefulWidget {
  double size;
  BuscarProductForCategory({Key key, this.size}) : super(key: key);

  @override
  _BuscarProductForCategoryState createState() =>
      _BuscarProductForCategoryState();
}

class _BuscarProductForCategoryState extends State<BuscarProductForCategory> {
  @override
  TextEditingController _textProduc = TextEditingController();
  List<ProductModel> _listProductos = [];
  List<ProductModel> listProduct2 = [];
  List<Category> _listCategorie = [];

  ModelEstablecimientos establecimientos;

  String _categoria = 'Seleccione una categoría';
  String _categories = 'Seleccione una opción';
  String _subCategoria = 'Seleccione una subcategoría';
  String _filtrar = '';

  final _formKey = GlobalKey<FormState>();

  StatusBloc _statusBloc;
  @override
  void initState() {
    super.initState();
    _buscarCategory();
    _buscarSede();
  }

  _buscarSede() async {
    establecimientos = await SessionSharepreferences().getEstablecimientos();
    setState(() {
      establecimientos;
    });
  }

  void _buscarCategory() async {
    _listCategorie = await ServicesServicesHTTP().buscarCategorias();
    setState(() {
      _listCategorie;
    });
  }

  Future<void> listarProduct(
      Map<String, String> categoryRefence, BuildContext context) async {
    AlertWidget().alertProcesando(context);
    _listProductos = await ServicesServicesHTTP()
        .listarProductosPorCategory(category: categoryRefence);
    Navigator.pop(context);
    setState(() {
      _listProductos;
      _categoria;
    });
  }

  Widget build(BuildContext context) {
    _statusBloc = Provider.of<StatusBloc>(context);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            // Form(key: _formKey, child: _buildBuscarProduct(widget.size)),
            SizedBox(
              height: 10,
            ),
            _categorie(),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TitleView(titleTxt: 'Lista Productos')),
            _buscarProductosList(queryData),
            _filtrar == ''
                ? _buildListProducts(_listProductos)
                : _buildListProducts2(),
          ],
        ),
      ),
    );
  }

  Widget _categorie() {
    return Container(
      //color: Colors.red,
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.only(right: 10.0, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        onTap: () async {
                          _categoria = element.name;

                          listarProduct({'category': element.ref}, context);
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
                      //setState(() {
                      _categoria = dato;
                      // });
                    }),
          ),
        ],
      ),
    );
  }

  // Widget _categorie() {
  //   return Center(
  //     child: Container(
  //       margin: EdgeInsets.fromLTRB(15, 5, 10, 5),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.category_outlined, color: PRIMARY_COLOR),
  //           Text(
  //             '    ',
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: PRIMARY_COLOR,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 45.0,
  //             //margin: EdgeInsets.fromLTRB(5, 0, 5.0, 5.0),
  //             child: FutureBuilder(
  //                 future: ServicesServicesHTTP().buscarCategorias(),
  //                 builder: (BuildContext context,
  //                     AsyncSnapshot<List<Category>> snapshot) {
  //                   switch (snapshot.connectionState) {
  //                     case ConnectionState.waiting:
  //                       return Container(
  //                           child: Center(
  //                         child: CircularProgressIndicator(),
  //                       ));

  //                     case ConnectionState.done:
  //                       {
  //                         _listCategorie = snapshot.data;
  //                         if (!snapshot.hasData) return Container();
  //                         return DropdownButton(
  //                             //isExpanded: false,
  //                             style: TextStyle(color: PRIMARY_COLOR),
  //                             items: _listCategorie.map((Category element) {
  //                               return DropdownMenuItem(
  //                                 onTap: (){
  //                                   listarProduct({'category': element.ref});
  //                                 },
  //                                 value: element.name,
  //                                 child: Text(element.name),
  //                               );
  //                             }).toList(),
  //                             hint: Text(
  //                               _categoria,
  //                               style: TextStyle(
  //                                   fontSize: 16, color: Colors.black),
  //                             ),
  //                             onChanged: (dato) {
  //                               setState(() {
  //                                 _categoryServices;
  //                                 _categoria = dato;
  //                               });
  //                             });
  //                       }
  //                     default:
  //                       return Container();
  //                   }
  //                 }),
  //           ),
  //           //),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildListProducts(List<ProductModel> listProduct) {
    return listProduct.length != 0
        ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
                children: listProduct.map(
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
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.production_quantity_limits),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: productos.codProduct));
                          SnackBar snac = SnackBar(
                            elevation: 50,
                            backgroundColor: Colors.grey,
                            content: Text(
                              ' Código  ' + productos.codProduct + ' copiado',
                              textAlign: TextAlign.center,
                            ),
                          );
                          _statusBloc.globalKey.currentState.showSnackBar(snac);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productos.name + "\n (${productos.codProduct})",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Icon(
                                  Icons.copy,
                                  color: Colors.grey[800],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            productos.description,
                            style: dondeluchoAppTheme.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Proveedor: ' + productos.proveedor.toString(),
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              children: [
                                Text(
                                  "vC: ${money.format(productos?.vCompra)}  ",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "vmV: ${money.format(productos?.vMinVenta)}  ",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "vP: ${money.format(productos?.vPublico)}",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Sede: ' + sede.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                              Text(
                                'Stock: ' + productos.cant.toString(),
                                style: TextStyle(
                                    color: Colors.red, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // IconButton(
                            //     onPressed: () async {
                            //       await Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => UpdateProducto()),
                            //       );
                            //       if (_subCategoria !=
                            //           'Seleccione una subcategoría') {
                            //         // listarProduct(_subCategoria);

                            //       } else {
                            //         // listarProduct(_categories);

                            //       }
                            //     },
                            //     color: PRIMARY_COLOR,
                            //     icon: Icon(Icons.update)),
                            IconButton(
                                onPressed: () async {
                                  await AlertWidget().aletProductDelete(
                                      context, productos.uid);
                                  if (_subCategoria !=
                                      'Seleccione una subcategoría') {
                                    //listarProduct(_subCategoria);

                                  } else {
                                    // listarProduct(_categories);

                                  }
                                },
                                color: Colors.red,
                                icon: Icon(Icons.delete)),
                            // Text(
                            //     "${DateFormat('MMM d').format(productos.fechaRegistro?.toDate())}",
                            //     style: DraviMedicAppTheme.subtitle),
                          ],
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

  Widget _buildListProducts2() {
    setState(() {
      listProduct2 = [];
      for (var producto in _listProductos) {
        if (producto.name.toUpperCase().contains(_filtrar.toUpperCase()) ||
            producto.cant.toString() == _filtrar) {
          listProduct2.add(producto);
        }
      }
    });
    return listProduct2.length != 0
        ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
                children: listProduct2.map(
              (productos) {
                //_listServicesAgent[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.production_quantity_limits),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: productos.codProduct));
                          SnackBar snac = SnackBar(
                            elevation: 50,
                            backgroundColor: Colors.grey,
                            content: Text(
                              ' Código  ' + productos.codProduct + ' copiado',
                              textAlign: TextAlign.center,
                            ),
                          );
                          _statusBloc.globalKey.currentState.showSnackBar(snac);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productos.name + "\n (${productos.codProduct})",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Icon(
                                  Icons.copy,
                                  color: Colors.grey[800],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            productos.description,
                            style: dondeluchoAppTheme.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Proveedor: ' + productos.proveedor.toString(),
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              children: [
                                Text(
                                  "vC: ${money.format(productos?.vCompra)}  ",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "vmV: ${money.format(productos?.vMinVenta)}  ",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "vP: ${money.format(productos?.vPublico)}",
                                  style: TextStyle(
                                      color: dondeluchoAppTheme.primaryColor,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Stock: ' + productos.cant.toString(),
                            style: TextStyle(color: Colors.red, fontSize: 18.0),
                          ),
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // IconButton(
                            //     onPressed: () async {
                            //       await Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => UpdateProducto()),
                            //       );
                            //       if (_subCategoria !=
                            //           'Seleccione una subcategoría') {
                            //         // listarProduct(_subCategoria);

                            //       } else {
                            //         // listarProduct(_categories);

                            //       }
                            //     },
                            //     color: PRIMARY_COLOR,
                            //     icon: Icon(Icons.update)),
                            IconButton(
                                onPressed: () async {
                                  await AlertWidget().aletProductDelete(
                                      context, productos.uid);
                                  if (_subCategoria !=
                                      'Seleccione una subcategoría') {
                                    //listarProduct(_subCategoria);

                                  } else {
                                    // listarProduct(_categories);

                                  }
                                },
                                color: Colors.red,
                                icon: Icon(Icons.delete)),
                            // Text(
                            //     "${DateFormat('MMM d').format(productos.fechaRegistro?.toDate())}",
                            //     style: DraviMedicAppTheme.subtitle),
                          ],
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
              "<<<< Lista vacía >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }

  Widget _buscarProductosList(MediaQueryData queryData) {
    return Container(
      width: queryData.size.width * 0.50,
      margin: EdgeInsets.only(right: 10.0, left: 10),
      child: TextFormField(
        controller: _textProduc,
        onChanged: (text) {
          setState(() {
            _filtrar = text;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.production_quantity_limits,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,

            //borderSide: const BorderSide(),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: "WorkSansLight",
          ),
          filled: true,
          fillColor: Colors.blue[300],
          hintText: 'Filtrar productos por nombre y Stock',
        ),
      ),
    );
  }
}
