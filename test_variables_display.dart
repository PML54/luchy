/// Test rapide pour vérifier l'affichage des variables {VAR:}
import 'package:luchy/core/formulas/prepa_math_engine.dart';

void main() {
  print('🧪 TEST AFFICHAGE VARIABLES {VAR:}');
  print('=' * 50);
  
  // Initialiser les formules
  UnifiedMathFormulaManager.initialize();
  
  // Tester quelques formules binôme
  print('\n📋 FORMULES BINÔME:');
  final binomeFormulas = PrepaMathFormulaManager.binomeFormulas.take(3);
  
  for (int i = 0; i < binomeFormulas.length; i++) {
    final formula = binomeFormulas.elementAt(i);
    print('\n--- Formule ${i + 1}: ${formula.name} ---');
    print('latexOrigine:         ${formula.latexOrigine}');
    print('latexVariable:        ${formula.latexVariable}');
    print('latex (final):        ${formula.latex}');
    print('leftSide (normal):    ${formula.leftSide}');
    print('leftSideWithVariables: ${formula.leftSideWithVariables}');
    print('rightSide (normal):   ${formula.rightSide}');
    print('rightSideWithVariables: ${formula.rightSideWithVariables}');
  }
  
  // Tester quelques formules sommes
  print('\n📋 FORMULES SOMMES:');
  final sommesFormulas = PrepaMathFormulaManager.sommesFormulas.take(2);
  
  for (int i = 0; i < sommesFormulas.length; i++) {
    final formula = sommesFormulas.elementAt(i);
    print('\n--- Formule ${i + 1}: ${formula.name} ---');
    print('latexOrigine:         ${formula.latexOrigine}');
    print('latexVariable:        ${formula.latexVariable}');
    print('leftSideWithVariables: ${formula.leftSideWithVariables}');
    print('rightSideWithVariables: ${formula.rightSideWithVariables}');
  }
  
  print('\n✅ TEST TERMINÉ !');
}
