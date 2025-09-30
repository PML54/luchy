/// <cursor>
///
/// quiz_statistics_screen.dart
/// features/quiz/presentation/screens/
///
/// LUCHY - Écran de statistiques des évaluations
///
/// Interface complète pour visualiser les performances et statistiques
/// de toutes les évaluations avec graphiques et détails par catégorie.
///
/// COMPOSANTS PRINCIPAUX:
/// - QuizStatisticsScreen: Écran principal des statistiques
/// - _buildGlobalStats: Statistiques globales (toutes évaluations confondues)
/// - _buildQuizList: Liste des évaluations avec performances individuelles
/// - _buildQuizCard: Carte individuelle pour chaque évaluation
/// - _buildPerformanceChart: Graphique des performances
///
/// ÉTAT ACTUEL:
/// - Interface moderne avec Material Design 3
/// - Statistiques globales et par évaluation
/// - Graphiques de performance
/// - Navigation vers les détails
/// - Gestion des états de chargement
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-29: NIVEAU ÉLÈVE MATHS - Affichage niveau max sans erreur pour les maths
/// - 2025-09-29: ORGANISATION MATIÈRES - "Matières" + tri Maths/Philo/SVT en premier
/// - 2025-09-29: INTERFACE ÉDUCATIVE - "Bulletin de Notes" + "Suivi de l'Élève" + icône école
/// - 2025-09-29: TERMINOLOGIE - Remplacement "Quiz" par "Évaluation" et "Session" par "Contrôle"
/// - 2025-09-29 09:49: TEMPS RECORD MATHS - Affichage temps record pour niveau max
/// - Ajout du temps record sous le niveau de l'élève pour les maths
/// - Format MM:SS avec icône timer et couleur orange
/// - Méthode _getRecordTime() pour récupérer le meilleur temps depuis SQLite
/// - Interface enrichie avec informations de performance temporelle
/// - 2025-01-27: Création de l'écran de statistiques complet
/// - 2025-01-27: Intégration avec QuizScoreService
/// - 2025-01-27: Interface responsive et moderne
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance: Chargement asynchrone des données
/// - Responsive: Adaptation aux différentes tailles d'écran
/// - Navigation: Intégration avec l'architecture existante
/// - Données: Gestion des cas où il n'y a pas de scores
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajout de graphiques avancés (fl_chart)
/// - Export des statistiques
/// - Filtres par période
/// - Comparaisons de performance
///
/// 🔗 FICHIERS LIÉS:
/// - core/quiz/quiz_score_service.dart: Service de gestion des scores
/// - core/quiz/quiz_score.dart: Modèle de données
/// - core/quiz/quiz_config.dart: Configuration des quiz
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Interface de suivi des performances)
/// 📅 Dernière modification: Mon Sep 29 09:49:52 CEST 2025
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_service.dart';
import '../../../../core/quiz/quiz_config.dart';
import '../../../../core/quiz/quiz_score.dart';
import '../../../../core/quiz/quiz_score_service.dart';

class QuizStatisticsScreen extends ConsumerStatefulWidget {
  const QuizStatisticsScreen({super.key});

  @override
  ConsumerState<QuizStatisticsScreen> createState() =>
      _QuizStatisticsScreenState();
}

class _QuizStatisticsScreenState extends ConsumerState<QuizStatisticsScreen> {
  List<QuizStatistics> _quizStats = [];
  Map<String, dynamic> _globalStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await QuizScoreService.getQuizStatistics();
      final global = await QuizScoreService.getGlobalStatistics();

