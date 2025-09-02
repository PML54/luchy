/// <cursor>
/// LUCHY - Architecture Orientée Objet pour les Formules Mathématiques
///
/// Nouvelle architecture pour gérer les formules mathématiques de manière
/// structurée et maintenable. Chaque formule est représentée par un objet
/// avec ses propriétés et méthodes.
///
/// COMPOSANTS PRINCIPAUX:
/// - MathematicalFormula: Classe de base pour toutes les formules
/// - FormulaArgument: Définition des paramètres d'une formule
/// - FormulaLibrary: Gestionnaire central des formules
/// - Catégories spécialisées: BinomialFormula, SummationFormula, etc.
///
/// ÉTAT ACTUEL:
/// - Architecture définie et prête à l'implémentation
/// - Structure modulaire et extensible
/// - Support pour validation et calcul automatique
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de l'architecture orientée objet
/// - Définition des interfaces et classes de base
/// - Préparation pour migration des 25 formules existantes
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du nouveau système éducatif)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

/// =====================================================================================
/// 📚 ÉNUMÉRATIONS ET TYPES DE BASE
/// =====================================================================================

/// Catégories de formules mathématiques
enum FormulaCategory {
  BINOMIAL, // Formules du binôme de Newton
  SUMMATION, // Formules de sommes (arithmétique, géométrique, etc.)
  COMBINATORIAL, // Formules combinatoires
  ALGEBRA, // Formules algébriques générales
  ANALYSIS, // Formules d'analyse
}

/// Niveaux éducatifs
enum DifficultyLevel {
  PRIMAIRE, // École primaire
  COLLEGE, // Collège
  LYCEE, // Lycée
  PREPA, // Classe préparatoire
}

/// Types de paramètres pour les formules
enum ArgumentType {
  NATURAL, // Entiers naturels (0, 1, 2, ...)
  INTEGER, // Entiers relatifs (...-2, -1, 0, 1, 2...)
  REAL, // Nombres réels
  POSITIVE, // Nombres strictement positifs
  NON_NEGATIVE, // Nombres positifs ou nuls
}

/// =====================================================================================
/// 🔧 CLASSES UTILITAIRES
/// =====================================================================================

/// Définition d'un argument/paramètre d'une formule
class FormulaArgument {
  final String name;
  final String description;
  final ArgumentType type;
  final num? minValue;
  final num? maxValue;
  final bool isRequired;

  const FormulaArgument({
    required this.name,
    required this.description,
    required this.type,
    this.minValue,
    this.maxValue,
    this.isRequired = true,
  });

  /// Valide si une valeur respecte les contraintes de cet argument
  bool validate(num value) {
    if (minValue != null && value < minValue!) return false;
    if (maxValue != null && value > maxValue!) return false;

    switch (type) {
      case ArgumentType.NATURAL:
        return value >= 0 && value == value.toInt();
      case ArgumentType.INTEGER:
        return value == value.toInt();
      case ArgumentType.POSITIVE:
        return value > 0;
      case ArgumentType.NON_NEGATIVE:
        return value >= 0;
      case ArgumentType.REAL:
        return true; // Pas de restriction supplémentaire
    }
  }

  @override
  String toString() => '$name: $description (${type.name})';
}

/// =====================================================================================
/// 🎯 CLASSE DE BASE POUR LES FORMULES MATHÉMATIQUES
/// =====================================================================================

/// Classe de base abstraite pour toutes les formules mathématiques
abstract class MathematicalFormula {
  final String id;
  final String name;
  final FormulaCategory category;
  final DifficultyLevel difficulty;
  final String description;
  final List<String> tags;

  const MathematicalFormula({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.description,
    this.tags = const [],
  });

  /// Expression LaTeX de la formule (partie gauche)
  String get latexLeft;

  /// Expression LaTeX du résultat (partie droite)
  String get latexRight;

  /// Liste des arguments/paramètres de la formule
  List<FormulaArgument> get arguments;

  /// Calcule le résultat numérique si possible
  num? calculate(Map<String, num> parameters);

  /// Valide que tous les paramètres sont corrects
  bool validateParameters(Map<String, num> parameters) {
    for (final arg in arguments) {
      if (arg.isRequired && !parameters.containsKey(arg.name)) {
        return false;
      }

      final value = parameters[arg.name];
      if (value != null && !arg.validate(value)) {
        return false;
      }
    }
    return true;
  }

