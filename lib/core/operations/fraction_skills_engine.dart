/// <cursor>
///
/// MOTEUR D'OPÉRATIONS SUR LES FRACTIONS
///
/// Générateur d'opérations mathématiques spécialisé dans les fractions.
/// Crée des opérations de calcul sur les fractions avec résultats fractionnaires.
/// Structure similaire à numerical_skills_engine mais adaptée aux fractions.
///
/// COMPOSANTS PRINCIPAUX:
/// - FractionOperation: Structure pour les opérations sur fractions
/// - FractionSkillsGenerator: Générateur de quiz fractions
/// - Opérations: Sommes, produits, quotients, différences, puissances, simplifications
/// - Validation: Vérification des résultats fractionnaires
/// - Niveaux de difficulté: Support enum NiveauDifficulte
///
/// ÉTAT ACTUEL:
/// - Opérations de base sur les fractions implémentées
/// - Génération de résultats fractionnaires irréductibles
/// - Support des opérations complexes (puissances, simplifications)
/// - Système de validation des résultats uniques
/// - Support niveaux de difficulté (Facile, Moyen, Difficile)
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU - Support niveaux de difficulté pour quizz
/// - Méthodes generateQuizByDifficultyLevel() et generateAdaptiveQuiz()
/// - Adaptation nombre questions selon niveau (4-8 questions)
/// - Filtrage opérations selon difficulté
/// - 2025-01-27: Création du moteur d'opérations sur les fractions
/// - Implémentation des opérations de base (+, -, ×, ÷)
/// - Ajout des puissances et simplifications de fractions
///
/// 🔧 POINTS D'ATTENTION:
/// - Gestion des fractions irréductibles avec PGCD
/// - Éviter les divisions par zéro
/// - Résultats fractionnaires uniques pour éviter les doublons
/// - Complexité des calculs de simplification
/// - Niveaux: Facile (4 questions), Moyen (6), Difficile (8)
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration avec le système de progression
/// - Ajout d'opérations plus complexes (racines de fractions)
/// - Optimisation des algorithmes de génération
/// - Ajouter statistiques par niveau
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/presentation/screens/fraction_skills_screen.dart: Interface utilisateur
/// - lib/core/operations/numerical_skills_engine.dart: Moteur de référence
/// - lib/features/puzzle/domain/models/game_state.dart: NiveauDifficulte
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27 22:30
/// </cursor>

import 'dart:math' as math;

import 'package:luchy/features/puzzle/domain/models/game_state.dart';

import 'base_skills_engine.dart';

class Fraction {
  final int numerator;
  final int denominator;

  const Fraction(this.numerator, this.denominator);

  /// Crée une fraction irréductible
  factory Fraction.fromReduced(int num, int den) {
    if (den == 0) throw ArgumentError('Dénominateur ne peut pas être zéro');
    if (den < 0) {
      num = -num;
      den = -den;
    }
    final gcd = _gcd(num.abs(), den.abs());
    return Fraction(num ~/ gcd, den ~/ gcd);
  }

  /// Calcule le PGCD de deux nombres
  static int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Addition de fractions
  Fraction operator +(Fraction other) {
    final newNum =
        numerator * other.denominator + other.numerator * denominator;
    final newDen = denominator * other.denominator;
    return Fraction.fromReduced(newNum, newDen);
  }

  /// Soustraction de fractions
  Fraction operator -(Fraction other) {
    final newNum =
        numerator * other.denominator - other.numerator * denominator;
    final newDen = denominator * other.denominator;
    return Fraction.fromReduced(newNum, newDen);
  }

  /// Multiplication de fractions
  Fraction operator *(Fraction other) {
    final newNum = numerator * other.numerator;
    final newDen = denominator * other.denominator;
    return Fraction.fromReduced(newNum, newDen);
  }

  /// Division de fractions
  Fraction operator /(Fraction other) {
    if (other.numerator == 0) throw ArgumentError('Division par zéro');
    final newNum = numerator * other.denominator;
    final newDen = denominator * other.numerator;
    return Fraction.fromReduced(newNum, newDen);
  }

