import 'dart:convert';


class ServiceModel {
  dynamic reference;
  String title;
  String subtitle;
  String description;
  String icon;
  String image;
  String category;

  // List<Subcategories> subcategories = new List();

  List<dynamic> subcategories = new List();

  ServiceModel(
      {this.reference,
      this.title,
      this.subtitle,
      this.description,
      this.icon,
      this.image,
      this.category,
      this.subcategories});

  ServiceModel.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'] ?? '',
        subtitle = map['subtitle'] ?? '',
        description = map['description'] ?? '',
        icon = map['icon'] == null ? null : map['icon'],
        image = map['image'] == null ? null : map['image'],
        subcategories = map['subcategories'] ?? null,
        category = map['category'] ?? '';

  ServiceModel.fromSnapshot(dynamic snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "icon": icon,
      "image": image,
      "subcategories": subcategories,
      "category": category
    };
  }
}

class Subcategories {
  String id;
  String name;
  String subtitle;
  List<Offer> offers;

  Subcategories({this.id, this.name, this.subtitle, this.offers});

  factory Subcategories.fromMap(Map snapshot, String id) => Subcategories(
        id: id,
        name: snapshot['name'],
        offers: snapshot["offers"] == null
            ? null
            : List<Offer>.from(snapshot["offers"].map((x) => Offer.fromMap(x))),
      );

  // toJson() {
  //   return {
  //     "name": name,
  //     "subtitle": subtitle,
  //     "offers": offers,
  //   };
  // }
}

class Offer {
  Offer({
    this.title,
    this.price,
  });

  String title;
  int price;

  factory Offer.fromJson(String str) => Offer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Offer.fromMap(Map<dynamic, dynamic> json) => Offer(
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"],
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "price": price == null ? null : price,
      };
}
