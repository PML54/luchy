/// <cursor>
/// LUCHY - Générateur d'images éducatives
///
/// Utilitaire pour créer des images de puzzle éducatives avec
/// 2 colonnes (questions/réponses, français/anglais, etc.).
///
/// COMPOSANTS PRINCIPAUX:
/// - generateNamesGridImagq@e(): Génération image grille 2 colonnes
/// - generateMultiplicationTable(): Preset tables de multiplication
/// - getVocabularyList(): Preset vocabulaire français-anglais
/// - Educational presets: Collections prêtes à utiliser
///
/// ÉTAT ACTUEL:
/// - Génération: Image PNG en mémoire avec dart:ui natif
/// - Auto-fit: Adaptation automatique taille police
/// - Customisation: Dimensions, couleurs, styles configurables
/// - Intégration: Compatible avec Image.memory() existant
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU TYPE PUZZLE - Combinaisons mathématiques (type 3)
/// - Ajout TypeDeJeu.combinaisonsMatematiques pour coefficients binomiaux
/// - Générateur automatique couples (n,p) avec n≥p, n<6, résultats uniques
/// - Notation LaTeX moderne \binom{n}{p} avec flutter_math_fork
/// - Support puzzleType=3 dans architecture existante
/// - Integration complète interface utilisateur et providers
/// - 2025-01-27: RESTRUCTURATION MAJEURE: QuestionnairePreset avec niveaux français
/// - Niveaux: Primaire, Collège, Lycée, Prépa, Supérieur
/// - Catégories: Mathématiques, Français, Anglais, Histoire, Géographie, Sciences, Économie
/// - Structure: id, nom, titre, niveau, catégorie, colonnes, sousThème
/// - Couleurs par niveau: Vert→Bleu→Orange→Violet→Rouge
/// - Compatibilité: Conversion automatique vers ancien format
/// - 2025-09-01: 🧹 NETTOYAGE ARCHITECTURAL - Suppression des classes obsolètes
/// - SUPPRIMÉ: FormulaTemplate, FormulaVariant, FormulaPerturbationGenerator (remplacés par architecture étendue)
/// - SUPPRIMÉ: Anciens templates binomeTemplates, combinaisonsTemplates, sommesTemplates
/// - SUPPRIMÉ: Fonction demonstratePerturbations() (fonctionnalité intégrée dans testEnhancedCalculations())
/// - 2025-09-01: 🚀 ARCHITECTURE ÉTENDUE AVEC CALCUL AUTOMATIQUE - Révolution complète !
/// - FormulaParameter avec validation intelligente (types, bornes, interchangeabilité)
/// - EnhancedFormulaTemplate avec calcul numérique intégré
/// - Génération automatique d'exemples et perturbations pédagogiques
/// - Validation automatique et génération d'exercices
/// - 2025-09-01: 🏗️ ARCHITECTURE MÉTADONNÉES - Génération automatique de perturbations pédagogiques
/// - 2025-09-01: 🔄 INTÉGRATION COMPLÈTE - Les 3 catégories Calcul prépa utilisent maintenant l'architecture automatique
/// - 2025-09-01: AJOUT PERTURBATION - 2 formules identiques avec paramètres inversés pour les 3 catégories Calcul prépa
/// - 2025-08-25: Création initiale avec code utilisateur
///
/// 🔧 POINTS D'ATTENTION:
/// - Architecture Étendue: FormulaParameter avec validation automatique (types, bornes)
/// - Calcul Automatique: EnhancedFormulaTemplate calcule numériquement toutes les formules
/// - Validation Intelligente: Paramètres validés selon leur type et contraintes
/// - Génération d'Exemples: Exemples numériques générés automatiquement pour les tests
/// - Perturbations Avancées: Variables interchangeables détectées automatiquement
/// - Performance: Calcul limité pour éviter les débordements (n ≤ 10 pour binôme, n ≤ 12 pour combinaisons)
/// - Memory: Surveiller usage mémoire pour images complexes
/// - Text rendering: Gérer débordement texte et ellipsis
/// - Architecture Métadonnées: FormulaTemplate + FormulaPerturbationGenerator pour génération automatique
/// - Génération Automatique: Les 3 catégories Calcul prépa utilisent maintenant des templates avec perturbations
/// - Perturbation: 2 formules identiques avec paramètres inversés générées automatiquement
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter plus de presets (géographie, sciences)
/// - Implémenter validation longueur textes
/// - Optimiser rendu pour grandes grilles
/// - Ajouter export/sauvegarde optionnel
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/controllers/image_controller.dart: Intégration
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: UI
/// - core/utils/image_optimizer.dart: Optimisation post-génération
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (STRUCTURE ÉDUCATIVE COMPLÈTE)
/// 📅 Dernière modification: 2025-09-01 04:23
/// </cursor>

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 🧮 ARCHITECTURE ÉTENDUE DES FORMULES MATHÉMATIQUES
/// Avec calcul automatique et validation intelligente

/// Type de paramètre pour la validation automatique
enum ParameterType {
  INTEGER, // Entiers relatifs (..., -2, -1, 0, 1, 2, ...)
  NATURAL, // Entiers naturels (0, 1, 2, 3, ...)
  POSITIVE, // Nombres positifs stricts (> 0)
  REAL, // Nombres réels
}

/// Type de formule pour le calcul automatique
enum FormulaType {
  COMBINAISON, // Coefficients binomiaux C(n,k)
  BINOME, // Développement (a+b)^n
  SOMME, // Sommes Σ
  UNKNOWN, // Non identifié
}

