/// <cursor>
///
/// MOTEUR DE BASE POUR LES QUIZ HABILETÉ
///
/// Classe de base commune pour tous les quiz "Habileté" (Numérique, Fractions, etc.).
/// Définit la structure commune et les interfaces partagées.
///
/// COMPOSANTS PRINCIPAUX:
/// - BaseOperationParameter: Paramètre d'opération générique
/// - BaseOperationTemplate: Template d'opération générique
/// - BaseSkillsGenerator: Générateur de base
/// - Interfaces communes pour tous les quiz
///
/// ÉTAT ACTUEL:
/// - Structure de base définie
/// - Interfaces communes créées
/// - Prêt pour l'héritage par les moteurs spécialisés
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de la base commune
/// - Définition des interfaces partagées
/// - Structure pour l'héritage
///
/// 🔧 POINTS D'ATTENTION:
/// - Généricité pour supporter différents types de données
/// - Interfaces communes pour la cohérence
/// - Extensibilité pour de nouveaux quiz
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Refactoring des moteurs existants
/// - Création d'écrans de base communs
/// - Tests d'intégration
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/operations/numerical_skills_engine.dart: Moteur numérique
/// - lib/core/operations/fraction_skills_engine.dart: Moteur fractions
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (5/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

/// Paramètre d'opération générique
class BaseOperationParameter {
  final String name;
  final int minValue;
  final int maxValue;
  final String description;

  const BaseOperationParameter({
    required this.name,
    required this.minValue,
    required this.maxValue,
    required this.description,
  });
}

/// Template d'opération générique
abstract class BaseOperationTemplate {
  final String operationType;
  final String latexPattern;
  final String description;
  final List<BaseOperationParameter> parameters;
  final int difficulty;

  const BaseOperationTemplate({
    required this.operationType,
    required this.latexPattern,
    required this.description,
    required this.parameters,
    required this.difficulty,
  });

  /// Calcule le résultat de l'opération
  dynamic calculateResult(Map<String, dynamic> params);
}

/// Générateur de base pour les quiz
class BaseSkillsGenerator {
  static final math.Random _random = math.Random();

  /// Génère un quiz avec des opérations
  static List<Map<String, dynamic>>
      generateQuiz<T extends BaseOperationTemplate>(
    List<T> operations,
    int numberOfQuestions,
  ) {
    final selectedOperations = <T>[];
    final usedResults = <String>{};

    // Sélectionner des opérations différentes
    while (selectedOperations.length < numberOfQuestions) {
      final operation = operations[_random.nextInt(operations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions
    final questions = <Map<String, dynamic>>[];

    for (final operation in selectedOperations) {
      Map<String, dynamic> params = {};
      dynamic result;
      int attempts = 0;
      const maxAttempts = 50;

      // Générer des paramètres jusqu'à obtenir un résultat unique et valide
      do {
        params = {};

        // Génération des paramètres
        for (final param in operation.parameters) {
          params[param.name] = param.minValue +
              _random.nextInt(param.maxValue - param.minValue + 1);
        }

        result = operation.calculateResult(params);
        attempts++;
      } while ((usedResults.contains(result.toString()) || result == null) &&
          attempts < maxAttempts);

      usedResults.add(result.toString());

      // Remplacer les variables dans le LaTeX
      String latex = operation.latexPattern;
      for (final entry in params.entries) {
        latex = latex.replaceAll('{VAR:${entry.key}}', entry.value.toString());
      }

      questions.add({
        'operation': operation,
        'latex': latex,
        'result': result,
        'params': params,
      });
    }

    return questions;
  }
}
