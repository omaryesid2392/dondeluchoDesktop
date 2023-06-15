import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:provider/provider.dart';

import '../../../../../app_theme.dart';
import '../../../../../session.dart';
import '../../../SettingSharepreferences.dart';

class DeleteUsers extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  final Animation animation;
  final ProductModel product;

  DeleteUsers(
      {Key key,
      this.animationController,
      this.animation,
      this.product,
      this.scaffoldKey})
      : super(key: key);

  @override
  _DeleteUsersState createState() => _DeleteUsersState();
}

class _DeleteUsersState extends State<DeleteUsers> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  bool _loading = false;
  List<ProductModel> _listProductos = [];
  StatusBloc statusBloc;
  ModelUser2 _userDelete;
  ModelUser2 user;
  TextEditingController _idUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSession();
  }

  initSession() async {
    user = await SessionSharepreferences().getUser();
    setState(() {});
  }

  void _buscarUser() async {
    try {
      _userDelete =
          await ServicesServicesHTTP().buscarUsuario(idUser: _idUser.text);
      if (_userDelete == null) {
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              'Usuario no encotrado',
              textAlign: TextAlign.center,
            ),
          ),
        );
        statusBloc.globalKey..currentState.showSnackBar(snac);
      }
      setState(() {
        _userDelete;
      });
    } catch (e) {
      SnackBar snac = SnackBar(
        content: BounceInRight(
          duration: Duration(milliseconds: 3000),
          child: Text(
            'Usuario no encontrado',
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
      await _buscarUser();
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
              child: _buildUser(),
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
          Text('Usuario a eliminar', style: dondeluchoAppTheme.title),
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
                controller: _idUser,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.person_remove_alt_1, color: PRIMARY_COLOR),
                    hintText: 'Ingrese número de identificación a eliminar',
                    labelText: 'Ingrese número de identificación '),
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
        Visibility(visible: _userDelete != null, child: _buildUser())
      ],
    );
  }

  Widget _buildUser() {
    return _userDelete != null
        ? GestureDetector(
            onTap: () => null,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.production_quantity_limits),
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  title: Text(
                    _userDelete?.name,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                        _userDelete.direction,
                        style: dondeluchoAppTheme.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      // Text(
                      //   'Proveedor: ' + productos.proveedor.toString(),
                      //   style: dondeluchoAppTheme.subtitle,
                      // ),
                      // Text(
                      //   " ${money.format(productos?.vPublico)}",
                      //   style: TextStyle(
                      //       color: dondeluchoAppTheme.primaryColor,
                      //       fontSize: 16.0),
                      // )
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
                              await AlertWidget().alertConfirmDeleteUser(
                                  statusBloc: statusBloc,
                                  context: context,
                                  userDelete: _userDelete,
                                  user: user);
                              setState(() {
                                _userDelete = null;
                              });
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
          )
        : Center(
            child: Text(
              "<<<< Esperando usuario a eliminar >>>>",
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          );
  }
}
