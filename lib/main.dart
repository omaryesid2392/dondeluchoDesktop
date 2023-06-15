import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/screens/NavbarPages/PagesEmployee/ventasDetalle.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/ui/screens/NavbarAdminPage.dart';
import 'package:dondelucho/ui/screens/NavbarEmployeePage.dart';
import 'package:dondelucho/ui/screens/Profiles/EditProfiles.dart';
import 'package:dondelucho/ui/screens/Profiles/Notifications.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:dondelucho/ui/screens/IntroPage.dart';
import 'package:dondelucho/ui/screens/RegisterPage.dart';
import 'package:dondelucho/ui/screens/LoginPage.dart';
import 'package:dondelucho/constant.dart';
import 'package:provider/provider.dart';

//import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //HearRequests myRequest = new HearRequests(); // escuchando la lista de request

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  //final player = AudioCache();

  void checkSession() async {
    _user = await SessionSharepreferences().getUser();

    if (_user != null) {
      navigatorKey.currentState.pushReplacementNamed('NavbarEmployeePage');
    }
  }

  ModelUser2 _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // pushProvider.initNotifications();

    if (this.mounted) {
      checkSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatusBloc()),
        // ChangeNotifierProvider(create: (_) => ServiceBloc()),
        // ChangeNotifierProvider(create: (_) => UserBloc()),
      ],
      child: MaterialApp(
        home: home(),
        title: 'dondelucho',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'ES'),
        ],
        initialRoute: 'IntroPage',
        theme: ThemeData(primaryColor: PRIMARY_COLOR),
        routes: {
          'IntroPage': (BuildContext context) => IntroPage(),
          'LoginPage': (BuildContext context) => LoginPage(),
          'RegisterPage': (BuildContext context) => RegisterPage(),
          'NavbarAdminPage': (BuildContext context) => NavbarAdminPage(),
          'NavbarEmployeePage': (BuildContext context) => NavbarEmployeePage(),
          'ventasDetalle': (BuildContext context) => facturarVentasDetalle(),

          //Services
          // 'ScheduleService': (BuildContext context) => ScheduleService(),
          // 'ServicesActived': (BuildContext context) => ServicesActived(),
          //'ServiceDetail': (BuildContext context) => ServiceDetail(),

          //Profiles
          'EditProfile': (BuildContext context) => EditProfile(),
          'Notifications': (BuildContext context) => Notifications(),

          //Posts
          //'PostDetail': (BuildContext context) => PostDetail(),

          // setting
          'Setting': (BuildContext context) => Setting(),
        },
      ),
    );
  }
}
