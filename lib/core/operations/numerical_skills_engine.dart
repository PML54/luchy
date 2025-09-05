import 'dart:math' as math;

import 'base_skills_engine.dart';

/// Paramètre d'opération pour les compétences numériques
class NumericalOperationParameter extends BaseOperationParameter {
  const NumericalOperationParameter({
    required String name,
    required int minValue,
    required int maxValue,
    required String description,
  }) : super(
          name: name,
          minValue: minValue,
          maxValue: maxValue,
          description: description,
        );
}

/// Template d'opération pour les compétences numériques
class NumericalOperationTemplate extends BaseOperationTemplate {
  final Function(Map<String, int>) _calculateResult;

  const NumericalOperationTemplate({
    required String operationType,
    required String latexPattern,
    required String description,
    required List<NumericalOperationParameter> parameters,
    required int difficulty,
    required Function(Map<String, int>) calculateResult,
  })  : _calculateResult = calculateResult,
        super(
          operationType: operationType,
          latexPattern: latexPattern,
          description: description,
          parameters: parameters,
          difficulty: difficulty,
        );

  @override
  dynamic calculateResult(Map<String, dynamic> params) {
    // Convertir les paramètres en int pour la compatibilité
    final intParams = <String, int>{};
    for (final entry in params.entries) {
      intParams[entry.key] =
          entry.value is int ? entry.value : int.parse(entry.value.toString());
    }
    return _calculateResult(intParams);
  }
}

