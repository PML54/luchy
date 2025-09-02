/// Test rapide sans dépendances Flutter
import 'dart:core';

// Copie simplifiée de la logique des formules
class SimpleFormulaTest {
  final String latexOrigine;
  final String latexVariable;
  final String latex;
  
  SimpleFormulaTest({required this.latexOrigine})
    : latexVariable = _generateLatexVariable(latexOrigine),
      latex = _generateLatex(latexOrigine);
  
  static String _generateLatexVariable(String origine) {
    String result = origine;
    
    // 1. Capturer les variables avec underscore (ex: C_n, a_i)
    result = result.replaceAllMapped(
      RegExp(r'([a-zA-Z])_([a-zA-Z0-9]+)'),
      (match) => '{VAR:${match.group(1)}_${match.group(2)}}'
    );
    
    // 2. Capturer les variables simples dans les contextes LaTeX courants
    // Variables dans \binom{n}{k}
    result = result.replaceAllMapped(
      RegExp(r'\\binom\{([a-zA-Z])\}\{([a-zA-Z])\}'),
      (match) => r'\binom{{VAR:' + match.group(1)! + r'}}{{VAR:' + match.group(2)! + r'}}'
    );
    
    // Variables dans \frac{n!}{k!...}
    result = result.replaceAllMapped(
      RegExp(r'([a-zA-Z])!'),
      (match) => '{VAR:${match.group(1)}}!'
    );
    
    // Variables isolées dans certains contextes (entourées d'espaces, parenthèses, opérateurs)
    result = result.replaceAllMapped(
      RegExp(r'(?<=[\s\(\)\+\-\*=]|^)([a-zA-Z])(?=[\s\(\)\+\-\*=!]|$)'),
      (match) => '{VAR:${match.group(1)}}'
    );
    
    return result;
  }
  
  static String _generateLatex(String withVars) {
    final processedVars = _generateLatexVariable(withVars);
    return processedVars.replaceAllMapped(
      RegExp(r'\{VAR:([^}]+)\}'),
      (match) => match.group(1)!
    );
  }
  
  String get leftSideWithVariables {
    // Simple split - on trouve le premier = qui est un séparateur principal
    final parts = latexVariable.split(' = ');
    if (parts.length >= 2) {
      return parts[0].trim();
    }
    // Si pas d'espace autour du =, essayer split simple
    final simpleParts = latexVariable.split('=');
    return simpleParts.isNotEmpty ? simpleParts[0].trim() : latexVariable;
  }
  
  String get rightSideWithVariables {
    // Simple split - on trouve le premier = qui est un séparateur principal
    final parts = latexVariable.split(' = ');
    if (parts.length >= 2) {
      return parts.sublist(1).join(' = ').trim();
    }
    // Si pas d'espace autour du =, essayer split simple
    final simpleParts = latexVariable.split('=');
    return simpleParts.length > 1 ? simpleParts.sublist(1).join('=').trim() : '';
  }
}

void main() {
  print('🧪 TEST RAPIDE DES VARIABLES {VAR:}');
  print('=' * 50);
  
  // Tester avec quelques formules types
  final testFormulas = [
    r'C_n^k = \frac{n!}{k!(n-k)!}',
    r'\sum_{i=1}^n i = \frac{n(n+1)}{2}',
    r'(a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k',
    r'P(A \cap B) = P(A) \cdot P(B|A)',
  ];
  
  for (int i = 0; i < testFormulas.length; i++) {
    final formula = SimpleFormulaTest(latexOrigine: testFormulas[i]);
    print('\n--- Test ${i + 1} ---');
    print('Original:     ${formula.latexOrigine}');
    print('Variable:     ${formula.latexVariable}');
    print('Final:        ${formula.latex}');
    print('Left with VAR: ${formula.leftSideWithVariables}');
    print('Right with VAR: ${formula.rightSideWithVariables}');
  }
  
  print('\n✅ Test terminé !');
}
