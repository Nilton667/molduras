import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../models/user.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class name extends StatelessWidget {
  const name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ProdutosTab extends StatefulWidget {
  const ProdutosTab({Key? key}) : super(key: key);

  @override
  _ProdutosTabState createState() => _ProdutosTabState();
}

class _ProdutosTabState extends State<ProdutosTab>
    with TickerProviderStateMixin {
  late TabController _tabControllerUser;
  int _rowsPerPage = 5;
  bool _isLoading = false;
  TextEditingController _descricao = TextEditingController();
  TextEditingController _pmc = TextEditingController();
  TextEditingController _pvp = TextEditingController();
  TextEditingController _quantidade = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool composto = false;
  ScrollController? _scrollController;
  List<Produtos> _produtos = [];
  List produtos = [];
  String labelTipoProduto = "Selecione o tipo de Produto";
  String labelUnidade = "Unidade";

  bool isProductoComposto = false;
  bool isMetrosLineares = false;
  // FORMULARIOS DE MATERIAS PRIMAS
  TextEditingController _materiaPrima = TextEditingController();
  TextEditingController _preco = TextEditingController();
  int quantidades = 0;

  TextEditingController mtComprimento = TextEditingController();
  TextEditingController mtLargura = TextEditingController();
  TextEditingController mtId = TextEditingController();

  // Calculo Metros Lineares
  TextEditingController _comprimento = TextEditingController();
  TextEditingController _largura = TextEditingController();
  TextEditingController _metrosQuadrados = TextEditingController();
  final inputStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

  final mtFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
    _tabControllerUser = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  getData() async {
    _produtos.clear();
    for (int i = 0; i < produtos.length; i++) {
      _produtos.add(Produtos(
          composto: produtos[i].composto,
          descricao: produtos[i].descricao,
          pvp: produtos[i].pvp.toString(),
          pmc: produtos[i].pmc.toString(),
          quantidade: produtos[i].quantidade,
          codigo: i + 1,
          unidades: produtos[i].unidades.toString(),
          objectId: produtos[i].objectId.toString()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabControllerUser.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*   double _metrosLineares = (((double.parse(_comprimento.text ?? "0") * 2) +
            (double.parse(_largura.text ?? "0") * 2) +
            8 * 4)) /
        100; */
    // print(_metrosLineares);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //context.read<ProdutosController>().getProdutos();
    });
    getData();

    return Scaffold(
      appBar: Platform.isAndroid
          ? AppBar(
              backgroundColor: Colors.yellow[900],
              title: Text("Produtos"),
              elevation: 0,
            )
          : null,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                enableFeedback: false,
                indicatorColor: Colors.yellow.shade800,
                labelColor: Colors.grey,
                indicatorWeight: 2,
                automaticIndicatorColorAdjustment: true,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                controller: _tabControllerUser,
                onTap: (_) {
                  if (_tabControllerUser.index == 0) {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  }
                  if (_tabControllerUser.index == 1) {
                    setState(() {});
                  }
                },
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Text("Gestão de Produtos"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Registrar Produto"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.grey.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      tooltip: "Voltar",
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.yellow.shade800,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            _isLoading = true;
                          },
                        );
                        Future.delayed(
                          Duration(seconds: 1),
                          () {
                            setState(
                              () {
                                _isLoading = false;
                              },
                            );
                          },
                        );
                        setState(
                          () {
                            _tabControllerUser.index = 0;
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Registro de Produtos",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Spacer(),
                    // ignore: deprecated_member_use
                    OutlineButton.icon(
                      onPressed: () {
                        setState(
                          () {
                            _tabControllerUser.animateTo(1,
                                duration: Duration(seconds: 1),
                                curve: Curves.decelerate);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.yellow.shade800,
                      ),
                      label: Text(
                        "Novo Produto  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _tabControllerUser.index != 0
                ? SizedBox()
                : Container(
                    color: Colors.grey.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          OutlineButton.icon(
                              onPressed: () async {
                                final doc = pw.Document();

                                doc.addPage(
                                  pw.MultiPage(
                                    pageTheme: pdfLib.PageTheme(
                                      pageFormat: PdfPageFormat.a4,
                                    ),
                                    header: (pw.Context context) {
                                      return pw.Column(
                                        children: [
                                          pw.Row(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Expanded(
                                                child: pw.Column(
                                                  children: [
                                                    pw.Container(
                                                      height: 50,
                                                      alignment: pw
                                                          .Alignment.centerLeft,
                                                      child: pw.Text(
                                                        'Lista de Produtos',
                                                        style: pw.TextStyle(
                                                          color:
                                                              PdfColors.grey900,
                                                          fontWeight: pw
                                                              .FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Container(
                                                      decoration:
                                                          pw.BoxDecoration(
                                                        borderRadius: const pw
                                                            .BorderRadius.all(pw
                                                                .Radius
                                                            .circular(2)),
                                                        color: PdfColors.white,
                                                      ),
                                                      padding: const pw
                                                              .EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 20),
                                                      alignment: pw
                                                          .Alignment.centerLeft,
                                                      height: 50,
                                                      child:
                                                          pw.DefaultTextStyle(
                                                        style: pw.TextStyle(
                                                          color: PdfColors
                                                              .blueGrey900,
                                                          fontSize: 12,
                                                        ),
                                                        child: pw.Column(
                                                          crossAxisAlignment: pw
                                                              .CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            pw.Row(children: [
                                                              pw.Text(
                                                                  'Descricão:'),
                                                              pw.SizedBox(
                                                                  width: 5),
                                                              pw.Text(
                                                                  "Relatório de Produtos Aphit Molduras"),
                                                            ])
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pw.Expanded(
                                                child: pw.Column(
                                                  mainAxisSize:
                                                      pw.MainAxisSize.min,
                                                  children: [
                                                    pw.Container(
                                                      alignment:
                                                          pw.Alignment.topRight,
                                                      padding: const pw
                                                              .EdgeInsets.only(
                                                          bottom: 8, left: 30),
                                                      height: 40,
                                                      child: pw.PdfLogo(),
                                                    ),
                                                    // pw.Container(
                                                    //   color: baseColor,
                                                    //   padding: pw.EdgeInsets.only(top: 3),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (context.pageNumber > 1)
                                            pw.SizedBox(height: 20)
                                        ],
                                      );
                                    },
                                    footer: (pw.Context context) {
                                      return pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.end,
                                        children: [
                                          pw.Container(
                                            height: 20,
                                            width: 100,
                                            child: pw.BarcodeWidget(
                                              barcode: pw.Barcode.pdf417(),
                                              data: 'Invoice# 11',
                                              drawText: false,
                                            ),
                                          ),
                                          pw.Text(
                                            'Page ${context.pageNumber}/${context.pagesCount}',
                                            style: const pw.TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    build: (ctx) => [
                                      pw.Table.fromTextArray(
                                        context: ctx,
                                        data: <List<String>>[
                                          /*<String>[
                                            'Descrição',
                                            'Quantidade',
                                            'PVP',
                                            'Unidades',
                                            'PMC',
                                            'Composto',
                                          ],
                                          ...context
                                              .read<ProdutosController>()
                                              .produtos
                                              .map(
                                                (e) => [
                                                  e.descricao,
                                                  e.quantidade.toString(),
                                                  e.pvp.toString(),
                                                  e.unidades,
                                                  e.pmc.toString(),
                                                  e.composto.toString(),
                                                ],
                                              )*/
                                        ],
                                      ),
                                    ],
                                  ),
                                );

                                await Printing.layoutPdf(
                                    onLayout: (PdfPageFormat format) async =>
                                        doc.save()); // Page
                              },
                              icon: Icon(
                                Icons.print,
                                color: Colors.green,
                              ),
                              label: Text(
                                "Imprimir Lista de Produtos",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          // ignore: deprecated_member_use

                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
            Expanded(
              child: TabBarView(
                controller: _tabControllerUser,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Scrollbar(
                    showTrackOnHover: true,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        PaginatedDataTable(
                          rowsPerPage: _rowsPerPage,
                          onRowsPerPageChanged: (v) {
                            setState(() {
                              _rowsPerPage = v!;
                            });
                          },
                          availableRowsPerPage: [5, 10, 15, 16],
                          showCheckboxColumn: true,
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(
                                label: Text(
                              "Id",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "PMC",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "Descrição",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "Quantidade",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "PMV",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "Unidade",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "Composto",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                                label: Text(
                              "Acções",
                              style: TextStyle(color: Colors.grey),
                            )),
                          ],
                          source: MyDataTableSource(
                            _produtos,
                            context,
                            () {
                              WidgetsBinding.instance!.addPostFrameCallback(
                                (_) {
                                  /*context
                                    .read<ProdutosController>()
                                    .getProdutos();*/
                                },
                              );
                              getData();

                              setState(() {
                                _isLoading = true;
                              });
                              Future.delayed(
                                Duration(seconds: 2),
                                () {
                                  setState(
                                    () {
                                      setState(
                                        () {
                                          _isLoading = false;
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                                  hintText: "Descrição",
                                  enabledBorder: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7),
                                  ),
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white),
                              controller: _descricao,
                              validator: (descricao) {
                                if (descricao!.isEmpty) {
                                  return "O campo descrição é requerido";
                                }

                                if (descricao.length < 5) {
                                  return "O campo descrição é requer no mínimo 5 caracteres";
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.monetization_on_outlined),
                                      hintText: "Preço Médio de Compra (PMC)",
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.7),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white),
                                  controller: _pmc,
                                  validator: (pmc) {
                                    if (pmc!.isEmpty) {
                                      return "O campo pmc é requerido";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.monetization_on_outlined),
                                      hintText: "Preço Médio de Venda (PMV)",
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.7),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white),
                                  controller: _pvp,
                                  validator: (pmv) {
                                    if (pmv!.isEmpty) {
                                      return "O campo preço médio de venda  é requerido";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\b[0-9]+\b')),
                                  ],
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_on),
                                      hintText: "Quantidade",
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.7),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white),
                                  controller: _quantidade,
                                  validator: (qtd) {
                                    if (qtd!.isEmpty) {
                                      return "O campo quantidade é requerido";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  child: ListTile(
                                    dense: true,
                                    leading: Text(
                                      labelTipoProduto,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700]),
                                    ),
                                    trailing: PopupMenuButton(
                                      tooltip: "Selecione o tipo de produto",
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (value) {
                                        if (value == true) {
                                          setState(() {
                                            labelTipoProduto =
                                                "Produto Composto";
                                            isProductoComposto = true;
                                          });
                                        } else {
                                          setState(() {
                                            labelTipoProduto =
                                                "Produto Simples";
                                            isProductoComposto = false;
                                          });
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            child: Text("Produto Simples"),
                                            value: false,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Produto Composto"),
                                            value: true,
                                          )
                                        ];
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: ListTile(
                              dense: true,
                              leading: Text(
                                labelUnidade,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                              trailing: PopupMenuButton(
                                tooltip: "Selecione a unidade",
                                icon: Icon(Icons.arrow_drop_down),
                                onSelected: (value) {
                                  if (value == true) {
                                    setState(() {
                                      isMetrosLineares = true;
                                      labelUnidade = "Metros Quadrados";
                                    });
                                  } else {
                                    setState(() {
                                      labelUnidade = "Metros  Lineares";
                                      isMetrosLineares = false;
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text("Metros Quadrado"),
                                      value: true,
                                    ),
                                    PopupMenuItem(
                                      child: Text("Metros Lineares"),
                                      value: false,
                                    )
                                  ];
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          isMetrosLineares == true
                              ? Expanded(
                                  child: TextFormField(
                                    controller: _metrosQuadrados,
                                    onChanged: (v) {
                                      print(v);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    decoration: InputDecoration(
                                        hintText:
                                            "Digite a medida em metros Quadrado",
                                        enabledBorder: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7),
                                        ),
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white),
                                    validator: (qtd) {
                                      if (qtd!.isEmpty) {
                                        return "O campo metros lineares é requerido";
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        controller: _comprimento,
                                        decoration: InputDecoration(
                                            hintText: "Comprimento",
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        controller: _largura,
                                        decoration: InputDecoration(
                                          hintText: "Largura",
                                          enabledBorder: OutlineInputBorder(
                                            // width: 0.0 produces a thin "hairline" border
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7),
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 15),
                          !isProductoComposto
                              ? SizedBox()
                              : /*SizedBox(
                                  height: 40.1 *
                                      context
                                          .watch<MateriaPrimaController>()
                                          .getMateriasPrimas
                                          .length,
                                  child: ListView.builder(
                                    itemCount: context
                                        .watch<MateriaPrimaController>()
                                        .getMateriasPrimas
                                        .length,
                                    itemBuilder: (BuildContext context, i) {
                                      /*return context
                                          .watch<MateriaPrimaController>()
                                          .getMateriasPrimas[i];*/
                                    },
                                  ),
                                ),*/
                              Center(),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            color: Colors.green,
                            width: 90,
                            height: 40,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.green,
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                /*await context
                                    .read<ProdutosController>()
                                    .addProduto(
                                        composto: isProductoComposto,
                                        quantidade: int.tryParse(
                                            _quantidade.text.trim()),
                                        descricao: _descricao.text.trim(),
                                        pmc: double.tryParse(_pmc.text.trim()),
                                        pmv: double.parse(
                                          _pvp.text.trim(),
                                        ),
                                        comprimento:
                                            double.parse(_comprimento.text),
                                        largura: double.parse(_largura.text),
                                        unidade: labelUnidade,
                                        materiasPrimas: context
                                            .read<MateriaPrimaController>()
                                            .materiasPrimaDataSource);*/

                                //print(response.result.toString());
                                Get.snackbar(
                                  "O produto Registrado",
                                  "Este produto foi Registrado",
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
                                setState(
                                  () {
                                    _isLoading = false;
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Registrar Produto",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !isProductoComposto
          ? SizedBox()
          : ElevatedButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    content: Container(
                      width: 540,
                      height: 520,
                      child: Form(
                        key: mtFormKey,
                        child: Column(
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
                                  labelText: "Pesquisar Matérias Primas",
                                  suffixIcon: Icon(
                                    Icons.search,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                /*return await context
                                    .read<MateriaPrimaController>()
                                    .searchMateriaPrima(
                                      descricao: pattern,
                                    );*/
                                return [];
                              },
                              noItemsFoundBuilder: (context) {
                                return Text("Nenhum resultado foi encontrado");
                              },
                              getImmediateSuggestions: true,
                              hideSuggestionsOnKeyboardHide: true,
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text("$suggestion"),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(
                                  () {
                                    /*_materiaPrima.text =
                                      suggestion?['descricao'] ?? '';
                                  mtId.text = suggestion["objectId"];
                                  _preco.text = suggestion["pmv"];*/
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: inputStyle,
                                    controller: _materiaPrima,
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
                                      hintText: _materiaPrima.text.isEmpty
                                          ? "Selecione a matéria prima"
                                          : _materiaPrima.text.toString(),
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
                            SizedBox(height: 10),
                            TextFormField(
                              style: inputStyle,
                              controller: _preco,
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
                                hintText: _preco.text.isEmpty
                                    ? "Preco"
                                    : _preco.text.toString(),
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
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (qt) {
                                if (qt!.isEmpty) {
                                  return "Indique a quantidade de matéria prima";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              style: inputStyle,
                              onChanged: (qt) {
                                if (qt.isAlphabetOnly) {
                                  return;
                                }
                                setState(() {
                                  quantidades = int.parse(qt);
                                });
                              },
                              decoration: InputDecoration(
                                enabled: true,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.7,
                                  ),
                                ),
                                hintStyle: inputStyle,
                                hintText: "Quantidade",
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
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (mt) {
                                if (mt!.isEmpty) {
                                  return "O Campo comrimento é requerido";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              style: inputStyle,
                              controller: mtComprimento,
                              decoration: InputDecoration(
                                enabled: true,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.7,
                                  ),
                                ),
                                hintStyle: inputStyle,
                                hintText: "Comprimento",
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
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (lg) {
                                if (lg!.isEmpty) {
                                  return "O Campo Largura é requerido";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              style: inputStyle,
                              controller: mtLargura,
                              decoration: InputDecoration(
                                enabled: true,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.7,
                                  ),
                                ),
                                hintStyle: inputStyle,
                                hintText: mtLargura.text.isEmpty
                                    ? "Largura"
                                    : mtLargura.text.toString(),
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
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!mtFormKey.currentState!.validate()) {
                                    return;
                                  }

                                  /*context
                                      .read<MateriaPrimaController>()
                                      .addMateriaPrima(
                                        id: mtId.text,
                                        precoVenda: double.parse(_preco.text),
                                        produto: _materiaPrima.text,
                                        quantidade: quantidades,
                                        comprimento:
                                            double.parse(mtComprimento.text),
                                        largura: double.parse(mtLargura.text),
                                      );*/

                                  _preco.clear();
                                  _materiaPrima.clear();
                                  quantidades = 0;

                                  //Navigator.of(context).pop();
                                },
                                child: Text("Adicionar"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text("Adicionar Matéria Prima"),
            ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this.data, this.context, this.onTap);
  final _formKey = GlobalKey<FormState>();
  Function onTap;
  String pmv = "";
  String pmc = "";
  String descricao = "";
  int quantidade = 0;
  int telemovel = 0;
  final List<Produtos> data;
  BuildContext context;
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data[index].codigo! + 1}')),
        DataCell(Text('${data[index].pmc}')),
        DataCell(Text('${data[index].descricao}')),
        DataCell(Text('${data[index].quantidade}')),
        DataCell(Text('${data[index].pvp}')),
        DataCell(Text('${data[index].unidades}')),
        DataCell(
          data[index].composto!
              ? Container(
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                  child: Text(
                    'Sim',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 9,
                  ),
                  child: Text(
                    'Não',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: "Excluir Produto",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Container(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Deseja Excluir o Cliente?"),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.red,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0, primary: Colors.red),
                                      onPressed: () async {
                                        onTap();
                                        /*context
                                            .read<ProdutosController>()
                                            .deleteProduto(
                                                data[index].objectId ?? '0');
                                        Navigator.of(context).pop();*/
                                        Get.snackbar(
                                          "O produto Excluido",
                                          "O produto foi Excluído",
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
                                      label: Text("Sim"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(width: 6),
                                  Container(
                                    color: Colors.black,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.close),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0, primary: Colors.black),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      label: Text(
                                        "Não",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                width: 6,
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                tooltip: "Editar Produto",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      descricao = data[index].descricao!;
                      pmc = data[index].pmc!;
                      pmv = data[index].pmc!;
                      quantidade = data[index].quantidade!;
                      return AlertDialog(
                        content: Form(
                          key: _formKey,
                          child: Container(
                            height: 400,
                            width: 650,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Produto:",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Descrição ",
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                          initialValue: data[index].descricao,
                                          onChanged: (desc) {
                                            descricao = desc;
                                          },
                                          validator: (nome) {
                                            if (nome!.isEmpty) {
                                              return "O campo descrição é requerido";
                                            }

                                            return null;
                                          },
                                        ),
                                      ],
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Preço Médio de Venda:",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}')),
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Preço Médio de Venda",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
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
                                              initialValue: data[index].pmc,
                                              onChanged: (precomedio) {
                                                pmc = precomedio;
                                              },
                                              validator: (pmc) {
                                                if (pmc!.isEmpty) {
                                                  return "O campo Preço Médio de Venda é requerido";
                                                }

                                                return null;
                                              },
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quantidades:",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                      SizedBox(height: 5),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Quantidade",
                                          enabledBorder: OutlineInputBorder(
                                            // width: 0.0 produces a thin "hairline" border
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7),
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                        ),
                                        onChanged: (contribuinti) {
                                          contribuinti = contribuinti;
                                        },
                                        initialValue:
                                            data[index].quantidade.toString(),
                                        validator: (qtd) {
                                          if (qtd!.isEmpty) {
                                            return "O campo Quantidade é requerido";
                                          }
                                          quantidade = int.tryParse(qtd)!;
                                          return null;
                                        },
                                      ),
                                    ]),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Preço Médio de Compras:",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      initialValue: data[index].pvp,
                                      onChanged: (localidade) {
                                        localidade = localidade;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Preço Médio de Venda",
                                        enabledBorder: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.7),
                                        ),
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                      ),
                                      validator: (precoMedioVenda) {
                                        if (precoMedioVenda!.isEmpty) {
                                          return "O campo Preco Médio de Venda é requerido";
                                        }

                                        pmv = precoMedioVenda;

                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(height: 8),
                                Flexible(
                                  child: Container(
                                    color: Colors.green,
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.green,
                                      ),
                                      onPressed: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        /*final response = await context
                                            .read<ProdutosController>()
                                            .updateProdutos(
                                              id: data[index].objectId,
                                              descricao: descricao.trim(),
                                              quantidade: quantidade,
                                              pmc: double.tryParse(pmc),
                                              pmv: double.tryParse(pmv),
                                              composto: false,
                                            );*/
                                        onTap();

                                        /*print(response.result);
                                        if (response.count > 0) {
                                          Navigator.of(context).pop();

                                          Get.showSnackbar(
                                            GetSnackBar(
                                              mainButton: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              duration: Duration(seconds: 9),
                                              icon: Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                              message:
                                                  "O Produto foi actualizado com sucesso",
                                            ),
                                          );
                                        } else {
                                          if (response.count > 0) {
                                            DangerAlertBox(
                                                context: context,
                                                title: "Erro ao actualizar",
                                                messageText:
                                                    "Não foi possível Actualizar");
                                          }
                                        }*/
                                      },
                                      child: Text("Actualizar Registro"),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Flexible(
                                  child: Container(
                                    color: Colors.green,
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancelar"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data.length;
  }
}
