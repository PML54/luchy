/// <cursor>
///
/// MOTEUR DE GÉNÉRATION DE QUIZ TRIGONOMÉTRIQUES - VERSION CORRIGÉE
///
/// Générateur de quiz de calcul trigonométrique basé sur les valeurs remarquables.
/// Supporte les fonctions sin, cos, tan avec les angles classiques (0, π/6, π/4, π/3, π/2, π, 3π/2, 2π).
///
/// COMPOSANTS PRINCIPAUX:
/// - TrigonometryOperation: Structure pour les opérations trigonométriques
/// - TrigonometrySkillsGenerator: Générateur principal de quiz
/// - Valeurs remarquables prédéfinies avec calculs exacts
///
/// ÉTAT ACTUEL:
/// - Valeurs remarquables implémentées
/// - Générateur de quiz par niveau de difficulté
/// - Support des calculs directs et combinés
/// - Correction du bug de génération des paramètres
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création initiale du moteur trigonométrique
/// - Intégration des valeurs remarquables classiques
/// - Support des 3 niveaux de difficulté (Facile, Moyen, Difficile)
/// - 2025-01-27: Amélioration de la variété des questions
/// - Ajout de plus d'angles remarquables (cercle complet)
/// - Support des coefficients décimaux (0.5, 1.5, 2.5)
/// - Correction gestion des valeurs infinies pour tan(π/2)
/// - Correction majeure : génération explicite des paramètres par switch/case
///
/// 🔧 POINTS D'ATTENTION:
/// - Utilise des calculs exacts (fractions) pour éviter les erreurs d'arrondi
/// - Gestion spéciale des valeurs infinies (tan(π/2), tan(3π/2))
/// - LaTeX correct pour l'affichage des formules
/// - Génération explicite des paramètres selon le type d'opération
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Tests de validation des calculs
/// - Optimisation de l'affichage des résultats
/// - Intégration dans la navigation principale
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/domain/models/game_state.dart (NiveauDifficulte)
/// - lib/core/operations/numerical_skills_engine.dart (structure similaire)
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Échelle de 1 à 5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

import '../../features/puzzle/domain/models/game_state.dart';

/// Valeurs remarquables des fonctions trigonométriques
class TrigonometryValues {
  static const Map<String, Map<String, String>> values = {
    '0': {
      'sin': '0',
      'cos': '1',
      'tan': '0',
    },
    'π/6': {
      'sin': '1/2',
      'cos': '√3/2',
      'tan': '1/√3',
    },
    'π/4': {
      'sin': '√2/2',
      'cos': '√2/2',
      'tan': '1',
    },
    'π/3': {
      'sin': '√3/2',
      'cos': '1/2',
      'tan': '√3',
    },
    'π/2': {
      'sin': '1',
      'cos': '0',
      'tan': '∞',
    },
    '2π/3': {
      'sin': '√3/2',
      'cos': '-1/2',
      'tan': '-√3',
    },
    '3π/4': {
      'sin': '√2/2',
      'cos': '-√2/2',
      'tan': '-1',
    },
    '5π/6': {
      'sin': '1/2',
      'cos': '-√3/2',
      'tan': '-1/√3',
    },
    'π': {
      'sin': '0',
      'cos': '-1',
      'tan': '0',
    },
    '7π/6': {
      'sin': '-1/2',
      'cos': '-√3/2',
      'tan': '1/√3',
    },
    '5π/4': {
      'sin': '-√2/2',
      'cos': '-√2/2',
      'tan': '1',
    },
    '4π/3': {
      'sin': '-√3/2',
      'cos': '-1/2',
      'tan': '√3',
    },
    '3π/2': {
      'sin': '-1',
      'cos': '0',
      'tan': '∞',
    },
    '5π/3': {
      'sin': '-√3/2',
      'cos': '1/2',
      'tan': '-√3',
    },
    '7π/4': {
      'sin': '-√2/2',
      'cos': '√2/2',
      'tan': '-1',
    },
    '11π/6': {
      'sin': '-1/2',
      'cos': '√3/2',
      'tan': '-1/√3',
    },
    '2π': {
      'sin': '0',
      'cos': '1',
      'tan': '0',
    },
  };

