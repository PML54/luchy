/// <cursor>
///
/// 🧮 MOTEUR MATHÉMATIQUE PRÉPA - VERSION UNIFIÉE
///
/// Version simplifiée du moteur mathématique avec liste unifiée de formules.
/// Toutes les formules sont regroupées dans allFormulas avec métadonnées chapitre et level.
///
/// COMPOSANTS PRINCIPAUX:
/// - allFormulas: Liste unifiée de toutes les formules
/// - getFormulasByChapter(): Filtrage par chapitre
/// - getFormulasByLevel(): Filtrage par niveau
/// - TypeDeJeu: Enum simplifié (Calcul + Géographie uniquement)
/// - Fonctions utilitaires pour la gestion des formules
///
/// ÉTAT ACTUEL:
/// - Architecture simplifiée avec liste unifiée
/// - Métadonnées chapitre et level pour chaque formule
/// - Types de jeu réduits à Calcul et Géographie
/// - Suppression des anciens moteurs (Numérique, Fractions, Séries)
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-23 18:37: Nettoyage majeur - Suppression anciens types de quiz
/// - Suppression habileteSeries, habileteNumerique, habileteFractions
/// - Conservation uniquement habileteMaths (Calcul) et habileteGeographie
/// - 2025-01-30: Refactorisation vers architecture unifiée
/// - Suppression des listes séparées
/// - Ajout des métadonnées chapitre et level
///
/// 🔧 POINTS D'ATTENTION:
/// - Types de jeu simplifiés (2 au lieu de 5)
/// - Cohérence avec les écrans ModernMathSkillsScreen et GeographySkillsScreen
/// - Suppression des anciens moteurs et écrans associés
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Tests de régression après nettoyage
/// - Optimisation des performances
/// - Ajout de nouvelles fonctionnalités sur base simplifiée
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart
/// - lib/features/puzzle/presentation/screens/geography_skills_screen.dart
/// - lib/core/operations/exact_math_engine.dart
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif mathématique)
/// 📅 Dernière modification: 2025-09-23 18:37
/// </cursor>

import 'dart:math' as math;

/// =====================================================================================
/// 🏷️ TYPES DE BASE
/// =====================================================================================

/// Type de paramètre pour la validation automatique des formules
enum ParameterType {
  /// Entiers relatifs (..., -2, -1, 0, 1, 2, ...)
  INTEGER,

  /// Entiers naturels (0, 1, 2, 3, ...)
  NATURAL,

  /// Nombres positifs stricts (> 0)
  POSITIVE,

  /// Nombres réels (-∞, +∞)
  REAL,
}

/// Type de formule pour le calcul automatique
enum FormulaType {
  /// Coefficients binomiaux C(n,k)
  COMBINAISON,

  /// Développement du binôme de Newton (a+b)^n
  BINOME,

  /// Formules de sommation Σ
  SOMME,

  /// Type non identifié
  UNKNOWN,
}

/// =====================================================================================
/// 📝 CLASSES DE PARAMÈTRES
/// =====================================================================================

/// Paramètre d'une formule avec validation intelligente
class FormulaParameter {
  /// Nom du paramètre (ex: 'n', 'k', 'a', 'b')
  final String name;

  /// Description pédagogique du paramètre
  final String description;

  /// Indique si ce paramètre peut être inversé avec un autre
  final bool canInvert;

  /// Type du paramètre pour validation
  final ParameterType type;

  /// Valeur minimale autorisée (optionnel)
  final num? minValue;

  /// Valeur maximale autorisée (optionnel)
  final num? maxValue;

  const FormulaParameter({
    required this.name,
    required this.description,
    this.canInvert = false,
    this.type = ParameterType.INTEGER,
    this.minValue,
    this.maxValue,
  });

  /// Valide une valeur selon les contraintes du paramètre
  bool validate(num value) {
    // Vérification du type
    switch (type) {
      case ParameterType.INTEGER:
        if (value != value.roundToDouble()) return false;
        break;
      case ParameterType.NATURAL:
        if (value != value.roundToDouble() || value < 0) return false;
        break;
      case ParameterType.POSITIVE:
        if (value <= 0) return false;
        break;
      case ParameterType.REAL:
        // Tous les nombres réels sont acceptés
        break;
    }

    // Vérification des bornes
    if (minValue != null && value < minValue!) return false;
    if (maxValue != null && value > maxValue!) return false;

    return true;
  }

  /// Génère une valeur aléatoire valide pour ce paramètre
  num generateRandomValue() {
    final random = math.Random();
    num min = minValue ?? _getDefaultMin();
    num max = maxValue ?? _getDefaultMax();

    switch (type) {
      case ParameterType.INTEGER:
        return (min + random.nextDouble() * (max - min)).round();
      case ParameterType.NATURAL:
        min = math.max(0, min);
        return (min + random.nextDouble() * (max - min)).round();
      case ParameterType.POSITIVE:
        min = math.max(0.1, min);
        return min + random.nextDouble() * (max - min);
      case ParameterType.REAL:
        return min + random.nextDouble() * (max - min);
    }
  }

  num _getDefaultMin() {
    switch (type) {
      case ParameterType.INTEGER:
        return -10;
      case ParameterType.NATURAL:
        return 0;
      case ParameterType.POSITIVE:
        return 0.1;
      case ParameterType.REAL:
        return -5;
    }
  }

  num _getDefaultMax() {
    switch (type) {
      case ParameterType.INTEGER:
        return 10;
      case ParameterType.NATURAL:
        return 10;
      case ParameterType.POSITIVE:
        return 10;
      case ParameterType.REAL:
        return 5;
    }
  }
}

/// =====================================================================================
/// 🔑 GÉNÉRATEUR D'IDENTIFIANTS DE FORMULES
/// =====================================================================================

