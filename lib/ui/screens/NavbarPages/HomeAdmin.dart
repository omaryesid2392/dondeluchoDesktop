//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondelucho/blocs/StatusBloc.dart';
import 'package:dondelucho/models/request_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:dondelucho/pref_user.dart';
import 'package:dondelucho/providers/UserProvider.dart';
//import 'package:dondelucho/services/HearRequests.dart';
import 'package:dondelucho/session.dart';
import 'package:dondelucho/ui/screens/SettingSharepreferences.dart';
import 'package:dondelucho/ui/widgets/Alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dondelucho/ui/screens/Services/takeRequest.dart';

import '../../../constant.dart';

import 'package:dondelucho/ui/screens/CalculateItems.dart';

class HomeAdminPage extends StatefulWidget {
  HomeAdminPage({Key key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  bool _audio = false;
  double _lati;
  double _long;
  ModelUser2 _user;

  StatusBloc statusBloc;

  // num _count = 1;

  //final player = AudioCache();
  //int count2 = 0;

  PrefUser _prefUser;

  List<RequestModel> _listRequests = List();

  //StreamSubscription<QuerySnapshot> _streamRequets;
  dynamic _distance;
  //int distancia = _distance.toInt();

  DateTime fechaN;
  num _id;

  @override
  void initState() {
    super.initState();
    initSesion();
    initActivo();
  }

  initSesion() async {
    _user = await SessionSharepreferences().getUser();

    _id = int.parse(await Session().getUserId());
    setState(() {
      _id;
      _user;
    });
    initStreamRequest();
    print("************************************");
    print(_id);
  }

  initActivo() async {
    SharedPreferences _ref = await SharedPreferences.getInstance();
    _audio = await _ref.getBool('audio') ?? false;
    _lati = await _ref.getDouble('latitude') ?? 1;
    _long = await _ref.getDouble('longitude') ?? 1;
    statusBloc.setLatitude = _lati;
    statusBloc.setLongitude = _long;
    statusBloc.setSonido = _audio;
    // setState(() {
    //   statusBloc.setLatitude = _lati;
    //   statusBloc.setLongitude = _long;
    //   statusBloc.setSonido = _audio;
    //   _audio;
    //   _lati;
    //   _long;
    // });
    // final fecha = await Session().getFechaNacimiento();
    // fechaN = DateTime.parse(fecha);
    // setState(() {
    //   fechaN;
    // });
  }

  void initStreamRequest() async {
    //final Firestore _db = Firestore.instance;
    //Firestore firestore = Firestore.instance;
    // GeoFirestore geoFirestore =
    //     GeoFirestore(firestore.collection('locationNURSE'));
    // // "etLocation" inserta el GeoHas y la Location en el usuario o requests
    // await geoFirestore.setLocation(
    //     "3qm8V9YvfSQNtEE2K125wTjAvQv2", GeoPoint(10.4062049, -75.5103048));

//     // "getLocation" consulta la localizacion
//     final location = await geoFirestore.getLocation("PNv1smiv7aBgLNfQ4bgH");
//     print('-----------------------------------------------? \n ');
//     // print(location.latitude);
//     // print(location.longitude);

//     print('-----------------------------------------------? \n ');

//     // se guarda la localizacion de referencia para realizar la geolocalizacion
//     final queryLocation = GeoPoint(location.latitude, location.longitude);
// // Con la localizacion anterior se calcula los más cercanos teniendo en cuenta el radio en km
// // creates a new query around [37.7832, -122.4056] with a radius of 6 kilometers
//     final List<DocumentSnapshot> documents =
//         await geoFirestore.getAtLocation(queryLocation, 6);
//     documents.forEach((document) {
//       print(document.data['idAgent']);
//       print(document.data);

//       //setState(() {});
//     });

    // ignore: missing_return
    // Stream<QuerySnapshot> getStreamRequets(ModelUser2 user) {
    //   final Firestore _db = Firestore.instance;
    //   try {
    //     return _db
    //         .collection('requests')
    //         .where('active', isEqualTo: true)
    //         .orderBy('schulde', descending: true)
    //         .snapshots();
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    // _streamRequets = getStreamRequets(_user).listen((querySnap) {
    //   _listRequests = querySnap.documents.map((doc) {
    //     var r = RequestModel.fromFirestore(doc);

    //     return r;
    //   }).toList();
    //   if (_listRequests.length != 0) {
    //     setState(() {});
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    initStreamRequest();
  }

  @override
  Widget build(BuildContext context) {
    statusBloc = Provider.of<StatusBloc>(context);

    // wait_service
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        home(),
        Expanded(
          child: Container(child: _buildListRequest()),
        ),
        // _buildUserStatus(),
      ],
    );
  }

