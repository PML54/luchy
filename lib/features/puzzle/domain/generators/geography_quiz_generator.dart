/// <cursor>
///
/// geography_quiz_generator.dart
///
/// Générateur de quiz géographiques utilisant la base de données pays-capitales.
/// Sélectionne aléatoirement 6 pays et leurs capitales pour créer un puzzle
/// éducatif compatible avec la mécanique drag & drop existante.
///
/// COMPOSANTS PRINCIPAUX:
/// - generateGeographyQuiz(): Génération aléatoire 6 pays-capitales
/// - filterSimpleCapitals(): Filtrage capitales simples (évite "Paris / Londres")
/// - GeographyQuizResult: Structure de données résultat
/// - Integration avec EducationalImageGenerator existant
///
/// ÉTAT ACTUEL:
/// - Génération: 6 pays aléatoires avec capitales simples
/// - Filtrage: Évite les pays avec capitales multiples complexes
/// - Compatibilité: Format compatible avec mécanique puzzle existante
/// - Aléatoire: Sélection équitable sur tous les continents
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-10: CRÉATION - Générateur quiz géographique pour intégration
/// - Utilise dataset pays_capitales_continents.dart (226 pays)
/// - Format compatible avec EducationalImageGenerator
/// - Mécanique identique aux quiz mathématiques
///
/// 🔧 POINTS D'ATTENTION:
/// - Certains pays ont capitales multiples (ex: "Pretoria / Le Cap / Bloemfontein")
/// - Filtrage nécessaire pour éviter confusion utilisateur
/// - Encodage UTF-8 requis pour caractères accentués
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajout filtrage par continent/difficulté
/// - Support capitales multiples avec choix
/// - Intégration statistiques apprentissage
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/constants/pays_capitales_continents.dart (données source)
/// - lib/core/utils/educational_image_generator.dart (génération image)
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart (mécanique)
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Échelle de 1 à 5 étoiles)
/// 📅 Dernière modification: Mer 10 sep 2025 08:00:00 CEST
/// </cursor>

import 'dart:math' as math;

import '../../../../core/constants/pays_capitales_continents.dart';

/// Type de quiz géographique
enum GeographyQuizMode {
  capitalsToCountries('Capitales ↔ Pays');

  const GeographyQuizMode(this.displayName);
  final String displayName;
}

/// Résultat d'un quiz géographique généré
class GeographyQuizResult {
  final List<String> leftColumn; // Colonne gauche (questions)
  final List<String> rightColumn; // Colonne droite (réponses)
  final List<String> countries; // Liste des pays
  final List<String> capitals; // Liste des capitales
  final List<String> currencies; // Liste des monnaies
  final List<String> continents; // Continents des pays sélectionnés
  final String description; // Description du quiz
  final GeographyQuizMode mode; // Type de quiz

  const GeographyQuizResult({
    required this.leftColumn,
    required this.rightColumn,
    required this.countries,
    required this.capitals,
    required this.currencies,
    required this.continents,
    required this.description,
    required this.mode,
  });
}

/// Générateur de quiz géographiques
class GeographyQuizGenerator {
  static final math.Random _random = math.Random();

