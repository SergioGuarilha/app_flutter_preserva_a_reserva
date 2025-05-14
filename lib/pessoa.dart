class Pessoa {
  final String nome;
  final int idade;

  Pessoa(this.nome, this.idade);

  // Convert Pessoa to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'idade': idade,
    };
  }

  // Create Pessoa from JSON (Map)
  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      json['nome'] as String,
      json['idade'] as int,
    );
  }
}