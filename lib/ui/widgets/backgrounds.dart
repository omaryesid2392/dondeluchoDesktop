import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';

final _bg = Container(
  width: double.infinity,
  height: double.infinity,
  decoration: BoxDecoration(gradient: LIGHT_GRADIENT),
);

Widget widgetBackground() {
  final box = Transform.rotate(
      angle: -pi / 20.0,
      child: Container(
        width: 500.0,
        height: 400.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
            gradient: PRIMARY_GRADIENT),
      ));

  return Stack(
    children: <Widget>[
      home(),
      Positioned(
        left: -180.0,
        top: -300.0,
        child: box,
      ),
    ],
  );
}

Widget widgetBackground_1() {
  final box = Transform.rotate(
      angle: -pi / 8.0,
      child: Container(
        width: 400.0,
        height: 400.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
            gradient: PRIMARY_GRADIENT),
      ));

  return Stack(
    children: <Widget>[
      //_bg,
      home(),
      Positioned(
        left: -340.0,
        top: -205.0,
        child: box,
      ),
    ],
  );
}

Widget widgetBackgroundBottom() {
  final box = Transform.rotate(
      angle: -pi / 20.0,
      child: Container(
        width: 400.0,
        height: 400.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
            gradient: PRIMARY_GRADIENT),
      ));

  return Stack(
    children: <Widget>[
      _bg,
      Positioned(
        left: -100.0,
        bottom: -300.0,
        child: box,
      ),
    ],
  );
}
