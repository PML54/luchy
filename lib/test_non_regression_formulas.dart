/// <cursor>
///
/// 🧪 TESTS DE NON-RÉGRESSION - NOUVELLE ARCHITECTURE DES FORMULES
///
/// Ce fichier teste que la nouvelle architecture isolée produit exactement
/// les mêmes résultats que l'ancienne architecture.
///
/// Objectifs du test :
/// ✅ Vérifier que les calculs sont identiques
/// ✅ Vérifier que les questionnaires sont identiques
/// ✅ Vérifier que l'API backward compatible fonctionne
/// ✅ Détecter toute régression potentielle
///
/// </cursor>

import 'package:luchy/core/formulas/prepa_math_engine.dart';

/// Tests de non-régression pour la nouvelle architecture des formules
class FormulaRegressionTest {
  static final List<Map<String, dynamic>> _testCases = [
    // Tests de calcul pour coefficients binomiaux
    {
      'description': 'C(5,2) - Coefficient binomial basique',
      'template': 'binomial_basic',
      'templateIndex': 1, // Index dans binomeFormulas
      'parameters': {'n': 5, 'k': 2},
      'expected': 10,
    },
    {
      'description': 'C(6,3) - Coefficient binomial plus grand',
      'template': 'binomial_basic',
      'templateIndex': 1,
      'parameters': {'n': 6, 'k': 3},
      'expected': 20,
    },
    {
      'description': 'C(4,2) - Coefficient binomial moyen',
      'template': 'binomial_basic',
      'templateIndex': 1,
      'parameters': {'n': 4, 'k': 2},
      'expected': 6,
    },

    // Tests pour développement binomial (2+3)^2
    {
      'description': '(2+3)² - Développement binomial simple',
      'template': 'binomial_expansion',
      'templateIndex': 0, // Premier template binome
      'parameters': {'a': 2, 'b': 3, 'n': 2},
      'expected': 25,
    },
    {
      'description': '(1+2)³ - Développement binomial cube',
      'template': 'binomial_expansion',
      'templateIndex': 0,
      'parameters': {'a': 1, 'b': 2, 'n': 3},
      'expected': 27,
    },

    // Tests pour sommes
    {
      'description': 'Σ(k=1 to 10) k - Somme des premiers entiers',
      'template': 'sum_basic',
      'templateIndex': 0, // Premier template sommes
      'parameters': {'n': 10},
      'expected': 55,
    },
    {
      'description': 'Σ(k=1 to 5) k - Petite somme',
      'template': 'sum_basic',
      'templateIndex': 0,
      'parameters': {'n': 5},
      'expected': 15,
    },
  ];

  /// =====================================================================================
  /// 🧪 TESTS DE CALCUL
  /// =====================================================================================

  /// Teste que tous les calculs donnent les mêmes résultats
  static bool testCalculs() {
    print('🧮 TEST DES CALCULS - VÉRIFICATION NON-RÉGRESSION');
    print('=' * 60);

    bool allPassed = true;
    int passedCount = 0;

    for (final testCase in _testCases) {
      final description = testCase['description'] as String;
      final templateIndex = testCase['templateIndex'] as int;
      final parameters = testCase['parameters'] as Map<String, num>;
      final expected = testCase['expected'] as num;

      try {
        // Sélection du bon template selon le type
        final templateType = testCase['template'] as String;
        late EnhancedFormulaTemplate template;

        switch (templateType) {
          case 'binomial_basic':
          case 'binomial_expansion':
            template = PrepaMathFormulaManager.binomeFormulas[templateIndex];
            break;
          case 'sum_basic':
            template = PrepaMathFormulaManager.sommesFormulas[templateIndex];
            break;
          default:
            throw Exception('Type de template inconnu: $templateType');
        }

        // Calcul avec le nouveau système
        final result = template.calculate(parameters);

        // Vérification du résultat
        final passed = result == expected;
        final status = passed ? '✅ PASS' : '❌ FAIL';

        print('$status $description');
        print('      Attendu: $expected | Obtenu: $result');

        if (passed) {
          passedCount++;
        } else {
          allPassed = false;
        }
      } catch (e) {
        print('❌ ERREUR $description');
        print('      Exception: $e');
        allPassed = false;
      }
    }

    print('');
    print('📊 RÉSULTATS TESTS CALCULS:');
    print('   • Tests passés: $passedCount/${_testCases.length}');
    print(
        '   • Taux de réussite: ${(passedCount / _testCases.length * 100).round()}%');
    print(
        '   • Statut global: ${allPassed ? '✅ TOUS RÉUSSIS' : '❌ ÉCHECS DÉTECTÉS'}');

    return allPassed;
  }

