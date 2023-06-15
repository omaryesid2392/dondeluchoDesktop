import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/screens/Services/DetailRequest.dart';
import 'package:dondelucho/ui/screens/Services/takeRequest.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BtnDraggableScrollableSheet extends StatefulWidget {
  final RequestModel request;
  final BuildContext cont;
  BtnDraggableScrollableSheet({
    Key key,
    double height,
    this.request,
    this.cont,
  }) : super(key: key);

  @override
  _BtnDraggableScrollableSheetState createState() =>
      _BtnDraggableScrollableSheetState();
}

class _BtnDraggableScrollableSheetState
    extends State<BtnDraggableScrollableSheet> {
  StatusBloc statusBloc;
  double distance;
  bool _loading = false;
  ModelUser2 _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSession();
  }

  initSession() async {
    _user = await SessionSharepreferences().getUser();
    setState(() {
      _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);

    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      builder: (context, scroll) {
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRequest(
                        widget.request,
                        uidRequest: "ok",
                      )),
            );

            if (statusBloc.uidRequest) {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            child: ListView(
              controller: scroll,
              children: [
                Text(
                  "¡¡¡ Tienes un nuevo servicio. !!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "El paciente te ha seleccionado para que le prestes tus servicios",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: new BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.75))
                    ],

                    //borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Servicio:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.request.category,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                widget.request.subcategory,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Precio",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                money.format(double.parse(
                                    widget.request.offer.toString())),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        distance > 1000
                            ? (distance * 1000).toStringAsFixed(1) + " ~ Km"
                            : distance.toStringAsFixed(1) + " ~ mt",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),

                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PRIMARY_COLOR_DARK,
                                blurRadius: 2.0,
                                offset: Offset(0.0, 0.75))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: PRIMARY_COLOR,
                        ),
                        child: SizedBox(
                          height: 25,
                          child: FlatButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailRequest(
                                          widget.request,
                                          uidRequest: "ok",
                                        )),
                              );

                              Navigator.of(context);
                            },
                            child: Text(
                              'Ver requerimiento',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 25.0,
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PRIMARY_COLOR_DARK,
                                blurRadius: 2.0,
                                offset: Offset(0.0, 0.75))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: PRIMARY_COLOR,
                        ),
                        child: SizedBox(
                          height: 25,
                          child: FlatButton(
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              await TakeRequest(widget.request, _user);
                              statusBloc.setTake = true;
                              statusBloc.setCurrentIndex = 2;
                              statusBloc.setUidRequest = true;
                              setState(() {
                                _loading = false;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Aceptar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () => Navigator.pop(context),
                //   child: Container(
                //     height: 50,
                //     color: Colors.amber,
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () => Navigator.pop(context),
                //   child: Container(
                //     height: 50,
                //     color: Colors.red,
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () => Navigator.pop(context),
                //   child: Container(
                //     height: 50,
                //     color: Colors.grey,
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () => Navigator.pop(context),
                //   child: Container(
                //     height: 50,
                //     color: Colors.green,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
