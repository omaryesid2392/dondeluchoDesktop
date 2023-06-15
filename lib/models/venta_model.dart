import 'package:dondelucho/models/product_model.dart';

class modeloVenta {
  String uid;
  String idCliente;
  String idEmployee;
  num fechaVenta;
  num descuento;
  num total;
  String numeroFactura;
  String sede;
  List<ProductDetalle> listProductosDetalle;

  modeloVenta({
    this.uid,
    this.idCliente,
    this.idEmployee,
    this.fechaVenta,
    this.listProductosDetalle,
    this.descuento,
    this.total,
    this.numeroFactura,
    this.sede,
  });

  factory modeloVenta.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return modeloVenta(
      uid: data['uid'] ?? '',
      idCliente: data['idCliente'] ?? '',
      idEmployee: data['idEmployee'] ?? '',
      fechaVenta: data['fechaVenta'] ?? 0,
      descuento: data['descuento'] ?? 0,
      total: data['total'] ?? 0,
      numeroFactura: data['numeroFactura'] ?? '',
      sede: data['sede'] ?? '',
      listProductosDetalle: List<ProductDetalle>.from(
          data["listProductos"] != null
              ? data["listProductos"].map((x) => x)
              : []),
    );
  }

  factory modeloVenta.fromMap(Map data) {
    return modeloVenta(
      uid: data['uid'] ?? '',
      idCliente: data['idCliente'] ?? '',
      idEmployee: data['idEmployee'] ?? '',
      fechaVenta: data['fechaVenta'] ?? null,
      descuento: data['descuento'] ?? 0,
      total: data['total'] ?? 0,
      sede: data['sede'] ?? '',
      numeroFactura: data['numeroFactura'] ?? '',
      listProductosDetalle: List<ProductDetalle>.from(
          data["listProductoDetalle"] != null
              ? data["listProductoDetalle"]
                  .map((x) => ProductDetalle.fromMap(x))
              : []),
    );
  }
}
