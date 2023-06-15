class ModelSetting {
  ModelSetting({
    // this.localizacion,
    this.uid,
    this.clave,
  });
  //GeoPoint localizacion;
  String uid;
  String clave;

  factory ModelSetting.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ModelSetting(
      uid: doc.documentID,
      clave: data['clave'] ?? 'dondelucho',
    );
  }

  factory ModelSetting.map(Map data) {
    return ModelSetting(
      clave: data['clave'] ?? 'dondelucho',
    );
  }
}
