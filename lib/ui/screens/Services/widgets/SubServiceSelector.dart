//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondelucho/app_theme.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubServiceSelector extends StatefulWidget {
  //SubServiceSelector({Key key}) : super(key: key);
  final ServiceModel service;
  final GlobalKey key;

  SubServiceSelector({@required this.service, this.key});

  @override
  _SubServiceSelectorState createState() => _SubServiceSelectorState();
}

class _SubServiceSelectorState extends State<SubServiceSelector> {
  int _currentindex = -1;
  bool _isSelected = false;

  bool _isSelectedOffer = false;
  int _currentindexOffer = -1;

  String _priceSelected = 'Seleccione servicio';
  String _price;
  List<Offer> _offers;
  Offer _offerSelected;
  String _offerSelectedGroup;
  double _heightOffer = 0;
  String _offerDescription = '';

  List<Subcategories> _subcategories = [];

  @override
  void initState() {
    fetchSubcategories();

    super.initState();
  }

  Widget _buildItemSelect(String title, String subtitle) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: _isSelected
            ? dondeluchoAppTheme.primaryColor
            : dondeluchoAppTheme.nearlyWhite,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: dondeluchoAppTheme.grey.withOpacity(0.2),
              offset: Offset(1.1, 1.1),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding:
            // const EdgeInsets.all(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
            const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.27,
                      color: _isSelected
                          ? dondeluchoAppTheme.nearlyWhite
                          : dondeluchoAppTheme.primaryColor,
                    ),
                  ),
                ),
                subtitle != null
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 13,
                            letterSpacing: 0.27,
                            color: _isSelected
                                ? dondeluchoAppTheme.nearlyWhite
                                : dondeluchoAppTheme.primaryColor,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemSelectOffer(String title, String price) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: _isSelectedOffer
            ? dondeluchoAppTheme.primaryColor
            : dondeluchoAppTheme.nearlyWhite,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: dondeluchoAppTheme.grey.withOpacity(0.2),
              offset: Offset(1.1, 1.1),
              blurRadius: 8.0),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        // color: Colors.red,
        // child: Padding(
        //   padding: const EdgeInsets.only(
        //       left: 8.0, right: 8.0, top: 0.0, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: _isSelectedOffer
                      ? dondeluchoAppTheme.nearlyWhite
                      : dondeluchoAppTheme.primaryColor,
                ),
              ),
            ),
            price != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      money.format(double.parse(price)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: _isSelectedOffer
                            ? dondeluchoAppTheme.nearlyWhite
                            : dondeluchoAppTheme.primaryColor,
                      ),
                    ),
                  )
                : Container(),
          ],
          // ),
        ),
      ),
    );
  }

  List<Widget> _buildOfferServices() {
    return _offers.map((offer) {
      var index = _offers.indexOf(offer);

      //print(index);
      _isSelectedOffer = _currentindexOffer == index;

      return GestureDetector(
        onTap: () async {
          setState(() {
            _currentindexOffer = index;
            // _offers = subcategory['offers'] ?? null;
            _offerSelected = offer;
            print(_currentindexOffer);
            print('EEEEEEEEEEE');
            print(index);

            // serviceBloc.setOffer = offer;
            //print(serviceBloc.offer.price.toString());

            //_priceSelected = offer.price.toString();

            //serviceBloc.setSubcategory = offer;

            //print(offer.containsKey('description'));
            //_offerDescription = offer['description'] != null ? offer['description'] : '';
            // _offerDescription =
            //     offer.containsKey('description') ? offer['description'] : '';
          });
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: _buildItemSelectOffer(
                    offer.title, offer.price.toString()))),
      );
    }).toList();
  }

  void getIdOfferSeleted() async {
    // print('getIdOfferSeleted()');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _offerSelectedGroup = prefs.getString('offerSelected');
      // print(_offerSelectedGroup);
    });
  }

  void fetchSubcategories() async {
    final res = await widget.service.reference
        .collection('subcategories')
        .getDocuments();

    List<Subcategories> subcategories = res.documents
        .map((doc) => Subcategories.fromMap(doc.data, doc.documentID))
        .toList();

    if (this.mounted) {
      _subcategories = subcategories;
    }
  }

  @override
  Widget build(BuildContext context) {
    //getIdOfferSeleted();

    return Column(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 18, right: 16, bottom: 8, top: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // serviceBloc.offer.price == 0
              //     ?
              Text(
                _priceSelected,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: dondeluchoAppTheme.primaryColor,
                ),
              ),
              // :
              Container(
                //margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                child: Text(
                  _offerDescription,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 100.0,
          width: double.infinity,
          child: ListView.builder(
            itemCount: _subcategories.length,
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index) {
              // print(_subcategories[index]);

              Subcategories _subCategory = _subcategories[index];

              _isSelected = _currentindex == index;
              print('#########################' +
                  _subcategories.length.toString());
              if (_subcategories.length == 0) {
                return CircularProgressIndicator();
              }

              return GestureDetector(
                onTap: () async {
                  // serviceBloc.setCategory = _subcategories[index];

                  setState(() {
                    _currentindexOffer = -1;

                    _currentindex = index;
                    _offers = _subCategory.offers;

                    _offerSelected = _offers != null ? _offers[0] : null;

                    // if (_subCategory.data['attach'] == true) {
                    //   serviceBloc.setActivedAttach = true;
                    // } else {
                    //   serviceBloc.setActivedAttach = false;
                    // }

                    //  print('_OFFERS: ${_offers.toString()}');
                    //serviceBloc.setSubcategory = _su;

                    _offerDescription = '';
                  });

                  await Future.delayed(const Duration(milliseconds: 200));
                  setState(() {
                    _heightOffer = 1;
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildItemSelect(_subcategories[index].name, null)),
              );
            },
          ),
        ),
        _offers != null
            ? AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _heightOffer,
                curve: Curves.easeInOut,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  child: ListView(
                      padding: EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      children: _buildOfferServices()),
                ),
              )
            : Text(''),
      ],
    );
  }
}
