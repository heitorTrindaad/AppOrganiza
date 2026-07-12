class UsuarioConfigModel {
  final int id; // Sempre será 1
  final double salarioMensal;
  final int horasTrabalhadasMes;
  final double valorHora;

  UsuarioConfigModel({
    this.id = 1,
    required this.salarioMensal,
    required this.horasTrabalhadasMes,
    required this.valorHora,
  });

  // Regra de Negócio: Fábrica para criar o modelo calculando a hora automaticamente
  factory UsuarioConfigModel.calcular({
    required double salarioMensal,
    required int horasTrabalhadasMes,
  }) {
    // Evita divisão por zero caso o usuário digite 0 horas
    final valorCalculado = horasTrabalhadasMes > 0 
        ? salarioMensal / horasTrabalhadasMes 
        : 0.0;

    return UsuarioConfigModel(
      id: 1,
      salarioMensal: salarioMensal,
      horasTrabalhadasMes: horasTrabalhadasMes,
      valorHora: valorCalculado,
    );
  }

  // Converte o Objeto Dart para um Map (JSON/Dicionário) para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'salario_mensal': salarioMensal,
      'horas_trabalhadas_mes': horasTrabalhadasMes,
      'valor_hora': valorHora,
    };
  }

  // Converte o Map que vem do SQLite de volta para um Objeto Dart
  factory UsuarioConfigModel.fromMap(Map<String, dynamic> map) {
    return UsuarioConfigModel(
      id: map['id'] as int,
      salarioMensal: map['salario_mensal'] as double,
      horasTrabalhadasMes: map['horas_trabalhadas_mes'] as int,
      valorHora: map['valor_hora'] as double,
    );
  }
}