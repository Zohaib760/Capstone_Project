import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'capstone.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image_url TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (item_id) REFERENCES items (id)
      )
    ''');
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Item operations
  Future<int> insertItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    Database db = await database;
    return await db.query('items');
  }

  Future<Map<String, dynamic>?> getItemById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Favorite operations
  Future<int> addFavorite(int userId, int itemId) async {
    Database db = await database;
    return await db.insert('favorites', {
      'user_id': userId,
      'item_id': itemId,
    });
  }

  Future<int> removeFavorite(int userId, int itemId) async {
    Database db = await database;
    return await db.delete(
      'favorites',
      where: 'user_id = ? AND item_id = ?',
      whereArgs: [userId, itemId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT items.* FROM items
      INNER JOIN favorites ON items.id = favorites.item_id
      WHERE favorites.user_id = ?
    ''', [userId]);
  }

  Future<bool> isFavorite(int userId, int itemId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'favorites',
      where: 'user_id = ? AND item_id = ?',
      whereArgs: [userId, itemId],
    );
    return results.isNotEmpty;
  }
}