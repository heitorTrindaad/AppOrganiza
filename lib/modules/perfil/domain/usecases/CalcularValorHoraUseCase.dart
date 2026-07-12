import '../../data/models/usuario_config_model.dart';
import '../../data/repositories/usuario_config_repository.dart';

class CalcularValorHoraUseCase {
  final UsuarioConfigRepository _repository;

  CalcularValorHoraUseCase(this._repository);

  // Executa a regra de negócio: atualiza ou cria o perfil calculando o valor da hora
  Future<void> executar({required double salario, required int horas}) async {
    if (salario < 0 || horas <= 0) {
      throw Exception('Salário deve ser maior que zero e horas devem ser maiores que zero.');
    }

    // A lógica de divisão já está encapsulada na factory do Model
    final novaConfig = UsuarioConfigModel.calcular(
      salarioMensal: salario,
      horasTrabalhadasMes: horas,
    );

    await _repository.salvarConfiguracao(novaConfig);
  }
}