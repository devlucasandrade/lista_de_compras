import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'compras.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE produtos (
            id TEXT PRIMARY KEY,
            nome TEXT,
            quantidade INT,
            preco REAL
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(
      String table, Map<String, Object> data, String id) async {
    final db = await DBUtil.database();
    await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBUtil.database();
    await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBUtil.database();
    return db.query(table);
  }
}
