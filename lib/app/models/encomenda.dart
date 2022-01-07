class Encomenda {
  Encomenda({
    this.produto,
    this.largura,
    this.comprimento,
    this.quantidade = 1,
    this.preco,
    this.total = 0,
    this.precoDeVenda,
    this.observacoes,
    this.personalizado = false,
    this.materiasPrimas,
  });
  final String? produto;
  final double? total;
  final double? preco;
  final int? quantidade;
  final double? comprimento;
  final double? largura;
  final double? precoDeVenda;
  bool? personalizado;
  List? materiasPrimas;

  final String? observacoes;
}
