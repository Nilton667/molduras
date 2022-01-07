import 'package:get/get.dart';
import '../models/user.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProdutosController extends GetxController {
  List produtoStore = [];

  Map<String, Produtos> dataSource = {};

  List get produtos {
    List data = [];
    data.clear();
    dataSource.forEach((key, value) {
      data.add(value);
    });
    return data;
  }

  Future addProduto({
    bool? composto,
    String? descricao,
    double? pmc,
    double? pmv,
    int? quantidade,
    String? unidade,
    double? comprimento,
    double? largura,
    List<Map<String, dynamic>>? materiasPrimas,
  }) async {
    final produto = ParseObject("Produtos")
      ..set("composto", composto)
      ..set("descricao", descricao)
      ..set("pmc", pmc)
      ..set("pmv", pmv)
      ..set("unidade", unidade)
      ..set("comprimento", comprimento)
      ..set("largura", largura)
      ..set("materiasPrimas", materiasPrimas)
      ..set("quantidade", quantidade);
    final response = await produto.save();
    print(response.error);
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
    final produto = ParseObject("Produtos")
      ..objectId = id
      ..set("composto", composto)
      ..set("descricao", descricao)
      ..set("pmc", pmc)
      ..set("pmv", pmv)
      ..set("quantidade", quantidade);
    final response = await produto.save();
    return response;
  }

  Future getProdutos() async {
    final produtos = await ParseObject("Produtos").getAll();

    for (var produto in produtos.results ?? []) {
      print(produto["descricao"]);
      dataSource.addAll({
        produto["objectId"]: Produtos(
            composto: produto["composto"],
            descricao: produto["descricao"],
            pmc: produto["pmc"].toString(),
            unidades: produto["unidade"],
            pvp: produto["pmv"].toString(),
            objectId: produto["objectId"].toString(),
            quantidade: produto["quantidade"])
      });
    }
    //print(dataSource);
    return produtos.result;
  }

  Future searchProdutos({String? descricao}) async {
    final produtos = ParseObject("Produtos");
    final query = QueryBuilder<ParseObject>(produtos)
      ..whereContains("descricao", descricao!);
    final response = await query.query();
    return response.result;
  }

  Future deleteProduto(String id) async {
    final cliente = ParseObject('Produtos')..objectId = id;
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
