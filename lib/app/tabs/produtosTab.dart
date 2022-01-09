import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:molduras/app/controllers/materiaPrimaController.dart';
import 'package:molduras/app/controllers/produtosController.dart';
import 'package:molduras/app/util/global.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProdutosTab extends StatelessWidget {
  final c = Get.put(ProdutosController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProdutosController>(
      init: ProdutosController(),
      initState: (_) {
        c.init(context);
      },
      builder: (_) {
        return Scaffold(
          appBar: Platform.isAndroid
              ? AppBar(
                  backgroundColor: Colors.yellow[900],
                  title: Text("Produtos"),
                  elevation: 0,
                )
              : null,
          body: ModalProgressHUD(
            progressIndicator: progressIndicator(),
            inAsyncCall: c.isLoading,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                  color: Colors.yellow.shade800,
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
                                  "Registro de Produtos",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Center(),
                        Spacer(),
                        c.tabControllerUser.index == 0
                            ? OutlinedButton.icon(
                                onPressed: () {
                                  c.tabControllerUser.animateTo(1,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.decelerate);
                                  c.update();
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
                              )
                            : Center(),
                      ],
                    ),
                  ),
                ),
                c.tabControllerUser.index != 0
                    ? SizedBox()
                    : Container(
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
                                                          'Lista de Produtos',
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
                                                              .BorderRadius.all(
                                                            pw.Radius.circular(
                                                                2),
                                                          ),
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
                                                              pw.Row(
                                                                children: [
                                                                  pw.Text(
                                                                    'Descricão:',
                                                                  ),
                                                                  pw.SizedBox(
                                                                      width: 5),
                                                                  pw.Text(
                                                                    "Relatório de Produtos Aphit Molduras",
                                                                  ),
                                                                ],
                                                              )
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
                                                          left: 30,
                                                        ),
                                                        height: 40,
                                                        child: pw.PdfLogo(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (context.pageNumber > 1)
                                              pw.SizedBox(
                                                height: 20,
                                              )
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
                                            <String>[
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
                                                )
                                          ],
                                        ),
                                      ],
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
                                  "Imprimir Lista de Produtos",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
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
                                    "Unidade",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Composto",
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
                          horizontal: 40,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Form(
                          key: c.formKey,
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.shopping_bag_outlined,
                                    ),
                                    hintText: "Descrição",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.7),
                                    ),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.monetization_on_outlined),
                                          hintText:
                                              "Preço Médio de Compra (PMC)",
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
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.monetization_on_outlined),
                                        hintText: "Preço Médio de Venda (PMV)",
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
                                      controller: c.pvp,
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
                                          RegExp(r'\b[0-9]+\b'),
                                        ),
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
                                  SizedBox(width: 10),
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
                                          c.labelTipoProduto,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        trailing: PopupMenuButton(
                                          tooltip:
                                              "Selecione o tipo de produto",
                                          icon: Icon(Icons.arrow_drop_down),
                                          onSelected: (value) {
                                            if (value == true) {
                                              c.labelTipoProduto =
                                                  "Produto Composto";
                                              c.isProductoComposto = true;
                                            } else {
                                              c.labelTipoProduto =
                                                  "Produto Simples";
                                              c.isProductoComposto = false;
                                            }
                                            c.update();
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
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: Text(
                                    c.labelUnidade,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    tooltip: "Selecione a unidade",
                                    icon: Icon(Icons.arrow_drop_down),
                                    onSelected: (value) {
                                      if (value == true) {
                                        c.isMetrosLineares = true;
                                        c.labelUnidade = "Metros Quadrados";
                                      } else {
                                        c.labelUnidade = "Metros  Lineares";
                                        c.isMetrosLineares = false;
                                      }
                                      c.update();
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
                              c.isMetrosLineares == true
                                  ? Expanded(
                                      child: TextFormField(
                                        controller: c.metrosQuadrados,
                                        onChanged: (v) {
                                          print(v);
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}'),
                                          ),
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
                                          fillColor: Colors.white,
                                        ),
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
                                                RegExp(r'^\d+\.?\d{0,2}'),
                                              ),
                                            ],
                                            controller: c.comprimento,
                                            decoration: InputDecoration(
                                              hintText: "Comprimento",
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7,
                                                ),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}'),
                                              ),
                                            ],
                                            controller: c.largura,
                                            decoration: InputDecoration(
                                              hintText: "Largura",
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.7),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 15),
                              c.isProductoComposto
                                  ? SizedBox()
                                  : SizedBox(
                                      height: 40.1 *
                                          Get.put(MateriaPrimaController())
                                              .produtos
                                              .length,
                                      child: ListView.builder(
                                        itemCount:
                                            Get.put(MateriaPrimaController())
                                                .produtos
                                                .length,
                                        itemBuilder: (BuildContext context, i) {
                                          return Container(
                                            child: Text(
                                              Get.put(MateriaPrimaController())
                                                  .produtos[i]
                                                  .toString(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              Center(),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 90,
                                height: 40,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.green,
                                  ),
                                  onPressed: () async {
                                    if (!c.formKey.currentState!.validate()) {
                                      return;
                                    }
                                    c.submitData(context);
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: c.isProductoComposto ||
                  c.tabControllerUser.index == 0
              ? SizedBox()
              : FloatingActionButton.extended(
                  label: Text(
                    "Adicionar Matéria Prima",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        content: Container(
                          width: 540,
                          height: 520,
                          child: Form(
                            key: c.mtFormKey,
                            child: Column(
                              children: [
                                TypeAheadFormField(
                                  hideOnEmpty: true,
                                  hideOnLoading: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                          fontStyle: FontStyle.normal,
                                        ),
                                    decoration: InputDecoration(
                                      labelText: "Pesquisar Matérias Primas",
                                      suffixIcon: Icon(
                                        Icons.search,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return await Get.put(
                                            MateriaPrimaController())
                                        .searchMateriaPrima(
                                      descricao: pattern,
                                    );
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return Text(
                                      "Nenhum resultado foi encontrado",
                                    );
                                  },
                                  getImmediateSuggestions: true,
                                  hideSuggestionsOnKeyboardHide: true,
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text("$suggestion"),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    /*c.materiaPrima.text =
                                        suggestion?['descricao'] ?? '';
                                    c.mtId.text = suggestion?.objectId;
                                    c.preco.text = suggestion?["pmv"];
                                    c.update();*/
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: c.inputStyle,
                                        controller: c.materiaPrima,
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
                                          hintStyle: c.inputStyle,
                                          hintText: c.materiaPrima.text.isEmpty
                                              ? "Selecione a matéria prima"
                                              : c.materiaPrima.text.toString(),
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
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  style: c.inputStyle,
                                  controller: c.preco,
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
                                    hintStyle: c.inputStyle,
                                    hintText: c.preco.text.isEmpty
                                        ? "Preco"
                                        : c.preco.text.toString(),
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
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  style: c.inputStyle,
                                  onChanged: (qt) {
                                    if (qt.isAlphabetOnly) {
                                      return;
                                    }

                                    c.quantidades = int.parse(qt);
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
                                    hintStyle: c.inputStyle,
                                    hintText: "Quantidade",
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
                                    filled: false,
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
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  style: c.inputStyle,
                                  controller: c.mtComprimento,
                                  decoration: InputDecoration(
                                    enabled: true,
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7,
                                      ),
                                    ),
                                    hintStyle: c.inputStyle,
                                    hintText: "Comprimento",
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
                                    filled: false,
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
                                  style: c.inputStyle,
                                  controller: c.mtLargura,
                                  decoration: InputDecoration(
                                    enabled: true,
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.7,
                                      ),
                                    ),
                                    hintStyle: c.inputStyle,
                                    hintText: c.mtLargura.text.isEmpty
                                        ? "Largura"
                                        : c.mtLargura.text.toString(),
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
                                    filled: false,
                                    fillColor: Colors.grey[100],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!c.mtFormKey.currentState!
                                          .validate()) {
                                        return;
                                      }

                                      /*context
                                          .read<MateriaPrimaController>()
                                          .addMateriaPrima(
                                            id: c.mtId.text,
                                            precoVenda:
                                                double.parse(c.preco.text),
                                            produto: c.materiaPrima.text,
                                            quantidade: c.quantidades,
                                            comprimento: double.parse(
                                                c.mtComprimento.text),
                                            largura:
                                                double.parse(c.mtLargura.text),
                                          );

                                      c.preco.clear();
                                      c.materiaPrima.clear();
                                      c.quantidades = 0;*/
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.green,
                                    ),
                                    child: Text(
                                      "Adicionar",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

/*class _ProdutosTabState extends State<ProdutosTab>
    with TickerProviderStateMixin {

  @override
  void dispose() {
    super.dispose();
    _tabControllerUser.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _metrosLineares = (((double.parse(_comprimento.text ?? "0") * 2) +
            (double.parse(_largura.text ?? "0") * 2) +
            8 * 4)) /
        100; 
    // print(_metrosLineares);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //context.read<ProdutosController>().getProdutos();
    });
    getData();

    
  }
}*/

class MyDataTableSource extends DataTableSource {
  final c = Get.put(ProdutosController());
  MyDataTableSource(this.data, this.context, this.onTap);
  final formKey = GlobalKey<FormState>();
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
        DataCell(Text('${data[index]['pmc']}')),
        DataCell(Text('${data[index]['descricao']}')),
        DataCell(Text('${data[index]['quantidade']}')),
        DataCell(Text('${data[index]['pvp']}')),
        DataCell(Text('${data[index]['unidade']}')),
        DataCell(
          data[index]['composto'] == 'true'
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
                              Text("Deseja excluir o produto?"),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.red,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0, primary: Colors.red),
                                      onPressed: () async {
                                        Get.back();
                                        c.removeProduto(
                                            context, data[index]['id']);
                                      },
                                      label: Text(
                                        "Sim",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
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
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                tooltip: "Editar Produto",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      id = data[index]['id'];
                      descricao = data[index]['descricao'];
                      pmc = data[index]['pmc'].toString();
                      pmv = data[index]['pmc'].toString();
                      quantidade = data[index]['quantidade'];
                      return AlertDialog(
                        content: Form(
                          key: formKey,
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
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.7,
                                              ),
                                            ),
                                            border: const OutlineInputBorder(),
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
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Preço Médio de Venda",
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
                                            initialValue:
                                                data[index]['pmc'].toString(),
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
                                        ],
                                      ),
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
                                        initialValue: data[index]['quantidade']
                                            .toString(),
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
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      initialValue:
                                          data[index]['pvp'].toString(),
                                      onChanged: (localidade) {
                                        localidade = localidade;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Preço Médio de Venda",
                                        enabledBorder: OutlineInputBorder(
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
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }
                                        data[index]['descricao'];
                                        Get.back();

                                        c.editProduto(
                                          context,
                                          id,
                                          descricao,
                                          quantidade,
                                          pmc,
                                          pmv,
                                        );
                                      },
                                      child: Text(
                                        "Atualizar Registo",
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
                                        )),
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
