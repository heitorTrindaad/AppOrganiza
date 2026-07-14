import 'package:app_organiza/core/database/database_helper.dart';
import 'package:app_organiza/modules/transacoes/data/models/transacao_model.dart';
import 'package:app_organiza/modules/transacoes/data/repositories/i_transacao_repository.dart';

class TransacaoRepositoryImpl implements ITransacaoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // 1. Inserir uma nova transação (Gasto ou Ganho)

  Future<int> inserirTransacao(TransacaoModel transacao) async {
    final db = await _dbHelper.database;

    return await db.insert('transacao', transacao.toMap());
  }

  // 2. Buscar todas as transações ordenadas pela data mais recente

  Future<List<TransacaoModel>> obterTodas() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'transacao',

      orderBy: 'data_registro DESC',
    );

    return List.generate(maps.length, (i) => TransacaoModel.fromMap(maps[i]));
  }

  // 3. CALCULO CORE: Saldo Geral Disponível (Livre para gastar)

  // Faz a soma matemática de ENTRADAs e subtrai as SAÍDAs do banco

  Future<double> obterSaldoGeral() async {
    final db = await _dbHelper.database;

    final resultado = await db.rawQuery('''
    SELECT 
      SUM(CASE WHEN tipo = 'ENTRADA' THEN valor ELSE -valor END) as saldo_geral
    FROM transacao
  ''');

    // Segurança extra: converte para num, depois para double, e trata o null
    final valor = resultado.first['saldo_geral'] as num?;
    return valor?.toDouble() ?? 0.0;
  }

  // 4. MODO "ESTOU SEM DINHEIRO": Buscar média de gastos por categoria supérflua

  // Retorna os gastos agrupados para a camada de domínio decidir o que cortar

  Future<List<Map<String, dynamic>>> obterGastosPorCategoriaNoMes() async {
    final db = await _dbHelper.database;

    return await db.rawQuery('''

      SELECT categoria, SUM(valor) as total

      FROM transacao

      WHERE tipo = 'SAIDA'

      GROUP BY categoria

      ORDER BY total DESC

    ''');
  }
}
