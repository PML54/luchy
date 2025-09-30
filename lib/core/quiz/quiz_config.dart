/// <cursor>
///
/// quiz_config.dart
///
/// Configuration générique pour tous les types de quiz
/// Structure standardisée avec code, catégorie et couples de données
///
/// COMPOSANTS PRINCIPAUX:
/// - EvalConfig : Configuration complète d'un quiz
/// - EvalPair : Couple de données (question, réponse)
/// - EvalManager : Gestionnaire central des quiz
///
/// ÉTAT ACTUEL:
/// - Structure générique pour tous les quiz
/// - Support des catégories (Géographie, Chimie, Code de la route, SVT, Philosophie)
/// - Codes uniques pour chaque quiz
/// - Système de génération aléatoire
/// - Support des quiz image-texte (panneaux de signalisation, drapeaux)
/// - Eval drapeaux du monde avec 100+ pays
/// - EVA SVT avec chargement dynamique depuis CSV (300+ questions)
/// - EVA PHILO avec chargement dynamique depuis CSV (130+ concepts)
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27 : Création de la structure générique
/// - 2025-01-27 : Support des catégories et codes
/// - 2025-01-27 : Intégration des données géographie
/// - 2025-09-26 : Ajout quiz Code de la route avec images
/// - 2025-01-27 : Ajout quiz Drapeaux du monde avec 100+ pays
/// - 2025-01-27 : Ajout EVA SVT avec chargement CSV dynamique
/// - 2025-09-29 : Ajout EVA PHILO avec chargement CSV dynamique
///
/// 🔧 POINTS D'ATTENTION:
/// - Codes uniques : GEO_CAP, CHIM_ELEM, ROUTE_PANNEAUX, DRAPEAUX_MONDE, SVT_EVA, PHILO_EVA
/// - Catégories : Géographie, Chimie, Code de la route, SVT Terminale, Philosophie
/// - Support texte-texte et image-texte
/// - Images SVG dans assets/panneaux/ et assets/flags/
/// - CSV dans assets/csv/ pour EVA SVT et EVA PHILO
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration dans l'UI existante
/// - Ajout des quiz chimie et maths
/// - Système de progression par catégorie
/// - Support des quiz image-texte dans l'UI
///
/// 🔗 FICHIERS LIÉS:
/// - geography_skills_screen.dart (UI existante)
/// - modern_math_skills_screen.dart (référence)
/// - svt_quiz_loader.dart (chargement CSV SVT)
/// - philo_quiz_loader.dart (chargement CSV PHILO)
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐
/// 📅 Dernière modification: 2025-09-29 05:35
/// </cursor>

import 'philo_quiz_loader.dart';
import 'svt_quiz_loader.dart';

/// Couple de données pour un quiz
class EvalPair {
  final String col1; // Question (pays, département, élément, etc.)
  final String col2; // Réponse (capitale, numéro, symbole, etc.)
  final String? col3; // Explication (optionnel, pour SVT)
  final String? col5; // Thème (optionnel, pour SVT)

  const EvalPair({
    required this.col1,
    required this.col2,
    this.col3,
    this.col5,
  });
}

/// Configuration générique pour tous les types de quiz
class EvalConfig {
  final String code; // "GEO_CAP", "GEO_DEPT", "CHIM_ELEM", etc.
  final String category; // "Géographie", "Chimie", "Maths", etc.
  final String title; // "Capitales", "Départements", "Éléments", etc.
  final String titre1; // "Pays", "Nom", "Élément", etc.
  final String titre2; // "Capitale", "Numéro", "Symbole", etc.
  final List<EvalPair> pairs; // Liste des couples (col1, col2)

  const EvalConfig({
    required this.code,
    required this.category,
    required this.title,
    required this.titre1,
    required this.titre2,
    required this.pairs,
  });
}

