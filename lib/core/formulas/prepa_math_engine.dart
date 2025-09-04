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
/// - Fonctions utilitaires pour la gestion des formules
///
/// ÉTAT ACTUEL:
/// - Architecture simplifiée avec liste unifiée
/// - Métadonnées chapitre et level pour chaque formule
/// - Fonctions de filtrage et statistiques
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-30: Refactorisation vers architecture unifiée
/// - Suppression des listes séparées
/// - Ajout des métadonnées chapitre et level
///
/// 🔧 POINTS D'ATTENTION:
/// - Remplacer l'ancien fichier par celui-ci
/// - Mettre à jour les imports dans les autres fichiers
/// - Tester la compatibilité avec l'existant
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Remplacer l'ancien fichier
/// - Mettre à jour les imports
/// - Tester l'application complète
///
/// 🔗 FICHIERS LIÉS:
/// - Ancien prepa_math_engine.dart (à remplacer)
/// - Fichiers utilisant les formules mathématiques
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif mathématique)
/// 📅 Dernière modification: 2025-01-30
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
/// 🧮 TEMPLATE DE FORMULE AVANCÉ
/// =====================================================================================

/// Template de formule mathématique avec calcul automatique et validation
class EnhancedFormulaTemplate {
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
    required this.chapitre,
    required this.level,
    required this.latexOrigine,
    required this.description,
    required this.parameters,
    this.latexVariable = '',
    this.conditionLatex,
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
    return parameters
        .where((param) => param.canInvert)
        .map((param) => param.name)
        .toList();
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
}

/// =====================================================================================
/// 📚 LISTE UNIFIÉE DE TOUTES LES FORMULES
/// =====================================================================================

/// Liste unifiée regroupant toutes les formules mathématiques de prépa
/// avec métadonnées chapitre et level pour faciliter la gestion
final List<EnhancedFormulaTemplate> allFormulas = [
  // ===== FORMULES BINÔME =====
  EnhancedFormulaTemplate(
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
        description: 'ensemble total',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'sous-ensemble choisi',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
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
        description: 'variable réelle',
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
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
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
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{0} = 1',
    latexVariable: r'\binom{{VAR:n}}{0} = 1',
    description: 'coefficient binomial pour k=0',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
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
    chapitre: 'binome',
    level: 14,
    latexOrigine: r'\binom{n}{n} = 1',
    latexVariable: r'\binom{{VAR:n}}{{VAR:n}} = 1',
    description: 'coefficient binomial pour k=n',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
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
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{0} = 1',
    latexVariable: r'\binom{{VAR:n}}{0} = 1',
    description: 'coefficient binomial pour k=0',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
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
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\binom{n}{n} = 1',
    latexVariable: r'\binom{{VAR:n}}{{VAR:n}} = 1',
    description: 'coefficient binomial pour k=n',
    conditionLatex: r'{VAR:n} \in \mathbb{N}',
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
    chapitre: 'combinaisons',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
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
    chapitre: 'sommes',
    level: 14,
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    description: 'somme alternée des coefficients binomiaux',
    conditionLatex: r'{VAR:n} \in \mathbb{N}, {VAR:n} \geq 1',
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

/// Niveaux éducatifs disponibles dans l'application
enum NiveauEducatif {
  primaire('Primaire', 'Niveau primaire'),
  college('Collège', 'Niveau collège'),
  lycee('Lycée', 'Niveau lycée'),
  prepa('Prépa', 'Niveau prépa'),
  superieur('Supérieur', 'Niveau supérieur');

  const NiveauEducatif(this.nom, this.description);
  final String nom;
  final String description;
}

/// Catégories de matières éducatives
enum CategorieMatiere {
  mathematiques('Mathématiques', 'Sciences mathématiques'),
  francais('Français', 'Littérature et langue française'),
  histoire('Histoire', 'Histoire et géographie'),
  sciences('Sciences', 'Sciences naturelles et physiques'),
  langues('Langues', 'Langues étrangères'),
  economie('Économie', 'Sciences économiques'),
  anglais('Anglais', 'Langue anglaise');

  const CategorieMatiere(this.nom, this.description);
  final String nom;
  final String description;
}

/// Types de jeux disponibles dans l'application
enum TypeDeJeu {
  correspondanceVisAVis('Correspondance vis-à-vis', 'Jeu de correspondance'),
  ordreChronologique('Ordre chronologique', 'Jeu de séquence temporelle'),
  combinaisonsMatematiques('Combinaisons mathématiques', 'Jeu de combinaisons'),
  formulairesLatex('Formulaires LaTeX', 'Jeu de formules mathématiques'),
  figuresDeStyle('Figures de Style', 'Jeu de littérature');

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
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      tags: ['calcul', 'prépa', 'unifié'],
    );
  }
}

/// =====================================================================================
/// 🎯 GÉNÉRATEUR DE QUIZ
/// =====================================================================================

/// Configuration pour un quiz
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

/// Générateur de quiz mathématiques
class QuizGenerator {
  final PrepaMathFormulaManager formulaManager;

  const QuizGenerator({required this.formulaManager});

  /// Génère un quiz basé sur la configuration
  QuizConfiguration generateQuiz({
    String? chapitre,
    int? level,
    int nombreQuestions = 10,
    Duration dureeLimite = const Duration(minutes: 30),
  }) {
    List<EnhancedFormulaTemplate> formules;

    if (chapitre != null && level != null) {
      formules = formulaManager.getFormulasByChapterAndLevel(chapitre, level);
    } else if (chapitre != null) {
      formules = formulaManager.getFormulasByChapter(chapitre);
    } else if (level != null) {
      formules = formulaManager.getFormulasByLevel(level);
    } else {
      formules = formulaManager.getAllFormulas();
    }

    return QuizConfiguration(
      formules: formules,
      nombreQuestions: nombreQuestions,
      dureeLimite: dureeLimite,
    );
  }
}

/// =====================================================================================
/// 🔄 COMPATIBILITÉ AVEC L'ANCIEN SYSTÈME
/// =====================================================================================

/// Alias pour la compatibilité avec l'ancien code
final List<EnhancedFormulaTemplate> enhancedBinomeTemplates =
    getFormulasByChapter('binome');
final List<EnhancedFormulaTemplate> enhancedCombinaisonsTemplates =
    getFormulasByChapter('combinaisons');
final List<EnhancedFormulaTemplate> enhancedSommesTemplates =
    getFormulasByChapter('sommes');

/// Instance globale du gestionnaire de formules
final PrepaMathFormulaManager prepaMathFormulaManager =
    PrepaMathFormulaManager();

/// Instance globale du générateur de quiz
final QuizGenerator quizGenerator =
    QuizGenerator(formulaManager: prepaMathFormulaManager);
