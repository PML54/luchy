/// <cursor>
///
/// quiz_score.dart
/// core/quiz/
///
/// LUCHY - Modèle de données pour les scores des quiz
///
/// Gestion des scores et notes pour tous les types de quiz avec calculs
/// automatiques et statistiques de performance.
///
/// COMPOSANTS PRINCIPAUX:
/// - QuizScore: Modèle principal avec métadonnées complètes
/// - QuizScoreService: Service de gestion des scores en base
/// - QuizStatistics: Statistiques agrégées par quiz
/// - Calculs automatiques: Note sur 20, pourcentage, moyennes
///
/// ÉTAT ACTUEL:
/// - Modèle complet avec tous les champs nécessaires
/// - Calculs automatiques de la note sur 20
/// - Support des métadonnées (durée, niveau, date)
/// - Méthodes utilitaires pour affichage
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-29: ARRONDI NOTES - Notes arrondies à l'entier inférieur (floor)
/// - 2025-01-27: Création du modèle QuizScore complet
/// - 2025-01-27: Ajout des calculs automatiques de notation
/// - 2025-01-27: Support des métadonnées de session
///
/// 🔧 POINTS D'ATTENTION:
/// - Calculs: Note sur 20 = floor((correct_answers / total_questions) * 20)
/// - Codes quiz: Utilise les codes existants (GEO_CAP, MATH_HABILETES, etc.)
/// - Dates: Stockage en ISO8601 pour compatibilité
/// - Performance: Index sur quiz_code et quiz_category
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans DatabaseService
/// - Modification des écrans de quiz existants
/// - Création de l'écran de statistiques
/// - Tests avec différents types de quiz
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/database_service.dart: Service de base de données
/// - core/quiz/quiz_config.dart: Configuration des quiz
/// - features/puzzle/presentation/screens/modern_math_skills_screen.dart: Quiz maths
/// - features/puzzle/presentation/screens/generic_quiz_screen.dart: Quiz génériques
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Système de notation central)
/// 📅 Dernière modification: 2025-09-29 05:09
/// </cursor>

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_score.freezed.dart';
part 'quiz_score.g.dart';

/// Modèle de données pour un score de quiz
@freezed
class QuizScore with _$QuizScore {
  const factory QuizScore({
    required int id,
    required String quizCode, // 'GEO_CAP', 'MATH_HABILETES', 'SVT_EVA', etc.
    required String
        quizCategory, // 'Géographie', 'Mathématiques', 'SVT Terminale'
    required int totalQuestions, // Nombre total de questions du quiz
    required int correctAnswers, // Nombre de bonnes réponses
    required double score20, // Note sur 20 calculée
    required DateTime sessionDate, // Date de la session
    int? durationSeconds, // Durée du quiz en secondes (optionnel)
    String? levelName, // Niveau de difficulté (optionnel)
    required DateTime createdAt, // Date de création de l'enregistrement
  }) = _QuizScore;

  factory QuizScore.fromJson(Map<String, dynamic> json) =>
      _$QuizScoreFromJson(json);
}

/// Extension pour les calculs et utilitaires
extension QuizScoreExtensions on QuizScore {
  /// Calculer la note sur 20 (arrondie à l'entier inférieur)
  static double calculateScore20(int correct, int total) {
    if (total == 0) return 0.0;
    return ((correct / total) * 20.0).floor().toDouble();
  }

  /// Obtenir la note en texte formatée (entier)
  String get scoreText => '${score20.toInt()}/20';

  /// Obtenir le pourcentage de réussite
  double get percentage => (correctAnswers / totalQuestions) * 100;

  /// Obtenir le pourcentage en texte formaté
  String get percentageText => '${percentage.toStringAsFixed(1)}%';

  /// Obtenir la durée formatée (si disponible)
  String get durationText {
    if (durationSeconds == null) return 'N/A';

    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Obtenir le niveau de performance (A, B, C, D, F)
  String get performanceGrade {
    if (score20 >= 18) return 'A+';
    if (score20 >= 16) return 'A';
    if (score20 >= 14) return 'B+';
    if (score20 >= 12) return 'B';
    if (score20 >= 10) return 'C+';
    if (score20 >= 8) return 'C';
    if (score20 >= 6) return 'D';
    return 'F';
  }

  /// Obtenir la couleur associée à la performance
  String get performanceColor {
    if (score20 >= 16) return 'green';
    if (score20 >= 12) return 'blue';
    if (score20 >= 8) return 'orange';
    return 'red';
  }
}

/// Statistiques agrégées pour un quiz
@freezed
class QuizStatistics with _$QuizStatistics {
  const factory QuizStatistics({
    required String quizCode,
    required String quizCategory,
    required String quizTitle,
    required int totalSessions, // Nombre total de sessions
    required double averageScore, // Moyenne des scores
    required double bestScore, // Meilleur score
    required double worstScore, // Pire score
    required int totalQuestions, // Total des questions (toutes sessions)
    required int totalCorrectAnswers, // Total des bonnes réponses
    required double overallPercentage, // Pourcentage global de réussite
    DateTime? lastSessionDate, // Date de la dernière session
    int? averageDurationSeconds, // Durée moyenne (si disponible)
  }) = _QuizStatistics;

  factory QuizStatistics.fromJson(Map<String, dynamic> json) =>
      _$QuizStatisticsFromJson(json);
}

/// Extension pour les statistiques
extension QuizStatisticsExtensions on QuizStatistics {
  /// Obtenir la moyenne formatée (entier)
  String get averageScoreText => '${averageScore.toInt()}/20';

  /// Obtenir le meilleur score formaté (entier)
  String get bestScoreText => '${bestScore.toInt()}/20';

  /// Obtenir le pire score formaté (entier)
  String get worstScoreText => '${worstScore.toInt()}/20';

  /// Obtenir le pourcentage global formaté
  String get overallPercentageText =>
      '${overallPercentage.toStringAsFixed(1)}%';

  /// Obtenir la durée moyenne formatée
  String get averageDurationText {
    if (averageDurationSeconds == null) return 'N/A';

    final minutes = averageDurationSeconds! ~/ 60;
    final seconds = averageDurationSeconds! % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Obtenir le niveau de performance global
  String get overallPerformanceGrade {
    if (averageScore >= 18) return 'A+';
    if (averageScore >= 16) return 'A';
    if (averageScore >= 14) return 'B+';
    if (averageScore >= 12) return 'B';
    if (averageScore >= 10) return 'C+';
    if (averageScore >= 8) return 'C';
    if (averageScore >= 6) return 'D';
    return 'F';
  }
}
