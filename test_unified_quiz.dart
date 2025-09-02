/// Test de la concaténation des 3 catégories en un quiz unifié

import 'dart:math';

import 'lib/core/utils/formulas_implementation.dart';
import 'lib/core/utils/mathematical_formulas_oop.dart';

void main() {
  print('🎯 TEST DU QUIZ UNIFIÉ - Concaténation des 3 catégories');
  print('=' * 60);

  // Initialisation
  print('1️⃣ INITIALISATION:');
  initializeFormulaLibrary();
  final library = FormulaLibrary();

  // Statistiques par catégorie
  print('\n2️⃣ STATISTIQUES PAR CATÉGORIE:');
  final binomialPrepa = library
      .getFormulasByCategory(FormulaCategory.BINOMIAL)
      .where((f) => f.difficulty == DifficultyLevel.PREPA)
      .toList();
  final summationPrepa = library
      .getFormulasByCategory(FormulaCategory.SUMMATION)
      .where((f) => f.difficulty == DifficultyLevel.PREPA)
      .toList();
  final combinatorialPrepa = library
      .getFormulasByCategory(FormulaCategory.COMBINATORIAL)
      .where((f) => f.difficulty == DifficultyLevel.PREPA)
      .toList();

  final totalPrepa =
      binomialPrepa.length + summationPrepa.length + combinatorialPrepa.length;

  print('   🟡 Binôme (Prépa): ${binomialPrepa.length} formules');
  print('   🔵 Sommes (Prépa): ${summationPrepa.length} formules');
  print('   🟣 Combinaisons (Prépa): ${combinatorialPrepa.length} formules');
  print('   🎯 TOTAL UNIFIÉ: $totalPrepa formules');

  // Concaténation des formules
  print('\n3️⃣ CONCATÉNATION DES FORMULES:');
  final unifiedFormulas = [
    ...binomialPrepa,
    ...summationPrepa,
    ...combinatorialPrepa
  ];
  print('   📚 Liste unifiée créée avec ${unifiedFormulas.length} formules');

  // Simulation de sélection de quiz
  print('\n4️⃣ SIMULATION DE QUIZ (6 questions):');
  final random = Random(42); // Seed pour reproductibilité
  final shuffled = List.from(unifiedFormulas)..shuffle(random);
  final quizFormulas = shuffled.take(6).toList();

  print('   🎲 Quiz généré:');
  for (int i = 0; i < quizFormulas.length; i++) {
    final formula = quizFormulas[i];
    final categoryIcon = formula.category == FormulaCategory.BINOMIAL
        ? '🟡'
        : formula.category == FormulaCategory.SUMMATION
            ? '🔵'
            : '🟣';
    print('     ${i + 1}. $categoryIcon ${formula.name}');
    print('        ${formula.latexLeft} = ${formula.latexRight}');
  }

  // Vérification de la diversité
  print('\n5️⃣ VÉRIFICATION DE LA DIVERSITÉ:');
  final categoriesInQuiz = quizFormulas.map((f) => f.category).toSet();
  print('   🎨 Catégories représentées: ${categoriesInQuiz.length}/3');
  print('   📊 Répartition:');
  for (final category in categoriesInQuiz) {
    final count = quizFormulas.where((f) => f.category == category).length;
    final icon = category == FormulaCategory.BINOMIAL
        ? '🟡'
        : category == FormulaCategory.SUMMATION
            ? '🔵'
            : '🟣';
    final categoryName = category == FormulaCategory.BINOMIAL
        ? 'Binôme'
        : category == FormulaCategory.SUMMATION
            ? 'Sommes'
            : 'Combinaisons';
    print('     $icon $categoryName: $count formule(s)');
  }

  // Statistiques finales
  print('\n6️⃣ RÉSULTATS:');
  final diversityScore = categoriesInQuiz.length / 3.0 * 100;
  print('   🎯 Score de diversité: ${diversityScore.toStringAsFixed(1)}%');
  print('   📈 Couverture: ${categoriesInQuiz.length}/3 catégories');

  if (categoriesInQuiz.length >= 2) {
    print(
        '   ✅ SUCCÈS: Quiz diversifié avec ${categoriesInQuiz.length} catégories!');
  } else {
    print('   ⚠️ ATTENTION: Quiz peu diversifié');
  }

  print('\n' + '=' * 60);
  print('🎉 CONCATÉNATION RÉUSSIE!');
  print('🔄 Les 3 catégories sont maintenant unifiées en un seul quiz!');
  print('=' * 60);
}
