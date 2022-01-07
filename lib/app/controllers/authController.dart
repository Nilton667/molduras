import 'dart:convert';
import 'dart:io';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:molduras/app/util/global.dart';
import 'package:molduras/app/views/home.dart';
import 'package:path_provider/path_provider.dart';

//Login
class AuthController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = true;

  bool emailValidate(String email) {
    bool isValidEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
    return isValidEmail;
  }

  var isLogged = 0;
  void isUserAuth() async {
    isLoading = true;
    update();
    if (GetPlatform.isWeb == false && !Hive.isBoxOpen('aphit_def')) {
      Directory dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    var box = await Hive.openBox('aphit_user');

    isLogged = box.get('login') is String || box.get('login') is int
        ? int.parse(box.get('login').toString())
        : 0;
    if (isLogged is int && isLogged > 0) {
      Get.offAll(Home());
    }
    isLoading = false;
    update();
  }

  formSubmit(context) async {
    bool isFormValid = formKey.currentState!.validate();
    if (!isFormValid) {
      return;
    }

    isLoading = true;
    update();

    try {
      var res = await http.post(Uri.parse(host + "login"), body: {
        "login": "true",
        "email": email.text.trim(),
        "senha": password.text.trim(),
        "permission": permitame,
      });

      isLoading = false;

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        print(resBody);
        if (resBody is List) {
          email.text = '';
          password.text = '';
          setUserData(resBody);
          return;
        } else if (resBody is int && resBody == 0) {
          showToast(
            "Email ou senha errada!",
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        } else {
          showToast(
            resBody,
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        }
      } else {
        print('not work');
        showToast(
          "Verifique a sua conexão e tente novamente!",
          context,
          duration: FlutterToastr.lengthLong,
          gravity: FlutterToastr.top,
        );
      }
    } catch (e) {
      isLoading = false;
      showToast(
        "Verifique a sua conexão ou tente novamente mais tarde!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
    }
    update();
  }
}

//Cadastro
class RegisterController extends GetxController {
  GlobalKey<FormState> formKeySingUp = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nome = TextEditingController();
  TextEditingController sobrenome = TextEditingController();

  bool isPasswordVisible = true;
  bool isRegisterLoading = false;

  bool emailValidate(String email) {
    bool isValidEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
    return isValidEmail;
  }

  singUp(context) async {
    bool isFormValid = formKeySingUp.currentState!.validate();
    if (!isFormValid) {
      return;
    }

    isRegisterLoading = true;
    update();

    try {
      var res = await http.post(
        Uri.parse(host + "cadastro"),
        body: {
          "login": "true",
          "nome": nome.text.trim(),
          "sobrenome": sobrenome.text.trim(),
          "email": email.text.trim(),
          "senha": password.text.trim(),
          "permission": permitame,
        },
      );

      isRegisterLoading = false;

      if (res.statusCode == 200) {
        print(res.body);
        var resBody = json.decode(res.body);

        if (resBody is List) {
          email.text = '';
          password.text = '';
          nome.text = '';
          sobrenome.text = '';
          setUserData(resBody);
          return;
        } else if (resBody is int && resBody == 0) {
          showToast(
            "Não foi possível registar o usuário!",
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        } else {
          showToast(
            resBody,
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        }
      } else {
        showToast(
          "Verifique a sua conexão e tente novamente!",
          context,
          duration: FlutterToastr.lengthLong,
          gravity: FlutterToastr.top,
        );
      }
    } catch (e) {
      isRegisterLoading = false;
      showToast(
        "Verifique a sua conexão ou tente novamente mais tarde!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
    }
    update();
  }
}

//Recover
class RecoverController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey();
  int confirm = 0;
  TextEditingController email = TextEditingController();
  TextEditingController confirmAccount = TextEditingController();

  //Senha
  TextEditingController keySenha = TextEditingController();
  TextEditingController keyConfirm = TextEditingController();

  bool isLoading = false;

  void recover(context) async {
    if (GetUtils.isEmail(email.text.trim()) == false) {
      showToast(
        "Insira um endereço de email valido!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
      return;
    }

    if (!isLoading) {
      customLoading(context);
      isLoading = true;
    }

    try {
      var res = await http.post(Uri.parse(host + "login"), body: {
        "recover": "true",
        "email": email.text.trim(),
        "permission": permitame,
      });

      if (isLoading) {
        Get.back();
        isLoading = false;
      }

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);

        if (resBody is List) {
          confirm = 1;
          update();
        } else if (resBody == 0) {
          showToast(
            "A sua conta não foi encontrada!",
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        } else {
          showToast(
            resBody,
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        }
      } else {
        showToast(
          "Verifique a sua conexão e tente novamente!",
          context,
          duration: FlutterToastr.lengthLong,
          gravity: FlutterToastr.top,
        );
      }
    } catch (e) {
      if (isLoading) {
        Get.back();
        isLoading = false;
      }
      showToast(
        "Verifique a sua conexão ou tente novamente mais tarde!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
    }
  }

  Future confirmCashe(context) async {
    if (confirmAccount.text.trim() == '') {
      showToast(
        'Insira o código enviado para o seu endereço de email!',
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
      return;
    }

    if (!isLoading) {
      customLoading(context);
      isLoading = true;
    }

    try {
      var res = await http.post(Uri.parse(host + "login"), body: {
        "recoverkey": "true",
        "email": email.text.trim(),
        "cashe": confirmAccount.text.trim(),
        "permission": permitame,
      });

      if (isLoading) {
        Get.back();
        isLoading = false;
      }

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is List) {
          //Get.to(UpdatePassword());
        } else if (resBody == 0) {
          showToast(
            "Código inválido!",
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        } else {
          showToast(
            resBody,
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        }
      } else {
        showToast(
          "Verifique a sua conexão e tente novamente!",
          context,
          duration: FlutterToastr.lengthLong,
          gravity: FlutterToastr.top,
        );
      }
    } catch (e) {
      if (isLoading) {
        Get.back();
        isLoading = false;
      }
      showToast(
        "Verifique a sua conexão ou tente novamente mais tarde!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
    }
  }

  Future updatePass(context) async {
    if (keySenha.text.trim().length < 6) {
      showToast(
        'A senha deve ter no mínimo 6 caracteres!',
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
      return;
    } else if (keySenha.text.trim() != keyConfirm.text.trim()) {
      showToast(
        'As senhas não combinam!',
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
      return;
    }

    if (!isLoading) {
      customLoading(context);
      isLoading = true;
    }

    try {
      var res = await http.post(Uri.parse(host + "login"), body: {
        "recoverpass": "true",
        "email": email.text.trim(),
        "cashe": confirmAccount.text.trim(),
        "senha": keySenha.text.trim(),
        "permission": permitame,
      });

      if (isLoading) {
        Get.back();
        isLoading = false;
      }

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if (resBody is List) {
          confirm = 0;
          email.text = '';
          confirmAccount.text = '';
          keySenha.text = '';
          keyConfirm.text = '';
          setUserData(resBody);
        } else if (resBody == 0) {
          showToast(
            "Usuário não encontrado!",
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        } else {
          showToast(
            resBody,
            context,
            duration: FlutterToastr.lengthLong,
            gravity: FlutterToastr.top,
          );
        }
      } else {
        showToast(
          "Verifique a sua conexão e tente novamente!",
          context,
          duration: FlutterToastr.lengthLong,
          gravity: FlutterToastr.top,
        );
      }
    } catch (e) {
      if (isLoading) {
        Get.back();
        isLoading = false;
      }
      showToast(
        "Verifique a sua conexão ou tente novamente mais tarde!",
        context,
        duration: FlutterToastr.lengthLong,
        gravity: FlutterToastr.top,
      );
    }
  }

  void recoverReturn() {
    confirm = 0;
    email.text = '';
    confirmAccount.text = '';
    keySenha.text = '';
    keyConfirm.text = '';
    update();
  }

  void recoverExit() {
    confirm = 0;
    email.text = '';
    confirmAccount.text = '';
    keySenha.text = '';
    keyConfirm.text = '';
    //Get.offAll(MyApp());
  }
}
