/// <cursor>
///
/// generic_quiz_screen.dart
///
/// Écran de quiz générique utilisant la nouvelle structure EvalConfig
/// Interface standardisée inspirée des habiletés maths
///
/// COMPOSANTS PRINCIPAUX:
/// - GenericQuizScreen : Écran principal du quiz générique
/// - _buildEvalContent : Interface de quiz avec drag & drop
/// - _buildEvalRow : Ligne individuelle de quiz
/// - _checkResults : Validation des réponses
///
/// ÉTAT ACTUEL:
/// - Interface standardisée inspirée des habiletés calcul
/// - Système de drag & drop fonctionnel
/// - Support de tous les types de quiz via EvalConfig
/// - Titres personnalisés par configuration
/// - Support des quiz image-texte (panneaux de signalisation)
/// - Tooltips cliquables pour descriptions complètes
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27 : Création de l'écran générique
/// - 2025-01-27 : Intégration de la structure EvalConfig
/// - 2025-01-27 : Interface standardisée
/// - 2025-09-26 : Ajout support images SVG pour quiz code de la route
/// - 2025-09-26 : Ajout tooltips cliquables pour descriptions
/// - 2025-09-26 : AMÉLIORATION MÉLANGE - Garantie aucune réponse bien placée
/// - 2025-09-28 : MODIFICATION EVA SVT - Infos masquées en mode quiz, affichées uniquement en correction pour réponses incorrectes
/// - 2025-09-28 : CORRECTION EVA SVT - Clic tooltip uniquement quand bordure rouge (réponse fausse)
/// - 2025-09-29 09:18: TERMINOLOGIE BOUTON - Remplacement "Nouveau Eval" par "Suivant"
/// - Modification du texte du bouton après validation pour une terminologie plus claire
/// - Mise à jour du texte d'aide correspondant
/// - 2025-09-29 09:47: RENOMMAGE EVAL - "Panneaux" → "Patrick"
/// - Modification du titre d'affichage pour le quiz code de la route
/// - Interface utilisateur mise à jour avec nouveau nom
///
/// 🔧 POINTS D'ATTENTION:
/// - Interface commune pour tous les types de quiz
/// - Système de drag & drop réutilisable
/// - Feedback visuel cohérent
/// - Titres dynamiques selon la configuration
/// - Détection automatique image/texte
/// - Support SVG, PNG, JPG, JPEG
/// - Tooltips avec descriptions complètes
/// - EVA SVT : Icône d'information uniquement en correction pour réponses incorrectes (bordure rouge)
/// - EVA SVT : Clic tooltip uniquement quand icône visible (cohérence visuelle)
/// - Mélange intelligent garantissant aucune réponse bien placée
/// - Algorithme de mélange robuste avec limite de sécurité
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans la navigation
/// - Système de progression par catégorie
/// - Statistiques par type de quiz
/// - Optimisation des images
///
/// 🔗 FICHIERS LIÉS:
/// - modern_math_skills_screen.dart (référence UI)
/// - quiz_config.dart (gestion des configurations)
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐
/// 📅 Dernière modification: Mon Sep 29 09:47:52 CEST 2025
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/quiz/quiz_config.dart';
import '../../../../core/quiz/quiz_score.dart';
import '../../../../core/quiz/quiz_score_service.dart';

class GenericQuizScreen extends ConsumerStatefulWidget {
  final String quizCode;

  const GenericQuizScreen({
    super.key,
    required this.quizCode,
  });

  @override
  ConsumerState<GenericQuizScreen> createState() => _GenericQuizScreenState();
}

class _GenericQuizScreenState extends ConsumerState<GenericQuizScreen> {
  // État du quiz
  List<EvalPair> _quizPairs = [];
  List<int> _rightArrangement = [];
  bool _showValidation = false;
  EvalConfig? _config;

  @override
  void initState() {
    super.initState();
    _loadEval();
  }

  /// Charger la configuration et générer le quiz
  Future<void> _loadEval() async {
    _config = EvalManager.getEvalConfig(widget.quizCode);
    if (_config != null) {
      await _generateNewEval();
    }
  }

