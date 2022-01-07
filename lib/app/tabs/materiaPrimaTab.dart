import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../models/user.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MateriaPrimaTab extends StatefulWidget {
  const MateriaPrimaTab({Key? key}) : super(key: key);

  @override
  _MateriaPrimaTabState createState() => _MateriaPrimaTabState();
}

class _MateriaPrimaTabState extends State<MateriaPrimaTab>
    with TickerProviderStateMixin {
  late TabController _tabControllerUser;
  int _rowsPerPage = 5;
  bool _isLoading = false;
  TextEditingController _descricao = TextEditingController();
  TextEditingController _pmc = TextEditingController();
  TextEditingController _pvp = TextEditingController();
  TextEditingController _quantidade = TextEditingController();
  TextEditingController _comprimento = TextEditingController();
  TextEditingController _largura = TextEditingController();
  int unidade = 1;
  String labelTipoUnidade = "Selecione a Unidade";
  final formKey = GlobalKey<FormState>();
  bool composto = false;
  late ScrollController _scrollController;
  List<MateriaPrima> _produtos = [];
  List produtos = [];
  @override
  void initState() {
    super.initState();
    setState(() {});
    _tabControllerUser = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
  }

  getData() async {
    _produtos.clear();
    //produtos = context.read<MateriaPrimaController>().produtos;
    for (int i = 0; i < produtos.length; i++) {
      _produtos.add(MateriaPrima(
          comprimento: produtos[i].comprimento,
          largura: produtos[i].largura,
          descricao: produtos[i].descricao,
          pvp: produtos[i].pvp.toString(),
          pmc: produtos[i].pmc.toString(),
          quantidade: produtos[i].quantidade,
          unidade: produtos[i].unidade,
          codigo: i + 1,
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //context.read<MateriaPrimaController>().getProdutos();
    });
    getData();

    return Scaffold(
      appBar: Platform.isAndroid
          ? AppBar(
              backgroundColor: Colors.yellow[900],
              title: Text("Matérias Primas"),
              elevation: 0,
            )
          : null,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
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
                  }
                },
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Text("Gestão de Matérias Primas"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Registo de Matéria Prima"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.grey.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      tooltip: "Voltar",
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                        setState(() {
                          _tabControllerUser.index = 0;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Registo de Matérias Primas",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Spacer(),

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
                                                alignment:
                                                    pw.Alignment.centerLeft,
                                                child: pw.Text(
                                                  'Listagem de Matérias Primas',
                                                  style: pw.TextStyle(
                                                    color: PdfColors.grey900,
                                                    fontWeight:
                                                        pw.FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              pw.Container(
                                                decoration: pw.BoxDecoration(
                                                  borderRadius: const pw
                                                          .BorderRadius.all(
                                                      pw.Radius.circular(2)),
                                                  color: PdfColors.white,
                                                ),
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 20),
                                                alignment:
                                                    pw.Alignment.centerLeft,
                                                height: 50,
                                                child: pw.DefaultTextStyle(
                                                  style: pw.TextStyle(
                                                    color:
                                                        PdfColors.blueGrey900,
                                                    fontSize: 12,
                                                  ),
                                                  child: pw.Column(
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      pw.Row(children: [
                                                        pw.Text('Descricão:'),
                                                        pw.SizedBox(width: 5),
                                                        pw.Text(
                                                            "Relatório de Matérias Primas Aphit Molduras"),
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
                                            mainAxisSize: pw.MainAxisSize.min,
                                            children: [
                                              pw.Container(
                                                alignment:
                                                    pw.Alignment.topRight,
                                                padding:
                                                    const pw.EdgeInsets.only(
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
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
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
                                /*pw.Table.fromTextArray(
                                  context: ctx,
                                  data: <List<String>>[
                                    <String>[
                                      'Descrição',
                                      'Quantidade',
                                      'PVP',
                                      'PMC',
                                      'Comprimento',
                                      'Largura',
                                      'Unidade',
                                    ],
                                    ...context
                                        .read<MateriaPrimaController>()
                                        .produtos
                                        .map((e) => [
                                              e.descricao.toString(),
                                              e.quantidade.toString(),
                                              e.pvp.toString(),
                                              e.pmc.toString(),
                                              e.comprimento.toString(),
                                              e.largura.toString(),
                                              e.unidade == 1
                                                  ? "Metros Lineares"
                                                  : "Metros Quadrados",
                                            ])
                                  ],
                                ),*/
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
                          "Imprimir Matérias Primas ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    SizedBox(width: 10),
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
                        color: Colors.green,
                      ),
                      label: Text(
                        "Nova Matéria Prima ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
                              "Comprimento",
                              style: TextStyle(color: Colors.grey),
                            )),
                            DataColumn(
                              label: Text(
                                "Largura",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Unidade",
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
                            _produtos,
                            context,
                            () {
                              /*WidgetsBinding.instance!.addPostFrameCallback(
                                (_) {
                                  context
                                      .read<MateriaPrimaController>()
                                      .getProdutos();
                                },
                              );*/
                              getData();
                              setState(() {
                                _isLoading = true;
                              });
                              Future.delayed(
                                Duration(seconds: 2),
                                () {
                                  setState(() {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  });
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
                    height: 200,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
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
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
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
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
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
                          SizedBox(height: 5),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: ListTile(
                                dense: true,
                                leading: Text(
                                  labelTipoUnidade,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                                trailing: PopupMenuButton(
                                    tooltip: "Selecione a Unidade",
                                    icon: Icon(Icons.arrow_drop_down),
                                    onSelected: (value) {
                                      if (value == 1) {
                                        setState(() {
                                          labelTipoUnidade = "Metros Lineares";
                                          unidade = 1;
                                        });
                                      } else {
                                        setState(() {
                                          labelTipoUnidade = "Metros Quadrados";
                                          unidade = 2;
                                        });
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          child: Text("Metros Lineares"),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Text("Metros Quadrados"),
                                          value: 2,
                                        )
                                      ];
                                    }),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'\b[0-9]+\b')),
                              ],
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
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                              controller: _comprimento,
                              validator: (qtd) {
                                if (qtd!.isEmpty) {
                                  return "O campo comprimento é requerido";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                                  fillColor: Colors.white),
                              controller: _largura,
                              validator: (qtd) {
                                if (qtd!.isEmpty) {
                                  return "O campo Largura é requerido";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            color: Colors.green,
                            width: 200,
                            height: 40,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  /*final response = await context
                                      .read<MateriaPrimaController>()
                                      .addProduto(
                                        quantidade: int.tryParse(
                                            _quantidade.text.trim()),
                                        comprimento:
                                            double.parse(_comprimento.text),
                                        largura: double.parse(_largura.text),
                                        descricao: _descricao.text.trim(),
                                        unidade: unidade,
                                        pmc: double.tryParse(_pmc.text.trim()),
                                        pmv: double.parse(
                                          _pvp.text.trim(),
                                        ),
                                      );*/

                                  //print(response.result.toString());
                                  SuccessAlertBox(
                                      context: context,
                                      messageText:
                                          "A matéria prima foi cadastrada com sucesso",
                                      title: "Cadastrado");
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                icon: Icon(Icons.check),
                                label: Text("Cadastrar    ")),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
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
  final List<MateriaPrima> data;
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
        DataCell(Text('${data[index].comprimento}')),
        DataCell(Text('${data[index].largura}')),
        DataCell(Text(
            '${data[index].unidade == 1 ? 'Metros Lineares' : 'Metros Quadrados'}')),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: "Excluir",
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
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
                              Text("Deseja Excluir o Cliente ?"),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                      icon: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0, primary: Colors.red),
                                      onPressed: () async {
                                        /*onTap();
                                        context
                                            .read<MateriaPrimaController>()
                                            .deleteMateriaPrima(
                                                data[index].objectId ?? '');
                                        Navigator.of(context).pop();

                                        SuccessAlertBox(
                                            context: context,
                                            title: "Cliente Excluido",
                                            messageText:
                                                "O cliente foi excluido com sucesso");*/
                                      },
                                      label: Text("Sim")),
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
                tooltip: "Editar",
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
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
                            width: 700,
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
                                          "Materia Prima:",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    ]),
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
                                            .read<MateriaPrimaController>()
                                            .updateProdutos(
                                              id: data[index].objectId,
                                              descricao: descricao.trim(),
                                              quantidade: quantidade,
                                              pmc: double.tryParse(pmc),
                                              pmv: double.tryParse(pmv),
                                              composto: false,
                                            );
                                        onTap();

                                        //print(response.result);
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
                                              duration: Duration(seconds: 3),
                                              icon: Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                              message:
                                                  "A matéria prima foi actualizado com sucesso",
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
                                        child: Text("Cancelar")),
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
