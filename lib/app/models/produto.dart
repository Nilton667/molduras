class Produto {
  int? quantidade;
  String? descricao;
  int? pvp;
  bool? composto;
  int? pmc;
  int? idProduto;
  int? pmv;

  Produto({
    this.quantidade,
    this.descricao,
    this.pvp,
    this.composto,
    this.pmc,
    this.idProduto,
    this.pmv,
  });

  Produto.fromJson(Map<String, dynamic> json) {
    quantidade = json['quantidade'];
    descricao = json['descricao'];
    pvp = json['pvp'];
    composto = json['composto'];
    pmc = json['pmc'];
    idProduto = json['idProduto'];
    pmv = json['pmv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantidade'] = this.quantidade;
    data['descricao'] = this.descricao;
    data['pvp'] = this.pvp;
    data['composto'] = this.composto;
    data['pmc'] = this.pmc;
    data['idProduto'] = this.idProduto;
    data['pmv'] = this.pmv;
    return data;
  }
}
