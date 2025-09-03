/// <cursor>
/// LUCHY - Écran puzzle des formules du binôme de Newton (ARCHITECTURE OOP)
///
/// Puzzle éducatif utilisant la nouvelle architecture orientée objet des formules.
/// Colonne gauche : libellés fixes, Colonne droite : formules déplaçables.
///
/// COMPOSANTS PRINCIPAUX:
/// - BinomeFormulesScreen: Écran puzzle avec grille 2 colonnes
/// - Architecture OOP: Utilisation de MathematicalFormula et FormulaLibrary
/// - Données dynamiques: Formules chargées depuis la bibliothèque unifiée
/// - Drag & Drop: Mécanisme de résolution du puzzle préservé
/// - Navigation: Intégré dans le système de puzzles éducatifs
///
/// ÉTAT ACTUEL:
/// - Architecture OOP: Migration complète vers la nouvelle architecture
/// - Rendu LaTeX: flutter_math_fork pour affichage natif des formules
/// - Puzzle interactif: Glisser-déposer fonctionnel
/// - Bibliothèque unifiée: 25 formules organisées par catégories
/// - Validation: Détection automatique de completion
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Migration vers architecture orientée objet
/// - Intégration FormulaLibrary avec 25 formules
/// - Conservation du mécanisme drag & drop
/// - Rendu LaTeX préservé et optimisé
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork requise
/// - Performance drag & drop sur mobile
/// - Initialisation FormulaLibrary obligatoire
/// - Taille des formules adaptée aux cellules
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter score et timing
/// - Intégrer avec système éducatif global
/// - Ajouter animations de réussite
/// - Optimiser le chargement des formules
///
/// 🔗 FICHIERS LIÉS:
/// - core/formulas/prepa_math_engine.dart: Nouvelle architecture unifiée
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Navigation
/// - core/utils/educational_image_generator.dart: Configuration
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Puzzle LaTeX avec architecture moderne)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/formulas/prepa_math_engine.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';

/// =====================================================================================
/// NOUVELLE ARCHITECTURE - Chargement dynamique des formules
/// =====================================================================================

/// Bibliothèque unifiée des formules mathématiques (concaténation des 3 catégories)
class UnifiedMathFormulaManager {
  static List<EnhancedFormulaTemplate> _prepaUnifiedFormulas = [];

  /// Initialiser avec les formules de la nouvelle architecture
  static void initialize() {
    if (_prepaUnifiedFormulas.isEmpty) {
      // Utiliser la nouvelle architecture PrepaMathFormulaManager
      _prepaUnifiedFormulas = [
        ...PrepaMathFormulaManager.binomeFormulas,
        ...PrepaMathFormulaManager.combinaisonsFormulas,
        ...PrepaMathFormulaManager.sommesFormulas,
      ];

      print('🎯 UnifiedMathFormulaManager (NOUVELLE ARCHITECTURE):');
      print('   • Binôme: ${PrepaMathFormulaManager.binomeFormulas.length}');
      print(
          '   • Combinaisons: ${PrepaMathFormulaManager.combinaisonsFormulas.length}');
      print('   • Sommes: ${PrepaMathFormulaManager.sommesFormulas.length}');
      print('   • Prépa unifié: ${_prepaUnifiedFormulas.length} formules');
    }
  }

  /// Obtenir les formules unifiées de prépa (concaténation des 3 catégories)
  static List<EnhancedFormulaTemplate> get prepaUnifiedFormulas =>
      _prepaUnifiedFormulas;

  /// Obtenir les formules binôme
  static List<EnhancedFormulaTemplate> get binomeFormulas =>
      PrepaMathFormulaManager.binomeFormulas;

  /// Obtenir les formules de combinaisons
  static List<EnhancedFormulaTemplate> get combinaisonsFormulas =>
      PrepaMathFormulaManager.combinaisonsFormulas;

  /// Obtenir les formules de sommes
  static List<EnhancedFormulaTemplate> get sommesFormulas =>
      PrepaMathFormulaManager.sommesFormulas;
}

/// =====================================================================================
/// NOUVELLES FONCTIONS DE COMPATIBILITÉ - Nouvelle Architecture
/// =====================================================================================

