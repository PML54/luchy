/// <cursor>
///
/// expression_corpus.dart
/// core/expressions/
///
/// Corpus central de toutes les fonctions de calcul pour expressions circonstanciées.
/// Organisé en classe statique selon spécifications définies.
///
/// COMPOSANTS PRINCIPAUX:
/// - ExpressionCorpus: Classe statique contenant toutes les fonctions
/// - additionFractionsSimples(): Addition a/b + c/d (entiers)
/// - additionEntiers(): Addition a + b (entiers)
/// - registerAllFunctions(): Auto-registration dans le registre
///
/// ÉTAT ACTUEL:
/// - Migration depuis expression_calculator.dart
/// - Organisation en classe statique
/// - Auto-registration des fonctions
/// - Prêt pour extensions futures
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-31: Migration vers classe statique
/// - Séparation claire JSON (config) vs Dart (logique)
/// - Organisation modulaire pour 50+ expressions futures
///
/// 🔧 POINTS D'ATTENTION:
/// - Toujours calculs exacts (jamais d'approximation)
/// - Simplification automatique obligatoire
/// - Nommage cohérent avec JSON
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter additionRadicaux()
/// - Ajouter additionFractionsRadicaux()
/// - Intégrer parser JSON automatique
///
/// 🔗 FICHIERS LIÉS:
/// - expression_calculator.dart (registre)
/// - fraction_result.dart
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur de tous les calculs)
/// 📅 Dernière modification: 2025-01-31
/// </cursor>

import 'expression_calculator.dart';
import 'fraction_result.dart';

/// Corpus central de toutes les fonctions de calcul d'expressions circonstanciées
/// Organisé selon les spécifications définies ensemble
class ExpressionCorpus {
  // =====================================================================================
  /// 🧮 ADDITIONS D'ENTIERS
  // =====================================================================================

  /// Addition de deux entiers simples: a + b
  /// Domaine: entiers_naturels ou entiers_relatifs
  static ExpressionResult additionEntiers(Map<String, dynamic> variables) {
    final a = variables['a'] as int?;
    final b = variables['b'] as int?;

    if (a == null || b == null) {
      throw ArgumentError('Variables a et b requises pour addition_entiers');
    }

    return IntegerExpressionResult(a + b);
  }

  // =====================================================================================
  /// 🔢 ADDITIONS DE FRACTIONS ENTIÈRES
  // =====================================================================================

  /// Addition de deux fractions à numérateurs/dénominateurs entiers
  /// Expression: \frac{a}{b} + \frac{c}{d}
  /// Domaine: fractions_entieres
  /// Résultat: fraction simplifiée ou entier si dénominateur = 1
  static ExpressionResult additionFractionsSimples(
      Map<String, dynamic> variables) {
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

    // Créer les fractions avec simplification automatique
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

  // =====================================================================================
  /// 🔄 AUTO-REGISTRATION DANS LE REGISTRE
  // =====================================================================================

  /// Enregistre automatiquement toutes les fonctions dans le registre
  /// À appeler au démarrage de l'application
  static void registerAllFunctions() {
    ExpressionCalculatorRegistry.register('addition_entiers', additionEntiers);
    ExpressionCalculatorRegistry.register(
        'addition_fractions_simples', additionFractionsSimples);

    print(
        '📋 ExpressionCorpus: ${_getRegisteredFunctionsCount()} fonctions enregistrées');
  }

  /// Compte le nombre de fonctions enregistrées
  static int _getRegisteredFunctionsCount() {
    return ExpressionCalculatorRegistry.getAvailableFunctions().length;
  }

  /// Liste toutes les fonctions disponibles dans ce corpus
  static List<String> getAvailableFunctions() {
    return [
      'addition_entiers',
      'addition_fractions_simples',
      // À étendre avec les nouvelles expressions
    ];
  }

  /// Vérifie si toutes les fonctions du corpus sont enregistrées
  static bool allFunctionsRegistered() {
    final available = getAvailableFunctions();
    final registered = ExpressionCalculatorRegistry.getAvailableFunctions();

    for (final function in available) {
      if (!registered.contains(function)) {
        return false;
      }
    }
    return true;
  }

  // =====================================================================================
  /// 🎯 VALIDATION ET GÉNÉRATION
  // =====================================================================================

  /// Valide qu'une expression peut être calculée
  static bool canCalculate(
      String functionName, Map<String, dynamic> variables) {
    try {
      if (!ExpressionCalculatorRegistry.hasFunction(functionName)) {
        return false;
      }

      // Test de calcul sans exception
      ExpressionCalculatorRegistry.calculate(functionName, variables);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Génère un exemple de calcul pour une fonction donnée
  static Map<String, dynamic> generateExample(String functionName) {
    switch (functionName) {
      case 'addition_entiers':
        return {
          'variables': {'a': 3, 'b': 5},
          'expression_latex': 'a + b',
          'expression_instanciee': '3 + 5',
          'resultat_attendu': '8'
        };

      case 'addition_fractions_simples':
        return {
          'variables': {'a': 1, 'b': 2, 'c': 1, 'd': 3},
          'expression_latex': '\\frac{a}{b} + \\frac{c}{d}',
          'expression_instanciee': '\\frac{1}{2} + \\frac{1}{3}',
          'resultat_attendu': '\\frac{5}{6}'
        };

      default:
        throw ArgumentError('Fonction inconnue: $functionName');
    }
  }
}