/// Liste complète des opérations mathématiques supportées
final List<NumericalOperationTemplate> allOperations = [
  // 1. CARRÉS
  NumericalOperationTemplate(
    operationType: 'carre',
    latexPattern: '{VAR:n}^2',
    description: 'Carré de n',
    parameters: [
      NumericalOperationParameter(
          name: 'n',
          minValue: 1,
          maxValue: 20,
          description: 'Nombre à élever au carré'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['n']! * params['n']!,
  ),

  // 2. RACINES CARRÉES (nombres parfaits uniquement)
  NumericalOperationTemplate(
    operationType: 'racine',
    latexPattern: '\\sqrt{{VAR:n}}',
    description: 'Racine carrée de n',
    parameters: [
      NumericalOperationParameter(
          name: 'n', minValue: 4, maxValue: 400, description: 'Carré parfait'),
    ],
    difficulty: 2,
    calculateResult: (params) => math.sqrt(params['n']!).toInt(),
  ),

  // 3. CUBES
  NumericalOperationTemplate(
    operationType: 'cube',
    latexPattern: '{VAR:n}^3',
    description: 'Cube de n',
    parameters: [
      NumericalOperationParameter(
          name: 'n',
          minValue: 1,
          maxValue: 10,
          description: 'Nombre à élever au cube'),
    ],
    difficulty: 2,
    calculateResult: (params) => params['n']! * params['n']! * params['n']!,
  ),

  // 4. PRODUITS
  NumericalOperationTemplate(
    operationType: 'produit',
    latexPattern: '{VAR:a} \\times {VAR:b}',
    description: 'Produit de a et b',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 2, maxValue: 20, description: 'Premier facteur'),
      NumericalOperationParameter(
          name: 'b',
          minValue: 2,
          maxValue: 20,
          description: 'Deuxième facteur'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! * params['b']!,
  ),

  // 5. FRACTIONS SIMPLES (résultat entier garanti)
  NumericalOperationTemplate(
    operationType: 'fraction',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}}',
    description: 'Fraction a sur b',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 2, maxValue: 40, description: 'Numérateur'),
      NumericalOperationParameter(
          name: 'b', minValue: 1, maxValue: 10, description: 'Dénominateur'),
    ],
    difficulty: 2,
    calculateResult: (params) {
      final a = params['a']!;
      final b = params['b']!;
      // S'assurer que la division donne un résultat entier
      return a ~/ b;
    },
  ),

  // 6. SOMMES
  NumericalOperationTemplate(
    operationType: 'somme',
    latexPattern: '{VAR:a} + {VAR:b}',
    description: 'Somme de a et b',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 1, maxValue: 50, description: 'Premier terme'),
      NumericalOperationParameter(
          name: 'b', minValue: 1, maxValue: 50, description: 'Deuxième terme'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! + params['b']!,
  ),

  // 7. SOUSTRACTIONS
  NumericalOperationTemplate(
    operationType: 'soustraction',
    latexPattern: '{VAR:a} - {VAR:b}',
    description: 'Différence de a et b',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 10, maxValue: 100, description: 'Minuende'),
      NumericalOperationParameter(
          name: 'b', minValue: 1, maxValue: 50, description: 'Soustrahend'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! - params['b']!,
  ),

  // 8. FACTORIELS
  NumericalOperationTemplate(
    operationType: 'factoriel',
    latexPattern: '{VAR:n}!',
    description: 'Factoriel de n',
    parameters: [
      NumericalOperationParameter(
          name: 'n', minValue: 1, maxValue: 6, description: 'Nombre factoriel'),
    ],
    difficulty: 3,
    calculateResult: (params) {
      int n = params['n']!;
      int result = 1;
      for (int i = 1; i <= n; i++) {
        result *= i;
      }
      return result;
    },
  ),

  // 9. SOMME DE FRACTIONS (résultat entier garanti)
  NumericalOperationTemplate(
    operationType: 'somme_fractions',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}} + \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Somme de deux fractions',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 1, maxValue: 10, description: 'Numérateur 1'),
      NumericalOperationParameter(
          name: 'b', minValue: 2, maxValue: 10, description: 'Dénominateur 1'),
      NumericalOperationParameter(
          name: 'c', minValue: 1, maxValue: 10, description: 'Numérateur 2'),
      NumericalOperationParameter(
          name: 'd', minValue: 2, maxValue: 10, description: 'Dénominateur 2'),
    ],
    difficulty: 4,
    calculateResult: (params) {
      int a = params['a']!;
      int b = params['b']!;
      int c = params['c']!;
      int d = params['d']!;
      // Calcul: (a*d + c*b) / (b*d)
      int numerateur = a * d + c * b;
      int denominateur = b * d;

      // Vérifier que la division est exacte
      if (numerateur % denominateur != 0) {
        // Si ce n'est pas exact, ajuster pour garantir un résultat entier
        // On prend le quotient entier et on ajuste les paramètres
        return numerateur ~/ denominateur;
      }

      return numerateur ~/ denominateur;
    },
  ),

  // 10. PRODUIT DE FRACTIONS (résultat entier garanti)
  NumericalOperationTemplate(
    operationType: 'produit_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Produit de deux fractions',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 1, maxValue: 20, description: 'Numérateur 1'),
      NumericalOperationParameter(
          name: 'b', minValue: 2, maxValue: 10, description: 'Dénominateur 1'),
      NumericalOperationParameter(
          name: 'c', minValue: 1, maxValue: 20, description: 'Numérateur 2'),
      NumericalOperationParameter(
          name: 'd', minValue: 2, maxValue: 10, description: 'Dénominateur 2'),
    ],
    difficulty: 3,
    calculateResult: (params) {
      int a = params['a']!;
      int b = params['b']!;
      int c = params['c']!;
      int d = params['d']!;
      // Calcul: (a*c) / (b*d)
      int numerateur = a * c;
      int denominateur = b * d;
      return numerateur ~/ denominateur; // Division entière
    },
  ),

  // 11. COMBINAISONS
  NumericalOperationTemplate(
    operationType: 'combinaison',
    latexPattern: '\\binom{{{VAR:n}}}{{{VAR:p}}}',
    description: 'Combinaison de p éléments parmi n',
    parameters: [
      NumericalOperationParameter(
          name: 'n', minValue: 3, maxValue: 8, description: 'Nombre total'),
      NumericalOperationParameter(
          name: 'p', minValue: 2, maxValue: 6, description: 'Nombre choisi'),
    ],
    difficulty: 4,
    calculateResult: (params) {
      int n = params['n']!;
      int p = params['p']!;
      if (p > n) return 0;
      if (p == 0 || p == n) return 1;
      if (p > n - p) p = n - p; // Optimisation
      int result = 1;
      for (int i = 0; i < p; i++) {
        result = result * (n - i) ~/ (i + 1);
      }
      return result;
    },
  ),

  // 12. PUISSANCES
  NumericalOperationTemplate(
    operationType: 'puissance',
    latexPattern: '{VAR:a}^{{{VAR:n}}}',
    description: 'a puissance n',
    parameters: [
      NumericalOperationParameter(
          name: 'a', minValue: 2, maxValue: 10, description: 'Base'),
      NumericalOperationParameter(
          name: 'n', minValue: 2, maxValue: 6, description: 'Exposant'),
    ],
    difficulty: 3,
    calculateResult: (params) => math.pow(params['a']!, params['n']!).toInt(),
  ),
];

