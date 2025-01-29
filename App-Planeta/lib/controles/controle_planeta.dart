  // Variável privada estática que armazena a instância do banco de dados.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelos/planeta.dart';


class ControlePlaneta {
  static Database? _bd;

  // Getter para acessar o banco de dados. Se já existir, retorna a instância, senão cria uma nova.
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await initBD('planetas.db');
    return _bd!;
  }

  // Inicializa o banco de dados, passando o nome do arquivo.
  Future<Database> initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: criarBD,
    );
  }

// Cria o banco de dados com a tabela 'planetas' caso ainda não exista.
  Future<void> criarBD(Database bd, int versao) async {
    const sql = '''
  CREATE TABLE planetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    tamanho REAL NOT NULL,
    distancia REAL NOT NULL,
    apelido TEXT
    );
    ''';
    await bd.execute(sql);
  }

  // Lê todos os planetas do banco de dados e os retorna como uma lista de objetos Planeta.
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

    // Insere um novo planeta no banco de dados e retorna o ID inserido.
  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert(
      'planetas',
      planeta.toMap(),
    );
  }

   // Atualiza os dados de um planeta existente no banco de dados com base no ID.
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }


  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
