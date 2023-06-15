import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../TitleView.dart';
import '../../../SettingSharepreferences.dart';

class UpdateCategory extends StatefulWidget {
  const UpdateCategory({
    Key key,
  }) : super(key: key);

  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  int _transition = 0;
  StatusBloc _statusBloc;

  List<Category> _listCategorie = [];
  Category _categoryServices;
  List<Map<String, List<Subcategory>>> _listSubCategories = [];
  List<UserModel2> _listItems;
  Subcategory _subCategoryServices;
  List<String> _ListCategoriesLevel1 = [];
  List<String> _ListCategoriesLevel2 = [];
  List<Map<String, dynamic>> _buildListCategories2 = [];
  String _categoria = 'Seleccione categoría';
  String _selectSubcategoria2 = 'Seleccione una subcategoría';
  // String _categories = 'Seleccione una opción';
  // String _subCategoria = 'Seleccione una subcategoría';
  // String _proveedor = 'Seleccione un proveedor';
  ModelUser2 _user;

  double _size;

  TextEditingController _controllerNuevaCategory = TextEditingController();
  TextEditingController _controllerSubcategoria1 = TextEditingController();
  TextEditingController _controllerSubcategoria2 = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();

  bool cambios = false;

  bool _loading = false;
  String referencia;
  String name;

  @override
  void initState() {
    super.initState();
    sesion();
    _buscarCategory();
  }

