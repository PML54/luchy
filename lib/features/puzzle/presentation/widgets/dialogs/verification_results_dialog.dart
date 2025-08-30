/// <cursor>
/// LUCHY - Dialog de résultats pour puzzles éducatifs
///
/// Widget de dialog affichant les résultats d'un puzzle éducatif :
/// nombre de bonnes réponses et temps de résolution.
///
/// COMPOSANTS PRINCIPAUX:
/// - VerificationResultsDialog: Dialog principal des résultats
/// - Affichage score: X/Y réponses correctes
/// - Affichage temps: Durée en secondes ou millisecondes
/// - Boutons: OK, Recommencer
///
/// ÉTAT ACTUEL:
/// - Interface: Material Design 3 avec icônes
/// - Animations: Smooth transitions
/// - Format temps: Adaptatif selon durée
/// - Actions: Fermeture et recommencer
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création pour remplacer compteur en temps réel
/// - Intégration système vérification manuelle puzzles éducatifs
///
/// 🔧 POINTS D'ATTENTION:
/// - UX: Dialog clair et encourageant
/// - Performance: Affichage temps optimisé
/// - Responsive: Adaptation tailles écran
/// - Accessibilité: Support lecteurs écran
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations de célébration pour score parfait
/// - Support statistiques détaillées
/// - Personnalisation messages selon performance
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/widgets/toolbar/educational_appbar.dart: Bouton vérification
/// - features/puzzle/domain/providers/game_providers.dart: Logique timer
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Intégration
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Feedback utilisateur essentiel)
/// 📅 Dernière modification: 2025-01-27 21:30
/// </cursor>

import 'package:flutter/material.dart';

/// Dialog affichant les résultats d'un puzzle éducatif
class VerificationResultsDialog extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final Duration elapsedTime;

  const VerificationResultsDialog({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    final scorePercentage = (correctAnswers / totalQuestions * 100).round();
    final isPerfectScore = correctAnswers == totalQuestions;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            isPerfectScore ? Icons.star : Icons.school,
            color: isPerfectScore ? Colors.amber : Colors.blue,
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            isPerfectScore ? 'Parfait !' : 'Résultats',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isPerfectScore ? Colors.amber[700] : Colors.blue[700],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  '$correctAnswers/$totalQuestions',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'réponses correctes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pourcentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(scorePercentage).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$scorePercentage%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(scorePercentage),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Temps
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  color: Colors.orange[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(elapsedTime),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Message d'encouragement
          Text(
            _getEncouragementMessage(scorePercentage),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('restart'),
          child: const Text(
            'Recommencer',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop('ok'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Formate la durée selon sa longueur
  String _formatTime(Duration duration) {
    if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}min ${seconds}s';
    } else if (duration.inSeconds >= 10) {
      return '${duration.inSeconds}s';
    } else {
      final milliseconds = duration.inMilliseconds;
      final seconds = (milliseconds / 1000).toStringAsFixed(1);
      return '${seconds}s';
    }
  }

  /// Retourne la couleur selon le score
  Color _getScoreColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  /// Message d'encouragement selon le score
  String _getEncouragementMessage(int percentage) {
    if (percentage == 100)
      return 'Excellent ! Toutes les réponses sont correctes ! 🎉';
    if (percentage >= 90) return 'Très bien ! Presque parfait ! 👍';
    if (percentage >= 70) return 'Bien joué ! Continuez comme ça ! 💪';
    if (percentage >= 50) return 'Pas mal ! Encore un petit effort ! 📚';
    return 'Ne vous découragez pas ! La pratique fait la perfection ! 🎯';
  }
}

