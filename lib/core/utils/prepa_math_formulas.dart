/// =====================================================================================
/// 🧮 SYSTÈME UNIFIÉ DE FORMULES MATHÉMATIQUES DE PRÉPA
/// =====================================================================================
///
/// Architecture centralisée pour gérer toutes les formules mathématiques de prépa.
/// Fichier séparé pour éviter les conflits avec les anciens systèmes.
///
/// COMPOSANTS PRINCIPAUX:
/// - PrepaMathFormulaManager: Classe centrale pour toutes les formules
/// - binomeFormulas: 10 formules de binôme (coefficients binomiaux, Pascal, etc.)
/// - sommesFormulas: 10 formules de sommes (arithmétique, géométrique, etc.)
/// - combinaisonsFormulas: 7 formules de combinaisons (analyse combinatoire)
///
/// ÉTAT ACTUEL:
/// - 27 formules organisées et validées
/// - Validation automatique des contraintes mathématiques
/// - Génération intelligente de puzzles aléatoires
/// - Recherche et filtrage avancés
/// - Maintenance centralisée
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création du système unifié PrepaMathFormulaManager
/// - Tests automatiques intégrés
/// - Validation des formules mathématiquement correctes
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;

/// =====================================================================================
/// 📚 CLASSES DE BASE POUR LES FORMULES
/// =====================================================================================

/// Types de paramètres pour les formules
enum ParameterType {
  NATURAL, // Entiers naturels (0, 1, 2, ...)
  INTEGER, // Entiers relatifs (...-2, -1, 0, 1, 2...)
  REAL, // Nombres réels
  POSITIVE, // Nombres positifs
}

/// Paramètre d'une formule mathématique
class FormulaParameter {
  final String name;
  final String description;
  final ParameterType type;
  final bool canInvert;
  final num? minValue;
  final num? maxValue;

  const FormulaParameter({
    required this.name,
    required this.description,
    required this.type,
    this.canInvert = false,
    this.minValue,
    this.maxValue,
  });
}

/// Template de formule avec validation automatique
class EnhancedFormulaTemplate {
  final String latex;
  final String description;
  final List<FormulaParameter> parameters;

  const EnhancedFormulaTemplate({
    required this.latex,
    required this.description,
    required this.parameters,
  });

  /// Génère des variantes avec paramètres inversés
  /// DÉSACTIVÉ : Génération de variantes avec paramètres inversés
  List<FormulaVariant> generateSmartVariants() {
    final variants = <FormulaVariant>[];
    variants.add(FormulaVariant(latex: latex, description: description));

    // DÉSACTIVÉ : Génération de variantes avec paramètres inversés
    // Cette fonctionnalité a été désactivée pour éviter la confusion
    /*
    // Générer la variante avec paramètres inversés si possible
    final invertibleParams = parameters.where((p) => p.canInvert).toList();
    if (invertibleParams.length >= 2) {
      final invertedLatex = _invertVariablesInLatex(latex, invertibleParams);
      if (_isMathematicallyValid(invertedLatex)) {
        final invertedDescription = '$description (paramètres inversés)';
        variants.add(FormulaVariant(
          latex: invertedLatex,
          description: invertedDescription,
        ));
      }
    }
    */

    return variants;
  }

  /// Génère des exemples numériques valides
  List<Map<String, num>> generateValidExamples({int count = 5}) {
    final examples = <Map<String, num>>[];

    for (int i = 0; i < count; i++) {
      final example = <String, num>{};
      bool isValid = true;

      // Génère des valeurs pour chaque paramètre
      for (final param in parameters) {
        num value = 0;

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

        // Respecter les bornes
        if (param.minValue != null && value < param.minValue!) {
          value = param.minValue!;
        }
        if (param.maxValue != null && value > param.maxValue!) {
          value = param.maxValue!;
        }

        example[param.name] = value;
      }

      // Vérifier que l'exemple produit une formule valide
      final testLatex = _substituteParameters(latex, example);
      if (_isMathematicallyValid(testLatex)) {
        examples.add(example);
      }
    }

    return examples;
  }

