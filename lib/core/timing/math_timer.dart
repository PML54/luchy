/// <cursor>
///
/// math_timer.dart
///
/// Système de timer simple pour les maths sans SQLite.
/// Se déclenche au CP et s'arrête à la première erreur ou fin Bac+2.
///
/// COMPOSANTS PRINCIPAUX:
/// - MathTimer: Timer principal avec état
/// - TimerState: État du timer (arrêté, en cours, terminé)
/// - Callbacks: Notifications de changement d'état
///
/// ÉTAT ACTUEL:
/// - Timer simple sans persistance
/// - Déclenchement automatique au CP
/// - Arrêt automatique à l'erreur ou fin Bac+2
/// - Affichage temps réel
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: CRÉATION - Timer maths simple sans SQLite
/// - Remplacement du système complexe par un timer basique
/// - Intégration avec progression mathématique
///
/// 🔧 POINTS D'ATTENTION:
/// - Pas de persistance (redémarre à chaque session)
/// - Timer basé sur DateTime.now()
/// - Callbacks pour mise à jour UI
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans modern_math_skills_screen.dart
/// - Affichage temps réel dans l'UI
/// - Gestion des états OK/KO
///
/// 🔗 FICHIERS LIÉS:
/// - modern_math_skills_screen.dart: Écran principal maths
/// - progression_manager.dart: Gestion des niveaux
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Fonctionnalité principale)
/// 📅 Dernière modification: 2025-01-27 20:50
/// </cursor>

import 'dart:async';

import 'package:flutter/foundation.dart';

/// État du timer mathématique
enum TimerState {
  stopped, // Arrêté
  running, // En cours
  completed, // Terminé (Bac+2 sans erreur)
  failed, // Échec (première erreur)
}

/// Timer mathématique simple
class MathTimer {
  Timer? _timer;
  DateTime? _startTime;
  TimerState _state = TimerState.stopped;
  final Duration _updateInterval = const Duration(seconds: 1);

  // Callbacks
  Function(Duration)? onTimeUpdate;
  Function(TimerState)? onStateChange;

  /// État actuel du timer
  TimerState get state => _state;

  /// Temps écoulé depuis le début
  Duration get elapsedTime {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  /// Vérifie si le timer est en cours
  bool get isRunning => _state == TimerState.running;

  /// Démarre le timer
  void start() {
    if (_state != TimerState.stopped) return;

    _startTime = DateTime.now();
    _state = TimerState.running;
    onStateChange?.call(_state);

    // Timer de mise à jour
    _timer = Timer.periodic(_updateInterval, (timer) {
      onTimeUpdate?.call(elapsedTime);
    });

    debugPrint('🕒 Timer maths démarré');
  }

  /// Arrête le timer avec succès (Bac+2 terminé)
  void complete() {
    if (_state != TimerState.running) return;

    _stopTimer();
    _state = TimerState.completed;
    onStateChange?.call(_state);

    debugPrint(
        '✅ Timer maths terminé avec succès: ${_formatDuration(elapsedTime)}');
  }

  /// Arrête le timer avec échec (première erreur)
  void fail() {
    if (_state != TimerState.running) return;

    _stopTimer();
    _state = TimerState.failed;
    onStateChange?.call(_state);

    debugPrint('❌ Timer maths échoué: ${_formatDuration(elapsedTime)}');
  }

  /// Arrête le timer
  void stop() {
    if (_state == TimerState.stopped) return;

    _stopTimer();
    _state = TimerState.stopped;
    onStateChange?.call(_state);

    debugPrint('⏹️ Timer maths arrêté');
  }

  /// Réinitialise le timer
  void reset() {
    stop();
    _startTime = null;
    _state = TimerState.stopped;
    onStateChange?.call(_state);

    debugPrint('🔄 Timer maths réinitialisé');
  }

  /// Arrête le timer interne
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Formate la durée en HH:MM:SS
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Formate la durée pour l'affichage
  String formatElapsedTime() {
    return _formatDuration(elapsedTime);
  }

  /// Libère les ressources
  void dispose() {
    _stopTimer();
  }
}
