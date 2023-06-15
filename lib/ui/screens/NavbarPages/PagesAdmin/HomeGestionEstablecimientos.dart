import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionEstablecimientos/CreateNewEstablecimiento.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionEstablecimientos/DeleteEstablecimiento.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionEstablecimientos/UpdateEstablecimiento.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionUsuarios/CreateNewUsuario.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionUsuarios/DeleteUsers.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/GestionUsuarios/UpdateUsuario.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dondelucho/constant.dart';

import 'package:provider/provider.dart';

import '../../../../session.dart';

class HomeGestionEstablecimientos extends StatefulWidget {
  HomeGestionEstablecimientos({Key key}) : super(key: key);

  _HomeGestionEstablecimientosState createState() =>
      _HomeGestionEstablecimientosState();
}

class _HomeGestionEstablecimientosState
    extends State<HomeGestionEstablecimientos> with TickerProviderStateMixin {
  bool isActive = false;
  double opacityDisabled = 0;
  //GeoPoint location;

  AnimationController animationController;

  int _currentIndex = 0;

  StatusBloc statusBloc;
  String _uid;

  PrefUser _pref = PrefUser();

  BuildContext _context;
  int _notifications;

  ModelUser2 _user;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    super.initState();
    initSession();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  initSession() async {
    _user = await SessionSharepreferences().getUser();
    statusBloc.setRol = _user.rol;
    print(_user.rol);
    setState(() {});
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Gestión de establecimientos'),
      ),
      body: Stack(
        children: <Widget>[
          //widgetBackground_1(),
          //_buildHeader(),
          //_alertAgentDisabled(),
          _callNav(_currentIndex)
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _callNav(int currentNav) {
    // print('WIDGET.RO: ${widget.rol}');

    switch (currentNav) {
      case 0:
        return CreateNewEstablecimiento();
      case 1:
        return UpdateEstablecimiento();
      case 2:
        return DeleteEstablecimiento();
      // case 3:
      //   return _user.rol == 'ADMIN'? HomePageCategory() : Container();
      default:
        return CreateNewEstablecimiento();
    }
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
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
              icon: Icon(Icons.home_work_outlined), title: Text("Nuevo")),
          BottomNavigationBarItem(
              icon: Icon(Icons.update), title: Text("Actualizar")),
          // BottomNavigationBarItem(
          //         icon: Icon(Icons.delete_forever_rounded), title: Text("Eliminar")),
        ],
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