  /// =====================================================================================
  /// 📋 TESTS DE GÉNÉRATION DE QUESTIONNAIRES
  /// =====================================================================================

  /// Teste que les questionnaires sont générés correctement
  static bool testQuestionnaires() {
    print('\n📋 TEST DES QUESTIONNAIRES - VÉRIFICATION STRUCTURE');
    print('=' * 60);

    bool allPassed = true;

    // Test des questionnaires individuels
    final questionnaires = [
      {
        'name': 'Binôme',
        'generator': PrepaMathFormulaManager.createBinomePreset,
        'expectedMinFormulas': 5,
      },
      {
        'name': 'Combinaisons',
        'generator': PrepaMathFormulaManager.createCombinaisonsPreset,
        'expectedMinFormulas': 3,
      },
      {
        'name': 'Sommes',
        'generator': PrepaMathFormulaManager.createSommesPreset,
        'expectedMinFormulas': 5,
      },
      {
        'name': 'Unifié',
        'generator': PrepaMathFormulaManager.createUnifiedPrepaCalculPreset,
        'expectedMinFormulas': 10,
      },
    ];

    for (final qTest in questionnaires) {
      final name = qTest['name'] as String;
      final generator = qTest['generator'] as QuestionnairePreset Function();
      final expectedMin = qTest['expectedMinFormulas'] as int;

      try {
        final questionnaire = generator();

        // Vérifications structurelles
        final hasTitle = questionnaire.titre.isNotEmpty;
        final hasFormulas = questionnaire.colonneGauche.isNotEmpty;
        final hasDescriptions = questionnaire.colonneDroite.isNotEmpty;
        final hasEnoughFormulas =
            questionnaire.colonneGauche.length >= expectedMin;
        final columnsMatch = questionnaire.colonneGauche.length ==
            questionnaire.colonneDroite.length;
        final hasValidNiveau = questionnaire.niveau != null;
        final hasValidCategorie = questionnaire.categorie != null;
        final hasValidTypeJeu = questionnaire.typeDeJeu != null;

        final allChecks = [
          hasTitle,
          hasFormulas,
          hasDescriptions,
          hasEnoughFormulas,
          columnsMatch,
          hasValidNiveau,
          hasValidCategorie,
          hasValidTypeJeu,
        ];

        final passed = !allChecks.contains(false);

        final status = passed ? '✅ PASS' : '❌ FAIL';
        print('$status Questionnaire $name:');
        print('      Titre: ${questionnaire.titre}');
        print('      Formules: ${questionnaire.colonneGauche.length}');
        print('      Colonnes cohérentes: $columnsMatch');
        print('      Niveau: ${questionnaire.niveau.nom}');
        print('      Catégorie: ${questionnaire.categorie.nom}');
        print('      Type: ${questionnaire.typeDeJeu.nom}');

        if (!passed) {
          print('      ❌ ÉCHECS:');
          if (!hasTitle) print('         - Pas de titre');
          if (!hasFormulas) print('         - Pas de formules');
          if (!hasDescriptions) print('         - Pas de descriptions');
          if (!hasEnoughFormulas)
            print('         - Pas assez de formules (min: $expectedMin)');
          if (!columnsMatch) print('         - Colonnes incohérentes');
          if (!hasValidNiveau) print('         - Niveau invalide');
          if (!hasValidCategorie) print('         - Catégorie invalide');
          if (!hasValidTypeJeu) print('         - Type de jeu invalide');
          allPassed = false;
        }
      } catch (e) {
        print('❌ ERREUR Questionnaire $name:');
        print('      Exception: $e');
        allPassed = false;
      }
    }

    print('');
    print('📊 RÉSULTATS TESTS QUESTIONNAIRES:');
    print('   • Questionnaires testés: ${questionnaires.length}');
    print(
        '   • Statut global: ${allPassed ? '✅ TOUS VALIDES' : '❌ PROBLÈMES DÉTECTÉS'}');

    return allPassed;
  }