  /// Puissance d'une fraction
  Fraction power(int exponent) {
    if (exponent == 0) return const Fraction(1, 1);
    if (exponent < 0) {
      return Fraction.fromReduced(denominator, numerator).power(-exponent);
    }
    final newNum = math.pow(numerator, exponent).toInt();
    final newDen = math.pow(denominator, exponent).toInt();
    return Fraction.fromReduced(newNum, newDen);
  }

  /// Vérifie si la fraction est égale à une autre
  @override
  bool operator ==(Object other) {
    if (other is! Fraction) return false;
    return numerator == other.numerator && denominator == other.denominator;
  }

  /// Hash code pour l'égalité
  @override
  int get hashCode => Object.hash(numerator, denominator);

  /// Représentation en chaîne
  @override
  String toString() {
    if (denominator == 1) return numerator.toString();
    return '$numerator/$denominator';
  }

  /// Représentation LaTeX
  String toLatex() {
    if (denominator == 1) return numerator.toString();
    return '\\frac{$numerator}{$denominator}';
  }

  /// Vérifie si la fraction est un entier
  bool isInteger() => denominator == 1;

  /// Valeur décimale de la fraction
  double toDouble() => numerator / denominator;
}

/// Template d'opération pour les compétences sur les fractions
class FractionOperation extends BaseOperationTemplate {
  final Function(Map<String, dynamic>) _calculateResult;

  const FractionOperation({
    required String operationType,
    required String latexPattern,
    required String description,
    required int difficulty,
    required Function(Map<String, dynamic>) calculateResult,
  })  : _calculateResult = calculateResult,
        super(
          operationType: operationType,
          latexPattern: latexPattern,
          description: description,
          parameters: const [], // Les fractions n'ont pas de paramètres prédéfinis
          difficulty: difficulty,
        );

  @override
  dynamic calculateResult(Map<String, dynamic> params) {
    return _calculateResult(params);
  }
}

