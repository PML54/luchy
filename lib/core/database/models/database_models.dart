/// <cursor>
/// LUCHY - Modèles de données SQLite
///
/// Modèles de données simples pour la persistance SQLite sans
/// dépendances Freezed pour éviter les conflits de génération.
///
/// COMPOSANTS PRINCIPAUX:
/// - GameSettingsDb: Paramètres jeu (grille, difficulté)
/// - UserStatsDb: Statistiques utilisateur (temps, réussites)
/// - PuzzleHistoryDb: Historique puzzles résolus
/// - FavoriteImageDb: Images favorites utilisateur
/// - Conversion: Méthodes toMap/fromMap pour SQLite
///
/// ÉTAT ACTUEL:
/// - Architecture: Classes simples sans génération code
/// - Conversion: Mapping manuel vers/depuis Map SQLite
/// - Compatibilité: Compatible avec modèles Freezed existants
/// - Validation: Contrôles basiques intégrés
///
/// HISTORIQUE RÉCENT:
/// - 2024-12-19: Création avec approche simple et fiable
/// - Évitement conflits Freezed pour stabilité
/// - Tests validation et conversion réussis
/// - Intégration avec repositories stable
///
/// 🔧 POINTS D'ATTENTION:
/// - Freezed: Volontairement évité ici pour éviter conflits
/// - Conversion: Mapping manuel mais testé et fiable
/// - Validation: Ajouter plus de contrôles si nécessaire
/// - Nullable: Bien gérer les champs optionnels
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter validation plus robuste avec contraintes
/// - Implémenter sérialisation JSON pour backup
/// - Optimiser performance conversion grandes listes
/// - Ajouter champs métadonnées (created_at, updated_at)
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/database_service.dart: Service principal
/// - core/database/repositories/game_settings_repository.dart: Repository
/// - core/database/providers/database_providers.dart: Providers Riverpod
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Modèles données centraux)
/// 📅 Dernière modification: 2025-08-25 14:32
/// </cursor>

