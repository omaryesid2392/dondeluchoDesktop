import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color PRIMARY_COLOR = Color.fromRGBO(0, 80, 181, 1);
const Color PRIMARY_COLOR_DARK = Color.fromRGBO(90, 100, 129, 1);

// const List ROL = [
//   {'agent': 'Agente'},
//   {'customer':'Paciente'}
// ];
Widget home() {
  return Opacity(
    opacity: 0.1,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/logo.png'), fit: BoxFit.scaleDown),
      ),
    ),
  );
}

final money = NumberFormat.currency(
    symbol: '\$', decimalDigits: 0, locale: "en_CA", name: "CAD");

const Gradient PRIMARY_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.4),
    end: FractionalOffset(0.0, 1.0),
    colors: [PRIMARY_COLOR, PRIMARY_COLOR_DARK]);

const Gradient LIGHT_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(220, 220, 220, 0.8),
      Colors.white,
    ]);

const Gradient PASION_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(213, 53, 49, 1),
      Color.fromRGBO(227, 93, 91, 1),
    ]);

const Gradient BLUE_SKIES_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(81, 152, 248, 1),
      Color.fromRGBO(47, 128, 237, 1),
    ]);

const Gradient SEA_BLIZZ_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(44, 192, 228, 1),
      Color.fromRGBO(24, 178, 216, 1),
    ]);

const Gradient ORANGE_1 = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(255, 81, 47, 1),
      Color.fromRGBO(240, 152, 25, 1),
    ]);

const Gradient SEA_2 = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(95, 219, 223, 1),
      Color.fromRGBO(95, 208, 223, 1),
    ]);

const Gradient SEA_3 = LinearGradient(
    begin: FractionalOffset(0.0, 0.2),
    end: FractionalOffset(0.0, 1.0),
    colors: [
      Color.fromRGBO(95, 187, 223, 1),
      Color.fromRGBO(95, 176, 223, 1),
    ]);

const List<Map> CATEGORIES = [
  {
    "title": "Medicina",
    "subtitle": "General",
    "fullname": "Medicina General",
    "icon": "assets/icons/24-doctor@3x.png",
    "image": "assets/images/medicine_prevent.png",
    "description":
        "Servicios medicos generales, atención preventiva y curativa. Malestares generales. Diagnosticos",
    "subcategories": [
      {
        "title": "Consulta Médica",
        "description": "Enfermería",
        "price": "70.000"
      }
    ]
  },
  {
    "title": "sss",
    "subtitle": "Inyectología",
    "fullname": "Enfermería ",
    "icon": "assets/icons/01-nurse@3x.png",
    "image": "assets/images/medicine_prevent.png",
    "description":
        "Profesionales de la enfermería dispuestos para atender sus curaciones, cuidado adulto mayor.",
    "subcategories": [
      {
        "title": "Inyectología",
        "description": "Enfermería",
        "price": "12.000",
        "subcategories": {
          {
            "title": "Intravenosa",
            "description": "Enfermería",
            "price": "2.000"
          },
          {
            "title": "Intramoscular",
            "description": "Enfermería",
            "price": "2.000"
          },
        }
      },
      {
        "title": "Curación",
        "description": "Enfermería",
        "price": "5.000",
        "photos": "true"
      },
      {
        "title": "Turno de Enfermería",
        "description": "Enfermería",
        "price": "8.000",
        "subcategories": {
          {
            "title": "Turno ordinario",
            "description": "Enfermería",
            "price": "2.000"
          },
          {
            "title": "Turno nocturno",
            "description": "Inyectología",
            "price": "8.000"
          },
          {
            "title": "Turno festivo",
            "description": "Inyectología",
            "price": "2.000"
          }
        }
      },
    ]
  },
  {
    "title": "",
    "subtitle": "Fisioterapia",
    "fullname": "Fisioterapia",
    "icon": "assets/icons/04-medical result@3x.png",
    "image": "assets/images/medicine_prevent.png",
    "description": "Terapia pasiva, dolores, fisioterapias. Diagnosticos",
    "subcategories": [
      {
        "title": "Terapia Física",
        "description": "Enfermería",
        "price": "40.000"
      },
      {
        "title": "Terapia Respiratoria",
        "description": "Enfermería",
        "price": "80.000"
      },
    ]
  }
];