  Widget _buildListRequest() {
    return _listRequests.length != 0
        ? ListView.builder(
            itemCount: _listRequests.length,
            itemBuilder: (context, key) {
              final r = _listRequests[key];
              return _buildItemRequest(r);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(PRIMARY_COLOR),
                ),
                SizedBox(
                  height: 65,
                ),
                Text(
                  'Esperando solicitud..',
                  style: TextStyle(fontSize: 20.0, color: Colors.blueGrey[700]),
                ),
              ],
            ),
          );
  }

  Widget _buildItemRequest(RequestModel r) {
    //var _edad = CalculateItems().calcularEdad(r.fechaNacimiento.toDate());
    //_count++;
    var _edad = 15;

    String _x;
    if (r.distance < 1000) {
      _x = r.distance.toString() + ' ~ mt';
    } else {
      double x = r.distance / 1000;
      _x = x.toStringAsFixed(2) + ' ~ Km';
    }

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DetailRequest(r)),
        // );
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: new BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),

          //height: 100.0,
          // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green[200]),
          child: Column(
            children: [
              Row(
                children: [
                  VerticalDivider(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[350],
                        child: Text(
                          r.nameCustomer.substring(0, 2).toUpperCase(),
                          style: TextStyle(color: PRIMARY_COLOR, fontSize: 15),
                        ),
                        maxRadius: 35.0,
                      ),
                      Divider(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(_x,
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.grey[400])),
                          // Text("(" + _edad.toString() + " - Años)",
                          //     style:
                          //         TextStyle(fontSize: 10.0, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                              DateFormat.yMMMd()
                                  .format(DateTime.now())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 8.0, color: Colors.grey[400])),
                          VerticalDivider(
                            width: 5,
                          ),
                          Text(
                              DateFormat.jms()
                                  .format(DateTime.now())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 8.0, color: Colors.grey[400])),
                        ],
                      ),
                    ],
                  ),
                  VerticalDivider(
                    width: 4.6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: r.category + "\n",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black)),
                              TextSpan(
                                  text: "(" + r.subcategory + ")",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black87)),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            // Text(r.category,
                            //     style: TextStyle(
                            //         fontSize: 17.0, color: Colors.black)),
                            // Text("(" + r.subcategory + ")",
                            //     style: TextStyle(
                            //         fontSize: 12.0, color: Colors.black87)),
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      money.format(
                                          double.parse(r.offer.toString())),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red[400])),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: PRIMARY_COLOR_DARK,
                                          blurRadius: 2.0,
                                          offset: Offset(0.0, 0.75))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: statusBloc.take == false
                                        ? PRIMARY_COLOR
                                        : Colors.grey,
                                  ),
                                  child: SizedBox(
                                    height: 25,
                                    child: FlatButton(
                                      onPressed: statusBloc.take == false
                                          ? () async {
                                              bool confirm =
                                                  await CalculateItems()
                                                      .cacularAmount(_user, r);

                                              if (confirm) {
                                                await TakeRequest(r, _user);
                                                statusBloc.setCurrentIndex = 2;
                                                statusBloc.setTake = true;
                                              } else {
                                                await AlertWidget()
                                                    .alertAcount(context);
                                              }
                                            }
                                          : null,
                                      child: statusBloc.take == false
                                          ? Text(
                                              'Aceptar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0),
                                            )
                                          : Text(
                                              'Terminar Pendientes',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      color: Colors.black12,
      height: 20,
      width: 2,
    );
  }

  Widget _buildUserStatus() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
            height: 350.0,
            child: Column(
              children: <Widget>[
                //Text(statusBloc.isActive.toString()),
                Container(
                  child: Column(
                    //alignment: Alignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: statusBloc.isActive ? 1 : 0.2,
                        child: Image.asset(
                          'assets/icons/wait_service.png',
                          width: 200.0,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        'Muy pronto recibiras servicios!',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),

                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: statusBloc.isActive ? 0 : 1,
                  child: GestureDetector(
                    onTap: () {
                      //StreamLocation().prueba();
                      // Navigator.of(context).push(
                      //   CupertinoPageRoute(builder: (context) => BackGroudInit()),
                      // );
                    },
                    child: Container(
                      //color: Color.fromRGBO(100, 100, 100, 0.8),
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Inactivo",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      width: 160.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(5.0),
                        color: Color.fromRGBO(160, 160, 160, 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
// class HearRequests {
//   final Firestore _db = Firestore.instance;
//   Stream<QuerySnapshot> getStreamRequets(UserModel user) {
//     print('sssssssssssssssssssss');
//     print(StatusBloc().isLatitude);
//     print(StatusBloc().isLongitude);
//     return _db
//         .collection('requests')
//         .orderBy('schulde', descending: true)
//         .where('isTaked', isEqualTo: false)
//         .where('type', isEqualTo: user.type)
//         .where('active', isEqualTo: true)
//         // .where('lat1',
//         //     isGreaterThan: _latitude) // donde lat1 es mayor que latitude
//         // .where('lat2',
//         //     isLessThanOrEqualTo: _latitude) // donde lat2 es menor que latitude
//         // .where('long1', isGreaterThan: _longitude)
//         // .where('long2', isLessThanOrEqualTo: _longitude)
//         .snapshots();
//   }
// }
