/// <cursor>
///
/// thema_manager.dart
/// Chemin: core/thema/
///
/// 🎯 GESTIONNAIRE DES THEMA - Interface principale du système
/// Gestion centralisée des Thema et génération de quiz
///
/// COMPOSANTS PRINCIPAUX:
/// - ThemaManager: Gestionnaire principal des Thema
/// - Génération de quiz selon les probabilités
/// - Validation et vérification des Thema
/// - Interface entre Thema et ExactMathEngine
///
/// ÉTAT ACTUEL:
/// - Gestionnaire centralisé des Thema
/// - Génération de quiz selon probabilités
/// - Validation automatique des Thema
/// - Interface avec le moteur de calculs
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-25 16:43: SOUSTRACTION ADAPTATIVE - Support ajouté
/// - Ajout case 'soustraction_entiers' dans _generateQuizItem()
/// - Intégration avec genSoustractionEntiersAdaptive()
/// - Support complet des opérations adaptatives
/// - 2025-09-24: Création gestionnaire Thema
/// - Interface centralisée pour génération de quiz
/// - Intégration avec ExactMathEngine
///
/// 🔧 POINTS D'ATTENTION:
/// - Validation: Vérification des probabilités
/// - Performance: Génération optimisée des quiz
/// - Cohérence: Synchronisation avec ExactMathEngine
/// - Évolutivité: Facile d'ajouter de nouveaux Thema
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans ModernMathSkillsScreen
/// - Tests sur tous les niveaux
/// - Optimisation des performances
/// - Ajout de nouvelles opérations
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/thema/thema_definitions.dart: Définitions des Thema
/// - lib/core/operations/exact_math_engine.dart: Moteur de calculs
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart: Interface
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Gestionnaire central)
/// 📅 Dernière modification: 2025-09-25 16:43 - Soustraction adaptative
/// </cursor>

import '../operations/exact_math_engine.dart';
import 'thema_definitions.dart';
import 'thema_operations.dart';

/// 🎯 GESTIONNAIRE DES THEMA
/// Interface principale pour la gestion des Thema et génération de quiz
class ThemaManager {
  static final ThemaManager _instance = ThemaManager._internal();
  factory ThemaManager() => _instance;
  ThemaManager._internal();

  /// Obtenir un Thema par niveau
  Thema? getThemaByLevel(int level) {
    return ThemaDefinitions.getThemaByLevel(level);
  }

  /// Obtenir un Thema par nom
  Thema? getThemaByName(String name) {
    return ThemaDefinitions.getThemaByName(name);
  }

  /// Obtenir tous les Thema disponibles
  List<Thema> getAllThema() {
    return ThemaDefinitions.allThema;
  }

  /// Obtenir tous les niveaux disponibles
  List<int> getAvailableLevels() {
    return ThemaDefinitions.getAvailableLevels();
  }

  /// Obtenir tous les noms de niveaux
  List<String> getAvailableNames() {
    return ThemaDefinitions.getAvailableNames();
  }

  /// Vérifier si un niveau existe
  bool hasLevel(int level) {
    return ThemaDefinitions.hasLevel(level);
  }

  /// Obtenir le niveau minimum
  int getMinLevel() {
    return ThemaDefinitions.getMinLevel();
  }

  /// Obtenir le niveau maximum
  int getMaxLevel() {
    return ThemaDefinitions.getMaxLevel();
  }

  /// Générer un quiz pour un niveau donné
  List<QuizItemExact> generateQuizForLevel(int level, {int itemCount = 5}) {
    final thema = getThemaByLevel(level);
    if (thema == null) {
      throw ArgumentError('Niveau $level non trouvé');
    }

    return generateQuizForThema(thema, itemCount: itemCount);
  }

  /// Générer un quiz pour un Thema donné
  List<QuizItemExact> generateQuizForThema(Thema thema, {int itemCount = 5}) {
    final quizItems = <QuizItemExact>[];

    for (int i = 0; i < itemCount; i++) {
      final operation = thema.getRandomOperation();
      final quizItem = _generateQuizItem(operation, level: thema.level);
      if (quizItem != null) {
        quizItems.add(quizItem);
      }
    }

    return quizItems;
  }

