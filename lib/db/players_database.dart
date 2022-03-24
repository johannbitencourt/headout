import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:headout/model/player.dart';

class PlayersDatabase {
  static final PlayersDatabase instance = PlayersDatabase._init();

  static Database? _database;

  PlayersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('players.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tablePlayers ( 
        ${PlayerFields.id} $idType, 
        ${PlayerFields.isParticipant} $boolType,
        ${PlayerFields.classification} $integerType,
        ${PlayerFields.name} $textType,
        ${PlayerFields.time} $textType
        )
      ''');
  }

  Future<Player> create(Player player) async {
    final db = await instance.database;

    // final json = player.toJson();
    // final columns =
    //     '${PlayerFields.name}, ${PlayerFields.classification}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.name]}, ${json[NoteFields.classification]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tablePlayers, player.toJson());
    return player.copy(id: id);
  }

  Future<Player> readPlayer(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePlayers,
      columns: PlayerFields.values,
      where: '${PlayerFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Player.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Player>> readAllPlayers() async {
    final db = await instance.database;

    const orderBy = '${PlayerFields.time} ASC';
    final result = await db.rawQuery('SELECT * FROM $tablePlayers ORDER BY $orderBy');

    // final result = await db.query(tablePlayers, orderBy: orderBy);

    return result.map((json) => Player.fromJson(json)).toList();
  }

  Future<int> update(Player player) async {
    final db = await instance.database;

    return db.update(
      tablePlayers,
      player.toJson(),
      where: '${PlayerFields.id} = ?',
      whereArgs: [player.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tablePlayers,
      where: '${PlayerFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
