/// <cursor>
///
/// TEMPLATE DE FORMULES ÉTENDU
///
/// Extension du système de formules existant avec support des niveaux éducatifs.
/// Compatible avec le système LaTeX et puzzle actuel.
/// Ajoute minLevel et parameters pour la génération adaptative.
///
/// COMPOSANTS PRINCIPAUX:
/// - FormulaTemplate: Template étendu avec minLevel et parameters
/// - FormulaCode: Codes de référence pour les formules
/// - ParameterDefinition: Définition des paramètres
/// - EducationalLevelManager: Gestion des niveaux éducatifs
///
/// ÉTAT ACTUEL:
/// - Structure compatible avec le système existant
/// - Support des 14 niveaux éducatifs
/// - Intervalles de valeurs par paramètre
/// - Codes de référence pour traçabilité
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU - Création du template étendu
/// - Compatibilité avec LaTeX et puzzle existants
/// - Support des niveaux éducatifs français
///
/// 🔧 POINTS D'ATTENTION:
/// - Rétrocompatibilité avec le système existant
/// - Migration progressive des formules
/// - Gestion des paramètres par niveau
/// - Codes de référence uniques
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Migration des formules existantes
/// - Intégration avec les moteurs de quiz
/// - Tests sur tous les niveaux
/// - Ajout de nouvelles formules
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/education/educational_levels.dart: Niveaux éducatifs
/// - lib/core/formulas/prepa_math_engine.dart: Moteur existant
/// - lib/core/operations/numerical_skills_engine.dart: Moteur numérique
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (5/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math' as math;
import 'educational_levels.dart';

/// Code de référence pour une formule
class FormulaCode {
  final String code; // Code unique (ex: "ADD_001", "MUL_002")
  final String structure; // Structure du calcul (ex: "a + b", "a * b")
  final String description; // Description de la formule

  const FormulaCode({
    required this.code,
    required this.structure,
    required this.description,
  });

  @override
  String toString() => code;
}

/// Définition d'un paramètre de formule
class ParameterDefinition {
  final String name; // Nom du paramètre (ex: "a", "b", "c")
  final String description; // Description du paramètre
  final ValueRange defaultRange; // Intervalle par défaut
  final bool required; // Paramètre obligatoire

  const ParameterDefinition({
    required this.name,
    required this.description,
    required this.defaultRange,
    this.required = true,
  });
}

/// Template de formule étendu avec support des niveaux éducatifs
class FormulaTemplate {
  final String fid; // ID existant (rétrocompatibilité)
  final FormulaCode code; // Code de référence
  final String structure; // Structure du calcul
  final int minLevel; // Niveau minimum requis
  final Map<String, ParameterDefinition> parameters; // Définition des paramètres
  final String latexPattern; // Pattern LaTeX existant
  final Function calculateResult; // Fonction de calcul existante
  final int difficulty; // Difficulté existante (1-5)
  final String operationType; // Type d'opération existant

  const FormulaTemplate({
    required this.fid,
    required this.code,
    required this.structure,
    required this.minLevel,
    required this.parameters,
    required this.latexPattern,
    required this.calculateResult,
    required this.difficulty,
    required this.operationType,
  });

  /// Vérifie si la formule est adaptée à un niveau donné
  bool isAdaptedToLevel(NiveauEducatif niveau) {
    return niveau.niveau >= minLevel;
  }

  /// Obtient l'intervalle de valeurs pour un paramètre à un niveau donné
  ValueRange? getParameterRange(NiveauEducatif niveau, String parameterName) {
    // D'abord, essayer d'obtenir l'intervalle spécifique au niveau
    final levelRange = EducationalLevelManager.getParameterRange(niveau, parameterName);
    if (levelRange != null) return levelRange;

    // Sinon, utiliser l'intervalle par défaut du paramètre
    final paramDef = parameters[parameterName];
    if (paramDef != null) return paramDef.defaultRange;

    return null;
  }

  /// Génère des paramètres adaptés à un niveau donné
  Map<String, dynamic> generateParametersForLevel(NiveauEducatif niveau, math.Random random) {
    final params = <String, dynamic>{};
    
    for (final paramName in parameters.keys) {
      final range = getParameterRange(niveau, paramName);
      if (range != null) {
        params[paramName] = range.generateRandomValue(random);
      } else {
        // Fallback: valeur par défaut
        params[paramName] = 1 + random.nextInt(10);
      }
    }
    
    return params;
  }

  /// Génère le LaTeX pour un niveau donné
  String generateLatexForLevel(NiveauEducatif niveau, math.Random random) {
    final params = generateParametersForLevel(niveau, random);
    String latex = latexPattern;
    
    for (final entry in params.entries) {
      final value = entry.value;
      String valueStr;
      if (value is int) {
        valueStr = value.toString();
      } else if (value is double) {
        valueStr = value.toString();
      } else {
        valueStr = value.toString();
      }
      latex = latex.replaceAll('{VAR:${entry.key}}', valueStr);
    }
    
    return latex;
  }

  /// Calcule le résultat pour un niveau donné
  dynamic calculateResultForLevel(NiveauEducatif niveau, math.Random random) {
    final params = generateParametersForLevel(niveau, random);
    return calculateResult(params);
  }

  /// Obtient tous les niveaux supportés par cette formule
  List<NiveauEducatif> getSupportedLevels() {
    return NiveauEducatif.values.where((niveau) => 
      niveau.niveau >= minLevel
    ).toList();
  }

  /// Obtient la difficulté adaptée à un niveau
  int getDifficultyForLevel(NiveauEducatif niveau) {
    // Ajuster la difficulté selon le niveau
    final baseDifficulty = difficulty;
    final levelAdjustment = (niveau.niveau - minLevel) * 0.5;
    return (baseDifficulty + levelAdjustment).round().clamp(1, 5);
  }

  @override
  String toString() => 'FormulaTemplate(${code.code}, minLevel: $minLevel)';
}

/// Gestionnaire des templates de formules
class FormulaTemplateManager {
  static final Map<String, FormulaTemplate> _templates = {};

  /// Enregistre un template de formule
  static void registerTemplate(FormulaTemplate template) {
    _templates[template.fid] = template;
  }

  /// Obtient un template par son FID
  static FormulaTemplate? getTemplate(String fid) {
    return _templates[fid];
  }

  /// Obtient tous les templates adaptés à un niveau
  static List<FormulaTemplate> getTemplatesForLevel(NiveauEducatif niveau) {
    return _templates.values.where((template) => 
      template.isAdaptedToLevel(niveau)
    ).toList();
  }

  /// Obtient les templates par type d'opération et niveau
  static List<FormulaTemplate> getTemplatesByTypeAndLevel(
    String operationType, 
    NiveauEducatif niveau
  ) {
    return _templates.values.where((template) => 
      template.operationType == operationType && 
      template.isAdaptedToLevel(niveau)
    ).toList();
  }

  /// Obtient tous les templates enregistrés
  static List<FormulaTemplate> getAllTemplates() {
    return _templates.values.toList();
  }

  /// Obtient le nombre de templates enregistrés
  static int getTemplateCount() {
    return _templates.length;
  }

  /// Obtient les statistiques par niveau
  static Map<NiveauEducatif, int> getStatisticsByLevel() {
    final stats = <NiveauEducatif, int>{};
    
    for (final niveau in NiveauEducatif.values) {
      stats[niveau] = getTemplatesForLevel(niveau).length;
    }
    
    return stats;
  }
}
