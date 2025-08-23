/// <cursor>
/// COMPOSANTS PRINCIPAUX
/// - Providers Riverpod pour l'injection des services SQLite
/// - DatabaseService singleton provider
/// - GameSettingsRepository provider avec injection automatique
/// 
/// ÉTAT ACTUEL
/// - Providers configurés pour injection de dépendances
/// - Pattern singleton pour DatabaseService
/// - Repository avec dépendances injectées
/// 
/// HISTORIQUE RÉCENT
/// - 2024-12-19: Création des providers de base SQLite
/// - Injection propre avec Riverpod
/// 
/// 🔧 POINTS D'ATTENTION
/// - DatabaseService en singleton pour éviter conflits
/// - Providers async pour gestion de l'initialisation
/// - Gestion des erreurs d'initialisation
/// 
/// 🚀 PROCHAINES ÉTAPES
/// - Intégrer dans les providers de jeu existants
/// - Ajouter providers pour stats et history
/// - Tester l'injection complète
/// 
/// 🔗 FICHIERS LIÉS
/// - lib/features/puzzle/domain/providers/game_providers.dart
/// - lib/core/database/database_service.dart
/// 
/// CRITICALITÉ: HAUTE - Injection de dépendances centrale
/// 📅 Dernière modification: 2024-12-19 16:45
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

  /// Remet les paramètres par défaut
  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
    _ref.invalidate(currentGameSettingsProvider);
  }
}