/// Fonctions utilisant le nouveau système de codes quiz (mode mixte par défaut)
/// Ces fonctions utilisent QuizGenerator avec mode mixte (code 2)
List<String> get _binomeLatexGaucheComplete {
  // Utiliser le nouveau système de quiz avec toutes les catégories en mode mixte
  final quizFormulas = QuizGenerator.generateQuiz(const QuizConfiguration(
    mode: QuizMode.mixte, // Mode mixte (code 2)
    questionCount: 12, // Plus de formules pour avoir du choix
  ));
  
  print('🎮 Formules chargées en mode mixte: ${quizFormulas.length}');
  
  return quizFormulas.map((f) {
    // Utiliser la propriété leftSide qui gère automatiquement leftLatex ou split
    return f.leftSide;
  }).toList();
}

List<String> get _binomeLatexDroiteComplete {
  // Utiliser le nouveau système de quiz avec toutes les catégories en mode mixte
  final quizFormulas = QuizGenerator.generateQuiz(const QuizConfiguration(
    mode: QuizMode.mixte, // Mode mixte (code 2)
    questionCount: 12, // Plus de formules pour avoir du choix
  ));
  
  return quizFormulas.map((f) {
    // Utiliser la propriété rightSide qui gère automatiquement rightLatex ou split
    return f.rightSide;
  }).toList();
}

List<String> get _binomeUsage2MotsComplete {
  // Utiliser le nouveau système de quiz avec toutes les catégories en mode mixte
  final quizFormulas = QuizGenerator.generateQuiz(const QuizConfiguration(
    mode: QuizMode.mixte, // Mode mixte (code 2)
    questionCount: 12, // Plus de formules pour avoir du choix
  ));
  
  return quizFormulas.map((f) => f.description).toList();
}

/// Fonction pour sélectionner 6 questions aléatoires avec résultats ET formules uniques
List<int> _selectRandomQuestions() {
  final random = Random();
  final availableIndices =
      List.generate(_binomeLatexGaucheComplete.length, (i) => i);
  final selectedIndices = <int>[];
  final usedLeftFormulas =
      <String>{}; // Pour éviter les doublons dans la colonne gauche
  final usedRightResults =
      <String>{}; // Pour éviter les doublons dans la colonne droite

  // Mélanger les indices disponibles
  availableIndices.shuffle(random);

  // Sélectionner jusqu'à 6 questions avec formules ET résultats uniques
  for (final index in availableIndices) {
    if (selectedIndices.length >= 6) break;

    final leftFormula = _binomeLatexGaucheComplete[index];
    final rightResult = _binomeLatexDroiteComplete[index];

    // Vérifier si cette formule OU ce résultat n'a pas déjà été utilisé
    if (!usedLeftFormulas.contains(leftFormula) &&
        !usedRightResults.contains(rightResult)) {
      selectedIndices.add(index);
      usedLeftFormulas.add(leftFormula);
      usedRightResults.add(rightResult);

      // Debug: afficher ce qui est sélectionné
      print('🎯 Sélectionnée: $leftFormula = $rightResult');
    } else {
      // Debug: afficher ce qui est rejeté et pourquoi
      final reason = usedLeftFormulas.contains(leftFormula)
          ? 'formule gauche déjà utilisée'
          : 'résultat droite déjà utilisé';
      print('❌ Rejetée ($reason): $leftFormula = $rightResult');
    }
  }

  print(
      '📊 Sélection finale: ${selectedIndices.length} formules avec ${usedLeftFormulas.length} formules uniques et ${usedRightResults.length} résultats uniques');
  return selectedIndices;
}

/// Fonction de secours si on n'a pas assez de résultats uniques
List<int> _selectRandomQuestionsFallback() {
  print(
      '⚠️ Pas assez de résultats uniques, utilisation de la méthode classique');
  final random = Random();
  final availableIndices =
      List.generate(_binomeLatexGaucheComplete.length, (i) => i);
  availableIndices.shuffle(random);
  return availableIndices.take(6).toList();
}

/// Variables globales pour la sélection actuelle
late List<int> _currentSelection;
late List<String> binomeLatexGauche;
late List<String> binomeLatexDroite;
late List<String> binomeUsage2Mots;

/// Écran puzzle des formules du binôme de Newton
class BinomeFormulesScreen extends ConsumerStatefulWidget {
  const BinomeFormulesScreen({super.key});

