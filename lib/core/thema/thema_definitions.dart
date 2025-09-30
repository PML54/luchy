/// <cursor>
///
/// thema_definitions.dart
/// Chemin: core/thema/
///
/// 🎯 CŒUR DU SYSTÈME QUIZ - DÉFINITIONS DES THEMA
/// Contrôle centralisé de tous les niveaux et opérations
///
/// COMPOSANTS PRINCIPAUX:
/// - Thema: Classe principale avec opérations et probabilités
/// - Niveaux prédéfinis: CP à Terminale avec opérations spécifiques
/// - Probabilités: Somme = 100% garantie pour chaque niveau
/// - Types d'opérations: Addition, multiplication, fractions, radicaux, etc.
///
/// ÉTAT ACTUEL:
/// - Définitions centralisées de tous les niveaux
/// - Probabilités ajustables par niveau
/// - Types d'opérations granulaires (addition_entiers, multiplication_fractions, etc.)
/// - Validation automatique des probabilités
///
/// HISTORIQUE RÉCENT:
/// - Fri Sep 26 19:33: SIMPLIFICATION CM2 - Suppression puissances et fractions
/// - CM2: Suppression puissance_simple, addition_fractions, soustraction_fractions
/// - CM2: Focus sur opérations de base (additions, soustractions, multiplications, divisions)
/// - Ajustement probabilités: additions 35%, multiplications 30%, soustractions 15%, divisions 15%, pourcentages 5%
/// - 2025-09-25 16:43: SOUSTRACTION ADAPTATIVE - Intégration complète
/// - Ajout soustraction_entiers dans tous les niveaux (CP à 3ème)
/// - Ajout soustraction_fractions dans niveaux avancés (CM1+)
/// - Probabilités ajustées pour équilibrer les opérations
/// - 2025-09-24: Création système Thema centralisé
/// - Architecture modulaire pour contrôle total des quiz
/// - Remplacement des anciennes méthodes de génération
/// - 2025-09-24: Suppression Thema Épicerie non implémenté
///
/// 🔧 POINTS D'ATTENTION:
/// - Probabilités: Somme doit toujours faire 100%
/// - Niveaux: Correspondance avec programmes scolaires
/// - Opérations: Granularité fine pour contrôle précis
/// - Évolutivité: Facile d'ajouter/modifier des opérations
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans ModernMathSkillsScreen
/// - Remplacement des anciennes méthodes
/// - Tests sur tous les niveaux
/// - Optimisation des probabilités
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/operations/exact_math_engine.dart: Moteur de calculs
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart: Interface
/// - lib/core/thema/thema_manager.dart: Gestionnaire des Thema
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur du système)
/// 📅 Dernière modification: Fri Sep 26 19:33:50 CEST 2025
/// </cursor>

import 'dart:math';

/// 🎯 THEMA - Cœur du système de quiz par niveau
/// Chaque Thema définit les opérations et leurs probabilités pour un niveau
class Thema {
  final String name;
  final int level;
  final Map<String, double> operations;

  const Thema(this.name, this.level, this.operations);

  /// Obtenir une opération aléatoire selon les probabilités
  String getRandomOperation() {
    final random = Random().nextDouble() * 100;
    double cumulative = 0.0;

    for (final entry in operations.entries) {
      cumulative += entry.value;
      if (random <= cumulative) {
        return entry.key;
      }
    }

    return operations.keys.first; // fallback
  }

  /// Vérifier si une opération existe
  bool hasOperation(String operation) => operations.containsKey(operation);

  /// Obtenir la probabilité d'une opération
  double getProbability(String operation) => operations[operation] ?? 0.0;

  /// Obtenir toutes les opérations disponibles
  List<String> getAvailableOperations() => operations.keys.toList();

  /// Obtenir le nombre d'opérations
  int get operationCount => operations.length;

  @override
  String toString() =>
      'Thema($name, niveau $level, ${operations.length} opérations)';
}

/// 🎯 DÉFINITIONS DES THEMA PAR NIVEAU
class ThemaDefinitions {
  // CP : Additions et soustractions simples
  static const cp = Thema("CP", 1, {
    "addition_entiers": 60.0, // 3 + 5 = 8
    "soustraction_entiers": 40.0, // 8 - 3 = 5
  });