/// Gestionnaire central des quiz
class EvalManager {
  static const Map<String, EvalConfig> _quizConfigs = {
    // HABILETÉS MATHS (Eval spécial - navigation directe) - EN PREMIER
    'MATH_HABILETES': EvalConfig(
      code: 'MATH_HABILETES',
      category: 'Mathématiques',
      title: 'Habileté Maths',
      titre1: 'Opération',
      titre2: 'Résultat',
      pairs: [], // Pas de données statiques - génération dynamique
    ),

    // EVA SVT TERMINALE
    'SVT_EVA': EvalConfig(
      code: 'SVT_EVA',
      category: 'SVT Terminale',
      title: 'EVA SVT',
      titre1: 'Terme',
      titre2: 'Définition',
      pairs: [], // Chargement dynamique depuis CSV
    ),

    // EVA PHILO BAC
    'PHILO_EVA': EvalConfig(
      code: 'PHILO_EVA',
      category: 'Philosophie',
      title: 'EVA PHILO',
      titre1: 'Philosophe',
      titre2: 'Concept',
      pairs: [], // Chargement dynamique depuis CSV
    ),

    // GÉOGRAPHIE
    'GEO_CAP': EvalConfig(
      code: 'GEO_CAP',
      category: 'Géographie',
      title: 'Capitales',
      titre1: 'Pays',
      titre2: 'Capitale',
      pairs: [
        EvalPair(col1: 'France', col2: 'Paris'),
        EvalPair(col1: 'Allemagne', col2: 'Berlin'),
        EvalPair(col1: 'Espagne', col2: 'Madrid'),
        EvalPair(col1: 'Italie', col2: 'Rome'),
        EvalPair(col1: 'Royaume-Uni', col2: 'Londres'),
        EvalPair(col1: 'Portugal', col2: 'Lisbonne'),
        EvalPair(col1: 'Belgique', col2: 'Bruxelles'),
        EvalPair(col1: 'Pays-Bas', col2: 'Amsterdam'),
        EvalPair(col1: 'Suisse', col2: 'Berne'),
        EvalPair(col1: 'Autriche', col2: 'Vienne'),
        EvalPair(col1: 'Pologne', col2: 'Varsovie'),
        EvalPair(col1: 'République tchèque', col2: 'Prague'),
        EvalPair(col1: 'Hongrie', col2: 'Budapest'),
        EvalPair(col1: 'Roumanie', col2: 'Bucarest'),
        EvalPair(col1: 'Bulgarie', col2: 'Sofia'),
        EvalPair(col1: 'Grèce', col2: 'Athènes'),
        EvalPair(col1: 'Turquie', col2: 'Ankara'),
        EvalPair(col1: 'Russie', col2: 'Moscou'),
        EvalPair(col1: 'Ukraine', col2: 'Kiev'),
        EvalPair(col1: 'Biélorussie', col2: 'Minsk'),
        EvalPair(col1: 'Lituanie', col2: 'Vilnius'),
        EvalPair(col1: 'Lettonie', col2: 'Riga'),
        EvalPair(col1: 'Estonie', col2: 'Tallinn'),
        EvalPair(col1: 'Finlande', col2: 'Helsinki'),
        EvalPair(col1: 'Suède', col2: 'Stockholm'),
        EvalPair(col1: 'Norvège', col2: 'Oslo'),
        EvalPair(col1: 'Danemark', col2: 'Copenhague'),
        EvalPair(col1: 'Islande', col2: 'Reykjavik'),
        EvalPair(col1: 'Irlande', col2: 'Dublin'),
        EvalPair(col1: 'Luxembourg', col2: 'Luxembourg'),
        EvalPair(col1: 'Malte', col2: 'La Valette'),
        EvalPair(col1: 'Chypre', col2: 'Nicosie'),
        EvalPair(col1: 'Slovaquie', col2: 'Bratislava'),
        EvalPair(col1: 'Slovénie', col2: 'Ljubljana'),
        EvalPair(col1: 'Croatie', col2: 'Zagreb'),
        EvalPair(col1: 'Bosnie-Herzégovine', col2: 'Sarajevo'),
        EvalPair(col1: 'Serbie', col2: 'Belgrade'),
        EvalPair(col1: 'Monténégro', col2: 'Podgorica'),
        EvalPair(col1: 'Macédoine du Nord', col2: 'Skopje'),
        EvalPair(col1: 'Albanie', col2: 'Tirana'),
        EvalPair(col1: 'Kosovo', col2: 'Pristina'),
        EvalPair(col1: 'Moldavie', col2: 'Chișinău'),
      ],
    ),
    'GEO_DEPT': EvalConfig(
      code: 'GEO_DEPT',
      category: 'Géographie',
      title: 'Départements',
      titre1: 'Département',
      titre2: 'Numéro',
      pairs: [
        EvalPair(col1: 'Ain', col2: '01'),
        EvalPair(col1: 'Aisne', col2: '02'),
        EvalPair(col1: 'Allier', col2: '03'),
        EvalPair(col1: 'Alpes-de-Haute-Provence', col2: '04'),
        EvalPair(col1: 'Hautes-Alpes', col2: '05'),
        EvalPair(col1: 'Alpes-Maritimes', col2: '06'),
        EvalPair(col1: 'Ardèche', col2: '07'),
        EvalPair(col1: 'Ardennes', col2: '08'),
        EvalPair(col1: 'Ariège', col2: '09'),
        EvalPair(col1: 'Aube', col2: '10'),
        EvalPair(col1: 'Aude', col2: '11'),
        EvalPair(col1: 'Aveyron', col2: '12'),
        EvalPair(col1: 'Bouches-du-Rhône', col2: '13'),
        EvalPair(col1: 'Calvados', col2: '14'),
        EvalPair(col1: 'Cantal', col2: '15'),
        EvalPair(col1: 'Charente', col2: '16'),
        EvalPair(col1: 'Charente-Maritime', col2: '17'),
        EvalPair(col1: 'Cher', col2: '18'),
        EvalPair(col1: 'Corrèze', col2: '19'),
        EvalPair(col1: 'Corse-du-Sud', col2: '2A'),
        EvalPair(col1: 'Haute-Corse', col2: '2B'),
        EvalPair(col1: 'Côte-d\'Or', col2: '21'),
        EvalPair(col1: 'Côtes-d\'Armor', col2: '22'),
        EvalPair(col1: 'Creuse', col2: '23'),
        EvalPair(col1: 'Dordogne', col2: '24'),
        EvalPair(col1: 'Doubs', col2: '25'),
        EvalPair(col1: 'Drôme', col2: '26'),
        EvalPair(col1: 'Eure', col2: '27'),
        EvalPair(col1: 'Eure-et-Loir', col2: '28'),
        EvalPair(col1: 'Finistère', col2: '29'),
        EvalPair(col1: 'Gard', col2: '30'),
        EvalPair(col1: 'Haute-Garonne', col2: '31'),
        EvalPair(col1: 'Gers', col2: '32'),
        EvalPair(col1: 'Gironde', col2: '33'),
        EvalPair(col1: 'Hérault', col2: '34'),
        EvalPair(col1: 'Ille-et-Vilaine', col2: '35'),
        EvalPair(col1: 'Indre', col2: '36'),
        EvalPair(col1: 'Indre-et-Loire', col2: '37'),
        EvalPair(col1: 'Isère', col2: '38'),
        EvalPair(col1: 'Jura', col2: '39'),
        EvalPair(col1: 'Landes', col2: '40'),
        EvalPair(col1: 'Loir-et-Cher', col2: '41'),
        EvalPair(col1: 'Loire', col2: '42'),
        EvalPair(col1: 'Haute-Loire', col2: '43'),
        EvalPair(col1: 'Loire-Atlantique', col2: '44'),
        EvalPair(col1: 'Loiret', col2: '45'),
        EvalPair(col1: 'Lot', col2: '46'),
        EvalPair(col1: 'Lot-et-Garonne', col2: '47'),
        EvalPair(col1: 'Lozère', col2: '48'),
        EvalPair(col1: 'Maine-et-Loire', col2: '49'),
        EvalPair(col1: 'Manche', col2: '50'),
        EvalPair(col1: 'Marne', col2: '51'),
        EvalPair(col1: 'Haute-Marne', col2: '52'),
        EvalPair(col1: 'Mayenne', col2: '53'),
        EvalPair(col1: 'Meurthe-et-Moselle', col2: '54'),
        EvalPair(col1: 'Meuse', col2: '55'),
        EvalPair(col1: 'Morbihan', col2: '56'),
        EvalPair(col1: 'Moselle', col2: '57'),
        EvalPair(col1: 'Nièvre', col2: '58'),
        EvalPair(col1: 'Nord', col2: '59'),
        EvalPair(col1: 'Oise', col2: '60'),
        EvalPair(col1: 'Orne', col2: '61'),
        EvalPair(col1: 'Pas-de-Calais', col2: '62'),
        EvalPair(col1: 'Puy-de-Dôme', col2: '63'),
        EvalPair(col1: 'Pyrénées-Atlantiques', col2: '64'),
        EvalPair(col1: 'Hautes-Pyrénées', col2: '65'),
        EvalPair(col1: 'Pyrénées-Orientales', col2: '66'),
        EvalPair(col1: 'Bas-Rhin', col2: '67'),
        EvalPair(col1: 'Haut-Rhin', col2: '68'),
        EvalPair(col1: 'Rhône', col2: '69'),
        EvalPair(col1: 'Haute-Saône', col2: '70'),
        EvalPair(col1: 'Saône-et-Loire', col2: '71'),
        EvalPair(col1: 'Sarthe', col2: '72'),
        EvalPair(col1: 'Savoie', col2: '73'),
        EvalPair(col1: 'Haute-Savoie', col2: '74'),
        EvalPair(col1: 'Paris', col2: '75'),
        EvalPair(col1: 'Seine-Maritime', col2: '76'),
        EvalPair(col1: 'Seine-et-Marne', col2: '77'),
        EvalPair(col1: 'Yvelines', col2: '78'),
        EvalPair(col1: 'Deux-Sèvres', col2: '79'),
        EvalPair(col1: 'Somme', col2: '80'),
        EvalPair(col1: 'Tarn', col2: '81'),
        EvalPair(col1: 'Tarn-et-Garonne', col2: '82'),
        EvalPair(col1: 'Var', col2: '83'),
        EvalPair(col1: 'Vaucluse', col2: '84'),
        EvalPair(col1: 'Vendée', col2: '85'),
        EvalPair(col1: 'Vienne', col2: '86'),
        EvalPair(col1: 'Haute-Vienne', col2: '87'),
        EvalPair(col1: 'Vosges', col2: '88'),
        EvalPair(col1: 'Yonne', col2: '89'),
        EvalPair(col1: 'Territoire-de-Belfort', col2: '90'),
        EvalPair(col1: 'Essonne', col2: '91'),
        EvalPair(col1: 'Hauts-de-Seine', col2: '92'),
        EvalPair(col1: 'Seine-Saint-Denis', col2: '93'),
        EvalPair(col1: 'Val-de-Marne', col2: '94'),
        EvalPair(col1: 'Val-d\'Oise', col2: '95'),
        EvalPair(col1: 'Guadeloupe', col2: '971'),
        EvalPair(col1: 'Martinique', col2: '972'),
        EvalPair(col1: 'Guyane', col2: '973'),
        EvalPair(col1: 'La Réunion', col2: '974'),
        EvalPair(col1: 'Mayotte', col2: '976'),
      ],
    ),

    // CHIMIE
    'CHIM_ELEM': EvalConfig(
      code: 'CHIM_ELEM',
      category: 'Chimie',
      title: 'Éléments chimiques',
      titre1: 'Élément',
      titre2: 'Symbole',
      pairs: [
        // Éléments groupés par première lettre (plus difficile)
        // Groupe H (5 éléments)
        EvalPair(col1: 'Hydrogène', col2: 'H'),
        EvalPair(col1: 'Hélium', col2: 'He'),
        EvalPair(col1: 'Hafnium', col2: 'Hf'),
        EvalPair(col1: 'Holmium', col2: 'Ho'),
        EvalPair(col1: 'Hassium', col2: 'Hs'),

        // Groupe C (8 éléments)
        EvalPair(col1: 'Carbone', col2: 'C'),
        EvalPair(col1: 'Calcium', col2: 'Ca'),
        EvalPair(col1: 'Chrome', col2: 'Cr'),
        EvalPair(col1: 'Cobalt', col2: 'Co'),
        EvalPair(col1: 'Cuivre', col2: 'Cu'),
        EvalPair(col1: 'Césium', col2: 'Cs'),
        EvalPair(col1: 'Cérium', col2: 'Ce'),
        EvalPair(col1: 'Curium', col2: 'Cm'),

        // Groupe S (6 éléments) - PIÈGES inclus
        EvalPair(
            col1: 'Sodium',
            col2: 'Na'), // PIÈGE: commence par S mais symbole Na
        EvalPair(col1: 'Silicium', col2: 'Si'),
        EvalPair(col1: 'Soufre', col2: 'S'),
        EvalPair(col1: 'Scandium', col2: 'Sc'),
        EvalPair(col1: 'Sélénium', col2: 'Se'),
        EvalPair(col1: 'Strontium', col2: 'Sr'),

        // Groupe P (6 éléments) - PIÈGES inclus
        EvalPair(col1: 'Phosphore', col2: 'P'),
        EvalPair(
            col1: 'Potassium',
            col2: 'K'), // PIÈGE: commence par P mais symbole K
        EvalPair(col1: 'Plomb', col2: 'Pb'),
        EvalPair(col1: 'Palladium', col2: 'Pd'),
        EvalPair(col1: 'Platine', col2: 'Pt'),
        EvalPair(col1: 'Plutonium', col2: 'Pu'),

        // Groupe F (4 éléments)
        EvalPair(col1: 'Fer', col2: 'Fe'),
        EvalPair(col1: 'Fluor', col2: 'F'),
        EvalPair(col1: 'Francium', col2: 'Fr'),
        EvalPair(col1: 'Fermium', col2: 'Fm'),

        // Groupe N (5 éléments)
        EvalPair(col1: 'Azote', col2: 'N'),
        EvalPair(col1: 'Néon', col2: 'Ne'),
        EvalPair(col1: 'Nickel', col2: 'Ni'),
        EvalPair(col1: 'Niobium', col2: 'Nb'),
        EvalPair(col1: 'Nobélium', col2: 'No'),

        // Groupe A (6 éléments) - PIÈGES inclus
        EvalPair(col1: 'Aluminium', col2: 'Al'),
        EvalPair(col1: 'Argon', col2: 'Ar'),
        EvalPair(col1: 'Arsenic', col2: 'As'),
        EvalPair(
            col1: 'Argent',
            col2: 'Ag'), // PIÈGE: commence par A mais symbole Ag
        EvalPair(col1: 'Actinium', col2: 'Ac'),
        EvalPair(col1: 'Américium', col2: 'Am'),

        // Groupe B (4 éléments)
        EvalPair(col1: 'Bore', col2: 'B'),
        EvalPair(col1: 'Béryllium', col2: 'Be'),
        EvalPair(col1: 'Brome', col2: 'Br'),
        EvalPair(col1: 'Baryum', col2: 'Ba'),

        // PIÈGES supplémentaires (éléments avec symboles non évidents)
        EvalPair(
            col1: 'Tungstène',
            col2: 'W'), // PIÈGE: commence par T mais symbole W
        EvalPair(
            col1: 'Mercure',
            col2: 'Hg'), // PIÈGE: commence par M mais symbole Hg
        EvalPair(
            col1: 'Or', col2: 'Au'), // PIÈGE: commence par O mais symbole Au
        EvalPair(
            col1: 'Étain', col2: 'Sn'), // PIÈGE: commence par É mais symbole Sn
        EvalPair(
            col1: 'Antimoine',
            col2: 'Sb'), // PIÈGE: commence par A mais symbole Sb

        // CAS SIMPLES (pour équilibrer)
        EvalPair(col1: 'Oxygène', col2: 'O'),
        EvalPair(col1: 'Azote', col2: 'N'),
        EvalPair(col1: 'Carbone', col2: 'C'),
        EvalPair(col1: 'Soufre', col2: 'S'),
        EvalPair(col1: 'Phosphore', col2: 'P'),
        EvalPair(col1: 'Chlore', col2: 'Cl'),
        EvalPair(col1: 'Brome', col2: 'Br'),
        EvalPair(col1: 'Iode', col2: 'I'),
        EvalPair(col1: 'Fluor', col2: 'F'),
        EvalPair(col1: 'Lithium', col2: 'Li'),
        EvalPair(col1: 'Béryllium', col2: 'Be'),
        EvalPair(col1: 'Bore', col2: 'B'),
        EvalPair(col1: 'Magnésium', col2: 'Mg'),
        EvalPair(col1: 'Aluminium', col2: 'Al'),
        EvalPair(col1: 'Silicium', col2: 'Si'),
      ],
    ),

    // DRAPEAUX DU MONDE
    'DRAPEAUX_MONDE': EvalConfig(
      code: 'DRAPEAUX_MONDE',
      category: 'Géographie',
      title: 'Drapeaux du monde',
      titre1: 'Pays',
      titre2: 'Drapeau',
      pairs: [
        EvalPair(col1: 'France', col2: 'assets/flags/fr.svg'),
        EvalPair(col1: 'États-Unis', col2: 'assets/flags/us.svg'),
        EvalPair(col1: 'Royaume-Uni', col2: 'assets/flags/gb.svg'),
        EvalPair(col1: 'Allemagne', col2: 'assets/flags/de.svg'),
        EvalPair(col1: 'Italie', col2: 'assets/flags/it.svg'),
        EvalPair(col1: 'Espagne', col2: 'assets/flags/es.svg'),
        EvalPair(col1: 'Canada', col2: 'assets/flags/ca.svg'),
        EvalPair(col1: 'Australie', col2: 'assets/flags/au.svg'),
        EvalPair(col1: 'Japon', col2: 'assets/flags/jp.svg'),
        EvalPair(col1: 'Chine', col2: 'assets/flags/cn.svg'),
        EvalPair(col1: 'Russie', col2: 'assets/flags/ru.svg'),
        EvalPair(col1: 'Brésil', col2: 'assets/flags/br.svg'),
        EvalPair(col1: 'Mexique', col2: 'assets/flags/mx.svg'),
        EvalPair(col1: 'Inde', col2: 'assets/flags/in.svg'),
        EvalPair(col1: 'Corée du Sud', col2: 'assets/flags/kr.svg'),
        EvalPair(col1: 'Pays-Bas', col2: 'assets/flags/nl.svg'),
        EvalPair(col1: 'Suède', col2: 'assets/flags/se.svg'),
        EvalPair(col1: 'Norvège', col2: 'assets/flags/no.svg'),
        EvalPair(col1: 'Danemark', col2: 'assets/flags/dk.svg'),
        EvalPair(col1: 'Finlande', col2: 'assets/flags/fi.svg'),
        EvalPair(col1: 'Suisse', col2: 'assets/flags/ch.svg'),
        EvalPair(col1: 'Autriche', col2: 'assets/flags/at.svg'),
        EvalPair(col1: 'Belgique', col2: 'assets/flags/be.svg'),
        EvalPair(col1: 'Pologne', col2: 'assets/flags/pl.svg'),
        EvalPair(col1: 'République tchèque', col2: 'assets/flags/cz.svg'),
        EvalPair(col1: 'Hongrie', col2: 'assets/flags/hu.svg'),
        EvalPair(col1: 'Roumanie', col2: 'assets/flags/ro.svg'),
        EvalPair(col1: 'Bulgarie', col2: 'assets/flags/bg.svg'),
        EvalPair(col1: 'Croatie', col2: 'assets/flags/hr.svg'),
        EvalPair(col1: 'Slovénie', col2: 'assets/flags/si.svg'),
        EvalPair(col1: 'Slovaquie', col2: 'assets/flags/sk.svg'),
        EvalPair(col1: 'Lituanie', col2: 'assets/flags/lt.svg'),
        EvalPair(col1: 'Lettonie', col2: 'assets/flags/lv.svg'),
        EvalPair(col1: 'Estonie', col2: 'assets/flags/ee.svg'),
        EvalPair(col1: 'Irlande', col2: 'assets/flags/ie.svg'),
        EvalPair(col1: 'Portugal', col2: 'assets/flags/pt.svg'),
        EvalPair(col1: 'Grèce', col2: 'assets/flags/gr.svg'),
        EvalPair(col1: 'Chypre', col2: 'assets/flags/cy.svg'),
        EvalPair(col1: 'Malte', col2: 'assets/flags/mt.svg'),
        EvalPair(col1: 'Luxembourg', col2: 'assets/flags/lu.svg'),
        EvalPair(col1: 'Liechtenstein', col2: 'assets/flags/li.svg'),
        EvalPair(col1: 'Monaco', col2: 'assets/flags/mc.svg'),
        EvalPair(col1: 'Saint-Marin', col2: 'assets/flags/sm.svg'),
        EvalPair(col1: 'Vatican', col2: 'assets/flags/va.svg'),
        EvalPair(col1: 'Andorre', col2: 'assets/flags/ad.svg'),
        EvalPair(col1: 'Islande', col2: 'assets/flags/is.svg'),
        EvalPair(col1: 'Turquie', col2: 'assets/flags/tr.svg'),
        EvalPair(col1: 'Israël', col2: 'assets/flags/il.svg'),
        EvalPair(col1: 'Arabie saoudite', col2: 'assets/flags/sa.svg'),
        EvalPair(col1: 'Émirats arabes unis', col2: 'assets/flags/ae.svg'),
        EvalPair(col1: 'Égypte', col2: 'assets/flags/eg.svg'),
        EvalPair(col1: 'Maroc', col2: 'assets/flags/ma.svg'),
        EvalPair(col1: 'Algérie', col2: 'assets/flags/dz.svg'),
        EvalPair(col1: 'Tunisie', col2: 'assets/flags/tn.svg'),
        EvalPair(col1: 'Libye', col2: 'assets/flags/ly.svg'),
        EvalPair(col1: 'Soudan', col2: 'assets/flags/sd.svg'),
        EvalPair(col1: 'Éthiopie', col2: 'assets/flags/et.svg'),
        EvalPair(col1: 'Kenya', col2: 'assets/flags/ke.svg'),
        EvalPair(col1: 'Afrique du Sud', col2: 'assets/flags/za.svg'),
        EvalPair(col1: 'Nigeria', col2: 'assets/flags/ng.svg'),
        EvalPair(col1: 'Ghana', col2: 'assets/flags/gh.svg'),
        EvalPair(col1: 'Sénégal', col2: 'assets/flags/sn.svg'),
        EvalPair(col1: 'Côte d\'Ivoire', col2: 'assets/flags/ci.svg'),
        EvalPair(col1: 'Cameroun', col2: 'assets/flags/cm.svg'),
        EvalPair(
            col1: 'République démocratique du Congo',
            col2: 'assets/flags/cd.svg'),
        EvalPair(col1: 'République du Congo', col2: 'assets/flags/cg.svg'),
        EvalPair(col1: 'Gabon', col2: 'assets/flags/ga.svg'),
        EvalPair(col1: 'Tchad', col2: 'assets/flags/td.svg'),
        EvalPair(
            col1: 'République centrafricaine', col2: 'assets/flags/cf.svg'),
        EvalPair(col1: 'Niger', col2: 'assets/flags/ne.svg'),
        EvalPair(col1: 'Burkina Faso', col2: 'assets/flags/bf.svg'),
        EvalPair(col1: 'Mali', col2: 'assets/flags/ml.svg'),
        EvalPair(col1: 'Guinée', col2: 'assets/flags/gn.svg'),
        EvalPair(col1: 'Sierra Leone', col2: 'assets/flags/sl.svg'),
        EvalPair(col1: 'Libéria', col2: 'assets/flags/lr.svg'),
        EvalPair(col1: 'Gambie', col2: 'assets/flags/gm.svg'),
        EvalPair(col1: 'Guinée-Bissau', col2: 'assets/flags/gw.svg'),
        EvalPair(col1: 'Cap-Vert', col2: 'assets/flags/cv.svg'),
        EvalPair(col1: 'São Tomé-et-Príncipe', col2: 'assets/flags/st.svg'),
        EvalPair(col1: 'Guinée équatoriale', col2: 'assets/flags/gq.svg'),
        EvalPair(col1: 'Angola', col2: 'assets/flags/ao.svg'),
        EvalPair(col1: 'Zambie', col2: 'assets/flags/zm.svg'),
        EvalPair(col1: 'Zimbabwe', col2: 'assets/flags/zw.svg'),
        EvalPair(col1: 'Botswana', col2: 'assets/flags/bw.svg'),
        EvalPair(col1: 'Namibie', col2: 'assets/flags/na.svg'),
        EvalPair(col1: 'Eswatini', col2: 'assets/flags/sz.svg'),
        EvalPair(col1: 'Lesotho', col2: 'assets/flags/ls.svg'),
        EvalPair(col1: 'Madagascar', col2: 'assets/flags/mg.svg'),
        EvalPair(col1: 'Maurice', col2: 'assets/flags/mu.svg'),
        EvalPair(col1: 'Seychelles', col2: 'assets/flags/sc.svg'),
        EvalPair(col1: 'Comores', col2: 'assets/flags/km.svg'),
        EvalPair(col1: 'Djibouti', col2: 'assets/flags/dj.svg'),
        EvalPair(col1: 'Somalie', col2: 'assets/flags/so.svg'),
        EvalPair(col1: 'Érythrée', col2: 'assets/flags/er.svg'),
        EvalPair(col1: 'Ouganda', col2: 'assets/flags/ug.svg'),
        EvalPair(col1: 'Tanzanie', col2: 'assets/flags/tz.svg'),
        EvalPair(col1: 'Rwanda', col2: 'assets/flags/rw.svg'),
        EvalPair(col1: 'Burundi', col2: 'assets/flags/bi.svg'),
        EvalPair(col1: 'Malawi', col2: 'assets/flags/mw.svg'),
        EvalPair(col1: 'Mozambique', col2: 'assets/flags/mz.svg'),
      ],
    ),

    // CODE DE LA ROUTE
    'ROUTE_PANNEAUX': EvalConfig(
      code: 'ROUTE_PANNEAUX',
      category: 'Code de la route',
      title: 'Panneaux de signalisation',
      titre1: 'Description',
      titre2: 'Image',
      pairs: [
        EvalPair(
            col1: 'Circulation interdite à tout véhicule dans les deux sens',
            col2: 'assets/panneaux/B0.svg'),
        EvalPair(col1: 'Sens interdit', col2: 'assets/panneaux/B1.svg'),
        EvalPair(
            col1:
                'Interdiction de tourner à gauche à la prochaine intersection',
            col2: 'assets/panneaux/B2A.svg'),
        EvalPair(
            col1:
                'Interdiction de tourner à droite à la prochaine intersection',
            col2: 'assets/panneaux/B2B.svg'),
        EvalPair(
            col1:
                'Interdiction de faire demi-tour sur la route suivie jusqu\'à la prochaine intersection',
            col2: 'assets/panneaux/B2C.svg'),
        EvalPair(
            col1:
                'Interdiction de dépasser tous les véhicules à moteur autres que ceux à deux roues sans side-car',
            col2: 'assets/panneaux/B3.svg'),
        EvalPair(
            col1: 'Arrêt au poste de gendarmerie',
            col2: 'assets/panneaux/B5A.svg'),
        EvalPair(
            col1: 'Arrêt au poste de police', col2: 'assets/panneaux/B5B.svg'),
        EvalPair(
            col1: 'Arrêt au poste de péage', col2: 'assets/panneaux/B5C.svg'),
        EvalPair(
            col1: 'Stationnement interdit', col2: 'assets/panneaux/B6A1.svg'),
        EvalPair(
            col1: 'Stationnement interdit du 1er au 15 du mois',
            col2: 'assets/panneaux/B6A2.svg'),
        EvalPair(
            col1: 'Stationnement interdit du 16 à la fin du mois',
            col2: 'assets/panneaux/B6A3.svg'),
        EvalPair(
            col1: 'Entrée d\'une zone à stationnement interdit',
            col2: 'assets/panneaux/B6B1.svg'),
        EvalPair(
            col1:
                'Entrée d\'une zone à stationnement unilatéral à alternance semi-mensuelle',
            col2: 'assets/panneaux/B6B2.svg'),
        EvalPair(
            col1: 'Entrée d\'une zone à stationnement de durée limitée',
            col2: 'assets/panneaux/B6B3.svg'),
        EvalPair(
            col1: 'Entrée d\'une zone à stationnement payant',
            col2: 'assets/panneaux/B6B4.svg'),
        EvalPair(
            col1: 'Arrêt et stationnement interdits',
            col2: 'assets/panneaux/B6D.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules à moteur à l\'exception des cyclomoteurs',
            col2: 'assets/panneaux/B7A.svg'),
        EvalPair(
            col1: 'Accès interdit à tous les véhicules à moteur',
            col2: 'assets/panneaux/B7B.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules affectés au transport de marchandises',
            col2: 'assets/panneaux/B8.svg'),
        EvalPair(
            col1: 'Accès interdit aux piétons',
            col2: 'assets/panneaux/B9A.svg'),
        EvalPair(
            col1: 'Accès interdit aux cycles', col2: 'assets/panneaux/B9B.svg'),
        EvalPair(
            col1: 'Accès interdit aux véhicules à traction animale',
            col2: 'assets/panneaux/B9C.svg'),
        EvalPair(
            col1: 'Accès interdit aux véhicules agricoles à moteur',
            col2: 'assets/panneaux/B9D.svg'),
        EvalPair(
            col1: 'Accès interdit aux voitures à bras',
            col2: 'assets/panneaux/B9E.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules de transport en commun de personnes',
            col2: 'assets/panneaux/B9F.svg'),
        EvalPair(
            col1: 'Accès interdit aux cyclomoteurs',
            col2: 'assets/panneaux/B9G.svg'),
        EvalPair(
            col1: 'Accès interdit aux motocyclettes et motocyclettes légères',
            col2: 'assets/panneaux/B9H.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules tractant une caravane ou une remorque de plus de 250 kg',
            col2: 'assets/panneaux/B9I.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules dont la longueur est supérieure au nombre indiqué',
            col2: 'assets/panneaux/B10A.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules dont la largeur, chargement compris, est supérieure au nombre indiqué',
            col2: 'assets/panneaux/B11.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules dont la hauteur, chargement compris, est supérieure au nombre indiqué',
            col2: 'assets/panneaux/B12.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules dont le poids total autorisé en charge excède le nombre indiqué',
            col2: 'assets/panneaux/B13.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules pesant sur un essieu plus que le nombre indiqué',
            col2: 'assets/panneaux/B13A.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 10 km/h',
            col2: 'assets/panneaux/B14.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 20 km/h',
            col2: 'assets/panneaux/B14_6.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 30 km/h',
            col2: 'assets/panneaux/B14_7.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 40 km/h',
            col2: 'assets/panneaux/B14_8.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 50 km/h',
            col2: 'assets/panneaux/B14_11.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 60 km/h',
            col2: 'assets/panneaux/B14_12.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 70 km/h',
            col2: 'assets/panneaux/B14_13.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 80 km/h',
            col2: 'assets/panneaux/B14_14.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 90 km/h',
            col2: 'assets/panneaux/B14_15.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 100 km/h',
            col2: 'assets/panneaux/B14_2.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 110 km/h',
            col2: 'assets/panneaux/B14_3.svg'),
        EvalPair(
            col1: 'Limitation de vitesse à 130 km/h',
            col2: 'assets/panneaux/B14_4.svg'),
        EvalPair(
            col1: 'Cédez le passage à la circulation venant en sens inverse',
            col2: 'assets/panneaux/B15.svg'),
        EvalPair(
            col1: 'Signaux sonores interdits', col2: 'assets/panneaux/B16.svg'),
        EvalPair(
            col1:
                'Interdiction aux véhicules de circuler sans maintenir entre eux un intervalle au moins égal au nombre indiqué',
            col2: 'assets/panneaux/B17.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules transportant des marchandises explosives ou facilement inflammables',
            col2: 'assets/panneaux/B18A.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules transportant des marchandises susceptibles de polluer les eaux',
            col2: 'assets/panneaux/B18B.svg'),
        EvalPair(
            col1:
                'Accès interdit aux véhicules transportant des marchandises dangereuses',
            col2: 'assets/panneaux/B18C.svg'),
        EvalPair(
            col1:
                'Autres interdictions dont la nature est indiquée par une inscription sur le panneau',
            col2: 'assets/panneaux/B19.svg'),
        EvalPair(
            col1: 'Obligation de tourner à droite avant le panneau',
            col2: 'assets/panneaux/B21.svg'),
        EvalPair(
            col1: 'Obligation de tourner à gauche avant le panneau',
            col2: 'assets/panneaux/B21_2.svg'),
        EvalPair(
            col1: 'Contournement obligatoire par la droite',
            col2: 'assets/panneaux/B21A1.svg'),
        EvalPair(
            col1: 'Contournement obligatoire par la gauche',
            col2: 'assets/panneaux/B21A2.svg'),
        EvalPair(
            col1:
                'Direction obligatoire à la prochaine intersection : tout droit',
            col2: 'assets/panneaux/B21B.svg'),
        EvalPair(
            col1:
                'Direction obligatoire à la prochaine intersection : à droite',
            col2: 'assets/panneaux/B21C1.svg'),
        EvalPair(
            col1:
                'Direction obligatoire à la prochaine intersection : à gauche',
            col2: 'assets/panneaux/B21C2.svg'),
        EvalPair(
            col1:
                'Directions obligatoires à la prochaine intersection : tout droit ou à droite',
            col2: 'assets/panneaux/B21D1.svg'),
        EvalPair(
            col1:
                'Directions obligatoires à la prochaine intersection : tout droit ou à gauche',
            col2: 'assets/panneaux/B21D2.svg'),
        EvalPair(
            col1:
                'Directions obligatoires à la prochaine intersection : à droite ou à gauche',
            col2: 'assets/panneaux/B21E.svg'),
        EvalPair(
            col1:
                'Piste ou bande obligatoire pour les cycles sans side-car ou remorque',
            col2: 'assets/panneaux/B22A.svg'),
        EvalPair(
            col1: 'Chemin obligatoire pour piétons',
            col2: 'assets/panneaux/B22B.svg'),
        EvalPair(
            col1: 'Chemin obligatoire pour cavaliers',
            col2: 'assets/panneaux/B22C.svg'),
        EvalPair(
            col1: 'Vitesse minimale obligatoire',
            col2: 'assets/panneaux/B25.svg'),
        EvalPair(
            col1:
                'Chaînes à neige obligatoires sur au moins deux roues motrices',
            col2: 'assets/panneaux/B26.svg'),
        EvalPair(
            col1:
                'Voie réservée aux véhicules des services réguliers de transport en commun',
            col2: 'assets/panneaux/B27A.svg'),
        EvalPair(
            col1: 'Voie réservée aux tramways',
            col2: 'assets/panneaux/B27B.svg'),
        EvalPair(
            col1:
                'Autres obligations dont la nature est mentionnée par une inscription sur le panneau',
            col2: 'assets/panneaux/B29.svg'),
        EvalPair(
            col1: 'Fin de toutes les interdictions précédemment signalées',
            col2: 'assets/panneaux/B31.svg'),
        EvalPair(
            col1: 'Fin de limitation de vitesse',
            col2: 'assets/panneaux/B33.svg'),
        EvalPair(
            col1: 'Fin d\'interdiction de dépasser',
            col2: 'assets/panneaux/B34.svg'),
        EvalPair(
            col1: 'Fin d\'interdiction de l\'usage de l\'avertisseur sonore',
            col2: 'assets/panneaux/B35.svg'),
        EvalPair(
            col1:
                'Fin d\'interdiction dont la nature est indiquée sur le panneau',
            col2: 'assets/panneaux/B39.svg'),
        EvalPair(
            col1: 'Fin de piste ou bande obligatoire pour cycle',
            col2: 'assets/panneaux/B40.svg'),
        EvalPair(
            col1: 'Fin de chemin obligatoire pour piétons',
            col2: 'assets/panneaux/B41.svg'),
        EvalPair(
            col1: 'Fin de vitesse minimale obligatoire',
            col2: 'assets/panneaux/B43.svg'),
        EvalPair(
            col1: 'Fin d\'obligation de l\'usage des chaînes à neige',
            col2: 'assets/panneaux/B44.svg'),
        EvalPair(
            col1:
                'Fin de voie réservée aux véhicules des services réguliers de transport en commun',
            col2: 'assets/panneaux/B45A.svg'),
        EvalPair(
            col1: 'Fin de voie réservée aux tramways',
            col2: 'assets/panneaux/B45B.svg'),
        EvalPair(
            col1:
                'Fin d\'obligation dont la nature est mentionnée par une inscription sur le panneau',
            col2: 'assets/panneaux/B49.svg'),
        EvalPair(
            col1: 'Sortie de zone à stationnement interdit',
            col2: 'assets/panneaux/B50A.svg'),
        EvalPair(
            col1:
                'Sortie de zone à stationnement unilatéral à alternance semi-mensuelle',
            col2: 'assets/panneaux/B50B.svg'),
        EvalPair(
            col1:
                'Sortie de zone à stationnement de durée limitée avec contrôle par disque',
            col2: 'assets/panneaux/B50C.svg'),
        EvalPair(
            col1: 'Sortie de zone à stationnement payant',
            col2: 'assets/panneaux/B50D.svg'),
        EvalPair(
            col1:
                'Sortie de zone à stationnement unilatéral à alternance semi-mensuelle et à durée limitée avec contrôle par disque',
            col2: 'assets/panneaux/B50E.svg'),
        EvalPair(col1: 'Virage à droite', col2: 'assets/panneaux/A1A.svg'),
        EvalPair(col1: 'Virage à gauche', col2: 'assets/panneaux/A1B.svg'),
        EvalPair(
            col1: 'Succession de virages', col2: 'assets/panneaux/A1C.svg'),
        EvalPair(
            col1: 'Succession de virages, le premier tournant à gauche',
            col2: 'assets/panneaux/A1D.svg'),
        EvalPair(col1: 'Cassis ou dos d\'âne', col2: 'assets/panneaux/A2A.svg'),
        EvalPair(
            col1: 'Ralentisseur de type dos d\'âne',
            col2: 'assets/panneaux/A2B.svg'),
        EvalPair(col1: 'Chaussée rétrécie', col2: 'assets/panneaux/A3.svg'),
        EvalPair(
            col1: 'Chaussée rétrécie par la droite',
            col2: 'assets/panneaux/A3A.svg'),
        EvalPair(
            col1: 'Chaussée rétrécie par la gauche',
            col2: 'assets/panneaux/A3B.svg'),
        EvalPair(col1: 'Chaussée glissante', col2: 'assets/panneaux/A4.svg'),
        EvalPair(col1: 'Pont mobile', col2: 'assets/panneaux/A6.svg'),
        EvalPair(
            col1: 'Passage à niveau avec barrière',
            col2: 'assets/panneaux/A7.svg'),
        EvalPair(
            col1: 'Passage à niveau sans barrière',
            col2: 'assets/panneaux/A8.svg'),
        EvalPair(
            col1: 'Passage de voies de tramway',
            col2: 'assets/panneaux/A9.svg'),
        EvalPair(
            col1: 'Traversée d\'enfants', col2: 'assets/panneaux/A13A.svg'),
        EvalPair(
            col1: 'Passage pour piéton(s)', col2: 'assets/panneaux/A13B.svg'),
        EvalPair(col1: 'Danger', col2: 'assets/panneaux/A14.svg'),
        EvalPair(
            col1: 'Passage d\'animaux domestiques',
            col2: 'assets/panneaux/A15A1.svg'),
        EvalPair(
            col1: 'Passage d\'animaux domestiques',
            col2: 'assets/panneaux/A15A2.svg'),
        EvalPair(
            col1: 'Passage d\'animaux sauvages',
            col2: 'assets/panneaux/A15B.svg'),
        EvalPair(
            col1: 'Passage d\'animaux sauvages',
            col2: 'assets/panneaux/A15C.svg'),
        EvalPair(col1: 'Descente dangereuse', col2: 'assets/panneaux/A16.svg'),
        EvalPair(col1: 'Feux tricolores', col2: 'assets/panneaux/A17.svg'),
        EvalPair(
            col1: 'Circulation dans les deux sens',
            col2: 'assets/panneaux/A18.svg'),
        EvalPair(
            col1: 'Risque de chute de pierres',
            col2: 'assets/panneaux/A19.svg'),
        EvalPair(
            col1: 'Débouché sur un quai ou une berge',
            col2: 'assets/panneaux/A20.svg'),
        EvalPair(
            col1: 'Débouché de cyclistes', col2: 'assets/panneaux/A21.svg'),
        EvalPair(
            col1: 'Débouché de cyclistes', col2: 'assets/panneaux/A21B.svg'),
        EvalPair(
            col1: 'Traversée d\'une aire aérienne',
            col2: 'assets/panneaux/A23.svg'),
        EvalPair(col1: 'Vent latéral', col2: 'assets/panneaux/A24.svg'),
        EvalPair(
            col1: 'Carrefour avec priorité à droite',
            col2: 'assets/panneaux/AB1.svg'),
        EvalPair(
            col1: 'Carrefour avec priorité', col2: 'assets/panneaux/AB2.svg'),
        EvalPair(
            col1:
                'Carrefour à sens giratoire avec priorité aux usagers circulant dans l\'anneau',
            col2: 'assets/panneaux/AB25.svg'),
        EvalPair(
            col1: 'Panneau d\'entrée d\'agglomération',
            col2: 'assets/panneaux/EB10.svg'),
        EvalPair(
            col1: 'Panneau de sortie d\'agglomération',
            col2: 'assets/panneaux/EB20.svg'),
        EvalPair(col1: 'Route nationale', col2: 'assets/panneaux/E42.svg'),
        EvalPair(col1: 'Route départementale', col2: 'assets/panneaux/E43.svg'),
        EvalPair(col1: 'Voie communale', col2: 'assets/panneaux/E44.svg'),
        EvalPair(col1: 'Chemin rural', col2: 'assets/panneaux/E44B.svg'),
        EvalPair(col1: 'Voie forestière', col2: 'assets/panneaux/E45.svg'),
        EvalPair(
            col1: 'Localisation d\'un État appartenant à l\'Union européenne',
            col2: 'assets/panneaux/E39.svg'),
        EvalPair(
            col1: 'Chaussée à sens unique à 2 voies',
            col2: 'assets/panneaux/C24A.svg'),
        EvalPair(
            col1: 'Chaussée à 4 voies (sens unique)',
            col2: 'assets/panneaux/C24A_2.svg'),
        EvalPair(
            col1: 'Emplacement de stationnement de personne handicapée',
            col2: 'assets/panneaux/PERS-HANDICAP.svg'),
        EvalPair(
            col1: 'Emplacement de stationnement de voiture électrique',
            col2: 'assets/panneaux/PICTO-VOITURE-_LECTRIQUE.svg'),
        EvalPair(
            col1: 'Disque de stationnement',
            col2: 'assets/panneaux/DISQUE-DE-STATIONNEMENT-FRANCE.svg'),
      ],
    ),
  };