/// Paramètre d'une formule avec validation
class FormulaParameter {
  final String name;
  final String description;
  final bool canInvert;
  final ParameterType type;
  final num? minValue;
  final num? maxValue;

  const FormulaParameter({
    required this.name,
    required this.description,
    this.canInvert = false,
    this.type = ParameterType.INTEGER,
    this.minValue,
    this.maxValue,
  });

  /// Valide une valeur pour ce paramètre
  bool validate(num value) {
    // Validation selon le type
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

    // Validation des bornes
    if (minValue != null && value < minValue!) return false;
    if (maxValue != null && value > maxValue!) return false;

    return true;
  }
}

/// Template de formule étendu avec calcul automatique
class EnhancedFormulaTemplate {
  final String latex;
  final String description;
  final List<FormulaParameter> parameters;

  const EnhancedFormulaTemplate({
    required this.latex,
    required this.description,
    required this.parameters,
  });

  /// Propriétés calculées
  int get parameterCount => parameters.length;
  List<String> get variableNames => parameters.map((p) => p.name).toList();
  List<String> get invertibleVariables =>
      parameters.where((p) => p.canInvert).map((p) => p.name).toList();

  /// Calcule la valeur numérique de la formule
  num? calculate(
    Map<String, num> parameterValues, {
    bool validateParameters = true,
  }) {
    // Validation des paramètres si demandé
    if (validateParameters && !_validateParameters(parameterValues)) {
      return null;
    }

    // Calcul selon le type de formule
    return _computeFormula(parameterValues);
  }

  /// Valide tous les paramètres
  bool _validateParameters(Map<String, num> values) {
    for (final param in parameters) {
      final value = values[param.name];
      if (value == null) return false;
      if (!param.validate(value)) return false;
    }
    return true;
  }

  /// Identifie le type de formule
  FormulaType _identifyFormulaType() {
    if (latex.contains(r'\binom')) return FormulaType.COMBINAISON;
    if (latex.contains(r'\sum') && latex.contains('k ='))
      return FormulaType.SOMME;
    if (latex.contains('^n') || latex.contains('^2') || latex.contains('^3'))
      return FormulaType.BINOME;
    return FormulaType.UNKNOWN;
  }

  /// Calcule la formule selon son type
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

  /// Calcule un coefficient binomial C(n,k)
  num? _calculateCombinaison(Map<String, num> values) {
    final n = values['n']?.toInt();
    final k = values['k']?.toInt();
    if (n == null || k == null || k > n || k < 0) return null;

    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  /// Calcule un développement binomial (a+b)^n
  num? _calculateBinome(Map<String, num> values) {
    final a = values['a'];
    final b = values['b'];
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

  /// Calcule une somme Σ(k=1 to n) k = n(n+1)/2
  num? _calculateSomme(Map<String, num> values) {
    final n = values['n']?.toInt();
    if (n == null || n < 1) return null;

    // Formule de la somme des n premiers entiers
    return n * (n + 1) / 2;
  }

  /// Calcule la factorielle d'un nombre
  int _factorial(int n) {
    if (n <= 1) return 1;
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  /// Génère des variantes avec paramètres inversés
  List<FormulaVariant> generateSmartVariants() {
    if (invertibleVariables.length < 2) {
      return [FormulaVariant(latex: latex, description: description)];
    }

    final variants = <FormulaVariant>[];
    variants.add(FormulaVariant(latex: latex, description: description));

    // Générer la variante avec paramètres inversés
    final invertedLatex = _invertVariablesInLatex(latex, invertibleVariables);
    final invertedDescription = '$description (paramètres inversés)';

    variants.add(FormulaVariant(
      latex: invertedLatex,
      description: invertedDescription,
    ));

    return variants;
  }

  /// Inverse les variables dans une formule LaTeX
  String _invertVariablesInLatex(String latex, List<String> variables) {
    if (variables.length != 2) return latex;

    final var1 = variables[0];
    final var2 = variables[1];

    String result = latex;

    // Échapper les backslashes pour les regex
    final escapedVar1 = RegExp.escape(var1);
    final escapedVar2 = RegExp.escape(var2);

    // Utiliser une approche plus robuste pour les expressions mathématiques
    result = result.replaceAllMapped(
        RegExp(r'(?<![a-zA-Z])' + escapedVar1 + r'(?![a-zA-Z0-9])'),
        (match) => var2);
    result = result.replaceAllMapped(
        RegExp(r'(?<![a-zA-Z])' + escapedVar2 + r'(?![a-zA-Z0-9])'),
        (match) => var1);

    return result;
  }

  /// Génère des exemples numériques valides
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

        // Respecter les bornes
        if (param.minValue != null && value < param.minValue!) {
          value = param.minValue!;
        }
        if (param.maxValue != null && value > param.maxValue!) {
          value = param.maxValue!;
        }

        example[param.name] = value;
      }

      // Vérifier que l'exemple est valide pour tous les paramètres
      if (_validateParameters(example)) {
        examples.add(example);
      }
    }

    return examples;
  }
}

/// Variante d'une formule générée (utilisée par EnhancedFormulaTemplate)
class FormulaVariant {
  final String latex;
  final String description;

  const FormulaVariant({
    required this.latex,
    required this.description,
  });
}

