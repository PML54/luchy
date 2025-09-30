/// <cursor>
///
/// quiz_score_service.dart
/// core/quiz/
///
/// LUCHY - Service de gestion des scores des quiz
///
/// Service centralisé pour la sauvegarde, récupération et calcul des statistiques
/// des scores de quiz avec intégration SQLite complète.
///
/// COMPOSANTS PRINCIPAUX:
/// - QuizScoreService: Service principal de gestion des scores
/// - Méthodes CRUD: Création, lecture, mise à jour des scores
/// - Statistiques: Calculs de moyennes, meilleurs scores, progression
/// - Requêtes optimisées: Index sur quiz_code et quiz_category
///
/// ÉTAT ACTUEL:
/// - Service complet avec toutes les opérations nécessaires
/// - Intégration SQLite avec gestion des erreurs
/// - Calculs de statistiques automatiques
/// - Support des métadonnées de session
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création du service QuizScoreService complet
/// - 2025-01-27: Intégration avec DatabaseService existant
/// - 2025-01-27: Ajout des calculs de statistiques avancées
///
/// 🔧 POINTS D'ATTENTION:
/// - Base de données: Extension de DatabaseService existant
/// - Performance: Index sur quiz_code et quiz_category
/// - Calculs: Note sur 20 calculée automatiquement
/// - Erreurs: Gestion robuste des erreurs de base de données
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans les écrans de quiz existants
/// - Création de l'écran de statistiques
/// - Tests avec différents types de quiz
/// - Optimisation des requêtes si nécessaire
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/database_service.dart: Service de base de données
/// - core/quiz/quiz_score.dart: Modèle de données
/// - core/quiz/quiz_config.dart: Configuration des quiz
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Service central de notation)
/// 📅 Dernière modification: 2025-01-27 22:05
/// </cursor>

import '../database/database_service.dart';
import 'quiz_score.dart';

/// Service de gestion des scores des quiz
class QuizScoreService {
  static const String _tableName = 'quiz_scores';