/// Liste des opérations sur les fractions supportées
final List<FractionOperation> allFractionOperations = [
  // 1. SOMME DE FRACTIONS
  FractionOperation(
    operationType: 'somme_fractions',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}} + \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Somme de deux fractions',
    difficulty: 2,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      return frac1 + frac2;
    },
  ),

  // 2. DIFFÉRENCE DE FRACTIONS
  FractionOperation(
    operationType: 'difference_fractions',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}} - \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Différence de deux fractions',
    difficulty: 2,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      return frac1 - frac2;
    },
  ),

  // 3. PRODUIT DE FRACTIONS
  FractionOperation(
    operationType: 'produit_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Produit de deux fractions',
    difficulty: 2,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      return frac1 * frac2;
    },
  ),

  // 4. QUOTIENT DE FRACTIONS
  FractionOperation(
    operationType: 'quotient_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\div \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Quotient de deux fractions',
    difficulty: 3,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      return frac1 / frac2;
    },
  ),

  // 4b. QUOTIENT DE FRACTIONS (fraction sur fraction)
  FractionOperation(
    operationType: 'quotient_fraction_sur_fraction',
    latexPattern:
        '\\frac{\\frac{{{VAR:a}}}{{{VAR:b}}}}{\\frac{{{VAR:c}}}{{{VAR:d}}}}',
    description: 'Fraction sur fraction',
    difficulty: 3,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      return frac1 / frac2;
    },
  ),

  // 5. PUISSANCE DE FRACTION
  FractionOperation(
    operationType: 'puissance_fraction',
    latexPattern: '\\left(\\frac{{{VAR:a}}}{{{VAR:b}}}\\right)^{{{VAR:n}}}',
    description: 'Puissance d\'une fraction',
    difficulty: 3,
    calculateResult: (params) {
      final frac = params['frac']! as Fraction;
      final exponent = params['exponent']! as int;
      return frac.power(exponent);
    },
  ),

  // 6. SIMPLIFICATION DE FRACTION
  FractionOperation(
    operationType: 'simplification_fraction',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}}',
    description: 'Simplification d\'une fraction',
    difficulty: 1,
    calculateResult: (params) {
      final frac = params['frac']! as Fraction;
      return Fraction.fromReduced(frac.numerator, frac.denominator);
    },
  ),

  // 7. SOMME DE TROIS FRACTIONS
  FractionOperation(
    operationType: 'somme_trois_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} + \\frac{{{VAR:c}}}{{{VAR:d}}} + \\frac{{{VAR:e}}}{{{VAR:f}}}',
    description: 'Somme de trois fractions',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 + frac2 + frac3;
    },
  ),

  // 8. PRODUIT DE TROIS FRACTIONS
  FractionOperation(
    operationType: 'produit_trois_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\frac{{{VAR:c}}}{{{VAR:d}}} \\times \\frac{{{VAR:e}}}{{{VAR:f}}}',
    description: 'Produit de trois fractions',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 * frac2 * frac3;
    },
  ),

  // 9. PRODUIT AVEC SOMME ENTRE PARENTHÈSES
  FractionOperation(
    operationType: 'produit_somme_parentheses',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\left(\\frac{{{VAR:c}}}{{{VAR:d}}} + \\frac{{{VAR:e}}}{{{VAR:f}}}\\right)',
    description: 'Produit avec somme entre parenthèses',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 * (frac2 + frac3);
    },
  ),

  // 10. PRODUIT AVEC DIFFÉRENCE ENTRE PARENTHÈSES
  FractionOperation(
    operationType: 'produit_difference_parentheses',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\left(\\frac{{{VAR:c}}}{{{VAR:d}}} - \\frac{{{VAR:e}}}{{{VAR:f}}}\\right)',
    description: 'Produit avec différence entre parenthèses',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 * (frac2 - frac3);
    },
  ),

  // 11. SOMME AVEC PRODUIT ENTRE PARENTHÈSES
  FractionOperation(
    operationType: 'somme_produit_parentheses',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} + \\left(\\frac{{{VAR:c}}}{{{VAR:d}}} \\times \\frac{{{VAR:e}}}{{{VAR:f}}}\\right)',
    description: 'Somme avec produit entre parenthèses',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 + (frac2 * frac3);
    },
  ),

  // 12. DIFFÉRENCE AVEC PRODUIT ENTRE PARENTHÈSES
  FractionOperation(
    operationType: 'difference_produit_parentheses',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} - \\left(\\frac{{{VAR:c}}}{{{VAR:d}}} \\times \\frac{{{VAR:e}}}{{{VAR:f}}}\\right)',
    description: 'Différence avec produit entre parenthèses',
    difficulty: 4,
    calculateResult: (params) {
      final frac1 = params['frac1']! as Fraction;
      final frac2 = params['frac2']! as Fraction;
      final frac3 = params['frac3']! as Fraction;
      return frac1 - (frac2 * frac3);
    },
  ),
];

/// Générateur de quiz d'opérations sur les fractions
class FractionSkillsGenerator extends BaseSkillsGenerator {
  static final math.Random _random = math.Random();

  /// Génère une fraction aléatoire simple
  static Fraction _generateSimpleFraction() {
    final numerator = 1 + _random.nextInt(10); // 1 à 10
    final denominator = 2 + _random.nextInt(9); // 2 à 10
    return Fraction.fromReduced(numerator, denominator);
  }

  /// Génère une fraction aléatoire pour les quotients (évite le numérateur zéro)
  static Fraction _generateNonZeroFraction() {
    final numerator = 1 + _random.nextInt(10); // 1 à 10 (jamais zéro)
    final denominator = 2 + _random.nextInt(9); // 2 à 10
    return Fraction.fromReduced(numerator, denominator);
  }