/// Générateur d'identifiants uniques pour les formules
class FormulaIdGenerator {
  static int _counter = 1;

  /// Génère un nouvel identifiant de formule
  static String generate() {
    final fid = 'F${_counter.toString().padLeft(3, '0')}';
    _counter++;
    return fid;
  }

  /// Remet le compteur à zéro (pour les tests)
  static void reset() => _counter = 1;
}

/// =====================================================================================
/// 🧮 TEMPLATE DE FORMULE AVANCÉ
/// =====================================================================================

/// Template de formule mathématique avec calcul automatique et validation
class EnhancedFormulaTemplate {
  /// 🔑 FID : Formula Identifier unique pour le suivi
  final String fid;

  /// 📚 CHAPITRE : Catégorie de la formule (binome, combinaisons, sommes)
  final String chapitre;

  /// 🎯 LEVEL : Niveau de difficulté (1-15, 14 pour les formules prépa)
  final int level;

  /// LaTeX original de la formule (immutable)
  final String latexOrigine;

  /// LaTeX avec variables marquées {VAR:nom}
  final String latexVariable;

  /// LaTeX traité pour affichage (généré automatiquement)
  String get latex => _processLatex();

  /// Partie gauche de la formule (générée automatiquement)
  String get leftSide => _extractLeftSide();

  /// Partie droite de la formule (générée automatiquement)
  String get rightSide => _extractRightSide();

  /// Description pédagogique de la formule
  final String description;

  /// Condition LaTeX pour la validité de la formule
  final String? conditionLatex;

  /// Paramètres de la formule avec validation
  final List<FormulaParameter> parameters;

  /// Indique si le résultat est une constante (pas d'inversion de nommage)
  final bool isConstant;

  /// Variables extraites automatiquement
  List<String> get extractedVariables => _extractVariables();

  /// Variables qui peuvent être inversées
  List<String> get invertibleVariables => _extractInvertibleVariables();

  /// Nombre de paramètres
  int get parameterCount => parameters.length;

  /// Noms des variables
  List<String> get variableNames => parameters.map((p) => p.name).toList();

  /// Condition LaTeX finale (alias pour conditionLatex)
  String? get finalConditionLatex => conditionLatex;

  /// Condition LaTeX traitée pour affichage (remplace {VAR:variable} par variable)
  String? get displayConditionLatex {
    if (conditionLatex == null) return null;

    String processed = conditionLatex!;
    // Remplacer {VAR:variable} par variable pour l'affichage
    for (final param in parameters) {
      processed = processed.replaceAll('{VAR:${param.name}}', param.name);
    }
    return processed;
  }

  const EnhancedFormulaTemplate({
    required this.fid,
    required this.chapitre,
    required this.level,
    required this.latexOrigine,
    required this.description,
    required this.parameters,
    this.latexVariable = '',
    this.conditionLatex,
    this.isConstant = false,
  });

  /// Traite le LaTeX en remplaçant les variables marquées
  String _processLatex() {
    return latexVariable.isEmpty
        ? latexOrigine
        : latexVariable.replaceAllMapped(
            RegExp(r'\{VAR:([a-zA-Z][a-zA-Z0-9]*)\}'),
            (match) => match.group(1)!,
          );
  }

