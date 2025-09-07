/// <cursor>
///
/// EXEMPLE DE MIGRATION DE FORMULES
///
/// Exemple de migration d'une formule existante vers le nouveau système.
/// Montre comment convertir une formule du système actuel vers FormulaTemplate.
/// Compatible avec le système LaTeX et puzzle existant.
///
/// COMPOSANTS PRINCIPAUX:
/// - MigrationExample: Exemple de migration
/// - FormulaConverter: Utilitaire de conversion
/// - TemplateBuilder: Constructeur de templates
///
/// ÉTAT ACTUEL:
/// - Exemple de migration d'une formule d'addition
/// - Conversion vers le nouveau système
/// - Compatibilité avec l'existant
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU - Création de l'exemple de migration
/// - Démonstration de la compatibilité
///
/// 🔧 POINTS D'ATTENTION:
/// - Rétrocompatibilité avec le système existant
/// - Migration progressive des formules
/// - Tests de validation
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Migration de toutes les formules existantes
/// - Intégration avec les moteurs de quiz
/// - Tests complets
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/education/formula_template.dart: Template étendu
/// - lib/core/education/educational_levels.dart: Niveaux éducatifs
/// - lib/core/operations/numerical_skills_engine.dart: Moteur existant
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'educational_levels.dart';
import 'formula_template.dart';

/// Exemple de migration d'une formule d'addition
class MigrationExample {
  /// Exemple de formule d'addition simple (système actuel)
  static Map<String, dynamic> createAdditionFormulaOld() {
    return {
      'operationType': 'addition',
      'latexPattern': '{VAR:a} + {VAR:b} = ?',
      'calculateResult': (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        return a + b;
      },
      'difficulty': 1,
    };
  }