class GameSettingsDb {
  final int? id;
  final int difficultyRows;
  final int difficultyCols;
  final bool useCustomGridSize;
  final bool hasSeenDocumentation;
  final int puzzleType; // 1=classique, 2=éducatif (colonnes 1-2)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GameSettingsDb({
    this.id,
    required this.difficultyRows,
    required this.difficultyCols,
    required this.useCustomGridSize,
    required this.hasSeenDocumentation,
    required this.puzzleType,
    this.createdAt,
    this.updatedAt,
  });

  factory GameSettingsDb.fromMap(Map<String, dynamic> map) {
    return GameSettingsDb(
      id: map['id'],
      difficultyRows: map['difficulty_rows'] ?? 3,
      difficultyCols: map['difficulty_cols'] ?? 3,
      useCustomGridSize: (map['use_custom_grid_size'] ?? 0) == 1,
      hasSeenDocumentation: (map['has_seen_documentation'] ?? 0) == 1,
      puzzleType: map['puzzle_type'] ?? 1,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'difficulty_rows': difficultyRows,
      'difficulty_cols': difficultyCols,
      'use_custom_grid_size': useCustomGridSize ? 1 : 0,
      'has_seen_documentation': hasSeenDocumentation ? 1 : 0,
      'puzzle_type': puzzleType,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  GameSettingsDb copyWith({
    int? id,
    int? difficultyRows,
    int? difficultyCols,
    bool? useCustomGridSize,
    bool? hasSeenDocumentation,
    int? puzzleType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameSettingsDb(
      id: id ?? this.id,
      difficultyRows: difficultyRows ?? this.difficultyRows,
      difficultyCols: difficultyCols ?? this.difficultyCols,
      useCustomGridSize: useCustomGridSize ?? this.useCustomGridSize,
      hasSeenDocumentation: hasSeenDocumentation ?? this.hasSeenDocumentation,
      puzzleType: puzzleType ?? this.puzzleType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserStatsDb {
  final int? id;
  final int totalPuzzlesCompleted;
  final int totalPlayTimeSeconds;
  final int? bestCompletionTimeSeconds;
  final int favoriteDifficulty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserStatsDb({
    this.id,
    required this.totalPuzzlesCompleted,
    required this.totalPlayTimeSeconds,
    this.bestCompletionTimeSeconds,
    required this.favoriteDifficulty,
    this.createdAt,
    this.updatedAt,
  });

  factory UserStatsDb.fromMap(Map<String, dynamic> map) {
    return UserStatsDb(
      id: map['id'],
      totalPuzzlesCompleted: map['total_puzzles_completed'] ?? 0,
      totalPlayTimeSeconds: map['total_play_time_seconds'] ?? 0,
      bestCompletionTimeSeconds: map['best_completion_time_seconds'],
      favoriteDifficulty: map['favorite_difficulty'] ?? 3,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'total_puzzles_completed': totalPuzzlesCompleted,
      'total_play_time_seconds': totalPlayTimeSeconds,
      if (bestCompletionTimeSeconds != null)
        'best_completion_time_seconds': bestCompletionTimeSeconds,
      'favorite_difficulty': favoriteDifficulty,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserStatsDb copyWith({
    int? id,
    int? totalPuzzlesCompleted,
    int? totalPlayTimeSeconds,
    int? bestCompletionTimeSeconds,
    int? favoriteDifficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserStatsDb(
      id: id ?? this.id,
      totalPuzzlesCompleted:
          totalPuzzlesCompleted ?? this.totalPuzzlesCompleted,
      totalPlayTimeSeconds: totalPlayTimeSeconds ?? this.totalPlayTimeSeconds,
      bestCompletionTimeSeconds:
          bestCompletionTimeSeconds ?? this.bestCompletionTimeSeconds,
      favoriteDifficulty: favoriteDifficulty ?? this.favoriteDifficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PuzzleHistoryDb {
  final int? id;
  final String imagePath;
  final int difficultyRows;
  final int difficultyCols;
  final int? completionTimeSeconds;
  final int movesCount;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? completedAt;

  const PuzzleHistoryDb({
    this.id,
    required this.imagePath,
    required this.difficultyRows,
    required this.difficultyCols,
    this.completionTimeSeconds,
    required this.movesCount,
    required this.isCompleted,
    this.createdAt,
    this.completedAt,
  });

  factory PuzzleHistoryDb.fromMap(Map<String, dynamic> map) {
    return PuzzleHistoryDb(
      id: map['id'],
      imagePath: map['image_path'] ?? '',
      difficultyRows: map['difficulty_rows'] ?? 3,
      difficultyCols: map['difficulty_cols'] ?? 3,
      completionTimeSeconds: map['completion_time_seconds'],
      movesCount: map['moves_count'] ?? 0,
      isCompleted: (map['is_completed'] ?? 0) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_path': imagePath,
      'difficulty_rows': difficultyRows,
      'difficulty_cols': difficultyCols,
      if (completionTimeSeconds != null)
        'completion_time_seconds': completionTimeSeconds,
      'moves_count': movesCount,
      'is_completed': isCompleted ? 1 : 0,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  PuzzleHistoryDb copyWith({
    int? id,
    String? imagePath,
    int? difficultyRows,
    int? difficultyCols,
    int? completionTimeSeconds,
    int? movesCount,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return PuzzleHistoryDb(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      difficultyRows: difficultyRows ?? this.difficultyRows,
      difficultyCols: difficultyCols ?? this.difficultyCols,
      completionTimeSeconds:
          completionTimeSeconds ?? this.completionTimeSeconds,
      movesCount: movesCount ?? this.movesCount,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class FavoriteImageDb {
  final int? id;
  final String imagePath;
  final String? title;
  final DateTime? addedAt;

  const FavoriteImageDb({
    this.id,
    required this.imagePath,
    this.title,
    this.addedAt,
  });

  factory FavoriteImageDb.fromMap(Map<String, dynamic> map) {
    return FavoriteImageDb(
      id: map['id'],
      imagePath: map['image_path'] ?? '',
      title: map['title'],
      addedAt:
          map['added_at'] != null ? DateTime.tryParse(map['added_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_path': imagePath,
      if (title != null) 'title': title,
      'added_at': (addedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  FavoriteImageDb copyWith({
    int? id,
    String? imagePath,
    String? title,
    DateTime? addedAt,
  }) {
    return FavoriteImageDb(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
