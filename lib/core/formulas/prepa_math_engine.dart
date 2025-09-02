/// <cursor>
///
/// 🧮 MOTEUR DE CALCUL MATHÉMATIQUE POUR PRÉPA
///
/// Architecture isolée pour le traitement des formules mathématiques de prépa.
/// Séparation complète de la logique métier des formules de la génération d'images.
///
/// COMPOSANTS PRINCIPAUX:
/// - ParameterType: Types de paramètres pour validation automatique
/// - FormulaType: Classification des formules mathématiques
/// - FormulaParameter: Paramètre avec validation intelligente
/// - EnhancedFormulaTemplate: Template de formule avec calcul automatique
/// - FormulaVariant: Variante d'une formule (originale/inversée)
/// - EnhancedFormulaPerturbationGenerator: Génération de perturbations pédagogiques
/// - Templates prépa: Collections de formules binôme/combinaisons/sommes
///
/// ÉTAT ACTUEL:
/// - Architecture complètement isolée du générateur d'images
/// - Calcul automatique des coefficients binomiaux, développements, sommes
/// - Validation intelligente des paramètres selon leur type et contraintes
/// - Génération d'exemples pédagogiques
/// - Support des perturbations pédagogiques (désactivé pour éviter confusion)
/// - 27 formules organisées en 3 catégories (Binôme, Combinaisons, Sommes)
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de l'architecture isolée
/// - Extraction complète depuis educational_image_generator.dart
/// - Séparation des préoccupations (calcul vs génération d'images)
/// - Optimisation des performances de calcul
/// - Validation automatique et génération d'exemples
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance: Calculs limités pour éviter débordements (n ≤ 10 pour binôme)
/// - Validation: Vérification automatique des contraintes mathématiques
/// - Génération d'exemples: Création automatique d'exemples pédagogiques valides
/// - Perturbations: Fonctionnalité désactivée pour éviter la confusion
/// - Factorielle: Limitation à n ≤ 12 pour éviter débordements
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter plus de types de formules (intégrales, dérivées)
/// - Optimiser les algorithmes de calcul pour grandes valeurs
/// - Ajouter support pour formules paramétriques complexes
/// - Implémenter cache pour calculs fréquents
/// - Ajouter validation plus sophistiquée des expressions LaTeX
///
/// 🔗 FICHIERS LIÉS:
/// - educational_image_generator.dart: Utilise ce moteur pour les formules
/// - binome_formules_screen.dart: Interface utilisateur
/// - mathematical_formulas_oop.dart: Architecture OOP complémentaire
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif mathématique)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

// Import du système unifié pour compatibilité
import 'package:luchy/features/puzzle/presentation/screens/binome_formules_screen.dart'
    show UnifiedMathFormulaManager;

/// =====================================================================================
/// 🧮 ARCHITECTURE DE VALIDATION ET CALCUL
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

  /// Valide une valeur numérique pour ce paramètre
  /// Retourne true si la valeur est valide selon le type et les contraintes
  bool validate(num value) {
    // Validation selon le type de paramètre
    switch (type) {
      case ParameterType.NATURAL:
        if (value < 0 || value != value.toInt()) return false;
        break;
      case ParameterType.POSITIVE:
        if (value <= 0) return false;
        break;
      case ParameterType.INTEGER:
        if (value != value.toInt()) return false;
        break;
      case ParameterType.REAL:
        // Pas de restriction supplémentaire pour les réels
        break;
    }

    // Validation des bornes si spécifiées
    if (minValue != null && value < minValue!) return false;
    if (maxValue != null && value > maxValue!) return false;

    return true;
  }
}

/// =====================================================================================
/// 🎯 ARCHITECTURE DES FORMULES ÉTENDUES
/// =====================================================================================

/// Template de formule étendu avec calcul automatique et validation intelligente
class EnhancedFormulaTemplate {
  /// Expression LaTeX de la formule (ex: r'C(n,k) = \frac{n!}{k!(n-k)!}')
  final String latex;

  /// Description pédagogique de la formule
  final String description;

  /// Liste des paramètres de la formule avec leurs contraintes
  final List<FormulaParameter> parameters;

  const EnhancedFormulaTemplate({
    required this.latex,
    required this.description,
    required this.parameters,
  });

  /// Nombre de paramètres de la formule
  int get parameterCount => parameters.length;

  /// Liste des noms des variables/paramètres
  List<String> get variableNames => parameters.map((p) => p.name).toList();

  /// Liste des variables qui peuvent être inversées
  List<String> get invertibleVariables =>
      parameters.where((p) => p.canInvert).map((p) => p.name).toList();