  /// Obtenir la configuration d'un quiz par code
  static EvalConfig? getEvalConfig(String code) => _quizConfigs[code];

  /// Obtenir tous les quiz d'une catégorie
  static List<EvalConfig> getEvalzesByCategory(String category) {
    return _quizConfigs.values
        .where((config) => config.category == category)
        .toList();
  }

  /// Lister toutes les catégories disponibles
  static List<String> getAvailableCategories() {
    return _quizConfigs.values
        .map((config) => config.category)
        .toSet()
        .toList();
  }

  /// Lister tous les quiz disponibles
  static List<String> getAvailableEvalCodes() => _quizConfigs.keys.toList();

  /// Obtenir tous les quiz disponibles
  static List<EvalConfig> getAllEvalzes() => _quizConfigs.values.toList();

  /// Générer un quiz aléatoire
  static Future<List<EvalPair>> generateEval(String code,
      {int count = 5}) async {
    final config = getEvalConfig(code);
    if (config == null) return [];

    // Chargement dynamique pour SVT
    if (code == 'SVT_EVA') {
      final pairs = await SVTEvalLoader.loadSVTEvalData();
      final shuffled = List<EvalPair>.from(pairs)..shuffle();
      return shuffled.take(count).toList();
    }

    // Chargement dynamique pour PHILO
    if (code == 'PHILO_EVA') {
      final pairs = await PhiloEvalLoader.loadPhiloEvalData();
      final shuffled = List<EvalPair>.from(pairs)..shuffle();
      return shuffled.take(count).toList();
    }

    // Eval statiques
    final shuffled = List<EvalPair>.from(config.pairs)..shuffle();
    return shuffled.take(count).toList();
  }
}
