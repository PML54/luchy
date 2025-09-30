/// <cursor>
///
/// modern_math_skills_screen.dart
/// features/puzzle/presentation/screens/
///
/// ÉCRAN MODERN MATH SKILLS - SYSTÈME EXACT UNIFIÉ AVEC CHRONOMÉTRAGE ET SQLITE
///
/// Interface moderne pour les quiz mathématiques avec exact_math_engine.dart UNIQUEMENT.
/// Structure identique aux anciens quiz : 2 colonnes avec réorganisation de la colonne droite.
/// Formules LaTeX à gauche (fixes), résultats à droite (réorganisables par drag & drop).
/// NOUVEAU : Chronométrage intégré avec sauvegarde SQLite automatique des records.
///

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/database/database_service.dart';
import 'package:luchy/core/formulas/prepa_math_engine.dart';
import 'package:luchy/core/operations/exact_math_engine.dart';
import 'package:luchy/core/progression/progression_manager.dart';
import 'package:luchy/core/quiz/quiz_score.dart';
import 'package:luchy/core/quiz/quiz_score_service.dart';
import 'package:luchy/core/thema/thema_manager.dart';
import 'package:luchy/core/timing/math_timer.dart';
import 'package:luchy/features/puzzle/presentation/widgets/math_timer_widget.dart';

class ModernMathSkillsScreen extends ConsumerStatefulWidget {
  const ModernMathSkillsScreen({super.key});

  @override
  ConsumerState<ModernMathSkillsScreen> createState() =>
      _ModernMathSkillsScreenState();
}

