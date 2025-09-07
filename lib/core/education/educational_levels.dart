/// <cursor>
///
/// SYSTÈME DE NIVEAUX ÉDUCATIFS FRANÇAIS
///
/// Définit les 14 niveaux éducatifs du système français (CP à Prépa+2).
/// Chaque niveau correspond à une classe spécifique avec ses caractéristiques.
/// Structure compatible avec le système de puzzle et LaTeX existant.
///
/// COMPOSANTS PRINCIPAUX:
/// - EducationalLevel: Classe principale pour chaque niveau
/// - ValueRange: Intervalles de valeurs pour les paramètres
/// - Cycle: Classification par cycle éducatif
/// - NiveauEducatif: Enum des 14 niveaux
///
/// ÉTAT ACTUEL:
/// - 14 niveaux définis (CP à Prépa+2)
/// - Classification par cycles (Primaire, Collège, Lycée, Supérieur)
/// - Intervalles de valeurs par paramètre
/// - Couleurs et icônes distinctives
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU - Création du système de 14 niveaux éducatifs
/// - Structure compatible avec le système existant
/// - Intervalles de valeurs configurables par niveau
///
/// 🔧 POINTS D'ATTENTION:
/// - Compatibilité avec le système LaTeX existant
/// - Intervalles de valeurs adaptés à chaque niveau
/// - Progression logique des difficultés
/// - Support des opérations complexes selon le niveau
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration avec les moteurs de quiz existants
/// - Migration des formules vers le nouveau système
/// - Ajout de la logique de génération par niveau
/// - Tests sur tous les niveaux
///
/// 🔗 FICHIERS LIÉS:
/// - lib/features/puzzle/domain/models/game_state.dart: NiveauDifficulte actuel
/// - lib/core/operations/numerical_skills_engine.dart: Moteur de quiz
/// - lib/core/operations/fraction_skills_engine.dart: Moteur de fractions
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (5/5 étoiles)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Intervalle de valeurs pour un paramètre de formule
class ValueRange {
  final int min;
  final int max;
  final bool allowDecimals;
  final List<int>? preferredValues; // Valeurs préférées (optionnel)
  final String description; // Description de l'intervalle

  const ValueRange({
    required this.min,
    required this.max,
    this.allowDecimals = false,
    this.preferredValues,
    this.description = '',
  });

  /// Génère une valeur aléatoire dans l'intervalle
  int generateRandomValue(math.Random random) {
    if (preferredValues != null && preferredValues!.isNotEmpty) {
      return preferredValues![random.nextInt(preferredValues!.length)];
    }
    return min + random.nextInt(max - min + 1);
  }

  /// Vérifie si une valeur est dans l'intervalle
  bool contains(int value) {
    return value >= min && value <= max;
  }

  @override
  String toString() {
    return 'ValueRange($min-$max${allowDecimals ? ', decimals' : ''})';
  }
}

/// Cycle éducatif français
enum CycleEducatif {
  primaire('Primaire', 'École primaire', Colors.green, Icons.child_care),
  college('Collège', 'Collège', Colors.blue, Icons.school),
  lycee('Lycée', 'Lycée', Colors.orange, Icons.school_outlined),
  superieur('Supérieur', 'Enseignement supérieur', Colors.purple, Icons.military_tech);

  const CycleEducatif(this.nom, this.description, this.couleur, this.icone);
  final String nom;
  final String description;
  final Color couleur;
  final IconData icone;
}

/// Niveau éducatif français (CP à Prépa+2)
enum NiveauEducatif {
  cp(1, 'CP', 'Cours Préparatoire', CycleEducatif.primaire),
  ce1(2, 'CE1', 'Cours Élémentaire 1', CycleEducatif.primaire),
  ce2(3, 'CE2', 'Cours Élémentaire 2', CycleEducatif.primaire),
  cm1(4, 'CM1', 'Cours Moyen 1', CycleEducatif.primaire),
  cm2(5, 'CM2', 'Cours Moyen 2', CycleEducatif.primaire),
  sixieme(6, '6ème', 'Sixième', CycleEducatif.college),
  cinquieme(7, '5ème', 'Cinquième', CycleEducatif.college),
  quatrieme(8, '4ème', 'Quatrième', CycleEducatif.college),
  troisieme(9, '3ème', 'Troisième', CycleEducatif.college),
  seconde(10, '2nde', 'Seconde', CycleEducatif.lycee),
  premiere(11, '1ère', 'Première', CycleEducatif.lycee),
  terminale(12, 'Term', 'Terminale', CycleEducatif.lycee),
  prepa1(13, 'Prépa+1', 'Première année prépa', CycleEducatif.superieur),
  prepa2(14, 'Prépa+2', 'Deuxième année prépa', CycleEducatif.superieur);

  const NiveauEducatif(this.niveau, this.nom, this.description, this.cycle);
  final int niveau;
  final String nom;
  final String description;
  final CycleEducatif cycle;

  /// Couleur du niveau (héritée du cycle)
  Color get couleur => cycle.couleur;

  /// Icône du niveau (héritée du cycle)
  IconData get icone => cycle.icone;

  /// Vérifie si le niveau est en primaire
  bool get isPrimaire => cycle == CycleEducatif.primaire;

  /// Vérifie si le niveau est au collège
  bool get isCollege => cycle == CycleEducatif.college;

