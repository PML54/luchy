/// <cursor>
///
/// 🎯 DÉMONSTRATION DU NOUVEAU MOTEUR DE FORMULES PRÉPA
///
/// Ce fichier montre comment utiliser le PrepaMathFormulaManager
/// isolé dans lib/core/formulas/prepa_math_engine.dart
///
/// </cursor>

import 'package:luchy/core/formulas/prepa_math_engine.dart';

void main() {
  print('🎯 DÉMONSTRATION - PrepaMathFormulaManager');
  print('=' * 60);

  // =====================================================================================
  // 📊 ACCÈS AUX TEMPLATES DE FORMULES
  // =====================================================================================

  print('\n📚 1. ACCÈS AUX TEMPLATES:');

  // Accès direct aux templates
  final binomeTemplates = PrepaMathFormulaManager.binomeFormulas;
  final combinaisonsTemplates = PrepaMathFormulaManager.combinaisonsFormulas;
  final sommesTemplates = PrepaMathFormulaManager.sommesFormulas;

  print('   📐 Formules de Binôme: ${binomeTemplates.length}');
  print('   🔢 Formules de Combinaisons: ${combinaisonsTemplates.length}');
  print('   ∑ Formules de Sommes: ${sommesTemplates.length}');

  // Recherche par catégorie
  final formulesBinome =
      PrepaMathFormulaManager.getFormulasByCategory('binome');
  print('   🔍 Recherche "binome": ${formulesBinome.length} résultats');

  // =====================================================================================
  // 🧮 CALCUL AUTOMATIQUE
  // =====================================================================================

  print('\n🧮 2. CALCUL AUTOMATIQUE:');

  // Exemple: Coefficient binomial C(5,2)
  final templateBinomial = binomeTemplates[1]; // C(n,k) = n!/(k!(n-k)!)
  final resultBinomial = templateBinomial.calculate({'n': 5, 'k': 2});
  print('   ✅ C(5,2) = $resultBinomial (attendu: 10)');

  // Exemple: Développement (a+b)^n
  final templateExpansion = binomeTemplates[0]; // (a+b)^n
  final resultExpansion = templateExpansion.calculate({'a': 2, 'b': 3, 'n': 2});
  print('   ✅ (2+3)² = $resultExpansion (attendu: 25)');

  // Exemple: Somme Σ(k=1 to n) k
  final templateSum = sommesTemplates[0]; // Σ(k=1 to n) k = n(n+1)/2
  final resultSum = templateSum.calculate({'n': 10});
  print('   ✅ Σ(k=1 to 10) k = $resultSum (attendu: 55)');

  // =====================================================================================
  // 🎲 GÉNÉRATION D'EXEMPLES
  // =====================================================================================

  print('\n🎲 3. GÉNÉRATION D\'EXEMPLES:');

  // Générer des exemples valides pour une formule
  final examples = templateBinomial.generateValidExamples(count: 3);
  print('   🎯 Exemples générés pour C(n,k):');
  for (final example in examples) {
    final result = templateBinomial.calculate(example);
    print('      ${example} → C(${example['n']},${example['k']}) = $result');
  }

  // =====================================================================================
  // 📋 CRÉATION DE QUESTIONNAIRES
  // =====================================================================================

  print('\n📋 4. CRÉATION DE QUESTIONNAIRES:');

  // Créer un questionnaire pour les binômes
  final questionnaireBinome = PrepaMathFormulaManager.createBinomePreset();
  print('   📐 Questionnaire Binôme créé:');
  print('      Titre: ${questionnaireBinome.titre}');
  print('      Niveau: ${questionnaireBinome.niveau.nom}');
  print('      Matière: ${questionnaireBinome.categorie.nom}');
  print('      Formules: ${questionnaireBinome.colonneGauche.length}');

  // Créer un questionnaire pour les combinaisons
  final questionnaireComb = PrepaMathFormulaManager.createCombinaisonsPreset();
  print('   🔢 Questionnaire Combinaisons créé:');
  print('      Formules: ${questionnaireComb.colonneGauche.length}');

  // Créer un questionnaire unifié (toutes les catégories)
  final questionnaireUnifie =
      PrepaMathFormulaManager.createUnifiedPrepaCalculPreset();
  print('   🔄 Questionnaire Unifié créé:');
  print('      Formules: ${questionnaireUnifie.colonneGauche.length}');
  print('      Description: ${questionnaireUnifie.description}');

  // =====================================================================================
  // 🔍 RECHERCHE ET FILTRES
  // =====================================================================================

  print('\n🔍 5. RECHERCHE ET FILTRES:');

  // Recherche par mots-clés
  final resultatsRecherche = PrepaMathFormulaManager.searchFormulas('binom');
  print(
      '   🔍 Recherche "binom": ${resultatsRecherche.length} formules trouvées');

  final resultatsSomme = PrepaMathFormulaManager.searchFormulas('somme');
  print('   🔍 Recherche "somme": ${resultatsSomme.length} formules trouvées');

  // =====================================================================================
  // 📊 STATISTIQUES ET VALIDATION
  // =====================================================================================

  print('\n📊 6. STATISTIQUES ET VALIDATION:');

  // Statistiques du système
  final stats = PrepaMathFormulaManager.getStatistics();
  print('   📈 Statistiques:');
  print('      Total formules: ${stats['total_formulas']}');
  print('      Validation: ${stats['validation_status']}');

  // Validation de tous les templates
  final isValid = PrepaMathFormulaManager.validateAllTemplates();
  print('   ✅ Validation globale: ${isValid ? 'RÉUSSIE' : 'ÉCHEC'}');

  // =====================================================================================
  // 🎯 UTILISATION AVANCÉE
  // =====================================================================================

  print('\n🎯 7. UTILISATION AVANCÉE:');

  // Accès aux templates individuels
  final premierTemplateBinome = binomeTemplates.first;
  print('   📖 Premier template Binôme:');
  print('      Description: ${premierTemplateBinome.description}');
  print('      Paramètres: ${premierTemplateBinome.parameterCount}');
  print('      Variables: ${premierTemplateBinome.variableNames}');

  // Vérifier les propriétés d'un template
  print('   🔧 Propriétés du template:');
  print(
      '      Variables interchangeables: ${premierTemplateBinome.invertibleVariables}');
  print(
      '      Type détecté: ${premierTemplateBinome.latex.contains('binom') ? 'COMBINAISON' : 'AUTRE'}');

  // =====================================================================================
  // 🎉 CONCLUSION
  // =====================================================================================

  print('\n' + '=' * 60);
  print('🎉 DÉMONSTRATION TERMINÉE !');
  print('');
  print('📚 Le PrepaMathFormulaManager offre:');
  print('   ✅ Calcul automatique de toutes les formules');
  print('   ✅ Validation intelligente des paramètres');
  print('   ✅ Génération d\'exemples pédagogiques');
  print('   ✅ Création de questionnaires éducatifs');
  print('   ✅ Recherche et filtrage avancés');
  print('   ✅ Architecture isolée et maintenable');
  print('');
  print('🔗 Utilise-le dans ton code:');
  print('   import \'package:luchy/core/formulas/prepa_math_engine.dart\';');
  print('   final manager = PrepaMathFormulaManager();');
  print('=' * 60);
}
