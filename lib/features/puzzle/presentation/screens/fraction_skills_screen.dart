/// <cursor>
///
/// ÉCRAN QUIZ HABILETÉ FRACTIONS
///
/// Interface de quiz pour les opérations sur les fractions.
/// Structure identique au quiz "Habileté Numérique" : grille 2 colonnes avec drag & drop.
/// Colonne gauche : opérations LaTeX sur fractions (cliquables), Colonne droite : résultats fractionnaires (glissables).
///
/// COMPOSANTS PRINCIPAUX:
/// - FractionSkillsScreen: Écran principal du quiz fractions
/// - FractionSkillsGenerator: Générateur d'opérations sur fractions
/// - GridView: Grille 2 colonnes identique aux autres quiz
/// - LaTeX Rendering: Affichage des opérations avec flutter_math_fork
/// - Validation: Système de validation des résultats fractionnaires
///
/// ÉTAT ACTUEL:
/// - Interface identique au quiz "Habileté Numérique"
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
/// - 2025-01-27: Création de l'écran quiz fractions
/// - Adaptation de la structure GridView 2 colonnes
/// - Intégration du système de validation pour fractions
/// - Ajout des tooltips et de l'AppBar cohérente
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork pour le rendu LaTeX
/// - Structure identique aux autres quiz pour cohérence
/// - Gestion des résultats fractionnaires (pas entiers)
/// - Validation des fractions irréductibles
/// - Niveaux: Facile (4 questions), Moyen (6), Difficile (8)
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégrer avec le système de progression SQLite
/// - Ajouter animations de réussite
/// - Optimiser l'affichage des fractions complexes
/// - Ajouter statistiques par niveau
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/operations/fraction_skills_engine.dart: Moteur d'opérations fractions
/// - lib/features/puzzle/presentation/screens/numerical_skills_screen.dart: Structure de référence
/// - lib/features/puzzle/presentation/widgets/quiz_difficulty_selector.dart: Sélecteur difficulté
/// - lib/core/database/: Système de persistance
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27 22:30
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/operations/fraction_skills_engine.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/widgets/quiz_difficulty_selector.dart';

class FractionSkillsScreen extends ConsumerStatefulWidget {
  const FractionSkillsScreen({super.key});

  @override
  ConsumerState<FractionSkillsScreen> createState() =>
      _FractionSkillsScreenState();
}

class _FractionSkillsScreenState extends ConsumerState<FractionSkillsScreen> {
  late List<Map<String, dynamic>> _quizData;
  late List<int> _leftArrangement;
  late List<int> _rightArrangement;
  late int _itemCount;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    try {
      _generateNewQuiz();
      _startTime = DateTime.now();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation du quiz fractions: $e');
      // Initialiser avec des données par défaut en cas d'erreur
      _quizData = [];
      _itemCount = 0;
      _leftArrangement = [];
      _rightArrangement = [];
    }
  }

  void _generateNewQuiz() {
    try {
      final gameSettings = ref.read(gameSettingsProvider);
      final difficultyLevel = gameSettings.quizDifficultyLevel;

      setState(() {
        _quizData =
            FractionSkillsGenerator.generateAdaptiveQuiz(difficultyLevel);
        _itemCount = _quizData.length;
        _initializePuzzle();
        _startTime = DateTime.now(); // Réinitialiser le temps de départ
      });
    } catch (e) {
      debugPrint('Erreur lors de la génération du quiz: $e');
      setState(() {
        _quizData = [];
        _itemCount = 0;
        _leftArrangement = [];
        _rightArrangement = [];
      });
    }
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
    if (screenWidth > 600) {
      return 24.0; // Tablette - augmenté
    } else if (screenWidth > 400) {
      return 20.0; // Grand téléphone - augmenté
    } else {
      return 18.0; // Petit téléphone - augmenté
    }
  }

  /// Échange deux éléments dans la colonne droite
  void _swapRightItems(int index1, int index2) {
    setState(() {
      final temp = _rightArrangement[index1];
      _rightArrangement[index1] = _rightArrangement[index2];
      _rightArrangement[index2] = temp;

      // Debug: afficher le score après échange
      final score = _getCorrectCount();
      debugPrint('Score après échange: $score/$_itemCount');
    });
  }

  /// Affiche un tooltip avec les détails de l'opération
  void _showOperationTooltip(
      BuildContext context, Map<String, dynamic> operation) {
    // Version simplifiée : seulement l'opération LaTeX
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Math.tex(
            operation['latex'] ?? '\\text{LaTeX non disponible}',
            textStyle: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  /// Quitte vers le puzzle normal
  Future<void> _quitToNormalPuzzle() async {
    Navigator.of(context).pop();
  }

  /// Calcule le nombre de bonnes réponses
  int _getCorrectCount() {
    if (_quizData.isEmpty || _itemCount == 0) return 0;

    int correctCount = 0;
    for (int i = 0; i < _itemCount; i++) {
      try {
        final leftOperation = _quizData[_leftArrangement[i]];
        final rightResult = _quizData[_rightArrangement[i]]['result'];

        // Comparer les fractions en utilisant leur représentation string
        if (leftOperation['result'].toString() == rightResult.toString()) {
          correctCount++;
        }
      } catch (e) {
        debugPrint('Erreur dans _getCorrectCount: $e');
        continue;
      }
    }
    return correctCount;
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si les données du quiz sont valides
    if (_quizData.isEmpty || _itemCount == 0) {
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
            title: const Text(
              'Habileté Fractions',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Erreur lors du chargement du quiz',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Veuillez réessayer',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                      ? 2.5
                      : 1.8, // Plus haut pour plus d'espace
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
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
                                ? 16.0
                                : 12.0),
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
                    // Colonne droite : résultats fractionnaires (glissables)
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
                            child: Math.tex(
                              result.toLatex(),
                              textStyle: const TextStyle(
                                fontSize: 16,
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
                                    ? Colors.green
                                    : Colors.grey[300]!,
                                width: candidateData.isNotEmpty ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: candidateData.isNotEmpty
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width > 600
                                    ? 16.0
                                    : 12.0),
                            child: Center(
                              child: Math.tex(
                                result.toLatex(),
                                textStyle: TextStyle(
                                  fontSize: _getAdaptiveFontSize(context),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
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
              // Pas d'affichage du score pendant le quiz pour ne pas aider l'utilisateur
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