  /// Extrait la partie gauche de la formule
  String _extractLeftSide() {
    final parts = _processLatex().split(' = ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  /// Extrait la partie droite de la formule
  String _extractRightSide() {
    final parts = _processLatex().split(' = ');
    return parts.length > 1 ? parts[1] : '';
  }

  /// Extrait les variables depuis le LaTeX marqué
  List<String> _extractVariables() {
    final regex = RegExp(r'\{VAR:([a-zA-Z][a-zA-Z0-9]*)\}');
    return regex
        .allMatches(latexVariable)
        .map((match) => match.group(1)!)
        .toSet()
        .toList();
  }

  /// Extrait les variables interchangeables
  List<String> _extractInvertibleVariables() {
    // Pas d'inversion pour les constantes
    if (isConstant) return [];

    // Pour l'inversion de nommage, tous les paramètres peuvent être inversés
    return parameters.map((param) => param.name).toList();
  }

  /// Calcule la valeur numérique de la formule avec les paramètres donnés
  num? calculate(
    Map<String, num> parameterValues, {
    bool validateParameters = true,
  }) {
    // Validation des paramètres si demandé
    if (validateParameters && !_validateParameters(parameterValues)) {
      return null;
    }

    // Calcul selon le type de formule détecté automatiquement
    return _computeFormula(parameterValues);
  }

  /// Valide tous les paramètres fournis
  bool _validateParameters(Map<String, num> values) {
    for (final param in parameters) {
      final value = values[param.name];
      if (value == null) return false;
      if (!param.validate(value)) return false;
    }
    return true;
  }

  /// Identifie automatiquement le type de formule d'après son expression LaTeX
  FormulaType _identifyFormulaType() {
    final latex = _processLatex();
    if (latex.contains(r'\binom')) return FormulaType.COMBINAISON;
    if (latex.contains(r'\sum') && latex.contains('k ='))
      return FormulaType.SOMME;
    if (latex.contains('^n') || latex.contains('^2') || latex.contains('^3')) {
      return FormulaType.BINOME;
    }
    return FormulaType.UNKNOWN;
  }

  /// Calcule la formule selon son type détecté
  num? _computeFormula(Map<String, num> values) {
    switch (_identifyFormulaType()) {
      case FormulaType.COMBINAISON:
        return _calculateCombinaison(values);
      case FormulaType.BINOME:
        return _calculateBinome(values);
      case FormulaType.SOMME:
        return _calculateSomme(values);
      default:
        return null;
    }
  }

  /// Calcule un coefficient binomial C(n,k) = n! / (k! * (n-k)!)
  num? _calculateCombinaison(Map<String, num> values) {
    final n = values['n']?.round();
    final k = values['k']?.round();

    if (n == null || k == null) return null;
    if (k < 0 || k > n) return null;
    if (n > 12) return null; // Limite pour éviter débordements

    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  /// Calcule le développement du binôme (a+b)^n
  num? _calculateBinome(Map<String, num> values) {
    final a = values['a'];
    final b = values['b'];
    final n = values['n']?.round();

    if (a == null || b == null || n == null) return null;
    if (n < 0 || n > 5) return null; // Limite pour éviter calculs trop lourds

    num result = 0;
    for (int k = 0; k <= n; k++) {
      final coeff = _factorial(n) / (_factorial(k) * _factorial(n - k));
      result += coeff * math.pow(a, n - k) * math.pow(b, k);
    }
    return result;
  }

  /// Calcule une somme selon le type détecté
  num? _calculateSomme(Map<String, num> values) {
    final n = values['n']?.round();
    if (n == null || n < 0) return null;

    final latex = _processLatex();

    // Somme des premiers entiers: Σ(k=1 to n) k = n(n+1)/2
    if (latex.contains(r'\sum_{k=1}^{n} k')) {
      return n * (n + 1) / 2;
    }

    // Somme des carrés: Σ(k=1 to n) k² = n(n+1)(2n+1)/6
    if (latex.contains(r'\sum_{k=1}^{n} k^2')) {
      return n * (n + 1) * (2 * n + 1) / 6;
    }

    // Somme des cubes: Σ(k=1 to n) k³ = (n(n+1)/2)²
    if (latex.contains(r'\sum_{k=1}^{n} k^3')) {
      final sum = n * (n + 1) / 2;
      return sum * sum;
    }

    return null;
  }

  /// Calcule la factorielle n!
  num _factorial(int n) {
    if (n < 0) return 0;
    if (n == 0 || n == 1) return 1;

    num result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  /// Génère des exemples valides pour cette formule
  List<Map<String, num>> generateValidExamples({int count = 5}) {
    final examples = <Map<String, num>>[];
    final random = math.Random();

    for (int i = 0; i < count * 3; i++) {
      // Essayer plus pour avoir assez de valides
      final example = <String, num>{};
      bool isValid = true;

      for (final param in parameters) {
        final value = param.generateRandomValue();
        if (!param.validate(value)) {
          isValid = false;
          break;
        }
        example[param.name] = value;
      }

      if (isValid && !_isDuplicateExample(examples, example)) {
        examples.add(example);
        if (examples.length >= count) break;
      }
    }

    return examples;
  }

  /// Vérifie si un exemple est déjà présent
  bool _isDuplicateExample(
      List<Map<String, num>> examples, Map<String, num> example) {
    for (final existing in examples) {
      bool isDuplicate = true;
      for (final entry in example.entries) {
        if (existing[entry.key] != entry.value) {
          isDuplicate = false;
          break;
        }
      }
      if (isDuplicate) return true;
    }
    return false;
  }

  // =====================================================================================
  /// 🔄 SYSTÈME D'INVERSION DE VARIABLES
  // =====================================================================================

  /// Vérifie si deux variables peuvent être inversées (inversion de nommage)
  bool canInvertVariables(String var1, String var2) {
    // Pas d'inversion pour les constantes
    if (isConstant) return false;

    final param1 = parameters.firstWhere(
      (p) => p.name == var1,
      orElse: () => throw ArgumentError('Variable $var1 non trouvée'),
    );
    final param2 = parameters.firstWhere(
      (p) => p.name == var2,
      orElse: () => throw ArgumentError('Variable $var2 non trouvée'),
    );

    // Pour l'inversion de nommage, on peut inverser n'importe quels 2 paramètres
    // tant qu'ils sont différents
    return var1 != var2;
  }

  /// Crée une version inversée de la formule en échangeant deux variables
  EnhancedFormulaTemplate createInvertedVersion(String var1, String var2) {
    if (!canInvertVariables(var1, var2)) {
      throw ArgumentError(
          'Les variables $var1 et $var2 ne peuvent pas être inversées');
    }

    // Inverser le LaTeX avec variables marquées
    String invertedLatexVariable = latexVariable;
    invertedLatexVariable =
        invertedLatexVariable.replaceAll('{VAR:$var1}', 'TEMP_VAR1');
    invertedLatexVariable =
        invertedLatexVariable.replaceAll('{VAR:$var2}', '{VAR:$var1}');
    invertedLatexVariable =
        invertedLatexVariable.replaceAll('TEMP_VAR1', '{VAR:$var2}');

    // Inverser le LaTeX original
    String invertedLatexOrigine = latexOrigine;
    // Utiliser des patterns plus spécifiques pour éviter les conflits
    final var1Pattern = RegExp(r'\b' + RegExp.escape(var1) + r'\b');
    final var2Pattern = RegExp(r'\b' + RegExp.escape(var2) + r'\b');

    invertedLatexOrigine =
        invertedLatexOrigine.replaceAll(var1Pattern, 'TEMP_VAR1');
    invertedLatexOrigine = invertedLatexOrigine.replaceAll(var2Pattern, var1);
    invertedLatexOrigine = invertedLatexOrigine.replaceAll('TEMP_VAR1', var2);

    // Inverser les conditions LaTeX si elles existent
    String? invertedConditionLatex = conditionLatex;
    if (invertedConditionLatex != null) {
      invertedConditionLatex =
          invertedConditionLatex.replaceAll('{VAR:$var1}', 'TEMP_VAR1');
      invertedConditionLatex =
          invertedConditionLatex.replaceAll('{VAR:$var2}', '{VAR:$var1}');
      invertedConditionLatex =
          invertedConditionLatex.replaceAll('TEMP_VAR1', '{VAR:$var2}');
    }

    // Créer les nouveaux paramètres avec les variables inversées
    final invertedParameters = parameters.map((param) {
      if (param.name == var1) {
        return FormulaParameter(
          name: var2,
          description: param.description.replaceAll(var1, var2),
          canInvert: param.canInvert,
          type: param.type,
          minValue: param.minValue,
          maxValue: param.maxValue,
        );
      } else if (param.name == var2) {
        return FormulaParameter(
          name: var1,
          description: param.description.replaceAll(var2, var1),
          canInvert: param.canInvert,
          type: param.type,
          minValue: param.minValue,
          maxValue: param.maxValue,
        );
      }
      return param;
    }).toList();

    return EnhancedFormulaTemplate(
      fid: FormulaIdGenerator.generate(),
      chapitre: chapitre,
      level: level,
      latexOrigine: invertedLatexOrigine,
      latexVariable: invertedLatexVariable,
      description: '${description} (inversé: $var1 ↔ $var2)',
      conditionLatex: invertedConditionLatex,
      parameters: invertedParameters,
    );
  }

  /// Génère toutes les variantes possibles avec inversions
  List<EnhancedFormulaTemplate> generateInvertedVariants() {
    final variants = <EnhancedFormulaTemplate>[];
    final invertibleVars = invertibleVariables;

    // Ajouter la formule originale
    variants.add(this);

    // Générer toutes les combinaisons d'inversions possibles
    for (int i = 0; i < invertibleVars.length; i++) {
      for (int j = i + 1; j < invertibleVars.length; j++) {
        try {
          final variant =
              createInvertedVersion(invertibleVars[i], invertibleVars[j]);
          variants.add(variant);
        } catch (e) {
          // Ignorer les inversions impossibles
          continue;
        }
      }
    }

    return variants;
  }

  /// Génère une variante aléatoire avec inversion
  EnhancedFormulaTemplate? generateRandomInvertedVariant() {
    final invertibleVars = invertibleVariables;
    if (invertibleVars.length < 2) return null;

    final random = math.Random();

    // S'assurer que var1 et var2 sont différentes
    String var1, var2;
    do {
      var1 = invertibleVars[random.nextInt(invertibleVars.length)];
      var2 = invertibleVars[random.nextInt(invertibleVars.length)];
    } while (var1 == var2 && invertibleVars.length > 1);

    if (var1 == var2) return null;

    try {
      return createInvertedVersion(var1, var2);
    } catch (e) {
      print('❌ Erreur lors de l\'inversion de $var1 et $var2: $e');
      return null;
    }
  }

  /// Vérifie si cette formule est une inversion d'une autre
  bool isInversionOf(EnhancedFormulaTemplate other) {
    // Comparer les variables interchangeables
    final myInvertible = invertibleVariables.toSet();
    final otherInvertible = other.invertibleVariables.toSet();

    if (myInvertible.length != otherInvertible.length) return false;
    if (!myInvertible.containsAll(otherInvertible)) return false;

    // Vérifier que les formules sont différentes mais similaires
    return latexOrigine != other.latexOrigine &&
        chapitre == other.chapitre &&
        level == other.level;
  }
}

/// =====================================================================================
/// 🔄 GÉNÉRATEUR DE QUIZ AVEC INVERSIONS
/// =====================================================================================

/// Génère un quiz avec des formules et leurs inversions pour perturber l'utilisateur
class InvertedQuizGenerator {
  /// Génère un quiz avec 50% de formules normales et 50% d'inversions
  static InvertedQuizConfiguration generateInvertedQuiz({
    String chapitre = 'binome',
    int level = 14,
    int nombreQuestions = 12,
    double inversionRatio = 0.5, // 50% d'inversions
  }) {
    final baseFormulas = allFormulas
        .where((f) => f.chapitre == chapitre && f.level == level)
        .toList();

    if (baseFormulas.isEmpty) {
      throw ArgumentError(
          'Aucune formule trouvée pour chapitre: $chapitre, level: $level');
    }

    final selectedFormulas = <EnhancedFormulaTemplate>[];
    final random = math.Random();

    // Sélectionner des formules de base
    final numberOfInversions = (nombreQuestions * inversionRatio).round();
    final numberOfNormal = nombreQuestions - numberOfInversions;

    // Ajouter des formules normales
    for (int i = 0; i < numberOfNormal && i < baseFormulas.length; i++) {
      selectedFormulas.add(baseFormulas[i]);
    }

    // Ajouter des inversions
    final formulasWithInversions =
        baseFormulas.where((f) => f.invertibleVariables.length >= 2).toList();

    for (int i = 0;
        i < numberOfInversions && i < formulasWithInversions.length;
        i++) {
      final formula = formulasWithInversions[i];
      final invertedVariant = formula.generateRandomInvertedVariant();
      if (invertedVariant != null) {
        selectedFormulas.add(invertedVariant);
      }
    }

    // Mélanger les formules pour perturber l'utilisateur
    selectedFormulas.shuffle(random);

    return InvertedQuizConfiguration(
      formules: selectedFormulas,
      chapitre: chapitre,
      level: level,
      nombreQuestions: selectedFormulas.length,
      hasInversions: true,
      inversionRatio: inversionRatio,
    );
  }

  /// Génère un quiz progressif : commence facile, puis ajoute des inversions
  static InvertedQuizConfiguration generateProgressiveQuiz({
    String chapitre = 'binome',
    int level = 14,
    int nombreQuestions = 12,
  }) {
    final baseFormulas = allFormulas
        .where((f) => f.chapitre == chapitre && f.level == level)
        .toList();

    if (baseFormulas.isEmpty) {
      throw ArgumentError(
          'Aucune formule trouvée pour chapitre: $chapitre, level: $level');
    }

    final selectedFormulas = <EnhancedFormulaTemplate>[];
    final random = math.Random();

    // Première moitié : formules normales
    final firstHalf = (nombreQuestions / 2).round();
    for (int i = 0; i < firstHalf && i < baseFormulas.length; i++) {
      selectedFormulas.add(baseFormulas[i]);
    }

    // Deuxième moitié : mélange de normales et d'inversions
    final secondHalf = nombreQuestions - firstHalf;
    final formulasWithInversions =
        baseFormulas.where((f) => f.invertibleVariables.length >= 2).toList();

    for (int i = 0; i < secondHalf; i++) {
      if (i < formulasWithInversions.length && random.nextBool()) {
        // Ajouter une inversion
        final formula = formulasWithInversions[i];
        final invertedVariant = formula.generateRandomInvertedVariant();
        if (invertedVariant != null) {
          selectedFormulas.add(invertedVariant);
        } else {
          selectedFormulas.add(formula);
        }
      } else {
        // Ajouter une formule normale
        final formulaIndex = (firstHalf + i) % baseFormulas.length;
        selectedFormulas.add(baseFormulas[formulaIndex]);
      }
    }

    // Mélanger pour plus de perturbation
    selectedFormulas.shuffle(random);

    return InvertedQuizConfiguration(
      formules: selectedFormulas,
      chapitre: chapitre,
      level: level,
      nombreQuestions: selectedFormulas.length,
      hasInversions: true,
      inversionRatio: 0.3, // 30% d'inversions en moyenne
    );
  }
}

/// Configuration étendue pour les quiz avec inversions
class InvertedQuizConfiguration {
  final List<EnhancedFormulaTemplate> formules;
  final String chapitre;
  final int level;
  final int nombreQuestions;
  final bool hasInversions;
  final double inversionRatio;

  const InvertedQuizConfiguration({
    required this.formules,
    required this.chapitre,
    required this.level,
    required this.nombreQuestions,
    this.hasInversions = false,
    this.inversionRatio = 0.0,
  });
}

/// =====================================================================================
/// 📚 LISTE UNIFIÉE DE TOUTES LES FORMULES
/// =====================================================================================

/// Liste unifiée regroupant toutes les formules mathématiques de prépa
/// avec métadonnées chapitre et level pour faciliter la gestion
final List<EnhancedFormulaTemplate> allFormulas = [
  // ===== FORMULES BINÔME =====
  EnhancedFormulaTemplate(
    fid: 'F002',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'(a+b)^{n} = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    latexVariable:
        r'({VAR:a}+{VAR:b})^{{VAR:n}} = \sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} {VAR:a}^{{VAR:n}-{VAR:k}} {VAR:b}^{{VAR:k}}',
    description: 'développement général du binôme de Newton',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    parameters: const [
      FormulaParameter(
        name: 'a',
        description: 'première variable (interchangeable avec b)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'b',
        description: 'seconde variable (interchangeable avec a)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F003',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \frac{n!}{k!(n-k)!}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \frac{{VAR:n}!}{{VAR:k}!({VAR:n}-{VAR:k})!}',
    description: 'coefficient binomial de base',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:k} \leq {VAR:n}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'ensemble total (interchangeable avec k)',
        canInvert: true,
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'sous-ensemble choisi (interchangeable avec n)',
        canInvert: true,
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F004',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'(1+a)^{n} = \sum_{k=0}^{n} \binom{n}{k} a^{k}',
    latexVariable:
        r'(1+{VAR:a})^{{VAR:n}} = \sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} {VAR:a}^{{VAR:k}}',
    description: 'développement binomial spécial',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:a} \in \mathbb{R}',
    parameters: const [
      FormulaParameter(
        name: 'a',
        description: 'variable réelle (interchangeable avec 1)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F005',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    isConstant: true, // Résultat = 0 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'exposant (doit être ≥ 1)',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F006',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\sum_{k=r}^{n} \binom{k}{r} = \binom{n+1}{r+1}',
    latexVariable:
        r'\sum_{{VAR:k}={VAR:r}}^{{VAR:n}} \binom{{VAR:k}}{{VAR:r}} = \binom{{VAR:n}+1}{{VAR:r}+1}',
    description: 'identité de hockey-stick',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:r} \in \mathbb{N}, {VAR:n} \geq {VAR:r}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'r',
        description: 'entier inférieur',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F007',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{0} = 1',
    latexVariable: r'\binom{{VAR:n}}{0} = 1',
    description: 'coefficient binomial pour k=0',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    isConstant: true, // Résultat = 1 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier quelconque',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F008',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{n} = 1',
    latexVariable: r'\binom{{VAR:n}}{{VAR:n}} = 1',
    description: 'coefficient binomial pour k=n',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    isConstant: true, // Résultat = 1 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier quelconque',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F009',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}-1}{{VAR:k}} + \binom{{VAR:n}-1}{{VAR:k}-1}',
    description: 'relation de récurrence de Pascal',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:n} \geq 1, 1 \leq {VAR:k} \leq {VAR:n}-1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 1',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'entier entre 1 et n-1',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F010',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} = 2^{n}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} = 2^{{VAR:n}}',
    description: 'formule du binôme pour (1+1)^n',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F011',
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \binom{n}{n-k}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}}{{VAR:n}-{VAR:k}}',
    description: 'propriété de symétrie des coefficients binomiaux',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:k} \leq {VAR:n}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille totale de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice (interchangeable avec n-k)',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // ===== FORMULES COMBINAISONS =====
  EnhancedFormulaTemplate(
    fid: 'F012',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \frac{n!}{k!(n-k)!}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \frac{{VAR:n}!}{{VAR:k}!({VAR:n}-{VAR:k})!}',
    description: 'définition de base des combinaisons',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:k} \leq {VAR:n}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre total d\'éléments',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'nombre d\'éléments à choisir',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F013',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \binom{n}{n-k}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}}{{VAR:n}-{VAR:k}}',
    description: 'symétrie des coefficients binomiaux',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:k} \leq {VAR:n}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille totale',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice (interchangeable avec n-k)',
        canInvert: true,
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F014',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}-1}{{VAR:k}} + \binom{{VAR:n}-1}{{VAR:k}-1}',
    description: 'relation de récurrence du triangle de Pascal',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:k} \in \mathbb{N}, {VAR:n} \geq 1, 1 \leq {VAR:k} \leq {VAR:n}-1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 1',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'entier entre 1 et n-1',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F015',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{0} = 1',
    latexVariable: r'\binom{{VAR:n}}{0} = 1',
    description: 'coefficient binomial pour k=0',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    isConstant: true, // Résultat = 1 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier quelconque',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F016',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{n} = 1',
    latexVariable: r'\binom{{VAR:n}}{{VAR:n}} = 1',
    description: 'coefficient binomial pour k=n',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    isConstant: true, // Résultat = 1 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier quelconque',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F017',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} = 2^{n}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} = 2^{{VAR:n}}',
    description: 'somme de tous les coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F018',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    isConstant: true, // Résultat = 0 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 0',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F019',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} k \binom{n}{k} = n \cdot 2^{n-1}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} {VAR:k} \binom{{VAR:n}}{{VAR:k}} = {VAR:n} \cdot 2^{{VAR:n}-1}',
    description: 'somme pondérée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 0',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F020',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} k^2 \binom{n}{k} = n(n+1) \cdot 2^{n-2}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} {VAR:k}^2 \binom{{VAR:n}}{{VAR:k}} = {VAR:n}({VAR:n}+1) \cdot 2^{{VAR:n}-2}',
    description: 'somme des carrés pondérés des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 1',
        type: ParameterType.NATURAL,
        minValue: 2,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F021',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k}^2 = \binom{2n}{n}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}}^2 = \binom{2{VAR:n}}{{VAR:n}}',
    description: 'identité de Vandermonde',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F022',
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=r}^{n} \binom{k}{r} = \binom{n+1}{r+1}',
    latexVariable:
        r'\sum_{{VAR:k}={VAR:r}}^{{VAR:n}} \binom{{VAR:k}}{{VAR:r}} = \binom{{VAR:n}+1}{{VAR:r}+1}',
    description: 'identité de hockey-stick',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:r} \in \mathbb{N}, {VAR:n} \geq {VAR:r}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'r',
        description: 'entier inférieur',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F023',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} k^3 = \left(\frac{n(n+1)}{2}\right)^2',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}^3 = \left(\frac{{VAR:n}({VAR:n}+1)}{2}\right)^2',
    description: 'somme des cubes des premiers entiers',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre d\'entiers à sommer',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F024',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} q^k = \frac{1-q^{n+1}}{1-q}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} {VAR:q}^{VAR:k} = \frac{1-{VAR:q}^{{VAR:n}+1}}{1-{VAR:q}}',
    description: 'série géométrique finie',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:q} \in \mathbb{R}, {VAR:q} \neq 1',
    parameters: const [
      FormulaParameter(
        name: 'q',
        description: 'raison de la suite (q ≠ 1)',
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 20,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 20,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F025',
    chapitre: 'sommes',
    level: 14,
    latexOrigine:
        r'\sum_{k=0}^{n} k q^k = \frac{q(1-(n+1)q^n + n q^{n+1})}{(1-q)^2}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} {VAR:k} {VAR:q}^{VAR:k} = \frac{{VAR:q}(1-({VAR:n}+1){VAR:q}^{VAR:n} + {VAR:n} {VAR:q}^{{VAR:n}+1})}{(1-{VAR:q})^2}',
    description: 'série arithmético-géométrique',
    conditionLatex:
        r'{VAR:n} \in \mathbb{N}, {VAR:q} \in \mathbb{R}, {VAR:q} \neq 1',
    parameters: const [
      FormulaParameter(
        name: 'q',
        description: 'raison de la suite (q ≠ 1)',
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F026',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} k^4 = \frac{n(n+1)(2n+1)(3n^2+3n-1)}{30}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}^4 = \frac{{VAR:n}({VAR:n}+1)(2{VAR:n}+1)(3{VAR:n}^2+3{VAR:n}-1)}{30}',
    description: 'somme des puissances quatrièmes',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre d\'entiers à sommer',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F027',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} \frac{1}{k(k+1)} = 1 - \frac{1}{n+1}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} \frac{1}{{VAR:k}({VAR:k}+1)} = 1 - \frac{1}{{VAR:n}+1}',
    description: 'somme télescopique',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 50,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 50,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F028',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} k(k+1) = \frac{n(n+1)(n+2)}{3}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}({VAR:k}+1) = \frac{{VAR:n}({VAR:n}+1)({VAR:n}+2)}{3}',
    description: 'somme des produits consécutifs',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F029',
    chapitre: 'sommes',
    level: 14,
    latexOrigine:
        r'\sum_{k=1}^{n} \frac{1}{k^2} = \frac{\pi^2}{6} - \sum_{k=n+1}^{\infty} \frac{1}{k^2}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} \frac{1}{{VAR:k}^2} = \frac{\pi^2}{6} - \sum_{{VAR:k}={VAR:n}+1}^{\infty} \frac{1}{{VAR:k}^2}',
    description: 'somme partielle des inverses des carrés',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 100,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 100,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F030',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} = 2^n',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} = 2^{{VAR:n}}',
    description: 'somme des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F031',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    isConstant: true, // Résultat = 0 (constante)
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'entier supérieur à 0',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  // ===== FORMULES SOMMES =====
  EnhancedFormulaTemplate(
    fid: 'F032',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k} = \frac{{VAR:n}({VAR:n}+1)}{2}',
    description: 'somme des premiers entiers',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre d\'entiers à sommer',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 100,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 100,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    fid: 'F033',
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}^2 = \frac{{VAR:n}({VAR:n}+1)(2{VAR:n}+1)}{6}',
    description: 'somme des carrés des premiers entiers',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre d\'entiers à sommer',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 50,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de sommation',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 50,
      ),
    ],
  ),
];