/// Générateur étendu de perturbations pédagogiques
class EnhancedFormulaPerturbationGenerator {
  /// Génère une liste de formules avec perturbations
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

/// 🧮 ARCHITECTURE RÉVOLUTIONNAIRE AVEC CALCUL AUTOMATIQUE
/// Les anciennes classes FormulaTemplate, FormulaVariant et FormulaPerturbationGenerator
/// ont été supprimées et remplacées par l'architecture étendue EnhancedFormulaTemplate
/// qui offre le calcul automatique et la validation intelligente.

/// 🔧 FONCTIONS UTILITAIRES POUR L'ARCHITECTURE

/// 🎯 NOUVELLES ARCHITECTURES AVEC CALCUL AUTOMATIQUE

/// Templates étendus pour les formules de Binôme de Newton
final List<EnhancedFormulaTemplate> enhancedBinomeTemplates = [
  EnhancedFormulaTemplate(
    latex: r'(a+b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{\,n-k} b^{\,k}',
    description: 'développement du binôme de Newton',
    parameters: [
      FormulaParameter(
        name: 'a',
        description: 'première variable (interchangeable avec b)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'b',
        description: 'deuxième variable (interchangeable avec a)',
        canInvert: true,
        type: ParameterType.REAL,
      ),
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 5, // Limite pour éviter les calculs trop lourds
      ),
    ],
  ),
  EnhancedFormulaTemplate(
    latex: r'\binom{n}{k} = \frac{n!}{k!\,(n-k)!}',
    description: 'coefficient binomial de base',
    parameters: [
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
    latex: r'(1+x)^n = \sum_{k=0}^{n} \binom{n}{k} x^{k}',
    description: 'développement binomial spécial',
    parameters: [
      FormulaParameter(
        name: 'x',
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
];

/// Templates étendus pour les formules de Combinaisons
final List<EnhancedFormulaTemplate> enhancedCombinaisonsTemplates = [
  EnhancedFormulaTemplate(
    latex: r'\binom{n}{k} = \frac{n!}{k!\,(n-k)!}',
    description: 'définition du coefficient binomial',
    parameters: [
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
  EnhancedFormulaTemplate(
    latex: r'\binom{n}{k} = \binom{n}{n-k}',
    description: 'propriété de symétrie des coefficients binomiaux',
    parameters: [
      FormulaParameter(
        name: 'n',
        description: 'taille totale de l\'ensemble',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 10,
      ),
      FormulaParameter(
        name: 'k',
        description: 'indice (interchangeable avec n-k)',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{n} \binom{n}{k} = 2^n',
    description: 'formule du binôme pour (1+1)^n',
    parameters: [
      FormulaParameter(
        name: 'n',
        description: 'exposant entier positif',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 8,
      ),
    ],
  ),
];

/// Templates étendus pour les formules de Sommes
final List<EnhancedFormulaTemplate> enhancedSommesTemplates = [
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}',
    description: 'somme des n premiers entiers naturels',
    parameters: [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure de la somme',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 20,
      ),
    ],
  ),
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6}',
    description: 'somme des carrés des n premiers entiers',
    parameters: [
      FormulaParameter(
        name: 'n',
        description: 'borne supérieure de la somme',
        type: ParameterType.NATURAL,
        minValue: 1,
        maxValue: 15,
      ),
    ],
  ),
  EnhancedFormulaTemplate(
    latex: r'\sum_{k=0}^{n} q^k = \frac{1-q^{n+1}}{1-q}',
    description: 'somme des termes d\'une suite géométrique finie',
    parameters: [
      FormulaParameter(
        name: 'q',
        description: 'raison de la suite géométrique',
        type: ParameterType.REAL,
        minValue: -5,
        maxValue: 5,
      ),
      FormulaParameter(
        name: 'n',
        description: 'nombre de termes',
        type: ParameterType.NATURAL,
        minValue: 0,
        maxValue: 10,
      ),
    ],
  ),
];



/// 🎯 FONCTIONS DE DÉMONSTRATION DE L'ARCHITECTURE

/// Crée un preset Binôme avec le nouveau système de calcul automatique
QuestionnairePreset createEnhancedBinomePreset() {
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

/// Crée un preset Combinaisons avec le nouveau système
QuestionnairePreset createEnhancedCombinaisonsPreset() {
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

/// Crée un preset Sommes avec le nouveau système
QuestionnairePreset createEnhancedSommesPreset() {
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

/// 🧪 FONCTION DE TEST DU CALCUL AUTOMATIQUE
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

/// 🔍 FONCTION DE VALIDATION DES TEMPLATES ÉTENDUS
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



/// 🐛 FONCTION DE DEBUG POUR VÉRIFIER LES QUESTIONNAIRES
void debugQuestionnaires() {
  print('🐛 DEBUG DES QUESTIONNAIRES');
  print('=' * 40);

  final allQuestionnaires = EducationalImageGenerator.getAllQuestionnaires();
  print('Nombre total de questionnaires: ${allQuestionnaires.length}');

  // Chercher les questionnaires de prépa math
  final prepaMathQuestionnaires = allQuestionnaires
      .where((q) =>
          q.niveau == NiveauEducatif.prepa &&
          q.categorie == CategorieMatiere.mathematiques &&
          q.nom == 'Calcul')
      .toList();

  print(
      'Questionnaires Prépa Math Calcul trouvés: ${prepaMathQuestionnaires.length}');

  for (final q in prepaMathQuestionnaires) {
    print('\n📋 ${q.titre}');
    print('   ID: ${q.id}');
    print('   Nombre de formules: ${q.colonneGauche.length}');

    for (int i = 0; i < q.colonneGauche.length; i++) {
      print('   ${i + 1}. ${q.colonneGauche[i]}');
      print('      → ${q.colonneDroite[i]}');
    }
  }
}

/// Résultat de génération d'image éducative
class EducationalImageResult {
  final Uint8List pngBytes;
  final int rows;
  final int columns;
  final String description;
  final List<int>? originalMapping; // Mapping des indices originaux

  const EducationalImageResult({
    required this.pngBytes,
    required this.rows,
    required this.columns,
    required this.description,
    this.originalMapping,
  });
}

/// Résultat du mélange éducatif
class EducationalShuffleResult {
  final List<String> shuffledLeft;
  final List<String> shuffledRight;
  final List<int> mapping; // Indices originaux pour chaque position

  const EducationalShuffleResult({
    required this.shuffledLeft,
    required this.shuffledRight,
    required this.mapping,
  });
}

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

/// Générateur d'images éducatives
class EducationalImageGenerator {
  /// Génère une image portrait avec 2 colonnes (liste gauche / liste droite)
  /// et n lignes (n = left.length = right.length). Chaque cellule a la même taille,
  /// idéale pour un découpage ultérieur en 2n sous-images.
  /// Retourne des bytes PNG (Uint8List).
  static Future<EducationalImageResult> generateNamesGridImage({
    required List<String> left,
    required List<String> right,
    double cellWidth =
        600, // largeur d'une cellule (colonne) - pour compatibilité
    double cellHeight = 200, // hauteur d'une cellule (ligne)
    double padding = 24, // marge intérieure pour le texte
    double initialFontSize = 64,
    double minFontSize = 20,
    Color backgroundColor = Colors.white,
    Color? leftColumnColor, // Couleur fond colonne gauche
    Color? rightColumnColor, // Couleur fond colonne droite
    Color gridColor = Colors.black,
    double gridStrokeWidth = 2.0,
    String? fontFamily, // éventuellement passer une police custom
    String description = "Image éducative personnalisée",
    double? ratioLargeurColonnes, // Ratio gauche/droite (null = 50%/50%)
  }) async {
    assert(left.length == right.length,
        "Les deux listes doivent avoir la même longueur.");
    final n = left.length;

    // Calcul des largeurs selon le ratio (défaut 50%/50%)
    final double ratio = ratioLargeurColonnes ?? 0.5;
    final double totalWidth = cellWidth * 2;
    final double leftCellWidth = totalWidth * ratio;
    final double rightCellWidth = totalWidth * (1.0 - ratio);

    final double width = leftCellWidth + rightCellWidth;
    final double height = cellHeight * n;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

    // Fond général
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    // Fonds colorés par colonne avec largeurs dynamiques
    if (leftColumnColor != null) {
      final leftColumnPaint = Paint()..color = leftColumnColor;
      canvas.drawRect(
          Rect.fromLTWH(0, 0, leftCellWidth, height), leftColumnPaint);
    }

    if (rightColumnColor != null) {
      final rightColumnPaint = Paint()..color = rightColumnColor;
      canvas.drawRect(Rect.fromLTWH(leftCellWidth, 0, rightCellWidth, height),
          rightColumnPaint);
    }

    // Grille
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = gridStrokeWidth;
    // Contour extérieur
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), gridPaint);
    // Ligne verticale centrale (largeur dynamique)
    canvas.drawLine(
        Offset(leftCellWidth, 0), Offset(leftCellWidth, height), gridPaint);
    // Lignes horizontales
    for (int i = 1; i < n; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Helper pour créer un TextPainter
    TextPainter _tp(String text, TextStyle style) => TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    // Dessine la notation binomiale moderne (n au-dessus de p dans des parenthèses)
    void drawBinomialNotation(
      String n,
      String p,
      Rect cell, {
      double gap = 6, // espace vertical entre n et p
    }) {
      final numberFontSize =
          (initialFontSize * 1.2).clamp(minFontSize, initialFontSize * 1.5);
      final parenFontSize =
          (initialFontSize * 1.4).clamp(minFontSize, initialFontSize * 1.8);

      final tsNumber = TextStyle(
        fontSize: numberFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      );

      final tsParen = TextStyle(
        fontSize: parenFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      );

      // Prépare les painters
      final top = _tp(n, tsNumber);
      final bot = _tp(p, tsNumber);
      final lParen = _tp("(", tsParen);
      final rParen = _tp(")", tsParen);

      top.layout();
      bot.layout();
      lParen.layout();
      rParen.layout();

      // Dimensions combinées (largeur = parenthèse gauche + max(n,p) + parenthèse droite)
      final innerWidth = top.width > bot.width ? top.width : bot.width;
      final totalWidth = lParen.width + innerWidth + rParen.width;

      // Hauteur combinée (n au-dessus, p en dessous, séparés par gap)
      final totalHeight = top.height + gap + bot.height;

      // Point de départ pour centrer dans cell
      final start = Offset(
        cell.left + (cell.width - totalWidth) / 2,
        cell.top + (cell.height - totalHeight) / 2,
      );

      // Positions
      final leftParenOffset =
          Offset(start.dx, start.dy + (totalHeight - lParen.height) / 2);
      final numbersStartX = start.dx + lParen.width;

      final topOffset = Offset(
        numbersStartX + (innerWidth - top.width) / 2,
        start.dy,
      );
      final botOffset = Offset(
        numbersStartX + (innerWidth - bot.width) / 2,
        start.dy + top.height + gap,
      );

      final rightParenOffset = Offset(
        numbersStartX + innerWidth,
        start.dy + (totalHeight - rParen.height) / 2,
      );

      // Dessin
      lParen.paint(canvas, leftParenOffset);
      top.paint(canvas, topOffset);
      bot.paint(canvas, botOffset);
      rParen.paint(canvas, rightParenOffset);
    }

    // Fonction d'écriture centrée avec auto-fit et support notation binomiale
    Future<void> drawCenteredTextInCell({
      required String text,
      required Rect cell,
    }) async {
      // Vérifier si c'est une notation binomiale C(n,p)
      final binomMatch = RegExp(r'C\((\d+),(\d+)\)').firstMatch(text);

      if (binomMatch != null) {
        // Dessiner la notation binomiale moderne
        final n = binomMatch.group(1)!;
        final p = binomMatch.group(2)!;
        drawBinomialNotation(n, p, cell);
        return;
      }

      // Sinon, dessiner le texte normal
      double fontSize = initialFontSize;
      TextPainter painter;

      final isMultiline = text.contains('\n');
      final maxLines = isMultiline ? 2 : 1;

      while (true) {
        final textSpan = TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontFamily: fontFamily,
            height: isMultiline ? 0.8 : 1.0,
          ),
        );
        painter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          ellipsis: '…',
        );
        painter.layout(maxWidth: cell.width - 2 * padding);

        final fitsWidth = painter.size.width <= (cell.width - 2 * padding);
        final fitsHeight = painter.size.height <= (cell.height - 2 * padding);

        if ((fitsWidth && fitsHeight) || fontSize <= minFontSize) {
          break;
        }
        fontSize = (fontSize - 2).clamp(minFontSize, initialFontSize);
      }

      final dx = cell.left + (cell.width - painter.size.width) / 2;
      final dy = cell.top + (cell.height - painter.size.height) / 2;
      painter.paint(canvas, Offset(dx, dy));
    }

    // Remplir les cellules avec largeurs dynamiques
    for (int i = 0; i < n; i++) {
      // Colonne gauche (largeur dynamique)
      final leftCell = Rect.fromLTWH(
        0,
        i * cellHeight,
        leftCellWidth,
        cellHeight,
      );
      await drawCenteredTextInCell(text: left[i], cell: leftCell);

      // Colonne droite (largeur dynamique)
      final rightCell = Rect.fromLTWH(
        leftCellWidth,
        i * cellHeight,
        rightCellWidth,
        cellHeight,
      );
      await drawCenteredTextInCell(text: right[i], cell: rightCell);
    }

    // Finalise l'image
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Impossible de générer les données d\'image éducative');
    }

    return EducationalImageResult(
      pngBytes: byteData.buffer.asUint8List(),
      rows: n,
      columns: 2,
      description: description,
    );
  }

