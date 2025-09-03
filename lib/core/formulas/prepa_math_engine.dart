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
/// - Génération d'exemples et variants de formules
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
/// - Calculs: Validation automatique et exemples pédagogiques
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
/// - Nouvelle architecture unifiée avec approche "tout substituable"
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif mathématique)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

// Import pour les calculs mathématiques

/// =====================================================================================
/// 🔄 PRÉPROCESSEUR DE FORMULES LATEX
/// =====================================================================================

/// Préprocesseur pour convertir les variables marquées en LaTeX standard
///
/// Utilise la syntaxe {VAR:nom} pour marquer les variables dans les templates,
/// puis les convertit en variables LaTeX standard pour l'affichage.
///
/// Exemple: {VAR:n} → n, {VAR:alpha} → alpha
class FormulaPreprocessor {
  /// Regex pour détecter les variables marquées {VAR:nom}
  static final RegExp _variableRegex =
      RegExp(r'\{VAR:([a-zA-Z][a-zA-Z0-9]*)\}');

  /// Convertit les variables marquées en LaTeX standard
  ///
  /// Exemples:
  /// - '{VAR:n}' → 'n'
  /// - '\\binom{{VAR:n}}{{VAR:k}}' → '\\binom{n}{k}'
  /// - '{VAR:alpha}^{VAR:beta}' → 'alpha^{beta}'
  static String processLatex(String rawLatex) {
    if (rawLatex.isEmpty) return rawLatex;

    return rawLatex.replaceAllMapped(_variableRegex, (match) {
      final variableName = match.group(1)!;
      return variableName;
    });
  }

  /// Extrait les noms de variables depuis le LaTeX marqué
  ///
  /// Retourne la liste unique des variables trouvées
  /// Exemple: '\\binom{{VAR:n}}{{VAR:k}}' → ['n', 'k']
  static List<String> extractVariableNames(String rawLatex) {
    if (rawLatex.isEmpty) return [];

    return _variableRegex
        .allMatches(rawLatex)
        .map((match) => match.group(1)!)
        .toSet() // Éliminer les doublons
        .toList();
  }

  /// Convertit une variable standard en variable marquée
  ///
  /// Utile pour les tests et la conversion inverse
  /// Exemple: 'n' → '{VAR:n}'
  static String markVariable(String variableName) {
    return '{VAR:$variableName}';
  }

  /// Vérifie si une chaîne contient des variables marquées
  static bool hasMarkedVariables(String text) {
    return _variableRegex.hasMatch(text);
  }

  /// Compte le nombre de variables marquées dans une chaîne
  static int countMarkedVariables(String text) {
    return _variableRegex.allMatches(text).length;
  }

  /// Remplace les variables marquées par des valeurs spécifiques
  ///
  /// Exemple: substitueVariables('{VAR:n}+{VAR:k}', {'n': '5', 'k': '2'}) → '5+2'
  static String substituteVariables(
      String rawLatex, Map<String, String> values) {
    return rawLatex.replaceAllMapped(_variableRegex, (match) {
      final variableName = match.group(1)!;
      return values[variableName] ??
          match.group(0)!; // Garder original si pas trouvé
    });
  }
}

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
/// 🎮 SYSTÈME DE CODES QUIZ PRÉPA
/// =====================================================================================

/// Mode de quiz pour organiser les variantes de formules
enum QuizMode {
  /// Mode 0: Formules originales sans modification
  normal(0, "Normal", "Formules originales sans modification"),
  
  /// Mode 1: Variables inversées (n↔k, a↔b)
  inversion(1, "Inversion", "Variables inversées (n↔k, a↔b)"),
  
  /// Mode 2: Original + inversé mélangés dans le même quiz
  mixte(2, "Mixte", "Original + inversé mélangés dans le même quiz"),
  
  /// Mode 3: Variables renommées (n→x, k→y)
  substitution(3, "Substitution", "Variables renommées (n→x, k→y)"),
  
  /// Mode 4: Difficulté progressive (simples → complexes)
  progressive(4, "Progressive", "Difficulté progressive (simples → complexes)");

  const QuizMode(this.code, this.nom, this.description);
  final int code;
  final String nom;
  final String description;
}

/// Configuration complète d'un quiz prépa
class QuizConfiguration {
  /// Mode du quiz (définit les variantes de formules)
  final QuizMode mode;
  
  /// Niveau de difficulté (1-5, filtre les formules)
  final int difficulty;
  
  /// Catégories à inclure ['binome', 'combinaisons', 'sommes']
  final List<String> categories;
  
  /// Afficher des exemples numériques
  final bool showExamples;
  
  /// Nombre de questions dans le quiz
  final int questionCount;
  
  /// Mélanger les formules originales et variantes
  final bool shuffleVariants;

