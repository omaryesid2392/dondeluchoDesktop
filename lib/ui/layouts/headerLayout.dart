import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';

class HeaderLayout extends StatefulWidget {
  HeaderLayout({Key key}) : super(key: key);

  _HeaderLayoutState createState() => _HeaderLayoutState();
}

class _HeaderLayoutState extends State<HeaderLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.line_style, color: Colors.white),
                    Container(
                      child: Image.asset("assets/images/logo.png"),
                      width: 130.0,
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.notifications_none, color: PRIMARY_COLOR),
                      onPressed: () {
                        //Navigator.pushNamed(context, "Notifications");
                      },
                    )
                  ],
                ))));
  }
}