  void _buscarCategory() async {
    _listCategorie = [];
    _listSubCategories = [];
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
      _listSubCategories;
    });
  }

  _buscarSubcategory({String subcategoyLevel1, String categorySelect}) async {
    if (subcategoyLevel1 != null) {
      print(subcategoyLevel1);
      bool data = false;
      for (var i = 0; i < _listSubCategories.length; i++) {
        _listSubCategories[i].forEach((key, value) {
          if (_categoria == key) {
            //print(value[i].name);
            for (var index = 0; index < value.length; index++) {
              print(value[index].subcategories);
              if (subcategoyLevel1 == value[index].name) {
                data = true;
                print(value[index].name);
                _ListCategoriesLevel2 = value[index].subcategories;
              }
            }
            setState(() {
              _ListCategoriesLevel2;
            });
          }
        });
      }
      if (!data) {
        setState(() {
          _ListCategoriesLevel2 = [];
        });
      }
    } else {
      _buildListCategories2 = [];

      for (var i = 0; i < _listSubCategories.length; i++) {
        _listSubCategories[i].forEach((key, value) {
          if (categorySelect == key) {
            for (var index = 0; index < value.length; index++) {
              if (value[index].subcategories != null) {
                _buildListCategories2.add({
                  value[index].name: value[index].subcategories,
                  'ref': value[index].ref
                });
              }
            }
            setState(() {
              _buildListCategories2;
            });
          }
        });
      }
    }
  }

  void validador({String validar}) async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (validar != null) // valiadmos si el formulario es valido
    {
      form.validate();
    } else if (form.validate()) {
      // updateCategories();
    } else {
      print('No es valido');
      setState(() {
        _loading = false;
      });
    }
  }

  updateCategories() async {
    setState(() {
      _loading = false;
    });
    String status;
    AlertWidget().alertProcesando(context);

    String encodeArrayLevel1 = jsonEncode(_ListCategoriesLevel1);
    List<Map<String, dynamic>> list = [];
    print(_ListCategoriesLevel1);
    print(_buildListCategories2);

    for (var i = 0; i < _ListCategoriesLevel1.length; i++) {
      for (var index = 0; index < _buildListCategories2.length; index++) {
        if (_buildListCategories2[index][_ListCategoriesLevel1[i]] != null) {
          print(_buildListCategories2[index]['ref']);
          list.add({
            'name': _ListCategoriesLevel1[i],
            'subcategories': _buildListCategories2[index]
                [_ListCategoriesLevel1[i]],
            'ref': _buildListCategories2[index]['ref'],
          });
        }
      }
    }
    print(list.length);

    String encodeArrayLevel2 = jsonEncode(list);

    try {
      status = await ServicesServicesHTTP()
          .updateCategory(referencia: 'ok', category: {
        'categories': encodeArrayLevel1,
        'subcategories': encodeArrayLevel2,
        'referencia': referencia,
        'name': name,
      });
    } catch (e) {
      print(e);
    }

    //print(status);
    // referenciaStatus = 'ok';

    // if (status != 'Error') {
    //   if (_buildListCategories2.length != 0) {
    //     print(_ListCategoriesLevel1);
    //     print(_buildListCategories2);
    //     for (var i = 0; i < _ListCategoriesLevel1.length; i++) {
    //       for (var index = 0; index < _buildListCategories2.length; index++) {
    //         if (_buildListCategories2[index][_ListCategoriesLevel1[i]] !=
    //             null) {
    //           String encodeArraySubcategories = jsonEncode(
    //               _buildListCategories2[index][_ListCategoriesLevel1[i]]);
    //           var objeto = {
    //             'referencia': status,
    //             'name': _ListCategoriesLevel1[i],
    //             'subcategories': encodeArraySubcategories,
    //           };
    //           await ServicesServicesHTTP()
    //               .createNewSubCategory(newSubCategory: objeto);
    //           print(_buildListCategories2[index][_ListCategoriesLevel1[i]]);
    //         }
    //       }
    //     }
    //   }
    // }

    setState(() {
      _loading = false;
      cambios = false;
      _transition = 1;
    });
    Navigator.pop(context);
    limpiarArrays();
    await AlertWidget().aletProductSave(context);
    _buscarCategory();
  }

  limpiarArrays() {
    _controllerNuevaCategory.text = '';
    _controllerSubcategoria1.text = '';
    _controllerSubcategoria2.text = '';

    setState(() {
      // _ListCategoriesLevel1 = [];
      _ListCategoriesLevel2 = [];
      _buildListCategories2 = [];
      _transition = 0;
      _selectSubcategoria2 = 'Seleccione una subcategoría';
    });
  }

  sesion() async {
    _user = await SessionSharepreferences().getUser();
    setState(() {
      _user;
      //_listItems.add( _userItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    _statusBloc = Provider.of<StatusBloc>(context);

    _size = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        SingleChildScrollView(
          child: Center(
            child: Form(
                key:
                    _formKey, // asignamos una key al formulario creada globalmente en el constructor del widget
                child: Container(width: _size * 0.5, child: _buildForm())),
          ),
        ),
        Positioned(bottom: 15, child: _btnsAtrasAndSiguiente()),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Visibility(
              visible: _transition != 2,
              child: BounceInRight(
                duration: Duration(milliseconds: 3000),
                child: _categorie(),
              )),
          SizedBox(
            height: 20.0,
          ),
          Visibility(
              visible: _transition == 1,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: _witgedCategoriesLevel1())),
          SizedBox(
            height: 20,
          ),
          Visibility(
              visible: _transition == 1,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child:
                      _witgedBuildListCategoriesLevel1(_ListCategoriesLevel1))),
          Visibility(
              visible: _transition == 2,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: _witgedSelectSubcategoriesLevel1())),
          Visibility(
              visible: _selectSubcategoria2 != 'Seleccione una subcategoría' &&
                  _transition == 2,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: _witgedCategoriesLevel2())),
          SizedBox(
            height: 20,
          ),
          Visibility(
              visible: _selectSubcategoria2 != 'Seleccione una subcategoría' &&
                  _transition == 2,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child:
                      _witgedBuildListCategoriesLevel2(_ListCategoriesLevel2))),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _categorie() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
                        onTap: () {
                          setState(() {
                            _ListCategoriesLevel1 = [];
                            _ListCategoriesLevel2 = [];
                            _buildListCategories2 = [];
                            _transition = 0;
                            _selectSubcategoria2 =
                                'Seleccione una subcategoría';
                          });
                          _ListCategoriesLevel1 = element.categories;
                          _categoryServices = element;
                          referencia = element.ref;
                          name = element.name;
                          _buscarSubcategory(categorySelect: element.name);
                          setState(() {
                            _ListCategoriesLevel1;
                            referencia;
                            name;
                          });
                        },
                        value: element.name,
                        child: Text(element.name),
                      );
                    }).toList(),
                    hint: Text(
                      _categoria,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onChanged: (dato) {
                      setState(() {
                        _transition = 1;
                        _categoryServices;
                        _categoria = dato;
                      });

                      //categories(_categoryServices.categories);
                    }),
          ),
          //),
        ],
      ),
    );
  }

  Widget _witgedCategoriesLevel1() {
    return Row(
      children: [
        Container(
          width: _size * 0.35,
          // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
          child: Column(
            children: [
              TextFormField(
                onEditingComplete: () {
                  construirListLevel1();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo requerido:';
                  }

                  return null;
                },
                controller: _controllerSubcategoria1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    icon: Icon(Icons.category_outlined, color: PRIMARY_COLOR),
                    hintText: 'Ej: Marcas de celulares.(Samsung,Huawey,etc)',
                    labelText: 'Subcategorias nivel 1'),
              ),
            ],
          ),
        ),
        _btnAddCategoriesLevel1()
      ],
    );
  }

  Widget _btnAddCategoriesLevel1() {
    return IconButton(
        onPressed: () {
          construirListLevel1();
        },
        color: PRIMARY_COLOR,
        iconSize: 35,
        icon: Icon(Icons.add));
  }

  construirListLevel1() {
    validador(validar: 'ok');
    if (_controllerSubcategoria1.text.isEmpty) {
      validador();
    } else {
      setState(() {
        _ListCategoriesLevel1.add(_controllerSubcategoria1.text);
      });

      _witgedBuildListCategoriesLevel1(_ListCategoriesLevel1);
      _controllerSubcategoria1.text = '';
      setState(() {
        cambios = true;
      });
    }
  }

  Widget _witgedBuildListCategoriesLevel1(List<String> list) {
    return list.length != 0
        ? Column(
            children: [
              TitleView(titleTxt: 'Lista subcategorias nivel 1'),
              Column(
                  children: list.map(
                (items) {
                  //_listServicesAgent[index];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            //_buildListCategories.removeWhere((element) => element==list)
                          });
                        },
                        leading: CircleAvatar(
                          child: Icon(Icons.category_outlined),
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        title: Text(
                          items,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        trailing: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    showDialogUpdateNameLevel1(
                                        nameUpdate: items);
                                  },
                                  color: PRIMARY_COLOR,
                                  iconSize: 25,
                                  icon: Icon(Icons.update)),
                              IconButton(
                                  onPressed: () {
                                    _ListCategoriesLevel1.removeWhere(
                                        (element) {
                                      return element == items;
                                    });
                                    setState(() {
                                      cambios = true;
                                      _ListCategoriesLevel1;
                                      _witgedBuildListCategoriesLevel1(
                                          _ListCategoriesLevel1);
                                    });
                                  },
                                  color: Colors.red,
                                  iconSize: 25,
                                  icon: Icon(Icons.delete_forever)),
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
            ],
          )
        : Center(
            child: Text(
              "Lista vacía",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }

  Widget _btnsAtrasAndSiguiente() {
    return Container(
      width: _size,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: RaisedButton(
              //padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              shape: StadiumBorder(),
              color: PRIMARY_COLOR,
              textColor: Colors.white,
              child: Text('Atras'),
              onPressed: _transition == 0 || _transition == 1
                  ? null
                  : () {
                      if (!cambios) {
                        setState(() {
                          _transition -= 1;
                        });
                      } else {
                        validateCambios();
                      }
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: RaisedButton(
              padding:
                  _transition == 2 ? EdgeInsets.fromLTRB(80, 15, 80, 15) : null,
              shape: StadiumBorder(),
              color: PRIMARY_COLOR,
              textColor: Colors.white,
              child: _transition == 2
                  ? _loading == true
                      ? CircularProgressIndicator()
                      : Text('Guardar')
                  : Text('Siguiente'),
              onPressed: () {
                validateAvance();
              },
            ),
          ),
        ],
      ),
    );
  }

  validateAvance() {
    if (_transition == 0) {
      if (_controllerNuevaCategory.text.isEmpty) {
        validador();
      } else {
        setState(() {
          _transition += 1;
        });
      }
    } else if (_transition == 1) {
      if (_ListCategoriesLevel1.length == 0) {
        validador();
        SnackBar snac = SnackBar(
          content: Text(
            'Favor agregar subcategoria a la lista. Con el botón "+"!!!',
            textAlign: TextAlign.center,
          ),
        );
        _statusBloc.globalKey.currentState.showSnackBar(snac);
      } else {
        setState(() {
          _transition += 1;
        });
      }
    } else if (_transition == 2) {
      updateCategories();
      // if (_ListCategoriesLevel1.length == 0) {
      //   validador();
      // } else {
      //   setState(() {
      //     _transition += 1;
      //   });
      // }
    }
  }

  validateCambios() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              "Tiene cambios sin guardar, desea descartarlos?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 25,
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Descartar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(context);
                    setState(() {
                      cambios = false;
                      _transition -= 1;
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
                width: 20,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  Widget _witgedSelectSubcategoriesLevel1() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
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
          Expanded(
            child: SizedBox(
              height: 45.0,
              //margin: EdgeInsets.fromLTRB(5, 0, 5.0, 5.0),
              child: DropdownButton(
                  //isExpanded: false,
                  style: TextStyle(color: PRIMARY_COLOR),
                  items: _ListCategoriesLevel1.map((element) {
                    return DropdownMenuItem(
                        onTap: () {
                          print('Subcategori:....' + element);
                          print(_buildListCategories2);
                          bool validate =
                              _buildListCategories2.firstWhere((elemen) {
                                    return elemen.containsKey(element);
                                  }, orElse: () => null) !=
                                  null;
                          print(validate);
                          if (validate) {
                            print('Ok rrrrr:');

                            _buildListCategories2.firstWhere((elementor) {
                              bool r = elementor.containsKey(element);
                              _ListCategoriesLevel2 = elementor[element];
                              return r;
                            });
                            print(_ListCategoriesLevel2);
                            setState(() {
                              _ListCategoriesLevel2;
                            });
                          } else {
                            _buscarSubcategory(subcategoyLevel1: element);
                            setState(() {});
                          }
                        },
                        value: element,
                        child: Text(element));
                  }).toList(),
                  hint: Text(
                    _selectSubcategoria2,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onChanged: (dato) {
                    // print('Subcategori:....' + dato);
                    // bool validate = _buildListCategories2.firstWhere(
                    //         (element) =>
                    //             element.containsKey(_selectSubcategoria2),
                    //         orElse: () => null) !=
                    //     null;

                    // print(validate);
                    // if (validate) {
                    //   print('Ok rrrrr:');
                    // _buildListCategories2.map(
                    //       (mapa) => mapa.forEach((_selectSubcategoria2, value) {
                    //             _ListCategoriesLevel2 = value;
                    //           }));
                    // setState(() {
                    //   _selectSubcategoria2 = dato;
                    //   _ListCategoriesLevel2;
                    //});
                    //_witgedBuildListCategoriesLevel2(_ListCategoriesLevel2);
                    // } else {
                    setState(() {
                      _selectSubcategoria2 = dato;
                      // _ListCategoriesLevel2 = [];
                    });
                    //}
                  }),
            ),
          ),
          //),
        ],
      ),
    );
  }

  Widget _witgedCategoriesLevel2() {
    return Row(
      children: [
        Container(
          width: _size * 0.35,
          // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
          child: Column(
            children: [
              TextFormField(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: () {
                  construirSubcategoriesLevel2();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo requerido:';
                  }

                  return null;
                },
                controller: _controllerSubcategoria2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    icon: Icon(Icons.category_outlined, color: PRIMARY_COLOR),
                    hintText:
                        'Ej:Modelos de celulares.(Galaxi S20,Xiaomi Poco X3, etc)',
                    labelText: 'Subcategorias nivel 2 << opcional >>'),
              ),
            ],
          ),
        ),
        _btnAddCategoriesLevel2()
      ],
    );
  }

  construirSubcategoriesLevel2() {
    validador(validar: 'ok');
    if (_controllerSubcategoria2.text.isEmpty) {
      validador();
    } else {
      setState(() {
        cambios = true;
        _ListCategoriesLevel2.add(_controllerSubcategoria2.text);
      });

      if (_buildListCategories2.firstWhere(
              (element) => element.containsKey(_selectSubcategoria2),
              orElse: () => null) !=
          null) {
        num cont = 0;
        _buildListCategories2.forEach((e) {
          if (e.containsKey(_selectSubcategoria2)) {
            e.update(_selectSubcategoria2, (value) => _ListCategoriesLevel2);
          }
        });
        print(_buildListCategories2);
        print(_buildListCategories2.length);
      } else {
        _buildListCategories2
            .add({_selectSubcategoria2: _ListCategoriesLevel2});
      }

      // ({_selectSubcategoria2: _ListCategoriesLevel2});

      _witgedBuildListCategoriesLevel2(_ListCategoriesLevel2);
      print('Agrega una subcategoria level 2::::::: ' +
          _controllerSubcategoria2.text +
          ' En: ' +
          _selectSubcategoria2);
      print(_buildListCategories2.firstWhere(
              (element) => element.containsKey(_selectSubcategoria2)) ==
          null);
      _controllerSubcategoria2.text = '';
    }
  }

  Widget _btnAddCategoriesLevel2() {
    return IconButton(
        onPressed: () {
          print('btn level 2');
          construirSubcategoriesLevel2();
        },
        color: PRIMARY_COLOR,
        iconSize: 35,
        icon: Icon(Icons.add));
  }

  Widget _witgedBuildListCategoriesLevel2(List<String> list) {
    return _selectSubcategoria2 != 'Seleccione una subcategoría' &&
            list.length != 0
        ? Column(
            children: [
              TitleView(titleTxt: 'Lista subcategorias nivel 2'),
              Column(
                  children: list
                      .map((items) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    //_buildListCategories.removeWhere((element) => element==list)
                                  });
                                },
                                leading: CircleAvatar(
                                  child: Icon(Icons.category_outlined),
                                  backgroundColor: PRIMARY_COLOR,
                                ),
                                title: Text(
                                  items,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            showDialogUpdateNameLevel2(
                                                nameUpdate: items);
                                          },
                                          color: PRIMARY_COLOR,
                                          iconSize: 25,
                                          icon: Icon(Icons.update)),
                                      IconButton(
                                          onPressed: () {
                                            _ListCategoriesLevel2.removeWhere(
                                                (element) {
                                              return element == items;
                                            });
                                            setState(() {
                                              cambios = true;
                                              _ListCategoriesLevel2;
                                              print(
                                                  'Categories que quedaron: ' +
                                                      _ListCategoriesLevel2
                                                          .toString());
                                              _buildListCategories2
                                                  .forEach((element) {
                                                if (element.containsKey(
                                                    _selectSubcategoria2)) {
                                                  element.update(
                                                      _selectSubcategoria2,
                                                      (value) =>
                                                          _ListCategoriesLevel2);
                                                }
                                              });
                                              // _buildListCategories2.add({
                                              //   _selectSubcategoria2:
                                              //       _ListCategoriesLevel2
                                              // });
                                            });
                                            // print(
                                            //     'Eliminacion subcategoria level 2::::::: ' +
                                            //         items);
                                            // print(_buildListCategories2
                                            //     .firstWhere((element) =>
                                            //         element.containsKey(
                                            //             _selectSubcategoria2)));
                                          },
                                          color: Colors.red,
                                          iconSize: 25,
                                          icon: Icon(Icons.delete_forever)),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black54,
                              )
                            ],
                          ))
                      .toList()),
            ],
          )
        : Center(
            child: Text(
              "Lista vacía",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }

  void showDialogUpdateNameLevel2({String nameUpdate}) {
    final _formKeyNewPacient = GlobalKey<FormState>();
    TextEditingController _updateName = TextEditingController();

    _updateName.text = nameUpdate;

    valido() {
      int position = 0;
      _ListCategoriesLevel2.forEach((e) {
        if (e == nameUpdate) {
          _ListCategoriesLevel2.setAll(position, [_updateName.text]);
        }
        print(position);
        position += 1;
      });
      print(_ListCategoriesLevel2);
      _buildListCategories2.forEach((element) {
        if (element.containsKey(_selectSubcategoria2)) {
          element.update(
              _selectSubcategoria2, (value) => _ListCategoriesLevel2);
        }
      });
      Navigator.pop(context);

      setState(() {
        _ListCategoriesLevel2;
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Actualizar nombre category",
              style: TextStyle(fontSize: 15.0),
            ),
            content: Form(
              key: _formKeyNewPacient,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _updateName,
                      onEditingComplete: () => valido(),
                      onSaved: (value) => _updateName.text = value,
                      validator: (value) =>
                          value.length > 0 ? null : 'Campo Requerido',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Cambiar",
                        labelStyle: TextStyle(fontSize: 13.0),
                      ),
                    ),
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
                child: Text("Guardar cambios"),
                textColor: PRIMARY_COLOR,
                onPressed: () async {
                  final form = _formKeyNewPacient.currentState;
                  form.save();
                  if (form.validate()) {
                    valido();
                  }
                },
              )
            ],
          );
        });
  }

  void showDialogUpdateNameLevel1({String nameUpdate}) {
    final _formKeyNewPacient = GlobalKey<FormState>();
    TextEditingController _updateName = TextEditingController();
    _updateName.text = nameUpdate;

    valido() {
      int position = 0;
      _ListCategoriesLevel1.forEach((e) {
        if (e == nameUpdate) {
          _ListCategoriesLevel1.setAll(position, [_updateName.text]);
        }
        position += 1;
      });
      position = 0;
      var obj;
      var index;
      print(_buildListCategories2);
      _buildListCategories2.forEach((element) {
        if (element.containsKey(nameUpdate)) {
          index = position;
          var data = element;
          obj = {_updateName.text: data[nameUpdate], 'ref': data['ref']};
          cambios = true;
        }
        position += 1;
      });
      if (index != null) {
        _buildListCategories2.setAll(index, [obj]);
        print(_buildListCategories2);
      }
      Navigator.pop(context);

      setState(() {
        _ListCategoriesLevel1;
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Actualizar nombre category",
              style: TextStyle(fontSize: 15.0),
            ),
            content: Form(
              key: _formKeyNewPacient,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _updateName,
                      onEditingComplete: () => valido(),
                      onSaved: (value) => _updateName.text = value,
                      validator: (value) =>
                          value.length > 0 ? null : 'Campo Requerido',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Cambiar",
                        labelStyle: TextStyle(fontSize: 13.0),
                      ),
                    ),
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
                child: Text("Guardar cambios"),
                textColor: PRIMARY_COLOR,
                onPressed: () async {
                  final form = _formKeyNewPacient.currentState;
                  form.save();
                  if (form.validate()) {
                    valido();
                  }
                },
              )
            ],
          );
        });
  }
}