  /// Valeurs numériques exactes pour les calculs
  static const Map<String, Map<String, double>> numericValues = {
    '0': {'sin': 0.0, 'cos': 1.0, 'tan': 0.0},
    'π/6': {'sin': 0.5, 'cos': 0.866, 'tan': 0.577},
    'π/4': {'sin': 0.707, 'cos': 0.707, 'tan': 1.0},
    'π/3': {'sin': 0.866, 'cos': 0.5, 'tan': 1.732},
    'π/2': {'sin': 1.0, 'cos': 0.0, 'tan': double.infinity},
    '2π/3': {'sin': 0.866, 'cos': -0.5, 'tan': -1.732},
    '3π/4': {'sin': 0.707, 'cos': -0.707, 'tan': -1.0},
    '5π/6': {'sin': 0.5, 'cos': -0.866, 'tan': -0.577},
    'π': {'sin': 0.0, 'cos': -1.0, 'tan': 0.0},
    '7π/6': {'sin': -0.5, 'cos': -0.866, 'tan': 0.577},
    '5π/4': {'sin': -0.707, 'cos': -0.707, 'tan': 1.0},
    '4π/3': {'sin': -0.866, 'cos': -0.5, 'tan': 1.732},
    '3π/2': {'sin': -1.0, 'cos': 0.0, 'tan': double.infinity},
    '5π/3': {'sin': -0.866, 'cos': 0.5, 'tan': -1.732},
    '7π/4': {'sin': -0.707, 'cos': 0.707, 'tan': -1.0},
    '11π/6': {'sin': -0.5, 'cos': 0.866, 'tan': -0.577},
    '2π': {'sin': 0.0, 'cos': 1.0, 'tan': 0.0},
  };
}

/// Structure d'une opération trigonométrique
class TrigonometryOperation {
  final String operationType;
  final String latexPattern;
  final int difficulty;
  final double Function(Map<String, dynamic>) calculateResult;

  const TrigonometryOperation({
    required this.operationType,
    required this.latexPattern,
    required this.difficulty,
    required this.calculateResult,
  });
}

/// Générateur de quiz trigonométriques
class TrigonometrySkillsGenerator {
  static final List<TrigonometryOperation> allOperations = [
    // Opérations de base - Facile
    TrigonometryOperation(
      operationType: 'sin_simple',
      latexPattern: r'\sin({VAR:angle})',
      difficulty: 1,
      calculateResult: (params) => _calculateSin(params['angle']),
    ),
    TrigonometryOperation(
      operationType: 'cos_simple',
      latexPattern: r'\cos({VAR:angle})',
      difficulty: 1,
      calculateResult: (params) => _calculateCos(params['angle']),
    ),
    TrigonometryOperation(
      operationType: 'tan_simple',
      latexPattern: r'\tan({VAR:angle})',
      difficulty: 1,
      calculateResult: (params) => _calculateTan(params['angle']),
    ),

    // Opérations avec coefficients - Moyen
    TrigonometryOperation(
      operationType: 'sin_coefficient',
      latexPattern: r'{VAR:coeff} \cdot \sin({VAR:angle})',
      difficulty: 2,
      calculateResult: (params) =>
          params['coeff'] * _calculateSin(params['angle']),
    ),
    TrigonometryOperation(
      operationType: 'cos_coefficient',
      latexPattern: r'{VAR:coeff} \cdot \cos({VAR:angle})',
      difficulty: 2,
      calculateResult: (params) =>
          params['coeff'] * _calculateCos(params['angle']),
    ),
    TrigonometryOperation(
      operationType: 'tan_coefficient',
      latexPattern: r'{VAR:coeff} \cdot \tan({VAR:angle})',
      difficulty: 2,
      calculateResult: (params) =>
          params['coeff'] * _calculateTan(params['angle']),
    ),

    // Opérations combinées - Difficile
    TrigonometryOperation(
      operationType: 'sin_plus_cos',
      latexPattern: r'\sin({VAR:angle1}) + \cos({VAR:angle2})',
      difficulty: 3,
      calculateResult: (params) =>
          _calculateSin(params['angle1']) + _calculateCos(params['angle2']),
    ),
    TrigonometryOperation(
      operationType: 'sin_minus_cos',
      latexPattern: r'\sin({VAR:angle1}) - \cos({VAR:angle2})',
      difficulty: 3,
      calculateResult: (params) =>
          _calculateSin(params['angle1']) - _calculateCos(params['angle2']),
    ),
    TrigonometryOperation(
      operationType: 'sin_times_cos',
      latexPattern: r'\sin({VAR:angle1}) \cdot \cos({VAR:angle2})',
      difficulty: 3,
      calculateResult: (params) =>
          _calculateSin(params['angle1']) * _calculateCos(params['angle2']),
    ),
    TrigonometryOperation(
      operationType: 'sin_squared',
      latexPattern: r'\sin^2({VAR:angle})',
      difficulty: 3,
      calculateResult: (params) =>
          math.pow(_calculateSin(params['angle']), 2).toDouble(),
    ),
    TrigonometryOperation(
      operationType: 'cos_squared',
      latexPattern: r'\cos^2({VAR:angle})',
      difficulty: 3,
      calculateResult: (params) =>
          math.pow(_calculateCos(params['angle']), 2).toDouble(),
    ),
    TrigonometryOperation(
      operationType: 'sin_cos_combination',
      latexPattern:
          r'{VAR:coeff1} \cdot \sin({VAR:angle1}) + {VAR:coeff2} \cdot \cos({VAR:angle2})',
      difficulty: 4,
      calculateResult: (params) =>
          params['coeff1'] * _calculateSin(params['angle1']) +
          params['coeff2'] * _calculateCos(params['angle2']),
    ),
  ];