  const QuizConfiguration({
    this.mode = QuizMode.mixte, // Par défaut: mode mixte (code 2)
    this.difficulty = 3,
    this.categories = const ['binome', 'combinaisons', 'sommes'],
    this.showExamples = true,
    this.questionCount = 6,
    this.shuffleVariants = true,
  });
  
  /// Crée une configuration avec des paramètres personnalisés
  QuizConfiguration copyWith({
    QuizMode? mode,
    int? difficulty,
    List<String>? categories,
    bool? showExamples,
    int? questionCount,
    bool? shuffleVariants,
  }) {
    return QuizConfiguration(
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
      showExamples: showExamples ?? this.showExamples,
      questionCount: questionCount ?? this.questionCount,
      shuffleVariants: shuffleVariants ?? this.shuffleVariants,
    );
  }
  
  @override
  String toString() {
    return 'QuizConfiguration(mode: ${mode.nom}, difficulty: $difficulty, '
           'categories: $categories, questions: $questionCount)';
  }
}

/// Générateur de quiz adaptatif selon la configuration
class QuizGenerator {
  /// Génère un quiz selon la configuration donnée
  static List<EnhancedFormulaTemplate> generateQuiz(QuizConfiguration config) {
    // 1. Récupérer les formules selon les catégories
    List<EnhancedFormulaTemplate> baseFormulas = [];
    
    for (final category in config.categories) {
      switch (category) {
        case 'binome':
          baseFormulas.addAll(PrepaMathFormulaManager.binomeFormulas);
          break;
        case 'combinaisons':
          baseFormulas.addAll(PrepaMathFormulaManager.combinaisonsFormulas);
          break;
        case 'sommes':
          baseFormulas.addAll(PrepaMathFormulaManager.sommesFormulas);
          break;
      }
    }
    
    // 2. Appliquer le mode de quiz
    List<EnhancedFormulaTemplate> quizFormulas = [];
    
    switch (config.mode) {
      case QuizMode.normal:
        quizFormulas = baseFormulas;
        break;
        
      case QuizMode.inversion:
        // Utiliser uniquement les versions inversées
        quizFormulas = baseFormulas
            .where((f) => f.numberOfVariables == 2)
            .map((f) => f.createWithSimpleInversion())
            .toList();
        break;
        
      case QuizMode.mixte:
        // Mélanger originales et inversées (50/50)
        final originals = baseFormulas.take(baseFormulas.length ~/ 2).toList();
        final inverted = baseFormulas
            .skip(baseFormulas.length ~/ 2)
            .where((f) => f.numberOfVariables == 2)
            .map((f) => f.createWithSimpleInversion())
            .toList();
        quizFormulas = [...originals, ...inverted];
        break;
        
      case QuizMode.substitution:
        // TODO: Implémenter substitution de variables
        quizFormulas = baseFormulas;
        break;
        
      case QuizMode.progressive:
        // TODO: Implémenter tri par difficulté
        quizFormulas = baseFormulas;
        break;
    }
    
    // 3. Mélanger si demandé
    if (config.shuffleVariants) {
      quizFormulas.shuffle();
    }
    
    // 4. Limiter au nombre de questions demandé
    return quizFormulas.take(config.questionCount).toList();
  }
  
  /// Génère un quiz avec la configuration par défaut (mode mixte)
  static List<EnhancedFormulaTemplate> generateDefaultQuiz() {
    return generateQuiz(const QuizConfiguration());
  }
  
  /// Génère un quiz avec un mode spécifique
  static List<EnhancedFormulaTemplate> generateQuizWithMode(QuizMode mode) {
    return generateQuiz(QuizConfiguration(mode: mode));
  }
}

/// =====================================================================================
/// 🎯 ARCHITECTURE DES FORMULES ÉTENDUES
/// =====================================================================================

/// Template de formule étendu avec calcul automatique et validation intelligente
///
/// 🔄 ARCHITECTURE À 3 NIVEAUX :
/// 1. latexOrigine   : LaTeX pur d'origine (ex: '\binom{n}{k} = \frac{n!}{k!(n-k)!}')
/// 2. latexVariable  : LaTeX avec variables marquées (ex: '\binom{{VAR:n}}{{VAR:k}} = \frac{{VAR:n}!}{{VAR:k}!({VAR:n}-{VAR:k})!}')
/// 3. latex          : LaTeX final pour affichage (avec substitutions éventuelles)
class EnhancedFormulaTemplate {
  /// 📝 NIVEAU ORIGINE : LaTeX d'origine (immutable)
  final String latexOrigine;
  final String? leftLatexOrigine;
  final String? rightLatexOrigine;

  /// 🔄 NIVEAU VARIABLE : LaTeX avec variables identifiées {VAR:} (donnée d'entrée)
  final String latexVariable;

  /// Description pédagogique de la formule
  final String description;

  /// Liste des paramètres de la formule avec leurs contraintes
  final List<FormulaParameter> parameters;

