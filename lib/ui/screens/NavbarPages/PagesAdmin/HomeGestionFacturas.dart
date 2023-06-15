import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionDevoluciones/BuscarDevolucion.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionDevoluciones/BuscarFactura.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionDevoluciones/listarDevoluciones.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/CreateProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/DeleteProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/UpdateProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';

import 'package:provider/provider.dart';

class HomeGestionFacturas extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  HomeGestionFacturas({Key key, this.scaffoldKey}) : super(key: key);

  _HomeGestionFacturasState createState() => _HomeGestionFacturasState();
}

class _HomeGestionFacturasState extends State<HomeGestionFacturas>
    with TickerProviderStateMixin {
  bool isActive = false;
  double opacityDisabled = 0;

  AnimationController animationController;

  int _currentIndex = 0;

  StatusBloc statusBloc;
  String _uid;

  PrefUser _pref = PrefUser();

  BuildContext _context;
  int _notifications;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _key = GlobalKey();

  //final pushProvider = new PushNotificationProvider();
  //final pushProvider2 = new PushNotificationProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //initGps();
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);
    statusBloc.setGlobalKey = _scaffoldKey;
    statusBloc.setContext = context;

    if (statusBloc.currentIndex != null) {
      _currentIndex = statusBloc.currentIndex;
      setState(() {
        _currentIndex;
      });
      statusBloc.setCurrentIndex = null;
    }
    // print("..........................");
    // print(location.latitude);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de factura'),
      ),
      key: _scaffoldKey,
      //drawer: BuildDrawer(),
      body: Stack(
        children: <Widget>[
          //widgetBackground_1(),
          //_buildHeader(),
          //_alertAgentDisabled(),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              child: _callNav(_currentIndex)),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _callNav(int currentNav) {
    switch (currentNav) {
      case 0:
        return BuscarFactura();
      case 1:
        return BuscarDevolucion();
      //ScheduleAppointmentPage();
      case 2:
        return listarDevolucion();
      // case 3:
      //   return ServicesActived();
      default:
        return BuscarDevolucion();
    }
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Container(
      key: _key,
      child: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: PRIMARY_COLOR,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 0.9), fontSize: 8.0))),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                title: Text("Facturas")),
            BottomNavigationBarItem(
                icon: Icon(Icons.remove_shopping_cart_outlined),
                title: Text("Devoluciones")),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Listar Devoluciones")),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.collections_bookmark), title: Text("Servicios")),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                        // Scaffold.of(context).openDrawer();
                      },
                    ),
                    Container(
                      child: Image.asset("assets/images/logo.png"),
                      width: 130.0,
                    ),
                    // Row(
                    //   children: [
                    //     IconButton(
                    //       icon: CircleAvatar(
                    //         child: Icon(
                    //           Icons.person_outline,
                    //           color: Colors.white,
                    //           size: 19.0,
                    //         ),
                    //         //child: Text(_pref.rol.toString()),
                    //         backgroundColor: PRIMARY_COLOR,
                    //         radius: 30.0,
                    //       ),
                    //       onPressed: () {
                    //         Navigator.pushNamed(context, "EditProfile");
                    //       },
                    //     ),
                    //     Stack(
                    //       children: [
                    //         IconButton(
                    //           icon: CircleAvatar(
                    //             child: Icon(
                    //               Icons.notifications_active,
                    //               color: Colors.white,
                    //               size: 19.0,
                    //             ),
                    //             //child: Text(_pref.rol.toString()),
                    //             backgroundColor: PRIMARY_COLOR,
                    //             radius: 30.0,
                    //           ),
                    //           onPressed: () {
                    //             AlertWidget().alertANotification(context);
                    //           },
                    //         ),
                    //         Visibility(
                    //           visible: statusBloc.notifications != 0,
                    //           child: Positioned(
                    //             top: 1,
                    //             right: 2,
                    //             child: CircleAvatar(
                    //               radius: 10,
                    //               backgroundColor: Colors.red,
                    //               child: Text(
                    //                 statusBloc.notifications < 10
                    //                     ? statusBloc.notifications.toString()
                    //                     : '9+',
                    //                 style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ))));
  }

  Widget _alertAgentDisabled() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: opacityDisabled,
      child: Container(
        margin: EdgeInsets.only(top: 24.0),
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(0, 0, 0, 0.2),
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        child: Text(
          "Agente Desactivado",
          style: TextStyle(color: Colors.white, fontSize: 10.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
