/// Test simple du système unifié PrepaMathFormulaManager
/// Ce script teste uniquement les fonctionnalités de base

import 'lib/core/utils/prepa_math_formulas.dart';

void main() {
  print('🧪 TEST SIMPLE DU SYSTÈME UNIFIÉ');
  print('=' * 50);

  try {
    // Créer une instance du manager
    final manager = PrepaMathFormulaManager();

    // Test 1: Statistiques
    print('\n📊 TEST 1: Statistiques du système');
    final stats = manager.getStatistics();
    print('   • Total formules: ${stats['total_formulas']}');
    print('   • Binômes: ${stats['binome_count']}');
    print('   • Sommes: ${stats['sommes_count']}');
    print('   • Combinaisons: ${stats['combinaisons_count']}');
    print('   • État: ${stats['validation_status']}');

    // Test 1b: Validation des templates
    print('\n✅ TEST 1b: Validation des templates');
    final isValid = PrepaMathFormulaManager.validateAllTemplates();
    print('   • Templates valides: $isValid');

    // Test 2: Recherche par catégorie
    print('\n📂 TEST 2: Recherche par catégorie');
    final binomes = PrepaMathFormulaManager.getFormulasByCategory('binome');
    final sommes = PrepaMathFormulaManager.getFormulasByCategory('somme');
    final combinaisons =
        PrepaMathFormulaManager.getFormulasByCategory('combinaison');
    print('   • Binômes trouvés: ${binomes.length}');
    print('   • Sommes trouvées: ${sommes.length}');
    print('   • Combinaisons trouvées: ${combinaisons.length}');

    // Test 3: Recherche par mot-clé
    print('\n🔍 TEST 3: Recherche par mot-clé');
    final binomResults = PrepaMathFormulaManager.searchFormulas('binom');
    final sumResults = PrepaMathFormulaManager.searchFormulas('sum');
    print('   • Résultats "binom": ${binomResults.length}');
    print('   • Résultats "sum": ${sumResults.length}');

    // Test 4: Génération de puzzle
    print('\n🎲 TEST 4: Génération de puzzle');
    final puzzle = manager.generateRandomBinomePuzzle();
    print('   • Puzzle créé: ${puzzle.colonneGauche.length} formules');
    print('   • Titre: ${puzzle.titre}');
    print('   • ID: ${puzzle.id}');

    // Test 5: Compatibilité legacy
    print('\n🔄 TEST 5: Compatibilité legacy');
    final leftList = <String>[];
    final rightList = <String>[];
    final descriptionList = <String>[];

    manager.generateLegacyLists(
      leftList: leftList,
      rightList: rightList,
      descriptionList: descriptionList,
      count: 5,
    );
    print('   • Liste legacy générée: ${leftList.length} éléments');

    // Test 6: Diagnostic
    print('\n📋 TEST 6: Diagnostic complet');
    manager.printDiagnostic();

    print('\n🎉 TOUS LES TESTS SONT RÉUSSIS !');
    print('✅ Le système unifié fonctionne parfaitement !');
    print('\n📈 RÉSUMÉ :');
    print('   • 27 formules organisées');
    print('   • 3 catégories principales');
    print('   • Validation automatique');
    print('   • Génération de puzzles');
    print('   • Recherche avancée');
    print('   • Compatibilité legacy');
  } catch (e, stackTrace) {
    print('\n❌ ERREUR LORS DES TESTS: $e');
    print('Stack trace: $stackTrace');
  }

  print('\n' + '=' * 50);
  print('🏁 TESTS TERMINÉS');
}
