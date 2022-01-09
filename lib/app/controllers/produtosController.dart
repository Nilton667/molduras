import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:molduras/app/controllers/materiaPrimaController.dart';
import 'package:molduras/app/util/global.dart';
import '../models/user.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:http/http.dart' as http;

class ProdutosController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List produtoStore = [];

  Map<String, Produtos> dataSource = {};

  late TabController tabControllerUser;
  int rowsPerPage = 5;
  bool isLoading = false;
  TextEditingController descricao = TextEditingController();
  TextEditingController pmc = TextEditingController();
  TextEditingController pvp = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool composto = false;
  ScrollController? scrollController;
  List produtos = [];
  String labelTipoProduto = "Selecione o tipo de Produto";
  String labelUnidade = "Unidade";

  bool isProductoComposto = false;
  bool isMetrosLineares = false;
  // FORMULARIOS DE MATERIAS PRIMAS
  TextEditingController materiaPrima = TextEditingController();
  TextEditingController preco = TextEditingController();
  int quantidades = 0;

  TextEditingController mtComprimento = TextEditingController();
  TextEditingController mtLargura = TextEditingController();
  TextEditingController mtId = TextEditingController();

  // Calculo Metros Lineares
  TextEditingController comprimento = TextEditingController();
  TextEditingController largura = TextEditingController();
  TextEditingController metrosQuadrados = TextEditingController();
  final inputStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);
  final mtFormKey = GlobalKey<FormState>();

  //Init
  int tabIinitialized = 0;
  void init(context) {
    if (tabIinitialized == 0) {
      tabControllerUser = TabController(
        length: 2,
        vsync: this,
        initialIndex: 0,
      );
      tabIinitialized = 1;
    }

    scrollController = ScrollController();
    if (!Get.put(MateriaPrimaController()).initialized) {
      Get.put(MateriaPrimaController()).init(context);
    }
    getData(context);
  }

  //Registar Produto
  submitData(context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "add/produto"), body: {
        'composto': isProductoComposto.toString(),
        'descricao': descricao.text.trim(),
        'quantidade': quantidade.text.trim(),
        'comprimento': comprimento.text.trim(),
        'largura': largura.text.trim(),
        'unidade': labelUnidade,
        'pmc': pmc.text.trim(),
        'pvp': pvp.text.trim(),
        'materiasPrimas': '',
        'permission': permitame,
      });

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody > 0) {
          SuccessAlertBox(
            context: context,
            title: "O produto foi registado com sucesso!",
            messageText: '',
            buttonText: 'Confirmar',
          );
          cleanProdutos();
          return;
        } else if (resBody is int && resBody == 0) {
          DangerAlertBox(
            context: context,
            title: "Não foi possível registar o produto!",
            messageText: '',
            buttonText: 'Confirmar',
          );
        } else {
          DangerAlertBox(
            context: context,
            title: resBody.toString(),
            messageText: '',
            buttonText: 'Confirmar',
          );
        }
      } else {
        DangerAlertBox(
          context: context,
          title: "Verifique a sua conexão ou tente novamente!",
          messageText: '',
          buttonText: 'Confirmar',
        );
      }
    } catch (e) {
      print(e.toString());
      DangerAlertBox(
        context: context,
        title: "Verifique a sua conexão ou tente novamente mais tarde!",
        messageText: '',
        buttonText: 'Confirmar',
      );
    }

    isLoading = false;
    update();
  }

  //Get produto
  void getData(context) async {
    produtos.clear();

    isLoading = true;
    update();

    try {
      var res = await http.post(
        Uri.parse(host + "get/produto"),
        body: {
          'permission': permitame,
        },
      );

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is List) {
          produtos = resBody;
        }
      } else {
        showToast(
          "Verifique a sua conexão ou tente novamente!",
          context,
          background: 'danger',
        );
      }
    } catch (e) {
      showToast(e.toString(), context);
    }
    isLoading = false;
    update();
  }

  //Eliminar Produto
  void removeProduto(context, id) async {
    isLoading = true;
    update();
    try {
      var res = await http.post(
        Uri.parse(host + "remove/produto"),
        body: {
          'id': id.toString(),
          'permission': permitame,
        },
      );

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody == 1) {
          Get.snackbar(
            "Notificação",
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
          getData(context);
        }
      } else {
        isLoading = false;
        showToast(
          "Verifique a sua conexão ou tente novamente2!",
          context,
          duration: FlutterToastr.lengthLong,
          background: 'danger',
        );
      }
    } catch (e) {
      isLoading = false;
      showToast(
        e.toString(),
        context,
        duration: FlutterToastr.lengthLong,
      );
    }
    update();
  }

  //Editar Materia prima
  final editFormKey = GlobalKey<FormState>();
  void editProduto(
    context,
    id,
    descricao,
    quantidade,
    pmc,
    pmv,
  ) async {
    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "edit/produto"), body: {
        'id': id.toString(),
        'descricao': descricao.trim(),
        'quantidade': quantidade.toString().trim(),
        'pmc': pmc.toString().trim(),
        'pvp': pmv.toString().trim(),
        'permission': permitame,
      });

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody > 0) {
          Get.snackbar(
            "Dados Atualizado",
            "A Produto foi atualizado com sucesso",
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
          getData(context);
          return;
        } else if (resBody is int && resBody == 0) {
          DangerAlertBox(
            context: context,
            title: "Não foi possível alterar os dados do produto!",
            messageText: '',
            buttonText: 'Confirmar',
          );
        } else {
          DangerAlertBox(
            context: context,
            title: resBody.toString(),
            messageText: '',
            buttonText: 'Confirmar',
          );
        }
      } else {
        DangerAlertBox(
          context: context,
          title: "Verifique a sua conexão ou tente novamente!",
          messageText: '',
          buttonText: 'Confirmar',
        );
      }
    } catch (e) {
      print(e.toString());
      DangerAlertBox(
        context: context,
        title: "Verifique a sua conexão ou tente novamente mais tarde!",
        messageText: '',
        buttonText: 'Confirmar',
      );
    }

    isLoading = false;
    update();
  }
  /////////////////////

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
          quantidade: produto["quantidade"],
        )
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
    pmc.clear();
    descricao.clear();
    quantidade.clear();
    pvp.clear();
    comprimento.clear();
    largura.clear();
  }
}