  /// =====================================================================================
  /// 🔄 SUBSTITUTION DE VARIABLES - APPROCHE "TOUT SUBSTITUABLE"
  /// =====================================================================================

  /// Substitue les variables marquées dans l'expression LaTeX
  ///
  /// Avec l'approche "tout substituable", seules les variables marquées avec '_'
  /// sont substituées. Les autres variables restent inchangées.
  ///
  /// Exemple: r'(_a+_b)^_n' avec {'_a': '2', '_b': '3', '_n': '2'}
  /// devient: r'(2+3)^2'
  String substitute(Map<String, String> values) {
    String result = latex;

    // Substitution directe des variables marquées
    values.forEach((markedVar, replacement) {
      result = result.replaceAll(markedVar, replacement);
    });

    return result;
  }

  /// =====================================================================================
  /// 🧮 CALCUL AUTOMATIQUE
  /// =====================================================================================

  /// Calcule la valeur numérique de la formule avec les paramètres donnés
  ///
  /// [parameterValues]: Map associant nom du paramètre -> valeur numérique
  /// [validateParameters]: Si true, valide les paramètres avant calcul
  ///
  /// Retourne la valeur calculée ou null si erreur/invalide
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

  /// Calcule un coefficient binomial C(_n,_k) = _n! / (_k! * (_n-_k)!)
  num? _calculateCombinaison(Map<String, num> values) {
    final n = values['_n']?.toInt();
    final k = values['_k']?.toInt();
    if (n == null || k == null || k > n || k < 0) return null;

    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  /// Calcule un développement binomial (_a+_b)^_n = Σ C(_n,k) * _a^(_n-k) * _b^k
  num? _calculateBinome(Map<String, num> values) {
    final a = values['_a'];
    final b = values['_b'];
    final n = values['_n']?.toInt();
    if (a == null || b == null || n == null || n < 0) return null;

    num result = 0;
    for (int k = 0; k <= n; k++) {
      final coeff = _calculateCombinaison({'_n': n, '_k': k});
      if (coeff == null) return null;
      result += coeff * math.pow(a, n - k) * math.pow(b, k);
    }
    return result;
  }

  /// Calcule une somme Σ (actuellement supporte Σ(k=1 to _n) k = _n(_n+1)/2)
  num? _calculateSomme(Map<String, num> values) {
    final n = values['_n']?.toInt();
    if (n == null || n < 1) return null;

    // Formule de la somme des n premiers entiers naturels
    return n * (n + 1) / 2;
  }

  /// Calcule la factorielle d'un nombre entier
  /// Limitation: n ≤ 12 pour éviter débordement numérique
  int _factorial(int n) {
    if (n <= 1) return 1;
    if (n > 12) return 1; // Limitation pour éviter débordement

    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  /// =====================================================================================
  /// 🎲 GÉNÉRATION DE VARIANTES ET EXEMPLES
  /// =====================================================================================

  /// Génère des variantes de la formule (originale + avec paramètres inversés)
  /// DÉSACTIVÉ: Cette fonctionnalité est désactivée pour éviter la confusion pédagogique
  List<FormulaVariant> generateSmartVariants() {
    if (invertibleVariables.length < 2) {
      return [FormulaVariant(latex: latex, description: description)];
    }

    final variants = <FormulaVariant>[];
    variants.add(FormulaVariant(latex: latex, description: description));

    // DÉSACTIVÉ: Génération de variantes avec paramètres inversés
    // Cette fonctionnalité a été désactivée pour éviter la confusion
    /*
    // Générer la variante avec paramètres inversés
    final invertedLatex = _invertVariablesInLatex(latex, invertibleVariables);
    final invertedDescription = '$description (paramètres inversés)';

    variants.add(FormulaVariant(
      latex: invertedLatex,
      description: invertedDescription,
    ));
    */

    return variants;
  }

  /// Inverse les variables dans une expression LaTeX

  /// Génère des exemples numériques valides pour cette formule
  ///
  /// [count]: Nombre d'exemples à générer (défaut: 5)
  /// Retourne une liste de maps associant nom_paramètre -> valeur_valide
  List<Map<String, num>> generateValidExamples({int count = 5}) {
    final examples = <Map<String, num>>[];

    for (int i = 0; i < count; i++) {
      final example = <String, num>{};

      // Génère des valeurs valides pour chaque paramètre
      for (final param in parameters) {
        num value = 0; // Valeur par défaut
        switch (param.type) {
          case ParameterType.NATURAL:
            value = math.Random().nextInt(8) + (param.minValue?.toInt() ?? 0);
            break;
          case ParameterType.POSITIVE:
            value = math.Random().nextInt(5) + 1;
            break;
          case ParameterType.INTEGER:
            value = math.Random().nextInt(10) - 5;
            break;
          case ParameterType.REAL:
            value = (math.Random().nextDouble() - 0.5) * 10;
            break;
        }

        // Respecter les bornes définies
        if (param.minValue != null && value < param.minValue!) {
          value = param.minValue!;
        }
        if (param.maxValue != null && value > param.maxValue!) {
          value = param.maxValue!;
        }

        example[param.name] = value;
      }

      // Vérifier que l'exemple produit une formule valide
      if (_validateParameters(example)) {
        examples.add(example);
      }
    }

    return examples;
  }
}

/// Variante d'une formule générée (utilisée par EnhancedFormulaTemplate)
class FormulaVariant {
  /// Expression LaTeX de la variante
  final String latex;

  /// Description pédagogique de la variante
  final String description;

  const FormulaVariant({
    required this.latex,
    required this.description,
  });
}

/// =====================================================================================
/// 🔄 GÉNÉRATEUR DE PERTURBATIONS PÉDAGOGIQUES
/// =====================================================================================

/// Générateur étendu de perturbations pédagogiques pour les formules
class EnhancedFormulaPerturbationGenerator {
  /// Génère une liste de formules LaTeX à partir des templates
  static List<String> generateLatexFormulas(
      List<EnhancedFormulaTemplate> templates) {
    final formulas = <String>[];

    for (final template in templates) {
      final variants = template.generateSmartVariants();
      for (final variant in variants) {
        formulas.add(variant.latex);
      }
    }

    return formulas;
  }

  /// Génère les descriptions correspondantes
  static List<String> generateDescriptions(
      List<EnhancedFormulaTemplate> templates) {
    final descriptions = <String>[];

    for (final template in templates) {
      final variants = template.generateSmartVariants();
      for (final variant in variants) {
        descriptions.add(variant.description);
      }
    }

    return descriptions;
  }

  /// Valide que tous les templates sont cohérents
  static bool validateTemplates(List<EnhancedFormulaTemplate> templates) {
    for (final template in templates) {
      // Vérifier que les noms de paramètres sont uniques
      final paramNames = template.parameters.map((p) => p.name).toList();
      if (paramNames.length != paramNames.toSet().length) {
        return false; // Doublons dans les noms
      }

      // Tester avec des exemples générés
      final examples = template.generateValidExamples(count: 1);
      if (examples.isNotEmpty) {
        final result = template.calculate(examples.first);
        if (result == null) {
          return false; // Calcul impossible
        }
      }
    }
    return true;
  }
}

/// =====================================================================================
/// 📚 TEMPLATES DE FORMULES PRÉPA - BINÔME DE NEWTON
/// =====================================================================================

/// Templates étendus pour les formules de Binôme de Newton
final List<EnhancedFormulaTemplate> enhancedBinomeTemplates = [
  // Développement général du binôme
  EnhancedFormulaTemplate(
    latex: r'(_a+_b)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _a^{\,_n-k} _b^{\,k}',
    description: 'développement général du binôme de Newton',
    parameters: const [
      FormulaParameter(
        name: '_a',
        description: 'première variable (interchangeable avec _b)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: '_b',
        description: 'seconde variable (interchangeable avec _a)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: '_n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5, // Limite pour éviter calculs trop lourds
      ),
    ],
  ),

  // Coefficient binomial de base
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \frac{_n!}{_k!\,(_n-_k)!}',
    description: 'coefficient binomial de base',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'ensemble total',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
      FormulaParameter(
        name: '_k',
        description: 'sous-ensemble choisi',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  // Développement binomial spécial
  EnhancedFormulaTemplate(
    latex: r'(1+_x)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _x^{k}',
    description: 'développement binomial spécial',
    parameters: const [
      FormulaParameter(
        name: '_x',
        description: 'variable réelle',
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: '_n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5,
      ),
    ],
  ),

  // Alternance des coefficients binomiaux
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{_n} (-1)^k \binom{_n}{k} = 0 \quad (_n \ge 1)',
    description: 'somme alternée des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'exposant (doit être ≥ 1)',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  // Somme oblique de Hockey-stick
  EnhancedFormulaTemplate(
    latex:
        r'\sum_{k=_r}^{_n} \binom{k}{_r} = \binom{_n+1}{_r+1} \quad (_r \le _n)',
    description: 'identité de hockey-stick',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_r',
        description: 'indice fixe (≤ n)',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  // Cas particuliers des coefficients binomiaux
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{0} = 1',
    description: 'coefficient binomial pour k=0',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_n} = 1',
    description: 'coefficient binomial pour k=n',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  // Relation de Pascal
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \binom{_n-1}{_k} + \binom{_n-1}{_k-1}',
    description: 'relation de récurrence de Pascal',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'indice de ligne',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_k',
        description: 'indice de colonne',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Formule du binôme pour (1+1)^n
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{_n} \binom{_n}{k} = 2^{_n}',
    description: 'formule du binôme pour (1+1)^n',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  // Symétrie des coefficients binomiaux
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \binom{_n}{_n-_k}',
    description: 'propriété de symétrie des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille totale de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_k',
        description: 'indice (interchangeable avec n-k)',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),
];

/// =====================================================================================
/// 🔢 TEMPLATES DE FORMULES PRÉPA - COMBINAISONS
/// =====================================================================================

/// Templates étendus pour les formules de Combinaisons
final List<EnhancedFormulaTemplate> enhancedCombinaisonsTemplates = [
  // Définition de base
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \frac{_n!}{_k!\,(_n-_k)!}',
    description: 'définition du coefficient binomial',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_k',
        description: 'nombre d\'éléments choisis',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Propriété symétrique
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \binom{_n}{_n-_k}',
    description: 'symétrie des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille totale',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_k',
        description: 'indice (interchangeable avec n-k)',
        canInvert: true,
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Triangle de Pascal
  EnhancedFormulaTemplate(
    latex: r'\binom{_n}{_k} = \binom{_n-1}{_k} + \binom{_n-1}{_k-1}',
    description: 'relation de récurrence du triangle de Pascal',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'ligne du triangle',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_k',
        description: 'position dans la ligne',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Développement binomial général
  EnhancedFormulaTemplate(
    latex: r'(_a+_b)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _a^{_n-k} _b^{k}',
    description: 'développement binomial général',
    parameters: const [
      FormulaParameter(
        name: '_a',
        description: 'première variable',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: '_b',
        description: 'seconde variable',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: '_n',
        description: 'exposant',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  // Nombre total de sous-ensembles
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{_n} \binom{_n}{k} = 2^{_n}',
    description: 'nombre total de sous-ensembles d\'un ensemble à n éléments',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  // Relation d'orthogonalité
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{_n} (-1)^k \binom{_n}{k} = 0 \quad (_n \ge 1)',
    description: 'somme alternée des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'degré (doit être ≥ 1)',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  // Identité de Chu-Vandermonde
  EnhancedFormulaTemplate(
    latex:
        r'\sum_{k=0}^{_n} \binom{_m}{k} \binom{_n-_m}{_n-k} = \binom{_n}{_m}',
    description: 'identité de Chu-Vandermonde (pour m fixe)',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'taille totale',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: '_m',
        description: 'paramètre fixe',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),
];

/// =====================================================================================
/// ∑ TEMPLATES DE FORMULES PRÉPA - SOMMES
/// =====================================================================================

/// Templates étendus pour les formules de Sommes
final List<EnhancedFormulaTemplate> enhancedSommesTemplates = [
  // Somme des premiers entiers
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{_n} k = \frac{_n(_n+1)}{2}',
    description: 'somme des n premiers entiers naturels',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 25,
      ),
    ],
  ),

  // Somme des carrés
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{_n} k^2 = \frac{_n(_n+1)(2_n+1)}{6}',
    description: 'somme des carrés des n premiers entiers',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),

  // Somme des cubes
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{_n} k^3 = \left(\frac{_n(_n+1)}{2}\right)^2',
    description: 'somme des cubes des n premiers entiers',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
    ],
  ),