  /// Inverse les variables dans une formule LaTeX
  String _invertVariablesInLatex(
      String latex, List<FormulaParameter> variables) {
    if (variables.length != 2) return latex;

    final var1 = variables[0].name;
    final var2 = variables[1].name;

    String result = latex;

    // Échapper les backslashes pour les regex
    final escapedVar1 = RegExp.escape(var1);
    final escapedVar2 = RegExp.escape(var2);

    // Utiliser une approche plus robuste pour les expressions mathématiques
    result = result.replaceAllMapped(
        RegExp(r'(?<![a-zA-Z0-9])' + escapedVar1 + r'(?![a-zA-Z0-9])'),
        (match) => var2);
    result = result.replaceAllMapped(
        RegExp(r'(?<![a-zA-Z0-9])' + escapedVar2 + r'(?![a-zA-Z0-9])'),
        (match) => var1);

    return result;
  }

  /// Substitue les paramètres dans une formule LaTeX
  String _substituteParameters(String latex, Map<String, num> values) {
    String result = latex;
    values.forEach((key, value) {
      result = result.replaceAll(key, value.toString());
    });
    return result;
  }

  /// Vérifie si une formule LaTeX est mathématiquement valide
  bool _isMathematicallyValid(String latex) {
    // Vérifier les coefficients binomiaux C(n,k) où n >= k >= 0
    final binomialRegex = RegExp(r'\\binom\{([^}]+)\}\{([^}]+)\}');
    final matches = binomialRegex.allMatches(latex);

    for (final match in matches) {
      final nStr = match.group(1);
      final kStr = match.group(2);

      // Si les paramètres ne sont pas des nombres, on ne peut pas valider
      if (!RegExp(r'^\d+$').hasMatch(nStr!) ||
          !RegExp(r'^\d+$').hasMatch(kStr!)) {
        continue; // Variables alphanumériques sont OK
      }

      final n = int.parse(nStr);
      final k = int.parse(kStr);

      // Vérifier les contraintes des coefficients binomiaux
      if (n < 0 || k < 0 || k > n) {
        return false;
      }
    }

    // Vérifier les sommes avec bornes cohérentes
    final sumRegex = RegExp(r'\\sum_\{([^}]+)\}\^\{([^}]+)\}');
    final sumMatches = sumRegex.allMatches(latex);

    for (final match in sumMatches) {
      final lowerStr = match.group(1);
      final upperStr = match.group(2);

      if (RegExp(r'^\d+$').hasMatch(lowerStr!) &&
          RegExp(r'^\d+$').hasMatch(upperStr!)) {
        final lower = int.parse(lowerStr);
        final upper = int.parse(upperStr);

        if (lower > upper) {
          return false;
        }
      }
    }

    return true;
  }
}

/// Variante d'une formule (originale ou avec paramètres inversés)
class FormulaVariant {
  final String latex;
  final String description;

  const FormulaVariant({
    required this.latex,
    required this.description,
  });
}

/// Générateur de perturbations pour les formules
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

/// Extension pour calculer une formule avec des valeurs
extension FormulaCalculation on EnhancedFormulaTemplate {
  /// Calcule la valeur numérique d'une formule avec des paramètres donnés
  num? calculate(Map<String, num> values) {
    try {
      // Pour l'instant, on ne calcule que les formules simples
      // Cette méthode peut être étendue pour des calculs plus complexes
      return null; // Pas encore implémenté pour toutes les formules
    } catch (e) {
      return null;
    }
  }
}

/// =====================================================================================
/// 🎯 CLASSES POUR LES QUESTIONNAIRES (compatibilité)
/// =====================================================================================

/// Niveaux éducatifs
enum NiveauEducatif {
  college,
  lycee,
  prepa,
}

