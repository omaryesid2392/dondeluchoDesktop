import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';

class ServiExpect extends StatefulWidget {
  // TerminosCondiciones({Key key}) : super(key: key);

  @override
  _ServiExpectState createState() => _ServiExpectState();
}

class _ServiExpectState extends State<ServiExpect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                //color: Colors.blue,
                alignment: Alignment.centerRight,
                child: Image.asset("assets/images/logo_white.png"),
                width: 130.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(PRIMARY_COLOR),
            // backgroundColor: PRIMARY_COLOR,
          ),
          SizedBox(
            height: 35,
          ),
          Text('Esperando aceptación del servicio..'),
        ],
      ))),
    );
  }
}
