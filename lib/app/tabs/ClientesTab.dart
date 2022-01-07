import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:molduras/app/controllers/clientesController.dart';
import 'package:molduras/app/util/global.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class UserTab extends StatelessWidget {
  final c = Get.put(userTabController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<userTabController>(
      init: userTabController(),
      initState: (_) {
        c.init(context);
      },
      builder: (_) {
        return Scaffold(
          appBar: Platform.isAndroid
              ? AppBar(
                  backgroundColor: Colors.yellow[900],
                  title: Text("Aphit Molduras"),
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
                        text: "Gestão de Clientes",
                      ),
                      Tab(
                        text: "Registro de Clientes",
                      ),
                    ],
                  ),
                ),
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
                                  color: Colors.yellow.shade800,
                                ),
                                onPressed: () {
                                  c.tabControllerUser.index = 0;
                                  c.getData(context);
                                  c.update();
                                },
                              )
                            : Center(),
                        Platform.isAndroid
                            ? SizedBox()
                            : c.tabControllerUser.index == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Registro de Clientes",
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
                                  c.tabControllerUser.animateTo(
                                    1,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.decelerate,
                                  );
                                  c.update();
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.yellow.shade800,
                                ),
                                label: Text(
                                  "Novo Cliente ",
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
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
                                                  alignment:
                                                      pw.Alignment.centerLeft,
                                                  child: pw.Text(
                                                    'Lista de Clientes',
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
                                                      pw.Radius.circular(2),
                                                    ),
                                                    color: PdfColors.white,
                                                  ),
                                                  padding:
                                                      const pw.EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20,
                                                  ),
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
                                                        pw.Row(
                                                          children: [
                                                            pw.Text(
                                                                'Descricão:'),
                                                            pw.SizedBox(
                                                                width: 5),
                                                            pw.Text(
                                                              "Relatório de clientes Aphit Molduras",
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
                                              mainAxisSize: pw.MainAxisSize.min,
                                              children: [
                                                pw.Container(
                                                  alignment:
                                                      pw.Alignment.topRight,
                                                  padding:
                                                      const pw.EdgeInsets.only(
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
                            "Imprimir Lista de Clientes",
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
                ),
                Expanded(
                  child: TabBarView(
                    controller: c.tabControllerUser,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Scrollbar(
                        isAlwaysShown: true,
                        controller: c.scrollController,
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
                                    "Codigo",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nome",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Telefone",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Contribuiente",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Localidade",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Morada",
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
                                c.clientes,
                                context,
                                () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      RawScrollbar(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 280,
                          child: Form(
                            key: c.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.people),
                                          hintText: "Nome ",
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
                                        controller: c.nome,
                                        validator: (nome) {
                                          if (nome!.isEmpty) {
                                            return "O campo nome é requerido";
                                          }
                                          if (nome.length < 4) {
                                            return "O nome deve conter mais de 6 caracteres";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        maxLength: 9,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          counterText: "",
                                          prefixIcon: Icon(Icons.phone),
                                          hintText: "Telefone",
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
                                        controller: c.telemovel,
                                        validator: (telemovel) {
                                          if (telemovel!.isEmpty) {
                                            return "O campo telemóvel é requerido";
                                          }
                                          if (telemovel.length < 9) {
                                            return "O telemóvel deve conter mais de 9 caracteres";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  maxLength: 9,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    counterText: "",
                                    prefixIcon: Icon(Icons.credit_card),
                                    hintText: "Contribuinte",
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
                                  controller: c.contribuinti,
                                  validator: (telemovel) {
                                    if (telemovel!.length > 9) {
                                      return "O campo contribuinti não deve conter mais de 9 dígitos";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: c.localidade,
                                  decoration: InputDecoration(
                                    hintText: "Localidade",
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
                                  validator: (localidade) {
                                    if (localidade!.isEmpty) {
                                      return "O campo telemóvel é requerido";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: c.morada,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.location_on),
                                    hintText: "Morada",
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
                                  validator: (morada) {
                                    if (morada!.isEmpty) {
                                      return "o campo morada é requerido";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8),
                                Flexible(
                                  child: Container(
                                    color: Colors.green,
                                    width: 200,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      onPressed: () => c.submitData(context),
                                      icon: Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Salvar Registro",
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

class MyDataTableSource extends DataTableSource {
  final c = Get.put(userTabController());
  MyDataTableSource(this.data, this.context, this.onTap);
  final formKey = GlobalKey<FormState>();
  String nome = "";
  var id = "";
  String morada = "";
  String localidade = "";
  String contribuinti = "";
  String telemovel = "";
  Function onTap;

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
        DataCell(Text('${data[index]['nome']}')),
        DataCell(Text('${data[index]['telemovel']}')),
        DataCell(Text('${data[index]['contribuinti']}')),
        DataCell(Text('${data[index]['morada']}')),
        DataCell(Text('${data[index]['localidade']}')),
        DataCell(Row(
          children: [
            IconButton(
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
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0, primary: Colors.red),
                                    onPressed: () async {
                                      Get.back();
                                      c.removeCliente(
                                        context,
                                        data[index]['id'],
                                      );
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
                                        elevation: 0, primary: Colors.black),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    label: Text(
                                      "Não",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    id = data[index]['id'].toString();
                    nome = data[index]['nome'];
                    morada = data[index]['morada'];
                    localidade = data[index]['localidade'];
                    contribuinti = data[index]['contribuinti'];
                    telemovel = data[index]['telemovel'];
                    return AlertDialog(
                      content: Form(
                        key: formKey,
                        child: Container(
                          height: 460,
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
                                          "Nome do Cliente:",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.people),
                                            hintText: "Nome ",
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
                                          initialValue: data[index]['nome'],
                                          onChanged: (nom) {
                                            nome = nom;
                                          },
                                          validator: (nome) {
                                            if (nome!.isEmpty) {
                                              return "O campo nome é requerido";
                                            }
                                            if (nome.length < 4) {
                                              return "O nome deve conter mais de 6 caracteres";
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
                                          "Telefone:",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          maxLength: 9,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            prefixIcon: Icon(Icons.phone),
                                            hintText: "Telemóvel",
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.7),
                                            ),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                          initialValue: data[index]
                                              ['telemovel'],
                                          onChanged: (telefone) {
                                            telemovel = telefone;
                                          },
                                          validator: (telemovel) {
                                            if (telemovel!.isEmpty) {
                                              return "O campo telefone é requerido";
                                            }
                                            if (telemovel.length < 9) {
                                              return "O telemóvel deve conter mais de 9 caracteres";
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
                                    "Contribuinti:",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.credit_card),
                                      hintText: "Contribuinte",
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
                                    initialValue: data[index]['contribuinti'],
                                    validator: (contrib) {
                                      if (contrib!.isEmpty) {
                                        return "O campo contribuinti é requerido";
                                      }
                                      contribuinti = contrib;
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
                                    "Localidade:",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    initialValue: data[index]['localidade'],
                                    onChanged: (localidade) {
                                      localidade = localidade;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Localidade",
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
                                    validator: (local) {
                                      if (local!.isEmpty) {
                                        return "O campo localidade é requerido";
                                      }
                                      localidade = local;

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
                                    "Morada:",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    initialValue: data[index]['morada'],
                                    onChanged: (morada) {
                                      morada = morada;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_on),
                                      hintText: "Morada",
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
                                    validator: (morad) {
                                      if (morad!.isEmpty) {
                                        return "o campo morada é requerido";
                                      }
                                      morada = morad;
                                      return null;
                                    },
                                  ),
                                ],
                              ),
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

                                      Get.back();

                                      c.editCliente(
                                        context,
                                        id,
                                        nome,
                                        morada,
                                        localidade,
                                        contribuinti,
                                        telemovel,
                                      );
                                    },
                                    child: Text(
                                      "Actualizar Registro",
                                      style: TextStyle(color: Colors.white),
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
                                      style: TextStyle(color: Colors.white),
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
            SizedBox(
              width: 6,
            ),
          ],
        )),
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
