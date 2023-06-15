import 'dart:convert';


class UserModel2 {
  UserModel2({
    this.tokenFCM,
    this.uid,
    this.name,
    this.email,
    this.rol,
    this.city,
    this.direction,
    this.cel,
    this.id,
    // this.fechaNacimiento
  });
  String tokenFCM;
  String uid;
  String name;
  String email;
  String rol;
  String city;
  String direction;
  String cel;
  String id;

  factory UserModel2.fromJson(String str) =>
      UserModel2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel2.fromSnapshot(dynamic doc) {
    final user = UserModel2.fromMap(doc.data);
    user.uid = doc.documentID;
    // user.reference = doc.reference;
    //user.fecha = doc.data['fechaNacimiento'].toDate();
    //user.location = doc.data['location'];

    return user;
  }

  //GeoPoint geoJson() => json.encode(geoMap());

  factory UserModel2.fromMap(Map<dynamic, dynamic> json) => UserModel2(
        tokenFCM: json["tokenFCM"] == null ? null : json["tokenFCM"],
        uid: json["uid"] == null ? null : json["uid"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        rol: json["rol"] == null ? null : json["rol"],
        city: json["city"] == null ? null : json["city"],
        direction: json["direction"] == null ? null : json["direction"],
        cel: json["cel"] == null ? null : json["cel"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<dynamic, dynamic> toMap() => {
        "tokenFCM": tokenFCM == null ? null : tokenFCM,
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "rol": rol == null ? null : rol,
        "city": city == null ? null : city,
        "direction": direction == null ? null : direction,
        "cel": cel == null ? null : cel,
        "id": id == null ? null : id,
      };
}

class ModelUser2 {
  String uid;
  String cel;
  String name;
  String email;
  String rol;
  String id;
  String password;
  String tokenFCM;
  String photoURL;
  String direction;
  String uidEstablecimientos;
  String sede;

  ModelUser2({
    this.uid,
    this.cel,
    this.name,
    this.rol,
    this.tokenFCM,
    this.email,
    this.password,
    this.id,
    this.direction,
    this.photoURL,
    this.uidEstablecimientos,
    this.sede,
  });

  factory ModelUser2.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ModelUser2(
      uid: doc.documentID,
      cel: data['cel'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      rol: data['rol'] ?? '',
      tokenFCM: data['tokenFCM'] ?? '',
      direction: data['direction'] ?? '',
      photoURL: data['photoURL'] ?? '',
      uidEstablecimientos: data['uidEstablecimientos'] ?? '',
      sede: data['sede'] ?? '',
    );
  }

  factory ModelUser2.fromMap(Map data) {
    return ModelUser2(
      uid: data['uid'] ?? '',
      id: data['id'] ?? '',
      cel: data['cel'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      rol: data['rol'] ?? '',
      password: data['password'] ?? '',
      tokenFCM: data['tokenFCM'] ?? '',
      direction: data['direction'] ?? '',
      photoURL: data['photoURL'] ?? '',
      uidEstablecimientos: data['uidEstablecimientos'] ?? '',
      sede: data['sede'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  Map<dynamic, dynamic> toMap() => {
        'uid': uid ?? '',
        'id': id ?? '',
        'cel': cel ?? '',
        'email': email ?? '',
        'name': name ?? '',
        'rol': rol ?? '',
        'password': password ?? '',
        'tokenFCM': tokenFCM ?? '',
        'direction': direction ?? '',
        'photoURL': photoURL ?? '',
        'uidEstablecimientos': uidEstablecimientos ?? '',
        'sede': sede ?? '',
      };
}