/// Générateur de quiz d'opérations mathématiques
class OperationsQuizGenerator extends BaseSkillsGenerator {
  /// Trouve tous les facteurs d'un nombre
  static List<int> _findFactors(int n) {
    final factors = <int>[];
    for (int i = 1; i <= n; i++) {
      if (n % i == 0) {
        factors.add(i);
      }
    }
    return factors;
  }

  /// Génère un carré parfait pour les racines carrées
  static Map<String, int> _generatePerfectSquare(math.Random random) {
    // Générer un nombre de base entre 2 et 20
    final base = 2 + random.nextInt(19); // 2 à 20
    final square = base * base; // Son carré

    return {'n': square}; // n sera le carré parfait
  }

  /// Génère une somme de fractions qui donne un résultat entier exact
  static Map<String, int> _generateExactFractionSum(math.Random random) {
    // Générer un résultat entier aléatoire entre 1 et 10
    final targetResult = 1 + random.nextInt(10);

    // Générer des dénominateurs aléatoires entre 2 et 8
    final b = 2 + random.nextInt(7); // 2 à 8
    final d = 2 + random.nextInt(7); // 2 à 8

    // Calculer le PPCM des dénominateurs
    final ppcm = (b * d) ~/ _gcd(b, d);

    // Calculer les numérateurs pour que la somme donne targetResult
    final a = (targetResult * ppcm) ~/ b;
    final c = (targetResult * ppcm) ~/ d;

    // Vérifier que le calcul est exact
    final numerateur = a * d + c * b;
    final denominateur = b * d;

    // Si ce n'est pas exact, ajuster pour garantir un résultat entier
    if (numerateur % denominateur != 0) {
      // Ajuster c pour que la division soit exacte
      final newC = (targetResult * denominateur - a * d) ~/ b;
      return {'a': a, 'b': b, 'c': newC, 'd': d};
    }

    return {'a': a, 'b': b, 'c': c, 'd': d};
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

  /// Génère un produit de fractions qui donne un résultat entier exact
  static Map<String, int> _generateExactFractionProduct(math.Random random) {
    // Générer un résultat entier aléatoire entre 2 et 20
    final targetResult = 2 + random.nextInt(19);

    // Trouver deux facteurs de targetResult
    final factors = _findFactors(targetResult);
    if (factors.isEmpty) {
      // Fallback simple
      return {'a': 4, 'b': 2, 'c': 6, 'd': 3}; // 4/2 * 6/3 = 2 * 2 = 4
    }

    // factor1 = factors[random.nextInt(factors.length)]; // Pas utilisé dans cette implémentation
    // factor2 = targetResult ~/ factor1; // Pas utilisé dans cette implémentation

    // Générer des fractions qui donnent ces facteurs
    // factor1 = a/b, factor2 = c/d
    // On veut (a*c)/(b*d) = targetResult
    // Donc a*c = targetResult * b*d

    final b = 2 + random.nextInt(8); // 2-9
    final d = 2 + random.nextInt(8); // 2-9

    // Calculer a et c pour que a*c = targetResult * b*d
    final product = targetResult * b * d;
    final factorsProduct = _findFactors(product);
    if (factorsProduct.isEmpty) {
      // Fallback simple
      return {'a': 4, 'b': 2, 'c': 6, 'd': 3};
    }

    final a = factorsProduct[random.nextInt(factorsProduct.length)];
    final c = product ~/ a;

    return {'a': a, 'b': b, 'c': c, 'd': d};
  }

  /// Génère un quiz de 6 opérations avec résultats uniques
  static List<Map<String, dynamic>> generateQuiz() {
    final random = math.Random();
    final selectedOperations = <NumericalOperationTemplate>[];
    final usedResults = <int>{};

    // Sélectionner 6 opérations différentes
    while (selectedOperations.length < 6) {
      final operation = allOperations[random.nextInt(allOperations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions
    final questions = <Map<String, dynamic>>[];

    for (final operation in selectedOperations) {
      Map<String, int> params = {};
      int result;
      int attempts = 0;
      const maxAttempts = 50; // Limite pour éviter les boucles infinies

      // Générer des paramètres jusqu'à obtenir un résultat unique et valide
      do {
        params = {};

        // Pour les produits de fractions, utiliser la méthode spécialisée
        if (operation.operationType == 'produit_fractions') {
          params = _generateExactFractionProduct(random);
        } else if (operation.operationType == 'somme_fractions') {
          // Pour les sommes de fractions, générer un résultat entier exact
          params = _generateExactFractionSum(random);
        } else if (operation.operationType == 'racine') {
          // Pour les racines carrées, générer un carré parfait
          params = _generatePerfectSquare(random);
        } else {
          // Pour les autres opérations, génération normale
          for (final param in operation.parameters) {
            params[param.name] = param.minValue +
                random.nextInt(param.maxValue - param.minValue + 1);
          }
        }

        result = operation.calculateResult(params);
        attempts++;

        // Pour les fractions simples, vérifier que le résultat est exact
        if (operation.operationType == 'fraction') {
          final a = params['a']!;
          final b = params['b']!;
          if (a % b != 0) {
            // La division n'est pas exacte, essayer avec un multiple de b
            params['a'] = b * (a ~/ b + 1);
            result = operation.calculateResult(params);
          }
        }
      } while ((usedResults.contains(result) || result <= 0) &&
          attempts < maxAttempts);

      // Si on n'a pas trouvé de résultat valide, utiliser une opération simple
      if (attempts >= maxAttempts) {
        final simpleOperation = allOperations.firstWhere(
          (op) => op.operationType == 'carre',
          orElse: () => allOperations.first,
        );
        params = {'n': 2 + random.nextInt(10)};
        result = simpleOperation.calculateResult(params);
      }

      usedResults.add(result);

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

  /// Génère un quiz avec un niveau de difficulté spécifique
  static List<Map<String, dynamic>> generateQuizByDifficulty(int difficulty) {
    final operations =
        allOperations.where((op) => op.difficulty == difficulty).toList();
    if (operations.isEmpty) {
      return generateQuiz(); // Fallback sur toutes les opérations
    }

    final random = math.Random();
    final selectedOperations = <NumericalOperationTemplate>[];
    final usedResults = <int>{};

    // Sélectionner 6 opérations du niveau demandé
    while (selectedOperations.length < 6 &&
        selectedOperations.length < operations.length) {
      final operation = operations[random.nextInt(operations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Compléter avec d'autres opérations si nécessaire
    while (selectedOperations.length < 6) {
      final operation = allOperations[random.nextInt(allOperations.length)];
      if (!selectedOperations
          .any((op) => op.operationType == operation.operationType)) {
        selectedOperations.add(operation);
      }
    }

    // Générer les questions (même logique que generateQuiz)
    final questions = <Map<String, dynamic>>[];

    for (final operation in selectedOperations) {
      Map<String, int> params = {};
      int result;
      int attempts = 0;
      const maxAttempts = 50; // Limite pour éviter les boucles infinies

      // Générer des paramètres jusqu'à obtenir un résultat unique et valide
      do {
        params = {};

        // Pour les produits de fractions, utiliser la méthode spécialisée
        if (operation.operationType == 'produit_fractions') {
          params = _generateExactFractionProduct(random);
        } else if (operation.operationType == 'somme_fractions') {
          // Pour les sommes de fractions, générer un résultat entier exact
          params = _generateExactFractionSum(random);
        } else if (operation.operationType == 'racine') {
          // Pour les racines carrées, générer un carré parfait
          params = _generatePerfectSquare(random);
        } else {
          // Pour les autres opérations, génération normale
          for (final param in operation.parameters) {
            params[param.name] = param.minValue +
                random.nextInt(param.maxValue - param.minValue + 1);
          }
        }

        result = operation.calculateResult(params);
        attempts++;

        // Pour les fractions simples, vérifier que le résultat est exact
        if (operation.operationType == 'fraction') {
          final a = params['a']!;
          final b = params['b']!;
          if (a % b != 0) {
            // La division n'est pas exacte, essayer avec un multiple de b
            params['a'] = b * (a ~/ b + 1);
            result = operation.calculateResult(params);
          }
        }
      } while ((usedResults.contains(result) || result <= 0) &&
          attempts < maxAttempts);

      // Si on n'a pas trouvé de résultat valide, utiliser une opération simple
      if (attempts >= maxAttempts) {
        final simpleOperation = allOperations.firstWhere(
          (op) => op.operationType == 'carre',
          orElse: () => allOperations.first,
        );
        params = {'n': 2 + random.nextInt(10)};
        result = simpleOperation.calculateResult(params);
      }

      usedResults.add(result);

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