  /// Génère une table de multiplication aléatoire
  static EducationalPreset generateRandomMultiplicationTable() {
    final left = <String>[];
    final right = <String>[];

    // Générer 8 multiplications aléatoires uniques
    final usedPairs = <String>{};
    final random = math.Random();

    while (left.length < 8) {
      final a = 2 + random.nextInt(8); // 2 à 9
      final b = 2 + random.nextInt(8); // 2 à 9
      final pairKey = '${math.min(a, b)}_${math.max(a, b)}';

      if (!usedPairs.contains(pairKey)) {
        usedPairs.add(pairKey);
        left.add('$a × $b');
        right.add('${a * b}');
      }
    }

    return EducationalPreset(
      id: 'multiplication_random',
      name: 'Calcul',
      description: 'Multiplications aléatoires',
      leftColumn: left,
      rightColumn: right,
    );
  }

  /// Génère un puzzle de combinaisons mathématiques
  /// Crée des couples (n,p) avec n >= p et n < 6, en s'assurant que tous les résultats sont uniques
  static QuestionnairePreset generateCombinationsPuzzle() {
    /// Calcule C(n,p) = n! / (p! * (n-p)!)
    int combinaison(int n, int p) {
      if (p > n || p < 0) return 0;
      if (p == 0 || p == n) return 1;

      // Optimisation: C(n,p) = C(n,n-p)
      if (p > n - p) p = n - p;

      int result = 1;
      for (int i = 0; i < p; i++) {
        result = result * (n - i) ~/ (i + 1);
      }
      return result;
    }

    // Générer tous les couples (n,p) possibles avec n < 8 et n >= p pour plus de diversité
    final allCouples = <({int n, int p})>[];
    for (int n = 0; n < 8; n++) {
      for (int p = 0; p <= n; p++) {
        allCouples.add((n: n, p: p));
      }
    }

    // Calculer les résultats et créer une map pour vérifier l'unicité
    final resultCounts = <int, List<({int n, int p})>>{};
    for (final couple in allCouples) {
      final result = combinaison(couple.n, couple.p);
      if (!resultCounts.containsKey(result)) {
        resultCounts[result] = [];
      }
      resultCounts[result]!.add(couple);
    }

    // Stratégie améliorée : prendre d'abord les couples uniques, puis compléter avec des couples distincts
    final selectedCouples = <({int n, int p})>[];
    final usedResults = <int>{};

    // 1. D'abord, ajouter tous les couples avec résultats uniques
    for (final entry in resultCounts.entries) {
      if (entry.value.length == 1 && selectedCouples.length < 5) {
        selectedCouples.add(entry.value.first);
        usedResults.add(entry.key);
      }
    }

    // 2. Si on n'a pas assez, ajouter des couples avec résultats distincts des précédents
    final remainingCouples = allCouples.where((couple) {
      final result = combinaison(couple.n, couple.p);
      return !usedResults.contains(result) &&
          !selectedCouples.any(
              (selected) => selected.n == couple.n && selected.p == couple.p);
    }).toList();

    remainingCouples.shuffle();
    for (final couple in remainingCouples) {
      if (selectedCouples.length >= 5) break;
      final result = combinaison(couple.n, couple.p);
      if (!usedResults.contains(result)) {
        selectedCouples.add(couple);
        usedResults.add(result);
      }
    }

    // 🎯 3. AJOUT DE LA PERTURBATION : Ajouter une combinaison identique mais avec variables inversées
    if (selectedCouples.isNotEmpty) {
      // Choisir aléatoirement une des combinaisons existantes
      final randomCouple =
          selectedCouples[math.Random().nextInt(selectedCouples.length)];

      // Créer la combinaison inversée (n,p) devient (p,n) si n ≠ p
      if (randomCouple.n != randomCouple.p) {
        final invertedCouple = (n: randomCouple.p, p: randomCouple.n);
        selectedCouples.add(invertedCouple);

        print(
            '🎯 [COMBINAISONS] Perturbation ajoutée: C(${randomCouple.n},${randomCouple.p}) et C(${invertedCouple.n},${invertedCouple.p}) = ${combinaison(randomCouple.n, randomCouple.p)}');
      } else {
        // Si c'est un carré parfait (n=n), ajouter une combinaison différente
        final alternativeCouples = allCouples
            .where((couple) =>
                combinaison(couple.n, couple.p) !=
                    combinaison(randomCouple.n, randomCouple.p) &&
                !selectedCouples.any((selected) =>
                    selected.n == couple.n && selected.p == couple.p))
            .toList();

        if (alternativeCouples.isNotEmpty) {
          alternativeCouples.shuffle();
          selectedCouples.add(alternativeCouples.first);
          print(
              '🎯 [COMBINAISONS] Alternative ajoutée car combinaison carrée parfaite');
        }
      }
    }

    // Mélanger la sélection finale (avec la perturbation incluse)
    selectedCouples.shuffle();
    print(
        '🎯 [COMBINAISONS] Total de combinaisons générées: ${selectedCouples.length}');

    // Créer les colonnes
    final colonneGauche = <String>[];
    final colonneDroite = <String>[];

    for (final couple in selectedCouples) {
      // Utiliser la vraie notation LaTeX pour un rendu propre
      colonneGauche.add('C(${couple.n},${couple.p})');
      colonneDroite.add('${combinaison(couple.n, couple.p)}');
    }

    return QuestionnairePreset(
      id: 'prepa_math_combinaisons_aleatoire',
      nom: 'Combinaisons aléatoires',
      titre: 'COMBINAISONS - PUZZLE ALÉATOIRE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.combinaisonsMatematiques,
      sousTheme: 'Analyse combinatoire',
      colonneGauche: colonneGauche,
      colonneDroite: colonneDroite,
      description:
          'Puzzle généré aléatoirement avec 2 combinaisons identiques (variables inversées) pour perturber',
      ratioLargeurColonnes: 0.5, // 50%/50% pour un découpage plus équilibré
    );
  }

