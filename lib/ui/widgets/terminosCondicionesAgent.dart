import 'package:flutter/material.dart';

class TerminosCondicionesAgent extends StatefulWidget {
  // TerminosCondiciones({Key key}) : super(key: key);

  @override
  _TerminosCondicionesAgentState createState() =>
      _TerminosCondicionesAgentState();
}

class _TerminosCondicionesAgentState extends State<TerminosCondicionesAgent> {
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