  /// Génère un quiz géographique avec mode aléatoire ou spécifique
  ///
  /// Filtre automatiquement les pays avec des capitales trop complexes
  /// pour éviter la confusion (ex: "Pretoria / Le Cap / Bloemfontein")
  static GeographyQuizResult generateGeographyQuiz({
    int numberOfQuestions = 5,
    List<String>? continentFilter, // Optionnel: filtrer par continent
    GeographyQuizMode? mode, // Optionnel: forcer un mode spécifique
  }) {
    // Filtrer les pays avec des capitales simples
    final simpleCapitalCountries =
        _filterSimpleCapitals(paysCapitalesContinents);

    // Appliquer le filtre par continent si spécifié
    List<Map<String, String>> availableCountries = simpleCapitalCountries;
    if (continentFilter != null && continentFilter.isNotEmpty) {
      availableCountries = simpleCapitalCountries
          .where((country) => continentFilter.contains(country['continent']))
          .toList();
    }

    // Vérifier qu'on a assez de pays disponibles
    if (availableCountries.length < numberOfQuestions) {
      throw Exception(
          'Pas assez de pays disponibles pour générer $numberOfQuestions questions. '
          'Disponibles: ${availableCountries.length}');
    }

    // Forcer le mode Capitales ↔ Pays uniquement
    final selectedMode = GeographyQuizMode.capitalsToCountries;

    // Mélanger et sélectionner les pays
    availableCountries.shuffle(_random);
    final selectedCountries =
        availableCountries.take(numberOfQuestions).toList();

    // Extraire les données de base
    final countries = selectedCountries.map((c) => c['pays']!).toList();
    final capitals = selectedCountries.map((c) => c['capitale']!).toList();
    final currencies = selectedCountries.map((c) => c['monnaie']!).toList();
    final continents = selectedCountries.map((c) => c['continent']!).toList();

    // Construire les colonnes pour le mode Capitales ↔ Pays
    final leftColumn = capitals;
    final rightColumn = countries;
    
    // Construire la description
    String description = 'Quiz Géographie - ${selectedMode.displayName}';
    final continentCount = continents.toSet().length;
    if (continentCount > 1) {
      // final continentList = continents.toSet().join(', '); // Variable non utilisée
      description += ' ($continentCount continents)';
    }

    return GeographyQuizResult(
      leftColumn: leftColumn,
      rightColumn: rightColumn,
      countries: countries,
      capitals: capitals,
      currencies: currencies,
      continents: continents,
      description: description,
      mode: selectedMode,
    );
  }

  /// Génère un quiz géographique par continent spécifique
  static GeographyQuizResult generateGeographyQuizByContinent(
    String continent, {
    int numberOfQuestions = 5,
    GeographyQuizMode? mode,
  }) {
    return generateGeographyQuiz(
      numberOfQuestions: numberOfQuestions,
      continentFilter: [continent],
      mode: mode,
    );
  }

  /// Filtre les pays ayant des capitales simples (pas de "/")
  ///
  /// Évite les pays comme:
  /// - "Afrique du Sud" -> "Pretoria / Le Cap / Bloemfontein"
  /// - "Bolivie" -> "Sucre / La Paz"
  /// - "Eswatini" -> "Mbabane / Lobamba"
  static List<Map<String, String>> _filterSimpleCapitals(
      List<Map<String, String>> countries) {
    return countries.where((country) {
      final capitale = country['capitale'] ?? '';
      // Garder seulement les capitales sans "/"
      return !capitale.contains('/');
    }).toList();
  }

  /// Obtient la liste des continents disponibles
  static List<String> getAvailableContinents() {
    return paysCapitalesContinents
        .map((country) => country['continent']!)
        .toSet()
        .toList()
      ..sort();
  }

  /// Obtient le nombre de pays disponibles par continent (capitales simples seulement)
  static Map<String, int> getCountriesCountByContinent() {
    final simpleCapitalCountries =
        _filterSimpleCapitals(paysCapitalesContinents);
    final Map<String, int> counts = {};

    for (final country in simpleCapitalCountries) {
      final continent = country['continent']!;
      counts[continent] = (counts[continent] ?? 0) + 1;
    }

    return counts;
  }

  /// Génère des statistiques sur les données géographiques disponibles
  static Map<String, dynamic> getGeographyStats() {
    final total = paysCapitalesContinents.length;
    final simpleCapitals = _filterSimpleCapitals(paysCapitalesContinents);
    final simpleCount = simpleCapitals.length;
    final complexCount = total - simpleCount;

    return {
      'total_countries': total,
      'simple_capitals': simpleCount,
      'complex_capitals': complexCount,
      'continents': getAvailableContinents(),
      'countries_by_continent': getCountriesCountByContinent(),
    };
  }

}