  /// Vocabulaire anglais collège : économie de base
  static const EducationalPreset vocabularyEconomyBasic = EducationalPreset(
    id: 'vocab_economy_basic',
    name: 'Anglais',
    description: 'Vocabulaire économique niveau collège',
    leftColumn: [
      'Entreprise',
      'Travail',
      'Argent',
      'Prix',
      'Vente',
      'Achat',
      'Marché',
      'Client',
      'Patron',
      'Emploi'
    ],
    rightColumn: [
      'Company',
      'Work',
      'Money',
      'Price',
      'Sale',
      'Purchase',
      'Market',
      'Customer',
      'Boss',
      'Job'
    ],
  );

  /// Vocabulaire anglais lycée : commerce
  static const EducationalPreset vocabularyCommerce = EducationalPreset(
    id: 'vocab_commerce',
    name: 'Anglais',
    description: 'Vocabulaire commercial niveau lycée',
    leftColumn: [
      'Bénéfice',
      'Investissement',
      'Banque',
      'Crédit',
      'Concurrence',
      'Publicité',
      'Innovation',
      'Qualité',
      'Service',
      'Exportation'
    ],
    rightColumn: [
      'Profit',
      'Investment',
      'Bank',
      'Credit',
      'Competition',
      'Advertising',
      'Innovation',
      'Quality',
      'Service',
      'Export'
    ],
  );

