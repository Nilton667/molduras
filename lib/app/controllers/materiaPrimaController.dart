import 'dart:convert';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:molduras/app/util/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MateriaPrimaController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List produtoStore = [];

  List<Map<String, dynamic>> materiasPrimaDataSource = [];
  late TabController tabControllerUser;
  int rowsPerPage = 5;
  bool isLoading = false;
  TextEditingController descricao = TextEditingController();
  TextEditingController pmc = TextEditingController();
  TextEditingController pvp = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  TextEditingController comprimento = TextEditingController();
  TextEditingController largura = TextEditingController();
  int unidade = 1;
  String labelTipoUnidade = "Selecione a Unidade";
  final formKey = GlobalKey<FormState>();
  bool composto = false;
  late ScrollController scrollController;
  List produtos = [];

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
    this.getData(context);
  }

  //Registar MateriaPrima
  submitData(context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "add/materiaprima"), body: {
        'quantidade': quantidade.text.trim(),
        'comprimento': comprimento.text.trim(),
        'largura': largura.text.trim(),
        'descricao': descricao.text.trim(),
        'unidade': unidade.toString(),
        'pmc': pmc.text.trim(),
        'pvp': pvp.text.trim(),
        'permission': permitame,
      });

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody > 0) {
          quantidade.text = '';
          comprimento.text = '';
          largura.text = '';
          descricao.text = '';
          pmc.text = '';
          pvp.text = '';
          SuccessAlertBox(
            context: context,
            title: "A matéria prima foi registada com sucesso!",
            messageText: '',
            buttonText: 'Confirmar',
          );

          return;
        } else if (resBody is int && resBody == 0) {
          DangerAlertBox(
            context: context,
            title: "Não foi possível registar a matéria prima!",
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

  //Get Materia Prima
  void getData(context) async {
    produtos.clear();

    isLoading = true;
    update();

    try {
      var res = await http.post(
        Uri.parse(host + "get/materiaprima"),
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

  //Eliminar Materia Prima
  void removeMateriaPrima(context, id) async {
    isLoading = true;
    update();
    try {
      var res = await http.post(
        Uri.parse(host + "remove/materiaprima"),
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
            "A máteria prima foi Excluída",
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
  void editMateriaPrima(
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
      var res = await http.post(Uri.parse(host + "edit/materiaprima"), body: {
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
            "A máteria prima foi atualizada com sucesso",
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
            title: "Não foi possível alterar os dados da máteria prima!",
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

///////////////////////////////

  Future searchMateriaPrima({String? descricao}) async {
    /*final produtos = ParseObject("MateriasPrimas");
    final query = QueryBuilder<ParseObject>(produtos)
      ..whereStartsWith("descricao", descricao!);
    final response = await query.query();
    return response.results;*/
    return '';
  }
}