      setState(() {
        _quizStats = stats;
        _globalStats = global;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement statistiques: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text(
          'Bulletin de Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_quizStats.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGlobalStats(),
            const SizedBox(height: 24),
            _buildQuizList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune note disponible',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par faire des quiz pour voir vos statistiques',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalStats() {
    final totalSessions = _globalStats['total_sessions'] as int? ?? 0;
    final averageScore =
        (_globalStats['average_score'] as num?)?.toDouble() ?? 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.green.shade600, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Suivi de l\'Élève',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Contrôles',
                    totalSessions.toString(),
                    Icons.quiz,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Moyenne',
                    '${averageScore.toInt()}/20',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList() {
    // Trier les matières : Maths, Philo, SVT en premier, puis les autres
    final sortedStats = List<QuizStatistics>.from(_quizStats);
    sortedStats.sort((a, b) {
      final configA = EvalManager.getEvalConfig(a.quizCode);
      final configB = EvalManager.getEvalConfig(b.quizCode);

      final categoryA = configA?.category ?? a.quizCategory;
      final categoryB = configB?.category ?? b.quizCategory;

      // Priorité : Mathématiques, Philosophie, SVT Terminale, puis les autres
      final priorityA = _getCategoryPriority(categoryA);
      final priorityB = _getCategoryPriority(categoryB);

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      // Si même priorité, trier par nom
      return categoryA.compareTo(categoryB);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Matières',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...sortedStats.map((stat) => _buildQuizCard(stat)),
      ],
    );
  }

  /// Définit la priorité d'affichage des matières
  int _getCategoryPriority(String category) {
    switch (category) {
      case 'Mathématiques':
        return 1; // Priorité la plus haute
      case 'Philosophie':
        return 2;
      case 'SVT Terminale':
        return 3;
      default:
        return 4; // Toutes les autres matières
    }
  }

  /// Récupère le niveau maximum validé pour les maths
  Future<String?> _getMaxLevelWithoutError(String quizCode) async {
    if (quizCode != 'MATH_HABILETES') return null;

    try {
      return await DatabaseService().getMaxLevelReached(quizCode);
    } catch (e) {
      print('Erreur lors de la récupération du niveau max: $e');
      return null;
    }
  }

  /// Récupère le temps record pour le niveau maximum personnel
  Future<String?> _getRecordTime(String quizCode) async {
    if (quizCode != 'MATH_HABILETES') return null;

    try {
      // Récupérer le niveau maximum personnel de l'élève
      final maxLevel = await DatabaseService().getMaxLevelReached(quizCode);
      if (maxLevel == null) return null;

      // Récupérer tous les records et trouver celui du niveau maximum personnel
      final allRecords = await DatabaseService().getAllRecords();

      // Trouver le record du niveau maximum personnel
      Map<String, dynamic>? personalRecord;
      for (final record in allRecords) {
        if (record['highest_level_name'] == maxLevel) {
          if (personalRecord == null ||
              (record['fastest_time_seconds'] as int) <
                  (personalRecord['fastest_time_seconds'] as int)) {
            personalRecord = record;
          }
        }
      }

      if (personalRecord != null) {
        final timeSeconds = personalRecord['fastest_time_seconds'] as int;
        final duration = Duration(seconds: timeSeconds);
        return _formatDuration(duration);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du temps record: $e');
      return null;
    }
  }

  /// Formate une durée en minutes:secondes
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Récupère le niveau maximum et le temps record pour les maths
  Future<Map<String, String?>> _getLevelAndTime(String quizCode) async {
    if (quizCode != 'MATH_HABILETES') return {};

    try {
      final level = await _getMaxLevelWithoutError(quizCode);
      final time = await _getRecordTime(quizCode);
      return {'level': level, 'time': time};
    } catch (e) {
      print('Erreur lors de la récupération du niveau et temps: $e');
      return {};
    }
  }

  Widget _buildQuizCard(QuizStatistics stat) {
    final config = EvalManager.getEvalConfig(stat.quizCode);
    final title = config?.title ?? stat.quizCode;
    final category = config?.category ?? stat.quizCategory;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showQuizDetails(stat),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPerformanceColor(stat.averageScore)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getPerformanceColor(stat.averageScore)
                            .withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      stat.overallPerformanceGrade,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getPerformanceColor(stat.averageScore),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Affichage spécial pour les maths avec niveau de l'élève et temps record
              if (stat.quizCode == 'MATH_HABILETES') ...[
                FutureBuilder<Map<String, String?>>(
                  future: _getLevelAndTime(stat.quizCode),
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? {};
                    final maxLevel = data['level'];
                    final recordTime = data['time'];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.school,
                                  color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Niveau de l\'élève = ${maxLevel ?? "Non défini"}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                          if (recordTime != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.timer,
                                    color: Colors.orange, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Temps record: $recordTime',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: _buildQuizStatItem(
                      'Moyenne',
                      stat.averageScoreText,
                      Icons.trending_up,
                    ),
                  ),
                  Expanded(
                    child: _buildQuizStatItem(
                      'Meilleur',
                      stat.bestScoreText,
                      Icons.emoji_events,
                    ),
                  ),
                  Expanded(
                    child: _buildQuizStatItem(
                      'Contrôles',
                      stat.totalSessions.toString(),
                      Icons.quiz,
                    ),
                  ),
                ],
              ),
              if (stat.lastSessionDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Dernier contrôle: ${_formatDate(stat.lastSessionDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 16) return Colors.green;
    if (score >= 12) return Colors.blue;
    if (score >= 8) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showQuizDetails(QuizStatistics stat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stat.quizTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Catégorie', stat.quizCategory),
              _buildDetailItem(
                  'Contrôles totaux', stat.totalSessions.toString()),
              _buildDetailItem('Moyenne', stat.averageScoreText),
              _buildDetailItem('Meilleur score', stat.bestScoreText),
              _buildDetailItem('Pire score', stat.worstScoreText),
              _buildDetailItem(
                  'Pourcentage global', stat.overallPercentageText),
              if (stat.averageDurationSeconds != null)
                _buildDetailItem('Durée moyenne', stat.averageDurationText),
              if (stat.lastSessionDate != null)
                _buildDetailItem(
                    'Dernier contrôle', _formatDate(stat.lastSessionDate!)),
            ],
          ),
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
