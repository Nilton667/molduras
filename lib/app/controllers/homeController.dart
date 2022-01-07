import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:molduras/app/util/global.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  late TabController tabController;
  bool isMenuVisible = true;

  void init() async {
    tabController = TabController(vsync: this, length: 5, initialIndex: 0);

    var box = await Hive.openBox('aphit_user');

    userData = [
      {
        'nome': box.get('nome'),
        'sobrenome': box.get('sobrenome'),
        'email': box.get('email'),
      }
    ];

    if (Platform.isAndroid || Platform.isIOS) {
      isMenuVisible = false;
    }
    update();
    /*WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<ClientesController>().cleanClientes();
      context.read<ClientesController>().getClientes();
      context.read<MateriaPrimaController>().getProdutos();
      context.read<ProdutosController>().getProdutos();
    });*/
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class SalesDatas {
  SalesDatas(this.year, this.sales, this.sale2);
  final year;
  final sales;
  final sale2;
}