/// =====================================================================================
/// 🔧 FONCTIONS UTILITAIRES POUR LA LISTE UNIFIÉE
/// =====================================================================================

/// Filtre les formules par chapitre
List<EnhancedFormulaTemplate> getFormulasByChapter(String chapitre) {
  return allFormulas.where((formula) => formula.chapitre == chapitre).toList();
}

/// Filtre les formules par niveau
List<EnhancedFormulaTemplate> getFormulasByLevel(int level) {
  return allFormulas.where((formula) => formula.level == level).toList();
}

/// Filtre les formules par chapitre et niveau
List<EnhancedFormulaTemplate> getFormulasByChapterAndLevel(
    String chapitre, int level) {
  return allFormulas
      .where(
          (formula) => formula.chapitre == chapitre && formula.level == level)
      .toList();
}

/// Obtient tous les chapitres disponibles
List<String> getAvailableChapters() {
  return allFormulas.map((formula) => formula.chapitre).toSet().toList();
}

/// Obtient tous les niveaux disponibles
List<int> getAvailableLevels() {
  return allFormulas.map((formula) => formula.level).toSet().toList()..sort();
}

/// Compte le nombre de formules par chapitre
Map<String, int> getFormulaCountByChapter() {
  final Map<String, int> counts = {};
  for (final formula in allFormulas) {
    counts[formula.chapitre] = (counts[formula.chapitre] ?? 0) + 1;
  }
  return counts;
}

