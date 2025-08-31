/// <cursor>
/// LUCHY - Écran puzzle des formules du binôme de Newton
///
/// Puzzle éducatif avec formules LaTeX et mécanisme de glisser-déposer.
/// Colonne gauche : libellés fixes, Colonne droite : formules déplaçables.
///
/// COMPOSANTS PRINCIPAUX:
/// - BinomeFormulesScreen: Écran puzzle avec grille 2 colonnes
/// - Données LaTeX: Formules mathématiques avec flutter_math_fork
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
/// - Transformation en puzzle interactif
/// - Intégration drag & drop pour formules LaTeX
/// - Conservation du rendu LaTeX parfait
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork requise
/// - Performance drag & drop sur mobile
/// - Taille des formules adaptée aux cellules
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter score et timing
/// - Intégrer avec système éducatif global
/// - Ajouter animations de réussite
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Navigation
/// - core/utils/educational_image_generator.dart: Configuration
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Puzzle LaTeX unique)
/// 📅 Dernière modification: 2025-01-30 19:00
/// </cursor>

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';

/// Données complètes - Formules LaTeX séparées en parties gauche et droite (variables mélangées)
final List<String> _binomeLatexGaucheComplete = [
  r'(a+b)^p',
  r'\binom{k}{n}',
  r'\binom{p}{p-n}',
  r'\binom{k-1}{n-1}',
  r'\sum_{n=0}^{k} \binom{k}{n}',
  r'\sum_{p=0}^{k} (-1)^p \binom{k}{p}',
  r'\sum_{n=r}^{p} \binom{n}{r}',
  r'(1+x)^k',
  r'\binom{p}{0}',
  r'\binom{k}{k}',
];

final List<String> _binomeLatexDroiteComplete = [
  r'\sum_{n=0}^{p} \binom{p}{n} a^{\,p-n} b^{\,n}',
  r'\frac{k!}{n!\,(k-n)!}',
  r'\binom{p}{n}',
  r'\binom{k-1}{n} + \binom{k-1}{n-1}',
  r'2^{k}',
  r'0 \quad (k\ge 1)',
  r'\binom{p+1}{r+1} \quad (r\le p)',
  r'\sum_{n=0}^{k} \binom{k}{n} x^{n}',
  r'1',
  r'1',
];

final List<String> _binomeUsage2MotsComplete = [
  'développement puissance',
  'calcul coefficient',
  'symétrie coefficients',
  'relation Pascal',
  'comptage sous-ensembles',
  'alternance nulle',
  'somme oblique',
  'série génératrice',
  'cas particulier k=0',
  'cas particulier k=n',
];

/// Fonction pour sélectionner 6 questions aléatoires
List<int> _selectRandomQuestions() {
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
    _initializeQuestions();
    _initializePuzzle();
    _startTime = DateTime.now(); // Démarrer le chronométrage
  }

  void _initializeQuestions() {
    // Sélectionner 6 questions aléatoires
    _currentSelection = _selectRandomQuestions();
    _itemCount = _currentSelection.length;

    // Créer les listes filtrées
    binomeLatexGauche =
        _currentSelection.map((i) => _binomeLatexGaucheComplete[i]).toList();
    binomeLatexDroite =
        _currentSelection.map((i) => _binomeLatexDroiteComplete[i]).toList();
    binomeUsage2Mots =
        _currentSelection.map((i) => _binomeUsage2MotsComplete[i]).toList();
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
        return 32.0; // Très grande tablette/desktop
      } else if (screenWidth >= 900) {
        return 28.0; // Grande tablette
      } else {
        return 24.0; // Tablette moyenne
      }
    } else {
      // Taille standard pour smartphones
      return 16.0; // Légèrement augmentée aussi
    }
  }

  /// Calcule la hauteur adaptée des cellules selon l'écran
  double _getAdaptiveCellHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (isTablet) {
      if (screenWidth >= 1200) {
        return 120.0; // Très grande tablette
      } else if (screenWidth >= 900) {
        return 100.0; // Grande tablette
      } else {
        return 90.0; // Tablette moyenne
      }
    } else {
      return 70.0; // Smartphone
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
    assert(binomeLatexGauche.length == binomeLatexDroite.length,
        'Listes binomeLatexGauche et binomeLatexDroite doivent avoir la même longueur');
    assert(binomeLatexGauche.length == binomeUsage2Mots.length,
        'Listes binomeLatexGauche et binomeUsage2Mots doivent avoir la même longueur');

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

              // Message de completion
              if (isComplete)
                Positioned(
                  left: 20,
                  top: 20,
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange
                            .withAlpha(200), // Couleur Epicerie Luchy
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        "Epicerie Luchy",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
void printBinomeFormulesInConsole() {
  for (int i = 0; i < binomeLatexGauche.length; i++) {
    final gauche = binomeLatexGauche[i];
    final droite = binomeLatexDroite[i];
    final tag = binomeUsage2Mots[i];
    // ignore: avoid_print
    print('$gauche = $droite  |  $tag');
  }
}
