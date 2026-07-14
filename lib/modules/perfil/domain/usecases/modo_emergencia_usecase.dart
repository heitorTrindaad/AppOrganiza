import 'package:app_organiza/modules/transacoes/data/models/transacao_model.dart';

import '../../../transacoes/data/repositories/transacao_repository_impl.dart';

class ModoEmergenciaResultado {
  final double saldoAtual;
  final int diasDeSobrevivencia;
  final List<Map<String, dynamic>> sugestoesDeCorte;

  ModoEmergenciaResultado({
    required this.saldoAtual,
    required this.diasDeSobrevivencia,
    required this.sugestoesDeCorte,
  });
}

class ProcessarModoEmergenciaUseCase {
  final TransacaoRepositoryImpl _transacaoRepository;

  ProcessarModoEmergenciaUseCase(this._transacaoRepository);

  Future<ModoEmergenciaResultado> executar() async {
    final saldo = await _transacaoRepository.obterSaldoGeral();
    final gastosAgrupados = await _transacaoRepository
        .obterGastosPorCategoriaNoMes();
    final todasTransacoes = await _transacaoRepository.obterTodas();

    // 1. Calcular a média de gastos diários dos últimos 30 dias (apenas Saídas)
    final hoje = DateTime.now();
    final trintaDiasAtras = hoje.subtract(const Duration(days: 30));

    final gastosTrintaDias = todasTransacoes.where(
      (t) =>
          t.tipo == TipoTransacao.SAIDA &&
          t.dataRegistro.isAfter(trintaDiasAtras),
    );

    double totalGastoNoMes = 0;
    for (var g in gastosTrintaDias) {
      totalGastoNoMes += g.valor;
    }

    double mediaGastoDiario = totalGastoNoMes / 30;
    if (mediaGastoDiario == 0) mediaGastoDiario = 1.0; // Evita divisão por zero

    // 2. Calcular quantos dias ele sobrevive com o saldo atual
    // Se o saldo for negativo ou zero, ele tem 0 dias de sobrevivência imediata
    int diasSobrevivencia = saldo > 0 ? (saldo / mediaGastoDiario).round() : 0;

    // 3. Filtrar sugestões de corte (Categorias onde ele mais gastou, ex: Delivery, Lazer)
    // Vamos sugerir cortar as 3 maiores categorias de gastos
    final sugestoes = gastosAgrupados.take(3).toList();

    return ModoEmergenciaResultado(
      saldoAtual: saldo,
      diasDeSobrevivencia: diasSobrevivencia,
      sugestoesDeCorte: sugestoes,
    );
  }
}
