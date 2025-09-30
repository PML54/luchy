/// <cursor>
///
/// philo_quiz_loader.dart
///
/// Chargeur de quiz EVA PHILO depuis le fichier CSV philo_bac.csv
/// Remplace les données statiques par un chargement dynamique
///
/// COMPOSANTS PRINCIPAUX:
/// - PhiloEvalLoader: Chargeur de données CSV
/// - loadPhiloEvalData(): Chargement de tous les couples
/// - Intégration avec EvalManager existant
///
/// ÉTAT ACTUEL:
/// - Chargement CSV: philo_bac.csv (130+ concepts philosophiques)
/// - Format: col1;col2;col3 (philosophe;concept;définition)
/// - Intégration: Compatible avec EvalManager
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-29: CRÉATION - Chargeur CSV pour EVA PHILO
/// - Remplacement des données statiques par chargement dynamique
///
/// 🔧 POINTS D'ATTENTION:
/// - Format CSV: col1;col2;col3
/// - Philosophes: Socrate, Platon, Aristote, etc.
/// - Encodage UTF-8 requis
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans EvalManager
/// - Cache des données chargées
///
/// 🔗 FICHIERS LIÉS:
/// - philo_bac.csv (données source)
/// - quiz_config.dart (intégration)
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐
/// 📅 Dernière modification: 2025-09-29 05:30
/// </cursor>

import 'package:flutter/services.dart';

import 'quiz_config.dart';

/// Chargeur de quiz EVA PHILO depuis CSV
class PhiloEvalLoader {
  
  /// Charge toutes les données de philosophie depuis le CSV
  static Future<List<EvalPair>> loadPhiloEvalData() async {
    try {
      final String csvContent = await rootBundle.loadString('assets/csv/philo_bac.csv');
      final List<String> lines = csvContent.split('\n');
      
      final List<EvalPair> pairs = [];
      
      // Ignorer la première ligne (en-têtes)
      for (int i = 1; i < lines.length; i++) {
        final String line = lines[i].trim();
        if (line.isEmpty) continue;
        
        final List<String> columns = line.split(';');
        if (columns.length >= 3) {
          final String philosophe = columns[0].trim();
          final String concept = columns[1].trim();
          final String definition = columns[2].trim();
          
          pairs.add(EvalPair(
            col1: philosophe,
            col2: concept,
            col3: definition,
          ));
        }
      }
      
      return pairs;
    } catch (e) {
      print('Erreur lors du chargement du CSV philo_bac.csv: $e');
      return [];
    }
  }
}




