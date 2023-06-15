import 'package:dondelucho/constant.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> _listNotifications = [
      {
        "title": "Solicitud de Servicio",
        "description": "Medicina general",
        "type": "SERVICE",
        "created_at": "Jueves 26 de Septiembre 2019"
      },
      {
        "title": "Tienes un chat activo",
        "description": "Dr Javier te escribió...",
        "type": "CHAT",
        "created_at": "Hace 10 min"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
      ),
      body: ListView.builder(
        itemCount: _listNotifications.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemNotification();
        },
      ),
    );
  }

  Widget _buildItemNotification() {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: PRIMARY_COLOR_DARK,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          maxRadius: 20.0,
          backgroundColor: PRIMARY_COLOR,
        ),
        title: Text("Solicitud de servicio"),
        subtitle: Text("Jueves 22 de Agosto 2019"),
      ),
      onDismissed: (direction) {},
    );
  }
}
