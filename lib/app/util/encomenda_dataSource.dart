// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:molduras/app/controllers/clientesController.dart';
import 'package:molduras/app/controllers/encomdendasController.dart';
import 'package:get/get.dart';
import 'package:molduras/app/util/global.dart';

class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this.data, this.context, this.onTap);

  Function onTap;

  final List<Encomendas> data;
  BuildContext context;
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data[index].codigo}')),
        DataCell(Text('${data[index].iva}')),
        DataCell(Text('${data[index].margemLucro}')),
        DataCell(Text('${data[index].sinal}')),
        DataCell(Text('${data[index].subtotal}')),
        DataCell(Text('${data[index].total}')),
        DataCell(Text('${data[index].valorPagar}')),
        DataCell(Row(
          children: [
            IconButton(
              tooltip: "Visualizar",
              icon: Icon(
                Icons.visibility,
                color: Colors.green,
              ),
              onPressed: () async {
                /*await context
                    .read<ClientesController>()
                    .searchClientesById(id: data[index].idCliente.toString());

                List cliente =
                    context.read<ClientesController>().getclienteById;

                Get.dialog(
                  AlertDialog(
                    content: Container(
                      width: 800,
                      height: 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dados do Cliente :"),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.grey[200],
                                child: Text(
                                  "Nome:",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: TextFormField(
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
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      hintText: cliente[0]["nome"],
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
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.grey[200],
                                  child: Text("NIF:")),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
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
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    hintText: cliente[0]["contribuinti"],
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.grey[200],
                                child: Text("Telemóvel:"),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
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
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    hintText:
                                        cliente[0]["telemovel"].toString(),
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
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.grey[200],
                                child: Text(
                                  "Morada:",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
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
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    hintText: cliente[0]["morada"],
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Matérias Primas associadas à encomenda :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Matéria Prima",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Preço de Venda",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Quantidade",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Comprimento",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Largura",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                              itemCount: data[index].materiasPrimas.length,
                              itemBuilder: (BuildContext context, int index) {
                                totalMateriasPrimas += double.parse(
                                        materiasPrimas[indice]["pvp"]
                                            .toString()) *
                                    double.parse(materiasPrimas[indice]
                                            ["quantidade"]
                                        .toString());
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        initialValue:
                                            data[index].materiasPrimas[index]
                                                ["MateriaPrima"],
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        initialValue: data[index]
                                            .materiasPrimas[index]["pvp"]
                                            .toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        initialValue: data[index]
                                            .materiasPrimas[index]["quantidade"]
                                            .toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        initialValue: data[index]
                                            .materiasPrimas[index]
                                                ["comprimento"]
                                            .toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        initialValue: data[index]
                                            .materiasPrimas[index]["largura"]
                                            .toString(),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<EncomendasController>()
                                      .updateEstadoEncomenda(
                                          estado: data.first.estado,
                                          id: data[index].codigo);

                                  Get.snackbar(
                                    "Encomenda Alterada",
                                    "O Estado da Encomenda foi alterado",
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
                                icon: Icon(Icons.print),
                                label: Row(
                                  children: [
                                    Text("Imprimir"),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.close),
                                label: Text("Fechar"),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Subtotal: ${data[index].subtotal}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text("Iva:  ${data[index].iva! * 100}%",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      "Taxa:  ${data[index].margemLucro! * 100}%",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text("Sinal:  ${data[index].sinal}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text("Total:  ${data[index].total}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Valor a Pagar: ${data[index].valorPagar}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );*/
              },
            ),
            SizedBox(
              width: 6,
            ),
            IconButton(
              tooltip: "Editar",
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                /*String labelEstado = "Alterar Estado da Encomenda";
                bool loading = false;
                await context
                    .read<ClientesController>()
                    .searchClientesById(id: data[index].idCliente.toString());
                List cliente =
                    context.read<ClientesController>().getclienteById;
                Get.dialog(
                  AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          height: 600,
                          width: 700,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Alterar Estado da Encomenda :"),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(16),
                                      color: Colors.grey[200],
                                      child: Text(
                                        "Nome:",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: TextFormField(
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
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          hintText:
                                              cliente.first["nome"] ?? "null",
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
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(16),
                                      color: Colors.grey[200],
                                      child: Text("NIF:")),
                                  Expanded(
                                      flex: 3,
                                      child: TextFormField(
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
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          hintText:
                                              cliente.first["contribuinti"],
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
                                      )),
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
                                      child: Text("Telemóvel:")),
                                  Expanded(
                                      flex: 3,
                                      child: TextFormField(
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
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          hintText: cliente.first["telemovel"]
                                              .toString(),
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
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(16),
                                      color: Colors.grey[200],
                                      child: Text(
                                        "Morada:",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: TextFormField(
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
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          hintText: cliente.first["morada"],
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
                                      )),
                                ],
                              ),
                              Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: Text(
                                    data.first.estado ?? "",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                  ),
                                  trailing: PopupMenuButton(
                                      tooltip: "Alterar Estado da Encomenda",
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (value) {
                                        switch (value) {
                                          case 1:
                                            setState(() {
                                              data.first.estado = "Nova";
                                            });
                                            break;
                                          case 2:
                                            setState(() {
                                              data.first.estado = "Em Produção";
                                            });
                                            break;
                                          case 3:
                                            setState(() {
                                              data.first.estado =
                                                  "A Espera de Levantamento";
                                            });
                                            break;
                                          case 4:
                                            setState(() {
                                              data.first.estado =
                                                  "Pago e Entregue";
                                            });
                                            break;
                                          case 5:
                                            setState(() {
                                              data.first.estado = "Entregue";
                                            });
                                            break;
                                          default:
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            child: Text("Nova"),
                                            value: 1,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Em Produção"),
                                            value: 2,
                                          ),
                                          PopupMenuItem(
                                            child: Text(
                                                "A Espera de Levantamento"),
                                            value: 3,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Pago e Entregue"),
                                            value: 4,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Entregue"),
                                            value: 5,
                                          )
                                        ];
                                      }),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                    "Matérias Primas associadas à encomenda :",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Matéria Prima",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Preço de Venda",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Quantidade",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Comprimento",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Largura",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                    itemCount:
                                        data[index].materiasPrimas.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      /*    totalMateriasPrimas += double.parse(
                                  materiasPrimas[indice]["pvp"].toString()) *
                              double.parse(materiasPrimas[indice]["quantidade"]
                                  .toString()); */
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                              enabled: false,
                                              initialValue: data[index]
                                                      .materiasPrimas[index]
                                                  ["MateriaPrima"],
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                              enabled: false,
                                              initialValue: data[index]
                                                  .materiasPrimas[index]["pvp"]
                                                  .toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                              enabled: false,
                                              initialValue: data[index]
                                                  .materiasPrimas[index]
                                                      ["quantidade"]
                                                  .toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                              enabled: false,
                                              initialValue: data[index]
                                                  .materiasPrimas[index]
                                                      ["comprimento"]
                                                  .toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                              enabled: false,
                                              initialValue: data[index]
                                                  .materiasPrimas[index]
                                                      ["largura"]
                                                  .toString(),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: () async {
                                      /*setState(() {
                                          loading = true;
                                        });
                                        await context
                                            .read<EncomendasController>()
                                            .updateEstadoEncomenda(
                                                estado: data.first.estado,
                                                id: data[index].codigo);
                                        setState(() {
                                          loading = false;
                                        });
                                        Get.snackbar(
                                          "Encomenda Alterada",
                                          "O Estado da Encomenda foi alterado",
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
                                        );*/
                                    },
                                    icon: Icon(Icons.save),
                                    label: Row(
                                      children: [
                                        Text("Salvar Alterações"),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          child: loading
                                              ? progressIndicator()
                                              : SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(Icons.close),
                                    label: Text("Fechar"),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subtotal: ${data[index].subtotal}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text("Iva:  ${data[index].iva! * 100}%",
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Taxa:  ${data[index].margemLucro! * 100}%",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Sinal:  ${data[index].sinal}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Total:  ${data[index].total}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Valor a Pagar: ${data[index].valorPagar}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );*/
              },
            ),
            SizedBox(
              width: 6,
            ),
            IconButton(
              tooltip: "Excluir ",
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                /*Get.defaultDialog(
                  radius: 5,
                  title: "Excluir ?",
                  middleText: "Deseja Excluir a Encomenda ?",
                  confirm: ElevatedButton.icon(
                    onPressed: () async {
                      await context
                          .read<EncomendasController>()
                          .deleteEncomenda(data[index].codigo ?? '0');
                      onTap();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    icon: Icon(Icons.check),
                    label: Text("Sim"),
                  ),
                  cancel: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    icon: Icon(Icons.close),
                    label: Text("Não"),
                  ),
                );*/
              },
            ),
            /* <   IconButton(
                tooltip: "Imprimir Encomenda",
                onPressed: () {},
                icon: Icon(
                  Icons.print,
                  color: Colors.yellow[900],
                ))> */
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

class Encomendas {
  Encomendas({
    this.produtos,
    this.margemLucro,
    this.total,
    this.sinal,
    this.iva,
    this.codigo,
    this.subtotal,
    this.estado,
    this.idCliente,
    this.valorPagar,
    required this.materiasPrimas,
  });

  List materiasPrimas;
  String? codigo;
  String? estado;
  String? idCliente;
  List? produtos;
  double? total;
  double? subtotal;
  double? sinal;
  double? iva;
  double? margemLucro;
  double? valorPagar;
}
