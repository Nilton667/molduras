import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:molduras/app/util/global.dart';

class userTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabControllerUser;
  List clientes = [];
  int rowsPerPage = 5;
  late ScrollController scrollController;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController nome = TextEditingController();
  TextEditingController morada = TextEditingController();
  TextEditingController localidade = TextEditingController();
  TextEditingController contribuinti = TextEditingController();
  TextEditingController telemovel = TextEditingController();

  void clearForm() {
    nome.clear();
    morada.clear();
    localidade.clear();
    contribuinti.clear();
    telemovel.clear();
  }

  //Registar Cliente
  submitData(context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "add/cliente"), body: {
        'nome': nome.text.trim(),
        'morada': morada.text.trim(),
        'contribuinti': contribuinti.text.trim(),
        'localidade': localidade.text.trim(),
        'telemovel': telemovel.text.trim(),
        'permission': permitame,
      });

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody > 0) {
          SuccessAlertBox(
            context: context,
            title: "O cliente foi registado com sucesso!",
            messageText: '',
            buttonText: 'Confirmar',
          );
          clearForm();
          return;
        } else if (resBody is int && resBody == 0) {
          DangerAlertBox(
            context: context,
            title: "Não foi possível registar o cliente!",
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
    this.getData(context);
  }

  //Get Cliente
  void getData(context) async {
    clientes.clear();
    isLoading = true;
    update();
    try {
      var res = await http.post(
        Uri.parse(host + "get/cliente"),
        body: {
          'permission': permitame,
        },
      );

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is List) {
          clientes = resBody;
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

  //Eliminar Cliente
  void removeCliente(context, id) async {
    isLoading = true;
    update();
    try {
      var res = await http.post(
        Uri.parse(host + "remove/cliente"),
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
            "O Cliente foi Excluído",
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

  //Editar Cliente
  void editCliente(
      context, id, nome, morada, localidade, contribuinti, telemovel) async {
    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "edit/cliente"), body: {
        'id': id.toString(),
        'nome': nome.trim(),
        'morada': morada.trim(),
        'contribuinti': contribuinti.trim(),
        'localidade': localidade.trim(),
        'telemovel': telemovel.trim(),
        'permission': permitame,
      });

      isLoading = false;
      update();

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is int && resBody > 0) {
          Get.snackbar(
            "Dados Atualizado",
            "O cliente foi atualizado com sucesso",
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
            title: "Não foi possível alterar os dados do cliente!",
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
}
