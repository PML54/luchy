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

/// Données complètes - Formules LaTeX séparées en parties gauche et droite
final List<String> _binomeLatexGaucheComplete = [
  r'(a+b)^n',
  r'\binom{n}{k}',
  r'\binom{n}{n-k}',
  r'\binom{n-1}{k-1}',
  r'\sum_{k=0}^{n} \binom{n}{k}',
  r'\sum_{k=0}^{n} (-1)^k \binom{n}{k}',
  r'\sum_{k=r}^{n} \binom{k}{r}',
  r'(1+x)^n',
  r'\binom{n}{0}',
  r'\binom{n}{n}',
];

final List<String> _binomeLatexDroiteComplete = [
  r'\sum_{k=0}^{n} \binom{n}{k} a^{\,n-k} b^{\,k}',
  r'\frac{n!}{k!\,(n-k)!}',
  r'\binom{n}{k}',
  r'\binom{n-1}{k} + \binom{n-1}{k-1}',
  r'2^{n}',
  r'0 \quad (n\ge 1)',
  r'\binom{n+1}{r+1} \quad (r\le n)',
  r'\sum_{k=0}^{n} \binom{n}{k} x^{k}',
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

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    _initializePuzzle();
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
    });
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
        title: Text(
          'Binôme Newton (${_getCorrectCount()}/$_itemCount)',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: () {
              final correctCount = _getCorrectCount();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Résultats'),
                  content: Text(
                    'Bonnes réponses : $correctCount/$_itemCount\n'
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 colonnes
                childAspectRatio: 2.0, // Ratio largeur/hauteur
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
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
                            ? Colors
                                .orange[100] // Surligné si définition affichée
                            : Colors.blue[50],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Stack(
                        children: [
                          // Formule LaTeX principale
                          Center(
                            child: Math.tex(
                              binomeLatexGauche[_leftArrangement[row]],
                              textStyle: const TextStyle(fontSize: 14),
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
                              border: Border.all(color: Colors.blue, width: 2),
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
                            padding: const EdgeInsets.all(4),
                            child: Center(
                              child: Math.tex(
                                binomeLatexDroite[formulaIndex],
                                textStyle: const TextStyle(fontSize: 14),
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
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Math.tex(
                              binomeLatexDroite[formulaIndex],
                              textStyle: const TextStyle(fontSize: 14),
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
