import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/providers/PushNotificationProvider.dart';
import 'package:dondelucho/providers/UserProvider.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/CreateProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/DeleteProducto.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/UpdateProduct.dart';
import 'package:dondelucho/ui/screens/NavbarPages/Reportes/ReportePorFecha/ReportePorDia.dart';
import 'package:dondelucho/ui/screens/NavbarPages/Reportes/ReportePorFecha/ReportePorMes.dart';
import 'package:dondelucho/ui/screens/NavbarPages/Reportes/ReportePorFecha/ReportePorProductoFecha.dart';
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

class HomeReporte extends StatefulWidget {
  HomeReporte({
    Key key,
  }) : super(key: key);

  _HomeReporteState createState() => _HomeReporteState();
}

class _HomeReporteState extends State<HomeReporte>
    with TickerProviderStateMixin {
  bool isActive = false;
  double opacityDisabled = 0;

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
      key: _scaffoldKey,
      drawer: BuildDrawer(),
      body: Stack(
        children: <Widget>[
          _bottomNavigationBar(context),
          //widgetBackground_1(),
          //_buildHeader(),
          //_alertAgentDisabled(),
          Container(
              margin: EdgeInsets.only(top: 60.0),
              child: _callNav(_currentIndex))
        ],
      ),
      //bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _callNav(int currentNav) {
    // print('WIDGET.RO: ${widget.rol}');

    switch (currentNav) {
      case 0:
        return ReportePorDia();
      case 1:
        return ReportePorMes();
      case 2:
        return ReportePorProductoFecha();
      // case 3:
      //   return ServicesActived();
      default:
        return ReportePorDia();
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
                icon: Icon(Icons.calendar_view_day_sharp),
                title: Text("Por día")),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("Por mes")),

            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits),
                title: Text("Por producto")),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.collections_bookmark), title: Text("Servicios")),
          ],
        ),
      ),
    );
  }
}
