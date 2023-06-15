import 'package:animate_do/animate_do.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/category_model.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/services/ServicesServicesHTTP.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteCategory extends StatefulWidget {
  AnimationController animationController;
  Animation animation;
  ProductModel product;

  DeleteCategory(
      {Key key, this.animationController, this.animation, this.product})
      : super(key: key);

  @override
  _DeleteCategoryState createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {
  final _formKey = GlobalKey<
      FormState>(); //creamos clave global para asignarlar al formularios

  List<Category> _listCategorie = [];
  Category _categoryServices;

  String _categoria = 'Seleccione categoría a eliminar';

  bool _loading = false;
  StatusBloc statusBloc;

  @override
  void initState() {
    _buscarCategory();

    super.initState();
  }

  void _buscarCategory() async {
    _listCategorie = await ServicesServicesHTTP().buscarCategorias();
    setState(() {
      _listCategorie;
    });
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
      try {
        print(_categoryServices.ref);
        var objeto = {'referencia': _categoryServices.ref};
        status = await ServicesServicesHTTP()
            .deleteCategory(category: objeto, referencia: 'ok');
        SnackBar snac = SnackBar(
          content: BounceInRight(
            duration: Duration(milliseconds: 3000),
            child: Text(
              status,
              textAlign: TextAlign.center,
            ),
          ),
        );
        statusBloc.globalKey.currentState.showSnackBar(snac);
        if (status == 'Categoria eliminada exitosamente') {
          _listCategorie.removeWhere((element) => element == _categoryServices);
          setState(() {
            _categoria = 'Seleccione categoría a eliminar';
            _listCategorie;
          });
        }
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
            _categorie(),
            Visibility(visible: _categoryServices != null, child: _btn())

            // divider(),
          ],
        ),
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
                          //print(element.ref.path);
                          _categoryServices = element;
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

  Widget _btn() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
        shape: StadiumBorder(),
        color: PRIMARY_COLOR,
        textColor: Colors.white,
        child: !_loading
            ? Text('Eliminar categoria')
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
}