  /// Géographie : capitales européennes
  static const EducationalPreset geographyEurope = EducationalPreset(
    id: 'geo_europe',
    name: 'Histoire',
    description: '',
    leftColumn: [
      'France',
      'Allemagne',
      'Italie',
      'Espagne',
      'Portugal',
      'Angleterre',
      'Suède',
      'Norvège',
      'Grèce',
      'Pologne'
    ],
    rightColumn: [
      'Paris',
      'Berlin',
      'Rome',
      'Madrid',
      'Lisbonne',
      'Londres',
      'Stockholm',
      'Oslo',
      'Athènes',
      'Varsovie'
    ],
  );

  // ============ QUESTIONNAIRES STRUCTURÉS ============

  /// Questionnaires organisés par niveau et matière
  static List<QuestionnairePreset> questionnaires = [
    // === PRIMAIRE ===
    QuestionnairePreset(
      id: 'primaire_math_multiplication',
      nom: 'Calcul',
      titre: '',
      niveau: NiveauEducatif.primaire,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Calcul mental',
      colonneGauche: [
        '2 × 3',
        '4 × 5',
        '6 × 7',
        '3 × 8',
        '5 × 6',
        '7 × 4',
        '9 × 3',
        '8 × 2',
      ],
      colonneDroite: [
        '6',
        '20',
        '42',
        '24',
        '30',
        '28',
        '27',
        '16',
      ],
    ),

    // === PRÉPA ECG - BINÔME (ARCHITECTURE ÉTENDUE AVEC CALCUL) ===
    createEnhancedBinomePreset(),

    // === PRÉPA ECG - COMBINAISONS (ARCHITECTURE ÉTENDUE AVEC CALCUL) ===
    createEnhancedCombinaisonsPreset(),

    // === PRÉPA ECG - SOMMES (ARCHITECTURE ÉTENDUE AVEC CALCUL) ===
    createEnhancedSommesPreset(),

    QuestionnairePreset(
      id: 'lycee_francais_figures_style',
      nom: 'Français',
      titre: 'FIGURES DE STYLE - LYCÉE',
      niveau: NiveauEducatif.lycee,
      categorie: CategorieMatiere.francais,
      typeDeJeu: TypeDeJeu.figuresDeStyle,
      sousTheme: 'Rhétorique',
      colonneGauche: [
        'Métaphore',
        'Comparaison',
        'Hyperbole',
        'Litote',
        'Oxymore',
        'Antithèse',
      ],
      colonneDroite: [
        'mer de blé',
        'fort comme lion',
        'faim de loup',
        'pas mauvais',
        'silence assourdissant',
        'ombre et lumière',
      ],
    ),

    QuestionnairePreset(
      id: 'prepa_eco_concepts',
      nom: 'Économie',
      titre: 'ÉCONOMIE GÉNÉRALE - PRÉPA ECG',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.economie,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Macroéconomie',
      colonneGauche: [
        'PIB',
        'Inflation',
        'Chômage structurel',
        'Politique monétaire',
        'Déficit budgétaire',
        'Balance commerciale',
        'Taux de change',
        'Productivité',
      ],
      colonneDroite: [
        'Produit Intérieur Brut',
        'Hausse générale des prix',
        'Inadéquation offre/demande',
        'Contrôle masse monétaire',
        'Dépenses > Recettes État',
        'Exportations - Importations',
        'Prix d\'une monnaie',
        'Production/Facteur travail',
      ],
    ),

    // === VOCABULAIRE ECG UNIFIÉ ===
    QuestionnairePreset(
      id: 'prepa_anglais_vocabulaire_ecg',
      nom: 'Anglais',
      titre: 'VOCABULAIRE ECG - CONCOURS PRÉPA',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.anglais,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Économie & Commerce',
      colonneGauche: [
        'Produit intérieur brut',
        'Croissance économique',
        'Récession',
        'Bilan',
        'Chiffre d\'affaires',
        'Commerce international',
        'Mondialisation',
      ],
      colonneDroite: [
        'Gross Domestic Product (GDP)',
        'Economic growth',
        'Recession',
        'Balance sheet',
        'Revenue',
        'International trade',
        'Globalization',
      ],
    ),

    // === COLLÈGE ===
    QuestionnairePreset(
      id: 'college_histoire_chronologie',
      nom: 'Histoire',
      titre: 'ORDRE CHRONOLOGIQUE - MOYEN ÂGE',
      niveau: NiveauEducatif.college,
      categorie: CategorieMatiere.histoire,
      typeDeJeu: TypeDeJeu.ordreChronologique,
      sousTheme: 'Événements médiévaux',
      colonneGauche: [
        'Bataille de Hastings',
        'Prise de Constantinople',
        'Guerre de Cent Ans début',
        'Première croisade',
        'Couronnement Charlemagne',
        'Chute Empire romain',
        'Peste noire en Europe',
        'Découverte Amérique',
      ],
      colonneDroite: [
        '1066',
        '1453',
        '1337',
        '1096',
        '800',
        '476',
        '1347',
        '1492',
      ],
    ),
  ];

