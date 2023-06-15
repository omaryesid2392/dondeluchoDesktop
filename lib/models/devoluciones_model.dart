import 'package:dondelucho/models/product_model.dart';

class modeloDevolucion {
  String uid;
  String idCliente;
  String idVendedor;
  String fechaVenta;
  num descuento;
  num total;
  var fechaDevolucion;
  String numeroFactura;
  String sede;
  List<ProductDetalle> listProductosDetalle;

  modeloDevolucion(
      {this.uid,
      this.idCliente,
      this.idVendedor,
      this.fechaVenta,
      this.listProductosDetalle,
      this.descuento,
      this.total,
      this.numeroFactura,
      this.sede,
      this.fechaDevolucion});

  factory modeloDevolucion.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return modeloDevolucion(
      uid: data['uid'] ?? '',
      idCliente: data['idCliente'] ?? '',
      idVendedor: data['idVendedor'] ?? '',
      fechaVenta: data['fechaVenta'] ?? 0,
      descuento: data['descuento'] ?? 0,
      total: data['total'] ?? 0,
      numeroFactura: data['numeroFactura'] ?? '',
      sede: data['sede'] ?? '',
      fechaDevolucion: data['fechaDevolucion'] ?? null,
      listProductosDetalle: List<ProductDetalle>.from(
          data["listProductos"] != null
              ? data["listProductos"].map((x) => x)
              : []),
    );
  }

  factory modeloDevolucion.fromMap(Map data) {
    return modeloDevolucion(
      uid: data['uid'] ?? '',
      idCliente: data['idCliente'] ?? '',
      idVendedor: data['idVendedor'] ?? '',
      fechaVenta: data['fechaVenta'] ?? null,
      descuento: data['descuento'] ?? 0,
      total: data['total'] ?? 0,
      sede: data['sede'] ?? '',
      numeroFactura: data['numeroFactura'] ?? '',
      fechaDevolucion: data['fechaDevolucion'] ?? null,
      listProductosDetalle: List<ProductDetalle>.from(
          data["listProductoDetalle"] != null
              ? data["listProductoDetalle"]
                  .map((x) => ProductDetalle.fromMap(x))
              : []),
    );
  }
}