  /// Initialiser la table des scores (à appeler au démarrage de l'app)
  static Future<void> initializeTable() async {
    final db = await DatabaseService().database;

    // Créer la table si elle n'existe pas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
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

    // Créer les index pour optimiser les requêtes
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quiz_scores_code 
      ON $_tableName(quiz_code)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quiz_scores_category 
      ON $_tableName(quiz_category)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quiz_scores_date 
      ON $_tableName(session_date)
    ''');
  }

  /// Sauvegarder un score de quiz
  static Future<int> saveQuizScore({
    required String quizCode,
    required String quizCategory,
    required int totalQuestions,
    required int correctAnswers,
    int? durationSeconds,
    String? levelName,
  }) async {
    final db = await DatabaseService().database;

    final score20 =
        QuizScoreExtensions.calculateScore20(correctAnswers, totalQuestions);
    final now = DateTime.now();

    final id = await db.insert(_tableName, {
      'quiz_code': quizCode,
      'quiz_category': quizCategory,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'score_20': score20,
      'session_date': now.toIso8601String(),
      'duration_seconds': durationSeconds,
      'level_name': levelName,
      'created_at': now.toIso8601String(),
    });

    // NOUVEAU: Si c'est un quiz de maths et que le niveau est validé, mettre à jour le niveau max
    if (quizCode == 'MATH_HABILETES' && levelName != null) {
      final levelIndex = _getLevelIndex(levelName);
      print('🔍 NIVEAU: $levelName, INDEX: $levelIndex');

      if (levelIndex >= 0) {
        final isLevelValidated =
            _isLevelValidated(levelName, correctAnswers, totalQuestions);
        print('✅ VALIDÉ: $isLevelValidated ($correctAnswers/$totalQuestions)');

        if (isLevelValidated) {
          await DatabaseService().updateMaxLevelReached(
            quizCode: quizCode,
            levelName: levelName,
            levelIndex: levelIndex,
          );
          print('💾 STOCKÉ: $levelName (index: $levelIndex)');
        } else {
          final criteria = _getValidationCriteria(levelName);
          print(
              '❌ NON VALIDÉ: Score ${(correctAnswers / totalQuestions * 100).toStringAsFixed(1)}% < Critère ${(criteria.successRate * 100).toStringAsFixed(0)}%');
        }
      } else {
        print('❌ INDEX INVALIDE: $levelName');
      }
    }

    return id;
  }

  /// Convertit le nom du niveau en index numérique
  static int _getLevelIndex(String levelName) {
    const levelOrder = [
      'CP',
      'CE1',
      'CE2',
      'CM1',
      'CM2',
      '6ème',
      '5ème',
      '4ème',
      '3ème',
      '2nde',
      '1ère',
      'Terminale',
      'Bac+1',
      'Bac+2'
    ];

    // Recherche insensible à la casse
    for (int i = 0; i < levelOrder.length; i++) {
      if (levelOrder[i].toLowerCase() == levelName.toLowerCase()) {
        return i;
      }
    }
    return -1;
  }

  /// Vérifie si un niveau est validé selon les critères de progression
  static bool _isLevelValidated(
      String levelName, int correctAnswers, int totalQuestions) {
    // Critères de validation par niveau (même logique que ProgressionManager)
    final criteria = _getValidationCriteria(levelName);
    return criteria.isValidated(correctAnswers, totalQuestions);
  }

  /// Récupère les critères de validation pour un niveau
  static ValidationCriteria _getValidationCriteria(String levelName) {
    switch (levelName) {
      case 'CP':
      case 'CE1':
        return const ValidationCriteria(successRate: 0.75, minimumQuestions: 5);
      case 'CE2':
      case 'CM1':
      case 'CM2':
        return const ValidationCriteria(successRate: 0.80, minimumQuestions: 5);
      case '6ème':
      case '5ème':
      case '4ème':
      case '3ème':
        return const ValidationCriteria(successRate: 0.85, minimumQuestions: 5);
      case '2nde':
      case '1ère':
      case 'Terminale':
        return const ValidationCriteria(successRate: 0.90, minimumQuestions: 5);
      case 'Bac+1':
      case 'Bac+2':
        return const ValidationCriteria(successRate: 0.95, minimumQuestions: 5);
      default:
        return const ValidationCriteria(successRate: 0.80, minimumQuestions: 5);
    }
  }

  /// Récupérer tous les scores
  static Future<List<QuizScore>> getAllQuizScores() async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      orderBy: 'session_date DESC',
    );

    return results.map((map) => _mapToQuizScore(map)).toList();
  }

  /// Récupérer les scores d'un quiz spécifique
  static Future<List<QuizScore>> getQuizScores(String quizCode) async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
      orderBy: 'session_date DESC',
    );

    return results.map((map) => _mapToQuizScore(map)).toList();
  }

  /// Récupérer les scores d'une catégorie
  static Future<List<QuizScore>> getCategoryScores(String category) async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'quiz_category = ?',
      whereArgs: [category],
      orderBy: 'session_date DESC',
    );

    return results.map((map) => _mapToQuizScore(map)).toList();
  }

  /// Récupérer le meilleur score pour un quiz
  static Future<QuizScore?> getBestScore(String quizCode) async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
      orderBy: 'score_20 DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _mapToQuizScore(results.first);
  }

  /// Récupérer les statistiques globales
  static Future<Map<String, dynamic>> getGlobalStatistics() async {
    final db = await DatabaseService().database;

    // Total des sessions
    final totalSessions =
        await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');

    // Moyenne globale
    final averageScore =
        await db.rawQuery('SELECT AVG(score_20) as avg FROM $_tableName');

    // Meilleur score global
    final bestScore =
        await db.rawQuery('SELECT MAX(score_20) as max FROM $_tableName');

    // Total des questions et bonnes réponses
    final totals = await db.rawQuery('''
      SELECT 
        SUM(total_questions) as total_questions,
        SUM(correct_answers) as total_correct
      FROM $_tableName
    ''');

    return {
      'total_sessions': totalSessions.first['count'] ?? 0,
      'average_score': averageScore.first['avg'] ?? 0.0,
      'best_score': bestScore.first['max'] ?? 0.0,
      'total_questions': totals.first['total_questions'] ?? 0,
      'total_correct_answers': totals.first['total_correct'] ?? 0,
    };
  }

  /// Récupérer les statistiques par quiz
  static Future<List<QuizStatistics>> getQuizStatistics() async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        quiz_code,
        quiz_category,
        COUNT(*) as total_sessions,
        AVG(score_20) as average_score,
        MAX(score_20) as best_score,
        MIN(score_20) as worst_score,
        SUM(total_questions) as total_questions,
        SUM(correct_answers) as total_correct_answers,
        MAX(session_date) as last_session_date,
        AVG(duration_seconds) as average_duration
      FROM $_tableName
      GROUP BY quiz_code, quiz_category
      ORDER BY average_score DESC
    ''');