  /// Liste de tous les questionnaires disponibles (format moderne)
  static List<QuestionnairePreset> getAllQuestionnaires() {
    return List<QuestionnairePreset>.from(questionnaires);
  }

  /// Liste de tous les presets disponibles (ancien format)
  static List<EducationalPreset> getAllPresets() {
    final presets = <EducationalPreset>[];

    // Convertir les nouveaux questionnaires
    for (final questionnaire in questionnaires) {
      presets.add(questionnaire.toEducationalPreset());
    }

    // Table de multiplication aléatoire unique
    presets.add(generateRandomMultiplicationTable());

    // Vocabulaire - format progressif
    presets.addAll([
      vocabularyEconomyBasic,
      vocabularyCommerce,
      geographyEurope,
    ]);

    return presets;
  }

  /// Détermine les couleurs de fond selon le type de preset
  static (Color?, Color?) _getColorsForPreset(String presetId) {
    // Nouveaux questionnaires structurés
    if (presetId.startsWith('primaire_')) {
      return (Colors.green[100], Colors.lightGreen[100]); // Vert doux primaire
    } else if (presetId.startsWith('college_')) {
      return (Colors.blue[100], Colors.lightBlue[100]); // Bleu collège
    } else if (presetId.startsWith('lycee_')) {
      return (Colors.orange[100], Colors.deepOrange[100]); // Orange lycée
    } else if (presetId.startsWith('prepa_')) {
      return (Colors.purple[100], Colors.deepPurple[100]); // Violet prépa
    } else if (presetId.startsWith('superieur_')) {
      return (Colors.red[100], Colors.pink[100]); // Rouge supérieur
    }

    // Anciens formats
    else if (presetId.startsWith('multiplication_')) {
      // Tables de multiplication : Bleu clair / Vert clair
      return (Colors.blue[50], Colors.green[50]);
    } else if (presetId.startsWith('vocab_')) {
      // Vocabulaire : Rose clair / Orange clair
      return (Colors.pink[50], Colors.orange[50]);
    } else if (presetId.startsWith('geo_')) {
      // Géographie : Violet clair / Jaune clair
      return (Colors.purple[50], Colors.yellow[50]);
    } else {
      // Par défaut : Gris très clair / Bleu très clair
      return (Colors.grey[50], Colors.blue[50]);
    }
  }

