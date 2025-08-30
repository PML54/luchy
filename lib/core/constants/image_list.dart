/// <cursor>
/// LUCHY - Liste et métadonnées des images de puzzle
///
/// Catalogue central des œuvres d'art disponibles pour les puzzles
/// avec métadonnées complètes et organisation par artiste.
///
/// COMPOSANTS PRINCIPAUX:
/// - imageList: Liste complète des œuvres disponibles
/// - ImageMetadata: Structure métadonnées (artiste, titre, année, etc.)
/// - Categorisation: Organisation par artiste et époque
/// - Public domain: Focus sur œuvres domaine public
///
/// ÉTAT ACTUEL:
/// - Collection: 14 œuvres sélectionnées (Pissarro, Van Gogh, classiques, BD)
/// - Métadonnées: Artiste, titre, année, style, localisation assets
/// - Qualité: Images haute résolution optimisées puzzle
/// - Organisation: Structure claire par artiste et catégorie
///
/// HISTORIQUE RÉCENT:
/// - Ajout nouvelles images : Dubout et Popeye (collection → 14 œuvres)
/// - Diversification : art classique + illustrations modernes/BD
/// - Amélioration noms et catégories pour Pissarro
/// - Documentation mise à jour format <curseur>
///
/// 🔧 POINTS D'ATTENTION:
/// - Asset paths: Maintenir cohérence avec fichiers assets/
/// - Public domain: Vérifier statut légal nouvelles œuvres
/// - Image quality: Équilibrer résolution vs taille fichier
/// - Performance: Lazy loading pour grandes collections
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter système filtres par artiste/époque
/// - Implémenter recherche textuelle dans métadonnées
/// - Optimiser chargement avec thumbnails/previews
/// - Considérer collection thématique (nature, portraits, etc.)
///
/// 🔗 FICHIERS LIÉS:
/// - assets/: Fichiers images physiques
/// - features/puzzle/presentation/controllers/image_controller.dart: Utilisation
/// - features/puzzle/domain/providers/game_providers.dart: Sélection aléatoire
///
/// CRITICALITÉ: ⭐⭐⭐ (Contenu central application)
/// 📅 Dernière modification: 2025-08-25 17:25
/// </curseur>
class ImageCategories {
  // Reste du code...
  static const String vanGogh = "Van Gogh";
  static const String picasso = "PICASSO";

  // Empêcher l'instanciation
  const ImageCategories._();
}

/// Liste des images disponibles pour le puzzle

List<Map<String, String>> imageList = [
  {
    "file": "edgar_degas_la_classe_de_danse.jpg",
    "name": "Edgar Degas - La Classe de danse",
    "categ": "Edgar Degas"
  },
  {
    "file": "la_liberte_guidant_le_peuple_eugene_delacroix.jpg",
    "name": "La Liberté guidant le peuple - Eugène Delacroix",
    "categ": "Delacroix"
  },
  {
    "file": "mona_lisa_vinci.jpg",
    "name": "Mona Lisa Vinci",
    "categ": "Leonard de Vinci"
  },
  {
    "file": "andro_botticelli_la_nascita_di_venere.jpg",
    "name": "La Naissance de Vénus - Botticelli",
    "categ": "Botticelli"
  },
  {
    "file": "camille_pissarro_bords_de_l_oise_a_pontoise_1867.jpg",
    "name": "Bords de l'Oise à Pontoise (1867)",
    "categ": "Camille Pissarro"
  },
  {
    "file":
        "camille_pissarro_l_hermitage_a_pontoise_les_coteaux_de_l_hermitage.jpg",
    "name": "L'Hermitage à Pontoise - Les côteaux de l'Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_colline_de_jalais_a_pontoise.jpg",
    "name": "La Colline de Jalais à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_route_de_gisors_a_pontoise.jpg",
    "name": "La Route de Gisors à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_pont_ferroviaire.jpg",
    "name": "Le Pont Ferroviaire",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_pontoise.jpg",
    "name": "Pontoise",
    "categ": "Camille Pissarro"
  },
  {"file": "vvg_10.jpg", "name": "Van Gogh", "categ": "Van Gogh"},
  {"file": "vvg_19.jpg", "name": "Van Gogh", "categ": "Van Gogh"},
  {
    "file": "dubout1.jpg",
    "name": "Dubout - Illustration humoristique",
    "categ": "Dubout"
  },
  {
    "file": "popeye.jpg",
    "name": "Popeye le marin",
    "categ": "Bandes dessinées"
  },
];
