/// <cursor>
///
/// 🧪 TEST DE L'APPROCHE "TOUT SUBSTITUABLE" AVEC MARQUAGE EXPLICITE
///
/// Ce test vérifie que la nouvelle approche de substitution fonctionne :
/// - Seules les variables marquées avec '_' sont substituées
/// - Les autres variables restent inchangées
/// - La logique est simple et prévisible
///

import 'package:luchy/core/formulas/prepa_math_engine.dart';

void main() {
  print('🧪 TEST APPROCHE "TOUT SUBSTITUABLE"');
  print('=' * 60);

  testSubstitution();
  testCalculationWithNewNames();
  testTemplatesWithMarkedVariables();

  print('\n' + '=' * 60);
  print('🎉 APPROCHE "TOUT SUBSTITUABLE" VALIDÉE !');
  print('✅ Variables marquées = substituées');
  print('✅ Variables non marquées = préservées');
  print('✅ Logique simple et fiable');
  print('=' * 60);
}

/// Test de la méthode substitute()
void testSubstitution() {
  print('\n🔄 TEST SUBSTITUTION DE BASE');

  final template = EnhancedFormulaTemplate(
    latex: r'(_a+_b)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _a^{\,_n-k} _b^{\,k}',
    description: 'Test template',
    parameters: const [
      FormulaParameter(name: '_a', description: 'a', type: ParameterType.REAL),
      FormulaParameter(name: '_b', description: 'b', type: ParameterType.REAL),
      FormulaParameter(
          name: '_n', description: 'n', type: ParameterType.NATURAL),
    ],
  );

  // Test substitution
  final result = template.substitute({
    '_a': '2',
    '_b': '3',
    '_n': '2',
  });

  print('✅ Substitution réussie:');
  print('  Original: ${template.latex}');
  print('  Résultat: $result');

  // Vérification que seules les variables marquées ont été substituées
  assert(result.contains('k'), 'k devrait être préservé');
  assert(!result.contains('_a'), '_a devrait être substitué');
  assert(!result.contains('_b'), '_b devrait être substitué');
  assert(!result.contains('_n'), '_n devrait être substitué');

  print('✅ Variables marquées substituées: _a, _b, _n');
  print('✅ Variables non marquées préservées: k');
}

/// Test des calculs avec les nouveaux noms
void testCalculationWithNewNames() {
  print('\n🧮 TEST CALCUL AVEC NOMS MARQUÉS');

  // Test coefficient binomial avec noms marqués
  final binomeTemplate = enhancedBinomeTemplates[0]; // (_a+_b)^_n = ...

  final result = binomeTemplate.calculate({
    '_a': 2,
    '_b': 3,
    '_n': 2,
  });

  print('✅ Calcul (2+3)² = $result');

  // Vérification du résultat
  assert(result == 25, 'Le résultat devrait être 25');
  print('✅ Résultat correct: 25');

  // Test coefficient binomial
  final binomialTemplate = enhancedBinomeTemplates[1]; // \binom{_n}{_k} = ...

  final binomialResult = binomialTemplate.calculate({
    '_n': 5,
    '_k': 2,
  });

  print('✅ Calcul C(5,2) = $binomialResult');

  // Vérification du résultat
  assert(binomialResult == 10, 'Le résultat devrait être 10');
  print('✅ Résultat correct: 10');
}

/// Test des templates avec variables marquées
void testTemplatesWithMarkedVariables() {
  print('\n📚 TEST TEMPLATES AVEC VARIABLES MARQUÉES');

  print('📐 Templates Binôme: ${enhancedBinomeTemplates.length}');
  print('🔢 Templates Combinaisons: ${enhancedCombinaisonsTemplates.length}');
  print('∑ Templates Sommes: ${enhancedSommesTemplates.length}');

  // Vérification que tous les templates utilisent des variables marquées
  for (final template in enhancedBinomeTemplates) {
    final varNames = template.variableNames;
    print('  Binôme: ${varNames.join(', ')}');

    // Vérifier que toutes les variables sont marquées
    for (final varName in varNames) {
      assert(varName.startsWith('_'),
          'Variable $varName devrait être marquée avec _');
    }
  }

  for (final template in enhancedCombinaisonsTemplates) {
    final varNames = template.variableNames;
    print('  Combinaison: ${varNames.join(', ')}');

    for (final varName in varNames) {
      assert(varName.startsWith('_'),
          'Variable $varName devrait être marquée avec _');
    }
  }

  for (final template in enhancedSommesTemplates) {
    final varNames = template.variableNames;
    print('  Somme: ${varNames.join(', ')}');

    for (final varName in varNames) {
      assert(varName.startsWith('_'),
          'Variable $varName devrait être marquée avec _');
    }
  }

  print('✅ Tous les templates utilisent des variables marquées');
  print('✅ Cohérence parfaite dans toute l\'architecture');
}

/// Test de substitution avec des cas complexes
void testComplexSubstitution() {
  print('\n🔧 TEST SUBSTITUTION COMPLEXE');

  final complexTemplate = EnhancedFormulaTemplate(
    latex:
        r'\sum_{k=_start}^{_end} \binom{_n}{k} _q^{k} = \binom{_n}{_start} _q^{_start} (_q+1)^{_n-_start}',
    description: 'Formule complexe avec plusieurs variables',
    parameters: const [
      FormulaParameter(
          name: '_n', description: 'n', type: ParameterType.NATURAL),
      FormulaParameter(name: '_q', description: 'q', type: ParameterType.REAL),
      FormulaParameter(
          name: '_start', description: 'début', type: ParameterType.NATURAL),
      FormulaParameter(
          name: '_end', description: 'fin', type: ParameterType.NATURAL),
    ],
  );

  final result = complexTemplate.substitute({
    '_n': '5',
    '_q': '2',
    '_start': '1',
    '_end': '3',
  });

  print('✅ Substitution complexe:');
  print('  Résultat: $result');

  // Vérifications
  assert(!result.contains('_n'), '_n devrait être substitué');
  assert(!result.contains('_q'), '_q devrait être substitué');
  assert(!result.contains('_start'), '_start devrait être substitué');
  assert(!result.contains('_end'), '_end devrait être substitué');
  assert(result.contains('k'), 'k devrait être préservé');

  print('✅ Variables marquées substituées');
  print('✅ Variable non marquée k préservée');
}
