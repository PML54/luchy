/// <cursor>
/// COMPOSANTS PRINCIPAUX
/// - GameSettingsRepository: Repository pour les paramètres de jeu
/// - Gestion CRUD des paramètres de difficulté et configuration
/// - Cache en mémoire pour optimiser les performances
///
/// ÉTAT ACTUEL
/// - Repository avec cache pour éviter requêtes répétées
/// - Méthodes async pour toutes les opérations
/// - Intégration avec DatabaseService
///
/// HISTORIQUE RÉCENT
/// - 2024-12-19: Création avec pattern repository + cache
/// - 2025-01-08: Ajout support types de puzzles (éducatifs)
/// - Interface simple pour remplacer SharedPreferences
///
/// 🔧 POINTS D'ATTENTION
/// - Cache doit être synchronisé avec la base
/// - Gestion des erreurs SQLite
/// - Fallback vers valeurs par défaut
///
/// 🚀 PROCHAINES ÉTAPES
/// - Créer les autres repositories (stats, history)
/// - Intégrer avec les providers Riverpod
/// - Ajouter validation des types de puzzles
///
/// 🔗 FICHIERS LIÉS
/// - lib/core/database/database_service.dart
/// - lib/core/database/models/database_models.dart
///
/// CRITICALITÉ: HAUTE - Repository principal des paramètres
/// 📅 Dernière modification: 2025-08-25 14:34
/// </cursor>

import '../database_service.dart';
import '../models/database_models.dart';

class GameSettingsRepository {
  final DatabaseService _databaseService;
  GameSettingsDb? _cachedSettings;

  GameSettingsRepository(this._databaseService);

  /// Récupère les paramètres actuels (avec cache)
  Future<GameSettingsDb> getSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final results = await _databaseService.query(
      'game_settings',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (results.isNotEmpty) {
      _cachedSettings = GameSettingsDb.fromMap(results.first);
      return _cachedSettings!;
    }

    // Retourne des paramètres par défaut si aucun n'existe
    final defaultSettings = const GameSettingsDb(
      difficultyRows: 3,
      difficultyCols: 3,
      useCustomGridSize: false,
      hasSeenDocumentation: false,
      puzzleType: 1,
    );

    // Sauvegarde les paramètres par défaut
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  /// Sauvegarde les nouveaux paramètres
  Future<void> saveSettings(GameSettingsDb settings) async {
    final existingSettings = await _getExistingSettings();

    if (existingSettings != null) {
      // Mise à jour
      await _databaseService.update(
        'game_settings',
        settings.toMap(),
        where: 'id = ?',
        whereArgs: [existingSettings.id],
      );

      _cachedSettings = settings.copyWith(
        id: existingSettings.id,
        createdAt: existingSettings.createdAt,
        updatedAt: DateTime.now(),
      );
    } else {
      // Insertion
      final id = await _databaseService.insert(
        'game_settings',
        settings.toMap(),
      );

      _cachedSettings = settings.copyWith(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Met à jour la difficulté
  Future<void> updateDifficulty(int rows, int cols) async {
    final current = await getSettings();
    final updated = current.copyWith(
      difficultyRows: rows,
      difficultyCols: cols,
      updatedAt: DateTime.now(),
    );
    await saveSettings(updated);
  }

  /// Met à jour le flag de documentation vue
  Future<void> markDocumentationSeen() async {
    final current = await getSettings();
    if (!current.hasSeenDocumentation) {
      final updated = current.copyWith(
        hasSeenDocumentation: true,
        updatedAt: DateTime.now(),
      );
      await saveSettings(updated);
    }
  }

  /// Met à jour l'utilisation de grille custom
  Future<void> updateCustomGridUsage(bool useCustom) async {
    final current = await getSettings();
    final updated = current.copyWith(
      useCustomGridSize: useCustom,
      updatedAt: DateTime.now(),
    );
    await saveSettings(updated);
  }

  /// Met à jour le type de puzzle
  Future<void> updatePuzzleType(int type) async {
    final current = await getSettings();
    final updated = current.copyWith(
      puzzleType: type,
      updatedAt: DateTime.now(),
    );
    await saveSettings(updated);
  }

  /// Remet les paramètres par défaut
  Future<void> resetToDefaults() async {
    const defaultSettings = GameSettingsDb(
      difficultyRows: 3,
      difficultyCols: 3,
      useCustomGridSize: false,
      hasSeenDocumentation: false,
      puzzleType: 1,
    );

    await saveSettings(defaultSettings);
  }

  /// Vide le cache (utile pour les tests)
  void clearCache() {
    _cachedSettings = null;
  }

  /// Récupère les paramètres existants en base (sans cache)
  Future<GameSettingsDb?> _getExistingSettings() async {
    final results = await _databaseService.query(
      'game_settings',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (results.isNotEmpty) {
      return GameSettingsDb.fromMap(results.first);
    }
    return null;
  }
}
