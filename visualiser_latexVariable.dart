/// Visualiseur de latexVariable pour formules spécifiques
import 'package:luchy/core/formulas/prepa_math_engine.dart';

void main() {
  print('🔍 VISUALISEUR latexVariable');
  print('=' * 60);

  // Exemples de formules à visualiser
  visualiserFormulesBinome();
  visualiserFormulesCombinaiGsons();
  visualiserFormulesSommes();

  // Test d'inversion
  print('\n🔄 TEST INVERSION:');
  testInversion();
}

void visualiserFormulesBinome() {
  print('\n📚 FORMULES BINÔME:');
  final formules = PrepaMathFormulaManager.binomeFormulas;

  for (int i = 0; i < 3 && i < formules.length; i++) {
    final f = formules[i];
    print('\n${i + 1}. ${f.description}');
    print('   latexOrigine:     ${f.latexOrigine}');
    print('   latexVariable:    ${f.latexVariable}');
    print('   leftLatexVariable:  ${f.leftLatexVariable}');
    print('   rightLatexVariable: ${f.rightLatexVariable}');
    print('   numberOfVariables: ${f.numberOfVariables}');
    print('   Variables: ${f.extractedVariables}');
  }
}

void visualiserFormulesCombinaiGsons() {
  print('\n🧮 FORMULES COMBINAISONS:');
  final formules = PrepaMathFormulaManager.combinaisonsFormulas;

  for (int i = 0; i < 2 && i < formules.length; i++) {
    final f = formules[i];
    print('\n${i + 1}. ${f.description}');
    print('   latexOrigine:     ${f.latexOrigine}');
    print('   latexVariable:    ${f.latexVariable}');
    print('   leftLatexVariable:  ${f.leftLatexVariable}');
    print('   rightLatexVariable: ${f.rightLatexVariable}');
    print('   numberOfVariables: ${f.numberOfVariables}');
    print('   Variables: ${f.extractedVariables}');
  }
}

void visualiserFormulesSommes() {
  print('\n📊 FORMULES SOMMES:');
  final formules = PrepaMathFormulaManager.sommesFormulas;

  for (int i = 0; i < 2 && i < formules.length; i++) {
    final f = formules[i];
    print('\n${i + 1}. ${f.description}');
    print('   latexOrigine:     ${f.latexOrigine}');
    print('   latexVariable:    ${f.latexVariable}');
    print('   leftLatexVariable:  ${f.leftLatexVariable}');
    print('   rightLatexVariable: ${f.rightLatexVariable}');
    print('   numberOfVariables: ${f.numberOfVariables}');
    print('   Variables: ${f.extractedVariables}');
  }
}

void testInversion() {
  // Prendre une formule avec 2 variables
  final formules = PrepaMathFormulaManager.allFormulas;
  final formulesAvec2Vars =
      formules.where((f) => f.numberOfVariables == 2).toList();

  if (formulesAvec2Vars.isNotEmpty) {
    final f = formulesAvec2Vars.first;
    print('\nFormule sélectionnée: ${f.description}');
    print('AVANT inversion:');
    print('   latexVariable: ${f.latexVariable}');
    print('   Variables: ${f.extractedVariables}');

    try {
      final inverted = f.createWithSimpleInversion();
      print('\nAPRÈS inversion:');
      print('   latexVariable: ${inverted.latexVariable}');
      print('   Variables: ${inverted.extractedVariables}');
      print('   latex final: ${inverted.latex}');
    } catch (e) {
      print('❌ Erreur inversion: $e');
    }
  }
}

/// Rechercher une formule par description
void rechercherFormule(String recherche) {
  print('\n🔍 RECHERCHE: "$recherche"');
  final formules = PrepaMathFormulaManager.searchFormulas(recherche);

  if (formules.isEmpty) {
    print('❌ Aucune formule trouvée');
    return;
  }

  for (int i = 0; i < formules.length && i < 3; i++) {
    final f = formules[i];
    print('\n${i + 1}. ${f.description}');
    print('   latexVariable: ${f.latexVariable}');
    print('   Variables: ${f.extractedVariables}');
  }
}

/// Afficher une formule spécifique par index
void afficherFormuleParIndex(int index) {
  final formules = PrepaMathFormulaManager.allFormulas;

  if (index < 0 || index >= formules.length) {
    print('❌ Index invalide. Plage: 0-${formules.length - 1}');
    return;
  }

  final f = formules[index];
  print('\n📋 FORMULE #$index:');
  print('Description: ${f.description}');
  print('latexOrigine:        ${f.latexOrigine}');
  print('latexVariable:       ${f.latexVariable}');
  print('leftLatexVariable:   ${f.leftLatexVariable}');
  print('rightLatexVariable:  ${f.rightLatexVariable}');
  print('latex final:         ${f.latex}');
  print('numberOfVariables:   ${f.numberOfVariables}');
  print('Variables extraites: ${f.extractedVariables}');
}
