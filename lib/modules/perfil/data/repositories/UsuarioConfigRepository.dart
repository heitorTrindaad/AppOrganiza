import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/usuario_config_model.dart';

class UsuarioConfigRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Salva ou atualiza a configuração do usuário (ID sempre 1)
  Future<void> salvarConfiguracao(UsuarioConfigModel config) async {
    final db = await _dbHelper.database;

    // 'conflictAlgorithm: ConflictAlgorithm.replace' funciona como um UPSERT:  
    // Se o ID 1 já existir, ele atualiza (UPDATE). Se não existir, insere (INSERT).
    await db.insert(
      'usuario_config',
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Recupera a configuração do usuário. Retorna null se for o primeiro acesso ao app.
  Future<UsuarioConfigModel?> obterConfiguracao() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'usuario_config',
      where: 'id = ?',
      whereArgs: [1],
    );

    // Se a lista não estiver vazia, transforma o primeiro resultado em Objeto Dart
    if (maps.isNotEmpty) {
      return UsuarioConfigModel.fromMap(maps.first);
    }

    return null;
  }
}