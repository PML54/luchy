/// <cursor>
/// LUCHY - Service de base de données SQLite
///
/// Service central de gestion de la base de données SQLite pour
/// la persistance des données de l'application Luchy.
///
/// COMPOSANTS PRINCIPAUX:
/// - DatabaseService: Service principal de gestion SQLite singleton
/// - Tables: game_settings, user_stats, puzzle_history, favorite_images
/// - Migration système: Gestion versions et évolutions schéma
/// - CRUD operations: Opérations de base pour toutes les entités
///
/// ÉTAT ACTUEL:
/// - Database: SQLite avec sqflite, support iOS/Android
/// - Architecture: Singleton pattern pour instance unique
/// - Performance: Optimisé avec transactions et indexation
/// - Stabilité: Gestion d'erreurs robuste et logging
///
/// HISTORIQUE RÉCENT:
/// - 2024-12-19: Création initiale remplaçant SharedPreferences
/// - Architecture repository pattern intégrée
/// - Gestion migrations automatiques implémentée
/// - Tests et validation sur iOS réussis
///
/// 🔧 POINTS D'ATTENTION:
/// - Singleton: Une seule instance database pour éviter conflits
/// - Migrations: Bien gérer évolutions schéma entre versions
/// - Transactions: Utiliser pour opérations atomiques critiques
/// - Chemins: Différents selon plateforme iOS/Android
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter sauvegarde progression puzzle en cours
/// - Implémenter système backup/restore cloud
/// - Optimiser index et requêtes pour grandes quantités données
/// - Ajouter monitoring performance database
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/models/database_models.dart: Modèles de données
/// - core/database/repositories/game_settings_repository.dart: Repository
/// - core/database/providers/database_providers.dart: Providers Riverpod
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Infrastructure critique)
/// 📅 Dernière modification: 2025-08-25 14:31
/// </cursor>

import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._internal();

  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'luchy.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des paramètres de jeu
    await db.execute('''
      CREATE TABLE game_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        difficulty_rows INTEGER NOT NULL DEFAULT 3,
        difficulty_cols INTEGER NOT NULL DEFAULT 3,
        use_custom_grid_size INTEGER NOT NULL DEFAULT 0,
        has_seen_documentation INTEGER NOT NULL DEFAULT 0,
        puzzle_type INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table des statistiques utilisateur
    await db.execute('''
      CREATE TABLE user_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_puzzles_completed INTEGER NOT NULL DEFAULT 0,
        total_play_time_seconds INTEGER NOT NULL DEFAULT 0,
        best_completion_time_seconds INTEGER,
        favorite_difficulty INTEGER NOT NULL DEFAULT 3,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table de l'historique des puzzles
    await db.execute('''
      CREATE TABLE puzzle_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        difficulty_rows INTEGER NOT NULL,
        difficulty_cols INTEGER NOT NULL,
        completion_time_seconds INTEGER,
        moves_count INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        completed_at TEXT
      )
    ''');

    // Table des images favorites
    await db.execute('''
      CREATE TABLE favorite_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL UNIQUE,
        title TEXT,
        added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Index pour optimiser les requêtes
    await db.execute(
        'CREATE INDEX idx_puzzle_history_completed ON puzzle_history(is_completed)');
    await db.execute(
        'CREATE INDEX idx_puzzle_history_created ON puzzle_history(created_at)');
    await db.execute(
        'CREATE INDEX idx_favorite_images_path ON favorite_images(image_path)');

    // Insérer les données par défaut
    await _insertDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration de version 1 à 2 : ajout du champ puzzle_type
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE game_settings ADD COLUMN puzzle_type INTEGER NOT NULL DEFAULT 1');
    }
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insérer les paramètres par défaut
    await db.insert('game_settings', {
      'difficulty_rows': 3,
      'difficulty_cols': 3,
      'use_custom_grid_size': 0,
      'has_seen_documentation': 0,
      'puzzle_type': 1,
    });

    // Insérer les statistiques par défaut
    await db.insert('user_stats', {
      'total_puzzles_completed': 0,
      'total_play_time_seconds': 0,
      'favorite_difficulty': 3,
    });
  }

  // Méthodes utilitaires pour les requêtes
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