/// Compte le nombre de formules par niveau
Map<int, int> getFormulaCountByLevel() {
  final Map<int, int> counts = {};
  for (final formula in allFormulas) {
    counts[formula.level] = (counts[formula.level] ?? 0) + 1;
  }
  return counts;
}

/// =====================================================================================
/// 🎮 TYPES DE JEUX ET NIVEAUX ÉDUCATIFS
/// =====================================================================================

/// Niveaux éducatifs disponibles dans l'application - 14 niveaux complets
enum NiveauEducatif {
  // Primaire
  cp('CP', 'Cours Préparatoire'),
  ce1('CE1', 'Cours Élémentaire 1'),
  ce2('CE2', 'Cours Élémentaire 2'),
  cm1('CM1', 'Cours Moyen 1'),
  cm2('CM2', 'Cours Moyen 2'),

  // Collège
  sixieme('6ème', 'Sixième'),
  cinquieme('5ème', 'Cinquième'),
  quatrieme('4ème', 'Quatrième'),
  troisieme('3ème', 'Troisième'),

  // Lycée
  seconde('2nde', 'Seconde'),
  premiere('1ère', 'Première'),
  terminale('Term', 'Terminale'),

  // Supérieur
  bacPlus1('Bac+1', 'Bac +1'),
  bacPlus2('Bac+2', 'Bac +2');

