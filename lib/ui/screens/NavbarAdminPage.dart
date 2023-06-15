import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/providers/PushNotificationProvider.dart';
import 'package:dondelucho/providers/UserProvider.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/screens/NavbarPages/HomeAdmin.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesAdmin/Productos/HomeProductos.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:dondelucho/ui/widgets/BuildDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dondelucho/ui/widgets/backgrounds.dart';

import 'package:dondelucho/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:provider/provider.dart';

class NavbarAdminPage extends StatefulWidget {
  NavbarAdminPage({Key key}) : super(key: key);

  _NavbarAdminPageState createState() => _NavbarAdminPageState();
}

class _NavbarAdminPageState extends State<NavbarAdminPage>
    with TickerProviderStateMixin {
  String rols;
  bool activo = false;

  bool isActive = false;
  double opacityDisabled = 0;

  AnimationController controller;
  CurvedAnimation curve;
  //StreamSubscription requestss;
  AnimationController animationController;

  int _currentIndex = 0;

  StatusBloc _statusBloc;
  // UserProvider userProvider;

  List<RequestModel> _validateAgent = [];

  SessionSharepreferences setting;
  String _uid;
  ModelUser2 _user;
  Session _activo;
  num _id;

  PrefUser _pref;
  BuildContext _context;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  //final pushProvider2 = new PushNotificationProvider();

  @override
  void initState() {
    if (this.mounted) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 2000), vsync: this);
      curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
      controller.repeat();
      //controller.forward();
    }

    initSession();
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    super.initState();

    // initSetting();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    //ListenLocation().listenzlocation(_user);
    print('Dispose');
  }

  initSession() async {
    _user = await SessionSharepreferences().getUser();
    if (_statusBloc.modo == null) {
      _statusBloc.setModo = _user.rol;
    }
  }

  @override
  Widget build(BuildContext context) {
    //setting = Provider.of<SettingShareprefences>(context);
    _statusBloc = Provider.of<StatusBloc>(context);
    //userProvider = Provider.of<UserProvider>(context);
    _statusBloc.setGlobalKey = _scaffoldKey;
    _statusBloc.setContext = context;

    if (_statusBloc.currentIndex != null) {
      _currentIndex = _statusBloc.currentIndex;
      setState(() {
        _currentIndex;
      });
      _statusBloc.setCurrentIndex = null;
    }

    setState(() {});

    return Scaffold(
      key: _scaffoldKey,
      drawer: BuildDrawer(),
      body: Stack(
        children: <Widget>[
          // Center(child: FlatButton(

          //   onPressed:(){
          //     print((height).toString());

          // }, child: Text("Mostra Draggable")),),

          widgetBackground_1(),
          _buildHeader(),
          //_alertAgentDisabled(),

          Container(
              margin: EdgeInsets.only(top: 100.0),
              child: _callNav(_currentIndex)),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.local_hospital),
      //   backgroundColor: PRIMARY_COLOR,
      //   onPressed: (){
      //     Navigator.pushNamed(context, 'ScheduleService', arguments: {"id":0});
      //   },
      // ),
    );
  }

  Widget _callNav(int currentNav) {
    switch (currentNav) {
      case 0:
        return HomeAdminPage();

      //case 0 : return HomePage(animationController: animationController);
      case 1:
        return homeProductos();
      case 2:
        return Center(
          child: Container(
              child: FadeTransition(
                  opacity: curve,
                  child: FlutterLogo(
                    size: 100.0,
                  ))),
        );
      case 3:
        return Container();
      default:
        return HomeAdminPage();
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
        selectedFontSize: 10.0,
        unselectedFontSize: 8.0,
        iconSize: 25.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Inicio")),
          BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              title: Text("Productos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), title: Text("Ventas")),

          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded), title: Text("Reportes")),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.collections_bookmark),
          //   title: Text("Servicios")
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_outline),
          //   title: Text("Perfil")
          // )
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
                      },
                    ),
                    Container(
                      child: Image.asset("assets/images/logo.png"),
                      width: 130.0,
                    ),
                  ],
                ))));
  }

  void _showModal() {
    showModalBottomSheet(context: context, builder: (context) {});
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
