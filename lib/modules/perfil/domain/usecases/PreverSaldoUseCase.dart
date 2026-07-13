import '../../data/repositories/TransacaoRepositories.dart';

class PrevisaoResultado {
  final double saldoEmTresMeses;
  final double saldoEmUmAno;

  PrevisaoResultado({required this.saldoEmTresMeses, required this.saldoEmUmAno});
}

class PreverSaldoFuturoUseCase {
  final TransacaoRepository _repository;

  PreverSaldoFuturoUseCase(this._repository);

  Future<PrevisaoResultado> executar() async {
    final saldoAtual = await _repository.obterSaldoGeral();
    final todas = await _repository.obterTodas();

    // Calcular a média de poupança mensal (Entradas - Saídas)
    // Para simplificar o MVP, pegaremos o histórico total acumulado
    double totalEntradas = 0;
    double totalSaidas = 0;

    for (var t in todas) {
      if (t.tipo == TipoTransacao.ENTRADA) {
        totalEntradas += t.valor;
      } else {
        totalSaidas += t.valor;
      }
    }

    // Se o app acabou de começar, assume que a constância é zero
    double taxaPoupancaMensal = totalEntradas - totalSaidas;

    // Projeta o futuro somando o saldo atual com a projeção multiplicada pelos meses
    double emTresMeses = saldoAtual + (taxaPoupancaMensal * 3);
    double emUmAno = saldoAtual + (taxaPoupancaMensal * 12);

    return PrevisaoResultado(
      saldoEmTresMeses: emTresMeses,
      saldoEmUmAno: emUmAno,
    );
  }
}