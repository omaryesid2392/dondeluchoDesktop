import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dondelucho/constant.dart';
import 'package:dondelucho/models/model_establecimientos.dart';
import 'package:dondelucho/models/product_model.dart';
import 'package:dondelucho/models/user_model.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
//import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printing/printing.dart';

class PDFScreen extends StatefulWidget {
  static const String id = 'pdf_screen';
  final List<ProductDetalle> listProductoDetalleConDescuento;
  num descuento;
  Establecimiento establecimiento;
  String nFactura;
  num total;
  num total2;
  String vendedor;
  ModelUser2 cliente;
  Map<String, dynamic> vueltas;
  PDFScreen(
      {Key key,
      this.listProductoDetalleConDescuento,
      this.establecimiento,
      this.nFactura,
      this.total,
      this.descuento,
      this.vendedor,
      this.cliente,
      this.total2,
      this.vueltas})
      : super(key: key);
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  pw.Document pdf;
  PdfImage imagen;
  Uint8List archivoPdf;

  double sizeIcon1 = 45;
  double sizeIcon2 = 30;
  double sizeIcon3 = 30;
  num totalF = 0;
  num totalD = 0;

  List<ProductDetalle> listProductoDetalleConDescuento = [];
  @override
  void initState() {
    super.initState();
    listProductoDetalleConDescuento = widget.listProductoDetalleConDescuento;
    setState(() {
      listProductoDetalleConDescuento;
    });
    print(widget.listProductoDetalleConDescuento[0].cant);
    initPDF();
  }

