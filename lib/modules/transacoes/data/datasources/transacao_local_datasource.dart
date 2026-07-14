import '../../../../core/database/database_helper.dart'; // Ajuste o import conforme sua estrutura
import '../models/transacao_model.dart';

class TransacaoLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<TransacaoModel>> buscarTodas() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transacao',
      orderBy: 'data_registro DESC',
    );

    return List.generate(maps.length, (i) => TransacaoModel.fromMap(maps[i]));
  }

  Future<int> inserir(TransacaoModel transacao) async {
    final db = await _dbHelper.database;
    return await db.insert('transacao', transacao.toMap());
  }
}
