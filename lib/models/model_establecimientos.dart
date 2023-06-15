
import 'dart:convert';

ModelEstablecimientos modelEstablecimientosFromMap(String str) => ModelEstablecimientos.fromMap(json.decode(str));

String modelEstablecimientosToMap(ModelEstablecimientos data) => json.encode(data.toMap());

class ModelEstablecimientos {
    ModelEstablecimientos({
        this.uid,
        this.establecimientos,
    });

    String uid;
    List<Establecimiento> establecimientos;

    factory ModelEstablecimientos.fromMap(Map<String, dynamic> json) => ModelEstablecimientos(
        uid: json["uid"],
        establecimientos: List<Establecimiento>.from(json["establecimientos"].map((x) => Establecimiento.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "uid": uid,
        "establecimientos": List<dynamic>.from(establecimientos.map((x) => x.toMap())),
    };
}

class Establecimiento {
    Establecimiento({
        this.name,
        this.direction,
        this.nit,
        this.cel,
        this.codigo,
    });

    String name;
    String direction;
    String nit;
    String cel;
    String codigo;

    factory Establecimiento.fromMap(Map<String, dynamic> json) => Establecimiento(
        name: json["name"],
        direction: json["direction"],
        nit: json["nit"],
        cel: json["cel"],
        codigo: json["codigo"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "direction": direction,
        "nit": nit,
        "cel": cel,
        "codigo": codigo,

    };
}
