class Contato {
  final int id;
  final String nome;
  final String telefone;

  Contato({required this.id, required this.nome, required this.telefone});

  factory Contato.fromJson(Map<String, dynamic> json) =>
      Contato(id: json['id'], nome: json['nome'], telefone: json['telefone']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'telefone': telefone,
  };
}
