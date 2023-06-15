import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/Buscarproducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/CreateProducto.dart';

class homeProductos extends StatefulWidget {
  homeProductos({Key key}) : super(key: key);

  @override
  _homeProductosState createState() => _homeProductosState();
}

String opcion = 'Nuevo';

class _homeProductosState extends State<homeProductos> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: btnProduct(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreateProduct(),
                BuscarProduct(_size),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget btnProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text('Nuevo'),
            onPressed: () {
              setState(() {
                opcion = 'Nuevo';
              });
            },
            shape: StadiumBorder(),
            color: opcion == 'Nuevo' ? Colors.blue[400] : PRIMARY_COLOR,
            textColor: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text('Buscar'),
            onPressed: () async {
              setState(() {
                opcion = 'Buscar';
              });
            },
            shape: StadiumBorder(),
            color: opcion == 'Buscar' ? Colors.blue[400] : PRIMARY_COLOR,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget BuscarProduct(double size) {
    return Center(
        child: Container(
      child: Visibility(
          visible: opcion == 'Buscar',
          child: BuscarProductForCategory(size: size)),
    ));
  }

  Widget CreateProduct() {
    return Center(
        child: Container(
      child: Visibility(visible: opcion == 'Nuevo', child: CreateProducto()),
    ));
  }
}
