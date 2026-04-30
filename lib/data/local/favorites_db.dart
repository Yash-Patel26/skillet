import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/recipe.dart';

class FavoritesDb {
  static const _dbName = 'skillet.db';
  static const _favTable = 'favorites';
  static const _cacheTable = 'recipe_cache';
  static const _feedTable = 'feed_cache';
  Database? _db;

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, _dbName);
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createAll(db);
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_cacheTable (
              id TEXT PRIMARY KEY,
              data TEXT NOT NULL,
              cached_at INTEGER NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_feedTable (
              key TEXT PRIMARY KEY,
              data TEXT NOT NULL,
              cached_at INTEGER NOT NULL
            )
          ''');
        }
      },
    );
    return _db!;
  }

  Future<void> _createAll(Database db) async {
    await db.execute('''
      CREATE TABLE $_favTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT,
        area TEXT,
        thumbnail TEXT,
        instructions TEXT,
        ingredients_json TEXT,
        tags_json TEXT,
        youtube_url TEXT,
        source_url TEXT,
        saved_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $_cacheTable (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $_feedTable (
        key TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> save(Recipe r) async {
    final db = await _open();
    await db.insert(
      _favTable,
      _recipeToRow(r)..['saved_at'] = DateTime.now().millisecondsSinceEpoch,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove(String id) async {
    final db = await _open();
    await db.delete(_favTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isSaved(String id) async {
    final db = await _open();
    final rows = await db.query(_favTable,
        columns: ['id'], where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }

  Future<List<Recipe>> all() async {
    final db = await _open();
    final rows = await db.query(_favTable, orderBy: 'saved_at DESC');
    return rows.map(_rowToRecipe).toList();
  }

  Future<void> cacheRecipe(Recipe r) async {
    if (r.id.isEmpty) return;
    final db = await _open();
    await db.insert(
      _cacheTable,
      {
        'id': r.id,
        'data': jsonEncode(_recipeToJson(r)),
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Recipe?> cachedRecipe(String id) async {
    final db = await _open();
    final rows = await db.query(_cacheTable,
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    final json = jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
    return _recipeFromJson(json);
  }

  Future<void> cacheFeed(String key, List<Recipe> recipes) async {
    final db = await _open();
    await db.insert(
      _feedTable,
      {
        'key': key,
        'data': jsonEncode(recipes.map(_recipeToJson).toList()),
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> cachedFeed(String key) async {
    final db = await _open();
    final rows = await db.query(_feedTable,
        where: 'key = ?', whereArgs: [key], limit: 1);
    if (rows.isEmpty) return const [];
    final raw = jsonDecode(rows.first['data'] as String) as List;
    return raw
        .cast<Map<String, dynamic>>()
        .map(_recipeFromJson)
        .toList();
  }

  Map<String, dynamic> _recipeToRow(Recipe r) => {
        'id': r.id,
        'name': r.name,
        'category': r.category,
        'area': r.area,
        'thumbnail': r.thumbnail,
        'instructions': r.instructions,
        'ingredients_json':
            jsonEncode(r.ingredients.map((e) => e.toMap()).toList()),
        'tags_json': jsonEncode(r.tags),
        'youtube_url': r.youtubeUrl,
        'source_url': r.sourceUrl,
      };

  Recipe _rowToRecipe(Map<String, Object?> row) {
    final ings = (jsonDecode((row['ingredients_json'] ?? '[]') as String) as List)
        .cast<Map<String, dynamic>>()
        .map(Ingredient.fromMap)
        .toList();
    final tags = (jsonDecode((row['tags_json'] ?? '[]') as String) as List)
        .cast<String>();
    return Recipe(
      id: row['id'] as String,
      name: row['name'] as String,
      category: row['category'] as String?,
      area: row['area'] as String?,
      thumbnail: row['thumbnail'] as String?,
      instructions: row['instructions'] as String?,
      ingredients: ings,
      tags: tags,
      youtubeUrl: row['youtube_url'] as String?,
      sourceUrl: row['source_url'] as String?,
    );
  }

  Map<String, dynamic> _recipeToJson(Recipe r) => {
        'id': r.id,
        'name': r.name,
        'category': r.category,
        'area': r.area,
        'thumbnail': r.thumbnail,
        'instructions': r.instructions,
        'ingredients': r.ingredients.map((e) => e.toMap()).toList(),
        'tags': r.tags,
        'youtube': r.youtubeUrl,
        'source': r.sourceUrl,
      };

  Recipe _recipeFromJson(Map<String, dynamic> j) {
    final ings = ((j['ingredients'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(Ingredient.fromMap)
        .toList();
    return Recipe(
      id: (j['id'] ?? '').toString(),
      name: (j['name'] ?? '').toString(),
      category: j['category']?.toString(),
      area: j['area']?.toString(),
      thumbnail: j['thumbnail']?.toString(),
      instructions: j['instructions']?.toString(),
      ingredients: ings,
      tags: ((j['tags'] as List?) ?? const []).cast<String>(),
      youtubeUrl: j['youtube']?.toString(),
      sourceUrl: j['source']?.toString(),
    );
  }
}