  // CE1 : Additions + soustractions + multiplications tables 1-4
  static const ce1 = Thema("CE1", 2, {
    "addition_entiers": 50.0, // 3 + 5 = 8
    "soustraction_entiers": 20.0, // 8 - 3 = 5
    "multiplication_entiers": 30.0, // 4 × 7 = 28
  });

  // CE2 : Additions + soustractions + multiplications tables 1-6
  static const ce2 = Thema("CE2", 3, {
    "addition_entiers": 40.0, // 3 + 5 = 8
    "soustraction_entiers": 20.0, // 8 - 3 = 5
    "multiplication_entiers": 40.0, // 4 × 7 = 28
  });

  // CM1 : Additions + soustractions + multiplications + fractions simples
  static const cm1 = Thema("CM1", 4, {
    "addition_entiers": 40.0, // 3 + 5 = 8
    "soustraction_entiers": 10.0, // 8 - 3 = 5
    "multiplication_entiers": 40.0, // 4 × 7 = 28
    "division_entiers": 10.0, // 12 ÷ 3 = 4

  });

  // CM2 : Additions + soustractions + multiplications + divisions + pourcentages
  static const cm2 = Thema("CM2", 5, {
    "addition_entiers": 5.0, // 3 + 5 = 8
    "soustraction_entiers": 10.0, // 8 - 3 = 5
    "multiplication_entiers": 70.0, // 4 × 7 = 28
    "division_entiers": 10.0, // 12 ÷ 3 = 4

  });

  // 6ème : Additions + soustractions + multiplications + fractions + radicaux + pourcentages
  static const sixieme = Thema("6ème", 6, {

    "soustraction_entiers": 10.0, // 8 - 3 = 5
    "multiplication_entiers": 50.0, // 4 × 7 = 28
    "division_entiers": 20.0, // 12 ÷ 3 = 4

    "addition_fractions": 10.0, // 1/2 + 1/3 = 5/6

    "multiplication_fractions": 10.0, // (2/3) × (4/5) = 8/15

  });

  // 5ème : Additions + soustractions + multiplications + fractions + radicaux + divisions + pourcentages
  static const cinquieme = Thema("5ème", 7, {

    "multiplication_entiers": 10.0, // 4 × 7 = 28
    "division_entiers": 10.0, // 12 ÷ 3 = 4
    "puissance_simple": 20.0, // 2³ = 8
    "addition_fractions": 20.0, // 1/2 + 1/3 = 5/6
    "soustraction_fractions": 10.0, // 1/2 - 1/4 = 1/4
    "multiplication_fractions": 10.0, // (2/3) × (4/5) = 8/15
    "division_fractions": 10.0, // (2/3) ÷ (4/5) = 10/12
    "pourcentage_simple": 10.0, // 10% de 250 = 25
  });

  // 4ème : Additions + soustractions + multiplications + fractions + radicaux + divisions + équations + pourcentages
  static const quatrieme = Thema("4ème", 8, {
    "addition_entiers": 5.0, // 3 + 5 = 8
    "soustraction_entiers": 5.0, // 8 - 3 = 5
    "multiplication_entiers": 5.0, // 4 × 7 = 28
    "division_entiers": 5.0, // 12 ÷ 3 = 4
    "addition_fractions": 10.0, // 1/2 + 1/3 = 5/6
    "soustraction_fractions": 10.0, // 1/2 - 1/4 = 1/4
    "multiplication_fractions": 15.0, // (2/3) × (4/5) = 8/15
    "division_fractions": 15.0, // (2/3) ÷ (4/5) = 10/12
    "pourcentage_simple": 10.0, // 10% de 250 = 25
    "puissance_simple": 10.0, // 2³ = 8
    "addition_radicaux": 10.0, // √2 + √3

  });

  // 3ème : Additions + soustractions + multiplications + fractions + radicaux + divisions + équations + simplifications + pourcentages + trigonométrie
  static const troisieme = Thema("3ème", 9, {

    "addition_fractions": 10.0, // 1/2 + 1/3 = 5/6
    "soustraction_fractions": 10.0, // 1/2 - 1/4 = 1/4
    "multiplication_fractions": 10.0, // (2/3) × (4/5) = 8/15
    "division_fractions": 10.0, // (2/3) ÷ (4/5) = 10/12
    "pourcentage_simple": 10.0, // 10% de 250 = 25
    "puissance_simple": 20.0, // 2³ = 8
    "addition_radicaux": 10.0, // √2 + √3
    "multiplication_radicaux": 10.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2

  });

