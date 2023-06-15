

class Categories {
  List<Category> categories;

  Categories({
    this.categories,
  });
}

class Category {
  Category({
    this.name,
    this.uid,
    this.categories,
    this.ref,
  });

  String name;
  String uid;
  String ref;
  List<String> categories;

  factory Category.fromMap(dynamic doc) => Category(
      uid: doc['uid'],
      ref: doc['ref'],
      name: doc['data']["name"] == null ? null : doc['data']["name"],
      categories: doc['data']["categories"] == null
          ? null
          : List<String>.from(doc['data']["categories"].map((x) => x)),
    );
  

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "uid": uid == null ? null : uid,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x)),
      };
}

class Subcategory {
  Subcategory({
    this.name,
    this.uid,
    this.subcategories,
    this.ref,
  });

  String name;
  String uid;
  List<String> subcategories;
  String ref;

  factory Subcategory.fromMap(dynamic doc)=> Subcategory(
      uid: doc['uid'],
      ref: doc['ref'],
      name: doc['data']["name"] == null ? null : doc['data']["name"],
      subcategories: doc['data']["subcategories"] == null
          ? null
          : List<String>.from(doc['data']["subcategories"].map((x) => x)),
    );
  

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "uid": uid == null ? null : uid,
        "subcategories": subcategories == null
            ? null
            : List<dynamic>.from(subcategories.map((x) => x)),
      };
}
