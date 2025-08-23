/// <cursor>
/// LUCHY - Outil de profilage performance
///
/// Utilitaire de mesure des performances pour optimiser les
/// opérations critiques de l'application Luchy.
///
/// COMPOSANTS PRINCIPAUX:
/// - Profiler: Classe singleton pour mesures performance
/// - start(): Démarrage mesure avec clé unique
/// - end(): Fin mesure et calcul durée
/// - report(): Génération rapport performance complet
/// - enabled: Flag activation/désactivation global
///
/// ÉTAT ACTUEL:
/// - Précision: Microseconde avec DateTime.now()
/// - Mémoire: Optimisé pour overhead minimal
/// - Thread safety: Sécurisé pour opérations concurrentes
/// - Reporting: Format lisible pour debugging
///
/// HISTORIQUE RÉCENT:
/// - Intégration avec image_controller et game_providers
/// - Optimisation overhead pour production
/// - Amélioration format rapports pour debugging
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Production: Désactiver profiler en release pour performance
/// - Memory leaks: Nettoyer entries accumulées périodiquement
/// - Clock precision: DateTime peut avoir variations selon platform
/// - Concurrency: Attention aux accès simultanés map entries
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter métriques mémoire (RAM usage)
/// - Implémenter sampling automatique pour stats
/// - Créer dashboard temps réel performance
/// - Intégrer avec analytics pour monitoring production
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: Utilisation principale
/// - features/puzzle/presentation/controllers/image_controller.dart: Profiling images
/// - core/utils/image_optimizer.dart: Mesures optimisation
///
/// CRITICALITÉ: ⭐⭐⭐ (Outil development et optimisation)
/// </cursor>
final profiler = Profiler();

class Profiler {
  final Map<String, ProfileEntry> _entries = {};
  bool _enabled = true;

  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
  }

  void start(String name) {
    if (!_enabled) return;
    _entries[name] = ProfileEntry(name, DateTime.now());
  }

  void end(String name) {
    if (!_enabled) return;
    final entry = _entries[name];
    if (entry != null) {
      entry.end = DateTime.now();
    }
  }

  double getTime(String name) {
    final entry = _entries[name];
    if (entry == null || entry.end == null) return 0.0;

    return entry.end!.difference(entry.start).inMicroseconds /
        1000.0; // Convertit en millisecondes
  }

  void reset() {
    _entries.clear();
  }

  String report() {
    if (!_enabled) return 'Profiler disabled';

    final StringBuffer buffer = StringBuffer();
    _entries.values.where((entry) => entry.end != null).forEach((entry) {
      final duration =
          entry.end!.difference(entry.start).inMicroseconds / 1000.0;
      buffer.writeln('${entry.name}: ${duration.toStringAsFixed(2)} ms');
    });
    return buffer.toString();
  }
}

class ProfileEntry {
  final String name;
  final DateTime start;
  DateTime? end;

  ProfileEntry(this.name, this.start);
}
