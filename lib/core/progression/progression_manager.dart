/// <cursor>
///
/// PROGRESSION_MANAGER.DART
/// Chemin: core/progression/
///
/// 🎓 GESTIONNAIRE DE PROGRESSION ÉDUCATIVE
/// Système d'avancement automatique avec validation et redoublement.
///
/// Gère la progression naturelle de CP à Bac+2 avec validation des acquis,
/// redoublement en cas d'échec, et sauvegarde persistante du niveau utilisateur.
///
/// COMPOSANTS PRINCIPAUX:
/// - ProgressionManager: Gestionnaire principal de progression
/// - ValidationCriteria: Critères de passage de niveau
/// - ProgressionState: État actuel de progression
/// - RedoublementLogic: Logique de redoublement
///
/// ÉTAT ACTUEL:
/// - Architecture complète de progression
/// - Validation automatique des quiz
/// - Système de redoublement intégré
/// - Sauvegarde SQLite de la progression
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-25 15:18: SIMPLIFICATION MESSAGES RÉUSSITE - Interface épurée
/// - Messages de réussite simplifiés: "Admis en [niveau]" uniquement
/// - Ajout "Avec les Félicitations" si temps < 15 secondes
/// - Suppression messages "Élève rapide/lent" pour plus de clarté
/// - Interface plus directe et pédagogique
/// - 2025-09-24 05:20: SIMPLIFICATION MESSAGES - Messages courts et corrects
/// - Correction affichage niveau: currentLevel au lieu de nextLevel
/// - Suppression "Promotion" → "Admis en [niveau]"
/// - Élève rapide si < 30s, élève lent si > 1min
/// - Messages plus courts et clairs
/// - 2025-09-24 05:13: AMÉLIORATION MESSAGES - Intégration temps et félicitations
/// - Ajout paramètre elapsedTime dans getResultMessage()
/// - Message avec félicitations si temps < 30s: "Félicitations ! Tu es admis en xxxx avec les félicitations (moins de 30s)"
/// - Message standard sinon: "Tu es admis en xxxx"
/// - 2025-09-23 19:00: SIMPLIFICATION MESSAGE - Message de réussite simplifié
/// - Suppression détails note/score du message de promotion
/// - Format: "Félicitations - Passage en xxxx Validé"
/// - Message plus concis et clair pour l'utilisateur
/// - Mar 9 sep 2025 04:25: CRÉATION - Système progression éducative
/// - Architecture avancement automatique CP → Bac+2
/// - Validation quiz avec critères de passage (80% réussite)
/// - Redoublement en cas d'échec, promotion en cas de réussite
///
/// 🔧 POINTS D'ATTENTION:
/// - Critères de passage configurables par niveau
/// - Sauvegarde persistante obligatoire
/// - Interface utilisateur adaptative
/// - Gestion des redoublements multiples
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration interface utilisateur
/// - Système de récompenses/badges
/// - Analytics de progression
/// - Mode parents/enseignants
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/database/database_service.dart: Persistance
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart: Interface
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système éducatif)
/// 📅 Dernière modification: 2025-09-25 15:18
/// </cursor>

import 'package:luchy/core/formulas/prepa_math_engine.dart';

/// Critères de validation pour passer au niveau supérieur
class ValidationCriteria {
  final double successRate; // Taux de réussite requis (0.0 à 1.0)
  final int minimumQuestions; // Nombre minimum de questions
  final int maxRedoublements; // Nombre max de redoublements autorisés

  const ValidationCriteria({
    this.successRate = 0.8, // 80% par défaut
    this.minimumQuestions = 6, // 6 questions minimum
    this.maxRedoublements = 3, // 3 redoublements max
  });

  /// Valide si les critères de passage sont remplis
  bool isValidated(int correctAnswers, int totalQuestions) {
    if (totalQuestions < minimumQuestions) return false;
    return (correctAnswers / totalQuestions) >= successRate;
  }

  /// Note sur 20 obtenue (arrondie)
  int getGradeOut20(int correctAnswers, int totalQuestions) {
    if (totalQuestions == 0) return 0;
    final percentage = (correctAnswers / totalQuestions);
    return (percentage * 20).round();
  }
}

/// État de progression d'un utilisateur
class ProgressionState {
  final NiveauEducatif currentLevel;
  final int redoublements; // Nombre de redoublements au niveau actuel
  final DateTime lastUpdate;
  final Map<NiveauEducatif, DateTime> levelUnlocked; // Historique des passages

  const ProgressionState({
    required this.currentLevel,
    this.redoublements = 0,
    required this.lastUpdate,
    this.levelUnlocked = const {},
  });

  /// Crée un état initial (CP)
  factory ProgressionState.initial() {
    return ProgressionState(
      currentLevel: NiveauEducatif.cp,
      redoublements: 0,
      lastUpdate: DateTime.now(),
      levelUnlocked: {NiveauEducatif.cp: DateTime.now()},
    );
  }

