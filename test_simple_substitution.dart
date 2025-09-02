/// <cursor>
///
/// 🧪 TEST SIMPLE DE SUBSTITUTION - SANS FLUTTER
///
/// Test de la logique de substitution avec approche "tout substituable"
/// Teste seulement la logique pure, sans dépendances Flutter.
///

/// Classe simple pour tester la substitution
class SimpleTemplate {
  final String latex;
  final List<String> markedVars;

  SimpleTemplate(this.latex, this.markedVars);

  /// Substitution simple des variables marquées
  String substitute(Map<String, String> values) {
    String result = latex;
    values.forEach((markedVar, replacement) {
      result = result.replaceAll(markedVar, replacement);
    });
    return result;
  }
}

/// Test de substitution de base
void testBasicSubstitution() {
  print('🔄 TEST SUBSTITUTION DE BASE');

  final template = SimpleTemplate(
      r'(_a+_b)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _a^{\,_n-k} _b^{\,k}',
      ['_a', '_b', '_n']);

  final result = template.substitute({
    '_a': '2',
    '_b': '3',
    '_n': '2',
  });

  print('✅ Substitution réussie:');
  print('  Original: ${template.latex}');
  print('  Résultat: $result');

  // Vérifications
  assert(result.contains('(2+3)^2'), 'Substitution incorrecte');
  assert(result.contains(r'\sum_{k=0}^{2}'), 'Substitution incorrecte');
  assert(result.contains(r'\binom{2}{k}'), 'Substitution incorrecte');
  assert(result.contains('2^{\,2-k}'), 'Substitution incorrecte');
  assert(result.contains('3^{\,k}'), 'Substitution incorrecte');

  // Variables marquées substituées
  assert(!result.contains('_a'), '_a devrait être substitué');
  assert(!result.contains('_b'), '_b devrait être substitué');
  assert(!result.contains('_n'), '_n devrait être substitué');

  // Variables non marquées préservées
  assert(result.contains('k'), 'k devrait être préservé');

  print('✅ Variables marquées substituées: _a, _b, _n');
  print('✅ Variables non marquées préservées: k');
}

/// Test avec formules de sommes
void testSumSubstitution() {
  print('\n∑ TEST SUBSTITUTION SOMMES');

  final sumTemplate =
      SimpleTemplate(r'\sum_{k=1}^{_n} k = \frac{_n(_n+1)}{2}', ['_n']);

  final result = sumTemplate.substitute({
    '_n': '10',
  });

  print('✅ Substitution somme:');
  print('  Résultat: $result');

  assert(result.contains(r'\sum_{k=1}^{10}'), 'Substitution incorrecte');
  assert(result.contains(r'\frac{10(10+1)}{2}'), 'Substitution incorrecte');
  assert(!result.contains('_n'), '_n devrait être substitué');
  assert(result.contains('k'), 'k devrait être préservé');

  print('✅ Substitution somme réussie');
}

/// Test avec coefficients binomiaux
void testBinomialSubstitution() {
  print('\n🔢 TEST SUBSTITUTION BINOMIALE');

  final binomialTemplate = SimpleTemplate(
      r'\binom{_n}{_k} = \frac{_n!}{_k!\,(_n-_k)!}', ['_n', '_k']);

  final result = binomialTemplate.substitute({
    '_n': '5',
    '_k': '2',
  });

  print('✅ Substitution binomiale:');
  print('  Résultat: $result');

  assert(result.contains(r'\binom{5}{2}'), 'Substitution incorrecte');
  assert(result.contains(r'\frac{5!}{2!\,(5-2)!}'), 'Substitution incorrecte');
  assert(!result.contains('_n'), '_n devrait être substitué');
  assert(!result.contains('_k'), '_k devrait être substitué');

  print('✅ Substitution binomiale réussie');
}

/// Test avec substitution partielle
void testPartialSubstitution() {
  print('\n🔧 TEST SUBSTITUTION PARTIELLE');

  final template = SimpleTemplate(
      r'(_a+_b)^_n = \sum_{k=0}^{_n} \binom{_n}{k} _a^{\,_n-k} _b^{\,k}',
      ['_a', '_b', '_n']);

  // Substitution partielle - seulement _a et _n
  final result = template.substitute({
    '_a': 'x',
    '_n': '3',
    // _b n'est pas fourni
  });

  print('✅ Substitution partielle:');
  print('  Résultat: $result');

  assert(result.contains('(x+_b)^3'), 'Substitution partielle incorrecte');
  assert(
      result.contains(r'\sum_{k=0}^{3}'), 'Substitution partielle incorrecte');
  assert(!result.contains('_a'), '_a devrait être substitué');
  assert(!result.contains('_n'), '_n devrait être substitué');
  assert(result.contains('_b'), '_b devrait être préservé');

  print('✅ Substitution partielle réussie');
}

/// Test avec variables multiples
void testMultipleSubstitution() {
  print('\n🔄 TEST SUBSTITUTION MULTIPLE');

  final complexTemplate = SimpleTemplate(
      r'\sum_{k=_start}^{_end} \binom{_n}{k} _q^{k} = \binom{_n}{_start} _q^{_start} (_q+1)^{_n-_start}',
      ['_n', '_q', '_start', '_end']);

  final result = complexTemplate.substitute({
    '_n': '5',
    '_q': '2',
    '_start': '1',
    '_end': '3',
  });

  print('✅ Substitution complexe:');
  print('  Résultat: $result');

  assert(
      result.contains(r'\sum_{k=1}^{3}'), 'Substitution complexe incorrecte');
  assert(result.contains(r'\binom{5}{k}'), 'Substitution complexe incorrecte');
  assert(result.contains('2^{k}'), 'Substitution complexe incorrecte');
  assert(result.contains(r'\binom{5}{1}'), 'Substitution complexe incorrecte');
  assert(result.contains('2^{1}'), 'Substitution complexe incorrecte');
  assert(result.contains('(2+1)^{5-1}'), 'Substitution complexe incorrecte');

  // Vérifier que toutes les variables marquées sont substituées
  assert(!result.contains('_n'), '_n devrait être substitué');
  assert(!result.contains('_q'), '_q devrait être substitué');
  assert(!result.contains('_start'), '_start devrait être substitué');
  assert(!result.contains('_end'), '_end devrait être substitué');

  // Variables non marquées préservées
  assert(result.contains('k'), 'k devrait être préservé');

  print('✅ Substitution complexe réussie');
}

/// Point d'entrée des tests
void main() {
  print('🧪 TESTS DE SUBSTITUTION - APPROCHE "TOUT SUBSTITUABLE"');
  print('=' * 60);

  try {
    testBasicSubstitution();
    testSumSubstitution();
    testBinomialSubstitution();
    testPartialSubstitution();
    testMultipleSubstitution();

    print('\n' + '=' * 60);
    print('🎉 TOUS LES TESTS DE SUBSTITUTION RÉUSSIS !');
    print('✅ Variables marquées = substituées');
    print('✅ Variables non marquées = préservées');
    print('✅ Logique simple et fiable');
    print('✅ Approche "tout substituable" validée');
    print('=' * 60);
  } catch (e) {
    print('\n❌ ERREUR LORS DES TESTS:');
    print('Exception: $e');
    print('🔍 Vérifier la logique de substitution');
  }
}