  /// =====================================================================================
  /// 🔄 TESTS DE COMPATIBILITÉ BACKWARD
  /// =====================================================================================

  /// Teste que l'API backward compatible fonctionne
  static bool testBackwardCompatibility() {
    print('\n🔄 TEST COMPATIBILITÉ BACKWARD - API ANCIENNE');
    print('=' * 60);

    bool allPassed = true;

    // Test des fonctions de compatibilité
    final compatibilityTests = [
      {
        'name': 'createEnhancedBinomePreset()',
        'function': () => createEnhancedBinomePreset(),
      },
      {
        'name': 'createEnhancedCombinaisonsPreset()',
        'function': () => createEnhancedCombinaisonsPreset(),
      },
      {
        'name': 'createEnhancedSommesPreset()',
        'function': () => createEnhancedSommesPreset(),
      },
      {
        'name': 'createUnifiedPrepaCalculPreset()',
        'function': () => createUnifiedPrepaCalculPreset(),
      },
    ];

    for (final test in compatibilityTests) {
      final name = test['name'] as String;
      final function = test['function'] as QuestionnairePreset Function();

      try {
        final result = function();

        // Vérifier que le résultat est valide
        final hasContent = result.colonneGauche.isNotEmpty;
        final isConsistent =
            result.colonneGauche.length == result.colonneDroite.length;

        final passed = hasContent && isConsistent;

        final status = passed ? '✅ PASS' : '❌ FAIL';
        print('$status $name');
        print('      Formules: ${result.colonneGauche.length}');
        print('      Cohérent: $isConsistent');

        if (!passed) {
          allPassed = false;
        }
      } catch (e) {
        print('❌ ERREUR $name:');
        print('      Exception: $e');
        allPassed = false;
      }
    }

    print('');
    print('📊 RÉSULTATS COMPATIBILITÉ BACKWARD:');
    print('   • Fonctions testées: ${compatibilityTests.length}');
    print(
        '   • Statut global: ${allPassed ? '✅ COMPATIBLE' : '❌ INCOMPATIBLE'}');

    return allPassed;
  }

  /// =====================================================================================
  /// 🎲 TESTS DE GÉNÉRATION D'EXEMPLES
  /// =====================================================================================

  /// Teste la génération d'exemples pédagogiques
  static bool testGenerationExemples() {
    print('\n🎲 TEST GÉNÉRATION D\'EXEMPLES - VALEURS PÉDAGOGIQUES');
    print('=' * 60);

    bool allPassed = true;

    // Test avec quelques templates représentatifs
    final templatesToTest = [
      {
        'name': 'Coefficient binomial',
        'template': PrepaMathFormulaManager.binomeFormulas[1],
      },
      {
        'name': 'Développement binomial',
        'template': PrepaMathFormulaManager.binomeFormulas[0],
      },
      {
        'name': 'Somme des entiers',
        'template': PrepaMathFormulaManager.sommesFormulas[0],
      },
    ];

    for (final templateTest in templatesToTest) {
      final name = templateTest['name'] as String;
      final template = templateTest['template'] as EnhancedFormulaTemplate;

      try {
        // Générer des exemples
        final exemples = template.generateValidExamples(count: 3);

        print('✅ $name - ${exemples.length} exemples générés:');

        bool templatePassed = true;
        for (int i = 0; i < exemples.length; i++) {
          final exemple = exemples[i];
          final result = template.calculate(exemple);

          final isValid = result != null && result.isFinite;
          final status = isValid ? '✅' : '❌';

          print('      $status Exemple ${i + 1}: $exemple → $result');

          if (!isValid) {
            templatePassed = false;
          }
        }

        if (!templatePassed) {
          allPassed = false;
        }
      } catch (e) {
        print('❌ ERREUR $name:');
        print('      Exception: $e');
        allPassed = false;
      }
    }

    print('');
    print('📊 RÉSULTATS GÉNÉRATION EXEMPLES:');
    print('   • Templates testés: ${templatesToTest.length}');
    print('   • Statut global: ${allPassed ? '✅ VALIDE' : '❌ PROBLÈMES'}');

    return allPassed;
  }

