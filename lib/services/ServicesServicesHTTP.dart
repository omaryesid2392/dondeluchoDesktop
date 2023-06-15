import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/devoluciones_model.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/models/venta_model.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';

class ServicesServicesHTTP {
  List<ProductModel> _listProductos = [];
  List<Category> _listCategory = [];
  List<modeloVenta> _listVentas = [];
  modeloVenta _venta;
  ProductModel _producto;
  Category _categories;
  Subcategory _subcategory;
  List<ModelUser2> _listaProveedores = [];
  ModelUser2 _user;
  String status;
  final host4 = 'https://goldenclic.online/';
  final host3 = 'https://dravimedic.com/';
  final host2 = 'http://localhost:5000/';
  final host = 'https://dravimedic.com/api/dondelucho/';
  final hostReporte = 'https://dravimedic.com/api/dondelucho/';
  var body;
  deleteCategory({String referencia, Map<String, String> category}) async {
    var url = host + 'category/deletecategory/' + referencia;

    await http.delete(Uri.parse(url), headers: category).then((value) {
      body = jsonDecode(value.body);
      print(body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  updateCategory({String referencia, Map<String, String> category}) async {
    var url = host + 'category/updatecategory/' + referencia;

    await http.put(Uri.parse(url), headers: category).then((value) {
      body = jsonDecode(value.body);
      print(body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  updateSubcategory(
      {String referencia, Map<String, String> subcategory}) async {
    var url = host + 'category/updatecategory/' + referencia;

    await http.put(Uri.parse(url), headers: subcategory).then((value) {
      body = jsonDecode(value.body);
      print(body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  deleteProducto({String uid, Map<String, String> producto}) async {
    var url = host + 'productos/deleteproducto/' + uid;

    await http.delete(Uri.parse(url), headers: producto).then((value) {
      body = jsonDecode(value.body);
      print(body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  deleteUser({String uid, Map<String, String> userDelete}) async {
    var url = host + 'users/delete/' + uid;

    await http.delete(Uri.parse(url), headers: userDelete).then((value) {
      body = jsonDecode(value.body);
      print(body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  buscarProducto({String producto, Map sede}) async {
    var url = host + 'productos/' + producto;

    await http.get(Uri.parse(url), headers: sede).then((value) {
      body = jsonDecode(value.body);
      print(body);
      for (var i = 0; i < body.length; i++) {
        _producto = ProductModel.fromMap(body[i]);
        _listProductos.add(_producto);
      }
    }).catchError((error) {
      print(error);
    });
    return _listProductos;
  }

  listarProductosPorCategory(
      {Map<String, String> category, String filtro}) async {
    var url = host + 'productos/filtrarproducto/ok';
    print(category);
    await http.get(Uri.parse(url), headers: category).then((value) {
      body = jsonDecode(value.body);
      print(body);
      for (var i = 0; i < body.length; i++) {
        _producto = ProductModel.fromMap(body[i]);
        _listProductos.add(_producto);
      }
    }).catchError((error) {
      print(error);
    });
    return _listProductos;
  }

  createNewProducto({Map<String, String> newProducto}) async {
    var url = host + 'productos/createproducto/new';
    print(newProducto);
    await http.post(Uri.parse(url), headers: newProducto).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  updateProducto({Map<String, String> updateproducto, String uid}) async {
    var url = host + 'productos/updateproducto/$uid';
    print(updateproducto);
    await http.put(Uri.parse(url), headers: updateproducto).then((res) {
      body = jsonDecode(res.body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  buscarUsuario({String idUser}) async {
    var url = host + 'users/' + idUser;
    await http.get(Uri.parse(url)).then((res) {
      print('<<<<< 0 >>>>>' + res.body);
      body = jsonEncode(res.body);
      print('<<<<< 1 >>>>>' + body);
      body = jsonDecode(res.body);

      _user = ModelUser2.fromMap(body);
    }).catchError((error) {
      print(error);
    });
    return _user;
  }

  createUsuario({dynamic user}) async {
    var url = host + 'users/createuser';
    await http.post(Uri.parse(url), headers: user).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  updateUsuario({dynamic user, String uid}) async {
    var url = host + 'users/updateuser/' + uid;
    await http.post(Uri.parse(url), headers: user).then((res) {
      body = jsonDecode(res.body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  createEstablecimiento({dynamic establecimiento, String uidUser}) async {
    var url = host + 'establecimientos/createstablecimiento/' + uidUser;
    await http.post(Uri.parse(url), headers: establecimiento).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  updateEstablecimiento({dynamic establecimiento, String uid}) async {
    var url = host + 'establecimientos/updatestablecimiento/' + uid;
    await http.put(Uri.parse(url), headers: establecimiento).then((res) {
      body = jsonDecode(res.body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  createNewVenta({Map<String, String> detalleVenta}) async {
    bool respuesta = false;
    var url = host + 'ventas/createventa';
    await http.post(Uri.parse(url), headers: detalleVenta).then((res) {
      respuesta = true;
    }).catchError((error) {
      print(error);
    });
    return respuesta;
  }

  deleteVenta({Map<String, String> detalleVenta}) async {
    var respuesta;
    var url = host + 'ventas/deleteventas/';
    await http.delete(Uri.parse(url), headers: detalleVenta).then((res) {
      respuesta = jsonDecode(res.body);
      print(respuesta['status']);
    }).catchError((error) {
      print('>>>>> ====' + error);
    });
    return respuesta['status'];
  }

  reportesPorID({Map<String, String> fechaSelect, String id}) async {
    print(hostReporte);
    var url = hostReporte + 'ventas/buscarventas/' + id;
    await http.get(Uri.parse(url), headers: fechaSelect).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    print(body);
    print(body.length);
    for (var i = 0; i < body.length; i++) {
      _venta = modeloVenta.fromMap(body[i]);
      _listVentas.add(_venta);
    }
    print(_listVentas.length);
    if (_listVentas.length != 0) {
      print(_listVentas[0]);
    }

    return _listVentas;
  }

  filtrarVentas({Map<String, String> codigo, String id}) async {
    var url = host + 'ventas/filtrarventas/' + id;
    await http.get(Uri.parse(url), headers: codigo).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    print(body);
    print(body.length);
    for (var i = 0; i < body['data'].length; i++) {
      _venta = modeloVenta.fromMap(body['data'][i]);
      _listVentas.add(_venta);
    }
    print(body['data']);
    if (body['status'] != 'Error') {
      return {'status': body['status'], 'data': _listVentas};
    } else {
      return {'status': body['status'], 'data': body['data']};
    }
  }

  listarDevoluciones() async {
    var url = host + 'ventas/listar/devolucines/';
    await http.get(Uri.parse(url)).then((res) {
      body = jsonDecode(res.body);
    }).catchError((error) {
      print(error);
    });
    print(body);
    print(body.length);
    List<modeloDevolucion> lisDevolucion = [];
    for (var i = 0; i < body['data'].length; i++) {
      var devolucion = modeloDevolucion.fromMap(body['data'][i]);
      lisDevolucion.add(devolucion);
    }
    print(body['data']);
    if (body['status'] != 'Error') {
      return {'status': body['status'], 'data': lisDevolucion};
    } else {
      return {'status': body['status'], 'data': body['data']};
    }
  }

  createNewCategory({Map<String, String> newCategory}) async {
    //body = jsonEncode(newCategory);
    var url = host + 'category/createcategory/';
    await http.post(Uri.parse(url), headers: newCategory).then((res) {
      print(res.body);
      body = jsonDecode(res.body);
      print(body['status']);
    }).catchError((error) {
      print(error);
    });
    return body['status'];
  }

  createNewSubCategory({Map<String, String> newSubCategory}) async {
    //body = jsonEncode(newCategory);
    var url = host + 'category/createsubcategory/';
    await http.post(Uri.parse(url), headers: newSubCategory).then((res) {
      print(res.body);
    }).catchError((error) {
      print(error);
    });
    return null;
  }

  Future<List<Category>> buscarCategorias({String category}) async {
    final url = host + 'category/';
    await http.get(Uri.parse(url)).then((value) {
      //body = value.body;
      body = jsonDecode(value.body);
      //_listCategory = body;
      print(body);
    });
    for (var i = 0; i < body.length; i++) {
      _categories = Category.fromMap(body[i]);
      print(_categories.name);
      _listCategory.add(_categories);
    }
    return _listCategory;
  }

  buscarSubcategorias({String referencia, String subcategory}) async {
    var objeto = {"referencia": referencia, "subcategory": subcategory};
    var format = jsonEncode(objeto);
    print('----' + '$format');

    final url = host + 'category/subcategorys/ok';
    await http.get(Uri.parse(url), headers: objeto).then((value) {
      body = jsonDecode(value.body);
      //body = value.body;
      print(body[0]['uid']);
    }).catchError((onError) => {print(onError)});
    List<Subcategory> listSubcategoria = [];
    for (var i = 0; i < body.length; i++) {
      _subcategory = Subcategory.fromMap(body[i]);
      listSubcategoria.add(_subcategory);
      print(_subcategory?.subcategories);
    }
    return listSubcategoria;
  }

  buscarProveedores() async {
    final url = host + 'users/proveedores/todos';
    await http.get(Uri.parse(url)).then((res) {
      print('<<<<< 0 >>>>>' + res.body);
      body = jsonEncode(res.body);
      print('<<<<< 1 >>>>>' + body);
      body = jsonDecode(res.body);
      print(body);
    }).catchError((error) {
      print(error);
    });
    for (var i = 0; i < body.length; i++) {
      _user = ModelUser2.fromMap(body[i]);
      _listaProveedores.add(_user);
    }
    return _listaProveedores;
  }

  login({Map<String, String> credenciales}) async {
    final url = host + 'users/';
    await http.post(Uri.parse(url), headers: credenciales).then((res) {
      // print('<<<<< 0 >>>>>' + res.body);
      body = jsonEncode(res.body);
      //print('<<<<< 1 >>>>>' + body);
      body = jsonDecode(res.body);
      //print(body[0]);
    }).catchError((error) {
      print(error.toString());
    });

    _user = ModelUser2.fromMap(body[0]);
    // print(_user.id);
    if (_user.email != '') {
      await SessionSharepreferences().setUser(_user);

      if (_user.rol != 'CLIENT' && _user.rol != 'PROVEEDOR') {
        ModelEstablecimientos establecimiento =
            ModelEstablecimientos.fromMap(body[1]);
        await SessionSharepreferences().setEstablecimientos(establecimiento);
      }
    }
    return _user;
  }
}
