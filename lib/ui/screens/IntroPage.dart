import 'package:dondelucho/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:dondelucho/ui/widgets/backgrounds.dart';

import 'package:dondelucho/constant.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widgetBackground(),
          //_logo(),
          //_textIntro(),
          _sliderIntro(),
          // _btnStart(),
          // _btnLogin(),
        ],
      ),
      bottomSheet: Container(
        height: 120.0,
        width: double.infinity,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _btnStart(),
            _btnLogin(),
          ],
        ),
      ),
    );
  }

  Widget _sliderIntro() {
    Map slider = {
      0: {
        'icon': 'assets/images/ob1.png',
        'primary': 'Golden System: ',
        'description':
            'Te permite mejorar la eficiencia operativa, reducir costos, minimizar pérdidas y mejorar la precisión en el seguimiento de los productos.'
      },
      1: {
        'icon': 'assets/images/ob2.png',
        'primary': 'Crece siempre: ',
        'description':
            'Con nuestro sistema de control de inventario y ventas manten tú negocio siempre creciente y extiso'
      },
      2: {
        'icon': 'assets/images/ob3.png',
        'primary': 'Equilibra tus ventas e inventarios: ',
        'description':
            'Control y equilibrio de los inventarios y las ventas e información confiable es lo que tú negocio necesita.'
      }
    };

    return Positioned(
        //bottom: _size.height * 0.19,
        child: Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1, child: _logo()),
          Expanded(
            flex: 8,
            child: Container(
              //margin: EdgeInsets.symmetric(vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height * 0.5,
              //height: 500.0,
              //color: Colors.amber,
              child: new Swiper(
                curve: Curves.bounceOut,

                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Container(
                          //height: 300.0,
                          //padding: EdgeInsets.all(5.0),
                          child: Image.asset(slider[index]['icon']),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                              //margin: EdgeInsets.only(top:10.0),
                              //height: 120,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: slider[index]['primary'],
                                    style: dondeluchoAppTheme.body2Primary,
                                  ),
                                  TextSpan(
                                      text: slider[index]['description'],
                                      style: dondeluchoAppTheme.body1)
                                ]),
                              ))
                          // child:   Wrap(children: <Widget>[
                          //     Text(slider[index]['primary'], style: DraviMedicAppTheme.body1, textAlign: TextAlign.center,),
                          //     Text(slider[index]['description'], style: DraviMedicAppTheme.body2, textAlign: TextAlign.center,)
                          //   ],)
                          // ),
                          ),
                    ],
                  );
                },
                itemCount: 3,
                itemHeight: 300.0,
                // control: SwiperControl(
                //   color: Colors.blue
                // ),
                pagination: new SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.grey[300],
                        activeColor: dondeluchoAppTheme.primaryColor)),
                viewportFraction: 1,
                //containerHeight: 300.0,
                scale: 1,
              ),
            ),
          )
        ],
      ),
    ));
  }

  // Widget _textIntro(){
  //   return Positioned(
  //     bottom: _size.height * 0.2,
  //     child: Container(
  //       width: _size.width * 0.6,
  //       child: Text(
  //         "Solicita tu servicio medico profesional a domicilio. DraviMedic para ti!",
  //         style: TextStyle(color: Colors.grey, fontSize: 15.0),
  //         textAlign: TextAlign.center,

  //       ),
  //     ),
  //   );
  // }

  Widget _btnStart() {
    return RaisedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'RegisterPage');
      },
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text('Crear una cuenta', textAlign: TextAlign.center)),
      shape: StadiumBorder(),
      color: PRIMARY_COLOR,
      textColor: Colors.white,
      elevation: 1.0,
    );
  }

  Widget _btnLogin() {
    return RaisedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'LoginPage');
      },
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text('Iniciar sesión', textAlign: TextAlign.center)),
      shape: StadiumBorder(),
      color: Colors.white,
      textColor: PRIMARY_COLOR,
      elevation: 1.0,
    );
  }

  Widget _logo() {
    return Image(width: 250.0, image: AssetImage('assets/images/logo.png'));
  }
}