  /// Mélanger les réponses en garantissant qu'aucune n'est à sa place initiale
  void _shuffleAnswers() {
    _rightArrangement = List.generate(_quizPairs.length, (index) => index);

    // Mélanger jusqu'à ce qu'aucune réponse ne soit bien placée
    int shuffleAttempts = 0;
    do {
      _rightArrangement.shuffle();
      shuffleAttempts++;
    } while (_hasCorrectlyPlacedAnswers() && shuffleAttempts < 100);

    if (shuffleAttempts >= 100) {
      print(
          '⚠️ Impossible de mélanger sans réponse bien placée après 100 tentatives');
    } else {
      print(
          '✅ Mélange réussi après $shuffleAttempts tentatives - Aucune réponse bien placée');
    }
  }

  /// Vérifie si des réponses sont déjà bien placées après mélange
  bool _hasCorrectlyPlacedAnswers() {
    for (int i = 0; i < _rightArrangement.length; i++) {
      if (_rightArrangement[i] == i) {
        return true; // Au moins une réponse est bien placée
      }
    }
    return false; // Aucune réponse n'est bien placée
  }

  /// Générer un nouveau quiz
  Future<void> _generateNewEval() async {
    if (_config == null) return;

    setState(() {
      _showValidation = false;
    });

    try {
      final pairs = await EvalManager.generateEval(widget.quizCode, count: 5);
      setState(() {
        _quizPairs = pairs;
        // Mélanger les réponses en garantissant qu'aucune n'est à sa place initiale
        _shuffleAnswers();
      });
    } catch (e) {
      print('Erreur lors du chargement du quiz: $e');
      setState(() {
        _quizPairs = [];
      });
    }
  }

  /// Vérifier les résultats
  void _checkResults() async {
    setState(() {
      _showValidation = true;
    });

    // NOUVEAU: Sauvegarder le score du quiz
    await _saveQuizScore();
  }

  /// NOUVEAU: Sauvegarder le score du quiz
  Future<void> _saveQuizScore() async {
    if (_config == null) return;

    try {
      int correctAnswers = 0;
      for (int i = 0; i < _quizPairs.length; i++) {
        if (_rightArrangement[i] == i) {
          correctAnswers++;
        }
      }

      await QuizScoreService.saveQuizScore(
        quizCode: _config!.code,
        quizCategory: _config!.category,
        totalQuestions: _quizPairs.length,
        correctAnswers: correctAnswers,
      );

      debugPrint(
          'Score évaluation sauvegardé: ${_config!.code} - ${correctAnswers}/${_quizPairs.length} (${QuizScoreExtensions.calculateScore20(correctAnswers, _quizPairs.length).toInt()}/20)');
    } catch (e) {
      debugPrint('Erreur sauvegarde score évaluation: $e');
    }
  }

  /// Obtenir le texte du bouton
  String _getButtonText() {
    if (_showValidation) {
      return 'Suivant';
    } else {
      return 'Vérifier';
    }
  }