  Future<void> initPDF() async {
    try {
      archivoPdf = await generarPdf1();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void iconoSeleccionado(int numero) {
    if (numero == 1) {
      sizeIcon1 = 45;
      sizeIcon2 = 30;
      sizeIcon3 = 30;
    } else if (numero == 2) {
      sizeIcon1 = 30;
      sizeIcon2 = 45;
      sizeIcon3 = 30;
    } else {
      sizeIcon1 = 30;
      sizeIcon2 = 30;
      sizeIcon3 = 45;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡¡¡ Facturación  exitosa !!!'),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 25,
                    ),
                    child: PdfPreview(
                      build: (format) => archivoPdf,
                      useActions: false,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 50,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       GestureDetector(
                //         onTap: () async {
                //           archivoPdf = await generarPdf1();
                //           setState(
                //             () {
                //               iconoSeleccionado(1);
                //               archivoPdf = archivoPdf;
                //             },
                //           );
                //         },
                //         child: Icon(
                //           Icons.picture_as_pdf,
                //           size: sizeIcon1,
                //           color: Colors.red,
                //         ),
                //       ),

                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Printing.sharePdf(
                            bytes: archivoPdf,
                            filename: '${widget.nFactura}.pdf');
                      },
                      child: Icon(
                        Icons.save_alt,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //final pdf = await rootBundle.load('document.pdf');
                        await Printing.layoutPdf(
                            onLayout: (_) => archivoPdf.buffer.asUint8List());
                      },
                      child: Icon(
                        Icons.print,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> generarPdf1() async {
    pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (context) => pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Column(children: [
            pw.Center(
              child: pw.Text(
                'dondelucho',
                style: pw.TextStyle(
                  fontSize: 30,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Text(
              '${widget.establecimiento?.name}',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Nit: ${widget.establecimiento?.nit}',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Dirección: ${widget.establecimiento?.direction}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Nro factura: ${widget.nFactura}',
              style: pw.TextStyle(
                fontSize: 7,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            _listProduc(),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Text(
                    'Total    :',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    money.format(widget.total),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
            pw.Text(
              '-------------------------------------------',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Text(
                    'Descuento    :',
                    style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    money.format(widget.descuento),
                    style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
            pw.Text(
              '-------------------------------------------',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Text(
                    'Total a pagar  :',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    money.format(widget.total2),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
            pw.Text(
              '-------------------------------------------',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(
                      'Forma de pago:',
                      style: pw.TextStyle(
                        //fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Efectivo',
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(
                      'Pagó:',
                      style: pw.TextStyle(
                        //fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      widget.vueltas['dinero'] != 0
                          ? money.format(widget.vueltas['dinero'])
                          : money.format(widget.total2),
                      style: pw.TextStyle(
                        //fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(
                      'Vueltas:',
                      style: pw.TextStyle(
                        //fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      money.format(widget.vueltas['vueltas']),
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ]),
              pw.Text(
                '-------------------------------------------',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ]),
            pw.Text(
              'IMPORTANTE',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              '*Revise su mercancía que salga completa y en perfecto estado\n*La garantía NO cubre humedad, golpes, táctil ni display\n*No se hace cambio sin justa causa\n*Los accesorios no tienen garantía\n*No se responde por equipo apagado',
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.Text(
              '-------------------------------------------',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Vendedor: ${widget.vendedor}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.RichText(
              textAlign: pw.TextAlign.justify,
              text: pw.TextSpan(children: [
                pw.TextSpan(
                  text: 'Cliente: ${widget.cliente.name}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                  ),
                ),
                pw.TextSpan(
                  text: '(${widget.cliente.id})',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                  ),
                ),
              ]),
            ),
            pw.Text(
              'Fecha factura: ${DateTime.now()}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ]),
        ),
      ),
      // pw. MultiPage(
      //   pageFormat: PdfPageFormat.roll57,
      //   margin: pw.EdgeInsets.zero,
      //   build: (context) => [
      //     pw.Padding(
      //       padding: pw.EdgeInsets.symmetric(vertical: 20),
      //       child: pw.Center(
      //         child: pw.Text(
      //           'Prueba Número 1',
      //           style: pw.TextStyle(
      //             fontSize: 30,
      //             color: PdfColors.blue,
      //           ),
      //           textAlign: pw.TextAlign.center,
      //         ),
      //       ),
      //     ),
      //     pw.Row(
      //       mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      //       children: [
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //       ],
      //     ),
      //     pw.SizedBox(
      //       height: 20,
      //     ),
      //     pw.Padding(
      //       padding: pw.EdgeInsets.symmetric(
      //         vertical: 10,
      //         horizontal: 20,
      //       ),
      //       child: pw.Text(
      //         ' Luis k cel',
      //         style: pw.TextStyle(
      //           fontSize: 20,
      //         ),
      //         textAlign: pw.TextAlign.justify,
      //       ),
      //     ),
      //     pw.SizedBox(
      //       height: 70,
      //     ),
      //     pw.Row(
      //       mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      //       children: [
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //         // pw.Image(
      //         //   imagen,
      //         //   height: 70,
      //         //   width: 70,
      //         // ),
      //       ],
      //     ),
      //   ],
      // ),
    );
    return pdf.save();
  }

  pw.Widget _listProduc() {
    listProductoDetalleConDescuento.forEach((element) {
      print(element.cant);
    });
    return pw.Column(children: [
      pw.Table(
        columnWidths: {
          0: pw.FractionColumnWidth(0.2),
          1: pw.FractionColumnWidth(0.5),
          2: pw.FractionColumnWidth(0.3),
          //4: FractionColumnWidth(0.1),
        },
        border: pw.TableBorder.all(),
        children: [
          pw.TableRow(children: [
            pw.Text(
              'Cant',
              textAlign: pw.TextAlign.center,
              style:
                  pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Detalle',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Valor',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ])
        ],
      ),
      pw.Table(
        columnWidths: {
          0: pw.FractionColumnWidth(0.2),
          1: pw.FractionColumnWidth(0.5),
          2: pw.FractionColumnWidth(0.3),
          //4: FractionColumnWidth(0.1),
        },
        border: pw.TableBorder.all(),
        children: listProductoDetalleConDescuento
            .map((elemennt) => pw.TableRow(children: [
                  pw.Text(
                    elemennt.cant.toString(),
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
                    elemennt.producto.imei != '' &&
                            elemennt.producto.imei != null
                        ? pw.Text(
                            elemennt.producto.name +
                                '(${elemennt.producto.imei})',
                            style: pw.TextStyle(
                              fontSize: 7,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                            overflow: pw.TextOverflow.clip,
                            maxLines: 2,
                          )
                        : pw.Text(
                            elemennt.producto.name +
                                '(${elemennt.producto?.codProduct})',
                            style: pw.TextStyle(
                              fontSize: 7,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                            overflow: pw.TextOverflow.clip,
                            maxLines: 2,
                          ),
                    pw.Text(
                      elemennt.producto.description.length > 15
                          ? elemennt.producto.description.substring(0, 15)
                          : elemennt.producto.description,
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                      overflow: pw.TextOverflow.clip,
                      maxLines: 2,
                    ),
                  ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisSize: pw.MainAxisSize.max,
                      children: [
                        pw.Text(
                          money.format(
                            elemennt.producto?.vPublico,
                          ),
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ])
                ]))
            .toList(),
      )
    ]);
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Prueba Número 3',
            style: pw.TextStyle(
              fontSize: 35,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(
            height: 4,
          ),
          pw.Container(
            height: 1,
            color: PdfColors.green,
          ),
          pw.SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              fontSize: 20,
              color: PdfColors.grey,
            ),
            textAlign: pw.TextAlign.right,
          ),
          pw.SizedBox(
            height: 4,
          ),
          pw.Container(
            height: 1,
            color: PdfColors.green,
          ),
        ],
      ),
    );
  }
}