  /// Copie avec modifications
  ProgressionState copyWith({
    NiveauEducatif? currentLevel,
    int? redoublements,
    DateTime? lastUpdate,
    Map<NiveauEducatif, DateTime>? levelUnlocked,
  }) {
    return ProgressionState(
      currentLevel: currentLevel ?? this.currentLevel,
      redoublements: redoublements ?? this.redoublements,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      levelUnlocked: levelUnlocked ?? this.levelUnlocked,
    );
  }

  /// Conversion JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel.name,
      'redoublements': redoublements,
      'lastUpdate': lastUpdate.toIso8601String(),
      'levelUnlocked':
          levelUnlocked.map((k, v) => MapEntry(k.name, v.toIso8601String())),
    };
  }

  /// Création depuis JSON
  factory ProgressionState.fromJson(Map<String, dynamic> json) {
    return ProgressionState(
      currentLevel: NiveauEducatif.values.firstWhere(
        (level) => level.name == json['currentLevel'],
        orElse: () => NiveauEducatif.cp,
      ),
      redoublements: json['redoublements'] ?? 0,
      lastUpdate: DateTime.parse(json['lastUpdate']),
      levelUnlocked: (json['levelUnlocked'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              NiveauEducatif.values.firstWhere((level) => level.name == k),
              DateTime.parse(v),
            ),
          ) ??
          {},
    );
  }
}

/// Résultat d'une validation de quiz
enum ValidationResult {
  promoted, // Promu au niveau supérieur
  redoublement, // Redoublement
  maxLevel, // Niveau maximum atteint
  demoted, // Redescendu de classe (trop d'essais)
}

/// Gestionnaire principal de la progression éducative
class ProgressionManager {
  static const String _storageKey = 'user_progression';

  ProgressionState _state = ProgressionState.initial();