  const EnhancedFormulaTemplate({
    required this.latexOrigine,
    required this.description,
    required this.parameters,
    this.latexVariable = '', // TEMPORAIRE: optionnel pendant migration
    this.leftLatexOrigine,
    this.rightLatexOrigine,
  });

  /// 🎯 NIVEAU FINAL : LaTeX final généré avec getters par défaut
  String get finalLatexVariable => latexVariable.isEmpty
      ? _convertToVariableSyntax(latexOrigine)
      : latexVariable;

  /// 🔄 GETTERS AVEC SPLIT AUTOMATIQUE : calculés à partir de finalLatexVariable
  String get leftLatexVariable => _splitLeft(finalLatexVariable);
  String get rightLatexVariable => _splitRight(finalLatexVariable);
  String get finalLeftLatexVariable => leftLatexVariable;
  String get finalRightLatexVariable => rightLatexVariable;

  /// 🎯 NIVEAU FINAL : LaTeX final généré (par défaut = origine, modifiable par transformations)
  String get latex => _applySubstitutions(finalLatexVariable);
  String get leftLatex => _applySubstitutions(finalLeftLatexVariable);
  String get rightLatex => _applySubstitutions(finalRightLatexVariable);

  /// 📊 MÉTADONNÉES : Nombre de variables dans la formule
  int get numberOfVariables =>
      FormulaPreprocessor.extractVariableNames(finalLatexVariable).length;

  /// Nombre de paramètres de la formule
  int get parameterCount => parameters.length;

  /// Liste des noms des variables/paramètres
  List<String> get variableNames => parameters.map((p) => p.name).toList();

  /// Liste des variables qui peuvent être inversées
  List<String> get invertibleVariables =>
      parameters.where((p) => p.canInvert).map((p) => p.name).toList();

  /// Obtient la partie gauche de la formule (avant le =)
  String get leftSide {
    return leftLatex;
  }

  /// Obtient la partie droite de la formule (après le =)
  String get rightSide {
    return rightLatex;
  }

  /// Obtient la partie gauche avec variables {VAR:} visibles
  String get leftSideWithVariables {
    // Si leftLatex est défini, d'abord générer la version avec {VAR:}
    final withVars = _generateLatexVariableFromOriginal(leftLatex);
    return withVars;
  }

  /// Obtient la partie droite avec variables {VAR:} visibles
  String get rightSideWithVariables {
    // Si rightLatex est défini, d'abord générer la version avec {VAR:}
    final withVars = _generateLatexVariableFromOriginal(rightLatex);
    return withVars;
  }

  /// Génère la version avec variables {VAR:} à partir d'une formule originale
  static String _generateLatexVariableFromOriginal(String origine) {
    String result = origine;

    // 1. Capturer les variables avec underscore (ex: C_n, a_i)
    result = result.replaceAllMapped(RegExp(r'([a-zA-Z])_([a-zA-Z0-9]+)'),
        (match) => '{VAR:${match.group(1)}_${match.group(2)}}');

    // 2. Capturer les variables simples dans les contextes LaTeX courants
    // Variables dans \binom{n}{k}
    result = result.replaceAllMapped(
        RegExp(r'\\binom\{([a-zA-Z])\}\{([a-zA-Z])\}'),
        (match) =>
            r'\binom{{VAR:' +
            match.group(1)! +
            r'}}{{VAR:' +
            match.group(2)! +
            r'}}');

    // Variables dans \frac{n!}{k!...}
    result = result.replaceAllMapped(
        RegExp(r'([a-zA-Z])!'), (match) => '{VAR:${match.group(1)}}!');

    // Variables isolées dans certains contextes (entourées d'espaces, parenthèses, opérateurs)
    result = result.replaceAllMapped(
        RegExp(r'(?<=[\s\(\)\+\-\*=]|^)([a-zA-Z])(?=[\s\(\)\+\-\*=!]|$)'),
        (match) => '{VAR:${match.group(1)}}');

    return result;
  }

  /// Obtient les variables extraites de la formule
  List<String> get extractedVariables =>
      FormulaPreprocessor.extractVariableNames(finalLatexVariable);

  /// Substitue les variables marquées dans la formule
  String substituteMarkedVariables(Map<String, String> values) {
    return FormulaPreprocessor.substituteVariables(finalLatexVariable, values);
  }

  /// Génère une version avec inversion de variables
  /// Exemple: inverser n et k dans \binom{{VAR:n}}{{VAR:k}}
  String generateWithInversion(String var1, String var2) {
    return finalLatexVariable
        .replaceAll('{VAR:$var1}', '{TEMP:$var2}')
        .replaceAll('{VAR:$var2}', '{VAR:$var1}')
        .replaceAll('{TEMP:$var2}', '{VAR:$var2}');
  }

