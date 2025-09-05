/// <cursor>
///
/// WIDGETS COMMUNS POUR LES QUIZ HABILETÉ
///
/// Widgets communs réutilisables pour tous les quiz "Habileté".
/// Définit les composants partagés pour une cohérence parfaite.
///
/// COMPOSANTS PRINCIPAUX:
/// - SkillsPuzzleGrid: Grille de puzzle commune
/// - SkillsOperationItem: Item d'opération commun
/// - SkillsResultItem: Item de résultat commun
/// - SkillsValidationDialog: Dialog de validation commun
///
/// ÉTAT ACTUEL:
/// - Widgets communs définis
/// - Réutilisables dans tous les quiz
/// - Interface cohérente garantie
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création des widgets communs
/// - Définition des composants partagés
/// - Structure pour la réutilisation
///
/// 🔧 POINTS D'ATTENTION:
/// - Généricité pour supporter différents types de données
/// - Widgets communs pour la cohérence
/// - Extensibilité pour de nouveaux quiz
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans les écrans existants
/// - Tests d'intégration
/// - Optimisations des performances
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/presentation/screens/numerical_skills_screen.dart: Écran numérique
/// - lib/features/puzzle/presentation/screens/fraction_skills_screen.dart: Écran fractions
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (4/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Grille de puzzle commune pour les quiz Habileté
class SkillsPuzzleGrid extends StatelessWidget {
  final List<Map<String, dynamic>> quizData;
  final List<int> leftArrangement;
  final List<int> rightArrangement;
  final Function(int, int) onSwapRightItems;
  final Function(Map<String, dynamic>) onShowOperationTooltip;
  final Widget Function(Map<String, dynamic>) buildResultDisplay;
  final double Function(BuildContext) getAdaptiveFontSize;

  const SkillsPuzzleGrid({
    super.key,
    required this.quizData,
    required this.leftArrangement,
    required this.rightArrangement,
    required this.onSwapRightItems,
    required this.onShowOperationTooltip,
    required this.buildResultDisplay,
    required this.getAdaptiveFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: quizData.length,
      itemBuilder: (context, index) {
        return _buildPuzzleItem(context, index);
      },
    );
  }

  Widget _buildPuzzleItem(BuildContext context, int index) {
    final leftOperation = quizData[leftArrangement[index]];
    final rightResult = quizData[rightArrangement[index]];

    return Row(
      children: [
        // Colonne gauche : Opérations LaTeX
        Expanded(
          child: SkillsOperationItem(
            operation: leftOperation,
            onTap: () => onShowOperationTooltip(leftOperation),
            getAdaptiveFontSize: getAdaptiveFontSize,
          ),
        ),
        const SizedBox(width: 8),
        // Colonne droite : Résultats
        Expanded(
          child: SkillsResultItem(
            result: rightResult,
            index: index,
            onSwap: onSwapRightItems,
            buildResultDisplay: buildResultDisplay,
            getAdaptiveFontSize: getAdaptiveFontSize,
          ),
        ),
      ],
    );
  }
}

/// Item d'opération commun
class SkillsOperationItem extends StatelessWidget {
  final Map<String, dynamic> operation;
  final VoidCallback onTap;
  final double Function(BuildContext) getAdaptiveFontSize;

  const SkillsOperationItem({
    super.key,
    required this.operation,
    required this.onTap,
    required this.getAdaptiveFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Center(
          child: Math.tex(
            operation['latex'] ?? '\\text{Erreur}',
            textStyle: TextStyle(
              fontSize: getAdaptiveFontSize(context),
              color: Colors.blue[800],
            ),
          ),
        ),
      ),
    );
  }
}

/// Item de résultat commun
class SkillsResultItem extends StatelessWidget {
  final Map<String, dynamic> result;
  final int index;
  final Function(int, int) onSwap;
  final Widget Function(Map<String, dynamic>) buildResultDisplay;
  final double Function(BuildContext) getAdaptiveFontSize;

  const SkillsResultItem({
    super.key,
    required this.result,
    required this.index,
    required this.onSwap,
    required this.buildResultDisplay,
    required this.getAdaptiveFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        onSwap(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 120,
              height: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Center(
                child: buildResultDisplay(result),
              ),
            ),
          ),
          childWhenDragging: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: const Center(
              child: Icon(Icons.drag_indicator, color: Colors.grey),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHovering ? Colors.green[100] : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovering ? Colors.green[300]! : Colors.green[200]!,
                width: isHovering ? 2 : 1,
              ),
            ),
            child: Center(
              child: buildResultDisplay(result),
            ),
          ),
        );
      },
    );
  }
}

/// Dialog de validation commun
class SkillsValidationDialog extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final VoidCallback onNewQuiz;

  const SkillsValidationDialog({
    super.key,
    required this.correctCount,
    required this.totalCount,
    required this.onNewQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        totalCount > 0 ? (correctCount / totalCount * 100).round() : 0;

    return AlertDialog(
      title: const Text('Résultats'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bonnes réponses : $correctCount / $totalCount'),
          const SizedBox(height: 8),
          Text('Pourcentage : $percentage%'),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: correctCount / totalCount,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage >= 80
                  ? Colors.green
                  : percentage >= 60
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNewQuiz();
          },
          child: const Text('Nouveau quiz'),
        ),
      ],
    );
  }
}

/// Tooltip d'opération commun
class SkillsOperationTooltip extends StatelessWidget {
  final Map<String, dynamic> operation;

  const SkillsOperationTooltip({
    super.key,
    required this.operation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}

/// Fonctions utilitaires communes
class SkillsUtils {
  /// Calcule le nombre de bonnes réponses
  static int getCorrectCount(
    List<Map<String, dynamic>> quizData,
    List<int> leftArrangement,
    List<int> rightArrangement,
  ) {
    int correctCount = 0;
    for (int i = 0; i < quizData.length; i++) {
      try {
        final leftOperation = quizData[leftArrangement[i]];
        final rightResult = quizData[rightArrangement[i]]['result'];

        if (leftOperation['result'].toString() == rightResult.toString()) {
          correctCount++;
        }
      } catch (e) {
        debugPrint('Erreur dans getCorrectCount: $e');
        continue;
      }
    }
    return correctCount;
  }

  /// Calcule la taille de police adaptative
  static double getAdaptiveFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return 18.0;
    } else if (width > 400) {
      return 16.0;
    } else {
      return 14.0;
    }
  }

  /// Initialise les arrangements du puzzle
  static void initializePuzzle(
    List<int> leftArrangement,
    List<int> rightArrangement,
    int itemCount,
  ) {
    leftArrangement.clear();
    rightArrangement.clear();
    leftArrangement.addAll(List.generate(itemCount, (index) => index));
    rightArrangement.addAll(List.generate(itemCount, (index) => index));
    leftArrangement.shuffle();
    rightArrangement.shuffle();
  }
}