  /// Génère une version LaTeX complète de la formule
  String get fullLatex => '$latexLeft = $latexRight';

  @override
  String toString() =>
      'MathematicalFormula(id: $id, name: $name, category: ${category.name}, difficulty: ${difficulty.name})';
}

/// =====================================================================================
/// 📐 CLASSES SPÉCIALISÉES PAR CATÉGORIE
/// =====================================================================================

/// Formule du binôme de Newton
class BinomialFormula extends MathematicalFormula {
  final String leftExpression;
  final String rightExpression;
  final List<FormulaArgument> formulaArguments;

  const BinomialFormula({
    required super.id,
    required super.name,
    required super.difficulty,
    required super.description,
    required this.leftExpression,
    required this.rightExpression,
    required this.formulaArguments,
    super.tags,
  }) : super(category: FormulaCategory.BINOMIAL);

  @override
  String get latexLeft => leftExpression;

  @override
  String get latexRight => rightExpression;

  @override
  List<FormulaArgument> get arguments => formulaArguments;

  @override
  num? calculate(Map<String, num> parameters) {
    // Implémentation spécifique selon la formule
    return null; // À implémenter selon la formule spécifique
  }
}

/// Formule de somme (arithmétique, géométrique, etc.)
class SummationFormula extends MathematicalFormula {
  final String leftExpression;
  final String rightExpression;
  final List<FormulaArgument> formulaArguments;

  const SummationFormula({
    required super.id,
    required super.name,
    required super.difficulty,
    required super.description,
    required this.leftExpression,
    required this.rightExpression,
    required this.formulaArguments,
    super.tags,
  }) : super(category: FormulaCategory.SUMMATION);

  @override
  String get latexLeft => leftExpression;

  @override
  String get latexRight => rightExpression;

  @override
  List<FormulaArgument> get arguments => formulaArguments;

  @override
  num? calculate(Map<String, num> parameters) {
    // Implémentation spécifique selon la formule
    return null; // À implémenter selon la formule spécifique
  }
}

/// Formule combinatoire
class CombinatorialFormula extends MathematicalFormula {
  final String leftExpression;
  final String rightExpression;
  final List<FormulaArgument> formulaArguments;

  const CombinatorialFormula({
    required super.id,
    required super.name,
    required super.difficulty,
    required super.description,
    required this.leftExpression,
    required this.rightExpression,
    required this.formulaArguments,
    super.tags,
  }) : super(category: FormulaCategory.COMBINATORIAL);

  @override
  String get latexLeft => leftExpression;

  @override
  String get latexRight => rightExpression;

  @override
  List<FormulaArgument> get arguments => formulaArguments;

  @override
  num? calculate(Map<String, num> parameters) {
    // Implémentation spécifique selon la formule
    return null; // À implémenter selon la formule spécifique
  }
}

/// =====================================================================================
/// 📚 BIBLIOTHÈQUE DE FORMULES
/// =====================================================================================

/// Gestionnaire central pour toutes les formules mathématiques
class FormulaLibrary {
  static final FormulaLibrary _instance = FormulaLibrary._internal();
  factory FormulaLibrary() => _instance;

  FormulaLibrary._internal();

  final List<MathematicalFormula> _formulas = [];

  /// Ajoute une formule à la bibliothèque
  void addFormula(MathematicalFormula formula) {
    _formulas.add(formula);
  }

  /// Récupère toutes les formules
  List<MathematicalFormula> get allFormulas => List.unmodifiable(_formulas);

  /// Récupère les formules d'une catégorie
  List<MathematicalFormula> getFormulasByCategory(FormulaCategory category) {
    return _formulas.where((f) => f.category == category).toList();
  }

  /// Récupère les formules d'un niveau de difficulté
  List<MathematicalFormula> getFormulasByDifficulty(
      DifficultyLevel difficulty) {
    return _formulas.where((f) => f.difficulty == difficulty).toList();
  }