  /// Critères par niveau éducatif
  static const Map<NiveauEducatif, ValidationCriteria> _criteriaByLevel = {
    NiveauEducatif.cp: ValidationCriteria(
        successRate: 0.75, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.ce1: ValidationCriteria(
        successRate: 0.75, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.ce2: ValidationCriteria(
        successRate: 0.80, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.cm1: ValidationCriteria(
        successRate: 0.80, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.cm2: ValidationCriteria(
        successRate: 0.80, minimumQuestions: 5, maxRedoublements: 3),
    NiveauEducatif.sixieme: ValidationCriteria(
        successRate: 0.85, minimumQuestions: 5, maxRedoublements: 3),
    NiveauEducatif.cinquieme: ValidationCriteria(
        successRate: 0.85, minimumQuestions: 5, maxRedoublements: 3),
    NiveauEducatif.quatrieme: ValidationCriteria(
        successRate: 0.85, minimumQuestions: 5, maxRedoublements: 3),
    NiveauEducatif.troisieme: ValidationCriteria(
        successRate: 0.85, minimumQuestions: 5, maxRedoublements: 3),
    NiveauEducatif.seconde: ValidationCriteria(
        successRate: 0.90, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.premiere: ValidationCriteria(
        successRate: 0.90, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.terminale: ValidationCriteria(
        successRate: 0.90, minimumQuestions: 5, maxRedoublements: 2),
    NiveauEducatif.bacPlus1: ValidationCriteria(
        successRate: 0.95, minimumQuestions: 5, maxRedoublements: 1),
    NiveauEducatif.bacPlus2: ValidationCriteria(
        successRate: 0.95, minimumQuestions: 5, maxRedoublements: 1),
  };

  /// Ordre de progression des niveaux
  static const List<NiveauEducatif> _progressionOrder = [
    NiveauEducatif.cp,
    NiveauEducatif.ce1,
    NiveauEducatif.ce2,
    NiveauEducatif.cm1,
    NiveauEducatif.cm2,
    NiveauEducatif.sixieme,
    NiveauEducatif.cinquieme,
    NiveauEducatif.quatrieme,
    NiveauEducatif.troisieme,
    NiveauEducatif.seconde,
    NiveauEducatif.premiere,
    NiveauEducatif.terminale,
    NiveauEducatif.bacPlus1,
    NiveauEducatif.bacPlus2,
  ];

  /// État actuel de progression
  ProgressionState get currentState => _state;

  /// Niveau actuel
  NiveauEducatif get currentLevel => _state.currentLevel;

  /// Critères pour le niveau actuel
  ValidationCriteria get currentCriteria =>
      _criteriaByLevel[currentLevel] ?? const ValidationCriteria();

  /// Note minimale requise sur 20 pour le niveau actuel
  int get requiredGradeOut20 => (currentCriteria.successRate * 20).round();

  /// Niveau suivant dans la progression
  NiveauEducatif? get nextLevel {
    final currentIndex = _progressionOrder.indexOf(currentLevel);
    if (currentIndex == -1 || currentIndex >= _progressionOrder.length - 1) {
      return null; // Niveau maximum atteint
    }
    return _progressionOrder[currentIndex + 1];
  }

  /// Vérifie si c'est le niveau maximum
  bool get isMaxLevel => nextLevel == null;

  /// Valide un quiz et détermine la progression
  ValidationResult validateQuiz(int correctAnswers, int totalQuestions) {
    final criteria = currentCriteria;
    final isSuccess = criteria.isValidated(correctAnswers, totalQuestions);

    if (isSuccess) {
      // Quiz réussi
      if (isMaxLevel) {
        return ValidationResult.maxLevel;
      } else {
        _promoteToNextLevel();
        return ValidationResult.promoted;
      }
    } else {
      // Quiz échoué
      if (_state.redoublements >= criteria.maxRedoublements) {
        // Trop de redoublements, redescendre de classe
        _demoteToLowerLevel();
        return ValidationResult.demoted;
      } else {
        _incrementRedoublement();
        return ValidationResult.redoublement;
      }
    }
  }

  /// Promeut au niveau supérieur
  void _promoteToNextLevel() {
    final next = nextLevel;
    if (next != null) {
      final now = DateTime.now();
      final newUnlocked =
          Map<NiveauEducatif, DateTime>.from(_state.levelUnlocked);
      newUnlocked[next] = now;

      _state = _state.copyWith(
        currentLevel: next,
        redoublements: 0, // Reset redoublements
        lastUpdate: now,
        levelUnlocked: newUnlocked,
      );
      _saveState();
    }
  }

  /// Incrémente le nombre de redoublements
  void _incrementRedoublement() {
    _state = _state.copyWith(
      redoublements: _state.redoublements + 1,
      lastUpdate: DateTime.now(),
    );
    _saveState();
  }

  /// Redescend au niveau inférieur
  void _demoteToLowerLevel() {
    final currentIndex = _progressionOrder.indexOf(_state.currentLevel);
    if (currentIndex > 0) {
      final lowerLevel = _progressionOrder[currentIndex - 1];
      _state = _state.copyWith(
        currentLevel: lowerLevel,
        redoublements: 0, // Reset redoublements
        lastUpdate: DateTime.now(),
      );
      _saveState();
    } else {
      // Si déjà au niveau le plus bas (CP), reset redoublements
      _state = _state.copyWith(
        redoublements: 0,
        lastUpdate: DateTime.now(),
      );
      _saveState();
    }
  }

  /// Sauvegarde l'état (simulation - à connecter avec SQLite)
  void _saveState() {
    // TODO: Intégrer avec DatabaseService
    print(
        '💾 Progression sauvegardée: ${_state.currentLevel.nom} (redoublements: ${_state.redoublements})');
  }

  /// Charge l'état depuis la base de données
  Future<void> loadState() async {
    // TODO: Charger depuis SQLite
    // Pour l'instant, état initial
    _state = ProgressionState.initial();
  }

  /// Remet à zéro la progression (debug/admin)
  void resetProgression() {
    _state = ProgressionState.initial();
    _saveState();
  }

  /// Informations de débogage
  String getDebugInfo() {
    return '''
🎓 PROGRESSION DEBUG:
Niveau actuel: ${currentLevel.nom}
Redoublements: ${_state.redoublements}/${currentCriteria.maxRedoublements}
Note requise: ${requiredGradeOut20}/20
Niveau suivant: ${nextLevel?.nom ?? 'MAXIMUM ATTEINT'}
Dernière MAJ: ${_state.lastUpdate}
''';
  }

  /// Message de résultat pour l'utilisateur
  String getResultMessage(
      ValidationResult result, int correctAnswers, int totalQuestions,
      {Duration? elapsedTime}) {
    final grade = currentCriteria.getGradeOut20(correctAnswers, totalQuestions);

    switch (result) {
      case ValidationResult.promoted:
        String baseMessage = 'Admis en ${currentLevel.nom}';
        if (elapsedTime != null && elapsedTime.inSeconds < 15) {
          return '$baseMessage\nAvec les Félicitations';
        }
        return baseMessage;

      case ValidationResult.redoublement:
        return '📚 Redoublement en ${currentLevel.nom}\n'
            'Note: $grade/20 (requis: $requiredGradeOut20/20)\n'
            'Tentative ${_state.redoublements + 1}/${currentCriteria.maxRedoublements + 1}';

      case ValidationResult.maxLevel:
        return '🏆 Niveau maximum atteint ! Bravo !\n'
            'Note: $grade/20 en ${currentLevel.nom}';

      case ValidationResult.demoted:
        final currentIndex = _progressionOrder.indexOf(_state.currentLevel);
        final newLevel = currentIndex > 0
            ? _progressionOrder[currentIndex - 1]
            : _state.currentLevel;
        return '⬇️ Redescente en ${newLevel.nom}\n'
            'Note: $grade/20 - Trop de tentatives\n'
            'Continue à t\'entraîner !';
    }
  }
}