  /// Génère une version avec substitutions de variables
  /// Exemple: remplacer n par x, k par y
  String generateWithSubstitutions(Map<String, String> substitutions) {
    String result = finalLatexVariable;
    for (final entry in substitutions.entries) {
      result = result.replaceAll('{VAR:${entry.key}}', '{VAR:${entry.value}}');
    }
    return result;
  }

  /// Génère le latex final à partir d'une version avec variables
  String convertVariablesToLatex(String variableVersion) {
    return FormulaPreprocessor.processLatex(variableVersion);
  }

  /// 🔄 FONCTION D'INVERSION SIMPLE : Inverse 2 variables si numberOfVariables == 2
  EnhancedFormulaTemplate createWithSimpleInversion() {
    if (numberOfVariables != 2) {
      throw ArgumentError(
          'Inversion simple possible uniquement avec 2 variables (actuel: $numberOfVariables)');
    }

    final variables =
        FormulaPreprocessor.extractVariableNames(finalLatexVariable);
    final var1 = variables[0];
    final var2 = variables[1];

    // Inverser les variables dans latexVariable
    final invertedLatexVariable = finalLatexVariable
        .replaceAll('{VAR:$var1}', '{TEMP:$var2}')
        .replaceAll('{VAR:$var2}', '{VAR:$var1}')
        .replaceAll('{TEMP:$var2}', '{VAR:$var2}');

    final invertedLeftLatexVariable = leftLatexVariable
        .replaceAll('{VAR:$var1}', '{TEMP:$var2}')
        .replaceAll('{VAR:$var2}', '{VAR:$var1}')
        .replaceAll('{TEMP:$var2}', '{VAR:$var2}');

    final invertedRightLatexVariable = rightLatexVariable
        .replaceAll('{VAR:$var1}', '{TEMP:$var2}')
        .replaceAll('{VAR:$var2}', '{VAR:$var1}')
        .replaceAll('{TEMP:$var2}', '{VAR:$var2}');

    // Créer une nouvelle instance avec inversion
    return _EnhancedFormulaTemplateWithInversion(
      original: this,
      invertedLatexVariable: invertedLatexVariable,
      invertedLeftLatexVariable: invertedLeftLatexVariable,
      invertedRightLatexVariable: invertedRightLatexVariable,
    );
  }

  /// 🔧 MÉTHODES INTERNES DE CONVERSION

  /// Convertit un LaTeX d'origine vers la syntaxe avec variables marquées
  ///
  /// Détecte automatiquement les variables (lettres isolées) et les convertit en {VAR:nom}
  /// Exemples:
  /// - '\binom{n}{k}' → '\binom{{VAR:n}}{{VAR:k}}'
  /// - '(a+b)^{n}' → '({VAR:a}+{VAR:b})^{{VAR:n}}'
  String _convertToVariableSyntax(String originalLatex) {
    // Utiliser la logique améliorée pour détecter toutes les variables
    return _generateLatexVariableFromOriginal(originalLatex);
  }

  /// Applique les substitutions finales pour l'affichage
  ///
  /// Pour l'instant, convertit simplement {VAR:nom} → nom
  /// Plus tard pourra appliquer des substitutions numériques
  String _applySubstitutions(String variableLatex) {
    // Pour l'instant, on utilise le préprocesseur pour convertir vers l'affichage
    return FormulaPreprocessor.processLatex(variableLatex);
  }

  /// Split gauche de la formule variable
  String _splitLeft(String formula) {
    final parts = formula.split(' = ');
    if (parts.length >= 2) {
      return parts[0].trim();
    }
    final simpleParts = formula.split('=');
    return simpleParts.isNotEmpty ? simpleParts[0].trim() : formula;
  }

  /// Split droite de la formule variable
  String _splitRight(String formula) {
    final parts = formula.split(' = ');
    if (parts.length >= 2) {
      return parts.sublist(1).join(' = ').trim();
    }
    final simpleParts = formula.split('=');
    return simpleParts.length > 1
        ? simpleParts.sublist(1).join('=').trim()
        : '';
  }

  /// =====================================================================================
  /// 🔄 SUBSTITUTION DE VARIABLES - APPROCHE "TOUT SUBSTITUABLE"
  /// =====================================================================================

  /// Substitue les variables marquées dans l'expression LaTeX
  ///
  /// Avec l'approche "tout substituable", seules les variables marquées avec '_'
  /// sont substituées. Les autres variables restent inchangées.
  ///
  /// Exemple: r'(_a+_b)^n' avec {'_a': '2', '_b': '3', 'n': '2'}
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