class _ModernMathSkillsScreenState
    extends ConsumerState<ModernMathSkillsScreen> {
  List<QuizItemExact> _operations = [];
  List<String> _results = [];
  List<int> _rightArrangement = [];
  int _itemCount = 5;
  bool _showValidation = false;
  late ProgressionManager _progressionManager;
  late MathTimer _mathTimer;
  late ThemaManager _themaManager;
  late DatabaseService _databaseService;
  bool _quizStarted = false;
  late AudioPlayer _audioPlayer;
  bool _showSuccessAnimation = false;
  bool _showFailureAnimation = false;

  @override
  void initState() {
    super.initState();
    _progressionManager = ProgressionManager();
    _mathTimer = MathTimer();
    _themaManager = ThemaManager();
    _databaseService = DatabaseService();
    _audioPlayer = AudioPlayer();
    _initializeProgression();
  }

  @override
  void dispose() {
    _mathTimer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeProgression() async {
    await _progressionManager.loadState();
    await _generateNewQuiz();
  }

  // Méthodes pour les sons et animations
  Future<void> _playSuccessSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/puzgood.mp3'));
    } catch (e) {
      debugPrint('Erreur lecture son succès: $e');
    }
  }

  Future<void> _playFailureSound() async {
    try {
      // Utiliser un son système pour l'échec (plus court et différent)
      await _audioPlayer.play(AssetSource(
          'sounds/puzgood.mp3')); // Temporaire, on peut ajouter un autre son
    } catch (e) {
      debugPrint('Erreur lecture son échec: $e');
    }
  }

  void _triggerSuccessAnimation() {
    setState(() {
      _showSuccessAnimation = true;
    });
    // Masquer l'animation après 1.5 secondes
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showSuccessAnimation = false;
        });
      }
    });
  }

  void _triggerFailureAnimation() {
    setState(() {
      _showFailureAnimation = true;
    });
    // Masquer l'animation après 1.5 secondes
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showFailureAnimation = false;
        });
      }
    });
  }

  Future<void> _generateNewQuiz() async {
    if (_quizStarted) {
      // Arrêter le quiz précédent
    }

    List<QuizItemExact> newOperations;
    List<String> newResults;

    do {
      newOperations =
          await _generateOperationsForLevel(_progressionManager.currentLevel);
      newResults = newOperations.map((op) => op.answerLatexCanonical).toList();
    } while (_hasDuplicateResults(newResults));

    setState(() {
      _operations = newOperations;
      _results = newResults;

      final realCount = newOperations.length;
      _rightArrangement = List.generate(realCount, (index) => index);

      int shuffleAttempts = 0;
      do {
        _rightArrangement.shuffle();
        shuffleAttempts++;
      } while (_hasCorrectlyPlacedAnswers() && shuffleAttempts < 100);

      if (shuffleAttempts >= 100) {
        print(
            'Impossible de mélanger sans réponse bien placée après 100 tentatives');
      } else {
        print(
            'Mélange réussi après $shuffleAttempts tentatives - Aucune réponse bien placée');
      }

      _showValidation = false;
      _itemCount = realCount;
      _quizStarted = false;
    });

    _startQuiz();

    // Démarrer le timer automatiquement
    if (_mathTimer.state == TimerState.stopped) {
      _mathTimer.start();
      setState(() {});
      debugPrint(
          'Timer maths démarré automatiquement pour ${_progressionManager.currentLevel.name}');
    } else {
      debugPrint('Timer maths déjà en cours: ${_mathTimer.state}');
    }
  }

  void _startQuiz() {
    if (!_quizStarted) {
      _quizStarted = true;
      debugPrint('Quiz démarré');
    }
  }

  bool _hasDuplicateResults(List<String> results) {
    final uniqueResults = results.toSet();
    final hasDuplicates = uniqueResults.length != results.length;

    if (hasDuplicates) {
      print('DOUBLONS DÉTECTÉS: $results');
      print('RÉGÉNÉRATION...');
    }

    return hasDuplicates;
  }

  bool _hasCorrectlyPlacedAnswers() {
    for (int i = 0; i < _rightArrangement.length; i++) {
      if (_rightArrangement[i] == i) {
        return true;
      }
    }
    return false;
  }

  void _checkResults() async {
    if (!_quizStarted) return;

    _quizStarted = false;

    int correctAnswers = 0;
    for (int i = 0; i < _operations.length; i++) {
      if (_rightArrangement[i] == i) {
        correctAnswers++;
      }
    }

    _progressionManager.validateQuiz(correctAnswers, _operations.length);

    // Sauvegarder la session
    await _saveSession(correctAnswers);

    // NOUVEAU: Sauvegarder le score du quiz
    await _saveQuizScore(correctAnswers);

    if (correctAnswers == _operations.length) {
      // Succès - son et animation
      _playSuccessSound();
      _triggerSuccessAnimation();

      // Gérer le timer et les records
      if (_mathTimer.isRunning) {
        final currentLevel = _progressionManager.currentLevel;
        final elapsedTime = _mathTimer.elapsedTime;

        // Vérifier si c'est le niveau maximum personnel de l'élève
        final maxLevelReached =
            await _databaseService.getMaxLevelReached('MATH_HABILETES');
        final isMaxLevel =
            maxLevelReached == null || currentLevel.name == maxLevelReached;

        if (isMaxLevel) {
          // Niveau maximum personnel atteint - sauvegarder le record
          _mathTimer.complete();
          await _saveRecord(currentLevel, elapsedTime);
          debugPrint(
              'Timer maths terminé avec succès au niveau max personnel: ${currentLevel.name}');
        } else {
          // Niveau intermédiaire - sauvegarder le record partiel
          await _saveRecord(currentLevel, elapsedTime);
        }
      }
      await _generateNewQuiz();
    } else {
      // Échec - son et animation
      _playFailureSound();
      _triggerFailureAnimation();

      // Arrêter le timer
      if (_mathTimer.isRunning) {
        _mathTimer.fail();
        debugPrint('Timer maths échoué - première erreur');
      }
      setState(() {
        _showValidation = true;
      });
    }
  }

  // Nouvelle méthode pour sauvegarder les records
  Future<void> _saveRecord(NiveauEducatif level, Duration elapsedTime) async {
    try {
      final timeSeconds = elapsedTime.inSeconds;

      // Vérifier si c'est le niveau maximum personnel
      final maxLevelReached =
          await _databaseService.getMaxLevelReached('MATH_HABILETES');
      final isMaxLevel =
          maxLevelReached == null || level.name == maxLevelReached;

      if (isMaxLevel) {
        // Pour le niveau maximum personnel, vérifier si c'est un nouveau record de temps
        final bestRecord = await _databaseService.getBestRecord();
        final isNewTimeRecord = bestRecord == null ||
            (bestRecord['highest_level_index'] as int == level.index &&
                timeSeconds < (bestRecord['fastest_time_seconds'] as int));

        if (isNewTimeRecord) {
          // Vérifier s'il y avait déjà des records avant (pour éviter signalement au premier démarrage)
          final existingRecords = await _databaseService.getAllRecords();
          final hadPreviousRecords = existingRecords.isNotEmpty;

          await _databaseService.saveRecord(
            levelName: level.name,
            levelIndex: level.index,
            timeSeconds: timeSeconds,
          );

          debugPrint(
              'NOUVEAU RECORD TEMPS: ${level.name} en ${_formatDuration(elapsedTime)}');

          // Afficher une notification de nouveau record seulement s'il y avait déjà des records
          if (hadPreviousRecords) {
            _showNewRecordDialog(level, elapsedTime);
          } else {
            debugPrint('Premier record - pas de signalement');
          }
        } else {
          debugPrint(
              'Niveau max atteint: ${level.name} en ${_formatDuration(elapsedTime)} (pas un record de temps)');
        }
      } else {
        // Pour les niveaux intermédiaires, utiliser l'ancienne logique
        final isNewRecord = await _databaseService.isNewRecord(
          levelIndex: level.index,
          timeSeconds: timeSeconds,
        );

        if (isNewRecord) {
          await _databaseService.saveRecord(
            levelName: level.name,
            levelIndex: level.index,
            timeSeconds: timeSeconds,
          );
          debugPrint(
              'NOUVEAU RECORD: ${level.name} en ${_formatDuration(elapsedTime)}');
        } else {
          debugPrint(
              'Progression: ${level.name} en ${_formatDuration(elapsedTime)} (pas un record)');
        }
      }
    } catch (e) {
      debugPrint('Erreur sauvegarde record: $e');
    }
  }

  // Nouvelle méthode pour sauvegarder les sessions
  Future<void> _saveSession(int correctAnswers) async {
    try {
      final currentLevel = _progressionManager.currentLevel;
      final elapsedTime = _mathTimer.elapsedTime;
      final completedWithoutError = correctAnswers == _operations.length;

      await _databaseService.saveSession(
        levelName: currentLevel.name,
        levelIndex: currentLevel.index,
        timeSeconds: elapsedTime.inSeconds,
        completedWithoutError: completedWithoutError,
      );

      debugPrint(
          'Session sauvegardée: ${currentLevel.name} - ${correctAnswers}/${_operations.length}');
    } catch (e) {
      debugPrint('Erreur sauvegarde session: $e');
    }
  }

  // NOUVEAU: Méthode pour sauvegarder le score du quiz
  Future<void> _saveQuizScore(int correctAnswers) async {
    try {
      final currentLevel = _progressionManager.currentLevel;
      final elapsedTime = _mathTimer.elapsedTime;

      await QuizScoreService.saveQuizScore(
        quizCode: 'MATH_HABILETES',
        quizCategory: 'Mathématiques',
        totalQuestions: _operations.length,
        correctAnswers: correctAnswers,
        durationSeconds: elapsedTime.inSeconds,
        levelName: currentLevel.name,
      );

      debugPrint(
          'Score évaluation sauvegardé: ${correctAnswers}/${_operations.length} (${QuizScoreExtensions.calculateScore20(correctAnswers, _operations.length).toInt()}/20)');
    } catch (e) {
      debugPrint('Erreur sauvegarde score évaluation: $e');
    }
  }

  // Méthode pour formater la durée
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDurationForRecord(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (minutes > 0) {
      return '${minutes} min ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Dialogue pour nouveau record
  void _showNewRecordDialog(NiveauEducatif level, Duration time) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text('Record Battu'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Admission en ${level.nom} en ${_formatDurationForRecord(time)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  String _getClassButtonText() {
    if (_showValidation) {
      return 'Suivant';
    } else {
      return 'Vérifier';
    }
  }

  Future<List<QuizItemExact>> _generateOperationsForLevel(
      NiveauEducatif level) async {
    final levelKey = level.name;
    final levelNumber = level.index + 1;

    print('Génération quiz Thema niveau: $levelKey (niveau $levelNumber)');

    try {
      final quizItems = _themaManager.generateQuizForLevel(levelNumber,
          itemCount: _itemCount);
      print('Quiz généré: ${quizItems.length} questions via Thema');
      return quizItems;
    } catch (e) {
      print('Erreur Thema, fallback vers ancien système: $e');
      return _generateFallbackForLevel(level);
    }
  }

  List<QuizItemExact> _generateFallbackForLevel(NiveauEducatif level) {
    print('Fallback: génération simple pour ${level.name}');
    return List.generate(
        _itemCount, (i) => ExactMathGenerator().genCPAddition());
  }

  void _showProgressionInfo() {
    final requiredGrade = _progressionManager.requiredGradeOut20;
    final nextLevel = _progressionManager.nextLevel;
    final redoublements = _progressionManager.currentState.redoublements;
    final maxRedoublements =
        _progressionManager.currentCriteria.maxRedoublements;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.timeline, color: Colors.green.shade600),
            const SizedBox(width: 8),
            const Text('Ma Progression'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Niveau actuel: ${_progressionManager.currentLevel.nom}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (nextLevel != null)
              Text('Prochain niveau: ${nextLevel.nom}')
            else
              const Text('Niveau maximum !'),
            const SizedBox(height: 8),
            Text('Note requise: $requiredGrade/20'),
            const SizedBox(height: 8),
            if (redoublements > 0)
              Text(
                'Redoublements: $redoublements/$maxRedoublements',
                style: TextStyle(color: Colors.orange.shade600),
              ),
            if (redoublements == 0)
              const Text(
                'Aucun redoublement',
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 8),
            Text(
              'Si échec répété → redescente de classe',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Retour au menu principal',
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _progressionManager.currentLevel.nom,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            if (_progressionManager.currentState.redoublements > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'R${_progressionManager.currentState.redoublements}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            const Spacer(),
            if (_mathTimer.state != TimerState.stopped)
              MathTimerWidget(
                timer: _mathTimer,
                currentLevel: _progressionManager.currentLevel.nom,
              )
            else
              const SizedBox.shrink(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showProgressionInfo,
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Progression',
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Instructions claires pour l'utilisateur
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Rétablis le bon ordre à droite et clique sur Vérifier',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildQuizContent(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showValidation ? _generateNewQuiz : _checkResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _getClassButtonText(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          // Animation de succès
          if (_showSuccessAnimation)
            Positioned.fill(
              child: Container(
                color: Colors.green.withOpacity(0.3),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Bravo !",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Passage en ${_progressionManager.currentLevel.nom}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          // Animation d'échec
          if (_showFailureAnimation)
            Positioned.fill(
              child: Container(
                color: Colors.red.withOpacity(0.3),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Redoublement en ${_progressionManager.currentLevel.nom}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    if (_operations.isEmpty || _results.isEmpty || _rightArrangement.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    return Column(
      children: List.generate(
          _itemCount, (row) => Expanded(child: _buildQuizRow(row))),
    );
  }

  Widget _buildQuizRow(int row) {
    if (row >= _operations.length ||
        row >= _results.length ||
        row >= _rightArrangement.length) {
      return const SizedBox.shrink();
    }

    final isCorrect = _showValidation && _rightArrangement[row] == row;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 80,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showValidation
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.green.shade300,
                  width: _showValidation ? 3 : 1,
                ),
              ),
              child: GestureDetector(
                onTap: () => _showFormulaExplanationTooltip(context, row),
                child: Center(
                  child: Math.tex(
                    _operations[row].getCleanLatex(),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DragTarget<int>(
              onAcceptWithDetails: (details) {
                setState(() {
                  final draggedIndex = details.data;
                  final temp = _rightArrangement[row];
                  final draggedRow = _rightArrangement.indexOf(draggedIndex);
                  _rightArrangement[row] = draggedIndex;
                  _rightArrangement[draggedRow] = temp;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: _rightArrangement[row],
                  feedback: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Math.tex(
                          (_rightArrangement[row] < _results.length
                              ? _results[_rightArrangement[row]]
                              : '...'),
                          textStyle: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Icon(Icons.drag_indicator, color: Colors.grey),
                    ),
                  ),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _showValidation
                            ? (isCorrect ? Colors.green : Colors.red)
                            : Colors.green.shade300,
                        width: _showValidation ? 3 : 1,
                      ),
                    ),
                    child: Center(
                      child: Math.tex(
                        (_rightArrangement[row] < _results.length
                            ? _results[_rightArrangement[row]]
                            : '...'),
                        textStyle: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFormulaExplanationTooltip(BuildContext context, int index) {
    late OverlayEntry overlayEntry;

    final operation = _operations[index];
    final explanation = _generateSimpleExplanation(operation);

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => overlayEntry.remove(),
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Math.tex(
                    operation.getCleanLatex(),
                    textStyle: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      explanation,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Appuyez pour fermer',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  String _generateSimpleExplanation(QuizItemExact operation) {
    final latex = operation.getCleanLatex();

    if (latex.contains(r'\binom') ||
        (latex.contains('(') && latex.contains(')'))) {
      return 'Coefficient binomial\nNombre de combinaisons';
    }

    if (latex.contains(r'\sum')) {
      return 'Somme mathématique\nAddition de termes';
    }

    if (latex.contains('^') && (latex.contains('+') || latex.contains('-'))) {
      return 'Développement du binôme\nFormule de Newton';
    }

    if (latex.contains('+')) {
      return 'Addition\nde deux entiers';
    } else if (latex.contains('-')) {
      return 'Soustraction\nde deux nombres';
    } else if (latex.contains('×') || latex.contains('·')) {
      return 'Multiplication\nde deux nombres';
    }

    if (latex.contains('^') && !latex.contains(r'\sum')) {
      return 'Puissance\nNombre élevé à un exposant';
    }

    return 'Opération mathématique\nCalcul de base';
  }
}

/// <cursor>
///
/// [modern_math_skills_screen.dart]
///
/// [Écran des habiletés mathématiques avec système de chronométrage et progression éducative]
///
/// COMPOSANTS PRINCIPAUX:
/// - ModernMathSkillsScreen: Interface principale des quiz mathématiques
/// - Système de chronométrage avec MathTimer
/// - Progression éducative avec ProgressionManager
/// - Sauvegarde des records en SQLite
/// - Interface drag & drop pour réorganisation des réponses
///
/// ÉTAT ACTUEL:
/// - Interface moderne avec exact_math_engine.dart
/// - Chronométrage automatique des performances
/// - Sauvegarde des records en base de données
/// - Progression par niveaux éducatifs (CP à Bac+)
/// - Messages de record simplifiés
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-28: Format temps explicite "2 min 13s" au lieu de "02:13" dans les records
/// - 2025-09-28: Suppression du signalement de record au premier démarrage
/// - 2025-09-28: Simplification du message de record "Record Battu" + "Admission en [niveau] en [temps]"
/// - 2025-09-28: Amélioration de l'interface de dialogue des records
/// - Intégration complète du système exact_math_engine.dart
/// - Chronométrage et sauvegarde SQLite fonctionnels
/// - 2025-09-29 09:07: TERMINOLOGIE INTERFACE - Remplacement "Correction" par "Vérifier"
/// - Modification du texte du bouton de validation pour une terminologie plus claire
/// - 2025-09-29 09:14: SIMPLIFICATION BOUTON - Suppression affichage classe après erreur
/// - Remplacement affichage classe par "Nouveau Quiz" pour éviter la perturbation
/// - Interface plus claire et moins déroutante pour l'utilisateur
/// - 2025-09-29 09:22: HARMONISATION TERMINOLOGIE - Remplacement "Nouveau Quiz" par "Suivant"
/// - Terminologie unifiée avec les autres quiz pour cohérence interface
/// - 2025-09-29 09:30: SONS ET ANIMATIONS FEEDBACK - Ajout feedback audio/visuel
/// - Son succès et échec avec audioplayers
/// - Animation succès (vert) et échec (rouge) avec TweenAnimationBuilder
/// - Overlay temporaire (1.5s) avec icônes et messages encourageants
/// - Amélioration expérience utilisateur et engagement
/// - 2025-09-29 09:38: MESSAGES NIVEAU PERSONNALISÉS - Messages avec niveau actuel
/// - Succès: "Bravo ! Passage en [niveau]" (ex: "Passage en CE1")
/// - Échec: "Redoublement en [niveau]" (ex: "Redoublement en CP")
/// - Messages contextuels et informatifs pour l'élève
/// - 2025-09-29 09:46: RECORDS NIVEAU MAX PERSONNEL - Sauvegarde temps niveau max individuel
/// - Record sauvegardé quand élève atteint son niveau maximum personnel (pas forcément Bac+2)
/// - Mise à jour automatique si même niveau mais temps meilleur
/// - Logique adaptée: CP max → record CP, CE1 max → record CE1, etc.
/// - Système personnalisé selon progression individuelle de chaque élève
///
/// 🔧 POINTS D'ATTENTION:
/// - Gestion des états de quiz (début, validation, correction)
/// - Synchronisation timer/progression
/// - Sauvegarde asynchrone des records
/// - Interface responsive pour différentes tailles d'écran
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Optimisation des performances de génération
/// - Amélioration de l'UX de progression
/// - Tests de performance sur différents appareils
///
/// 🔗 FICHIERS LIÉS:
/// - exact_math_engine.dart: Moteur de génération des opérations
/// - progression_manager.dart: Gestion des niveaux éducatifs
/// - math_timer.dart: Système de chronométrage
/// - database_service.dart: Sauvegarde des records
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐
/// 📅 Dernière modification: Mon Sep 29 09:46:16 CEST 2025
/// </cursor>