  /// Génère des paramètres pour une opération de fractions
  static Map<String, dynamic> _generateFractionParams(String operationType,
      [math.Random? random]) {
    final rng = random ?? _random;
    switch (operationType) {
      case 'somme_fractions':
      case 'difference_fractions':
      case 'produit_fractions':
      case 'quotient_fractions':
      case 'quotient_fraction_sur_fraction':
        final frac1 = _generateSimpleFraction();
        final frac2 = _generateNonZeroFraction(); // Évite la division par zéro
        return {
          'frac1': frac1,
          'frac2': frac2,
          'a': frac1.numerator,
          'b': frac1.denominator,
          'c': frac2.numerator,
          'd': frac2.denominator,
        };

      case 'puissance_fraction':
        final frac = _generateSimpleFraction();
        final exponent = 2 + rng.nextInt(3); // 2 à 4
        return {
          'frac': frac,
          'exponent': exponent,
          'a': frac.numerator,
          'b': frac.denominator,
          'n': exponent,
        };

      case 'simplification_fraction':
        // Générer une fraction non simplifiée
        final numerator = (2 + rng.nextInt(8)) * (2 + rng.nextInt(8));
        final denominator = (2 + rng.nextInt(8)) * (2 + rng.nextInt(8));
        final frac = Fraction(numerator, denominator);
        return {
          'frac': frac,
          'a': numerator,
          'b': denominator,
        };

      case 'somme_trois_fractions':
      case 'produit_trois_fractions':
      case 'produit_somme_parentheses':
      case 'produit_difference_parentheses':
      case 'somme_produit_parentheses':
      case 'difference_produit_parentheses':
        final frac1 = _generateSimpleFraction();
        final frac2 = _generateSimpleFraction();
        final frac3 = _generateSimpleFraction();
        return {
          'frac1': frac1,
          'frac2': frac2,
          'frac3': frac3,
          'a': frac1.numerator,
          'b': frac1.denominator,
          'c': frac2.numerator,
          'd': frac2.denominator,
          'e': frac3.numerator,
          'f': frac3.denominator,
        };

      default:
        return {};
    }
  }

  /// Génère un quiz de 6 opérations sur les fractions
  /// Génère un quiz en utilisant la base commune
  static List<Map<String, dynamic>> generateQuizWithBase() {
    return BaseSkillsGenerator.generateQuiz(allFractionOperations, 6);
  }

