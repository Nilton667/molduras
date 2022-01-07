import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart' as parse;
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:molduras/app/models/widget.dart';
import 'package:molduras/app/views/home.dart';
import 'package:molduras/app/views/login.dart';
import './theme_config.dart';

//Global String / array
//final host = 'http://127.0.0.1:8000/api/';
final host = 'https://molduras.aphit.cloud/api/';
//const host = 'http://10.0.2.2:8000/api/';
const permitame = 'oratoriam';
List userData = [
  {
    'nome': 'n/a',
    'sobrenome': 'n/a',
    'email': 'n/a',
  }
];

//Funções Globais
//Login
void setUserData(dynamic userData) async {
  //UserData
  var box = await Hive.openBox('aphit_user');
  box.put('login', userData[0]['id']);
  box.put('nome', userData[0]['nome']);
  box.put('sobrenome', userData[0]['sobrenome']);
  box.put('email', userData[0]['email']);
  box.put('telemovel', userData[0]['telemovel']);
  box.put('genero', userData[0]['genero']);
  box.put('morada', userData[0]['morada']);
  //box.put('token', userData[1]['token']);
  Get.offAll(Home());
}

//Terminar sessão
void loginOff() async {
  bool confirm = false;

  await Get.defaultDialog(
    confirmTextColor: Colors.white,
    title: 'Atenção',
    content: const Text(
      'Pretende mesmo terminar a sessão?',
      style: TextStyle(fontSize: 14.0),
      textAlign: TextAlign.center,
    ),
    textConfirm: 'Sim',
    buttonColor: themeData.themeColor,
    onConfirm: () async {
      Get.back();
      var box = await Hive.openBox('aphit_user');
      box.delete('login');
      box.delete('nome');
      box.delete('sobrenome');
      box.delete('email');
      box.delete('telemovel');
      box.delete('genero');
      box.delete('morada');
      //box.delete('token');
      Get.offAll(LoginScreen());
    },
    textCancel: 'Não',
    cancelTextColor: Colors.black87,
  );

  if (confirm == false) {
    return;
  }
}

//Toast
void showToast(String msg, context,
    {final duration, final gravity, final background}) {
  //danger -> red
  //default -> black
  //success -> green
  return FlutterToastr.show(
    msg,
    context,
    duration: duration ?? FlutterToastr.lengthShort,
    position: gravity ?? FlutterToastr.center,
    backgroundColor: background == null
        ? Colors.black38
        : background == 'danger'
            ? Colors.red
            : background == 'success'
                ? Colors.green
                : Colors.black38,
    textStyle: TextStyle(
      fontSize: 15.0,
      color: Colors.white,
    ),
  );
}

//Loading
void customLoading(dynamic context) {
  Dialog dialog = Dialog(
    elevation: 3.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        themeData.themeColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Aguarde...',
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => dialog,
  );
}

//Progress indicator
CircularProgressIndicator progressIndicator() {
  return CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation<Color>(
      themeData.themeColor,
    ),
  );
}

//Urllaucher - Custom tab
void launchURL(String url) async {
  try {
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.system,
        toolbarColor: themeData.themeColor,
        secondaryToolbarColor: Colors.grey,
        navigationBarColor: Colors.white,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.white,
        preferredControlTintColor: Colors.grey,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  } catch (e) {
    print(e.toString());
  }
}

//Remover tags html
String parseHtmlString(String htmlString) {
  final document = parse.parse(htmlString);
  final String parsedString =
      parse.parse(document.body!.text).documentElement!.text;

  return parsedString;
}

//Ler tags html
Widget getHtml(String htmlString) {
  return Html(data: htmlString);
}

//Number Format
String numberFormat(String number) {
  var conversor = NumberFormat("#,##0.00", "pt");

  if (int.parse(number.trim()) is int) {
    int format = int.parse(number.trim());
    return conversor.format(format).toString() + ' AOA';
  } else {
    return conversor.format(0).toString() + ' AOA';
  }
}
