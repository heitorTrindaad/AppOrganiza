class MetaSonhoModel {
  final int? id;
  final String nomeSonho;
  final double valorAlvo;
  final double valorPoupado; // Saldo atual dentro deste cofrinho
  final String? caminhoImagem; // Caminho do arquivo de foto local no celular
  final DateTime? dataLimite;

  MetaSonhoModel({
    this.id,
    required this.nomeSonho,
    required this.valorAlvo,
    this.valorPoupado = 0.0,
    this.caminhoImagem,
    this.dataLimite,
  });

  // Calcula a porcentagem de conclusão do sonho (útil para a barra de progresso na UI)
  double get progresso {
    if (valorAlvo <= 0) return 0.0;
    final resultado = valorPoupado / valorAlvo;
    return resultado > 1.0 ? 1.0 : resultado; // Limita em 100% (1.0)
  }

  // Converte para o SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_sonho': nomeSonho,
      'valor_alvo': valorAlvo,
      'valor_poupado': valorPoupado,
      'caminho_imagem': caminhoImagem,
      'data_limite': dataLimite?.toIso8601String(),
    };
  }

  // Converte do SQLite para Dart
  factory MetaSonhoModel.fromMap(Map<String, dynamic> map) {
    return MetaSonhoModel(
      id: map['id'] as int?,
      nomeSonho: map['nome_sonho'] as String,
      valorAlvo: map['valor_alvo'] as double,
      valorPoupado: map['valor_poupado'] as double,
      caminhoImagem: map['caminho_imagem'] as String?,
      dataLimite: map['data_limite'] != null
          ? DateTime.parse(map['data_limite'] as String)
          : null,
    );
  }
}