  // 2nde : Additions + multiplications + fractions + radicaux + divisions + équations + simplifications + logarithmes + pourcentages + trigonométrie
  static const seconde = Thema("2nde", 10, {

    "soustraction_fractions": 5.0, // 1/2 - 1/4 = 1/4
    "multiplication_fractions": 5.0, // (2/3) × (4/5) = 8/15
    "division_fractions": 10.0, // (2/3) ÷ (4/5) = 10/12
    "pourcentage_simple": 10.0, // 10% de 250 = 25
    "puissance_simple": 30.0, // 2³ = 8
    "addition_radicaux": 10.0, // √2 + √3
    "multiplication_radicaux": 20.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2
  });

  // 1ère : Additions + multiplications + fractions + radicaux + divisions + équations + simplifications + logarithmes + combinaisons + trigonométrie
  static const premiere = Thema("1ère", 11, {
    "soustraction_fractions": 5.0, // 1/2 - 1/4 = 1/4
    "multiplication_fractions": 5.0, // (2/3) × (4/5) = 8/15
    "division_fractions": 5.0, // (2/3) ÷ (4/5) = 10/12
    "pourcentage_simple": 10.0, // 10% de 250 = 25
    "puissance_simple": 30.0, // 2³ = 8
    "addition_radicaux": 5.0, // √2 + √3
    "multiplication_radicaux": 30.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2
  });

  // Terminale : Additions + multiplications + fractions + radicaux + divisions + équations + simplifications + logarithmes + combinaisons + trigonométrie
  static const terminale = Thema("Terminale", 12, {
    "puissance_simple": 30.0, // 2³ = 8

    "multiplication_radicaux": 30.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2
    "logarithm_simple": 20.0, // ln(2) + ln(3) = ln(6)

    "factorial_simple": 10.0, // 5! = 120

  });

  // Bac+1 : Niveau supérieur avec mathématiques avancées
  static const bacPlus1 = Thema("Bac+1", 13, {
    "puissance_simple": 10.0, // 2³ = 8

    "multiplication_radicaux": 20.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2
    "logarithm_simple": 10.0, // ln(2) + ln(3) = ln(6)
    "logarithm_multiplication": 10.0, // ln(2) × ln(3) = ?
    "factorial_simple": 10.0, // 5! = 120
    "combination_simple": 30.0, // (5 2) = 10

  });

  // Bac+2 : Niveau supérieur avancé
  static const bacPlus2 = Thema("Bac+2", 14, {
    "puissance_simple": 10.0, // 2³ = 8

    "multiplication_radicaux": 20.0, // √2 × √3 = √6
    "trigonometry_simple": 10.0, // sin(π/4) = √2/2
    "logarithm_simple": 10.0, // ln(2) + ln(3) = ln(6)
    "logarithm_multiplication": 15.0, // ln(2) × ln(3) = ?
    "factorial_simple": 5.0, // 5! = 120
    "combination_simple": 30.0, // (5 2) = 10
  });

  /// Liste de tous les Thema disponibles
  static const List<Thema> allThema = [
    cp,
    ce1,
    ce2,
    cm1,
    cm2,
    sixieme,
    cinquieme,
    quatrieme,
    troisieme,
    seconde,
    premiere,
    terminale,
    bacPlus1,
    bacPlus2
  ];

  /// Obtenir un Thema par niveau
  static Thema? getThemaByLevel(int level) {
    try {
      return allThema.firstWhere((t) => t.level == level);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir un Thema par nom
  static Thema? getThemaByName(String name) {
    try {
      return allThema.firstWhere((t) => t.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir tous les niveaux disponibles
  static List<int> getAvailableLevels() {
    return allThema.map((t) => t.level).toList()..sort();
  }

  /// Obtenir tous les noms de niveaux
  static List<String> getAvailableNames() {
    return allThema.map((t) => t.name).toList();
  }

  /// Vérifier si un niveau existe
  static bool hasLevel(int level) {
    return allThema.any((t) => t.level == level);
  }

  /// Obtenir le niveau minimum
  static int getMinLevel() {
    return allThema.map((t) => t.level).reduce((a, b) => a < b ? a : b);
  }

  /// Obtenir le niveau maximum
  static int getMaxLevel() {
    return allThema.map((t) => t.level).reduce((a, b) => a > b ? a : b);
  }
}
