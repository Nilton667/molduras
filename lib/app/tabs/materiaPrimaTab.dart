import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:molduras/app/controllers/materiaPrimaController.dart';
import 'package:molduras/app/util/global.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MateriaPrimaTab extends StatelessWidget {
  final c = Get.put(MateriaPrimaController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MateriaPrimaController>(
      init: MateriaPrimaController(),
      initState: (_) {
        c.init(context);
      },
      builder: (_) {
        return Scaffold(
          appBar: Platform.isAndroid
              ? AppBar(
                  backgroundColor: Colors.yellow[900],
                  title: Text("Matérias Primas"),
                  elevation: 0,
                )
              : null,
          body: ModalProgressHUD(
            inAsyncCall: c.isLoading,
            progressIndicator: progressIndicator(),
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
                    controller: c.tabControllerUser,
                    onTap: (_) async {
                      if (c.tabControllerUser.index == 0) {
                        c.getData(context);
                      }
                      c.update();
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        c.tabControllerUser.index == 1
                            ? IconButton(
                                tooltip: "Voltar",
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  c.tabControllerUser.index = 0;
                                  c.getData(context);
                                  c.update();
                                },
                              )
                            : Center(),
                        c.tabControllerUser.index == 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Registo de Matérias Primas",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Center(),
                        Spacer(),
                        c.tabControllerUser.index == 0
                            ? OutlinedButton.icon(
                                onPressed: () {
                                  c.tabControllerUser.animateTo(
                                    1,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.decelerate,
                                  );
                                  c.update();
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
                              )
                            : Center(),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                c.tabControllerUser.index == 0
                    ? Container(
                        color: Colors.grey.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              OutlinedButton.icon(
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
                                                        alignment: pw.Alignment
                                                            .centerLeft,
                                                        child: pw.Text(
                                                          'Listagem de Matérias Primas',
                                                          style: pw.TextStyle(
                                                            color: PdfColors
                                                                .grey900,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold,
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
                                                          color:
                                                              PdfColors.white,
                                                        ),
                                                        padding: const pw
                                                                .EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 20),
                                                        alignment: pw.Alignment
                                                            .centerLeft,
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
                                                    mainAxisSize:
                                                        pw.MainAxisSize.min,
                                                    children: [
                                                      pw.Container(
                                                        alignment: pw
                                                            .Alignment.topRight,
                                                        padding: const pw
                                                                .EdgeInsets.only(
                                                            bottom: 8,
                                                            left: 30),
                                                        height: 40,
                                                        child: pw.PdfLogo(),
                                                      ),
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
                                      build: (ctx) => [],
                                    ),
                                  );

                                  await Printing.layoutPdf(
                                    onLayout: (PdfPageFormat format) async =>
                                        doc.save(),
                                  ); // Page
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
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(),
                Expanded(
                  child: TabBarView(
                    controller: c.tabControllerUser,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Scrollbar(
                        showTrackOnHover: true,
                        child: ListView(
                          controller: c.scrollController,
                          children: [
                            PaginatedDataTable(
                              rowsPerPage: c.rowsPerPage,
                              onRowsPerPageChanged: (v) {
                                c.rowsPerPage = v!;
                                c.update();
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
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Descrição",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "PMC",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Quantidade",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "PMV",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Comprimento",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
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
                                c.produtos,
                                context,
                                () {},
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 200,
                        child: Form(
                          key: c.formKey,
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
                                  controller: c.descricao,
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
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Preço Médio de Compra (PMC)",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.7),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white),
                                  controller: c.pmc,
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
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Preço Médio de Venda (PMV)",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.7),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white),
                                  controller: c.pvp,
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
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    leading: Text(
                                      c.labelTipoUnidade,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    trailing: PopupMenuButton(
                                      tooltip: "Selecione a Unidade",
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (value) {
                                        if (value == 1) {
                                          c.labelTipoUnidade =
                                              "Metros Lineares";
                                          c.unidade = 1;
                                        } else {
                                          c.labelTipoUnidade =
                                              "Metros Quadrados";
                                          c.unidade = 2;
                                        }
                                        c.update();
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
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'\b[0-9]+\b'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Quantidade",
                                    enabledBorder: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  controller: c.quantidade,
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
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  controller: c.comprimento,
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
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  controller: c.largura,
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
                                    c.submitData(context);
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Registar",
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
                SizedBox(height: 20)
              ],
            ),
          ),
        );
      },
    );
  }
}

/*class _MateriaPrimaTabState extends State<MateriaPrimaTab>
    with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //context.read<MateriaPrimaController>().getProdutos();
    });
    getData();

  ;
  }
}*/

class MyDataTableSource extends DataTableSource {
  final c = Get.put(MateriaPrimaController());
  MyDataTableSource(this.data, this.context, this.onTap);

  Function onTap;
  String pmv = "";
  String pmc = "";
  String descricao = "";
  int quantidade = 0;
  var id = 0;
  final List data;
  BuildContext context;
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data[index]['id']}')),
        DataCell(Text('${data[index]['descricao']}')),
        DataCell(Text('${data[index]['pmc']}')),
        DataCell(Text('${data[index]['quantidade']}')),
        DataCell(Text('${data[index]['pvp']}')),
        DataCell(Text('${data[index]['comprimento']}')),
        DataCell(Text('${data[index]['largura']}')),
        DataCell(
          Text(
              '${data[index]['unidade'] == 1 ? 'Metros Lineares' : 'Metros Quadrados'}'),
        ),
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
                              Text("Deseja excluir a máteria prima?"),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.red,
                                    ),
                                    onPressed: () async {
                                      Get.back();
                                      c.removeMateriaPrima(
                                          context, data[index]['id']);
                                    },
                                    label: Text(
                                      "Sim",
                                      style: TextStyle(color: Colors.white),
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
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.black,
                                      ),
                                      onPressed: () {
                                        Get.back();
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
                      id = data[index]['id'];
                      descricao = data[index]['descricao'];
                      pmc = data[index]['pmc'].toString();
                      pmv = data[index]['pvp'].toString();
                      quantidade = data[index]['quantidade'];
                      return AlertDialog(
                        content: Form(
                          key: c.editFormKey,
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
                                            initialValue: data[index]
                                                ['descricao'],
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
                                      ),
                                    ),
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
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}'),
                                              ),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Preço Médio de Venda",
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
                                            initialValue:
                                                data[index]['pvp'].toString(),
                                            onChanged: (precomedio) {
                                              pmv = precomedio;
                                            },
                                            validator: (pmv) {
                                              if (pmv!.isEmpty) {
                                                return "O campo Preço Médio de Venda é requerido";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quantidades:",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Quantidade",
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
                                      onChanged: (contribuinti) {
                                        contribuinti = contribuinti;
                                      },
                                      initialValue:
                                          data[index]['quantidade'].toString(),
                                      validator: (qtd) {
                                        if (qtd!.isEmpty) {
                                          return "O campo Quantidade é requerido";
                                        }
                                        quantidade = int.tryParse(qtd)!;
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Preço Médio de Compras:",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'),
                                        ),
                                      ],
                                      initialValue:
                                          data[index]['pmc'].toString(),
                                      onChanged: (value) {
                                        pmc = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Preço Médio de Compra",
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
                                      validator: (precoMedioCompra) {
                                        if (precoMedioCompra!.isEmpty) {
                                          return "O campo Preco Médio de Compra é requerido";
                                        }

                                        pmc = precoMedioCompra;

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
                                        if (!c.editFormKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        Get.back();
                                        c.editMateriaPrima(
                                          context,
                                          id,
                                          descricao,
                                          quantidade,
                                          pmc,
                                          pmv,
                                        );
                                      },
                                      child: Text(
                                        "Actualizar Registo",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
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
                                        Get.back();
                                      },
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
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
