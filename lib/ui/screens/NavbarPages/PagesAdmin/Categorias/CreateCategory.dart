import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../TitleView.dart';
import '../../../SettingSharepreferences.dart';

class CreateCategory extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const CreateCategory({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios
  int _transition = 0;
  StatusBloc _statusBloc;

  List<Category> _listCategorie;
  Category _categoryServices;
  List<Subcategory> _listSubCategorie;
  List<UserModel2> _listItems;
  Subcategory _subCategoryServices;
  List<String> _ListCategoriesLevel1 = [];
  List<String> _ListCategoriesLevel2 = [];
  List<Map<String, List>> _buildListCategories2 = [];

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

  bool _loading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    sesion();
  }

  void validador() async {
    final form =
        _formKey.currentState; // validando el estado actual de la clave
    if (form.validate()) // valiadmos si el formulario es valido
    {
      createNuevaCategory();
    } else {
      print('No es valido');
      setState(() {
        _loading = false;
      });
    }
  }

  createNuevaCategory() async {
    setState(() {
      _loading = false;
    });
    String referenciaStatus;
    AlertWidget().alertProcesando(context);

    String encodeArray = jsonEncode(_ListCategoriesLevel1);
    try {
      referenciaStatus =
          await ServicesServicesHTTP().createNewCategory(newCategory: {
        'categories': encodeArray,
        'name': _controllerNuevaCategory.text,
      });
    } catch (e) {
      print(e);
    }

    print(referenciaStatus);
    // referenciaStatus = 'ok';

    if (referenciaStatus != 'Error') {
      if (_buildListCategories2.length != 0) {
        print(_ListCategoriesLevel1);
        print(_buildListCategories2);
        for (var i = 0; i < _ListCategoriesLevel1.length; i++) {
          for (var index = 0; index < _buildListCategories2.length; index++) {
            if (_buildListCategories2[index][_ListCategoriesLevel1[i]] !=
                null) {
              String encodeArraySubcategories = jsonEncode(
                  _buildListCategories2[index][_ListCategoriesLevel1[i]]);
              var objeto = {
                'referencia': referenciaStatus,
                'name': _ListCategoriesLevel1[i],
                'subcategories': encodeArraySubcategories,
              };
              await ServicesServicesHTTP()
                  .createNewSubCategory(newSubCategory: objeto);
              print(_buildListCategories2[index][_ListCategoriesLevel1[i]]);
            }
          }
        }
      }
    }
    // String uidCategoryNueva = _ref.documentID;
    // print(uidCategoryNueva);
    // DocumentReference _refSubcategory =
    //     _ref.collection('subcategory').document();

    setState(() {
      _loading = false;
    });
    Navigator.pop(context);
    await AlertWidget().aletProductSave(context);
    _controllerNuevaCategory.text = '';
    _controllerSubcategoria1.text = '';
    _controllerSubcategoria2.text = '';

    setState(() {
      _ListCategoriesLevel1 = [];
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
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
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
      ),
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
          Visibility(
              visible: _transition == 0,
              child: BounceInRight(
                  duration: Duration(milliseconds: 3000),
                  child: _witgedCrearCategory())),
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
                  child: _witgedSubcategories2())),
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

          // _ValorPublico(),
          // _Cantidad(),
          // _description(),

          // divider(),
        ],
      ),
    );
  }

  Widget _witgedCrearCategory() {
    return Container(
      // margin: EdgeInsets.fromLTRB(10, 0, 100, 0),
      child: Column(
        children: [
          TextFormField(
            //key: _formKey,
            validator: (value) {
              if (value.isEmpty) {
                // se valida si el Email esta vacio
                return 'Campo requerido:';
              }

              return null;
            },
            controller: _controllerNuevaCategory,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: Icon(Icons.category_outlined, color: PRIMARY_COLOR),
                hintText: 'Ej: Celulares, Estuches,Parlantes, ect.',
                labelText: 'Nueva Categoria'),
          ),
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
                  if (_controllerSubcategoria1.text.isEmpty) {
                    validador();
                  } else {
                    setState(() {
                      _ListCategoriesLevel1.add(_controllerSubcategoria1.text);
                    });
                    _witgedBuildListCategoriesLevel1(_ListCategoriesLevel1);
                    _controllerSubcategoria1.text = '';
                  }
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
          if (_controllerSubcategoria1.text.isEmpty) {
            validador();
          } else {
            setState(() {
              _ListCategoriesLevel1.add(_controllerSubcategoria1.text);
            });
            _witgedBuildListCategoriesLevel1(_ListCategoriesLevel1);
            _controllerSubcategoria1.text = '';
          }
        },
        color: PRIMARY_COLOR,
        iconSize: 35,
        icon: Icon(Icons.add));
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
              onPressed: _transition == 0
                  ? null
                  : () {
                      setState(() {
                        _transition -= 1;
                      });
                      //validador();
                      //}
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
        // validador();
        SnackBar snac = SnackBar(
          content: Text(
            'Favor agregar subcategoria a la lista, con el botón "+"!!!',
            textAlign: TextAlign.center,
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snac);
      } else {
        setState(() {
          _transition += 1;
        });
      }
    } else if (_transition == 2) {
      createNuevaCategory();
      // if (_ListCategoriesLevel1.length == 0) {
      //   validador();
      // } else {
      //   setState(() {
      //     _transition += 1;
      //   });
      // }
    }
  }

  Widget _witgedSubcategories2() {
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
                        onTap: () async {
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
                            setState(() {
                              _ListCategoriesLevel2 = [];
                            });
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
                onEditingComplete: () {
                  if (_controllerSubcategoria2.text.isEmpty) {
                    validador();
                  } else {
                    setState(() {
                      _ListCategoriesLevel2.add(_controllerSubcategoria2.text);
                    });

                    if (_buildListCategories2.firstWhere(
                            (element) =>
                                element.containsKey(_selectSubcategoria2),
                            orElse: () => null) !=
                        null) {
                      _buildListCategories2.map((e) => e.update(
                          _selectSubcategoria2,
                          (value) => value = _ListCategoriesLevel2));
                      print(_buildListCategories2);
                    } else {
                      _buildListCategories2
                          .add({_selectSubcategoria2: _ListCategoriesLevel2});
                    }

                    ({_selectSubcategoria2: _ListCategoriesLevel2});

                    _witgedBuildListCategoriesLevel2(_ListCategoriesLevel2);
                    print('Agrega una subcategoria level 2::::::: ' +
                        _controllerSubcategoria2.text +
                        ' En: ' +
                        _selectSubcategoria2);
                    print(_buildListCategories2.firstWhere((element) =>
                            element.containsKey(_selectSubcategoria2)) ==
                        null);
                    _controllerSubcategoria2.text = '';
                  }
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

  Widget _btnAddCategoriesLevel2() {
    return IconButton(
        onPressed: () {
          if (_controllerSubcategoria2.text.isEmpty) {
            validador();
          } else {
            setState(() {
              _ListCategoriesLevel2.add(_controllerSubcategoria2.text);
            });

            if (_buildListCategories2.firstWhere(
                    (element) => element.containsKey(_selectSubcategoria2),
                    orElse: () => null) !=
                null) {
              _buildListCategories2.map((e) => e.update(_selectSubcategoria2,
                  (value) => value = _ListCategoriesLevel2));
              print(_buildListCategories2);
            } else {
              _buildListCategories2
                  .add({_selectSubcategoria2: _ListCategoriesLevel2});
            }

            ({_selectSubcategoria2: _ListCategoriesLevel2});

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
                                              _ListCategoriesLevel2;
                                              print(
                                                  'Categories que quedaron: ' +
                                                      _ListCategoriesLevel2
                                                          .toString());
                                              _buildListCategories2.add({
                                                _selectSubcategoria2:
                                                    _ListCategoriesLevel2
                                              });
                                            });
                                            print(
                                                'Eliminacion subcategoria level 2::::::: ' +
                                                    items);
                                            print(_buildListCategories2
                                                .firstWhere((element) =>
                                                    element.containsKey(
                                                        _selectSubcategoria2)));
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
        print(position);
        position += 1;
      });
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