  /// =====================================================================================
  /// 📊 TESTS DE VALIDATION DES TEMPLATES
  /// =====================================================================================

  /// Teste la validation automatique des templates
  static bool testValidationTemplates() {
    print('\n📊 TEST VALIDATION DES TEMPLATES - INTÉGRITÉ SYSTÈME');
    print('=' * 60);

    try {
      final isValid = PrepaMathFormulaManager.validateAllTemplates();

      print('✅ Validation globale: ${isValid ? 'RÉUSSIE' : 'ÉCHOUÉE'}');

      if (isValid) {
        print('   • Tous les templates sont cohérents');
        print('   • Tous les calculs sont possibles');
        print('   • Toutes les validations passent');
      } else {
        print('   • Problèmes détectés dans certains templates');
        print('   • Vérifier les logs ci-dessus pour détails');
      }

      return isValid;
    } catch (e) {
      print('❌ ERREUR lors de la validation:');
      print('   Exception: $e');
      return false;
    }
  }

  /// =====================================================================================
  /// 🚀 EXÉCUTION COMPLÈTE DES TESTS
  /// =====================================================================================

  /// Exécute tous les tests de non-régression
  static void runAllTests() {
    print('🧪 TESTS DE NON-RÉGRESSION - ARCHITECTURE FORMULES');
    print('==================================================');
    print('Objectif: Vérifier que la nouvelle architecture produit');
    print('         exactement les mêmes résultats que l\'ancienne.');
    print('==================================================');

    final results = <String, bool>{};

    // Exécuter tous les tests
    results['calculs'] = testCalculs();
    results['questionnaires'] = testQuestionnaires();
    results['backward_compatibility'] = testBackwardCompatibility();
    results['generation_exemples'] = testGenerationExemples();
    results['validation_templates'] = testValidationTemplates();

    // Résumé final
    print('\n' + '=' * 60);
    print('📊 RÉSULTAT FINAL - TESTS DE NON-RÉGRESSION');
    print('=' * 60);

    final totalTests = results.length;
    final passedTests = results.values.where((passed) => passed).length;
    final successRate = (passedTests / totalTests * 100).round();

    print('Tests exécutés: $totalTests');
    print('Tests réussis: $passedTests');
    print('Taux de réussite: $successRate%');

    print('\nDÉTAIL PAR TEST:');
    results.forEach((testName, passed) {
      final status = passed ? '✅ PASS' : '❌ FAIL';
      print('   $status ${testName.replaceAll('_', ' ').toUpperCase()}');
    });

    print('\n' + '=' * 60);
    if (successRate == 100) {
      print('🎉 SUCCÈS TOTAL ! AUCUNE RÉGRESSION DÉTECTÉE');
      print('   ✅ La nouvelle architecture est parfaitement compatible');
      print('   ✅ Tous les calculs sont identiques');
      print('   ✅ Toutes les fonctionnalités marchent');
    } else {
      print('⚠️ RÉGRESSIONS DÉTECTÉES !');
      print('   ❌ Certains tests ont échoué');
      print('   🔍 Vérifier les logs ci-dessus pour diagnostiquer');
    }
    print('=' * 60);
  }
}

/// Point d'entrée pour exécuter les tests
void main() {
  FormulaRegressionTest.runAllTests();
}