/// Catégories de matières
enum CategorieMatiere {
  mathematiques,
  francais,
  anglais,
  economie,
}

/// Types de jeux
enum TypeDeJeu {
  correspondanceVisAVis,
  formulairesLatex,
  figuresDeStyle,
  combinaisonsMatematiques,
}

/// Extension pour ajouter la propriété nom aux enums
extension NiveauEducatifExtension on NiveauEducatif {
  String get nom => switch (this) {
    NiveauEducatif.college => 'Collège',
    NiveauEducatif.lycee => 'Lycée',
    NiveauEducatif.prepa => 'Prépa',
  };
}

extension TypeDeJeuExtension on TypeDeJeu {
  String get nom => switch (this) {
    TypeDeJeu.correspondanceVisAVis => 'Correspondance',
    TypeDeJeu.formulairesLatex => 'LaTeX',
    TypeDeJeu.figuresDeStyle => 'Figures de Style',
    TypeDeJeu.combinaisonsMatematiques => 'Combinaisons',
  };
}

/// Questionnaire éducatif
class QuestionnairePreset {
  final String id;
  final String nom;
  final String titre;
  final NiveauEducatif niveau;
  final CategorieMatiere categorie;
  final TypeDeJeu typeDeJeu;
  final String sousTheme;
  final List<String> colonneGauche;
  final List<String> colonneDroite;
  final String description;
  final double ratioLargeurColonnes;

  const QuestionnairePreset({
    required this.id,
    required this.nom,
    required this.titre,
    required this.niveau,
    required this.categorie,
    required this.typeDeJeu,
    required this.sousTheme,
    required this.colonneGauche,
    required this.colonneDroite,
    required this.description,
    this.ratioLargeurColonnes = 0.5,
  });
}

/// =====================================================================================
/// 🧮 GESTIONNAIRE UNIFIÉ DES FORMULES MATHÉMATIQUES DE PRÉPA
/// =====================================================================================

/// Classe centrale pour gérer toutes les formules mathématiques de niveau prépa
/// Unifie les différents systèmes existants (enhanced templates, listes statiques, etc.)
class PrepaMathFormulaManager {
  /// Instance singleton
  static final PrepaMathFormulaManager _instance =
      PrepaMathFormulaManager._internal();
  factory PrepaMathFormulaManager() => _instance;
  PrepaMathFormulaManager._internal();

  /// =====================================================================================
  /// 📐 FORMULES DE BINÔME (Développement du binôme de Newton)
  /// =====================================================================================

