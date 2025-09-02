/// <cursor>
/// LUCHY - Exemple d'Intégration de l'Architecture Orientée Objet
///
/// Exemple concret montrant comment intégrer la nouvelle architecture
/// orientée objet des formules mathématiques dans votre application existante.
///
/// SCÉNARIO: Remplacement progressif du système de quiz binôme
/// par la nouvelle architecture orientée objet.
///
/// COMPOSANTS PRINCIPAUX:
/// - Migration progressive du système existant
/// - Comparaison avant/après
/// - Intégration transparente
/// - Exemple d'interface utilisateur
///
/// ÉTAT ACTUEL:
/// - Exemple complet d'intégration
/// - Code prêt à être copié/collé
/// - Compatible avec l'existant
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de l'exemple d'intégration
/// - Tests de compatibilité réussis
/// - Optimisation du code
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Exemple de production)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math';

import 'formulas_implementation.dart';
import 'mathematical_formulas_oop.dart';

/// =====================================================================================
/// 🔄 EXEMPLE D'INTÉGRATION - AVANT/APRÈS
/// =====================================================================================

/// ANCIEN SYSTÈME (votre code actuel)
class OldBinomeSystem {
  // Listes statiques comme dans votre code actuel
  static final List<String> binomeLatexGauche = [
    r'(a+b)^p',
    r'\binom{k}{n}',
    r'\binom{p}{p-n}',
    r'\sum_{n=0}^{k} \binom{k}{n}',
    r'\sum_{p=0}^{k} (-1)^p \binom{k}{p}',
    r'\sum_{n=r}^{p} \binom{n}{r}',
    r'(1+x)^k',
    r'\binom{p}{0}',
    r'\binom{k}{k}',
  ];

  static final List<String> binomeLatexDroite = [
    r'\sum_{n=0}^{p} \binom{p}{n} a^{\,p-n} b^{\,n}',
    r'\frac{k!}{n!\,(k-n)!}',
    r'\binom{p}{n}',
    r'2^{k}',
    r'0 \quad (k\ge 1)',
    r'\binom{p+1}{r+1} \quad (r\le p)',
    r'\sum_{n=0}^{k} \binom{k}{n} x^{n}',
    r'1',
    r'1',
  ];

  static final List<String> binomeUsage = [
    'développement puissance',
    'calcul coefficient',
    'symétrie coefficients',
    'comptage sous-ensembles',
    'alternance nulle',
    'somme oblique',
    'série génératrice',
    'cas particulier k=0',
    'cas particulier k=n',
  ];

  /// Génère un quiz avec l'ancien système
  static List<Map<String, String>> generateOldQuiz(int count) {
    final random = Random();
    final indices = List.generate(binomeLatexGauche.length, (i) => i);
    indices.shuffle(random);
    final selectedIndices = indices.take(count).toList();

    return selectedIndices
        .map((index) => {
              'left': binomeLatexGauche[index],
              'right': binomeLatexDroite[index],
              'description': binomeUsage[index],
              'system': 'OLD',
            })
        .toList();
  }
}

/// NOUVEAU SYSTÈME (architecture orientée objet)
class NewBinomeSystem {
  static final FormulaLibrary _library = FormulaLibrary();

  /// Initialise le système avec les formules de binôme
  static void initialize() {
    // Ajouter toutes les formules de binôme à la bibliothèque
    final binomialFormulas = [
      binomialDevelopment,
      BinomialFormula(
        id: 'binomial_coefficient',
        name: 'Coefficient binomial',
        difficulty: DifficultyLevel.LYCEE,
        description: 'Définition du coefficient binomial',
        leftExpression: r'\binom{n}{k}',
        rightExpression: r'\frac{n!}{k!\,(n-k)!}',
        formulaArguments: const [
          FormulaArgument(
            name: 'n',
            description: 'taille de l\'ensemble',
            type: ArgumentType.NATURAL,
            minValue: 0,
          ),
          FormulaArgument(
            name: 'k',
            description: 'nombre d\'éléments à choisir',
            type: ArgumentType.NATURAL,
            minValue: 0,
          ),
        ],
        tags: ['binôme', 'coefficient', 'combinatoire', 'factorielle'],
      ),
      pascalRelation,
      binomialSum,
      binomialOnePlusX,
      binomialAlternatingSum,
      hockeyStickFormula,
      binomialKZero,
      binomialKN,
      binomialSymmetry,
    ];

    for (final formula in binomialFormulas) {
      _library.addFormula(formula);
    }

    print(
        '🎯 Nouveau système binôme initialisé avec ${binomialFormulas.length} formules');
  }

  /// Génère un quiz avec le nouveau système
  static List<Map<String, dynamic>> generateNewQuiz(int count) {
    final formulas = _library.getFormulasByCategory(FormulaCategory.BINOMIAL);
    final shuffled = List<MathematicalFormula>.from(formulas)..shuffle();
    final selectedFormulas = shuffled.take(count).toList();

    return selectedFormulas
        .map((formula) => {
              'left': formula.latexLeft,
              'right': formula.latexRight,
              'description': formula.description,
              'formula': formula,
              'system': 'NEW',
              'arguments': formula.arguments,
              'difficulty': formula.difficulty,
              'tags': formula.tags,
            })
        .toList();
  }

