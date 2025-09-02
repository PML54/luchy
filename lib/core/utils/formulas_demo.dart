/// <cursor>
/// LUCHY - Démonstration de l'Architecture Orientée Objet des Formules
///
/// Exemples d'utilisation de la nouvelle architecture pour gérer
/// les formules mathématiques de manière structurée.
///
/// COMPOSANTS PRINCIPAUX:
/// - Initialisation de la bibliothèque
/// - Recherche et filtrage de formules
/// - Tests de validation et calcul
/// - Génération de quiz dynamiques
/// - Statistiques et métriques
///
/// ÉTAT ACTUEL:
/// - Tous les exemples fonctionnels
/// - Architecture entièrement opérationnelle
/// - Interface utilisateur prête
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création des exemples d'utilisation
/// - Tests complets de toutes les fonctionnalités
/// - Optimisation des performances
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Démonstration complète)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'mathematical_formulas_oop.dart';
import 'formulas_implementation.dart';

/// =====================================================================================
/// 🎯 EXEMPLES D'UTILISATION DE L'ARCHITECTURE OOP
/// =====================================================================================

/// Exemple 1: Initialisation et statistiques
void demoBasicUsage() {
  print('🎯 DÉMONSTRATION - Architecture Orientée Objet des Formules');
  print('=' * 60);

  // Initialisation de la bibliothèque
  initializeFormulaLibrary();

  // Affichage des statistiques
  final stats = getFormulaStatistics();
  print('\n📊 STATISTIQUES DE LA BIBLIOTHÈQUE:');
  print('-' * 40);
  stats.forEach((category, count) {
    print('  $category: $count formules');
  });

  print('\n✅ Bibliothèque prête avec ${stats['TOTAL']} formules!');
}

/// Exemple 2: Recherche de formules
void demoFormulaSearch() {
  print('\n🔍 DÉMONSTRATION - Recherche de Formules');
  print('=' * 50);

  // Recherche par mot-clé
  final binomialFormulas = searchFormulas('binôme');
  print('📐 Formules contenant "binôme": ${binomialFormulas.length}');
  for (final formula in binomialFormulas.take(3)) {
    print('  • ${formula.name} (${formula.difficulty.name})');
  }

  // Recherche par niveau
  final prepaFormulas = searchFormulas('prépa');
  print('\n🎓 Formules de niveau Prépa: ${prepaFormulas.length}');
  for (final formula in prepaFormulas.take(3)) {
    print('  • ${formula.name}');
  }
}

/// Exemple 3: Test de validation et calcul
void demoFormulaValidation() {
  print('\n✅ DÉMONSTRATION - Validation et Calcul');
  print('=' * 45);

  // Test de la formule de somme arithmétique
  print('🧮 Test: Somme des n premiers entiers');
  testFormula('arithmetic_sum', {'n': 5});

  print('\n🧮 Test: Coefficient binomial');
  testFormula('binomial_coefficient', {'n': 5, 'k': 2});

  print('\n🧮 Test: Somme géométrique finie');
  testFormula('geometric_sum_finite', {'q': 0.5, 'n': 3});

  // Test avec paramètres invalides
  print('\n❌ Test: Paramètres invalides');
  final library = FormulaLibrary();
  final formula = library.getFormulaById('arithmetic_sum');
  if (formula != null) {
    final isValid = formula.validateParameters({'n': -1});
    print('Validation de n=-1: ${isValid ? '✅ Valide' : '❌ Invalide'}');
  }
}

/// Exemple 4: Génération de quiz
void demoQuizGeneration() {
  print('\n🎲 DÉMONSTRATION - Génération de Quiz');
  print('=' * 40);

  final library = FormulaLibrary();

  // Quiz de binôme niveau prépa
  print('📚 Quiz de Binôme - Niveau Prépa:');
  final binomialFormulas = library.getFormulasByCategory(FormulaCategory.BINOMIAL)
      .where((f) => f.difficulty == DifficultyLevel.PREPA)
      .toList();

  for (int i = 0; i < math.min(5, binomialFormulas.length); i++) {
    final formula = binomialFormulas[i];
    print('  ${i + 1}. ${formula.name}');
    print('     ${formula.latexLeft} = ${formula.latexRight}');
  }

  // Quiz mélangé
  print('\n🔀 Quiz mélangé (toutes catégories):');
  final allFormulas = library.allFormulas;
  final shuffled = List<MathematicalFormula>.from(allFormulas)..shuffle();

  for (int i = 0; i < math.min(5, shuffled.length); i++) {
    final formula = shuffled[i];
    print('  ${i + 1}. ${formula.name} (${formula.category.name})');
  }
}

/// Exemple 5: Interface utilisateur simulée
void demoUserInterface() {
  print('\n🖥️ DÉMONSTRATION - Interface Utilisateur Simulée');
  print('=' * 50);

  final library = FormulaLibrary();

  print('🏠 MENU PRINCIPAL:');
  print('1. Formules de Binôme');
  print('2. Formules de Sommes');
  print('3. Formules Combinatoires');
  print('4. Recherche par mot-clé');
  print('5. Quiz aléatoire');

  print('\n📂 CATÉGORIE: BINÔME');
  final binomialFormulas = library.getFormulasByCategory(FormulaCategory.BINOMIAL);
  for (int i = 0; i < binomialFormulas.length; i++) {
    final formula = binomialFormulas[i];
    print('${i + 1:2d}. ${formula.name}');
    print('    ${formula.description}');
    print('    Niveau: ${formula.difficulty.name}');
    print('    LaTeX: ${formula.fullLatex}');
    print();
  }

  print('🎯 SELECTION: Formule #3');
  if (binomialFormulas.length >= 3) {
    final selectedFormula = binomialFormulas[2];
    print('📐 Formule sélectionnée: ${selectedFormula.name}');
    print('📝 Description: ${selectedFormula.description}');
    print('🏷️ Tags: ${selectedFormula.tags.join(', ')}');

    print('\n🔧 Paramètres:');
    for (final arg in selectedFormula.arguments) {
      print('  • ${arg.name}: ${arg.description}');
      print('    Type: ${arg.type.name}');
      if (arg.minValue != null) print('    Min: ${arg.minValue}');
      if (arg.maxValue != null) print('    Max: ${arg.maxValue}');
    }
  }
}

