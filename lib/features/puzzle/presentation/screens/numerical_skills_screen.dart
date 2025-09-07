/// <cursor>
///
/// ÉCRAN QUIZ HABILETÉ NUMÉRIQUE
///
/// Interface de quiz pour les opérations mathématiques de base.
/// Structure identique au quiz "Calcul Prépa" : grille 2 colonnes avec drag & drop.
/// Colonne gauche : opérations LaTeX (cliquables), Colonne droite : résultats numériques (glissables).
///
/// COMPOSANTS PRINCIPAUX:
/// - NumericalSkillsScreen: Écran principal du quiz
/// - OperationsQuizGenerator: Générateur d'opérations mathématiques
/// - GridView: Grille 2 colonnes identique au quiz formules
/// - LaTeX Rendering: Affichage des opérations avec flutter_math_fork
/// - Validation: Système de validation identique au quiz formules
///
/// ÉTAT ACTUEL:
/// - Interface identique au quiz "Calcul Prépa"
/// - Grille 2 colonnes avec GridView.builder
/// - Système de validation avec compteur de bonnes réponses
/// - Tooltips pour afficher les détails des opérations
/// - AppBar bleue avec boutons de validation et refresh
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU - Support niveaux de difficulté pour quizz
/// - Sélecteur de difficulté dans AppBar avec bouton réglages
/// - Indicateur niveau actuel dans titre
/// - Régénération automatique questions selon niveau
/// - 2025-01-27: Refonte complète de l'interface pour correspondre au quiz formules
/// - Adaptation de la structure GridView 2 colonnes
/// - Intégration du système de validation identique
/// - Ajout des tooltips et de l'AppBar cohérente
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork pour le rendu LaTeX
/// - Structure identique au quiz formules pour cohérence
/// - Gestion des opérations complexes (fractions, combinaisons)
/// - Validation des résultats entiers
/// - Niveaux: Facile (4 questions), Moyen (6), Difficile (8)
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégrer avec le système de progression SQLite
/// - Ajouter animations de réussite
/// - Optimiser l'affichage des opérations complexes
/// - Ajouter statistiques par niveau
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/operations/numerical_skills_engine.dart: Moteur d'opérations
/// - lib/features/puzzle/presentation/screens/binome_formules_screen.dart: Structure de référence
/// - lib/features/puzzle/presentation/widgets/quiz_difficulty_selector.dart: Sélecteur difficulté
/// - lib/core/database/: Système de persistance
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27 22:30
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/operations/numerical_skills_engine.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
import 'package:luchy/features/puzzle/presentation/widgets/quiz_difficulty_selector.dart';

class NumericalSkillsScreen extends ConsumerStatefulWidget {
  const NumericalSkillsScreen({super.key});

  @override
  ConsumerState<NumericalSkillsScreen> createState() =>
      _NumericalSkillsScreenState();
}

class _NumericalSkillsScreenState extends ConsumerState<NumericalSkillsScreen> {
  late List<Map<String, dynamic>> _quizData;
  late List<int> _leftArrangement;
  late List<int> _rightArrangement;
  late int _itemCount;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _generateNewQuiz();
    _startTime = DateTime.now();
  }

  void _generateNewQuiz() {
    final gameSettings = ref.read(gameSettingsProvider);
    final difficultyLevel = gameSettings.quizDifficultyLevel;

    setState(() {
      _quizData = OperationsQuizGenerator.generateAdaptiveQuiz(difficultyLevel);
      _itemCount = _quizData.length;
      _initializePuzzle();
      _startTime = DateTime.now(); // Réinitialiser le temps de départ
    });
  }

  void _initializePuzzle() {
    // Créer l'arrangement initial
    _leftArrangement = List.generate(_itemCount, (index) => index);
    _rightArrangement = List.generate(_itemCount, (index) => index);

    // Mélanger seulement la colonne droite (résultats)
    _rightArrangement.shuffle();
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
      if (screenWidth >= 1200) {
        return 40.0;
      } else if (screenWidth >= 900) {
        return 36.0;
      } else {
        return 32.0;
      }
    } else {
      return 20.0;
    }
  }

  /// Quitter le quiz et revenir au mode puzzle normal
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
      debugPrint('Erreur lors de la sortie du quiz: $e');
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Affiche un tooltip avec les détails de l'opération (colonne gauche)
  void _showOperationTooltip(
      BuildContext context, Map<String, dynamic> operation) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => overlayEntry.remove(),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Opération LaTeX
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Math.tex(
                          operation['latex'],
                          textStyle: const TextStyle(fontSize: 22),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          operation['operation'].description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Difficulté
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Difficulté: ${operation['operation'].difficulty}/4',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
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
    return WillPopScope(
      onWillPop: () async {
        await _quitToNormalPuzzle();
        return false;
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
          title: CurrentDifficultyIndicator(
            showIcon: true,
            showDescription: false,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () => _showDifficultySelector(context),
              tooltip: 'Changer le niveau de difficulté',
            ),
            IconButton(
              icon: const Icon(Icons.thumb_up, color: Colors.white),
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
              onPressed: _generateNewQuiz,
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
                    // Colonne gauche : opérations LaTeX (fixes, cliquables)
                    final operation = _quizData[_leftArrangement[row]];
                    return GestureDetector(
                      onTap: () => _showOperationTooltip(context, operation),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[50],
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width > 600
                                ? 12.0
                                : 6.0),
                        child: Center(
                          child: Math.tex(
                            operation['latex'],
                            textStyle: TextStyle(
                                fontSize: _getAdaptiveFontSize(context)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Colonne droite : résultats numériques (glissables)
                    final result = _quizData[_rightArrangement[row]]['result'];
                    return Draggable<int>(
                      data: _rightArrangement[row],
                      feedback: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Center(
                            child: Text(
                              result.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
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
                        child: const Center(
                          child: Icon(Icons.drag_indicator, color: Colors.grey),
                        ),
                      ),
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (data) => true,
                        onAcceptWithDetails: (data) {
                          _swapRightItems(
                              row, _rightArrangement.indexOf(data.data));
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: candidateData.isNotEmpty
                                    ? Colors.blue
                                    : Colors.grey[300]!,
                                width: candidateData.isNotEmpty ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: candidateData.isNotEmpty
                                  ? Colors.blue[50]
                                  : Colors.orange[50],
                            ),
                            child: Center(
                              child: Text(
                                result.toString(),
                                style: TextStyle(
                                  fontSize: _getAdaptiveFontSize(context),
                                  fontWeight: FontWeight.bold,
                                  color: candidateData.isNotEmpty
                                      ? Colors.blue[700]
                                      : Colors.orange[700],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Niveau de difficulté'),
        content: const QuizDifficultySelector(
          showTitle: false,
          cardHeight: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateNewQuiz(); // Régénérer avec le nouveau niveau
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }
}