  @override
  ConsumerState<BinomeFormulesScreen> createState() =>
      _BinomeFormulesScreenState();
}

class _BinomeFormulesScreenState extends ConsumerState<BinomeFormulesScreen> {
  late List<int> _leftArrangement;
  late List<int> _rightArrangement;
  late int _itemCount;
  int?
      _showingDefinitionIndex; // Index de la cellule gauche qui affiche la définition
  DateTime? _startTime; // Heure de début du puzzle

  @override
  void initState() {
    super.initState();

    // Initialiser la bibliothèque unifiée avec concaténation des 3 catégories
    UnifiedMathFormulaManager.initialize();

    _initializeQuestions();
    _initializePuzzle();
    _startTime = DateTime.now(); // Démarrer le chronométrage
  }

  void _initializeQuestions() {
    // Sélectionner 6 questions aléatoires avec résultats uniques
    _currentSelection = _selectRandomQuestions();

    // Si on n'a pas assez de questions (moins de 6), utiliser la méthode de secours
    if (_currentSelection.length < 6) {
      print(
          '⚠️ Seulement ${_currentSelection.length} questions uniques trouvées, utilisation de la méthode de secours');
      _currentSelection = _selectRandomQuestionsFallback();
    }

    _itemCount = _currentSelection.length;

    // Créer les listes filtrées
    binomeLatexGauche =
        _currentSelection.map((i) => _binomeLatexGaucheComplete[i]).toList();
    binomeLatexDroite =
        _currentSelection.map((i) => _binomeLatexDroiteComplete[i]).toList();
    binomeUsage2Mots =
        _currentSelection.map((i) => _binomeUsage2MotsComplete[i]).toList();

    print('✅ Questions initialisées: $_itemCount formules chargées');
  }

  void _initializePuzzle() {
    // Créer l'arrangement initial
    _leftArrangement = List.generate(_itemCount, (index) => index);
    _rightArrangement = List.generate(_itemCount, (index) => index);

    // Mélanger seulement la colonne droite (formules LaTeX)
    _rightArrangement.shuffle();

    // Réinitialiser l'affichage des définitions
    _showingDefinitionIndex = null;
  }

  void _renewQuestions() {
    setState(() {
      _initializeQuestions();
      _initializePuzzle();
      _startTime = DateTime.now(); // Redémarrer le chronométrage
    });
  }

  /// Calcule le temps écoulé depuis le début du puzzle
  Duration _getElapsedTime() {
    if (_startTime == null) {
      return Duration.zero;
    }
    return DateTime.now().difference(_startTime!);
  }

  /// Calcule la taille de police adaptée selon la taille de l'écran
  double _getAdaptiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600 || screenHeight > 800;

