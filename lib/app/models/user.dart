class Usuario {
  Usuario({
    this.codigo,
    this.nome,
    this.email,
    this.telefone,
    this.endereco,
  });
  final int? codigo;
  final String? nome;
  final String? email;
  final String? telefone;
  final String? endereco;
}

class Cliente {
  Cliente({
    this.codigo,
    this.nome,
    this.contribuinti,
    this.telefone,
    this.morada,
    this.localidade,
    this.objectId,
  });
  final int? codigo;
  final String? objectId;
  final String? nome;
  final String? contribuinti;
  final String? telefone;
  final String? morada;
  final String? localidade;
}

class Produtos {
  Produtos({
    this.codigo,
    this.pmc,
    this.pvp,
    this.composto,
    this.descricao,
    this.objectId,
    this.quantidade,
    this.unidades,
  });

  final String? objectId;
  final String? pvp;
  final String? unidades;
  final int? quantidade;
  final bool? composto;
  final String? pmc;
  final String? descricao;
  final int? codigo;
}

class MateriaPrima {
  MateriaPrima({
    this.codigo,
    this.pmc,
    this.pvp,
    this.descricao,
    this.objectId,
    this.quantidade,
    this.comprimento,
    this.largura,
    this.unidade,
  });
  final int? unidade;
  final String? objectId;
  final String? pvp;
  final int? quantidade;
  final String? pmc;
  final String? descricao;
  final int? codigo;
  final double? comprimento;
  final double? largura;
}