  /// Générer un item de quiz pour une opération donnée
  QuizItemExact? _generateQuizItem(String operation, {int level = 1}) {
    try {
      switch (operation) {
        case 'addition_entiers':
          return ExactMathGenerator().genAdditionEntiersAdaptive(level: level);
        case 'soustraction_entiers':
          return ExactMathGenerator()
              .genSoustractionEntiersAdaptive(level: level);
        case 'multiplication_entiers':
          return ExactMathGenerator()
              .genMultiplicationEntiersAdaptive(level: level);
        case 'division_entiers':
          return ExactMathGenerator().genDivisionEntiers();
        case 'puissance_simple':
          return ExactMathGenerator().genPuissanceSimple();
        case 'addition_fractions':
          return ExactMathGenerator().genFractionSum();
        case 'multiplication_fractions':
          return ExactMathGenerator().genFractionMultiplication();
        case 'division_fractions':
          return ExactMathGenerator().genFractionDivision();
        case 'addition_radicaux':
          return ExactMathGenerator().genRadicalSum();
        case 'multiplication_radicaux':
          return ExactMathGenerator().genRadicalMultiplication();
        case 'simplification_radicaux':
          return ExactMathGenerator().genRadicalSimplification();
        case 'logarithm_simple':
          return ExactMathGenerator().genLogExpOperations();
        case 'logarithm_multiplication':
          return ExactMathGenerator().genLogarithmMultiplication();
        case 'combination_simple':
          return ExactMathGenerator().genCombinationsSimple();
        case 'trigonometry_simple':
          return ExactMathGenerator().genTrigonometryAdaptive(level: level);
        case 'factorial_simple':
          return ExactMathGenerator().genFactorialSimple();
        case 'pourcentage_simple':
          return ExactMathGenerator().genPourcentageSimple();
        default:
          print('⚠️ Opération non reconnue: $operation');
          return ExactMathGenerator().genFractionSum(); // fallback
      }
    } catch (e) {
      print('❌ Erreur génération $operation: $e');
      return ExactMathGenerator().genFractionSum(); // fallback
    }
  }

  /// Obtenir les statistiques d'un Thema
  Map<String, dynamic> getThemaStats(Thema thema) {
    return {
      'name': thema.name,
      'level': thema.level,
      'operationCount': thema.operationCount,
      'operations': thema.operations,
      'totalProbability': thema.operations.values.fold(0.0, (a, b) => a + b),
    };
  }

  /// Valider tous les Thema
  List<String> validateAllThema() {
    final errors = <String>[];

    for (final thema in getAllThema()) {
      final total = thema.operations.values.fold(0.0, (a, b) => a + b);
      if ((total - 100.0).abs() > 0.01) {
        errors.add('${thema.name}: Probabilités = $total% (doit être 100%)');
      }

      for (final operation in thema.operations.keys) {
        if (operation.isEmpty) {
          errors.add('${thema.name}: Opération vide détectée');
        }
      }
    }

    return errors;
  }

  /// Obtenir un résumé de tous les Thema
  Map<String, dynamic> getAllThemaSummary() {
    final summary = <String, dynamic>{};

    for (final thema in getAllThema()) {
      summary[thema.name] = {
        'level': thema.level,
        'operationCount': thema.operationCount,
        'operations': thema.operations.keys.toList(),
        'totalProbability': thema.operations.values.fold(0.0, (a, b) => a + b),
      };
    }

    return summary;
  }

  /// Simuler la génération de quiz pour un niveau
  Map<String, int> simulateQuizGeneration(int level, {int iterations = 1000}) {
    final thema = getThemaByLevel(level);
    if (thema == null) {
      throw ArgumentError('Niveau $level non trouvé');
    }

    final counts = <String, int>{};

    for (int i = 0; i < iterations; i++) {
      final operation = thema.getRandomOperation();
      counts[operation] = (counts[operation] ?? 0) + 1;
    }

    return counts;
  }

  /// Obtenir les probabilités théoriques vs réelles
  Map<String, dynamic> getProbabilityAnalysis(int level,
      {int iterations = 1000}) {
    final thema = getThemaByLevel(level);
    if (thema == null) {
      throw ArgumentError('Niveau $level non trouvé');
    }

    final simulation = simulateQuizGeneration(level, iterations: iterations);
    final analysis = <String, dynamic>{};

    for (final operation in thema.operations.keys) {
      final theoretical = thema.getProbability(operation);
      final actual = (simulation[operation] ?? 0) / iterations * 100;
      final difference = (theoretical - actual).abs();

      analysis[operation] = {
        'theoretical': theoretical,
        'actual': actual,
        'difference': difference,
        'count': simulation[operation] ?? 0,
      };
    }

    return analysis;
  }
}
