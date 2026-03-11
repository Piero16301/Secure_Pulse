import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/security_item.dart';
import '../../domain/repositories/items_repository.dart';
import '../mappers/security_item_mapper.dart';

class LocalItemsRepository implements ItemsRepository {
  Database? _database;
  static const String _tableName = 'security_items';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'secure_pulse.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            status TEXT NOT NULL,
            severity TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<SecurityItem>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => map.toEntity()).toList();
  }

  @override
  Future<void> addItem(SecurityItem item) async {
    final db = await database;
    await db.insert(
      _tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateItem(SecurityItem item) async {
    final db = await database;
    await db.update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deleteItem(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
