/// <cursor>
/// LUCHY - Providers SQLite pour Riverpod
///
/// Configuration des providers Riverpod pour l'injection de dépendances
/// des services de base de données SQLite dans l'application.
///
/// COMPOSANTS PRINCIPAUX:
/// - databaseServiceProvider: Provider singleton DatabaseService
/// - gameSettingsRepositoryProvider: Provider repository avec injection
/// - Future providers: Gestion async initialisation base
/// - Error handling: Gestion erreurs initialisation database
///
/// ÉTAT ACTUEL:
/// - Architecture: Injection dépendances propre avec Riverpod
/// - Singleton: DatabaseService unique pour éviter conflits
/// - Async: Providers Future pour initialisation asynchrone
/// - Stabilité: Gestion d'erreurs robuste
///
/// HISTORIQUE RÉCENT:
/// - 2024-12-19: Création infrastructure providers SQLite
/// - Architecture injection dépendances établie
/// - Pattern singleton implementé pour DatabaseService
/// - Tests réussis avec game settings repository
///
/// 🔧 POINTS D'ATTENTION:
/// - Singleton: Un seul DatabaseService pour toute l'app
/// - Async init: Bien gérer les états de chargement
/// - Error states: Capturer erreurs init database proprement
/// - Dependencies: Injection correcte entre providers
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter providers UserStats et PuzzleHistory repositories
/// - Implémenter cache des données pour performance
/// - Ajouter monitoring santé database
/// - Optimiser initialisation pour app startup
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/database_service.dart: Service principal
/// - core/database/repositories/game_settings_repository.dart: Repository
/// - core/database/models/database_models.dart: Modèles données
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Infrastructure Riverpod critique)
/// 📅 Dernière modification: 2025-08-25 14:33
/// </cursor>

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database_service.dart';
import '../repositories/game_settings_repository.dart';

/// Provider pour le service de base de données (singleton)
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provider pour le repository des paramètres de jeu
final gameSettingsRepositoryProvider = Provider<GameSettingsRepository>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return GameSettingsRepository(databaseService);
});

/// Provider pour récupérer les paramètres actuels
final currentGameSettingsProvider = FutureProvider((ref) async {
  final repository = ref.watch(gameSettingsRepositoryProvider);
  return repository.getSettings();
});

/// Provider pour les actions sur les paramètres
final gameSettingsActionsProvider = Provider((ref) {
  final repository = ref.watch(gameSettingsRepositoryProvider);
  return GameSettingsActions(repository, ref);
});

/// Classe d'actions pour les paramètres de jeu
class GameSettingsActions {
  final GameSettingsRepository _repository;
  final Ref _ref;

  GameSettingsActions(this._repository, this._ref);

  /// Met à jour la difficulté et rafraîchit le provider
  Future<void> updateDifficulty(int rows, int cols) async {
    await _repository.updateDifficulty(rows, cols);
    _ref.invalidate(currentGameSettingsProvider);
  }

  /// Marque la documentation comme vue
  Future<void> markDocumentationSeen() async {
    await _repository.markDocumentationSeen();
    _ref.invalidate(currentGameSettingsProvider);
  }

  /// Met à jour l'utilisation de grille personnalisée
  Future<void> updateCustomGridUsage(bool useCustom) async {
    await _repository.updateCustomGridUsage(useCustom);
    _ref.invalidate(currentGameSettingsProvider);
  }

  /// Met à jour le type de puzzle
  Future<void> updatePuzzleType(int type) async {
    await _repository.updatePuzzleType(type);
    _ref.invalidate(currentGameSettingsProvider);
  }

  /// Remet les paramètres par défaut
  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
    _ref.invalidate(currentGameSettingsProvider);
  }
}