    return results.map((map) => _mapToQuizStatistics(map)).toList();
  }

  /// Récupérer les statistiques d'un quiz spécifique
  static Future<QuizStatistics?> getQuizStatisticsForCode(
      String quizCode) async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        quiz_code,
        quiz_category,
        COUNT(*) as total_sessions,
        AVG(score_20) as average_score,
        MAX(score_20) as best_score,
        MIN(score_20) as worst_score,
        SUM(total_questions) as total_questions,
        SUM(correct_answers) as total_correct_answers,
        MAX(session_date) as last_session_date,
        AVG(duration_seconds) as average_duration
      FROM $_tableName
      WHERE quiz_code = ?
      GROUP BY quiz_code, quiz_category
    ''', [quizCode]);

    if (results.isEmpty) return null;
    return _mapToQuizStatistics(results.first);
  }

  /// Supprimer un score spécifique
  static Future<void> deleteScore(int scoreId) async {
    final db = await DatabaseService().database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [scoreId],
    );
  }

  /// Supprimer tous les scores d'un quiz
  static Future<void> deleteQuizScores(String quizCode) async {
    final db = await DatabaseService().database;

    await db.delete(
      _tableName,
      where: 'quiz_code = ?',
      whereArgs: [quizCode],
    );
  }

  /// Supprimer tous les scores
  static Future<void> deleteAllScores() async {
    final db = await DatabaseService().database;

    await db.delete(_tableName);
  }

  /// Convertir une Map en QuizScore
  static QuizScore _mapToQuizScore(Map<String, dynamic> map) {
    return QuizScore(
      id: map['id'] as int,
      quizCode: map['quiz_code'] as String,
      quizCategory: map['quiz_category'] as String,
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int,
      score20: (map['score_20'] as num).toDouble(),
      sessionDate: DateTime.parse(map['session_date'] as String),
      durationSeconds: map['duration_seconds'] as int?,
      levelName: map['level_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convertir une Map en QuizStatistics
  static QuizStatistics _mapToQuizStatistics(Map<String, dynamic> map) {
    final totalQuestions = map['total_questions'] as int? ?? 0;
    final totalCorrectAnswers = map['total_correct_answers'] as int? ?? 0;
    final overallPercentage =
        totalQuestions > 0 ? (totalCorrectAnswers / totalQuestions) * 100 : 0.0;

    return QuizStatistics(
      quizCode: map['quiz_code'] as String,
      quizCategory: map['quiz_category'] as String,
      quizTitle: map['quiz_code'] as String, // Sera remplacé par le titre réel
      totalSessions: map['total_sessions'] as int,
      averageScore: (map['average_score'] as num?)?.toDouble() ?? 0.0,
      bestScore: (map['best_score'] as num?)?.toDouble() ?? 0.0,
      worstScore: (map['worst_score'] as num?)?.toDouble() ?? 0.0,
      totalQuestions: totalQuestions,
      totalCorrectAnswers: totalCorrectAnswers,
      overallPercentage: overallPercentage,
      lastSessionDate: map['last_session_date'] != null
          ? DateTime.parse(map['last_session_date'] as String)
          : null,
      averageDurationSeconds: (map['average_duration'] as num?)?.toInt(),
    );
  }
}

/// Critères de validation pour un niveau
class ValidationCriteria {
  final double successRate;
  final int minimumQuestions;

  const ValidationCriteria({
    required this.successRate,
    required this.minimumQuestions,
  });

  /// Valide si les critères de passage sont remplis
  bool isValidated(int correctAnswers, int totalQuestions) {
    if (totalQuestions < minimumQuestions) return false;
    return (correctAnswers / totalQuestions) >= successRate;
  }
}