  /// Calcule un coefficient binomial C(n,k) = n! / (k! * (n-k)!)
  num? _calculateCombinaison(Map<String, num> values) {
    final n = values['n']?.toInt();
    final k = values['k']?.toInt();
    if (n == null || k == null || k > n || k < 0) return null;

    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  /// Calcule un développement binomial (_a+_b)^n = Σ C(n,k) * _a^(n-k) * _b^k
  num? _calculateBinome(Map<String, num> values) {
    final a = values['_a'];
    final b = values['_b'];
    final n = values['n']?.toInt();
    if (a == null || b == null || n == null || n < 0) return null;

    num result = 0;
    for (int k = 0; k <= n; k++) {
      final coeff = _calculateCombinaison({'n': n, 'k': k});
      if (coeff == null) return null;
      result += coeff * math.pow(a, n - k) * math.pow(b, k);
    }
    return result;
  }

  /// Calcule une somme Σ (actuellement supporte Σ(k=1 to n) k = n(n+1)/2)
  num? _calculateSomme(Map<String, num> values) {
    final n = values['n']?.toInt();
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

  /// Génère des variantes de la formule (original uniquement)
  List<FormulaVariant> generateSmartVariants() {
    return [FormulaVariant(latex: latex, description: description)];
  }

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

/// Classe spécialisée pour formules avec inversion
class _EnhancedFormulaTemplateWithInversion extends EnhancedFormulaTemplate {
  final EnhancedFormulaTemplate original;
  final String invertedLatexVariable;
  final String invertedLeftLatexVariable;
  final String invertedRightLatexVariable;

  const _EnhancedFormulaTemplateWithInversion({
    required this.original,
    required this.invertedLatexVariable,
    required this.invertedLeftLatexVariable,
    required this.invertedRightLatexVariable,
  }) : super(
          latexOrigine: '',
          description: '',
          parameters: const [],
        );

  @override
  String get latexOrigine => original.latexOrigine;

  @override
  String get description => '${original.description} (inversé)';

  @override
  List<FormulaParameter> get parameters => original.parameters;

  @override
  String get latexVariable => invertedLatexVariable;

  @override
  String get leftLatexVariable => invertedLeftLatexVariable;

  @override
  String get rightLatexVariable => invertedRightLatexVariable;

  @override
  String get latex => FormulaPreprocessor.processLatex(invertedLatexVariable);

  @override
  String get leftLatex =>
      FormulaPreprocessor.processLatex(invertedLeftLatexVariable);

  @override
  String get rightLatex =>
      FormulaPreprocessor.processLatex(invertedRightLatexVariable);
}

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
    latexOrigine: r'(a+b)^{n} = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    latexVariable:
        r'({VAR:a}+{VAR:b})^{{VAR:n}} = \sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} {VAR:a}^{{VAR:n}-{VAR:k}} {VAR:b}^{{VAR:k}}',
    leftLatexOrigine: r'(a+b)^{n}',
    rightLatexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    description: 'développement général du binôme de Newton',
    parameters: const [
      FormulaParameter(
        name: 'a',
        description: 'première variable (interchangeable avec _b)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'b',
        description: 'seconde variable (interchangeable avec _a)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5, // Limite pour éviter calculs trop lourds
      ),
    ],
  ),

  // Coefficient binomial de base
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \frac{n!}{k!(n-k)!}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \frac{{VAR:n}!}{{VAR:k}!({VAR:n}-{VAR:k})!}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\frac{n!}{k!(n-k)!}',
    description: 'coefficient binomial de base',
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

  // Développement binomial spécial
  EnhancedFormulaTemplate(
    latexOrigine: r'(1+a)^{n} = \sum_{k=0}^{n} \binom{n}{k} a^{k}',
    latexVariable:
        r'(1+{VAR:a})^{{VAR:n}} = \sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} {VAR:a}^{{VAR:k}}',
    leftLatexOrigine: r'(1+a)^{n}',
    rightLatexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} a^{k}',
    description: 'développement binomial spécial',
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
    ],
  ),

  // Alternance des coefficients binomiaux
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    leftLatexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k}',
    rightLatexOrigine: r'0',
    description: 'somme alternée des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'exposant (doit être ≥ 1)',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  // Somme oblique de Hockey-stick
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=r}^{n} \binom{k}{r} = \binom{n+1}{r+1}',
    latexVariable:
        r'\sum_{{VAR:k}={VAR:r}}^{{VAR:n}} \binom{{VAR:k}}{{VAR:r}} = \binom{{VAR:n}+1}{{VAR:r}+1}',
    leftLatexOrigine: r'\sum_{k=r}^{n} \binom{k}{r}',
    rightLatexOrigine: r'\binom{n+1}{r+1}',
    description: 'identité de hockey-stick',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'r',
        description: 'indice fixe (≤ n)',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  // Cas particuliers des coefficients binomiaux
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{0} = 1',
    latexVariable: r'\binom{{VAR:n}}{0} = 1',
    leftLatexOrigine: r'\binom{n}{0}',
    rightLatexOrigine: r'1',
    description: 'coefficient binomial pour k=0',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{n} = 1',
    latexVariable: r'\binom{{VAR:n}}{{VAR:n}} = 1',
    leftLatexOrigine: r'\binom{n}{n}',
    rightLatexOrigine: r'1',
    description: 'coefficient binomial pour k=n',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  // Relation de Pascal
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}-1}{{VAR:k}} + \binom{{VAR:n}-1}{{VAR:k}-1}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\binom{n-1}{k} + \binom{n-1}{k-1}',
    description: 'relation de récurrence de Pascal',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'indice de ligne',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice de colonne',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Formule du binôme pour (1+1)^n
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} = 2^{n}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} = 2^{{VAR:n}}',
    leftLatexOrigine: r'\sum_{k=0}^{n} \binom{n}{k}',
    rightLatexOrigine: r'2^{n}',
    description: 'formule du binôme pour (1+1)^n',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  // Symétrie des coefficients binomiaux
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \binom{n}{n-k}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}}{{VAR:n}-{VAR:k}}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\binom{n}{n-k}',
    description: 'propriété de symétrie des coefficients binomiaux',
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
];