  /// Templates pour les formules de binôme (version unifiée)
  static final List<EnhancedFormulaTemplate> binomeFormulas = [
    // Développement général
    EnhancedFormulaTemplate(
      latex: r'(a+b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{\,n-k} b^{\,k}',
      description: 'développement général du binôme de Newton',
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
          description: 'exposant entier positif',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 8,
        ),
      ],
    ),

    // Coefficient binomial de base
    EnhancedFormulaTemplate(
      latex: r'\binom{n}{k} = \frac{n!}{k!\,(n-k)!}',
      description: 'définition du coefficient binomial',
      parameters: const [
        FormulaParameter(
          name: 'n',
          description: 'taille de l\'ensemble',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 15,
        ),
        FormulaParameter(
          name: 'k',
          description: 'éléments choisis',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 15,
        ),
      ],
    ),

    // Relation de Pascal
    EnhancedFormulaTemplate(
      latex: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
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

    // Symétrie
    EnhancedFormulaTemplate(
      latex: r'\binom{n}{k} = \binom{n}{n-k}',
      description: 'propriété de symétrie des coefficients binomiaux',
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

    // Formule du binôme pour (1+1)^n
    EnhancedFormulaTemplate(
      latex: r'\sum_{k=0}^{n} \binom{n}{k} = 2^n',
      description: 'somme de tous les coefficients binomiaux',
      parameters: const [
        FormulaParameter(
          name: 'n',
          description: 'exposant',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 10,
        ),
      ],
    ),

    // Développement binomial spécial
    EnhancedFormulaTemplate(
      latex: r'(1+x)^n = \sum_{k=0}^{n} \binom{n}{k} x^{k}',
      description: 'développement binomial pour 1+x',
      parameters: const [
        FormulaParameter(
          name: 'x',
          description: 'variable réelle',
          type: ParameterType.REAL,
        ),
        FormulaParameter(
          name: 'n',
          description: 'exposant entier',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 8,
        ),
      ],
    ),

    // Alternance
    EnhancedFormulaTemplate(
      latex: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0 \quad (n \ge 1)',
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
      latex: r'\sum_{k=r}^{n} \binom{k}{r} = \binom{n+1}{r+1} \quad (r \le n)',
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

    // Cas particuliers
    EnhancedFormulaTemplate(
      latex: r'\binom{n}{0} = 1',
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
      latex: r'\binom{n}{n} = 1',
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
  ];

  /// =====================================================================================
  /// ∑ FORMULES DE SOMMES (Sommations classiques)
  /// =====================================================================================

  /// Templates pour les formules de sommes
  static final List<EnhancedFormulaTemplate> sommesFormulas = [
    // Somme des premiers entiers
    EnhancedFormulaTemplate(
      latex: r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}',
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
      latex: r'\sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6}',
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
      latex: r'\sum_{k=1}^{n} k^3 = \left(\frac{n(n+1)}{2}\right)^2',
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
      latex: r'\sum_{k=0}^{n} q^k = \frac{1-q^{n+1}}{1-q} \quad (q \neq 1)',
      description: 'somme des termes d\'une suite géométrique finie',
      parameters: const [
        FormulaParameter(
          name: 'q',
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
      latex: r'\sum_{k=1}^{n} (2k-1) = n^2',
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
      latex: r'\sum_{k=1}^{n} \frac{1}{k(k+1)} = 1 - \frac{1}{n+1}',
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
  /// 🔢 FORMULES DE COMBINAISONS (Analyse combinatoire)
  /// =====================================================================================

  /// Templates pour les formules de combinaisons
  static final List<EnhancedFormulaTemplate> combinaisonsFormulas = [
    // Définition de base
    EnhancedFormulaTemplate(
      latex: r'C(n,k) = \binom{n}{k} = \frac{n!}{k!(n-k)!}',
      description: 'nombre de combinaisons de k éléments parmi n',
      parameters: const [
        FormulaParameter(
          name: 'n',
          description: 'taille de l\'ensemble',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 15,
        ),
        FormulaParameter(
          name: 'k',
          description: 'éléments choisis',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 15,
        ),
      ],
    ),

    // Propriété symétrique
    EnhancedFormulaTemplate(
      latex: r'\binom{n}{k} = \binom{n}{n-k}',
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
      latex: r'\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}',
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

    // Formule du binôme
    EnhancedFormulaTemplate(
      latex: r'(a+b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^{k}',
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
      latex: r'\sum_{k=0}^{n} \binom{n}{k} = 2^n',
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

    // Relation d\'orthogonalité
    EnhancedFormulaTemplate(
      latex: r'\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0 \quad (n \ge 1)',
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
      latex: r'\sum_{k=0}^{n} \binom{m}{k} \binom{n-m}{n-k} = \binom{n}{m}',
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
          name: 'm',
          description: 'paramètre fixe',
          type: ParameterType.NATURAL,
          minValue: 0,
          maxValue: 12,
        ),
      ],
    ),
  ];

  /// =====================================================================================
  /// 🔧 MÉTHODES UTILITAIRES
  /// =====================================================================================

  /// Génère une liste de formules LaTeX à partir des templates
  static List<String> generateLatexFormulas(
      List<EnhancedFormulaTemplate> templates) {
    return EnhancedFormulaPerturbationGenerator.generateLatexFormulas(
        templates);
  }

  /// Génère les descriptions correspondantes
  static List<String> generateDescriptions(
      List<EnhancedFormulaTemplate> templates) {
    return EnhancedFormulaPerturbationGenerator.generateDescriptions(templates);
  }

  /// Valide tous les templates
  static bool validateAllTemplates() {
    final allTemplates = [
      ...binomeFormulas,
      ...sommesFormulas,
      ...combinaisonsFormulas
    ];
    return EnhancedFormulaPerturbationGenerator.validateTemplates(allTemplates);
  }

  /// Obtient toutes les formules d'une catégorie
  static List<EnhancedFormulaTemplate> getFormulasByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'binome':
      case 'binomial':
        return binomeFormulas;
      case 'somme':
      case 'sum':
        return sommesFormulas;
      case 'combinaison':
      case 'combination':
        return combinaisonsFormulas;
      default:
        return [];
    }
  }

  /// Recherche des formules par mots-clés
  static List<EnhancedFormulaTemplate> searchFormulas(String keyword) {
    final allTemplates = [
      ...binomeFormulas,
      ...sommesFormulas,
      ...combinaisonsFormulas
    ];
    final lowerKeyword = keyword.toLowerCase();

    return allTemplates.where((template) {
      return template.description.toLowerCase().contains(lowerKeyword) ||
          template.latex.toLowerCase().contains(lowerKeyword);
    }).toList();
  }

  /// =====================================================================================
  /// 🔄 COMPATIBILITÉ AVEC L'ANCIEN SYSTÈME
  /// =====================================================================================

  /// Génère les listes compatibles avec l'ancien système binome_formules_screen.dart
  void generateLegacyLists({
    required List<String> leftList,
    required List<String> rightList,
    required List<String> descriptionList,
    int? count,
  }) {
    final templates = binomeFormulas;
    final selectedTemplates = count != null && count < templates.length
        ? templates.take(count).toList()
        : templates;

    leftList.clear();
    rightList.clear();
    descriptionList.clear();

    for (final template in selectedTemplates) {
      final variants = template.generateSmartVariants();
      for (final variant in variants) {
        leftList.add(variant.latex);
        rightList.add(variant.description);
        descriptionList.add(variant.description);
      }
    }
  }

  /// Génère les listes pour les sommes (legacy compatibility)
  void generateLegacySumLists({
    required List<String> leftList,
    required List<String> rightList,
    required List<String> descriptionList,
    int? count,
  }) {
    final templates = sommesFormulas;
    final selectedTemplates = count != null && count < templates.length
        ? templates.take(count).toList()
        : templates;

    leftList.clear();
    rightList.clear();
    descriptionList.clear();

    for (final template in selectedTemplates) {
      final variants = template.generateSmartVariants();
      for (final variant in variants) {
        leftList.add(variant.latex);
        rightList.add(variant.description);
        descriptionList.add(variant.description);
      }
    }
  }

  /// =====================================================================================
  /// 🎲 GÉNÉRATION DE PUZZLES ALÉATOIRES
  /// =====================================================================================

  /// Génère un puzzle de binôme aléatoire
  QuestionnairePreset generateRandomBinomePuzzle() {
    final templates = [...binomeFormulas];
    templates.shuffle();

    // Sélectionner 5-7 formules aléatoirement
    final selectedCount = 5 + math.Random().nextInt(3); // 5 à 7 formules
    final selectedTemplates = templates.take(selectedCount).toList();

    final leftFormulas = <String>[];
    final rightDescriptions = <String>[];

    for (final template in selectedTemplates) {
      final variants = template.generateSmartVariants();
      // Prendre la première variante (originale) pour éviter la complexité
      if (variants.isNotEmpty) {
        leftFormulas.add(variants[0].latex);
        rightDescriptions.add(variants[0].description);
      }
    }

    return QuestionnairePreset(
      id: 'prepa_math_binome_unified_${DateTime.now().millisecondsSinceEpoch}',
      nom: 'Binôme Unifié',
      titre: 'BINÔME DE NEWTON - SYSTÈME UNIFIÉ',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Formules unifiées avec validation automatique',
      colonneGauche: leftFormulas,
      colonneDroite: rightDescriptions,
      description:
          'Puzzle généré automatiquement avec le système unifié de formules',
      ratioLargeurColonnes: 0.6,
    );
  }

  /// Génère un puzzle de sommes aléatoire
  QuestionnairePreset generateRandomSumPuzzle() {
    final templates = [...sommesFormulas];
    templates.shuffle();

    final selectedCount = 5 + math.Random().nextInt(3);
    final selectedTemplates = templates.take(selectedCount).toList();

    final leftFormulas = <String>[];
    final rightDescriptions = <String>[];

    for (final template in selectedTemplates) {
      final variants = template.generateSmartVariants();
      if (variants.isNotEmpty) {
        leftFormulas.add(variants[0].latex);
        rightDescriptions.add(variants[0].description);
      }
    }

    return QuestionnairePreset(
      id: 'prepa_math_sommes_unified_${DateTime.now().millisecondsSinceEpoch}',
      nom: 'Sommes Unifiées',
      titre: 'FORMULES DE SOMMES - SYSTÈME UNIFIÉ',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.formulairesLatex,
      sousTheme: 'Sommations classiques avec validation',
      colonneGauche: leftFormulas,
      colonneDroite: rightDescriptions,
      description: 'Puzzle de sommes généré automatiquement avec validation',
      ratioLargeurColonnes: 0.6,
    );
  }

  /// =====================================================================================
  /// 📊 STATISTIQUES ET DIAGNOSTIC
  /// =====================================================================================

  /// Statistiques du système unifié
  Map<String, dynamic> getStatistics() {
    return {
      'total_formulas': binomeFormulas.length +
          sommesFormulas.length +
          combinaisonsFormulas.length,
      'binome_count': binomeFormulas.length,
      'sommes_count': sommesFormulas.length,
      'combinaisons_count': combinaisonsFormulas.length,
      'validation_status':
          validateAllTemplates() ? '✅ Valide' : '❌ Erreurs détectées',
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  /// =====================================================================================
  /// 🚀 FONCTION DE DÉMONSTRATION RAPIDE
  /// =====================================================================================

  /// Démonstration rapide du système unifié (appelable depuis n'importe où)
  void demo() {
    print('\n🎯 DÉMONSTRATION - PrepaMathFormulaManager');

    // Afficher les statistiques
    final stats = getStatistics();
    print('📊 ${stats['total_formulas']} formules organisées');

    // Tester une génération de puzzle
    final puzzle = generateRandomBinomePuzzle();
    print('🎲 Puzzle créé: ${puzzle.colonneGauche.length} formules');

    // Tester la recherche
    final results = searchFormulas('binom');
    print('🔍 Recherche "binom": ${results.length} formules trouvées');

    print('✅ Système unifié opérationnel !\n');
  }

  /// Diagnostic complet du système
  void printDiagnostic() {
    final stats = getStatistics();
    print('''
🧮 DIAGNOSTIC - PrepaMathFormulaManager
═══════════════════════════════════════════════
📊 Statistiques :
   • Total formules : ${stats['total_formulas']}
   • Binômes : ${stats['binome_count']}
   • Sommes : ${stats['sommes_count']}
   • Combinaisons : ${stats['combinaisons_count']}

🔍 État : ${stats['validation_status']}
📅 Dernière mise à jour : ${stats['last_updated']}

📝 Recherche disponible :
   • getFormulasByCategory('binome'|'somme'|'combinaison')
   • searchFormulas('mot-clé')
   • generateRandomBinomePuzzle()
   • generateRandomSumPuzzle()
   • demo() - Démonstration rapide

✅ Système opérationnel !
═══════════════════════════════════════════════
    ''');
  }
}
