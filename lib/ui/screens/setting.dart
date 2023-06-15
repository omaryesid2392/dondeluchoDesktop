import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  StatusBloc _statusBlocProvider;

  @override
  void initState() {
    super.initState();
    initStatus();
  }

  initStatus() async {
    SharedPreferences _ref = await SharedPreferences.getInstance();
    _statusBlocProvider.setSonido = await _ref.getBool('audio') ?? false;
    _statusBlocProvider.setOscuro = await _ref.getBool('oscuro') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _statusBlocProvider = Provider.of<StatusBloc>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                //color: Colors.blue,
                alignment: Alignment.centerRight,
                child: Image.asset("assets/images/logo.png"),
                width: 130.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: dondeluchoAppTheme.nearlyWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: dondeluchoAppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 50.0),
            // height: 100.0,
            child: Column(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.notifications_on_outlined,
                              size: 40,
                            ),
                            Text(' Desactivar Sonido \n   Notificaciones:'),
                          ],
                        ),
                      ),
                      Switch(
                        activeColor: _statusBlocProvider.getSonido
                            ? PRIMARY_COLOR
                            : Colors.grey.withOpacity(0.6),
                        value: _statusBlocProvider.getSonido,
                        onChanged: (value) {
                          _statusBlocProvider.setSonido = value;
                          SessionSharepreferences().setAudio(value);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.brightness_6_outlined,
                            size: 40,
                          ),
                          Text(' Modo Oscuro:'),
                        ],
                      ),
                    ),
                    Switch(
                      activeColor: _statusBlocProvider.isOscuro
                          ? PRIMARY_COLOR
                          : Colors.grey.withOpacity(0.6),
                      value: _statusBlocProvider.isOscuro,
                      onChanged: (value) {
                        _statusBlocProvider.setOscuro = value;
                        SessionSharepreferences().setOscuro(value);
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// bool sonido;
// Future<void> getAudio() async {
//   SharedPreferences audio = await SharedPreferences.getInstance();
//   // ignore: await_only_futures
//   sonido = await audio.getBool('audio') ?? false;
//   print('resultado xxxxxx');
//   print(sonido);

//   //return sonido;
// }

// Future<void> setAudio(bool audio1) async {
//   try {
//     SharedPreferences audio = await SharedPreferences.getInstance();
//     await audio.setBool('audio', audio1);
//     print('clave guardada: audio xxxx');
//     print(audio1);
//   } catch (e) {
//     print(e);
//   }
// }