    if (isTablet) {
      // Tailles beaucoup plus grandes pour tablettes
      if (screenWidth >= 1200) {
        return 40.0; // Très grande tablette/desktop - augmentée
      } else if (screenWidth >= 900) {
        return 36.0; // Grande tablette - augmentée
      } else {
        return 32.0; // Tablette moyenne - augmentée
      }
    } else {
      // Taille standard pour smartphones - augmentée
      return 20.0; // Augmentée de 16 à 20 pour compenser flutter_math_fork
    }
  }

  /// Quitter le puzzle LaTeX et revenir au mode puzzle normal 3x3
  Future<void> _quitToNormalPuzzle() async {
    try {
      // Remettre la difficulté par défaut 3x3
      await ref.read(gameSettingsProvider.notifier).setDifficulty(3, 3);

      // Passer en mode puzzle normal (type 1)
      await ref.read(gameSettingsProvider.notifier).setPuzzleType(1);

      // Charger une image aléatoire normale
      await ref.read(imageControllerProvider.notifier).loadRandomImage();

      // Revenir à l'écran précédent
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Erreur lors de la sortie du puzzle LaTeX: $e');
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _toggleDefinition(int index) {
    setState(() {
      if (_showingDefinitionIndex == index) {
        _showingDefinitionIndex = null; // Cacher si déjà affiché
      } else {
        _showingDefinitionIndex = index; // Afficher la définition
      }
    });
  }

  void _swapRightItems(int index1, int index2) {
    setState(() {
      final temp = _rightArrangement[index1];
      _rightArrangement[index1] = _rightArrangement[index2];
      _rightArrangement[index2] = temp;
    });
  }

  int _getCorrectCount() {
    int correctCount = 0;
    for (int i = 0; i < _itemCount; i++) {
      if (_rightArrangement[i] == i) {
        correctCount++;
      }
    }
    return correctCount;
  }

  @override
  Widget build(BuildContext context) {
    assert(binomeLatexGauche.length == binomeLatexDroite.length,
        'Listes binomeLatexGauche et binomeLatexDroite doivent avoir la même longueur');
    assert(binomeLatexGauche.length == binomeUsage2Mots.length,
        'Listes binomeLatexGauche et binomeUsage2Mots doivent avoir la même longueur');

    return WillPopScope(
      onWillPop: () async {
        await _quitToNormalPuzzle();
        return false; // Empêcher le pop automatique car on l'a géré manuellement
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _quitToNormalPuzzle,
          ),
          title: const Text(
            'Binôme de Newton',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              onPressed: () {
                final correctCount = _getCorrectCount();
                final elapsedTime = _getElapsedTime();
                final minutes = elapsedTime.inMinutes;
                final seconds = elapsedTime.inSeconds % 60;
                final timeString =
                    minutes > 0 ? '${minutes}min ${seconds}s' : '${seconds}s';

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Résultats'),
                    content: Text(
                      'Bonnes réponses : $correctCount/$_itemCount\n'
                      'Temps écoulé : $timeString\n'
                      '${correctCount == _itemCount ? "🎉 Parfait !" : "Continuez !"}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _renewQuestions,
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Grille du puzzle
              GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colonnes
                  childAspectRatio: MediaQuery.of(context).size.width > 600
                      ? 3.0
                      : 2.0, // Plus large sur tablette
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _itemCount * 2, // 2 colonnes
                itemBuilder: (context, index) {
                  final row = index ~/ 2;
                  final col = index % 2;

                  if (col == 0) {
                    // Colonne gauche : formules LaTeX gauche (fixes, cliquables)
                    return GestureDetector(
                      onTap: () => _toggleDefinition(row),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: _showingDefinitionIndex == row
                              ? Colors.orange[
                                  100] // Surligné si définition affichée
                              : Colors.blue[50],
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width > 600
                                ? 12.0
                                : 6.0),
                        child: Stack(
                          children: [
                            // Formule LaTeX principale
                            Center(
                              child: Math.tex(
                                binomeLatexGauche[_leftArrangement[row]],
                                textStyle: TextStyle(
                                    fontSize: _getAdaptiveFontSize(context)),
                              ),
                            ),
                            // Overlay avec définition si activé
                            if (_showingDefinitionIndex == row)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(230),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Center(
                                    child: Text(
                                      binomeUsage2Mots[_leftArrangement[row]],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Colonne droite : formules LaTeX (déplaçables)
                    final formulaIndex = _rightArrangement[row];
                    return DragTarget<int>(
                      onAcceptWithDetails: (details) {
                        _swapRightItems(row, details.data);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Draggable<int>(
                          data: row,
                          feedback: Material(
                            child: Container(
                              width: 180,
                              height: 90,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width > 600
                                      ? 12.0
                                      : 6.0),
                              child: Center(
                                child: Math.tex(
                                  binomeLatexDroite[formulaIndex],
                                  textStyle: TextStyle(
                                      fontSize: _getAdaptiveFontSize(context)),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width > 600
                                    ? 12.0
                                    : 6.0),
                            child: Center(
                              child: Math.tex(
                                binomeLatexDroite[formulaIndex],
                                textStyle: TextStyle(
                                    fontSize: _getAdaptiveFontSize(context)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),

              // Pas de message automatique - l'utilisateur doit valider lui-même
            ],
          ),
        ),
      ),
    );
  }
}

/// Fonction utilitaire pour affichage console (debug)
void printBinomeFormulesInConsole() {
  for (int i = 0; i < binomeLatexGauche.length; i++) {
    final gauche = binomeLatexGauche[i];
    final droite = binomeLatexDroite[i];
    final tag = binomeUsage2Mots[i];
    // ignore: avoid_print
    print('$gauche = $droite  |  $tag');
  }
}
