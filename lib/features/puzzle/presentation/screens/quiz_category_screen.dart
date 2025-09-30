/// <cursor>
///
/// quiz_category_screen.dart
///
/// Écran de sélection des quiz par catégorie
/// Utilise la nouvelle structure EvalConfig pour organiser les quiz
///
/// COMPOSANTS PRINCIPAUX:
/// - QuizCategoryScreen : Écran de sélection par catégorie
/// - _buildCategoryCard : Carte de catégorie
/// - _buildEvalCard : Carte individuelle de quiz
/// - _navigateToEval : Navigation vers le quiz sélectionné
///
/// ÉTAT ACTUEL:
/// - Interface de sélection directe des quiz
/// - Liste complète de tous les quiz disponibles
/// - Cartes modernes avec catégorie et description
/// - Navigation simplifiée sans catégories
///
/// HISTORIQUE RÉCENT:
/// - Mon Sep 29 08:29: SIMPLIFICATION APPBAR - Suppression titre et ajout aide
/// - Suppression du libellé "Contrôles" de l'AppBar
/// - Icône Bulletin de Notes agrandie (32px → 40px) et mise en valeur
/// - Ajout de l'icône aide avec dialog d'aide détaillé
/// - Interface plus épurée et focalisée sur les fonctionnalités
/// - Mon Sep 29 09:12: CENTRAGE ICÔNE CARNET - Icône Carnet de Notes au centre
/// - Icône Carnet de Notes déplacée dans le title (centerTitle: true)
/// - Taille augmentée à 50px pour plus de visibilité
/// - Icône aide repositionnée tout à droite dans actions
/// - Interface plus équilibrée et focalisée
/// - 2025-09-29 09:47: RENOMMAGE EVAL - "Eval Panneaux" → "Eval Patrick"
/// - Modification du nom d'affichage pour le quiz code de la route
/// - Mise à jour dans l'aide et l'interface utilisateur
/// - 2025-01-27 : Création de l'écran par catégorie
/// - 2025-01-27 : Intégration de la structure EvalConfig
/// - 2025-01-27 : Interface moderne avec cartes
/// - 2025-09-26 : Refactoring pour affichage direct des quiz
/// - 2025-09-29 : Ajout support EVA PHILO avec icône et couleur
///
/// 🔧 POINTS D'ATTENTION:
/// - Navigation vers GenericQuizScreen
/// - Affichage direct de tous les quiz
/// - Interface cohérente avec l'app
/// - Badges de catégorie sur chaque quiz
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Système de recherche/filtrage
/// - Statistiques par quiz
/// - Système de progression
///
/// 🔗 FICHIERS LIÉS:
/// - generic_quiz_screen.dart (quiz générique)
/// - quiz_config.dart (gestion des configurations)
///
/// CRITICALITÉ: ⭐⭐⭐⭐
/// 📅 Dernière modification: Mon Sep 29 09:47:52 CEST 2025
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/quiz/quiz_config.dart';
import '../../../quiz/presentation/screens/quiz_statistics_screen.dart';
import 'generic_quiz_screen.dart';
import 'modern_math_skills_screen.dart';

class QuizCategoryScreen extends ConsumerWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvalzes = EvalManager.getAllEvalzes();

    // Afficher tous les quiz sans contrôle VIP
    final visibleEvalzes = allEvalzes;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: IconButton(
          icon: const Icon(Icons.school, color: Colors.orange, size: 50),
          onPressed: () => _showStatistics(context),
          tooltip: 'Ton Carnet de Notes',
        ),
        actions: [
          // Icône Aide (tout à droite)
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () => _showHelp(context),
            tooltip: 'Aide',
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Liste des quiz
            Expanded(
              child: ListView.builder(
                itemCount: visibleEvalzes.length,
                itemBuilder: (context, index) {
                  final quiz = visibleEvalzes[index];
                  return _buildEvalCard(context, quiz);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvalCard(BuildContext context, EvalConfig quiz) {
    final icon = _getEvalIcon(quiz.category);
    final color = _getEvalColor(quiz.category);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        title: Text(
          _getEvalTitle(quiz.code),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        onTap: () => _navigateToEval(context, quiz.code),
      ),
    );
  }

  IconData _getEvalIcon(String category) {
    switch (category) {
      case 'Mathématiques':
        return Icons.functions; // Icône moderne pour les mathématiques
      case 'Géographie':
        return Icons.public;
      case 'Chimie':
        return Icons.science;
      case 'Code de la route':
        return Icons.directions_car;
      case 'Maths':
        return Icons.calculate;
      case 'SVT Terminale':
        return Icons.science;
      case 'Philosophie':
        return Icons.psychology; // Icône pour la philosophie
      default:
        return Icons.quiz;
    }
  }

  Color _getEvalColor(String category) {
    switch (category) {
      case 'Mathématiques':
        return Colors.orange; // Couleur orange pour les mathématiques
      case 'Géographie':
        return Colors.blue;
      case 'Chimie':
        return Colors.purple;
      case 'Code de la route':
        return Colors.red;
      case 'Maths':
        return Colors.orange;
      case 'SVT Terminale':
        return Colors.green;
      case 'Philosophie':
        return Colors.indigo; // Couleur indigo pour la philosophie
      default:
        return Colors.green;
    }
  }

  String _getEvalTitle(String quizCode) {
    switch (quizCode) {
      case 'MATH_HABILETES':
        return 'Eval Maths';
      case 'SVT_EVA':
        return 'Eva SVT';
      case 'PHILO_EVA':
        return 'Eva Philo';
      case 'GEO_CAP':
        return 'Eval Capitales';
      case 'GEO_DEPT':
        return 'Eval France';
      case 'CHIM_ELEM':
        return 'Eval Chimie';
      case 'DRAPEAUX_MONDE':
        return 'Eval Drapeaux';
      case 'ROUTE_PANNEAUX':
        return 'Eval Patrick';
      default:
        return 'Eval';
    }
  }

  void _navigateToEval(BuildContext context, String quizCode) {
    // Cas spécial : Habileté Maths - navigation vers l'écran dédié
    if (quizCode == 'MATH_HABILETES') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ModernMathSkillsScreen(),
        ),
      );
      return;
    }

    // Navigation vers le quiz générique pour tous les autres quiz (y compris EVA SVT)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericQuizScreen(quizCode: quizCode),
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizStatisticsScreen(),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Aide - Contrôles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment utiliser les contrôles :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Sélectionnez un contrôle dans la liste'),
              Text('• Répondez aux questions proposées'),
              Text('• Vérifiez vos réponses'),
              Text('• Consultez vos notes dans le Bulletin'),
              SizedBox(height: 16),
              Text(
                'Types de contrôles disponibles :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Eval Maths - Habileté au calcul'),
              Text('• Eva Philo & SVT - Bac'),
              Text('• Géographie - Capitales et France'),
              Text('• Chimie - Éléments chimiques'),
              Text('• Code de la route - Patrick'),
              SizedBox(height: 16),
              Text(
                'Bulletin de Notes :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Consultez vos performances'),
              Text('• Suivez votre progression'),
              Text('• Niveau maximum atteint en maths'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
