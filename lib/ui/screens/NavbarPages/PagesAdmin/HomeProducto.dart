import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/providers/PushNotificationProvider.dart';
import 'package:dondelucho/providers/UserProvider.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/Buscarproducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/CreateProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/DeleteProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/UpdateProduct.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:dondelucho/ui/widgets/BuildDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:dondelucho/ui/layouts/headerLayout.dart';
//import 'package:dondelucho/providers/LoginProvider.dart';
import 'package:dondelucho/ui/screens/NavbarPages/HomeEmployee.dart';
import 'package:dondelucho/ui/widgets/backgrounds.dart';

import 'package:dondelucho/constant.dart';

import 'package:provider/provider.dart';

class HomeProducto extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  HomeProducto({Key key, this.scaffoldKey}) : super(key: key);

  _HomeProductoState createState() => _HomeProductoState();
}

class _HomeProductoState extends State<HomeProducto>
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
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
    //initGps();
  }

  @override
  Widget build(BuildContext context) {
    //  final  args = ModalRoute.of(context).settings.arguments as Map<String, String>;
    //  print('ARGS: ${args["uid"]}');

    //  setState(() {
    //    _uid = args["uid"];
    //  });

    statusBloc = Provider.of<StatusBloc>(context);
    // userProvider = Provider.of<UserProvider>(context);
    statusBloc.setGlobalKey = _scaffoldKey;
    statusBloc.setContext = context;
    //statusBloc.setNotifications = _notifications;

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
        title: Text('Gestion de productos'),
      ),
      key: _scaffoldKey,
      //drawer: BuildDrawer(),
      body: Stack(
        children: <Widget>[
          //widgetBackground_1(),
          //_buildHeader(),
          //_alertAgentDisabled(),
          Container(
              // margin: EdgeInsets.only(top:  60.0),
              child: _callNav(_currentIndex)),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _callNav(int currentNav) {
    // print('WIDGET.RO: ${widget.rol}');

    switch (currentNav) {
      case 0:
        return CreateProducto();
      case 1:
        return UpdateProducto();
      //ScheduleAppointmentPage();
      case 2:
        return BuscarProductForCategory();
      case 3:
        return DeleteProducto(
          scaffoldKey: _scaffoldKey,
        );
      // case 3:
      //   return ServicesActived();
      default:
        return CreateProducto();
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
                icon: Icon(Icons.add_shopping_cart), title: Text("Nuevo")),
            BottomNavigationBarItem(
                icon: Icon(Icons.update), title: Text("Actualizar")),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Listar Productos")),
            BottomNavigationBarItem(
                icon: Icon(Icons.delete), title: Text("Eliminar")),
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