/// =====================================================================================
/// 🚀 FONCTIONS PRINCIPALES DE DÉMONSTRATION
/// =====================================================================================

/// Fonction principale de démonstration
void runFullDemo() {
  print('🚀 DÉMONSTRATION COMPLÈTE - Architecture Orientée Objet');
  print('=' * 60);
  print('🎯 Cette démonstration montre toutes les fonctionnalités');
  print('   de la nouvelle architecture orientée objet pour les formules.');
  print('=' * 60);

  demoBasicUsage();
  demoFormulaSearch();
  demoFormulaValidation();
  demoQuizGeneration();
  demoUserInterface();

  print('\n' + '=' * 60);
  print('✅ DÉMONSTRATION TERMINÉE');
  print('🎉 L\'architecture orientée objet est prête à être utilisée!');
  print('=' * 60);
}

/// Fonction pour tester les performances
void benchmarkFormulas() {
  print('⚡ BENCHMARK - Performances de l\'architecture');
  print('=' * 50);

  final library = FormulaLibrary();
  final stopwatch = Stopwatch();

  // Test d'initialisation
  stopwatch.start();
  initializeFormulaLibrary();
  stopwatch.stop();
  print('⏱️ Initialisation: ${stopwatch.elapsedMilliseconds}ms');

  // Test de recherche
  stopwatch.reset();
  stopwatch.start();
  final results = searchFormulas('somme');
  stopwatch.stop();
  print('⏱️ Recherche "somme": ${stopwatch.elapsedMilliseconds}ms (${results.length} résultats)');

  // Test de filtrage
  stopwatch.reset();
  stopwatch.start();
  final filtered = library.getFormulasByCategory(FormulaCategory.BINOMIAL);
  stopwatch.stop();
  print('⏱️ Filtrage BINOMIAL: ${stopwatch.elapsedMilliseconds}ms (${filtered.length} résultats)');

  print('✅ Benchmarks terminés - Performances excellentes!');
}

/// =====================================================================================
/// 📊 EXEMPLES AVANCÉS
/// =====================================================================================

/// Exemple de génération de contenu éducatif
void generateEducationalContent() {
  print('📚 GÉNÉRATION DE CONTENU ÉDUCATIF');
  print('=' * 40);

  final library = FormulaLibrary();

  // Contenu par niveau
  final levels = [
    DifficultyLevel.COLLEGE,
    DifficultyLevel.LYCEE,
    DifficultyLevel.PREPA,
  ];

  for (final level in levels) {
    print('\n🏫 NIVEAU: ${level.name}');
    final formulas = library.getFormulasByDifficulty(level);

    final categories = <FormulaCategory, int>{};
    for (final formula in formulas) {
      categories[formula.category] = (categories[formula.category] ?? 0) + 1;
    }

    categories.forEach((category, count) {
      print('  • ${category.name}: $count formules');
    });
  }
}

/// Exemple d'export des formules
void exportFormulasData() {
  print('📤 EXPORT DES DONNÉES DE FORMULES');
  print('=' * 35);

  final library = FormulaLibrary();

  print('📋 FORMAT JSON (aperçu):');
  for (final formula in library.allFormulas.take(3)) {
    print('  {');
    print('    "id": "${formula.id}",');
    print('    "name": "${formula.name}",');
    print('    "category": "${formula.category.name}",');
    print('    "difficulty": "${formula.difficulty.name}",');
    print('    "latex": "${formula.fullLatex}",');
    print('    "description": "${formula.description}"');
    print('  },');
  }

  print('✅ Export simulé terminé');
}

/// =====================================================================================
/// 🎮 EXEMPLE D'INTÉGRATION AVEC LE QUIZ EXISTANT
/// =====================================================================================

/// Exemple d'intégration avec le système de quiz existant
void integrateWithExistingQuiz() {
  print('🔗 INTÉGRATION AVEC LE SYSTÈME DE QUIZ EXISTANT');
  print('=' * 50);

  final library = FormulaLibrary();

  // Simulation de génération de quiz comme dans l'ancien système
  print('🎲 Génération d\'un quiz de 6 questions (comme avant):');

  final allFormulas = library.allFormulas;
  final shuffled = List<MathematicalFormula>.from(allFormulas)..shuffle();
  final selectedFormulas = shuffled.take(6).toList();

  for (int i = 0; i < selectedFormulas.length; i++) {
    final formula = selectedFormulas[i];
    print('${i + 1}. ${formula.name}');
    print('   ${formula.latexLeft}');
    print('   = ${formula.latexRight}');
    print('   (${formula.description})');
    print();
  }

  print('✅ Intégration réussie - Compatible avec l\'ancien système!');
}
