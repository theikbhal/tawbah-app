import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('zikir.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        startDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE zikir_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        date TEXT NOT NULL,
        count INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        date TEXT NOT NULL,
        content TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // User Methods
  Future<int> createUser(AppUser user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<AppUser>> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((json) => AppUser.fromMap(json)).toList();
  }

  // Zikir Log Methods
  Future<void> updateZikirCount(int userId, DateTime date, int increment) async {
    final db = await instance.database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final existing = await db.query(
      'zikir_logs',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, dateStr],
    );

    if (existing.isNotEmpty) {
      final currentCount = existing.first['count'] as int;
      await db.update(
        'zikir_logs',
        {'count': currentCount + increment},
        where: 'userId = ? AND date = ?',
        whereArgs: [userId, dateStr],
      );
    } else {
      await db.insert('zikir_logs', {
        'userId': userId,
        'date': dateStr,
        'count': increment,
      });
    }
  }

  Future<int> getZikirCount(int userId, DateTime date) async {
    final db = await instance.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'zikir_logs',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, dateStr],
    );
    if (result.isEmpty) return 0;
    return result.first['count'] as int;
  }

  Future<List<ZikirLog>> getLogsForRange(int userId, DateTime start, DateTime end) async {
    final db = await instance.database;
    final startStr = start.toIso8601String().split('T')[0];
    final endStr = end.toIso8601String().split('T')[0];
    
    final result = await db.query(
      'zikir_logs',
      where: 'userId = ? AND date BETWEEN ? AND ?',
      whereArgs: [userId, startStr, endStr],
    );
    return result.map((json) => ZikirLog.fromMap(json)).toList();
  }

  // Note Methods
  Future<void> saveNote(DailyNote note) async {
    final db = await instance.database;
    final dateStr = note.date.toIso8601String().split('T')[0];
    
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getNote(int userId, DateTime date) async {
    final db = await instance.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'notes',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, dateStr],
    );
    if (result.isEmpty) return null;
    return result.first['content'] as String;
  }
}
