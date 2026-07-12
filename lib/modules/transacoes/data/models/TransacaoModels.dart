// Enums para garantir que o código não aceite strings erradas
enum TipoTransacao { ENTRADA, SAIDA }

enum EstadoEmocional { feliz, triste, ansioso, estressado }

class TransacaoModel {
  final int? id; // Null quando estamos criando uma nova transação antes de salvar
  final double valor;
  final TipoTransacao tipo;
  final String categoria;
  final String? descricao;
  final DateTime dataRegistro;
  final EstadoEmocional? estadoEmocional; // Pode ser null (obrigatório apenas em saídas se o usuário quiser)
  final int? metaId; // ID da meta/cofrinho vinculado, se houver

  TransacaoModel({
    this.id,
    required this.valor,
    required this.tipo,
    required this.categoria,
    this.descricao,
    required this.dataRegistro,
    this.estadoEmocional,
    this.metaId,
  });

  // Converte o Objeto Dart para o Map que o SQLite exige
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'tipo': tipo.name, // Transforma o Enum em String ('ENTRADA' ou 'SAIDA')
      'categoria': categoria,
      'descricao': descricao,
      'data_registro': dataRegistro.toIso8601String(), // Transforma DateTime em String YYYY-MM-DD...
      'estado_emocional': estadoEmocional?.name, // Salva o nome do enum ou null
      'meta_id': metaId,
    };
  }

  // Converte o Map do SQLite de volta para o Objeto Dart fortemente tipado
  factory TransacaoModel.fromMap(Map<String, dynamic> map) {
    return TransacaoModel(
      id: map['id'] as int?,
      valor: map['valor'] as double,
      tipo: TipoTransacao.values.byName(map['tipo'] as String),
      categoria: map['categoria'] as String,
      descricao: map['descricao'] as String?,
      dataRegistro: DateTime.parse(map['data_registro'] as String),
      estadoEmocional: map['estado_emocional'] != null
          ? EstadoEmocional.values.byName(map['estado_emocional'] as String)
          : null,
      metaId: map['meta_id'] as int?,
    );
  }
}