import 'package:flutter/material.dart';

class TerminosCondicionesCustomer extends StatefulWidget {
  // TerminosCondiciones({Key key}) : super(key: key);

  @override
  _TerminosCondicionesCustomerState createState() =>
      _TerminosCondicionesCustomerState();
}

class _TerminosCondicionesCustomerState
    extends State<TerminosCondicionesCustomer> {
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
      body: Center(
          child: Column(
        children: [
          CircularProgressIndicator(),
          Text('Esperando...'),
        ],
      )),
    );
  }
}
