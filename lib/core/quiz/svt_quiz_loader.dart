/// <cursor>
///
/// svt_quiz_loader.dart
///
/// Chargeur de quiz EVA SVT depuis le fichier CSV couples_final.csv
/// Remplace les données statiques par un chargement dynamique
///
/// COMPOSANTS PRINCIPAUX:
/// - SVTEvalLoader: Chargeur de données CSV
/// - loadSVTEvalData(): Chargement de tous les couples
/// - Intégration avec EvalManager existant
///
/// ÉTAT ACTUEL:
/// - Chargement CSV: couples_final.csv (300+ questions)
/// - Format: col1;col2;col3;col5 (terme;définition;explication;thème)
/// - Intégration: Compatible avec EvalManager
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: CRÉATION - Chargeur CSV pour EVA SVT
/// - Remplacement des données statiques par chargement dynamique
///
/// 🔧 POINTS D'ATTENTION:
/// - Format CSV: col1;col2;col3;col5
/// - Thèmes: 1A, 1B, 2A, 2B, 3
/// - Encodage UTF-8 requis
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans EvalManager
/// - Cache des données chargées
///
/// 🔗 FICHIERS LIÉS:
/// - couples_final.csv (données source)
/// - quiz_config.dart (intégration)
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐
/// 📅 Dernière modification: 2025-01-27 17:30
/// </cursor>

import 'package:flutter/services.dart';

import 'quiz_config.dart';

/// Chargeur de quiz EVA SVT depuis CSV
class SVTEvalLoader {
  static List<EvalPair>? _cachedPairs;
  static bool _isLoaded = false;

  /// Charge tous les couples SVT depuis le CSV
  static Future<List<EvalPair>> loadSVTEvalData() async {
    if (_isLoaded && _cachedPairs != null) {
      return _cachedPairs!;
    }

    try {
      final String csvContent =
          await rootBundle.loadString('assets/csv/couples_final.csv');
      final List<String> lines = csvContent.split('\n');

      final List<EvalPair> pairs = [];

      // Ignorer la première ligne (en-têtes)
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(';');
        if (parts.length >= 4) {
          final col1 = parts[0].trim();
          final col2 = parts[1].trim();
          final col3 = parts.length > 2 ? parts[2].trim() : '';
          final col5 = parts.length > 4 ? parts[4].trim() : '';

          // Utiliser col1 et col2 pour le quiz (terme ↔ définition)
          if (col1.isNotEmpty && col2.isNotEmpty) {
            pairs.add(EvalPair(
              col1: col1,
              col2: col2,
              col3: col3.isNotEmpty ? col3 : null,
              col5: col5.isNotEmpty ? col5 : null,
            ));
          }
        }
      }

      _cachedPairs = pairs;
      _isLoaded = true;

      print('✅ ${pairs.length} couples SVT chargés depuis CSV');
      return pairs;
    } catch (e) {
      print('❌ Erreur lors du chargement du CSV SVT: $e');
      return [];
    }
  }

  /// Obtient le nombre de couples par thème
  static Future<Map<String, int>> getThemeCounts() async {
    // final pairs = await loadSVTEvalData(); // Variable non utilisée
    final Map<String, int> counts = {};

    try {
      final String csvContent =
          await rootBundle.loadString('assets/csv/couples_final.csv');
      final List<String> lines = csvContent.split('\n');

      // Ignorer la première ligne (en-têtes)
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(';');
        if (parts.length >= 4) {
          final theme = parts[3].trim();
          if (theme.isNotEmpty) {
            counts[theme] = (counts[theme] ?? 0) + 1;
          }
        }
      }
    } catch (e) {
      print('❌ Erreur lors du comptage des thèmes: $e');
    }

    return counts;
  }

  /// Obtient tous les thèmes disponibles
  static Future<List<String>> getAvailableThemes() async {
    final counts = await getThemeCounts();
    return counts.keys.toList()..sort();
  }
}