  /// Afficher l'aide
  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aide'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comment jouer :'),
            SizedBox(height: 8),
            Text('1. Faites glisser les éléments de droite vers la gauche'),
            Text('2. Associez chaque élément à sa correspondance'),
            Text('3. Cliquez sur "Vérifier" pour valider'),
            Text('4. Cliquez sur "Suivant" pour recommencer'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Vérifier si le contenu est une image
  bool _isImage(String content) {
    return content.toLowerCase().endsWith('.svg') ||
        content.toLowerCase().endsWith('.png') ||
        content.toLowerCase().endsWith('.jpg') ||
        content.toLowerCase().endsWith('.jpeg');
  }

  /// Afficher le contenu (texte ou image)
  Widget _buildContent(String content, {bool isLeftColumn = true}) {
    if (_isImage(content)) {
      // Afficher une image
      return Container(
        width: double.infinity, // Largeur équilibrée pour les deux colonnes
        height: 80, // Hauteur équilibrée pour les deux colonnes
        child: SvgPicture.asset(
          content,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      );
    } else {
      // Afficher du texte
      return SizedBox(
        width: double.infinity, // Largeur équilibrée pour les deux colonnes
        child: Text(
          content,
          style: TextStyle(
            fontSize: 17, // Taille équilibrée pour les deux colonnes
            color: isLeftColumn ? Colors.green.shade800 : Colors.green.shade800,
            fontWeight: isLeftColumn ? FontWeight.w500 : FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  /// Afficher un tooltip avec la description complète
  void _showDescriptionTooltip(
      BuildContext context, String term, EvalPair? quizPair) {
    // Pour SVT, afficher l'explication (col3) si disponible
    String description = term;
    String title = 'Description';

    if (quizPair?.col3 != null && quizPair!.col3!.isNotEmpty) {
      description = quizPair.col3!;
      title = 'Explication';

      // Ajouter le thème si disponible
      if (quizPair.col5 != null && quizPair.col5!.isNotEmpty) {
        description += '\n\nThème: ${quizPair.col5}';
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Fermer',
                style: TextStyle(color: Colors.blue.shade600),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  /// Détermine le titre à afficher dans l'AppBar
  String _getDisplayTitle() {
    switch (_config!.title) {
      case 'Panneaux de signalisation':
        return 'Patrick';
      case 'Drapeaux du monde':
        return 'Drapeaux';
      default:
        return _config!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Eval non trouvé'),
          backgroundColor: Colors.red.shade600,
        ),
        body: const Center(
          child: Text('Configuration de quiz introuvable'),
        ),
      );
    }

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
        title: Text(
          _getDisplayTitle(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Icône Aide
          IconButton(
            icon: Icon(Icons.help),
            onPressed: _showHelp,
            tooltip: 'Aide',
          ),
        ],
        elevation: 0,
      ),
      body: _buildEvalContent(),
    );
  }

  Widget _buildEvalContent() {
    if (_quizPairs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    return Column(
      children: [
        // Instructions claires pour l'utilisateur
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
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
        // Contenu du quiz
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < _quizPairs.length; i++)
                  Expanded(
                    child: _buildEvalRow(i),
                  ),
              ],
            ),
          ),
        ),

        // Bouton de validation
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _showValidation ? _generateNewEval : _checkResults,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              _getButtonText(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvalRow(int row) {
    final quizPair = _quizPairs[row];
    final isCorrect = _showValidation && _rightArrangement[row] == row;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Colonne de gauche : Question
          Expanded(
            flex: 1,
            child: DragTarget<int>(
              onAcceptWithDetails: (details) {
                setState(() {
                  final draggedIndex = details.data;
                  // Trouver la position de l'élément glissé
                  final draggedRow = _rightArrangement.indexOf(draggedIndex);
                  if (draggedRow != -1 && draggedRow != row) {
                    // Échanger les valeurs
                    final temp = _rightArrangement[row];
                    _rightArrangement[row] = draggedIndex;
                    _rightArrangement[draggedRow] = temp;
                  }
                });
              },
              builder: (context, candidateData, rejectedData) {
                return GestureDetector(
                  onTap: _showValidation && !isCorrect
                      ? () => _showDescriptionTooltip(
                          context, quizPair.col1, quizPair)
                      : null,
                  child: Container(
                    height: 80,
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
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildContent(quizPair.col1,
                                isLeftColumn: true),
                          ),
                        ),
                        // Icône d'information uniquement en mode correction pour les réponses incorrectes (bordure rouge)
                        if (_showValidation && !isCorrect)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 16),

          // Colonne de droite : Réponse
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
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.green.shade400, width: 2),
                      ),
                      child: Center(
                        child: _buildContent(
                            _quizPairs[_rightArrangement[row]].col2,
                            isLeftColumn: false),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: const Center(
                      child: Icon(Icons.drag_indicator, color: Colors.grey),
                    ),
                  ),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.green.shade50
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _showValidation
                            ? (isCorrect ? Colors.green : Colors.red)
                            : (candidateData.isNotEmpty
                                ? Colors.green
                                : Colors.green.shade300),
                        width: _showValidation
                            ? 3
                            : (candidateData.isNotEmpty ? 2 : 1),
                      ),
                    ),
                    child: Center(
                      child: _buildContent(
                          _quizPairs[_rightArrangement[row]].col2,
                          isLeftColumn: false),
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
}