  const NiveauEducatif(this.nom, this.description);
  final String nom;
  final String description;
}

/// Catégories de matières éducatives
enum CategorieMatiere {
  mathematiques('Mathématiques', 'Sciences mathématiques'),
  geographie('Géographie', 'Géographie mondiale et continentale');

  const CategorieMatiere(this.nom, this.description);
  final String nom;
  final String description;
}

/// Types de jeux disponibles dans l'application
enum TypeDeJeu {
  habileteMaths(
      'Habileté Calcul', 'Nouveau système de quiz mathématiques avec LaTeX'),
  habileteGeographie('Habileté Géographie', 'Quiz pays et capitales du monde');

  const TypeDeJeu(this.nom, this.description);
  final String nom;
  final String description;
}

/// =====================================================================================
/// 📋 PRÉSÉLECTIONS DE QUESTIONNAIRES
/// =====================================================================================

/// Configuration prédéfinie pour un questionnaire
class QuestionnairePreset {
  final String id;
  final String nom;
  final String description;
  final String titre;
  final String sousTheme;
  final TypeDeJeu typeDeJeu;
  final NiveauEducatif niveau;
  final CategorieMatiere categorie;
  final int nombreQuestions;
  final Duration dureeLimite;
  final List<String> colonneGauche;
  final List<String> colonneDroite;
  final double ratioLargeurColonnes;