/// =====================================================================================
/// 🔢 TEMPLATES DE FORMULES PRÉPA - COMBINAISONS
/// =====================================================================================

/// Templates étendus pour les formules de Combinaisons
final List<EnhancedFormulaTemplate> enhancedCombinaisonsTemplates = [
  // Définition de base
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \frac{n!}{k!\,(n-k)!}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \frac{{VAR:n}!}{{VAR:k}!\,({VAR:n}-{VAR:k})!}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\frac{n!}{k!\,(n-k)!}',
    description: 'définition du coefficient binomial',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'nombre d\'éléments choisis',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Propriété symétrique
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \binom{n}{n-k}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}}{{VAR:n}-{VAR:k}}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\binom{n}{n-k}',
    description: 'symétrie des coefficients binomiaux',
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

  // Triangle de Pascal
  EnhancedFormulaTemplate(
    latexOrigine: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
    latexVariable:
        r'\binom{{VAR:n}}{{VAR:k}} = \binom{{VAR:n}-1}{{VAR:k}} + \binom{{VAR:n}-1}{{VAR:k}-1}',
    leftLatexOrigine: r'\binom{n}{k}',
    rightLatexOrigine: r'\binom{n-1}{k} + \binom{n-1}{k-1}',
    description: 'relation de récurrence du triangle de Pascal',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'ligne du triangle',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
      FormulaParameter(
        name: 'k',
        description: 'position dans la ligne',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 12,
      ),
    ],
  ),

  // Développement binomial général
  EnhancedFormulaTemplate(
    latexOrigine: r'(a+b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    latexVariable:
        r'({VAR:a}+{VAR:b})^{VAR:n} = \sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} {VAR:a}^{{VAR:n}-{VAR:k}} {VAR:b}^{{VAR:k}}',
    leftLatexOrigine: r'(a+b)^n',
    rightLatexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
    description: 'développement binomial général',
    parameters: const [
      FormulaParameter(
        name: 'a',
        description: 'première variable',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'b',
        description: 'seconde variable',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'exposant',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),

  // Nombre total de sous-ensembles
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{n} \binom{n}{k} = 2^{n}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:n}}{{VAR:k}} = 2^{{VAR:n}}',
    leftLatexOrigine: r'\sum_{k=0}^{n} \binom{n}{k}',
    rightLatexOrigine: r'2^{n}',
    description: 'nombre total de sous-ensembles d\'un ensemble à n éléments',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'taille de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),

  // Relation d'orthogonalité
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} (-1)^{VAR:k} \binom{{VAR:n}}{{VAR:k}} = 0',
    leftLatexOrigine: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k}',
    rightLatexOrigine: r'0',
    description: 'somme alternée des coefficients binomiaux',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'degré (doit être ≥ 1)',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
    ],
  ),

  // Identité de Chu-Vandermonde
  EnhancedFormulaTemplate(
    latexOrigine:
        r'\sum_{k=0}^{n} \binom{m}{k} \binom{n-m}{n-k} = \binom{n}{m}',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{{VAR:n}} \binom{{VAR:m}}{{VAR:k}} \binom{{VAR:n}-{VAR:m}}{{VAR:n}-{VAR:k}} = \binom{{VAR:n}}{{VAR:m}}',
    leftLatexOrigine: r'\sum_{k=0}^{n} \binom{m}{k} \binom{n-m}{n-k}',
    rightLatexOrigine: r'\binom{n}{m}',
    description: 'identité de Chu-Vandermonde (pour m fixe)',
    parameters: const [
      FormulaParameter(
        name: 'n',
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
    latexOrigine: r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k} = \frac{{VAR:n}({VAR:n}+1)}{2}',
    leftLatexOrigine: r'\sum_{k=1}^{n} k',
    rightLatexOrigine: r'\frac{n(n+1)}{2}',
    description: 'somme des n premiers entiers naturels',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 25,
      ),
    ],
  ),

  // Somme des carrés
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}^2 = \frac{{VAR:n}({VAR:n}+1)(2n+1)}{6}',
    leftLatexOrigine: r'\sum_{k=1}^{n} k^2',
    rightLatexOrigine: r'\frac{n(n+1)(2n+1)}{6}',
    description: 'somme des carrés des n premiers entiers',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),

  // Somme des cubes
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=1}^{n} k^3 = \left(\frac{n(n+1)}{2}\right)^2',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} {VAR:k}^3 = \left(\frac{{VAR:n}({VAR:n}+1)}{2}\right)^2',
    leftLatexOrigine: r'\sum_{k=1}^{n} k^3',
    rightLatexOrigine: r'\left(\frac{n(n+1)}{2}\right)^2',
    description: 'somme des cubes des n premiers entiers',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
    ],
  ),

  // Série géométrique finie
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{n} q^k = \frac{1-q^{n+1}}{1-q} ',
    leftLatexOrigine: r'\sum_{k=0}^{n} q^k',
    rightLatexOrigine: r'\frac{1-q^{n+1}}{1-q}',
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
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 15,
      ),
    ],
  ),

  // Série arithmético-géométrique
  EnhancedFormulaTemplate(
    latexOrigine:
        r'\sum_{k=1}^{n} k \cdot q^k = \frac{q(1-(n+1)q^n + nq^{n+1})}{(1-q)^2}',
    leftLatexOrigine: r'\sum_{k=1}^{n} k \cdot q^k',
    rightLatexOrigine: r'\frac{q(1-(n+1)q^n + nq^{n+1})}{(1-q)^2}',
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
        name: 'n',
        description: 'borne supérieure',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 12,
      ),
    ],
  ),

  // Série géométrique infinie
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=0}^{\infty} q^k = \frac{1}{1-q} ',
    latexVariable:
        r'\sum_{{VAR:k}=0}^{\infty} {VAR:q}^{VAR:k} = \frac{1}{1-{VAR:q}} )',
    leftLatexOrigine: r'\sum_{k=0}^{\infty} q^k',
    rightLatexOrigine: r'\frac{1}{1-q}',
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
    latexOrigine: r'\sum_{k=1}^{\infty} k \cdot q^{k-1} = \frac{1}{(1-q)^2} ',
    leftLatexOrigine: r'\sum_{k=1}^{\infty} k \cdot q^{k-1}',
    rightLatexOrigine: r'\frac{1}{(1-q)^2}',
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
    latexOrigine: r'\sum_{k=0}^{n} 1 = n+1',
    latexVariable: r'\sum_{{VAR:k}=0}^{{VAR:n}} 1 = {VAR:n}+1',
    leftLatexOrigine: r'\sum_{k=0}^{n} 1',
    rightLatexOrigine: r'n+1',
    description: 'comptage des éléments d\'un ensemble fini',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre d\'éléments',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 20,
      ),
    ],
  ),

  // Somme des impairs
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=1}^{n} (2k-1) = n^2',
    latexVariable: r'\sum_{{VAR:k}=1}^{{VAR:n}} (2k-1) = {VAR:n}^2',
    leftLatexOrigine: r'\sum_{k=1}^{n} (2k-1)',
    rightLatexOrigine: r'n^2',
    description: 'somme des n premiers nombres impairs',
    parameters: const [
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
    ],
  ),

  // Somme télescopique
  EnhancedFormulaTemplate(
    latexOrigine: r'\sum_{k=1}^{n} \frac{1}{k(k+1)} = 1 - \frac{1}{n+1}',
    latexVariable:
        r'\sum_{{VAR:k}=1}^{{VAR:n}} \frac{1}{{VAR:k}({VAR:k}+1)} = 1 - \frac{1}{{VAR:n}+1}',
    leftLatexOrigine: r'\sum_{k=1}^{n} \frac{1}{k(k+1)}',
    rightLatexOrigine: r'1 - \frac{1}{n+1}',
    description: 'somme télescopique des fractions unitaires',
    parameters: const [
      FormulaParameter(
        name: 'n',
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

/// Teste le préprocesseur de formules
void testFormulaPreprocessor() {
  print('🧪 TEST DU PRÉPROCESSEUR DE FORMULES');
  print('=' * 60);

  // Test basique de conversion
  final testCases = [
    '{VAR:n}',
    '\\binom{{VAR:n}}{{VAR:k}}',
    '({VAR:a}+{VAR:b})^{VAR:n}',
    '\\sum_{{k=0}}^{{VAR:n}} \\binom{{VAR:n}}{{k}} {VAR:x}^{{k}}',
  ];

  for (final testCase in testCases) {
    final processed = FormulaPreprocessor.processLatex(testCase);
    final variables = FormulaPreprocessor.extractVariableNames(testCase);
    print('📝 Entrée:  $testCase');
    print('✅ Sortie:  $processed');
    print('🔤 Variables: $variables');
    print('');
  }

  // Test des templates modifiés
  print('🔬 TEST DES TEMPLATES MODIFIÉS:');
  final testTemplate = enhancedBinomeTemplates[0];
  print('Template brut: ${testTemplate.latexOrigine}');
  print('Template traité: ${testTemplate.latex}');
  print('Variables extraites: ${testTemplate.extractedVariables}');
  print('Partie gauche: ${testTemplate.leftSide}');
  print('Partie droite: ${testTemplate.rightSide}');

  print('\n✅ TESTS DU PRÉPROCESSEUR TERMINÉS !');
}

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
/// Gestionnaire unifié des formules mathématiques (legacy pour compatibilité)
class UnifiedMathFormulaManager {
  static List<EnhancedFormulaTemplate> _prepaUnifiedFormulas = [];

  /// Initialiser avec les formules de la nouvelle architecture
  static void initialize() {
    if (_prepaUnifiedFormulas.isEmpty) {
      // Utiliser PrepaMathFormulaManager
      _prepaUnifiedFormulas = [
        ...PrepaMathFormulaManager.binomeFormulas,
        ...PrepaMathFormulaManager.combinaisonsFormulas,
        ...PrepaMathFormulaManager.sommesFormulas,
      ];

      print('🎯 UnifiedMathFormulaManager (NOUVELLE ARCHITECTURE):');
      print('   • Binôme: ${PrepaMathFormulaManager.binomeFormulas.length}');
      print('   • Combinaisons: ${PrepaMathFormulaManager.combinaisonsFormulas.length}');
      print('   • Sommes: ${PrepaMathFormulaManager.sommesFormulas.length}');
      print('   • Prépa unifié: ${_prepaUnifiedFormulas.length} formules');
    }
  }

  /// Obtenir les formules unifiées de prépa (concaténation des 3 catégories)
  static List<EnhancedFormulaTemplate> get prepaUnifiedFormulas =>
      _prepaUnifiedFormulas;

  /// Obtenir les formules binôme
  static List<EnhancedFormulaTemplate> get binomeFormulas =>
      PrepaMathFormulaManager.binomeFormulas;

  /// Obtenir les formules de combinaisons
  static List<EnhancedFormulaTemplate> get combinaisonsFormulas =>
      PrepaMathFormulaManager.combinaisonsFormulas;

  /// Obtenir les formules de sommes
  static List<EnhancedFormulaTemplate> get sommesFormulas =>
      PrepaMathFormulaManager.sommesFormulas;
}

/// Manager principal des formules mathématiques de prépa.
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
  /// Utilise le système de codes quiz avec mode mixte par défaut (code 2)
  static QuestionnairePreset createUnifiedPrepaCalculPreset({QuizConfiguration? config}) {
    // Utiliser la configuration par défaut (mode mixte) si non spécifiée
    final quizConfig = config ?? const QuizConfiguration();
    
    // Générer le quiz selon la configuration
    final formulas = QuizGenerator.generateQuiz(quizConfig);
    
    print('🎮 Quiz généré avec mode: ${quizConfig.mode.nom} (code ${quizConfig.mode.code})');
    print('   • Formules sélectionnées: ${formulas.length}');
    print('   • Catégories: ${quizConfig.categories}');

    // Créer les listes pour le questionnaire
    final leftFormulas = formulas.map((f) => f.leftSide).toList();
    final rightFormulas = formulas.map((f) => f.rightSide).toList();

    return QuestionnairePreset(
      id: 'prepa_calcul_unified',
      nom: 'Calcul Prépa',
      titre: 'CALCUL PRÉPA - ${quizConfig.mode.nom.toUpperCase()}',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: '${quizConfig.mode.description} - ${formulas.length} formules',
      colonneGauche: leftFormulas,
      colonneDroite: rightFormulas,
      description:
          'Quiz ${quizConfig.mode.nom} combinant les formules de binôme, sommes et combinaisons. '
          '${formulas.length} formules avec ${quizConfig.mode.description}.',
    );
  }
  
  /// Crée un quiz avec un mode spécifique
  static QuestionnairePreset createQuizWithMode(QuizMode mode) {
    final config = QuizConfiguration(mode: mode);
    return createUnifiedPrepaCalculPreset(config: config);
  }
  
  /// Crée un quiz normal (mode 0)
  static QuestionnairePreset createNormalQuiz() {
    return createQuizWithMode(QuizMode.normal);
  }
  
  /// Crée un quiz avec inversions (mode 1)
  static QuestionnairePreset createInversionQuiz() {
    return createQuizWithMode(QuizMode.inversion);
  }
  
  /// Crée un quiz mixte (mode 2) - par défaut
  static QuestionnairePreset createMixteQuiz() {
    return createQuizWithMode(QuizMode.mixte);
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
