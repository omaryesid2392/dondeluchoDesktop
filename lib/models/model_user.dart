

class ModelUser {
  ModelUser({
    // this.localizacion,
    this.uid,
    this.name,
    this.genero,
    this.email,
    this.rol,
    this.city,
    this.type,
    this.description,
    this.photoURL,
    this.title,
    this.rating,
    this.cel,
    this.cel2,
    this.direction,
    this.distance,
    this.id,
  });
  //GeoPoint localizacion;
  String uid;
  String name;
  String genero;
  String email;
  String rol;
  String city;
  String type;
  String photoURL;
  String description;
  String title;
  num rating;
  String cel;
  String cel2;
  String direction;
  num distance;
  num id;

  factory ModelUser.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ModelUser(
      uid: doc.documentID,
      name: data['name'] ?? '',
      genero: data['genero'] ?? '',
      email: data['email'] ?? '',
      rol: data['rol'] ?? '',
      city: data['city'] ?? '',
      type: data['type'] ?? '',
      //localizacion: data['location'] ?? '',
      photoURL: data['photoURL'] ?? null,
      description: data['description'] ?? '',
      title: data['title'] ?? '',
      rating: data['rating'],
      cel: data['cel'],
      cel2: data['cel2'],
      direction: data['direction'],
      id: data['id'],
      // distance: data['distance'],
    );
  }

  factory ModelUser.map(Map data) {
    return ModelUser(
      name: data['name'] ?? '',
      genero: data['genero'] ?? '',
      email: data['email'] ?? '',
      rol: data['rol'] ?? '',
      city: data['city'] ?? '',
      type: data['type'] ?? '',
      //localizacion: data['location'] ?? '',
      photoURL: data['photoURL'] ?? null,
      description: data['description'] ?? '',
      title: data['title'] ?? '',
      rating: data['rating'],
      cel: data['cel'],
      cel2: data['cel2'],
      direction: data['direction'],
      id: data['id'],
      // distance: data['distance'],
    );
  }
}
