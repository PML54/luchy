/// <cursor>
///
/// math_timer_widget.dart
///
/// Widget d'affichage du timer mathématique.
/// Affiche le temps écoulé en temps réel et le statut final.
///
/// COMPOSANTS PRINCIPAUX:
/// - MathTimerWidget: Widget principal d'affichage
/// - Affichage temps réel: HH:MM:SS
/// - Statut final: OK/KO avec temps total
/// - Design responsive et accessible
///
/// ÉTAT ACTUEL:
/// - Affichage temps réel du timer
/// - Statut final avec couleurs
/// - Design cohérent avec l'app
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: CRÉATION - Widget timer maths
/// - Intégration avec MathTimer
/// - Design responsive et accessible
///
/// 🔧 POINTS D'ATTENTION:
/// - Mise à jour temps réel
/// - Design cohérent avec l'app
/// - Accessibilité pour tous les utilisateurs
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans modern_math_skills_screen.dart
/// - Tests de performance
///
/// 🔗 FICHIERS LIÉS:
/// - math_timer.dart: Timer principal
/// - modern_math_skills_screen.dart: Écran principal
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Fonctionnalité principale)
/// 📅 Dernière modification: 2025-01-27 20:50
/// </cursor>

import 'package:flutter/material.dart';
import 'package:luchy/core/timing/math_timer.dart';

/// Widget d'affichage du timer mathématiqu
/// Widget timer ultra-minimaliste - temps seulement
class MathTimerWidget extends StatefulWidget {
  final MathTimer timer;
  final String? currentLevel;

  const MathTimerWidget({
    super.key,
    required this.timer,
    this.currentLevel,
  });

  @override
  State<MathTimerWidget> createState() => _MathTimerWidgetState();
}

class _MathTimerWidgetState extends State<MathTimerWidget> {
  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.timer.elapsedTime;
    widget.timer.onTimeUpdate = _onTimeUpdate;
  }

  @override
  void dispose() {
    widget.timer.onTimeUpdate = null;
    super.dispose();
  }

  void _onTimeUpdate(Duration time) {
    if (mounted) {
      setState(() {
        _currentTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _formatTime(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  String _formatTime() {
    final minutes = _currentTime.inMinutes.remainder(60);
    final seconds = _currentTime.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}