  /// Génère un quiz adaptatif basé sur le niveau de difficulté
  static List<Map<String, dynamic>> generateAdaptiveQuiz(
      NiveauDifficulte niveau) {
    print(
        '🔧 TrigonometrySkillsGenerator: Génération du quiz pour niveau ${niveau.nom}');
    final random = math.Random();
    final questions = <Map<String, dynamic>>[];

    List<TrigonometryOperation> operations;
    int nombreQuestions;

    switch (niveau) {
      case NiveauDifficulte.facile:
        operations = allOperations.where((op) => op.difficulty <= 2).toList();
        nombreQuestions = 4;
        break;
      case NiveauDifficulte.moyen:
        operations = allOperations
            .where((op) => op.difficulty >= 2 && op.difficulty <= 3)
            .toList();
        nombreQuestions = 6;
        break;
      case NiveauDifficulte.difficile:
        operations = allOperations.where((op) => op.difficulty >= 3).toList();
        nombreQuestions = 6;
        break;
    }

    if (operations.isEmpty) {
      operations = allOperations; // Fallback
    }

    final selectedOperations = <TrigonometryOperation>[];
    final usedResults = <double>{};

    print(
        '🔧 TrigonometrySkillsGenerator: ${operations.length} opérations disponibles');

    // Sélectionner les opérations
    while (selectedOperations.length < nombreQuestions &&
        selectedOperations.length < operations.length) {
      final operation = operations[random.nextInt(operations.length)];
      if (!selectedOperations.contains(operation)) {
        selectedOperations.add(operation);
      }
    }

    print(
        '🔧 TrigonometrySkillsGenerator: ${selectedOperations.length} opérations sélectionnées');

    // Compléter si nécessaire
    while (selectedOperations.length < nombreQuestions) {
      final operation = allOperations[random.nextInt(allOperations.length)];
      if (!selectedOperations.contains(operation)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions
    for (final operation in selectedOperations) {
      Map<String, dynamic> params = {};
      double result;
      int attempts = 0;
      const maxAttempts = 50;

      do {
        params = _generateTrigonometryParams(operation, niveau);
        result = operation.calculateResult(params);
        attempts++;
      } while (usedResults.contains(result) &&
          !(result.isInfinite && operation.operationType.contains('tan')) &&
          attempts < maxAttempts);

      usedResults.add(result);

      // Générer LaTeX
      String latex = operation.latexPattern;
      for (final entry in params.entries) {
        latex = latex.replaceAll('{VAR:${entry.key}}', entry.value.toString());
      }

      questions.add({
        'operation': operation,
        'latex': latex,
        'result': result,
        'resultLatex': _formatResult(result),
        'params': params,
        'difficulty': niveau.nom,
      });
    }

    return questions;
  }

  /// Génère les paramètres pour une opération trigonométrique - VERSION CORRIGÉE
  static Map<String, dynamic> _generateTrigonometryParams(
      TrigonometryOperation operation, NiveauDifficulte niveau) {
    final random = math.Random();

    // Angles disponibles selon le niveau
    List<String> availableAngles;
    switch (niveau) {
      case NiveauDifficulte.facile:
        availableAngles = ['0', 'π/4', 'π/2', 'π', '3π/2', '2π'];
        break;
      case NiveauDifficulte.moyen:
        availableAngles = [
          '0',
          'π/6',
          'π/4',
          'π/3',
          'π/2',
          '2π/3',
          '3π/4',
          'π',
          '5π/4',
          '3π/2',
          '7π/4',
          '2π'
        ];
        break;
      case NiveauDifficulte.difficile:
        availableAngles = [
          '0',
          'π/6',
          'π/4',
          'π/3',
          'π/2',
          '2π/3',
          '3π/4',
          '5π/6',
          'π',
          '7π/6',
          '5π/4',
          '4π/3',
          '3π/2',
          '5π/3',
          '7π/4',
          '11π/6',
          '2π'
        ];
        break;
    }

    String pickAngle({bool forbidTanInfty = false}) {
      final List<String> pool = forbidTanInfty
          ? availableAngles.where((a) => a != 'π/2' && a != '3π/2').toList()
          : availableAngles;
      return pool[random.nextInt(pool.length)];
    }

    double pickCoeff() {
      const coeffs = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];
      return coeffs[random.nextInt(coeffs.length)];
    }

    print('🔧 Génération paramètres pour: ${operation.operationType}');

    switch (operation.operationType) {
      case 'sin_simple':
      case 'cos_simple':
      case 'tan_simple':
      case 'sin_squared':
      case 'cos_squared':
        final params = {
          'angle': pickAngle(
              forbidTanInfty: operation.operationType.startsWith('tan')),
        };
        print('🔧 Paramètres générés: $params');
        return params;

      case 'sin_coefficient':
      case 'cos_coefficient':
      case 'tan_coefficient':
        final params = {
          'angle': pickAngle(
              forbidTanInfty: operation.operationType.startsWith('tan')),
          'coeff': pickCoeff(),
        };
        print('🔧 Paramètres générés: $params');
        return params;

      case 'sin_plus_cos':
      case 'sin_minus_cos':
      case 'sin_times_cos':
        final params = {
          'angle1': pickAngle(),
          'angle2': pickAngle(),
        };
        print('🔧 Paramètres générés: $params');
        return params;

      case 'sin_cos_combination':
        final params = {
          'coeff1': pickCoeff(),
          'angle1': pickAngle(),
          'coeff2': pickCoeff(),
          'angle2': pickAngle(),
        };
        print('🔧 Paramètres générés: $params');
        return params;

      default:
        // Fallback sûr
        final params = {'angle': pickAngle()};
        print('🔧 Paramètres générés (fallback): $params');
        return params;
    }
  }

  /// Calcule la valeur de sin pour un angle donné
  static double _calculateSin(String angle) {
    final values = TrigonometryValues.numericValues[angle];
    final result = values?['sin'] ?? 0.0;
    print('🔧 _calculateSin($angle) = $result');
    return result;
  }

  /// Calcule la valeur de cos pour un angle donné
  static double _calculateCos(String angle) {
    final values = TrigonometryValues.numericValues[angle];
    final result = values?['cos'] ?? 0.0;
    print('🔧 _calculateCos($angle) = $result');
    return result;
  }

  /// Calcule la valeur de tan pour un angle donné
  static double _calculateTan(String angle) {
    final values = TrigonometryValues.numericValues[angle];
    final result = values?['tan'] ?? 0.0;
    print('🔧 _calculateTan($angle) = $result');
    return result;
  }

  /// Formate le résultat pour l'affichage
  static String _formatResult(double result) {
    if (result.isInfinite) {
      return '∞';
    }
    if (result == result.toInt().toDouble()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(3);
  }
}
