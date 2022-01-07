import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:molduras/app/models/encomenda.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:printing/printing.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class EncomendaTab extends StatefulWidget {
  EncomendaTab({Key? key}) : super(key: key);

  @override
  _EncomendaTabState createState() => _EncomendaTabState();
}

class _EncomendaTabState extends State<EncomendaTab>
    with TickerProviderStateMixin {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  final style = TextStyle(
    fontSize: 14,
  );
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();

  TextEditingController _clienteNome = TextEditingController();
  TextEditingController _clienteNif = TextEditingController();
  TextEditingController _clienteTelemovel = TextEditingController();
  TextEditingController _clienteMorada = TextEditingController();
  TextEditingController _clienteLocalidade = TextEditingController();

  TextEditingController _productoPrecoVenda = TextEditingController();
  TextEditingController _productoDescricao = TextEditingController();
  TextEditingController idCliente = TextEditingController();

  TextEditingController _preco = TextEditingController();
  int rowsPerPage = 10;

  bool isLoading = false;
  final inputStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);
  double largura = 0;
  double comprimento = 0;
  double precoVenda = 0;
  Map<String, Encomenda> encomendas = {};
  List data = [];
  List<Widget> _produtos = [];
  List encomendasData = [];
  List encomendasDataSource = [];
  String? codigoCliente;
  double totalMateriasPrimas = 0;
  double totalProdutos = 0;
  double totalEncomenda = 0;

  Map<String, Map<String, dynamic>> _produtosNaLista = {};

  getData() {
    encomendasData.clear();
    //encomendasDataSource = context.read<EncomendasController>().encomendas;

    for (int i = 0; i < encomendasDataSource.length; i++) {
      /*encomendasData.add(Encomendas(
          iva: double.parse(encomendasDataSource[i]["iva"].toString()),
          margemLucro: double.parse(encomendasDataSource[i]["taxa"].toString()),
          sinal: double.parse(encomendasDataSource[i]["sinal"].toString()),
          total: double.parse(encomendasDataSource[i]["total"].toString()),
          subtotal:
              double.parse(encomendasDataSource[i]["subtotal"].toString()),
          materiasPrimas: encomendasDataSource[i]["materiasPrimas"],
          valorPagar:
              double.parse(encomendasDataSource[i]["valor_a_pagar"].toString()),
          produtos: encomendasDataSource[i]["produtos"] ?? [],
          idCliente: encomendasDataSource[i]["id_cliente"],
          estado: encomendasDataSource[i]["estado"],
          codigo: encomendasDataSource[i]["objectId"].toString()));*/
    }
  }

  limparForms() {
    _clienteLocalidade.clear();
    _clienteLocalidade.clear();
    _clienteMorada.clear();
    _clienteNif.clear();
    _clienteNome.clear();
    _clienteTelemovel.clear();
    _sinal = 0;
    totalMateriasPrimas = 0;
    totalProdutos = 0;

    encomendas.clear();
    _produtos.clear();
  }

  List pdfMateriaPrima = [];
  actualizarTela() {
    setState(() {});
  }

  // database variables
  List dbMateriasPrimas = [];
  List dbProdutos = [];

  calcularEncomenda() {
    double valorTotal =
        (totalEncomenda + (totalEncomenda * (_margemLucro / 100)));
    encomendas.forEach((key, produto) {
      dbProdutos.add({
        "produto": produto.produto,
        "preco": produto.preco,
        "comprimento": produto.comprimento,
        "largura": produto.largura,
        "quantidade": produto.quantidade
      });
    });

    print("Data" + data.toString());

    setState(() {
      dbMateriasPrimas = data;

      isLoading = true;
    });
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            bool _loading = false;

            // ignore: unused_local_variable
            double valorPagar = totalEncomenda;
            return AlertDialog(
              content: StatefulBuilder(
                builder: (context, setState) {
                  return ModalProgressHUD(
                    inAsyncCall: _loading,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/aphit.jpg",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(height: 10),
                                    Text("Aphit Molduras", style: style),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Rua do sacramento 37", style: style),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("2500-182 Caldas da Rainha",
                                        style: style),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("932882626", style: style),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Número de Contribuinte: 599999993",
                                        style: style)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 40),
                                    Text("Cliente: ${_clienteNome.text}",
                                        style: style),
                                    SizedBox(height: 5),
                                    Text("NIF: ${_clienteNif.text}",
                                        style: style),
                                    SizedBox(height: 5),
                                    Text("Telemóvel: ${_clienteTelemovel.text}",
                                        style: style),
                                    SizedBox(height: 5),
                                    Text("Morada: ${_clienteMorada.text}",
                                        style: style),
                                    SizedBox(height: 5),
                                    Text(
                                        "Localidade: ${_clienteLocalidade.text}",
                                        style: style),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: RawScrollbar(
                                thickness: 10,
                                isAlwaysShown: true,
                                controller: _scrollController2,
                                child: ListView.builder(
                                  controller: _scrollController2,
                                  itemCount: encomendas.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String key =
                                        encomendas.keys.elementAt(index);
                                    return Column(
                                      children: [
                                        Container(
                                          color: Colors.grey[100],
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 4),
                                          margin: encomendas[key]!
                                                  .materiasPrimas!
                                                  .isEmpty
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 4)
                                              : const EdgeInsets.symmetric(
                                                  vertical: 1),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Produto: ",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      encomendas[key]!.produto!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "DPVP: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        encomendas[key]!
                                                            .preco!
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Comprimento: ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      encomendas[key]!
                                                          .comprimento
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Largura: ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      encomendas[key]!
                                                          .largura
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              encomendas[key]!.personalizado!
                                                  ? Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        children: [
                                                          Text("Medidas: ",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                          Text(
                                                            ("${encomendas[key]!.comprimento!.toStringAsFixed(2)} x ${encomendas[key]!.largura!.toStringAsFixed(2)}"),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Subtotal: ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      totalEncomenda.toString(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        encomendas[key]!.materiasPrimas!.isEmpty
                                            ? SizedBox()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 10,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  top: 1,
                                                  left: 20,
                                                ),
                                                color: Colors.grey[100],
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Matéria Prima",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      "Preço de Venda",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      "Quantidade",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      "Comprimento",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      "Largura",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                        encomendas[key]!.materiasPrimas!.isEmpty
                                            ? SizedBox()
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    top: 1, left: 15),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 10),
                                                child: SizedBox(
                                                  height: 160,
                                                  child: ListView.builder(
                                                    itemCount: encomendas[key]!
                                                        .materiasPrimas!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            indice) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              initialValue: encomendas[
                                                                          key]!
                                                                      .materiasPrimas![indice]
                                                                  [
                                                                  "MateriaPrima"],
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              initialValue: encomendas[
                                                                      key]!
                                                                  .materiasPrimas![
                                                                      indice]
                                                                      ["pvp"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              initialValue: encomendas[
                                                                      key]!
                                                                  .materiasPrimas![
                                                                      indice][
                                                                      "quantidade"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              initialValue: encomendas[
                                                                      key]!
                                                                  .materiasPrimas![
                                                                      indice][
                                                                      "comprimento"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              initialValue: encomendas[
                                                                      key]!
                                                                  .materiasPrimas![
                                                                      indice][
                                                                      "largura"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        final doc = pw.Document();

                                        doc.addPage(
                                          pw.Page(
                                            pageFormat: PdfPageFormat.a5,
                                            margin: pw.EdgeInsets.all(10),
                                            build: (ctx) => pw.Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Row(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      pw.Column(
                                                        crossAxisAlignment: pw
                                                            .CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          /*  pw.Image(
                                    "https://scontent.flad4-1.fna.fbcdn.net/v/t1.6435-9/83212461_481516936099690_9164996550764527616_n.jpg?_nc_cat=107&ccb=1-3&_nc_sid=09cbfe&_nc_eui2=AeERU_Xn4-FsJBWIrFcdHiPs_5jg4U98qc3_mODhT3ypzdjU22eUv5eJmku7b6gAtCp9amojwJYzG5EfA0VV8GS2&_nc_ohc=SbMH9cVfUvgAX8ZqphI&_nc_ht=scontent.flad4-1.fna&oh=bfbb81b49f0c4430389299fe8d43463e&oe=60B55AEC",
                                    width: 80,
                                    height: 80,
                                  ), */
                                                          pw.SizedBox(
                                                              height: 10),
                                                          pw.Text(
                                                            "Aphit Molduras",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                            height: 5,
                                                          ),
                                                          pw.Text(
                                                            "Rua do sacramento 37",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                            height: 5,
                                                          ),
                                                          pw.Text(
                                                            "2500-182 Caldas da Rainha",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                            height: 5,
                                                          ),
                                                          pw.Text(
                                                            "932882626",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                            height: 5,
                                                          ),
                                                          pw.Text(
                                                            "Número de Contribuinte: 599999993",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      pw.Column(
                                                        crossAxisAlignment: pw
                                                            .CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          pw.SizedBox(
                                                              height: 10),
                                                          pw.Text(
                                                            "Cliente: ${_clienteNome.text}",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.Text(
                                                            "NIF: ${_clienteNif.text}",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                              height: 5),
                                                          pw.Text(
                                                            "Telemóvel: ${_clienteTelemovel.text}",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.Text(
                                                            "Morada: ${_clienteMorada.text}",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          pw.SizedBox(
                                                              height: 5),
                                                          pw.Text(
                                                            "Localidade: ${_clienteLocalidade.text}",
                                                            style: pw.TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  pw.SizedBox(
                                                    height: 20,
                                                  ),
                                                  pw.Expanded(
                                                    child: pw.ListView.builder(
                                                        itemCount:
                                                            encomendas.length,
                                                        itemBuilder: (context,
                                                            int index) {
                                                          String key =
                                                              encomendas.keys
                                                                  .elementAt(
                                                                      index);
                                                          return pw.Expanded(
                                                              // height: 250,
                                                              child: pw.Column(
                                                                  children: [
                                                                pw.Container(
                                                                  color: PdfColors
                                                                      .grey300,
                                                                  padding: pw
                                                                          .EdgeInsets
                                                                      .all(10),
                                                                  child: pw.Row(
                                                                    children: [
                                                                      pw.Expanded(
                                                                        flex: 2,
                                                                        child: pw
                                                                            .Row(
                                                                          children: [
                                                                            pw.Text(
                                                                              "Produto: ",
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            pw.Text(
                                                                              encomendas[key]!.produto!,
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      pw.Expanded(
                                                                        flex: 1,
                                                                        child: pw
                                                                            .Row(
                                                                          children: [
                                                                            pw.Text(
                                                                              "PVP: ",
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            pw.Text(
                                                                              encomendas[key]!.preco!.toStringAsFixed(2),
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      pw.Expanded(
                                                                        flex: 2,
                                                                        child: pw
                                                                            .Row(
                                                                          children: [
                                                                            pw.Text(
                                                                              "Subtotal: ",
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            pw.Text(
                                                                              (encomendas[key]!.preco! * encomendas[key]!.quantidade!).toStringAsFixed(2),
                                                                              style: pw.TextStyle(
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                encomendas[key]!
                                                                        .materiasPrimas!
                                                                        .isEmpty
                                                                    ? pw.SizedBox()
                                                                    : pw.Container(
                                                                        padding: const pw.EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                10),
                                                                        margin: const pw.EdgeInsets.only(
                                                                            top:
                                                                                1,
                                                                            left:
                                                                                20),
                                                                        color: PdfColors
                                                                            .grey100,
                                                                        child: pw
                                                                            .Row(
                                                                          children: [
                                                                            pw.Expanded(
                                                                              child: pw.Text(
                                                                                "Matéria Prima",
                                                                                style: pw.TextStyle(
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            pw.Expanded(
                                                                              child: pw.Text(
                                                                                "Preço de Venda",
                                                                                style: pw.TextStyle(
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            pw.Expanded(
                                                                              child: pw.Text(
                                                                                "Quantidade",
                                                                                style: pw.TextStyle(
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            pw.Expanded(
                                                                              child: pw.Text(
                                                                                "Comprimento",
                                                                                style: pw.TextStyle(
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            pw.Expanded(
                                                                              child: pw.Text(
                                                                                "Largura",
                                                                                style: pw.TextStyle(
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                encomendas[key]!
                                                                        .materiasPrimas!
                                                                        .isEmpty
                                                                    ? pw.SizedBox()
                                                                    : pw.Container(
                                                                        margin: const pw.EdgeInsets.only(
                                                                            top:
                                                                                1,
                                                                            left:
                                                                                15),
                                                                        padding: const pw.EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                10),
                                                                        child: pw
                                                                            .Expanded(
                                                                          // height: 400,
                                                                          child: pw.ListView.builder(
                                                                              itemCount: encomendas[key]!.materiasPrimas!.length,
                                                                              itemBuilder: (context, indice) {
                                                                                return pw.Row(
                                                                                  children: [
                                                                                    pw.Expanded(
                                                                                      child: pw.Text(
                                                                                        encomendas[key]!.materiasPrimas![indice]["MateriaPrima"],
                                                                                        style: pw.TextStyle(
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    pw.Expanded(
                                                                                      child: pw.Text(
                                                                                        encomendas[key]!.materiasPrimas![indice]["pvp"].toString(),
                                                                                        style: pw.TextStyle(
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    pw.Expanded(
                                                                                      child: pw.Text(
                                                                                        encomendas[key]!.materiasPrimas![indice]["quantidade"].toString(),
                                                                                        style: pw.TextStyle(
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    pw.Expanded(
                                                                                      child: pw.Text(encomendas[key]!.materiasPrimas![indice]["comprimento"].toString(),
                                                                                          style: pw.TextStyle(
                                                                                            fontSize: 10,
                                                                                          )),
                                                                                    ),
                                                                                    pw.Expanded(
                                                                                      child: pw.Text(
                                                                                        encomendas[key]!.materiasPrimas![indice]["largura"].toString(),
                                                                                        style: pw.TextStyle(
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              }),
                                                                        ),
                                                                      ),
                                                              ]));
                                                        }),
                                                  ),
                                                  pw.Column(
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      pw.Text(
                                                        "Subtotal: $totalEncomenda ",
                                                        style: pw.TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      pw.SizedBox(
                                                        height: 4,
                                                      ),
                                                      pw.Text("Iva: $_iva%",
                                                          style: pw.TextStyle(
                                                            fontSize: 10,
                                                          )),
                                                      pw.SizedBox(
                                                        height: 4,
                                                      ),
                                                      pw.Text(
                                                        "Taxa: $_margemLucro%",
                                                        style: pw.TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      pw.SizedBox(
                                                        height: 4,
                                                      ),
                                                      pw.Text(
                                                        "Sinal: $_sinal",
                                                        style: pw.TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      pw.SizedBox(
                                                        height: 4,
                                                      ),
                                                      pw.Text(
                                                        "Total: ${(valorTotal + (valorTotal * (_iva / 100))).toStringAsFixed(2)}",
                                                        style: pw.TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      pw.SizedBox(
                                                        height: 4,
                                                      ),
                                                      pw.Text(
                                                        "Valor a Pagar: ${((valorTotal + (valorTotal * (_iva / 100)) - _sinal)).toStringAsFixed(2)}",
                                                        style: pw.TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                        await Printing.layoutPdf(
                                          onLayout:
                                              (PdfPageFormat format) async =>
                                                  doc.save(),
                                        ); // Page
                                      },
                                      icon: Icon(Icons.print),
                                      label: Text("Imprimir Factura"),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.close),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      label: Text("Cancelar"),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.green.shade800,
                                      ),
                                      onPressed: () async {
                                        setState(
                                          () {
                                            _loading = true;
                                          },
                                        );

                                        /*await context
                                            .read<EncomendasController>()
                                            .addEncomendas(
                                              total: double.parse((valorTotal +
                                                      (valorTotal *
                                                          (_iva / 100)))
                                                  .toStringAsFixed(2)),
                                              idCliente:
                                                  idCliente.text.toString(),
                                              iva: _iva / 100,
                                              margemLucro: _margemLucro / 100,
                                              materiasPrimas: dbMateriasPrimas,
                                              produtos: dbProdutos,
                                              sinal: _sinal,
                                              subtotal: totalEncomenda,
                                              valorPagar: double.parse(
                                                ((valorTotal +
                                                        (valorTotal *
                                                            (_iva / 100)) -
                                                        _sinal))
                                                    .toStringAsFixed(2),
                                              ),
                                            );*/

                                        setState(() {
                                          _loading = false;
                                          data.clear();
                                          encomendas.clear();
                                          dbProdutos.clear();
                                          totalProdutos = 0;
                                        });

                                        Get.back();

                                        Get.snackbar(
                                          "Encomenda Registrada",
                                          "A encomenda foi registrada com sucesso",
                                          duration: Duration(seconds: 4),
                                          margin: EdgeInsets.zero,
                                          backgroundColor: Colors.green[600],
                                          colorText: Colors.white,
                                          borderRadius: 0,
                                          mainButton: TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              "Fechar",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.check),
                                      label: Text("Salvar Encomenda"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Subtotal: $totalEncomenda",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Iva: $_iva%",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Taxa: $_margemLucro%",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Sinal: $_sinal",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Total: ${(valorTotal + (valorTotal * (_iva / 100))).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Valor a Pagar: ${((valorTotal + (valorTotal * (_iva / 100)) - _sinal)).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  //Funcao para calcular os produtos e as materias primas

  calcular() {
    totalEncomenda = 0;
    _produtosNaLista.forEach(
      (key, value) {
        double comprimento = value["comprimento"];
        double largura = value["largura"];
        print("comprimento $comprimento");
        print("largura $comprimento");

        if (value["materiasPrimas"].length == 0) {
          totalEncomenda += double.parse(value["pvp"]);
        }
        value["materiasPrimas"].forEach(
          (v) {
            totalEncomenda += ((2 * comprimento) +
                    (2 * largura) +
                    (8 * (v["largura"] / 100))) *
                v["pvp"];
            print(totalEncomenda);
          },
        );
      },
    );
  }

  //******************************** */

  double _margemLucro = 0;
  double _iva = 0;
  double _sinal = 0;

  addProdutos({
    String? produto,
    String? preco,
    double? comprimento,
    double? largura,
    String? id,
    String? observacoes,
    String? quantidade,
    List? materiasPrimas,
  }) {
    if (encomendas.containsKey(id)) {
      Get.snackbar(
        "O produto duplicado",
        "Este produto já foi adicionado à lista",
        duration: Duration(seconds: 4),
        margin: EdgeInsets.zero,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        borderRadius: 0,
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Fechar",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      return;
    }

    /*_produtosNaLista.addAll({
      id: {
        "descricao": produto,
        "pvp": preco,
        "comprimento": comprimento! / 100,
        "largura": largura! / 100,
        "materiasPrimas": materiasPrimas
      }
    });*/

    pdfMateriaPrima = materiasPrimas!;

    totalProdutos += double.parse(preco!);
    materiasPrimas.forEach((materiaPrima) {
      data.add(materiaPrima);
    });
    ValueNotifier<int> valueNotifier = ValueNotifier(materiasPrimas.length);
    ValueNotifier<double> medidas = ValueNotifier(1);

    /*encomendas.addAll({
      id: Encomenda(
        produto: produto ?? '',
        preco: double.parse(preco),
        observacoes: "",
        comprimento: comprimento,
        largura: largura,
        materiasPrimas: materiasPrimas,
      ),
    });*/

    _produtos.add(
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text("Produto:")),
                Expanded(
                    flex: 2,
                    child: TextFormField(
                      style: inputStyle,
                      readOnly: true,
                      initialValue: produto,
                      onChanged: (v) {
                        setState(() {
                          produto = v;
                        });
                      },
                      decoration: InputDecoration(
                        enabled: false,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.7,
                          ),
                        ),
                        hintStyle: inputStyle,
                        hintText: _productoDescricao.text.isEmpty
                            ? "Selecione o produto"
                            : _productoDescricao.text,
                        focusColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 0.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 0.7),
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text("PVP:")),
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder(
                    valueListenable: medidas,
                    builder: (BuildContext context, double med, __) {
                      return TextFormField(
                        style: inputStyle,
                        readOnly: true,
                        initialValue: preco,
                        decoration: InputDecoration(
                          enabled: false,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.7,
                            ),
                          ),
                          hintStyle: inputStyle,
                          hintText: _productoPrecoVenda.text.isEmpty
                              ? "Preço de venda"
                              : {
                                  double.parse(_productoPrecoVenda.text) *
                                      medidas.value
                                }.toString(),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 0.7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 0.7),
                          ),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text("Comprimento:")),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: inputStyle,
                    initialValue: comprimento.toString(),
                    onChanged: (comprimento) {
                      _produtosNaLista.update(
                        id!,
                        (produto) => {
                          "descricao": produto["descricao"],
                          "pvp": produto["pvp"],
                          "comprimento": double.parse(comprimento) / 100,
                          "largura": produto["largura"],
                          "materiasPrimas": produto["materiasPrimas"],
                        },
                      );
                    },
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      hintStyle: inputStyle,
                      hintText: "Comprimento (cm)",
                      focusColor: Colors.grey,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Text("Largura:"),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: inputStyle,
                    onChanged: (largura) {
                      _produtosNaLista.update(
                        id!,
                        (produto) => {
                          "descricao": produto["descricao"],
                          "pvp": produto["pvp"],
                          "comprimento": produto["comprimento"],
                          "largura": double.parse(largura) / 100,
                          "materiasPrimas": produto["materiasPrimas"],
                        },
                      );
                    },
                    initialValue: comprimento.toString(),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      hintStyle: inputStyle,
                      hintText: "Largura (cm)",
                      focusColor: Colors.grey,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 0.7),
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            materiasPrimas.isEmpty
                ? SizedBox()
                : Column(
                    children: [
                      TypeAheadFormField(
                        hideOnEmpty: true,
                        hideOnLoading: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.normal),
                          decoration: InputDecoration(
                            labelText: "Associar matérias primas ao produto",
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          /*return await context
                              .read<MateriaPrimaController>()
                              .searchMateriaPrima(descricao: pattern);*/
                          return [];
                        },
                        noItemsFoundBuilder: (context) {
                          return Text("Nenhum resultado foi encontrado");
                        },
                        getImmediateSuggestions: true,
                        hideSuggestionsOnKeyboardHide: true,
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                                /*suggestion['descricao'] ?? "nullo"*/ 'ff'),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            /*materiasPrimas.add({
                            "mtId": suggestion["objectId"],
                            "MateriaPrima": suggestion["descricao"],
                            "pvp": suggestion["pmv"],
                            "quantidade": 1,
                            "comprimento": suggestion["comprimento"],
                            "largura": suggestion["largura"],
                          });*/
                          });
                          valueNotifier.value = materiasPrimas.length;
                          print(materiasPrimas);
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Matéria Prima"),
                          ),
                          Expanded(
                            child: Text("Preço de Venda"),
                          ),
                          Expanded(
                            child: Text("Quantidade"),
                          ),
                          Expanded(
                            child: Text("Comprimento (cm)"),
                          ),
                          Expanded(
                            child: Text("Largura (cm)"),
                          )
                        ],
                      ),
                    ],
                  ),
            materiasPrimas.isEmpty
                ? SizedBox()
                : ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (BuildContext context, int indice, __) {
                      return SizedBox(
                        height: 60.0 * indice,
                        child: ListView.builder(
                          itemCount: indice,
                          itemBuilder: (BuildContext context, indice) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: materiasPrimas[indice]
                                        ["MateriaPrima"],
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: materiasPrimas[indice]["pvp"]
                                        .toString(),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (v) {
                                      setState(() {
                                        materiasPrimas[indice]["quantidade"] =
                                            v;
                                      });
                                    },
                                    initialValue: materiasPrimas[indice]
                                            ["quantidade"]
                                        .toString(),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: (materiasPrimas[indice]
                                                ["comprimento"])
                                            .toString()),
                                    onChanged: (v) {
                                      setState(() {
                                        materiasPrimas[indice]["comprimento"] =
                                            double.parse(v);
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: (materiasPrimas[indice]
                                                ["largura"])
                                            .toString()),
                                    onChanged: (v) {
                                      setState(() {
                                        materiasPrimas[indice]["largura"] =
                                            double.parse(v);
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.remove),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _productoPrecoVenda.text = "0";
    _preco.text = "0";
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getData();

    //context.read<EncomendasController>().getEncomendas();

    return Scaffold(
      appBar: Platform.isAndroid
          ? AppBar(
              backgroundColor: Colors.yellow[900],
              title: Text("Encomendas"),
              elevation: 0,
            )
          : null,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.withOpacity(0.1),
                child: TabBar(
                  indicatorColor: Colors.yellow.shade800,
                  controller: _tabController,
                  onTap: (index) {
                    if (index == 1) {
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          isLoading = true;
                          print("Loading");
                        });

                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                    setState(() {});
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Nova Encomenda",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Tab(
                        child: Text(
                      "Lista de Encomendas",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Platform.isAndroid
                  ? Expanded(
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              height: 140,
                              child: RawScrollbar(
                                controller: _scrollController,
                                thickness: 7,
                                isAlwaysShown: true,
                                thumbColor: Colors.black.withOpacity(0.2),
                                child: ListView(
                                  controller: _scrollController,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TypeAheadFormField(
                                              loadingBuilder:
                                                  (BuildContext context) {
                                                return Container(
                                                  height: 100,
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        Text("Carregando ..."),
                                                        SizedBox(width: 5),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                autofocus: false,
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .copyWith(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 13,
                                                        ),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Pesquisar Clientes",
                                                  suffixIcon: Icon(
                                                    Icons.search,
                                                  ),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                /*return await context
                                                    .read<ClientesController>()
                                                    .searchClientes(
                                                        nome: pattern);*/
                                                return [];
                                              },
                                              noItemsFoundBuilder: (context) {
                                                return Text(
                                                    "Nenhum resultado foi encontrado");
                                              },
                                              getImmediateSuggestions: false,
                                              hideSuggestionsOnKeyboardHide:
                                                  true,
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  leading: Icon(Icons
                                                      .account_box_rounded),
                                                  title: Text(
                                                      /*suggestion['nome']*/ 'ff'),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                setState(() {
                                                  /* _clienteNome.text =
                                                      suggestion["objectId"];
                                                  codigoCliente =
                                                      suggestion["objectId"];
                                                  _clienteNif.text =
                                                      suggestion["contribuinti"]
                                                          .toString();
                                                  _clienteTelemovel.text =
                                                      suggestion["telemovel"]
                                                          .toString();
                                                  _clienteMorada.text =
                                                      suggestion["morada"];
                                                  _clienteLocalidade.text =
                                                      suggestion["localidade"];
                                                  idCliente.text =
                                                      suggestion["objectId"];*/
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    _margemLucro =
                                                        double.parse(value);
                                                  },
                                                );
                                              },
                                              decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                hintStyle: inputStyle,
                                                labelStyle: inputStyle,
                                                hintText: "Margem de Lucro %",
                                                focusColor: Colors.grey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _iva = double.parse(value);
                                                });
                                              },
                                              decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                hintStyle: inputStyle,
                                                labelStyle: inputStyle,
                                                hintText: "iva %",
                                                focusColor: Colors.grey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    _sinal =
                                                        double.parse(value);
                                                  },
                                                );
                                              },
                                              decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                hintStyle: inputStyle,
                                                labelStyle: inputStyle,
                                                hintText: "Sinal",
                                                focusColor: Colors.grey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Dados do cliente:",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                onChanged: (cliente) {
                                                  setState(
                                                    () {
                                                      _clienteNome.text =
                                                          cliente;
                                                    },
                                                  );
                                                },
                                                controller: _clienteNome,
                                                style: inputStyle,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  hintStyle: inputStyle,
                                                  labelStyle: inputStyle,
                                                  hintText: _clienteNome
                                                          .text.isEmpty
                                                      ? "Selecione o cliente"
                                                      : _clienteNome.text,
                                                  focusColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                ),
                                              )),
                                          SizedBox(height: 10),
                                          Flexible(
                                              flex: 2,
                                              child: TextFormField(
                                                onChanged: (nif) {
                                                  setState(() {
                                                    _clienteNif.text = nif;
                                                  });
                                                },
                                                style: inputStyle,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  hintStyle: inputStyle,
                                                  hintText:
                                                      _clienteNif.text.isEmpty
                                                          ? "NIF"
                                                          : _clienteNif.text,
                                                  focusColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 0.7),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 0.7),
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                ),
                                              )),
                                          SizedBox(height: 10),
                                          Flexible(
                                              flex: 2,
                                              child: TextFormField(
                                                onChanged: (nif) {
                                                  setState(() {
                                                    _clienteNif.text = nif;
                                                  });
                                                },
                                                style: inputStyle,
                                                controller: _clienteTelemovel,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  hintStyle: inputStyle,
                                                  hintText: _clienteTelemovel
                                                          .text.isEmpty
                                                      ? "(+351) ### ### ### "
                                                      : _clienteTelemovel.text,
                                                  focusColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 0.7),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 0.7),
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(16),
                                            color: Colors.grey[200],
                                            child: Text("Morada:")),
                                        Expanded(
                                            flex: 3,
                                            child: TextFormField(
                                              style: inputStyle,
                                              controller: _clienteMorada,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                enabled: false,
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                hintStyle: inputStyle,
                                                hintText: _clienteMorada
                                                        .text.isEmpty
                                                    ? "Selecione a morada do cliente"
                                                    : _clienteMorada.text,
                                                focusColor: Colors.grey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(16),
                                            color: Colors.grey[200],
                                            child: Text("Localidade:")),
                                        Expanded(
                                            flex: 3,
                                            child: TextFormField(
                                              style: inputStyle,
                                              controller: _clienteLocalidade,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                enabled: false,
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7,
                                                  ),
                                                ),
                                                hintStyle: inputStyle,
                                                hintText: _clienteLocalidade
                                                        .text.isEmpty
                                                    ? "Selecione a localidade do cliente"
                                                    : _clienteLocalidade.text,
                                                focusColor: Colors.grey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.7),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Dados da Moldura:",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TypeAheadFormField(
                                            hideOnEmpty: true,
                                            hideOnLoading: false,
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              autofocus: false,
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .copyWith(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 14,
                                                      ),
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Selecione o produto  ",
                                                suffixIcon: Icon(
                                                  Icons.close,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            loadingBuilder:
                                                (BuildContext context) {
                                              return Container(
                                                height: 100,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                            suggestionsCallback:
                                                (pattern) async {
                                              /*return await context
                                                  .read<ProdutosController>()
                                                  .searchProdutos(
                                                      descricao: pattern);*/
                                              return [];
                                            },
                                            noItemsFoundBuilder: (context) {
                                              return Text(
                                                  "Nenhum resultado foi encontrado");
                                            },
                                            hideSuggestionsOnKeyboardHide: true,
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                leading: Icon(Icons
                                                    .shopping_bag_outlined),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        /*suggestion[
                                                        'descricao']*/
                                                        'ff'),
                                                  ],
                                                ),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              setState(() {
                                                /*_productoDescricao.text =
                                                    suggestion["descricao"];

                                                _productoPrecoVenda.text =
                                                    suggestion["pmv"];

                                                precoVenda = double.parse(
                                                    suggestion["pmv"]);*/
                                              });

                                              /*addProdutos(
                                                largura: suggestion["largura"],
                                                comprimento:
                                                    suggestion["comprimento"],
                                                id: suggestion["objectId"],
                                                preco: suggestion["pmv"]
                                                    .toString(),
                                                quantidade: "1",
                                                produto:
                                                    suggestion["descricao"],
                                                materiasPrimas: suggestion[
                                                    "materiasPrimas"],
                                              );*/
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 50,
                                            child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  primary: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _produtos.clear();
                                                    encomendas.clear();
                                                    limparForms();
                                                  });
                                                },
                                                icon: Icon(Icons.clear),
                                                label: Text("Limpadr")),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              230,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListView.builder(
                                        itemCount: _produtos.length,
                                        itemBuilder: (BuildContext context, i) {
                                          return _produtos[i];
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      height: 40,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary: Colors.green[500]),
                                        onPressed: () {
                                          if (_clienteMorada.text.isEmpty ||
                                              encomendas.isEmpty) {
                                            Get.snackbar(
                                              "Preencha os dados",
                                              "Preencha os campos antes de prosseguir",
                                              duration: Duration(seconds: 4),
                                              margin: EdgeInsets.zero,
                                              backgroundColor: Colors.red[600],
                                              colorText: Colors.white,
                                              borderRadius: 0,
                                              mainButton: TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "Fechar",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );

                                            return;
                                          }

                                          calcularEncomenda();
                                        },
                                        icon: Icon(Icons.check),
                                        label: Text("Realizar encomenda"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ListView(
                              children: [
                                /*PaginatedDataTable(
                                  rowsPerPage: rowsPerPage,
                                  onRowsPerPageChanged: (v) {
                                    setState(
                                      () {
                                        rowsPerPage = v!;
                                      },
                                    );
                                  },
                                  availableRowsPerPage: [5, 10, 15, 16],
                                  showCheckboxColumn: true,
                                  sortAscending: true,
                                  columns: <DataColumn>[
                                    DataColumn(
                                        label: Text(
                                      "Código",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Iva",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Taxa",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Sinal",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    DataColumn(
                                      label: Text(
                                        "Subtotal",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Total",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Valor a Pagar",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Acções",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                  source:
                                      DataTableSource(), /*MyDataTableSource(
                                    //encomendasData.reversed.toList(),
                                    context,
                                    () {
                                      /*WidgetsBinding.instance!
                                        .addPostFrameCallback(
                                      (_) {
                                        context
                                            .read<ClientesController>()
                                            .getClientes();
                                        print("tela recriada");
                                      },
                                    );*/

                                      setState(
                                        () {
                                          isLoading = true;
                                        },
                                      );
                                      Future.delayed(
                                        Duration(seconds: 2),
                                        () {
                                          setState(
                                            () {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),*/
                                ),*/
                              ],
                            ),
                          ]),
                    )
                  : Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            height: 140,
                            child: RawScrollbar(
                              controller: _scrollController,
                              thickness: 7,
                              isAlwaysShown: true,
                              thumbColor: Colors.black.withOpacity(0.2),
                              child: ListView(
                                controller: _scrollController,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TypeAheadFormField(
                                          hideOnEmpty: false,
                                          hideOnLoading: false,
                                          loadingBuilder:
                                              (BuildContext context) {
                                            return Container(
                                              height: 100,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            autofocus: false,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.normal),
                                            decoration: InputDecoration(
                                              labelText: "Pesquisar Clientes",
                                              suffixIcon: Icon(
                                                Icons.search,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            /*return await context
                                                  .read<ClientesController>()
                                                  .searchClientes(
                                                      nome: pattern);*/
                                            return [];
                                          },
                                          noItemsFoundBuilder: (context) {
                                            return Text(
                                                "Nenhum resultado foi encontrado");
                                          },
                                          getImmediateSuggestions: false,
                                          hideSuggestionsOnKeyboardHide: true,
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              leading: Icon(
                                                  Icons.account_box_rounded),
                                              title: Text(
                                                  /*suggestion!['nome'] ??
                                                        "null"*/
                                                  'suggestion'),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            setState(
                                              () {
                                                /*idCliente.text =
                                                    suggestion["objectId"];
                                                _clienteNome.text =
                                                    suggestion["nome"];
                                                _clienteNif.text =
                                                    suggestion["contribuinti"]
                                                        .toString();
                                                _clienteTelemovel.text =
                                                    suggestion["telemovel"]
                                                        .toString();
                                                _clienteMorada.text =
                                                    suggestion["morada"];
                                                _clienteLocalidade.text =
                                                    suggestion["localidade"];*/
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Margem de Lucro: %  ")),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              _margemLucro =
                                                  double.parse(value);
                                            });
                                          },
                                          decoration: InputDecoration(
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            hintStyle: inputStyle,
                                            labelStyle: inputStyle,
                                            hintText: "",
                                            focusColor: Colors.grey,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("IVA  ")),
                                      Expanded(
                                          child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            _iva = double.parse(value);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          hintStyle: inputStyle,
                                          labelStyle: inputStyle,
                                          hintText: "",
                                          focusColor: Colors.grey,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                        ),
                                      )),
                                      SizedBox(width: 10),
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Sinal  ")),
                                      Expanded(
                                          child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            _sinal = double.parse(value);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          hintStyle: inputStyle,
                                          labelStyle: inputStyle,
                                          hintText: "",
                                          focusColor: Colors.grey,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7,
                                            ),
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                        ),
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Dados do cliente:",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Cliente:  ")),
                                      Expanded(
                                          flex: 4,
                                          child: TextFormField(
                                            controller: _clienteNome,
                                            style: inputStyle,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              enabled: false,
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              hintStyle: inputStyle,
                                              labelStyle: inputStyle,
                                              hintText:
                                                  _clienteNome.text.isEmpty
                                                      ? "Selecione o cliente"
                                                      : _clienteNome.text,
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                            ),
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("NIF:")),
                                      Flexible(
                                        flex: 2,
                                        child: TextFormField(
                                          readOnly: true,
                                          style: inputStyle,
                                          decoration: InputDecoration(
                                            enabled: false,
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            hintStyle: inputStyle,
                                            hintText: _clienteNif.text.isEmpty
                                                ? "NIF"
                                                : _clienteNif.text,
                                            focusColor: Colors.grey,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Telem:")),
                                      Flexible(
                                          flex: 2,
                                          child: TextFormField(
                                            readOnly: true,
                                            style: inputStyle,
                                            controller: _clienteTelemovel,
                                            decoration: InputDecoration(
                                              enabled: false,
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              hintStyle: inputStyle,
                                              hintText:
                                                  _clienteTelemovel.text.isEmpty
                                                      ? "(+351) ### ### ### "
                                                      : _clienteTelemovel.text,
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Morada:")),
                                      Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            style: inputStyle,
                                            controller: _clienteMorada,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              enabled: false,
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              hintStyle: inputStyle,
                                              hintText: _clienteMorada
                                                      .text.isEmpty
                                                  ? "Selecione a morada do cliente"
                                                  : _clienteMorada.text,
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                            ),
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: Text("Localidade:")),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          style: inputStyle,
                                          controller: _clienteLocalidade,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            enabled: false,
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            hintStyle: inputStyle,
                                            hintText: _clienteLocalidade
                                                    .text.isEmpty
                                                ? "Selecione a localidade do cliente"
                                                : _clienteLocalidade.text,
                                            focusColor: Colors.grey,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Dados da Moldura:",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: TypeAheadFormField(
                                          hideOnEmpty: true,
                                          hideOnLoading: false,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            autofocus: false,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.normal),
                                            decoration: InputDecoration(
                                              labelText:
                                                  "Selecione o produto : Pesquise aqui",
                                              suffixIcon: Icon(
                                                Icons.close,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          loadingBuilder:
                                              (BuildContext context) {
                                            return Container(
                                              height: 100,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                          suggestionsCallback: (pattern) async {
                                            /*return await context
                                                  .read<ProdutosController>()
                                                  .searchProdutos(
                                                      descricao: pattern);*/
                                            return [];
                                          },
                                          noItemsFoundBuilder: (context) {
                                            return Text(
                                                "Nenhum resultado foi encontrado");
                                          },
                                          hideSuggestionsOnKeyboardHide: false,
                                          itemBuilder: (context, suggestion) {
                                            return Center();
                                            /*return Container(
                                                height: 50,
                                                child: ListTile(
                                                  leading: Icon(Icons
                                                      .shopping_bag_outlined),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(suggestion[
                                                          'descricao' ??
                                                              "nullo"]),
                                                    ],
                                                  ),
                                                ),
                                              );*/
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            setState(
                                              () {
                                                /*_productoDescricao.text =
                                                      suggestion["descricao"];
                                                  _productoPrecoVenda.text =
                                                      suggestion["pmv"]
                                                          .toString();

                                                  precoVenda = double.parse(
                                                      suggestion["pmv"]
                                                          .toString());*/
                                              },
                                            );

                                            /*addProdutos(
                                                largura: double.parse(
                                                    suggestion["largura"]),
                                                comprimento: double.parse(
                                                    suggestion["comprimento"]),
                                                id: suggestion["objectId"],
                                                preco: suggestion["pmv"],
                                                quantidade: "1",
                                                produto:
                                                    suggestion["descricao"],
                                                materiasPrimas: suggestion[
                                                    "materiasPrimas"],
                                              );*/
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.blue,
                                            ),
                                            onPressed: () {},
                                            icon: Icon(Icons.clear),
                                            label: Text("Limpar"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height -
                                        230,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListView.builder(
                                        itemCount: _produtos.length,
                                        itemBuilder: (BuildContext context, i) {
                                          return _produtos[i];
                                        }),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 40,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.green[500]),
                                      onPressed: () {
                                        if (_clienteMorada.text.isEmpty ||
                                            encomendas.isEmpty) {
                                          Get.snackbar(
                                            "Preencha os dados",
                                            "Preencha os campos antes de prosseguir",
                                            duration: Duration(seconds: 4),
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.red[600],
                                            colorText: Colors.white,
                                            borderRadius: 0,
                                            mainButton: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                "Fechar",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );

                                          return;
                                        }

                                        calcularEncomenda();
                                      },
                                      icon: Icon(Icons.check),
                                      label: Text("Realizar encomenda"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ListView(children: [
                            /*PaginatedDataTable(
                              rowsPerPage: rowsPerPage,
                              onRowsPerPageChanged: (v) {
                                setState(() {
                                  rowsPerPage = v!;
                                });
                              },
                              availableRowsPerPage: [5, 10, 15, 16],
                              showCheckboxColumn: true,
                              sortAscending: true,
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  "Código",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )),
                                DataColumn(
                                  label: Text(
                                    "Iva",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Taxa",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Sinal",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Subtotal",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Total",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Valor a Pagar",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Acções",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                              source: MyDataTableSource(
                                encomendasData.reversed.toList(),
                                context,
                                () {
                                  WidgetsBinding.instance!.addPostFrameCallback(
                                    (_) {
                                      /*context
                                          .read<ClientesController>()
                                          .getClientes();
                                      print("tela recriada");*/
                                    },
                                  );

                                  setState(
                                    () {
                                      isLoading = true;
                                    },
                                  );
                                  Future.delayed(
                                    Duration(seconds: 2),
                                    () {
                                      setState(
                                        () {
                                          setState(
                                            () {
                                              isLoading = false;
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),*/
                          ]),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? SizedBox()
          : FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                if (_clienteMorada.text.isEmpty || encomendas.isEmpty) {
                  Get.snackbar(
                    "Preencha os dados",
                    "Preencha os campos antes de prosseguir",
                    duration: Duration(seconds: 4),
                    margin: EdgeInsets.zero,
                    backgroundColor: Colors.red[600],
                    colorText: Colors.white,
                    borderRadius: 0,
                    mainButton: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Fechar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );

                  return;
                }
                calcular();
                calcularEncomenda();
              },
            ),
    );
  }
}