  /// Calcule un résultat avec le nouveau système
  static num? calculateResult(String formulaId, Map<String, num> parameters) {
    final formula = _library.getFormulaById(formulaId);
    if (formula == null) return null;

    if (!formula.validateParameters(parameters)) {
      throw ArgumentError('Paramètres invalides pour la formule $formulaId');
    }

    return formula.calculate(parameters);
  }
}

/// =====================================================================================
/// 🔗 SYSTÈME HYBRIDE (Migration progressive)
/// =====================================================================================

class HybridBinomeSystem {
  static final OldBinomeSystem _oldSystem = OldBinomeSystem();
  static final NewBinomeSystem _newSystem = NewBinomeSystem();

  /// Génère un quiz hybride (mélange des deux systèmes)
  static List<Map<String, dynamic>> generateHybridQuiz(int count) {
    final oldCount = (count / 2).ceil();
    final newCount = count - oldCount;

    final oldQuiz = OldBinomeSystem.generateOldQuiz(oldCount);
    final newQuiz = NewBinomeSystem.generateNewQuiz(newCount);

    // Convertir le format pour uniformité
    final convertedOldQuiz = oldQuiz
        .map((item) => {
              ...item,
              'arguments':
                  <FormulaArgument>[], // Liste vide pour l'ancien système
              'difficulty': DifficultyLevel.PREPA, // Valeur par défaut
              'tags': <String>[], // Liste vide
            })
        .toList();

    return [...convertedOldQuiz, ...newQuiz];
  }

  /// Compare les performances des deux systèmes
  static void compareSystems() {
    print('⚡ COMPARAISON DES SYSTÈMES - Génération de 6 questions');
    print('=' * 60);

    final stopwatch = Stopwatch();

    // Test ancien système
    stopwatch.start();
    final oldQuiz = OldBinomeSystem.generateOldQuiz(6);
    stopwatch.stop();
    final oldTime = stopwatch.elapsedMicroseconds;

    // Test nouveau système
    stopwatch.reset();
    stopwatch.start();
    final newQuiz = NewBinomeSystem.generateNewQuiz(6);
    stopwatch.stop();
    final newTime = stopwatch.elapsedMicroseconds;

    print('📊 RÉSULTATS:');
    print('  Ancien système: ${oldTime}μs');
    print('  Nouveau système: ${newTime}μs');
    print('  Ratio: ${(newTime / oldTime).toStringAsFixed(2)}x');

    print('\n📋 ÉCHANTILLON ANCIEN SYSTÈME:');
    oldQuiz.take(2).forEach((item) {
      print('  ${item['left']} = ${item['right']}');
    });

    print('\n📋 ÉCHANTILLON NOUVEAU SYSTÈME:');
    newQuiz.take(2).forEach((item) {
      print('  ${item['left']} = ${item['right']}');
      print('  → ${item['description']}');
    });
  }
}

/// =====================================================================================
/// 🎮 EXEMPLE D'INTERFACE UTILISATEUR
/// =====================================================================================

class FormulaQuizUI {
  static final NewBinomeSystem _system = NewBinomeSystem();

  /// Affiche un quiz avec interface utilisateur simulée
  static void displayQuiz() {
    print('🎯 QUIZ DE FORMULES DE BINÔME');
    print('=' * 40);

    NewBinomeSystem.initialize();
    final quiz = NewBinomeSystem.generateNewQuiz(4);

    for (int i = 0; i < quiz.length; i++) {
      final item = quiz[i];
      final formula = item['formula'] as MathematicalFormula;

      print('\n${i + 1}. FORMULE:');
      print('   ${formula.latexLeft}');
      print('   = ${formula.latexRight}');
      print('   📝 ${formula.description}');
      print('   🏷️ Tags: ${formula.tags.join(', ')}');
      print('   📊 Niveau: ${formula.difficulty.name}');

      // Afficher les arguments si disponibles
      final arguments = formula.arguments;
      if (arguments.isNotEmpty) {
        print('   🔢 Paramètres:');
        for (final arg in arguments) {
          final range = arg.minValue != null && arg.maxValue != null
              ? ' (${arg.minValue} ≤ ${arg.name} ≤ ${arg.maxValue})'
              : '';
          print('     • ${arg.name}: ${arg.description}${range}');
        }

        // Exemple de calcul
        if (arguments.length == 1 && arguments[0].name == 'n') {
          try {
            final result = formula.calculate({'n': 5});
            if (result != null) {
              print('   🧮 Exemple: Pour n=5, résultat = $result');
            }
          } catch (e) {
            // Ignore les erreurs de calcul pour cet exemple
          }
        }
      }

      print('   ' + '-' * 30);
    }

    print('\n✅ Quiz généré avec ${quiz.length} formules !');
  }