  /// Migration vers le nouveau système
  static FormulaTemplate createAdditionFormulaNew() {
    return FormulaTemplate(
      fid: 'ADD_001', // ID existant
      code: FormulaCode(
        code: 'ADD_001',
        structure: 'a + b',
        description: 'Addition simple de deux nombres',
      ),
      structure: 'a + b',
      minLevel: 1, // CP minimum
      parameters: {
        'a': ParameterDefinition(
          name: 'a',
          description: 'Premier nombre',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
        'b': ParameterDefinition(
          name: 'b',
          description: 'Deuxième nombre',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
      },
      latexPattern: '{VAR:a} + {VAR:b} = ?',
      calculateResult: (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        return a + b;
      },
      difficulty: 1,
      operationType: 'addition',
    );
  }

  /// Exemple de formule de multiplication (système actuel)
  static Map<String, dynamic> createMultiplicationFormulaOld() {
    return {
      'operationType': 'multiplication',
      'latexPattern': '{VAR:a} \\times {VAR:b} = ?',
      'calculateResult': (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        return a * b;
      },
      'difficulty': 2,
    };
  }

  /// Migration vers le nouveau système
  static FormulaTemplate createMultiplicationFormulaNew() {
    return FormulaTemplate(
      fid: 'MUL_001',
      code: FormulaCode(
        code: 'MUL_001',
        structure: 'a × b',
        description: 'Multiplication de deux nombres',
      ),
      structure: 'a × b',
      minLevel: 3, // CE2 minimum
      parameters: {
        'a': ParameterDefinition(
          name: 'a',
          description: 'Premier facteur',
          defaultRange: ValueRange(min: 1, max: 20, description: 'Nombres jusqu\'à 20'),
        ),
        'b': ParameterDefinition(
          name: 'b',
          description: 'Deuxième facteur',
          defaultRange: ValueRange(min: 1, max: 20, description: 'Nombres jusqu\'à 20'),
        ),
      },
      latexPattern: '{VAR:a} \\times {VAR:b} = ?',
      calculateResult: (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        return a * b;
      },
      difficulty: 2,
      operationType: 'multiplication',
    );
  }

  /// Exemple de formule de fraction (système actuel)
  static Map<String, dynamic> createFractionFormulaOld() {
    return {
      'operationType': 'somme_fractions',
      'latexPattern': '\\frac{{VAR:a}}{{VAR:b}} + \\frac{{VAR:c}}{{VAR:d}} = ?',
      'calculateResult': (Map<String, dynamic> params) {
        // Logique de calcul des fractions (simplifiée)
        final a = params['a'] as int;
        final b = params['b'] as int;
        final c = params['c'] as int;
        final d = params['d'] as int;
        // Calcul simplifié pour l'exemple
        return (a * d + c * b) / (b * d);
      },
      'difficulty': 4,
    };
  }

  /// Migration vers le nouveau système
  static FormulaTemplate createFractionFormulaNew() {
    return FormulaTemplate(
      fid: 'FRAC_001',
      code: FormulaCode(
        code: 'FRAC_001',
        structure: 'a/b + c/d',
        description: 'Somme de deux fractions',
      ),
      structure: 'a/b + c/d',
      minLevel: 6, // 6ème minimum
      parameters: {
        'a': ParameterDefinition(
          name: 'a',
          description: 'Numérateur première fraction',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
        'b': ParameterDefinition(
          name: 'b',
          description: 'Dénominateur première fraction',
          defaultRange: ValueRange(min: 2, max: 10, description: 'Dénominateurs simples'),
        ),
        'c': ParameterDefinition(
          name: 'c',
          description: 'Numérateur deuxième fraction',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
        'd': ParameterDefinition(
          name: 'd',
          description: 'Dénominateur deuxième fraction',
          defaultRange: ValueRange(min: 2, max: 10, description: 'Dénominateurs simples'),
        ),
      },
      latexPattern: '\\frac{{VAR:a}}{{VAR:b}} + \\frac{{VAR:c}}{{VAR:d}} = ?',
      calculateResult: (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        final c = params['c'] as int;
        final d = params['d'] as int;
        return (a * d + c * b) / (b * d);
      },
      difficulty: 4,
      operationType: 'somme_fractions',
    );
  }
}

/// Utilitaire pour convertir les formules existantes
class FormulaConverter {
  /// Convertit une formule du système actuel vers le nouveau
  static FormulaTemplate convertFromOldSystem(
    Map<String, dynamic> oldFormula,
    String fid,
    int minLevel,
  ) {
    return FormulaTemplate(
      fid: fid,
      code: FormulaCode(
        code: fid,
        structure: _extractStructure(oldFormula),
        description: _generateDescription(oldFormula),
      ),
      structure: _extractStructure(oldFormula),
      minLevel: minLevel,
      parameters: _extractParameters(oldFormula),
      latexPattern: oldFormula['latexPattern'] as String,
      calculateResult: oldFormula['calculateResult'] as Function,
      difficulty: oldFormula['difficulty'] as int,
      operationType: oldFormula['operationType'] as String,
    );
  }

  /// Extrait la structure du calcul
  static String _extractStructure(Map<String, dynamic> formula) {
    final latexPattern = formula['latexPattern'] as String;
    // Extraction simplifiée - à améliorer selon les besoins
    return latexPattern.replaceAll('{VAR:', '').replaceAll('}', '').replaceAll(' = ?', '');
  }

  /// Génère une description basée sur le type d'opération
  static String _generateDescription(Map<String, dynamic> formula) {
    final operationType = formula['operationType'] as String;
    switch (operationType) {
      case 'addition':
        return 'Addition de deux nombres';
      case 'multiplication':
        return 'Multiplication de deux nombres';
      case 'somme_fractions':
        return 'Somme de deux fractions';
      default:
        return 'Opération mathématique';
    }
  }

  /// Extrait les paramètres de la formule
  static Map<String, ParameterDefinition> _extractParameters(Map<String, dynamic> formula) {
    final parameters = <String, ParameterDefinition>{};
    final latexPattern = formula['latexPattern'] as String;
    
    // Extraction des paramètres du pattern LaTeX
    final regex = RegExp(r'\{VAR:(\w+)\}');
    final matches = regex.allMatches(latexPattern);
    
    for (final match in matches) {
      final paramName = match.group(1)!;
      parameters[paramName] = ParameterDefinition(
        name: paramName,
        description: 'Paramètre $paramName',
        defaultRange: ValueRange(min: 1, max: 10, description: 'Valeur par défaut'),
      );
    }
    
    return parameters;
  }
}

/// Constructeur de templates pour faciliter la création
class TemplateBuilder {
  static FormulaTemplate buildAddition(int minLevel) {
    return FormulaTemplate(
      fid: 'ADD_${minLevel.toString().padLeft(3, '0')}',
      code: FormulaCode(
        code: 'ADD_${minLevel.toString().padLeft(3, '0')}',
        structure: 'a + b',
        description: 'Addition niveau $minLevel',
      ),
      structure: 'a + b',
      minLevel: minLevel,
      parameters: {
        'a': ParameterDefinition(
          name: 'a',
          description: 'Premier nombre',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
        'b': ParameterDefinition(
          name: 'b',
          description: 'Deuxième nombre',
          defaultRange: ValueRange(min: 1, max: 10, description: 'Nombres simples'),
        ),
      },
      latexPattern: '{VAR:a} + {VAR:b} = ?',
      calculateResult: (Map<String, dynamic> params) {
        final a = params['a'] as int;
        final b = params['b'] as int;
        return a + b;
      },
      difficulty: 1,
      operationType: 'addition',
    );
  }
}
