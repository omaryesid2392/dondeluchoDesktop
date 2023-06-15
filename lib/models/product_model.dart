
class ProductModel {
  String uid;
  String description;
  String name;
  String codProduct;
  num vCompra;
  num vMinVenta;
  num vPublico;
  num cant;
  String proveedor;
  String imei;
  String refCategory;
  String refSubCategory;
  String sede;

  ProductModel({
    this.uid,
    this.description,
    this.name,
    this.vCompra,
    this.vMinVenta,
    this.vPublico,
    this.cant,
    this.codProduct,
    this.proveedor,
    this.imei,
    this.refCategory,
    this.refSubCategory,
    this.sede,
  });

  factory ProductModel.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ProductModel(
      uid: doc.documentID,
      description: data['description'] ?? '',
      codProduct: data['codProduct'] ?? '',
      name: data['name'] ?? '',
      proveedor: data['proveedor'] ?? '',
      vCompra: data['vCompra'] ?? 0,
      vMinVenta: data['vMinVenta'] ?? 0,
      vPublico: data['vPublico'] ?? 0,
      cant: data['cant'] ?? 0,
      imei: data['imei'] ?? '',
      sede: data['sede'] ?? '',
      refSubCategory: data['refSubCategory'] ?? '',
      refCategory: data['refCategory'] ?? '',
    );
  }

  factory ProductModel.fromMap(Map data) {
    return ProductModel(
      uid: data['uid'] ?? '',
      description: data['description'] ?? '',
      codProduct: data['codProduct'] ?? '',
      name: data['name'] ?? '',
      proveedor: data['proveedor'] ?? '',
      vCompra: data['vCompra'] ?? 0,
      vMinVenta: data['vMinVenta'] ?? 0,
      vPublico: data['vPublico'] ?? 0,
      cant: data['cant'] ?? 0,
      imei: data['imei'] ?? '',
      sede: data['sede'] ?? '',
      refCategory: data['refCategory'] ?? '',
      refSubCategory: data['refSubCategory'] ?? '',
    );
  }
}

class ProductDetalle {
  String codigo;
  num cant;
  ProductModel producto;

  ProductDetalle({
    this.codigo,
    this.cant,
    this.producto,
  });

  factory ProductDetalle.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return ProductDetalle(
      codigo: doc.documentID,
      cant: data['cant'] ?? 0,
      producto: data['producto'] ?? null,
    );
  }

  factory ProductDetalle.fromMap(Map data) {
    return ProductDetalle(
      cant: data['cant'] ?? 0,
      producto: ProductModel.fromMap(data['producto']) ?? null,
    );
  }
  factory ProductDetalle.fromMap2(Map data) {
    return ProductDetalle(
      cant: data['cant'] ?? 0,
      producto: data['producto']?? null,
    );
  }
}
