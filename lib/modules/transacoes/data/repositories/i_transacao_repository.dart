import 'package:app_organiza/modules/transacoes/data/models/transacao_model.dart';

abstract class ITransacaoRepository {
  Future<int> inserirTransacao(TransacaoModel transacao);
  Future<List<TransacaoModel>> obterTodas();
  Future<double> obterSaldoGeral();
  Future<List<Map<String, dynamic>>> obterGastosPorCategoriaNoMes();
}