  /// Recherche des formules par nom ou description
  List<MathematicalFormula> searchFormulas(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _formulas
        .where((f) =>
            f.name.toLowerCase().contains(lowercaseQuery) ||
            f.description.toLowerCase().contains(lowercaseQuery) ||
            f.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  /// Récupère une formule par son ID
  MathematicalFormula? getFormulaById(String id) {
    try {
      return _formulas.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Statistiques de la bibliothèque
  Map<String, int> get statistics {
    final stats = <String, int>{};
    for (final category in FormulaCategory.values) {
      stats[category.name] = getFormulasByCategory(category).length;
    }
    stats['TOTAL'] = _formulas.length;
    return stats;
  }

  /// Affiche les statistiques
  void printStatistics() {
    print('📊 STATISTIQUES DE LA BIBLIOTHÈQUE DE FORMULES:');
    print('=' * 50);
    final stats = statistics;
    stats.forEach((key, value) {
      if (key != 'TOTAL') {
        print('  $key: $value formules');
      }
    });
    print('  TOTAL: ${stats['TOTAL']} formules');
    print('=' * 50);
  }
}

/// =====================================================================================
/// 🎯 EXEMPLES D'UTILISATION
/// =====================================================================================

/// Fonction utilitaire pour créer des exemples de formules
void createExampleFormulas() {
  final library = FormulaLibrary();

  // Exemple 1: Formule du binôme de Newton
  final binomialFormula = BinomialFormula(
    id: 'binomial_basic',
    name: 'Développement du binôme',
    difficulty: DifficultyLevel.PREPA,
    description: 'Formule générale du développement du binôme de Newton',
    leftExpression: r'(a+b)^n',
    rightExpression: r'\sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    formulaArguments: const [
      FormulaArgument(
        name: 'n',
        description: 'exposant entier positif',
        type: ArgumentType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
    tags: ['binôme', 'développement', 'coefficients'],
  );

  // Exemple 2: Somme des n premiers entiers
  final sumFormula = SummationFormula(
    id: 'sum_arithmetic',
    name: 'Somme arithmétique',
    difficulty: DifficultyLevel.COLLEGE,
    description: 'Formule de la somme des n premiers entiers naturels',
    leftExpression: r'\sum_{k=1}^{n} k',
    rightExpression: r'\frac{n(n+1)}{2}',
    formulaArguments: const [
      FormulaArgument(
        name: 'n',
        description: 'nombre d\'entiers à sommer',
        type: ArgumentType.NATURAL,
        minValue: 1,
      ),
    ],
    tags: ['somme', 'arithmétique', 'entiers'],
  );

  // Exemple 3: Coefficient binomial
  final combinatorialFormula = CombinatorialFormula(
    id: 'combinatorial_basic',
    name: 'Coefficient binomial',
    difficulty: DifficultyLevel.LYCEE,
    description: 'Nombre de combinaisons de k éléments parmi n',
    leftExpression: r'\binom{n}{k}',
    rightExpression: r'\frac{n!}{k!(n-k)!}',
    formulaArguments: const [
      FormulaArgument(
        name: 'n',
        description: 'taille de l\'ensemble',
        type: ArgumentType.NATURAL,
        minValue: 0,
      ),
      FormulaArgument(
        name: 'k',
        description: 'nombre d\'éléments à choisir',
        type: ArgumentType.NATURAL,
        minValue: 0,
      ),
    ],
    tags: ['combinatoire', 'coefficient', 'factorielle'],
  );

  // Ajout des formules à la bibliothèque
  library.addFormula(binomialFormula);
  library.addFormula(sumFormula);
  library.addFormula(combinatorialFormula);

  // Affichage des statistiques
  library.printStatistics();
}

/// =====================================================================================
/// 🔍 FONCTIONS UTILITAIRES
/// =====================================================================================

/// Fonction de calcul pour les coefficients binomiaux
int binomialCoefficient(int n, int k) {
  if (k < 0 || k > n) return 0;
  if (k == 0 || k == n) return 1;

  int result = 1;
  for (int i = 1; i <= k; i++) {
    result = result * (n - k + i) ~/ i;
  }
  return result;
}

/// Fonction de calcul factorielle
int factorial(int n) {
  if (n < 0)
    throw ArgumentError('Factorial is not defined for negative numbers');
  if (n <= 1) return 1;

  int result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}

/// Fonction de calcul pour les sommes arithmétiques
int arithmeticSum(int n) {
  return n * (n + 1) ~/ 2;
}

/// Fonction de calcul pour les sommes géométriques finies
double geometricSumFinite(double a, double r, int n) {
  if (r == 1) return a * n;
  return a * (1 - math.pow(r, n)) / (1 - r);
}

/// Fonction de calcul pour les sommes géométriques infinies
double geometricSumInfinite(double a, double r) {
  if (r.abs() >= 1) throw ArgumentError('Series diverges for |r| >= 1');
  return a / (1 - r);
}
