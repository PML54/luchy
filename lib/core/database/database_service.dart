// 1. Créer le service de base de données : database_service.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'math_records.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createTables,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Table pour les records de progression
    await db.execute('''
      CREATE TABLE math_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        highest_level_name TEXT NOT NULL,
        highest_level_index INTEGER NOT NULL,
        fastest_time_seconds INTEGER NOT NULL,
        completion_date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Table pour l'historique des sessions
    await db.execute('''
      CREATE TABLE math_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        level_name TEXT NOT NULL,
        level_index INTEGER NOT NULL,
        total_time_seconds INTEGER NOT NULL,
        completed_without_error INTEGER NOT NULL,
        session_date TEXT NOT NULL
      )
    ''');

    // Table pour les scores des quiz
    await db.execute('''
      CREATE TABLE quiz_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_code TEXT NOT NULL,
        quiz_category TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        score_20 REAL NOT NULL,
        session_date TEXT NOT NULL,
        duration_seconds INTEGER,
        level_name TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Table pour les niveaux maximum atteints sans erreur
    await db.execute('''
      CREATE TABLE user_levels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_code TEXT NOT NULL UNIQUE,
        max_level_name TEXT NOT NULL,
        max_level_index INTEGER NOT NULL,
        last_perfect_score_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Index pour optimiser les requêtes sur les scores de quiz
    await db.execute('''
      CREATE INDEX idx_quiz_scores_code ON quiz_scores(quiz_code)
    ''');

    await db.execute('''
      CREATE INDEX idx_quiz_scores_category ON quiz_scores(quiz_category)
    ''');

    await db.execute('''
      CREATE INDEX idx_quiz_scores_date ON quiz_scores(session_date)
    ''');
  }

  /// Migration de la base de données
  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Ajouter la table des scores de quiz
      await db.execute('''
        CREATE TABLE quiz_scores (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          quiz_code TEXT NOT NULL,
          quiz_category TEXT NOT NULL,
          total_questions INTEGER NOT NULL,
          correct_answers INTEGER NOT NULL,
          score_20 REAL NOT NULL,
          session_date TEXT NOT NULL,
          duration_seconds INTEGER,
          level_name TEXT,
          created_at TEXT NOT NULL
        )
      ''');

      // Ajouter les index
      await db.execute('''
        CREATE INDEX idx_quiz_scores_code ON quiz_scores(quiz_code)
      ''');

      await db.execute('''
        CREATE INDEX idx_quiz_scores_category ON quiz_scores(quiz_category)
      ''');

      await db.execute('''
        CREATE INDEX idx_quiz_scores_date ON quiz_scores(session_date)
      ''');
    }

    if (oldVersion < 3) {
      // Ajouter la table des niveaux maximum atteints sans erreur
      await db.execute('''
        CREATE TABLE user_levels (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          quiz_code TEXT NOT NULL UNIQUE,
          max_level_name TEXT NOT NULL,
          max_level_index INTEGER NOT NULL,
          last_perfect_score_date TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
  }

  // Sauvegarder un nouveau record
  Future<void> saveRecord({
    required String levelName,
    required int levelIndex,
    required int timeSeconds,
  }) async {
    final db = await database;

    await db.insert(
      'math_records',
      {
        'highest_level_name': levelName,
        'highest_level_index': levelIndex,
        'fastest_time_seconds': timeSeconds,
        'completion_date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  // Récupérer le meilleur record actuel
  Future<Map<String, dynamic>?> getBestRecord() async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.query(
      'math_records',
      orderBy: 'highest_level_index DESC, fastest_time_seconds ASC',
      limit: 1,
    );

    return results.isNotEmpty ? results.first : null;
  }

  // Vérifier si ce record est meilleur que l'existant
  Future<bool> isNewRecord({
    required int levelIndex,
    required int timeSeconds,
  }) async {
    final bestRecord = await getBestRecord();

    if (bestRecord == null) return true;

    final bestLevel = bestRecord['highest_level_index'] as int;
    final bestTime = bestRecord['fastest_time_seconds'] as int;

    // Nouveau record si niveau supérieur OU même niveau mais temps meilleur
    return levelIndex > bestLevel ||
        (levelIndex == bestLevel && timeSeconds < bestTime);
  }

  // Sauvegarder une session
  Future<void> saveSession({
    required String levelName,
    required int levelIndex,
    required int timeSeconds,
    required bool completedWithoutError,
  }) async {
    final db = await database;

    await db.insert(
      'math_sessions',
      {
        'level_name': levelName,
        'level_index': levelIndex,
        'total_time_seconds': timeSeconds,
        'completed_without_error': completedWithoutError ? 1 : 0,
        'session_date': DateTime.now().toIso8601String(),
      },
    );
  }

  // NOUVEAU: Sauvegarder ou mettre à jour le niveau maximum atteint (même sans score parfait)
  Future<void> updateMaxLevelReached({
    required String quizCode,
    required String levelName,
    required int levelIndex,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Vérifier si un niveau existe déjà pour ce quiz
    final existing = await db.query(
      'user_levels',
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
    );

    if (existing.isNotEmpty) {
      // Mettre à jour si le nouveau niveau est plus élevé
      final currentIndex = existing.first['max_level_index'] as int;
      if (levelIndex > currentIndex) {
        await db.update(
          'user_levels',
          {
            'max_level_name': levelName,
            'max_level_index': levelIndex,
            'last_perfect_score_date': now,
            'updated_at': now,
          },
          where: 'quiz_code = ?',
          whereArgs: [quizCode],
        );
        print('NOUVEAU NIVEAU MAX: $levelName (index: $levelIndex) pour $quizCode');
      }
    } else {
      // Créer un nouvel enregistrement
      await db.insert('user_levels', {
        'quiz_code': quizCode,
        'max_level_name': levelName,
        'max_level_index': levelIndex,
        'last_perfect_score_date': now,
        'created_at': now,
        'updated_at': now,
      });
      print('PREMIER NIVEAU: $levelName (index: $levelIndex) pour $quizCode');
    }
  }

  // NOUVEAU: Sauvegarder ou mettre à jour le niveau maximum atteint sans erreur
  Future<void> updateMaxLevelWithoutError({
    required String quizCode,
    required String levelName,
    required int levelIndex,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Vérifier si un niveau existe déjà pour ce quiz
    final existing = await db.query(
      'user_levels',
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
    );

    if (existing.isNotEmpty) {
      // Mettre à jour si le nouveau niveau est plus élevé
      final currentIndex = existing.first['max_level_index'] as int;
      if (levelIndex > currentIndex) {
        await db.update(
          'user_levels',
          {
            'max_level_name': levelName,
            'max_level_index': levelIndex,
            'last_perfect_score_date': now,
            'updated_at': now,
          },
          where: 'quiz_code = ?',
          whereArgs: [quizCode],
        );
      }
    } else {
      // Créer un nouvel enregistrement
      await db.insert('user_levels', {
        'quiz_code': quizCode,
        'max_level_name': levelName,
        'max_level_index': levelIndex,
        'last_perfect_score_date': now,
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  // NOUVEAU: Récupérer le niveau maximum atteint pour un quiz
  Future<String?> getMaxLevelReached(String quizCode) async {
    final db = await database;

    final results = await db.query(
      'user_levels',
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
      limit: 1,
    );

    return results.isNotEmpty
        ? results.first['max_level_name'] as String?
        : null;
  }

  // NOUVEAU: Récupérer le niveau maximum atteint sans erreur pour un quiz
  Future<String?> getMaxLevelWithoutError(String quizCode) async {
    final db = await database;

    final results = await db.query(
      'user_levels',
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
      limit: 1,
    );

    return results.isNotEmpty
        ? results.first['max_level_name'] as String?
        : null;
  }

  // Récupérer tous les records
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query(
      'math_records',
      orderBy: 'highest_level_index DESC, fastest_time_seconds ASC',
    );
  }

  // Récupérer les statistiques
  Future<Map<String, dynamic>> getStats() async {
    final db = await database;

    final totalSessions =
        await db.rawQuery('SELECT COUNT(*) as count FROM math_sessions');

    final successfulSessions = await db.rawQuery(
        'SELECT COUNT(*) as count FROM math_sessions WHERE completed_without_error = 1');

    final bestRecord = await getBestRecord();

    return {
      'total_sessions': totalSessions.first['count'],
      'successful_sessions': successfulSessions.first['count'],
      'best_record': bestRecord,
    };
  }
}
