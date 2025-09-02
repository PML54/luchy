/// <cursor>
/// LUCHY - Écran puzzle des formules de sommes pour prépa
///
/// Puzzle éducatif avec formules LaTeX des sommes classiques et mécanisme de glisser-déposer.
/// Colonne gauche : formules LaTeX gauche, Colonne droite : formules LaTeX droite.
///
/// COMPOSANTS PRINCIPAUX:
/// - SommesFormulesScreen: Écran puzzle avec grille 2 colonnes
/// - Données LaTeX: Formules de sommes avec flutter_math_fork
/// - Drag & Drop: Mécanisme de résolution du puzzle
/// - Navigation: Intégré dans le système de puzzles éducatifs
///
/// ÉTAT ACTUEL:
/// - Rendu LaTeX: flutter_math_fork pour affichage natif des formules
/// - Puzzle interactif: Glisser-déposer fonctionnel
/// - UI cohérente: Style adapté à l'app Luchy
/// - Validation: Détection automatique de completion
///
/// HISTORIQUE RÉCENT:
/// - Création basée sur BinomeFormulesScreen
/// - Adaptation aux formules de sommes
/// - Intégration drag & drop pour formules LaTeX
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork requise
/// - Performance drag & drop sur mobile
/// - Taille des formules adaptée aux cellules
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter plus de formules de sommes
/// - Intégrer avec système éducatif global
/// - Ajouter animations de réussite
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Navigation
/// - core/utils/educational_image_generator.dart: Configuration
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Puzzle LaTeX unique)
/// 📅 Dernière modification: 2025-01-30 21:00
/// </cursor>

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/formulas/prepa_math_engine.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';

/// =====================================================================================
/// NOUVELLE ARCHITECTURE - Utilisation de PrepaMathFormulaManager
/// =====================================================================================

/// Fonctions utilisant la nouvelle architecture pour les sommes
List<String> get _sommesLatexGaucheComplete {
  return PrepaMathFormulaManager.sommesFormulas.map((f) {
    // Utiliser leftSideWithVariables pour afficher les variables {VAR:}
    return f.leftSideWithVariables;
  }).toList();
}

List<String> get _sommesLatexDroiteComplete {
  return PrepaMathFormulaManager.sommesFormulas.map((f) {
    // Utiliser rightSideWithVariables pour afficher les variables {VAR:}
    return f.rightSideWithVariables;
  }).toList();
}

List<String> get _sommesUsage2MotsComplete {
  return PrepaMathFormulaManager.sommesFormulas
      .map((f) => f.description)
      .toList();
}

/// Fonction pour sélectionner 6 questions aléatoires
List<int> _selectRandomQuestions() {
  final random = Random();
  final availableIndices =
      List.generate(_sommesLatexGaucheComplete.length, (i) => i);
  availableIndices.shuffle(random);
  return availableIndices.take(6).toList();
}

/// Variables globales pour la sélection actuelle
late List<int> _currentSelection;
late List<String> sommesLatexGauche;
late List<String> sommesLatexDroite;
late List<String> sommesUsage2Mots;

/// Écran puzzle des formules de sommes
class SommesFormulesScreen extends ConsumerStatefulWidget {
  const SommesFormulesScreen({super.key});

  @override
  ConsumerState<SommesFormulesScreen> createState() =>
      _SommesFormulesScreenState();
}

class _SommesFormulesScreenState extends ConsumerState<SommesFormulesScreen> {
  late List<int> _leftArrangement;
  late List<int> _rightArrangement;
  late int _itemCount;
  int?
      _showingDefinitionIndex; // Index de la cellule gauche qui affiche la définition
  DateTime? _startTime; // Heure de début du puzzle

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    _initializePuzzle();
    _startTime = DateTime.now(); // Démarrer le chronométrage
  }

  void _initializeQuestions() {
    // Sélectionner 6 questions aléatoires
    _currentSelection = _selectRandomQuestions();
    _itemCount = _currentSelection.length;

    // Créer les listes filtrées
    sommesLatexGauche =
        _currentSelection.map((i) => _sommesLatexGaucheComplete[i]).toList();
    sommesLatexDroite =
        _currentSelection.map((i) => _sommesLatexDroiteComplete[i]).toList();
    sommesUsage2Mots =
        _currentSelection.map((i) => _sommesUsage2MotsComplete[i]).toList();
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

  bool _isComplete() {
    for (int i = 0; i < _itemCount; i++) {
      if (_rightArrangement[i] != i) return false;
    }
    return true;
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
    assert(sommesLatexGauche.length == sommesLatexDroite.length,
        'Listes sommesLatexGauche et sommesLatexDroite doivent avoir la même longueur');
    assert(sommesLatexGauche.length == sommesUsage2Mots.length,
        'Listes sommesLatexGauche et sommesUsage2Mots doivent avoir la même longueur');

    final isComplete = _isComplete();

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
            'Formules de Sommes',
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
                                sommesLatexGauche[_leftArrangement[row]],
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
                                      sommesUsage2Mots[_leftArrangement[row]],
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
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width > 600
                                    ? 12.0
                                    : 6.0),
                            child: Center(
                              child: Math.tex(
                                sommesLatexDroite[formulaIndex],
                                textStyle: TextStyle(
                                    fontSize: _getAdaptiveFontSize(context)),
                              ),
                            ),
                          ),
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
                                  sommesLatexDroite[formulaIndex],
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
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width > 600
                                    ? 12.0
                                    : 6.0),
                            child: Center(
                              child: Math.tex(
                                sommesLatexDroite[formulaIndex],
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
        floatingActionButton: FloatingActionButton(
          onPressed: _renewQuestions,
          backgroundColor: Colors.orange,
          child: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Nouvelles questions',
        ),
      ),
    );
  }
}

/// Fonction utilitaire pour affichage console (debug)
void printSommesFormulesInConsole() {
  for (int i = 0; i < sommesLatexGauche.length; i++) {
    final gauche = sommesLatexGauche[i];
    final droite = sommesLatexDroite[i];
    final tag = sommesUsage2Mots[i];
    // ignore: avoid_print
    print('$gauche = $droite  |  $tag');
  }
}
