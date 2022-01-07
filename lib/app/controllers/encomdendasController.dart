import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class EncomendasController extends GetxController {
  List _encomendas = [];
  List get encomendas => _encomendas;

  Future<ParseResponse> addEncomendas({
    List? materiasPrimas,
    List? produtos,
    String? idCliente,
    double? total,
    double? subtotal,
    double? sinal,
    double? iva,
    double? margemLucro,
    double? valorPagar,
  }) async {
    final encomenda = ParseObject("Encomendas")
      ..set("id_cliente", idCliente)
      ..set("total", total)
      ..set("estado", "Nova")
      ..set("taxa", margemLucro)
      ..set("iva", iva)
      ..set("sinal", sinal)
      ..set("subtotal", subtotal)
      ..set("materiasPrimas", materiasPrimas)
      ..set("protudos", produtos)
      ..set("valor_a_pagar", valorPagar);

    final response = await encomenda.save();
    return response;
  }

  Future<List> getEncomendas() async {
    final encomendas = await ParseObject("Encomendas").getAll();
    _encomendas = encomendas.results!;
    return encomendas.results!;
  }

  Future updateEstadoEncomenda({String? estado, String? id}) async {
    final encomenda = ParseObject("Encomendas")
      ..objectId = id
      ..set("estado", estado);
    final response = await encomenda.save();
    return response;
  }

  Future deleteEncomenda(String id) async {
    final encomenda = ParseObject('Encomendas')..objectId = id;
    final response = await encomenda.delete();

    update();
    return response;
  }
}