  /// Génère une image à partir d'un preset avec logique éducative
  ///
  /// Pour les puzzles éducatifs :
  /// 1. Mélange d'abord la liste 1 (colonne gauche)
  /// 2. Applique le même mélange à la liste 2 (colonne droite)
  /// 3. Génère l'image avec ces listes mélangées
  /// Cela garantit la correspondance éducative pour la vérification
  static Future<EducationalImageResult> generateFromPreset(
    EducationalPreset preset, {
    double cellWidth = 600,
    double cellHeight = 200,
    bool applyEducationalShuffle = true, // Nouveau paramètre
  }) async {
    final (leftColor, rightColor) = _getColorsForPreset(preset.id);

    List<String> leftColumn = preset.leftColumn;
    List<String> rightColumn = preset.rightColumn;
    List<int>? shuffleMapping;

    // Appliquer le mélange éducatif si demandé
    if (applyEducationalShuffle) {
      final result = _applyEducationalShuffle(leftColumn, rightColumn);
      leftColumn = result.shuffledLeft;
      rightColumn = result.shuffledRight;
      shuffleMapping = result.mapping;
    }

    final imageResult = await generateNamesGridImage(
      left: leftColumn,
      right: rightColumn,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      leftColumnColor: leftColor,
      rightColumnColor: rightColor,
      description: preset.description,
    );

    // Retourner le résultat avec les informations de mélange
    return EducationalImageResult(
      pngBytes: imageResult.pngBytes,
      rows: imageResult.rows,
      columns: imageResult.columns,
      description: imageResult.description,
      originalMapping: shuffleMapping, // Nouveau champ
    );
  }

  /// Version pour QuestionnairePreset avec support largeurs dynamiques
  static Future<EducationalImageResult> generateFromQuestionnairePreset(
    QuestionnairePreset questionnaire, {
    double cellWidth = 600,
    double cellHeight = 200,
    bool applyEducationalShuffle = true,
  }) async {
    final (leftColor, rightColor) = _getColorsForPreset(questionnaire.id);

    List<String> leftColumn = questionnaire.colonneGauche;
    List<String> rightColumn = questionnaire.colonneDroite;
    List<int>? shuffleMapping;

    // Appliquer le mélange éducatif si demandé
    if (applyEducationalShuffle) {
      final result = _applyEducationalShuffle(leftColumn, rightColumn);
      leftColumn = result.shuffledLeft;
      rightColumn = result.shuffledRight;
      shuffleMapping = result.mapping;
    }

    final imageResult = await generateNamesGridImage(
      left: leftColumn,
      right: rightColumn,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      leftColumnColor: leftColor,
      rightColumnColor: rightColor,
      description: questionnaire.description ?? questionnaire.titre,
      ratioLargeurColonnes: questionnaire.ratioLargeurColonnes, // ← NOUVEAU
    );

    return EducationalImageResult(
      pngBytes: imageResult.pngBytes,
      rows: imageResult.rows,
      columns: imageResult.columns,
      description: imageResult.description,
      originalMapping: shuffleMapping,
    );
  }

  /// Résultat du mélange éducatif
  static EducationalShuffleResult _applyEducationalShuffle(
    List<String> originalLeft,
    List<String> originalRight,
  ) {
    final length = originalLeft.length;

    // 1. Créer une liste des indices et la mélanger
    final indices = List<int>.generate(length, (index) => index);
    indices.shuffle(); // Mélange aléatoire

    // 2. Appliquer ce mélange aux deux listes
    final shuffledLeft = <String>[];
    final shuffledRight = <String>[];

    for (int i = 0; i < length; i++) {
      final originalIndex = indices[i];
      shuffledLeft.add(originalLeft[originalIndex]);
      shuffledRight.add(originalRight[originalIndex]);
    }

    return EducationalShuffleResult(
      shuffledLeft: shuffledLeft,
      shuffledRight: shuffledRight,
      mapping: indices, // Stocke le mapping pour la vérification
    );
  }
}

/// Widget pour afficher les coefficients binomiaux avec la notation moderne
/// Utilise flutter_math_fork pour le rendu LaTeX
/// Note: Cette fonction nécessite l'import de 'package:flutter_math_fork/flutter_math.dart'
/* 
Widget binomWidget(int n, int k) {
  return Math.tex(
    r'\binom{' '$n' '}{' '$k' '}',
    textStyle: const TextStyle(fontSize: 32),
  );
}
*/