  const QuestionnairePreset({
    required this.id,
    required this.nom,
    required this.description,
    required this.titre,
    required this.sousTheme,
    required this.typeDeJeu,
    required this.niveau,
    required this.categorie,
    this.nombreQuestions = 10,
    this.dureeLimite = const Duration(minutes: 30),
    this.colonneGauche = const [],
    this.colonneDroite = const [],
    this.ratioLargeurColonnes = 1.0,
  });

  /// Convertit en EducationalPreset
  EducationalPreset toEducationalPreset() {
    return EducationalPreset(
      id: id,
      nom: nom,
      description: description,
      niveau: niveau,
      categorie: categorie,
      typeDeJeu: typeDeJeu,
      tags: [sousTheme],
    );
  }

  /// Crée une variante du questionnaire avec un niveau de difficulté différent
  QuestionnairePreset withNiveauEducatif(NiveauEducatif newNiveau) {
    return QuestionnairePreset(
      id: '${id}_${newNiveau.name}',
      nom: '$nom (${newNiveau.nom})',
      description: '$description - Niveau ${newNiveau.nom.toLowerCase()}',
      titre: '$titre - ${newNiveau.nom}',
      sousTheme: sousTheme,
      typeDeJeu: typeDeJeu,
      niveau: newNiveau,
      categorie: categorie,
      nombreQuestions: nombreQuestions,
      dureeLimite: dureeLimite,
      colonneGauche: colonneGauche,
      colonneDroite: colonneDroite,
      ratioLargeurColonnes: ratioLargeurColonnes,
    );
  }

