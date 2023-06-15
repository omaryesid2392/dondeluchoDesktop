// import 'dart:async';

// import 'package:dondelucho/constant.dart';
// import 'package:dondelucho/models/request_model.dart';

// import 'package:dondelucho/services/ServicesServices.dart';
// import 'package:dondelucho/app_theme.dart';

// import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';

// class HistorialService extends StatefulWidget {
//   String modo;
//   HistorialService(this.modo, {Key key}) : super(key: key);

//   @override
//   _HistorialServiceState createState() => _HistorialServiceState(modo);
// }

// class _HistorialServiceState extends State<HistorialService> {
//   List<RequestModel> _listHistorialAgent = [];
//   List<RequestModel> _listHistorialPacient = [];
//   String modo;
//   MediaQueryData queryData;
//   _HistorialServiceState(this.modo);

//   @override
//   // ignore: must_call_super
//   void initState() {
//     fetchServicesTaked();
//   }

//   Future fetchServicesTaked() async {
//     if (modo == 'AGENT') {
//       _listHistorialAgent = await ServicesServices().getHistorialAgent();
//       if (_listHistorialAgent.length != 0) {
//         setState(() {
//           _listHistorialAgent;
//         });
//       }
//     } else {
//       //_listHistorialAgent = await ServicesServices().getHistorialAgent();
//       _listHistorialPacient = await ServicesServices().getHistorialPacient();
//       //print(_listHistorialPacient.length);
//       if (_listHistorialPacient.length != 0) {
//         setState(() {
//           _listHistorialPacient;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     queryData = MediaQuery.of(context);
//     //_statusBloc = Provider.of<StatusBloc>(context);

//     // setState(() {});
//     return Container(
//       child: modo == 'AGENT'
//           ? _buildHistorialServiceAgent(_listHistorialAgent)
//           : _buildHistorialServicePacient(_listHistorialPacient),
//     );
//   }

//   Widget _buildHistorialServiceAgent(List<RequestModel> listRequest) {
//     return _listHistorialAgent.length != 0
//         ? Column(
//             children: listRequest.map(
//             (requestModel) {
//               //_listServicesAgent[index];
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: CircleAvatar(
//                       child: Icon(Icons.person),
//                       backgroundColor: dondeluchoAppTheme.primaryColor,
//                     ),
//                     title: Text(
//                       requestModel?.nameCustomer,
//                       style: TextStyle(
//                           fontSize: 15.0, fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       requestModel.category + "\n" + requestModel?.subcategory,
//                       style: dondeluchoAppTheme.subtitle,
//                       textAlign: TextAlign.center,
//                     ),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Text(
//                           "${money.format(requestModel?.offer)}",
//                           style: TextStyle(
//                               color: dondeluchoAppTheme.primaryColor,
//                               fontSize: 16.0),
//                         ),
//                         Text(
//                             "${DateFormat('MMM d').format(requestModel.schulde.toDate())}",
//                             style: dondeluchoAppTheme.subtitle),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.black54,
//                   )
//                 ],
//               );
//             },
//           ).toList())
//         : Center(
//             child: Text(
//               "Aún no ha tenido servicios",
//               style: TextStyle(color: PRIMARY_COLOR),
//             ),
//           );
//   }

//   Widget _buildHistorialServicePacient(List<RequestModel> listRequest) {
//     return _listHistorialPacient.length != 0
//         ? Column(
//             children: listRequest.map(
//             (requestModel) {
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: CircleAvatar(
//                       child: Icon(Icons.person),
//                       backgroundColor: dondeluchoAppTheme.primaryColor,
//                     ),
//                     title: Text(
//                       requestModel.nameCustomer,
//                       style: TextStyle(
//                           fontSize: 15.0, fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       requestModel.category + "\n" + requestModel.subcategory,
//                       style: dondeluchoAppTheme.subtitle,
//                       textAlign: TextAlign.center,
//                     ),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Text(
//                           "${money.format(requestModel?.offer)}",
//                           style: TextStyle(
//                               color: dondeluchoAppTheme.primaryColor,
//                               fontSize: 16.0),
//                         ),
//                         Text(
//                             "${DateFormat('MMM d').format(requestModel.schulde.toDate())}",
//                             style: dondeluchoAppTheme.subtitle),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.black54,
//                   )
//                 ],
//               );
//             },
//           ).toList())
//         : Center(
//             child: Text(
//               "Aún no ha tenido servicios",
//               style: TextStyle(color: PRIMARY_COLOR),
//             ),
//           );
//   }
// }
