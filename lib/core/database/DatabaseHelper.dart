    import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Instância privada para o Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Instância do banco de dados do sqflite
  static Database? _database;

  // Construtor privado
  DatabaseHelper._init();

  // Getter que garante que o banco de dados seja inicializado apenas uma vez
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('financas_comportamental.db');
    return _database!;
  }

  // Inicializa o banco de dados no caminho correto do dispositivo (Android/iOS)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Abre o banco de dados e define a versão. Se mudar o schema no futuro, aumenta a versão.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  // Ativa o suporte a Chaves Estrangeiras (Foreign Keys) no SQLite
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Cria as tabelas que desenhamos no início do projeto
  Future _createDB(Database db, int version) async {
    // 1. Tabela de Configuração do Usuário
    await db.execute('''
      CREATE TABLE usuario_config (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        salario_mensal REAL NOT NULL,
        horas_trabalhadas_mes INTEGER NOT NULL,
        valor_hora REAL NOT NULL
      )
    ''');

    // 2. Tabela de Metas dos Sonhos / Cofrinhos
    await db.execute('''
      CREATE TABLE meta_sonho (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_sonho TEXT NOT NULL,
        valor_alvo REAL NOT NULL,
        valor_poupado REAL NOT NULL DEFAULT 0.0,
        caminho_imagem TEXT,
        data_limite TEXT
      )
    ''');

    // 3. Tabela de Transações (Entradas e Saídas com Humor)
    await db.execute('''
      CREATE TABLE transacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL NOT NULL,
        tipo TEXT NOT NULL CHECK (tipo IN ('ENTRADA', 'SAIDA')),
        categoria TEXT NOT NULL,
        descricao TEXT,
        data_registro TEXT NOT NULL,
        estado_emocional TEXT,
        meta_id INTEGER,
        FOREIGN KEY (meta_id) REFERENCES meta_sonho(id) ON DELETE SET NULL
      )
    ''');
  }

  // Método auxiliar para fechar a conexão, útil para testes
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}