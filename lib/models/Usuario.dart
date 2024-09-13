class Usuario {
  String nome;
  String telefone;
  String email;
  String senha;
  String? imagem;
  Endereco? endereco;
  List<Consulta> consultas;
  List<Prontuario> prontuarios;
  List<Exame> exames;

  Usuario({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    this.imagem,
    this.endereco,
    this.consultas = const [],
    this.prontuarios = const [],
    this.exames = const [],
  });
}

class Endereco {
  String rua;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;

  Endereco({
    required this.rua,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });
}

class Consulta {
  DateTime data;
  String descricao;
  String medico;
  String notas;

  Consulta({
    required this.data,
    required this.descricao,
    required this.medico,
    required this.notas,
  });
}

class Prontuario {
  DateTime data;
  String descricao;
  String medico;
  String diagnostico;
  List<Tratamento> tratamentos;
  List<Prescricao> prescricoes;
  List<Anexo> anexos;
  String notasAdicionais;

  Prontuario({
    required this.data,
    required this.descricao,
    required this.medico,
    required this.diagnostico,
    required this.tratamentos,
    required this.prescricoes,
    required this.anexos,
    required this.notasAdicionais,
  });
}

class Tratamento {
  String descricao;
  DateTime data;

  Tratamento({
    required this.descricao,
    required this.data,
  });
}

class Prescricao {
  String medicamento;
  String dose;
  String frequencia;

  Prescricao({
    required this.medicamento,
    required this.dose,
    required this.frequencia,
  });
}

class Anexo {
  String url;
  String tipo;
  String descricao;

  Anexo({
    required this.url,
    required this.tipo,
    required this.descricao,
  });
}

class Exame {
  String tipo;
  DateTime data;
  String resultados;
  String solicitacao;
  String medicoSolicitante;

  Exame({
    required this.tipo,
    required this.data,
    required this.resultados,
    required this.solicitacao,
    required this.medicoSolicitante,
  });
}
