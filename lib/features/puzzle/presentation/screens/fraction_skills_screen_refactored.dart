/// <cursor>
///
/// ÉCRAN QUIZ HABILETÉ FRACTIONS REFACTORISÉ
///
/// Interface de quiz pour les opérations sur les fractions utilisant les widgets communs.
/// Utilise common_skills_widgets.dart pour une cohérence parfaite.
///
/// COMPOSANTS PRINCIPAUX:
/// - FractionSkillsScreenRefactored: Écran principal du quiz fractions
/// - Utilisation des widgets communs: SkillsPuzzleGrid, SkillsOperationItem, etc.
/// - FractionSkillsGenerator: Générateur d'opérations sur fractions
/// - LaTeX Rendering: Affichage des opérations avec flutter_math_fork
///
/// ÉTAT ACTUEL:
/// - Interface utilisant les widgets communs
/// - Gestion des fractions irréductibles
/// - Système de validation des résultats fractionnaires
/// - Code simplifié grâce aux widgets communs
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de la version refactorisée
/// - Utilisation des widgets communs pour la cohérence
/// - Simplification du code grâce aux composants partagés
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork pour le rendu LaTeX
/// - Gestion des résultats fractionnaires (pas entiers)
/// - Validation des fractions irréductibles
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Remplacer l'ancien écran par cette version
/// - Tests d'intégration
/// - Optimisations des performances
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/presentation/widgets/common_skills_widgets.dart: Widgets communs
/// - lib/core/operations/fraction_skills_engine.dart: Moteur d'opérations fractions
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/operations/fraction_skills_engine.dart';
import '../widgets/common_skills_widgets.dart';

class FractionSkillsScreenRefactored extends ConsumerStatefulWidget {
  const FractionSkillsScreenRefactored({super.key});

  @override
  ConsumerState<FractionSkillsScreenRefactored> createState() =>
      _FractionSkillsScreenRefactoredState();
}

class _FractionSkillsScreenRefactoredState
    extends ConsumerState<FractionSkillsScreenRefactored> {
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
      debugPrint('Erreur lors de l\'initialisation du quiz: $e');
      _quizData = [];
      _itemCount = 0;
      _leftArrangement = [];
      _rightArrangement = [];
    }
  }

  void _generateNewQuiz() {
    try {
      _quizData = FractionSkillsGenerator.generateQuiz();
      _itemCount = _quizData.length;
      _initializePuzzle();
    } catch (e) {
      debugPrint('Erreur lors de la génération du quiz fractions: $e');
      _quizData = [];
      _itemCount = 0;
    }
  }

  void _initializePuzzle() {
    _leftArrangement = [];
    _rightArrangement = [];
    SkillsUtils.initializePuzzle(
        _leftArrangement, _rightArrangement, _itemCount);
  }

  void _swapRightItems(int fromIndex, int toIndex) {
    setState(() {
      final temp = _rightArrangement[fromIndex];
      _rightArrangement[fromIndex] = _rightArrangement[toIndex];
      _rightArrangement[toIndex] = temp;
    });
  }

  int _getCorrectCount() {
    return SkillsUtils.getCorrectCount(
        _quizData, _leftArrangement, _rightArrangement);
  }

  void _showOperationTooltip(Map<String, dynamic> operation) {
    showDialog(
      context: context,
      builder: (context) => SkillsOperationTooltip(operation: operation),
    );
  }

  Widget _buildResultDisplay(Map<String, dynamic> result) {
    final fraction = result['result'] as Fraction?;
    if (fraction == null) {
      return const Text('Erreur', style: TextStyle(color: Colors.red));
    }

    return Math.tex(
      fraction.toLatex(),
      textStyle: TextStyle(
        fontSize: SkillsUtils.getAdaptiveFontSize(context),
        color: Colors.green[800],
      ),
    );
  }

  void _showValidationDialog() {
    final correctCount = _getCorrectCount();
    final totalCount = _itemCount;

    showDialog(
      context: context,
      builder: (context) => SkillsValidationDialog(
        correctCount: correctCount,
        totalCount: totalCount,
        onNewQuiz: () {
          setState(() {
            _generateNewQuiz();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habileté Fractions'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _generateNewQuiz();
              });
            },
            tooltip: 'Nouveau quiz',
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _showValidationDialog,
            tooltip: 'Valider',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_quizData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Erreur lors du chargement du quiz',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Associez les opérations sur les fractions avec leurs résultats',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SkillsPuzzleGrid(
            quizData: _quizData,
            leftArrangement: _leftArrangement,
            rightArrangement: _rightArrangement,
            onSwapRightItems: _swapRightItems,
            onShowOperationTooltip: _showOperationTooltip,
            buildResultDisplay: _buildResultDisplay,
            getAdaptiveFontSize: SkillsUtils.getAdaptiveFontSize,
          ),
        ],
      ),
    );
  }
}