  static List<Map<String, dynamic>> generateQuiz() {
    final selectedOperations = <FractionOperation>[];
    final usedResults = <String>{};

    // Sélectionner 6 opérations différentes
    while (selectedOperations.length < 6) {
      final operation =
          allFractionOperations[_random.nextInt(allFractionOperations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions
    final questions = <Map<String, dynamic>>[];

    for (final operation in selectedOperations) {
      Map<String, dynamic> params = {};
      Fraction result;
      int attempts = 0;
      const maxAttempts = 50;

      // Générer des paramètres jusqu'à obtenir un résultat unique
      do {
        params = _generateFractionParams(operation.operationType);
        result = operation.calculateResult(params);
        attempts++;
      } while (
          usedResults.contains(result.toString()) && attempts < maxAttempts);

      // Si on n'a pas trouvé de résultat valide, utiliser une opération simple
      if (attempts >= maxAttempts) {
        final simpleOperation = allFractionOperations.firstWhere(
          (op) => op.operationType == 'somme_fractions',
          orElse: () => allFractionOperations.first,
        );
        params = _generateFractionParams('somme_fractions');
        result =
            simpleOperation.calculateResult(params as Map<String, Fraction>);
      }

      usedResults.add(result.toString());

      // Remplacer les variables dans le LaTeX
      String latex = operation.latexPattern;
      for (final entry in params.entries) {
        if (entry.value is int) {
          latex =
              latex.replaceAll('{VAR:${entry.key}}', entry.value.toString());
        }
      }

      questions.add({
        'operation': operation,
        'latex': latex,
        'result': result,
        'resultLatex': result.toLatex(),
        'params': params,
      });
    }

    return questions;
  }

  /// Génère un quiz avec un niveau de difficulté spécifique
  static List<Map<String, dynamic>> generateQuizByDifficulty(int difficulty) {
    final operations = allFractionOperations
        .where((op) => op.difficulty == difficulty)
        .toList();
    if (operations.isEmpty) {
      return generateQuiz(); // Fallback sur toutes les opérations
    }

    final selectedOperations = <FractionOperation>[];
    final usedResults = <String>{};

    // Sélectionner 6 opérations du niveau demandé
    while (selectedOperations.length < 6 &&
        selectedOperations.length < operations.length) {
      final operation = operations[_random.nextInt(operations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Compléter avec d'autres opérations si nécessaire
    while (selectedOperations.length < 6) {
      final operation =
          allFractionOperations[_random.nextInt(allFractionOperations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions (même logique que generateQuiz)
    final questions = <Map<String, dynamic>>[];

    for (final operation in selectedOperations) {
      Map<String, dynamic> params = {};
      Fraction result;
      int attempts = 0;
      const maxAttempts = 50;

      do {
        params = _generateFractionParams(operation.operationType);
        result = operation.calculateResult(params);
        attempts++;
      } while (
          usedResults.contains(result.toString()) && attempts < maxAttempts);

      if (attempts >= maxAttempts) {
        final simpleOperation = allFractionOperations.firstWhere(
          (op) => op.operationType == 'somme_fractions',
          orElse: () => allFractionOperations.first,
        );
        params = _generateFractionParams('somme_fractions');
        result =
            simpleOperation.calculateResult(params as Map<String, Fraction>);
      }

      usedResults.add(result.toString());

      String latex = operation.latexPattern;
      for (final entry in params.entries) {
        if (entry.value is int) {
          latex =
              latex.replaceAll('{VAR:${entry.key}}', entry.value.toString());
        }
      }

      questions.add({
        'operation': operation,
        'latex': latex,
        'result': result,
        'resultLatex': result.toLatex(),
        'params': params,
      });
    }

    return questions;
  }

  /// Génère un quiz adapté au niveau de difficulté
  static List<Map<String, dynamic>> generateAdaptiveQuiz(
      NiveauDifficulte niveau) {
    final random = math.Random();
    final questions = <Map<String, dynamic>>[];

    // Sélectionner les opérations selon le niveau éducatif
    List<FractionOperation> operations;
    int nombreQuestions;

    // Sélectionner les opérations selon le niveau
    switch (niveau) {
      case NiveauDifficulte.facile:
        operations =
            allFractionOperations.where((op) => op.difficulty <= 2).toList();
        nombreQuestions = 4; // Moins de questions pour commencer
        break;
      case NiveauDifficulte.moyen:
        operations = allFractionOperations
            .where((op) => op.difficulty >= 2 && op.difficulty <= 4)
            .toList();
        nombreQuestions = 6; // Nombre standard
        break;
      case NiveauDifficulte.difficile:
        operations =
            allFractionOperations.where((op) => op.difficulty >= 3).toList();
        nombreQuestions = 6; // Maximum 6 questions
        break;
    }

    if (operations.isEmpty) {
      operations = allFractionOperations; // Fallback
    }

    final selectedOperations = <FractionOperation>[];
    final usedResults = <String>{}; // Utiliser String pour les fractions

    // Sélectionner les opérations
    while (selectedOperations.length < nombreQuestions &&
        selectedOperations.length < operations.length) {
      final operation = operations[random.nextInt(operations.length)];
      if (!selectedOperations.contains(operation)) {
        selectedOperations.add(operation);
      }
    }

    // Compléter si nécessaire avec des opérations aléatoires
    while (selectedOperations.length < nombreQuestions) {
      final operation =
          allFractionOperations[random.nextInt(allFractionOperations.length)];
      if (!selectedOperations.contains(operation)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions
    for (final operation in selectedOperations) {
      Map<String, dynamic> params = {};
      Fraction result;
      int attempts = 0;
      const maxAttempts = 50;

      do {
        params = _generateFractionParams(operation.operationType, random);
        result = operation.calculateResult(params);
        attempts++;
      } while (
          usedResults.contains(result.toString()) && attempts < maxAttempts);

      if (attempts >= maxAttempts) {
        // Si on n'arrive pas à générer un résultat unique, on continue quand même
        usedResults.add(result.toString());
      } else {
        usedResults.add(result.toString());
      }

      // Générer LaTeX
      String latex = operation.latexPattern;
      for (final entry in params.entries) {
        String value;
        if (entry.value is Fraction) {
          value = (entry.value as Fraction).toLatex();
        } else {
          value = entry.value.toString();
        }
        latex = latex.replaceAll('{VAR:${entry.key}}', value);
      }

      questions.add({
        'operation': operation,
        'latex': latex,
        'result': result,
        'resultLatex': result.toLatex(),
        'params': params,
        'difficulty': niveau.nom, // Ajouter le niveau pour l'affichage
      });
    }

    return questions;
  }
}
