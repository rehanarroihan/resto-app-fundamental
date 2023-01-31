import 'package:path/path.dart';
import 'package:restaurant/models/resto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    // var db = openDatabase(
    //   join(path, 'resto.db'),
    //   onCreate: (db, version) async {
    //     await db.execute(
    //       '''CREATE TABLE $_tableName (
    //            id INTEGER PRIMARY KEY,
    //            resto_id TEXT NOT NULL,
    //            name TEXT,
    //            description TEXT,
    //            pictureId TEXT,
    //            city TEXT,
    //            rating DOUBLE,
    //          )''',
    //     );
    //   },
    //   version: 1,
    // );

    var db = openDatabase(
      join(path, 'resto_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               id TEXT,
               name TEXT,
               description TEXT,
               pictureId TEXT,
               city TEXT,
               rating DOUBLE,
               isFavorite INTEGER
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertFavoriteResto(Resto resto) async {
    final Database db = await database;
    await db.insert(_tableName, resto.toJson());
  }

  Future<void> deleteFavoriteResto(String restoId) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [restoId],
    );
  }

  Future<List<Resto>> getFavoriteResto() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Resto.fromJson(res)).toList();
  }
}