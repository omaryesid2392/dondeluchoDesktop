class ConfigModel {
  ConfigModel({
    // this.localizacion,
    this.uid,
    this.clave,
    this.otra,
  });
  //GeoPoint localizacion;
  String uid;
  String clave;
  String otra;

  factory ConfigModel.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ConfigModel(
      uid: doc.documentID,
      clave: data['clave'] ?? '',
      otra: data['otra'] ?? '',
    );
  }

  factory ConfigModel.map(Map data) {
    return ConfigModel(
      clave: data['clave'] ?? '',
      otra: data['otra'] ?? '',
    );
  }
}