  /// Génère toutes les variantes de difficulté pour ce questionnaire
  List<QuestionnairePreset> generateAllDifficultyVariants() {
    return NiveauEducatif.values
        .map((niveau) => withNiveauEducatif(niveau))
        .toList();
  }
}

/// Configuration prédéfinie pour un contenu éducatif
class EducationalPreset {
  final String id;
  final String nom;
  final String description;
  final NiveauEducatif niveau;
  final CategorieMatiere categorie;
  final TypeDeJeu typeDeJeu;
  final List<String> tags;
  final List<String> leftColumn;
  final List<String> rightColumn;

  const EducationalPreset({
    required this.id,
    required this.nom,
    required this.description,
    required this.niveau,
    required this.categorie,
    required this.typeDeJeu,
    this.tags = const [],
    this.leftColumn = const [],
    this.rightColumn = const [],
  });
}

/// =====================================================================================
/// 🧮 GESTIONNAIRE DE FORMULES MATHÉMATIQUES PRÉPA
/// =====================================================================================

/// Gestionnaire principal pour les formules mathématiques de prépa
class PrepaMathFormulaManager {
  /// Obtient toutes les formules disponibles
  List<EnhancedFormulaTemplate> getAllFormulas() => allFormulas;

  /// Obtient les formules par chapitre
  List<EnhancedFormulaTemplate> getFormulasByChapter(String chapitre) {
    return allFormulas
        .where((formula) => formula.chapitre == chapitre)
        .toList();
  }

  /// Obtient les formules par niveau
  List<EnhancedFormulaTemplate> getFormulasByLevel(int level) {
    return allFormulas.where((formula) => formula.level == level).toList();
  }

  /// Obtient les formules par chapitre et niveau
  List<EnhancedFormulaTemplate> getFormulasByChapterAndLevel(
      String chapitre, int level) {
    return allFormulas
        .where(
            (formula) => formula.chapitre == chapitre && formula.level == level)
        .toList();
  }

  /// Obtient tous les chapitres disponibles
  List<String> getAvailableChapters() {
    return allFormulas.map((formula) => formula.chapitre).toSet().toList();
  }

  /// Obtient tous les niveaux disponibles
  List<int> getAvailableLevels() {
    return allFormulas.map((formula) => formula.level).toSet().toList()..sort();
  }

  /// Compte le nombre de formules par chapitre
  Map<String, int> getFormulaCountByChapter() {
    final Map<String, int> counts = {};
    for (final formula in allFormulas) {
      counts[formula.chapitre] = (counts[formula.chapitre] ?? 0) + 1;
    }
    return counts;
  }

  /// Compte le nombre de formules par niveau
  Map<int, int> getFormulaCountByLevel() {
    final Map<int, int> counts = {};
    for (final formula in allFormulas) {
      counts[formula.level] = (counts[formula.level] ?? 0) + 1;
    }
    return counts;
  }

  /// Alias pour la compatibilité avec l'ancien code
  List<EnhancedFormulaTemplate> get binomeFormulas =>
      getFormulasByChapter('binome');
  List<EnhancedFormulaTemplate> get combinaisonsFormulas =>
      getFormulasByChapter('combinaisons');
  List<EnhancedFormulaTemplate> get sommesFormulas =>
      getFormulasByChapter('sommes');

  /// Crée un preset unifié pour les calculs prépa
  EducationalPreset createUnifiedPrepaCalculPreset() {
    return EducationalPreset(
      id: 'unified_prepa_calcul',
      nom: 'Calculs Prépa Unifiés',
      description: 'Formules mathématiques unifiées pour la prépa',
      niveau: NiveauEducatif.bacPlus1,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.habileteMaths,
      tags: ['calcul', 'prépa', 'unifié'],
    );
  }
}

/// =====================================================================================
/// 🎯 GÉNÉRATEUR DE QUIZ
/// =====================================================================================

/// Configuration simple pour un quiz (compatibilité)
class QuizConfiguration {
  final List<EnhancedFormulaTemplate> formules;
  final int nombreQuestions;
  final Duration dureeLimite;
  final bool melangeQuestions;
  final bool afficheCorrections;

  const QuizConfiguration({
    required this.formules,
    this.nombreQuestions = 10,
    this.dureeLimite = const Duration(minutes: 30),
    this.melangeQuestions = true,
    this.afficheCorrections = true,
  });
}

/// Mode de quiz
enum QuizMode {
  entrainement('Entraînement', 'Mode d\'entraînement libre'),
  evaluation('Évaluation', 'Mode d\'évaluation chronométrée'),
  examen('Examen', 'Mode d\'examen formel'),
  mixte('Mixte', 'Mode mixte avec différents types de questions');

  const QuizMode(this.nom, this.description);
  final String nom;
  final String description;
}

/// =====================================================================================
/// 🔄 COMPATIBILITÉ AVEC L'ANCIEN SYSTÈME (OBSOLÈTE)
/// =====================================================================================

/// Instance globale du gestionnaire de formules
final PrepaMathFormulaManager prepaMathFormulaManager =
    PrepaMathFormulaManager();