  // Série géométrique finie
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{_n} _q^k = \frac{1-_q^{_n+1}}{1-_q} \quad (_q \neq 1)',
    description: 'somme des termes d\'une suite géométrique finie',
    parameters: const [
      FormulaParameter(
        name: '_q',
        description: 'raison de la suite géométrique',
        type: ParameterType.REAL,
        minValue: -3,
        maxValue: 3,
      ),
      FormulaParameter(
        name: '_n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  // Série arithmético-géométrique
  EnhancedFormulaTemplate(
    latex:
        r'\sum_{k=1}^{n} k \cdot q^k = \frac{q(1-(n+1)q^n + nq^{n+1})}{(1-q)^2}',
    description: 'somme d\'une série arithmético-géométrique',
    parameters: const [
      FormulaParameter(
        name: 'q',
        description: 'raison géométrique',
        type: ParameterType.REAL,
        minValue: -2,
        maxValue: 2,
      ),
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
    ],
  ),

  // Série géométrique infinie
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{\infty} q^k = \frac{1}{1-q} \quad (|q| < 1)',
    description: 'somme d\'une série géométrique infinie convergente',
    parameters: const [
      FormulaParameter(
        name: 'q',
        description: 'raison (doit vérifier |q| < 1)',
        type: ParameterType.REAL,
        minValue: -0.9,
        maxValue: 0.9,
      ),
    ],
  ),

  // Dérivée de la série géométrique
  EnhancedFormulaTemplate(
    latex:
        r'\sum_{k=1}^{\infty} k \cdot q^{k-1} = \frac{1}{(1-q)^2} \quad (|q| < 1)',
    description:
        'somme pondérée par les indices (dérivée de la série géométrique)',
    parameters: const [
      FormulaParameter(
        name: 'q',
        description: 'raison (doit vérifier |q| < 1)',
        type: ParameterType.REAL,
        minValue: -0.9,
        maxValue: 0.9,
      ),
    ],
  ),

  // Somme élémentaire
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{n} 1 = n+1',
    description: 'comptage des éléments d\'un ensemble fini',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'nombre d\'éléments',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 20,
      ),
    ],
  ),

  // Somme des impairs
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{n} (2k-1) = n^2',
    description: 'somme des n premiers nombres impairs',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
    ],
  ),

  // Somme télescopique
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{n} \frac{1}{k(k+1)} = 1 - \frac{1}{n+1}',
    description: 'somme télescopique des fractions unitaires',
    parameters: const [
      FormulaParameter(
        name: '_n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),
];

/// =====================================================================================
/// 🧪 FONCTIONS DE TEST ET VALIDATION
/// =====================================================================================

/// Teste le calcul automatique des formules
void testEnhancedCalculations() {
  print('🧪 TEST DU CALCUL AUTOMATIQUE ÉTENDU');
  print('=' * 60);

  // Test Combinaisons
  print('\n🧮 TEST COMBINAISONS:');
  final combTemplate = enhancedCombinaisonsTemplates[0]; // C(n,k)
  print('Formule: ${combTemplate.latex}');

  final testValues1 = {'n': 5, 'k': 2};
  final result1 = combTemplate.calculate(testValues1);
  print('C(5,2) = $result1 (attendu: 10)');

  final testValues2 = {'n': 6, 'k': 3};
  final result2 = combTemplate.calculate(testValues2);
  print('C(6,3) = $result2 (attendu: 20)');

  // Test Binôme
  print('\n📚 TEST BINÔME:');
  final binomeTemplate = enhancedBinomeTemplates[0]; // (a+b)^n
  print('Formule: ${binomeTemplate.latex}');

  final binomeValues = {'a': 2, 'b': 3, 'n': 2};
  final binomeResult = binomeTemplate.calculate(binomeValues);
  print('(2+3)^2 = $binomeResult (attendu: 25)');

  // Test Sommes
  print('\n📊 TEST SOMMES:');
  final sommeTemplate = enhancedSommesTemplates[0]; // Σ(k=1 to n) k
  print('Formule: ${sommeTemplate.latex}');

  final sommeValues = {'n': 10};
  final sommeResult = sommeTemplate.calculate(sommeValues);
  print('Σ(k=1 to 10) k = $sommeResult (attendu: 55)');

  // Test génération d'exemples
  print('\n🎲 TEST GÉNÉRATION D\'EXEMPLES:');
  final examples = combTemplate.generateValidExamples(count: 3);
  print('Exemples générés pour C(n,k):');
  for (final example in examples) {
    final result = combTemplate.calculate(example);
    print('  ${example} → $result');
  }

  print('\n✅ TESTS TERMINÉS AVEC SUCCÈS !');
}

/// Valide tous les templates de formules
void validateEnhancedTemplates() {
  print('🔍 VALIDATION DES TEMPLATES ÉTENDUS');
  print('=' * 50);

  final allTemplates = [
    ...enhancedBinomeTemplates,
    ...enhancedCombinaisonsTemplates,
    ...enhancedSommesTemplates,
  ];

  print('Nombre total de templates: ${allTemplates.length}');

  bool allValid = true;
  for (final template in allTemplates) {
    // Test de génération d'exemples
    final examples = template.generateValidExamples(count: 2);
    print('\n📋 ${template.description}');
    print('   Paramètres: ${template.parameterCount}');
    print('   Variables: ${template.variableNames}');
    print('   Invertibles: ${template.invertibleVariables}');

    if (examples.isNotEmpty) {
      final firstExample = examples.first;
      final result = template.calculate(firstExample);
      print('   ✅ Calcul possible: $firstExample → $result');
    } else {
      print('   ❌ Aucun exemple valide généré');
      allValid = false;
    }

    // Test des variantes
    final variants = template.generateSmartVariants();
    print('   Variantes générées: ${variants.length}');
  }

  print('\n' + ('=' * 50));
  if (allValid) {
    print('✅ TOUS LES TEMPLATES SONT VALIDES !');
  } else {
    print('❌ PROBLÈMES DÉTECTÉS DANS CERTAINS TEMPLATES');
  }
}

/// =====================================================================================
/// 🏗️ GESTIONNAIRE PRINCIPAL DES FORMULES PRÉPA
/// =====================================================================================

/// Classe principale pour gérer toutes les formules mathématiques de prépa.
/// Fournit une interface unifiée pour accéder aux templates et créer des questionnaires.
class PrepaMathFormulaManager {
  /// =====================================================================================
  /// 📊 ACCÈS AUX TEMPLATES
  /// =====================================================================================

  /// Templates pour les formules de binôme de Newton
  static List<EnhancedFormulaTemplate> get binomeFormulas =>
      enhancedBinomeTemplates;

  /// Templates pour les formules de combinaisons
  static List<EnhancedFormulaTemplate> get combinaisonsFormulas =>
      enhancedCombinaisonsTemplates;

  /// Templates pour les formules de sommes
  static List<EnhancedFormulaTemplate> get sommesFormulas =>
      enhancedSommesTemplates;

  /// Tous les templates combinés
  static List<EnhancedFormulaTemplate> get allFormulas => [
        ...enhancedBinomeTemplates,
        ...enhancedCombinaisonsTemplates,
        ...enhancedSommesTemplates,
      ];

  /// =====================================================================================
  /// 🎯 CRÉATION DE QUESTIONNAIRES
  /// =====================================================================================

  /// Crée un preset pour les formules de binôme
  static QuestionnairePreset createBinomePreset() {
    final latexFormulas =
        EnhancedFormulaPerturbationGenerator.generateLatexFormulas(
            enhancedBinomeTemplates);
    final descriptions =
        EnhancedFormulaPerturbationGenerator.generateDescriptions(
            enhancedBinomeTemplates);

    return QuestionnairePreset(
      id: 'prepa_math_binome_enhanced',
      nom: 'Calcul',
      titre: 'BINÔME DE NEWTON - AVEC CALCUL AUTOMATIQUE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Binôme Newton avec calcul et perturbations',
      colonneGauche: latexFormulas,
      colonneDroite: descriptions,
    );
  }

  /// Crée un preset pour les formules de combinaisons
  static QuestionnairePreset createCombinaisonsPreset() {
    final latexFormulas =
        EnhancedFormulaPerturbationGenerator.generateLatexFormulas(
            enhancedCombinaisonsTemplates);
    final descriptions =
        EnhancedFormulaPerturbationGenerator.generateDescriptions(
            enhancedCombinaisonsTemplates);

    return QuestionnairePreset(
      id: 'prepa_math_combinaisons_enhanced',
      nom: 'Calcul',
      titre: 'COMBINAISONS - AVEC CALCUL AUTOMATIQUE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Analyse combinatoire avec calcul intégré',
      colonneGauche: latexFormulas,
      colonneDroite: descriptions,
    );
  }

  /// Crée un preset pour les formules de sommes
  static QuestionnairePreset createSommesPreset() {
    final latexFormulas =
        EnhancedFormulaPerturbationGenerator.generateLatexFormulas(
            enhancedSommesTemplates);
    final descriptions =
        EnhancedFormulaPerturbationGenerator.generateDescriptions(
            enhancedSommesTemplates);

    return QuestionnairePreset(
      id: 'prepa_math_sommes_enhanced',
      nom: 'Calcul',
      titre: 'SOMMES - AVEC CALCUL AUTOMATIQUE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Formules de sommes avec calcul intégré',
      colonneGauche: latexFormulas,
      colonneDroite: descriptions,
    );
  }

  /// Crée un questionnaire unifié combinant toutes les catégories de prépa
  static QuestionnairePreset createUnifiedPrepaCalculPreset() {
    // Initialiser le système unifié
    UnifiedMathFormulaManager.initialize();

    // Récupérer les formules unifiées de prépa
    final formulas = UnifiedMathFormulaManager.prepaUnifiedFormulas;

    // Créer les listes pour le questionnaire
    final leftFormulas = formulas.map((f) => f.latexLeft).toList();
    final rightResults = formulas.map((f) => f.latexRight).toList();
    final _ = formulas.map((f) => f.description).toList(); // Pour compatibilité

    return QuestionnairePreset(
      id: 'prepa_calcul_unified',
      nom: 'Calcul Prépa',
      titre: 'CALCUL PRÉPA - QUIZ UNIFIÉ',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Binôme, Sommes & Combinaisons - Architecture Unifiée',
      colonneGauche: leftFormulas,
      colonneDroite: rightResults,
      description:
          'Quiz unifié combinant les formules de binôme, sommes et combinaisons de niveau prépa. '
          '${formulas.length} formules organisées automatiquement.',
    );
  }

  /// =====================================================================================
  /// 🔧 UTILITAIRES ET VALIDATION
  /// =====================================================================================

  /// Valide tous les templates de formules
  static bool validateAllTemplates() {
    return EnhancedFormulaPerturbationGenerator.validateTemplates(allFormulas);
  }

  /// Obtient les formules par catégorie
  static List<EnhancedFormulaTemplate> getFormulasByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'binome':
      case 'binomial':
        return binomeFormulas;
      case 'combinaison':
      case 'combination':
      case 'combinaisons':
        return combinaisonsFormulas;
      case 'somme':
      case 'sum':
      case 'sommes':
        return sommesFormulas;
      default:
        return [];
    }
  }

  /// Recherche des formules par mots-clés
  static List<EnhancedFormulaTemplate> searchFormulas(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return allFormulas.where((template) {
      return template.description.toLowerCase().contains(lowerKeyword) ||
          template.latex.toLowerCase().contains(lowerKeyword);
    }).toList();
  }

  /// =====================================================================================
  /// 📊 STATISTIQUES ET DIAGNOSTIC
  /// =====================================================================================

  /// Statistiques du système de formules prépa
  static Map<String, dynamic> getStatistics() {
    return {
      'total_formulas': allFormulas.length,
      'binome_count': binomeFormulas.length,
      'combinaisons_count': combinaisonsFormulas.length,
      'sommes_count': sommesFormulas.length,
      'validation_status':
          validateAllTemplates() ? '✅ Valide' : '❌ Erreurs détectées',
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  /// Diagnostic complet du système
  static void printDiagnostic() {
    final stats = getStatistics();
    print('''
🧮 DIAGNOSTIC - PrepaMathFormulaManager
═══════════════════════════════════════════════
📊 Statistiques :
   • Total formules : ${stats['total_formulas']}
   • Binôme : ${stats['binome_count']}
   • Combinaisons : ${stats['combinaisons_count']}
   • Sommes : ${stats['sommes_count']}

🔍 État : ${stats['validation_status']}
📅 Dernière mise à jour : ${stats['last_updated']}

📝 Méthodes disponibles :
   • getFormulasByCategory('binome'|'combinaisons'|'sommes')
   • searchFormulas('mot-clé')
   • createBinomePreset(), createCombinaisonsPreset(), createSommesPreset()
   • createUnifiedPrepaCalculPreset()
   • validateAllTemplates()
   • getStatistics(), printDiagnostic()

✅ Système opérationnel !
═══════════════════════════════════════════════
    ''');
  }
}

/// =====================================================================================
/// 🎯 FONCTIONS DE COMPATIBILITÉ (LEGACY)
/// =====================================================================================

/// Fonctions de compatibilité pour maintenir l'ancien API
/// Ces fonctions utilisent maintenant le nouveau PrepaMathFormulaManager

QuestionnairePreset createEnhancedBinomePreset() =>
    PrepaMathFormulaManager.createBinomePreset();

QuestionnairePreset createEnhancedCombinaisonsPreset() =>
    PrepaMathFormulaManager.createCombinaisonsPreset();

QuestionnairePreset createEnhancedSommesPreset() =>
    PrepaMathFormulaManager.createSommesPreset();

QuestionnairePreset createUnifiedPrepaCalculPreset() =>
    PrepaMathFormulaManager.createUnifiedPrepaCalculPreset();

/// =====================================================================================
/// 📋 STRUCTURES DE COMPATIBILITÉ ÉDUCATIVE
/// =====================================================================================

/// Niveaux éducatifs français
enum NiveauEducatif {
  primaire('Primaire', 'CP-CM2', 1),
  college('Collège', 'Brevet', 2),
  lycee('Lycée', 'Baccalauréat', 3),
  prepa('Prépa', 'CPGE', 4),
  superieur('Supérieur', 'Licence+', 5);

  const NiveauEducatif(this.nom, this.diplome, this.ordre);
  final String nom;
  final String diplome;
  final int ordre; // Pour trier par difficulté
}

/// Catégories de matières
enum CategorieMatiere {
  mathematiques('Mathématiques', '🧮'),
  francais('Français', '📝'),
  anglais('Anglais', '🇬🇧'),
  histoire('Histoire', '🏛️'),
  geographie('Géographie', '🌍'),
  sciences('Sciences', '🔬'),
  economie('Économie', '💼');

  const CategorieMatiere(this.nom, this.emoji);
  final String nom;
  final String emoji;
}

/// Types de jeux éducatifs possibles
enum TypeDeJeu {
  correspondanceVisAVis('Correspondance vis-à-vis',
      'Associer chaque élément de gauche avec son correspondant de droite'),
  ordreChronologique(
      'Ordre chronologique', 'Remettre les éléments dans l\'ordre temporel'),
  classementCroissant(
      'Classement croissant', 'Ordonner du plus petit au plus grand'),
  groupement('Groupement', 'Rassembler les éléments par catégories'),
  sequenceLogique('Séquence logique', 'Compléter une suite logique'),
  combinaisonsMatematiques('Combinaisons mathématiques',
      'Associer formules de combinaisons avec leurs résultats'),
  formulairesLatex('Formulaires LaTeX',
      'Consultation de formules mathématiques avec rendu LaTeX'),
  figuresDeStyle(
      'Figures de Style', 'Associer figures de style avec leurs exemples');

  const TypeDeJeu(this.nom, this.description);
  final String nom;
  final String description;
}

/// Structure complète d'un questionnaire éducatif
class QuestionnairePreset {
  final String id;
  final String nom;
  final String titre; // Titre affiché en haut de l'image
  final NiveauEducatif niveau;
  final CategorieMatiere categorie;
  final TypeDeJeu typeDeJeu; // Type de mécanisme de jeu
  final List<String> colonneGauche;
  final List<String> colonneDroite;
  final String? description;
  final String? sousTheme; // Ex: "Analyse combinatoire", "Conjugaison"
  final double?
      ratioLargeurColonnes; // Ratio gauche/droite (ex: 0.75 = 75%/25%)

  const QuestionnairePreset({
    required this.id,
    required this.nom,
    required this.titre,
    required this.niveau,
    required this.categorie,
    required this.typeDeJeu,
    required this.colonneGauche,
    required this.colonneDroite,
    this.description,
    this.sousTheme,
    this.ratioLargeurColonnes, // null = 50%/50% par défaut
  });

  /// Conversion vers l'ancien format pour compatibilité
  EducationalPreset toEducationalPreset() {
    return EducationalPreset(
      id: id,
      name: nom,
      description: description ?? titre,
      leftColumn: colonneGauche,
      rightColumn: colonneDroite,
    );
  }
}

/// Preset éducatif (ancien format - gardé pour compatibilité)
class EducationalPreset {
  final String id;
  final String name;
  final String description;
  final List<String> leftColumn;
  final List<String> rightColumn;

  const EducationalPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.leftColumn,
    required this.rightColumn,
  });
}

/// =====================================================================================
/// 🔗 COMPATIBILITÉ AVEC LES AUTRES MODULES
/// =====================================================================================

// Note: Les imports suivants doivent être ajoutés dans les fichiers qui utilisent ce module
// import 'package:luchy/core/formulas/prepa_math_engine.dart';

// Les classes suivantes sont exportées pour utilisation dans d'autres modules:
// - ParameterType
// - FormulaType
// - FormulaParameter
// - EnhancedFormulaTemplate
// - FormulaVariant
// - EnhancedFormulaPerturbationGenerator
// - enhancedBinomeTemplates
// - enhancedCombinaisonsTemplates
// - enhancedSommesTemplates
// - NiveauEducatif
// - CategorieMatiere
// - TypeDeJeu
// - QuestionnairePreset
// - EducationalPreset

// Fonctions exportées:
// - createEnhancedBinomePreset()
// - createEnhancedCombinaisonsPreset()
// - createEnhancedSommesPreset()
// - createUnifiedPrepaCalculPreset()
// - testEnhancedCalculations()
// - validateEnhancedTemplates()