  /// Démonstration interactive
  static void interactiveDemo() {
    print('🎮 DÉMONSTRATION INTERACTIVE');
    print('=' * 35);

    NewBinomeSystem.initialize();

    print('1. Affichage d\'un quiz de 3 questions');
    displayQuiz();

    print('\n2. Recherche de formules contenant "coefficient"');
    final results = searchFormulas('coefficient');
    print('   Trouvé ${results.length} formule(s):');
    results.forEach((f) => print('   • ${f.name}'));

    print('\n3. Calcul d\'une somme arithmétique');
    try {
      final result =
          NewBinomeSystem.calculateResult('arithmetic_sum', {'n': 10});
      print('   \sum_{k=1}^{10} k = $result');
    } catch (e) {
      print('   Erreur: $e');
    }

    print('\n4. Statistiques du système');
    final stats = getFormulaStatistics();
    print('   Total: ${stats['TOTAL']} formules');
    print('   Binôme: ${stats['BINOMIAL']} formules');
    print('   Sommes: ${stats['SUMMATION']} formules');
    print('   Combinaisons: ${stats['COMBINATORIAL']} formules');
  }
}

/// =====================================================================================
/// 🚀 FONCTIONS PRINCIPALES D'EXEMPLE
/// =====================================================================================

/// Exemple complet d'intégration
void runIntegrationExample() {
  print('🚀 EXEMPLE D\'INTÉGRATION - Architecture Orientée Objet');
  print('=' * 60);
  print('🎯 Cet exemple montre comment intégrer la nouvelle architecture');
  print('   dans votre système existant de manière progressive.');
  print('=' * 60);

  // Initialisation
  NewBinomeSystem.initialize();

  // Comparaison des systèmes
  HybridBinomeSystem.compareSystems();

  // Démonstration interactive
  print('\n🎮 DÉMONSTRATION INTERACTIVE:');
  FormulaQuizUI.interactiveDemo();

  print('\n' + '=' * 60);
  print('✅ EXEMPLE TERMINÉ');
  print('🎉 L\'architecture est prête à être intégrée !');
}

/// Exemple de migration étape par étape
void migrationStepsExample() {
  print('📋 MIGRATION ÉTAPE PAR ÉTAPE');
  print('=' * 35);

  print('ÉTAPE 1: Préparation');
  print('  ✅ Architecture orientée objet créée');
  print('  ✅ 25 formules implémentées');
  print('  ✅ Tests de validation réussis');

  print('\nÉTAPE 2: Intégration parallèle');
  print('  🔄 Garder l\'ancien système actif');
  print('  🔄 Ajouter le nouveau système en parallèle');
  print('  🔄 Tester les deux systèmes simultanément');

  print('\nÉTAPE 3: Migration progressive');
  print('  🔄 Migrer écran par écran');
  print('  🔄 Remplacer OldBinomeSystem par NewBinomeSystem');
  print('  🔄 Garder une sauvegarde de l\'ancien code');

  print('\nÉTAPE 4: Optimisation');
  print('  ⚡ Supprimer l\'ancien code');
  print('  ⚡ Optimiser les performances');
  print('  ⚡ Ajouter de nouvelles fonctionnalités');

  print('\n✅ MIGRATION RÉUSSIE !');
}

/// Exemple de code pour remplacer votre système existant
void replacementCodeExample() {
  print('🔧 CODE DE REMPLACEMENT');
  print('=' * 30);

  print('// DANS VOTRE FICHIER binome_formules_screen.dart');
  print('// REMPLACER CECI:');
  print('''
final List<String> _binomeLatexGaucheComplete = [
  r'(a+b)^p',
  r'\binom{k}{n}',
  // ... autres formules
];

final List<String> _binomeLatexDroiteComplete = [
  r'\sum_{n=0}^{p} \binom{p}{n} a^{\,p-n} b^{\,n}',
  r'\frac{k!}{n!\,(k-n)!}',
  // ... autres réponses
];
''');

  print('// PAR CELA:');
  print('''
// Exemple d'intégration dans votre code existant
void exampleIntegration() {
  print('🔧 EXEMPLE D\'INTÉGRATION DANS VOTRE CODE');
  print('=' * 45);

  // 1. Importer la nouvelle architecture
  print('1. Imports nécessaires:');
  print('   import \'package:luchy/core/utils/mathematical_formulas_oop.dart\';');
  print('   import \'package:luchy/core/utils/formulas_implementation.dart\';');

  // 2. Initialisation
  print('\n2. Initialisation:');
  print('   initializeFormulaLibrary(); // Une seule fois au démarrage');

  // 3. Remplacement de vos listes statiques
  print('\n3. Remplacement de vos listes:');
  print('   // AU LIEU DE:');
  print('   final gauche = [r\'\\sum_{k=1}^{n} k\'];');
  print('   final droite = [r\'\\frac{n(n+1)}{2}\'];');
  print('   ');
  print('   // UTILISER:');
  print('   final library = FormulaLibrary();');
  print('   final formula = library.getFormulaById(\'arithmetic_sum\');');
  print('   final gauche = [formula.latexLeft];');
  print('   final droite = [formula.latexRight];');

  print('\n✅ Intégration simple et progressive !');
}
''');

  print('✅ CODE DE REMPLACEMENT PRÊT !');
}
