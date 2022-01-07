import 'package:get/get.dart';
import '../models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/material.dart';

class MateriaPrimaController extends GetxController {
  List produtoStore = [];

  List<Map<String, dynamic>> materiasPrimaDataSource = [];

  List get getMateriasPrimas {
    List materiasPrimas = [];
    _widgets.forEach((key, value) {
      materiasPrimas.add(value);
    });
    return materiasPrimas;
  }

  List get materiasPrimas => _materiasPrimas;

  double get gettotalMateriasPrimas {
    double total = 43;
    print(materiasPrimaDataSource);
    return total;
  }

  Map<String, Widget> _widgets = {};
  List<String> _materiasPrimas = [];
  double totalMateriasPrimas = 0;

  addMateriaPrima({
    String? produto,
    double? precoVenda,
    int? quantidade,
    double? comprimento,
    double? largura,
    String? unidade,
    double? metrosLineares,
    double? metrosQuadrados,
    String? id,
  }) {
    _materiasPrimas.add(produto!);

    materiasPrimaDataSource.add(
      {
        "mtId": id,
        "MateriaPrima": produto,
        "pvp": precoVenda,
        "quantidade": quantidade,
        "comprimento": comprimento,
        "largura": largura,
      },
    );
    //totalMateriasPrimas += precoVenda * quantidade;

    if (_widgets.containsKey(produto)) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.red.shade800,
          duration: Duration(seconds: 2),
          mainButton: InkWell(
            onTap: () {
              Get.back();
            },
            child: Text("OK"),
          ),
          title: "Produto Duplicado",
          message: "O Produto já foi adicionado à lista",
        ),
      );
      return;
    }
    _widgets.addAll(
      {
        produto: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          color: Colors.grey.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text("Matéria Prima: $produto")),
              Expanded(flex: 2, child: Text("Preco:$precoVenda")),
              Expanded(flex: 2, child: Text("Quantidades: $quantidade")),
              Expanded(
                  flex: 2, child: Text("total: ${precoVenda! * quantidade!}")),
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _widgets.remove(produto);
                    totalMateriasPrimas =
                        totalMateriasPrimas - (precoVenda * quantidade);
                    update();
                  },
                ),
              ),
            ],
          ),
        )
      },
    );
    Get.back();
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green.shade800,
      duration: Duration(seconds: 2),
      mainButton: InkWell(
          onTap: () {
            Get.back();
          },
          child: Text("OK")),
      message: "Matéria Prima  adicionada",
    ));
    update();
  }

  Map<String, MateriaPrima> dataSource = {};

  List get produtos {
    List data = [];
    data.clear();
    dataSource.forEach((key, value) {
      data.add(value);
    });
    return data;
  }

  Future addProduto({
    String? descricao,
    double? pmc,
    double? pmv,
    int? quantidade,
    double? comprimento,
    double? largura,
    int? unidade,
  }) async {
    final produto = ParseObject("MateriasPrimas")
      ..set("descricao", descricao)
      ..set("pmc", pmc)
      ..set("pmv", pmv)
      ..set("comprimento", comprimento)
      ..set("largura", largura)
      ..set("unidade", unidade)
      ..set("quantidade", quantidade);
    final response = await produto.save();

    produtoStore.insert(0, response.result);
    update();
    return response;
  }

  Future updateProdutos({
    bool? composto,
    String? descricao,
    double? pmc,
    double? pmv,
    int? quantidade,
    String? id,
  }) async {
    final produto = ParseObject("MateriasPrimas")
      ..objectId = id
      ..set("descricao", descricao)
      ..set("pmc", pmc)
      ..set("pmv", pmv)
      ..set("quantidade", quantidade);
    final response = await produto.save();
    return response;
  }

  Future getProdutos() async {
    final produtos = await ParseObject("MateriasPrimas").getAll();
    update();
    for (var produto in produtos.results ?? []) {
      print(produto["descricao"]);
      dataSource.addAll({
        produto["objectId"]: MateriaPrima(
          comprimento: double.parse(produto["comprimento"].toString()),
          largura: double.parse(produto["largura"].toString()),
          descricao: produto["descricao"],
          pmc: produto["pmc"].toString(),
          pvp: produto["pmv"].toString(),
          objectId: produto["objectId"].toString(),
          quantidade: produto["quantidade"],
          unidade: produto["unidade"],
        )
      });
    }
    //print(dataSource);
    return produtos.result;
  }

  Future searchMateriaPrima({String? descricao}) async {
    final produtos = ParseObject("MateriasPrimas");
    final query = QueryBuilder<ParseObject>(produtos)
      ..whereStartsWith("descricao", descricao!);
    final response = await query.query();
    return response.results;
  }

  Future deleteMateriaPrima(String id) async {
    final cliente = ParseObject('MateriasPrimas')..objectId = id;
    final response = await cliente.delete();
    dataSource.remove(id);
    update();
    return response;
  }

  cleanProdutos() {
    print(dataSource);

    update();
  }
}
