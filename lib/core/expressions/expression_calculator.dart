/// <cursor>
///
/// expression_calculator.dart
/// core/expressions/
///
/// Calculateurs pour les expressions circonstanciées selon spécifications.
/// Implémente le registre de fonctions et les calculs exacts.
///
/// COMPOSANTS PRINCIPAUX:
/// - ExpressionCalculatorRegistry: Registre des fonctions de calcul
/// - ExpressionValidator: Validation des variables et contraintes
/// - VariableGenerator: Génération de valeurs aléatoires
/// - Types de résultats (délégués à expression_corpus.dart)
///
/// ÉTAT ACTUEL:
/// - Registre de base implémenté
/// - Addition de fractions avec simplification
/// - Résultats en forme exacte uniquement
/// - Support LaTeX intégré
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-31: Création selon architecture spécifiée
/// - Migration des fonctions vers expression_corpus.dart
/// - Focus sur registre et utilitaires
///
/// 🔧 POINTS D'ATTENTION:
/// - Jamais de valeurs approchées
/// - Simplification automatique obligatoire
/// - Gestion des entiers vs fractions
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Parser automatique JSON → Dart
/// - Intégration avec quiz factory
/// - Optimisations performance registre
///
/// 🔗 FICHIERS LIÉS:
/// - expression_corpus.dart (fonctions de calcul)
/// - fraction_result.dart
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur des calculs exacts)
/// 📅 Dernière modification: 2025-01-31
/// </cursor>

import 'dart:math' as math;

import 'fraction_result.dart';

/// Type de fonction pour le registre de calcul
typedef ExpressionCalculatorFunction = ExpressionResult Function(
    Map<String, dynamic> variables);

/// Registre central des fonctions de calcul d'expressions
class ExpressionCalculatorRegistry {
  static final Map<String, ExpressionCalculatorFunction> _registry = <String, ExpressionCalculatorFunction>{};

  /// Enregistre une nouvelle fonction de calcul
  static void register(String nom, ExpressionCalculatorFunction function) {
    _registry[nom] = function;
  }

  /// Exécute le calcul pour une expression donnée
  static ExpressionResult calculate(
      String fonctionCalcul, Map<String, dynamic> variables) {
    final function = _registry[fonctionCalcul];
    if (function == null) {
      throw ArgumentError('Fonction de calcul inconnue: $fonctionCalcul');
    }
    return function(variables);
  }

  /// Liste toutes les fonctions disponibles
  static List<String> getAvailableFunctions() => _registry.keys.toList();

  /// Vérifie si une fonction existe
  static bool hasFunction(String nom) => _registry.containsKey(nom);
}

/// Addition de deux entiers simples
ExpressionResult additionEntiers(Map<String, dynamic> variables) {
  final a = variables['a'] as int?;
  final b = variables['b'] as int?;

  if (a == null || b == null) {
    throw ArgumentError('Variables a et b requises pour addition_entiers');
  }

  return IntegerExpressionResult(a + b);
}

/// Addition de deux fractions avec numérateurs/dénominateurs entiers
/// Implémente exactement: a/b + c/d = (a*d + c*b)/(b*d) puis simplification
ExpressionResult additionFractionsSimples(Map<String, dynamic> variables) {
  final a = variables['a'] as int?;
  final b = variables['b'] as int?;
  final c = variables['c'] as int?;
  final d = variables['d'] as int?;

  if (a == null || b == null || c == null || d == null) {
    throw ArgumentError(
        'Variables a, b, c, d requises pour addition_fractions_simples');
  }

  if (b == 0 || d == 0) {
    throw ArgumentError('Les dénominateurs b et d ne peuvent pas être zéro');
  }

  // Créer les fractions
  final fraction1 = FractionResult(a, b);
  final fraction2 = FractionResult(c, d);

  // Addition avec simplification automatique
  final resultat = fraction1 + fraction2;

  // Retourner entier si dénominateur = 1, sinon fraction
  if (resultat.estEntier) {
    return IntegerExpressionResult(resultat.valeurEntiere!);
  } else {
    return FractionExpressionResult(resultat);
  }
}

/// Validation des variables pour une expression donnée
class ExpressionValidator {
  /// Valide que toutes les variables requises sont présentes
  static bool validateVariables(
      List<String> requiredVars, Map<String, dynamic> variables) {
    for (final varName in requiredVars) {
      if (!variables.containsKey(varName)) {
        return false;
      }
    }
    return true;
  }

  /// Valide les contraintes d'une variable selon le JSON
  static bool validateConstraints(
      dynamic value, Map<String, dynamic> constraints) {
    if (value is! int) return false;

    final min = constraints['min'] as int?;
    final max = constraints['max'] as int?;
    final exclude = constraints['exclude'] as List<dynamic>?;

    if (min != null && value < min) return false;
    if (max != null && value > max) return false;
    if (exclude != null && exclude.contains(value)) return false;

    return true;
  }
}

/// Générateur de valeurs aléatoires pour variables selon contraintes
class VariableGenerator {
  static final _random = math.Random();

  /// Génère une valeur aléatoire selon les contraintes
  static int generateValue(Map<String, dynamic> constraints) {
    final min = constraints['min'] as int? ?? 1;
    final max = constraints['max'] as int? ?? 10;
    final exclude =
        (constraints['exclude'] as List<dynamic>?)?.cast<int>() ?? [];

    List<int> validValues = [];
    for (int i = min; i <= max; i++) {
      if (!exclude.contains(i)) {
        validValues.add(i);
      }
    }

    if (validValues.isEmpty) {
      throw ArgumentError(
          'Aucune valeur valide selon les contraintes: $constraints');
    }

    return validValues[_random.nextInt(validValues.length)];
  }

  /// Génère toutes les variables pour une expression
  static Map<String, int> generateVariables(
      List<Map<String, dynamic>> variableSpecs) {
    final result = <String, int>{};

    for (final spec in variableSpecs) {
      final nom = spec['nom'] as String;
      final contraintes = spec['contraintes'] as Map<String, dynamic>;
      result[nom] = generateValue(contraintes);
    }

    return result;
  }
}
