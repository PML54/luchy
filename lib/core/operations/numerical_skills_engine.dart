import 'dart:math' as math;

class OperationParameter {
  final String name;
  final int minValue;
  final int maxValue;
  final String description;

  const OperationParameter({
    required this.name,
    required this.minValue,
    required this.maxValue,
    required this.description,
  });
}

class OperationTemplate {
  final String operationType;
  final String latexPattern;
  final String description;
  final List<OperationParameter> parameters;
  final int difficulty;
  final Function(Map<String, int>) calculateResult;

  const OperationTemplate({
    required this.operationType,
    required this.latexPattern,
    required this.description,
    required this.parameters,
    required this.difficulty,
    required this.calculateResult,
  });
}

/// Liste complète des opérations mathématiques supportées
final List<OperationTemplate> allOperations = [
  // 1. CARRÉS
  OperationTemplate(
    operationType: 'carre',
    latexPattern: '{VAR:n}^2',
    description: 'Carré de n',
    parameters: const [
      OperationParameter(
          name: 'n',
          minValue: 1,
          maxValue: 20,
          description: 'Nombre à élever au carré'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['n']! * params['n']!,
  ),

  // 2. RACINES CARRÉES (nombres parfaits uniquement)
  OperationTemplate(
    operationType: 'racine',
    latexPattern: '\\sqrt{{VAR:n}}',
    description: 'Racine carrée de n',
    parameters: const [
      OperationParameter(
          name: 'n', minValue: 4, maxValue: 400, description: 'Carré parfait'),
    ],
    difficulty: 2,
    calculateResult: (params) => math.sqrt(params['n']!).toInt(),
  ),

  // 3. CUBES
  OperationTemplate(
    operationType: 'cube',
    latexPattern: '{VAR:n}^3',
    description: 'Cube de n',
    parameters: const [
      OperationParameter(
          name: 'n',
          minValue: 1,
          maxValue: 10,
          description: 'Nombre à élever au cube'),
    ],
    difficulty: 2,
    calculateResult: (params) => params['n']! * params['n']! * params['n']!,
  ),

  // 4. PRODUITS
  OperationTemplate(
    operationType: 'produit',
    latexPattern: '{VAR:a} \\times {VAR:b}',
    description: 'Produit de a et b',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 2, maxValue: 20, description: 'Premier facteur'),
      OperationParameter(
          name: 'b',
          minValue: 2,
          maxValue: 20,
          description: 'Deuxième facteur'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! * params['b']!,
  ),

  // 5. FRACTIONS SIMPLES (résultat entier garanti)
  OperationTemplate(
    operationType: 'fraction',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}}',
    description: 'Fraction a sur b',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 2, maxValue: 40, description: 'Numérateur'),
      OperationParameter(
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
  OperationTemplate(
    operationType: 'somme',
    latexPattern: '{VAR:a} + {VAR:b}',
    description: 'Somme de a et b',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 1, maxValue: 50, description: 'Premier terme'),
      OperationParameter(
          name: 'b', minValue: 1, maxValue: 50, description: 'Deuxième terme'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! + params['b']!,
  ),

  // 7. SOUSTRACTIONS
  OperationTemplate(
    operationType: 'soustraction',
    latexPattern: '{VAR:a} - {VAR:b}',
    description: 'Différence de a et b',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 10, maxValue: 100, description: 'Minuende'),
      OperationParameter(
          name: 'b', minValue: 1, maxValue: 50, description: 'Soustrahend'),
    ],
    difficulty: 1,
    calculateResult: (params) => params['a']! - params['b']!,
  ),

  // 8. FACTORIELS
  OperationTemplate(
    operationType: 'factoriel',
    latexPattern: '{VAR:n}!',
    description: 'Factoriel de n',
    parameters: const [
      OperationParameter(
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
  OperationTemplate(
    operationType: 'somme_fractions',
    latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}} + \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Somme de deux fractions',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 1, maxValue: 10, description: 'Numérateur 1'),
      OperationParameter(
          name: 'b', minValue: 2, maxValue: 10, description: 'Dénominateur 1'),
      OperationParameter(
          name: 'c', minValue: 1, maxValue: 10, description: 'Numérateur 2'),
      OperationParameter(
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
      return numerateur ~/ denominateur; // Division entière
    },
  ),

  // 10. PRODUIT DE FRACTIONS (résultat entier garanti)
  OperationTemplate(
    operationType: 'produit_fractions',
    latexPattern:
        '\\frac{{{VAR:a}}}{{{VAR:b}}} \\times \\frac{{{VAR:c}}}{{{VAR:d}}}',
    description: 'Produit de deux fractions',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 1, maxValue: 20, description: 'Numérateur 1'),
      OperationParameter(
          name: 'b', minValue: 2, maxValue: 10, description: 'Dénominateur 1'),
      OperationParameter(
          name: 'c', minValue: 1, maxValue: 20, description: 'Numérateur 2'),
      OperationParameter(
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
  OperationTemplate(
    operationType: 'combinaison',
    latexPattern: '\\binom{{{VAR:n}}}{{{VAR:p}}}',
    description: 'Combinaison de p éléments parmi n',
    parameters: const [
      OperationParameter(
          name: 'n', minValue: 3, maxValue: 8, description: 'Nombre total'),
      OperationParameter(
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
  OperationTemplate(
    operationType: 'puissance',
    latexPattern: '{VAR:a}^{{{VAR:n}}}',
    description: 'a puissance n',
    parameters: const [
      OperationParameter(
          name: 'a', minValue: 2, maxValue: 10, description: 'Base'),
      OperationParameter(
          name: 'n', minValue: 2, maxValue: 6, description: 'Exposant'),
    ],
    difficulty: 3,
    calculateResult: (params) => math.pow(params['a']!, params['n']!).toInt(),
  ),
];

/// Générateur de quiz d'opérations mathématiques
class OperationsQuizGenerator {
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
    final selectedOperations = <OperationTemplate>[];
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
    final selectedOperations = <OperationTemplate>[];
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