  /// Vérifie si le niveau est au lycée
  bool get isLycee => cycle == CycleEducatif.lycee;

  /// Vérifie si le niveau est supérieur
  bool get isSuperieur => cycle == CycleEducatif.superieur;

  /// Obtient le niveau précédent
  NiveauEducatif? get niveauPrecedent {
    if (niveau <= 1) return null;
    return NiveauEducatif.values.firstWhere((n) => n.niveau == niveau - 1);
  }

  /// Obtient le niveau suivant
  NiveauEducatif? get niveauSuivant {
    if (niveau >= 14) return null;
    return NiveauEducatif.values.firstWhere((n) => n.niveau == niveau + 1);
  }

  /// Obtient tous les niveaux d'un cycle
  static List<NiveauEducatif> getNiveauxDuCycle(CycleEducatif cycle) {
    return values.where((n) => n.cycle == cycle).toList();
  }

  /// Obtient le niveau par son numéro
  static NiveauEducatif? fromNiveau(int niveau) {
    try {
      return values.firstWhere((n) => n.niveau == niveau);
    } catch (e) {
      return null;
    }
  }
}

/// Classe principale pour gérer les niveaux éducatifs
class EducationalLevelManager {
  static const Map<NiveauEducatif, Map<String, ValueRange>> _parameterRanges = {
    // PRIMAIRE (CP à CM2)
    NiveauEducatif.cp: {
      'a': ValueRange(min: 1, max: 5, description: 'Nombres très simples'),
      'b': ValueRange(min: 1, max: 5, description: 'Nombres très simples'),
      'c': ValueRange(min: 1, max: 5, description: 'Nombres très simples'),
    },
    NiveauEducatif.ce1: {
      'a': ValueRange(min: 1, max: 10, description: 'Nombres simples'),
      'b': ValueRange(min: 1, max: 10, description: 'Nombres simples'),
      'c': ValueRange(min: 1, max: 10, description: 'Nombres simples'),
    },
    NiveauEducatif.ce2: {
      'a': ValueRange(min: 1, max: 20, description: 'Nombres jusqu\'à 20'),
      'b': ValueRange(min: 1, max: 20, description: 'Nombres jusqu\'à 20'),
      'c': ValueRange(min: 1, max: 20, description: 'Nombres jusqu\'à 20'),
    },
    NiveauEducatif.cm1: {
      'a': ValueRange(min: 1, max: 50, description: 'Nombres jusqu\'à 50'),
      'b': ValueRange(min: 1, max: 50, description: 'Nombres jusqu\'à 50'),
      'c': ValueRange(min: 1, max: 50, description: 'Nombres jusqu\'à 50'),
    },
    NiveauEducatif.cm2: {
      'a': ValueRange(min: 1, max: 100, description: 'Nombres jusqu\'à 100'),
      'b': ValueRange(min: 1, max: 100, description: 'Nombres jusqu\'à 100'),
      'c': ValueRange(min: 1, max: 100, description: 'Nombres jusqu\'à 100'),
    },
    
    // COLLÈGE (6ème à 3ème)
    NiveauEducatif.sixieme: {
      'a': ValueRange(min: 1, max: 100, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 100, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 100, description: 'Nombres entiers'),
    },
    NiveauEducatif.cinquieme: {
      'a': ValueRange(min: 1, max: 200, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 200, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 200, description: 'Nombres entiers'),
    },
    NiveauEducatif.quatrieme: {
      'a': ValueRange(min: 1, max: 500, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 500, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 500, description: 'Nombres entiers'),
    },
    NiveauEducatif.troisieme: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
    
    // LYCÉE (2nde à Terminale)
    NiveauEducatif.seconde: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
    NiveauEducatif.premiere: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
    NiveauEducatif.terminale: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
    
    // SUPÉRIEUR (Prépa+1 à Prépa+2)
    NiveauEducatif.prepa1: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
    NiveauEducatif.prepa2: {
      'a': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'b': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
      'c': ValueRange(min: 1, max: 1000, description: 'Nombres entiers'),
    },
  };

  /// Obtient les intervalles de valeurs pour un niveau donné
  static Map<String, ValueRange> getParameterRanges(NiveauEducatif niveau) {
    return _parameterRanges[niveau] ?? {};
  }

  /// Obtient l'intervalle pour un paramètre spécifique à un niveau
  static ValueRange? getParameterRange(NiveauEducatif niveau, String parameter) {
    return _parameterRanges[niveau]?[parameter];
  }

  /// Génère une valeur aléatoire pour un paramètre à un niveau donné
  static int generateParameterValue(NiveauEducatif niveau, String parameter, math.Random random) {
    final range = getParameterRange(niveau, parameter);
    if (range == null) {
      // Fallback: valeurs par défaut
      return 1 + random.nextInt(10);
    }
    return range.generateRandomValue(random);
  }

  /// Vérifie si un niveau supporte un paramètre
  static bool supportsParameter(NiveauEducatif niveau, String parameter) {
    return _parameterRanges[niveau]?.containsKey(parameter) ?? false;
  }

  /// Obtient tous les niveaux supportant un paramètre
  static List<NiveauEducatif> getNiveauxSupportantParametre(String parameter) {
    return NiveauEducatif.values.where((niveau) => 
      _parameterRanges[niveau]?.containsKey(parameter) ?? false
    ).toList();
  }
}
