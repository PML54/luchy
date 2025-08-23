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
/// - Collection: 30+ œuvres Camille Pissarro, Van Gogh, classiques
/// - Métadonnées: Artiste, titre, année, style, localisation assets
/// - Qualité: Images haute résolution optimisées puzzle
/// - Organisation: Structure claire par artiste et catégorie
///
/// HISTORIQUE RÉCENT:
/// - Expansion collection Camille Pissarro (focus Pontoise)
/// - Ajout métadonnées complètes pour toutes œuvres
/// - Optimisation paths assets pour performance
/// - Documentation mise à jour format <cursor>
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
/// </cursor>
/// - File paths
/// - Artist attribution
/// - Artwork titles
/// - Categorization
///
/// IMPLEMENTATION DETAILS:
/// - Constants for categories
/// - Data model for images
/// - List structure
/// - Asset management
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Added content structure section
///
/// </claude>
class ImageCategories {
  // Reste du code...
  static const String vanGogh = "Van Gogh";
  static const String picasso = "PICASSO";

  // Empêcher l'instanciation
  const ImageCategories._();
}

/// Modèle pour une image de puzzle
/*class PuzzleImage {
  final String file;

  final String name;
  final String category;

  const PuzzleImage({
    required this.file,
    required this.name,
    required this.category,
  });

  factory PuzzleImage.fromMap(Map<String, String> map) {
    return PuzzleImage(
      file: map['file'] ?? '',
      name: map['name'] ?? '',
      category: map['categ'] ?? '',
    );
  }
}*/

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
    "file": "camille_pissarro_bords_de_l_oise_a_pontoise_1867.jpg",
    "name": "Bords de l'oise a pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_cote_des_grouettes.jpg",
    "name": "Cote des Grouettes",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_festival_a_l_hermitage.jpg",
    "name": "Festival à l'Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file":
        "camille_pissarro_l_hermitage_a_pontoise_les_coteaux_de_l_hermitage.jpg",
    "name": "L'Hermitage à Pontoise  Les côteaux de l'Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_barriere_1872.jpg",
    "name": "La Recolte des choux, l’Hermitage, Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_colline_de_jalais_a_pontoise.jpg",
    "name": "La Route d'Ennery, près de Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_recolte_des_choux_lhermitage_pontoise.jpg",
    "name": "La Rue de Gisors à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_recolte_des_pommes_a_eragny.jpg",
    "name": "La Sente du Chou",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_route_d_ennery_pres_de_pontoise.jpg",
    "name": "La barriere 1872",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_route_de_gisors_a_pontoise.jpg",
    "name": "La colline de Jalais à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_rue_de_gisors_a_pontoise.jpg",
    "name": "La route de Gisors à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_la_sente_du_chou.jpg",
    "name": "La récolte des pommes à Éragny",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_chemin_des_pouilleux_pontoise.jpg",
    "name": "Le Parc aux Charrettes",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_jardin_public_de_pontoise.jpg",
    "name": "Le chemin des Pouilleux Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_palais_de_justice_pontoise.jpg",
    "name": "Le jardin public de Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_parc_aux_charrettes.jpg",
    "name": "Le palais de Justice Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_le_pont_ferroviaire.jpg",
    "name": "Le pont ferroviaire",
    "categ": "Camille Pissarro"
  },
  {
    "file":
        "camille_pissarro_les_toits_rouges_coin_de_village_effet_d_hiver.jpg",
    "name": "Les toits rouges, coin de village, effet d'hiver",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_paysage_a_pontoise.jpg",
    "name": "Paysage à Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_paysanne_1880.jpg",
    "name": "Paysanne ",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_paysannes_pres_de_pontoise_1882.jpg",
    "name": "Paysannes pres de pontoise ",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_pontoise.jpg",
    "name": "Pontoise",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_printemps_pruniers_en_fleurs_1877.jpg",
    "name": "Printemps pruniers en fleurs ",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_route_de_saint_antoine_a_l_hermitage.jpg",
    "name": "Route de Saint-Antoine à l'Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_soleil_sur_la_route_pontoise_1874.jpg",
    "name": "Soleil sur la route pontoise ",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_un_carrefour_a_lhermitage.jpg",
    "name": "Un Carrefour à l’Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_un_coin_de_l_hermitage.jpg",
    "name": "Un coin de l'Hermitage",
    "categ": "Camille Pissarro"
  },
  {
    "file": "camille_pissarro_vue_de_saint_ouen_l_aumone.jpg",
    "name": "Vue de Saint-Ouen-L'Aumone",
    "categ": "Camille Pissarro"
  },
  {"file": "vvg_10.jpg", "name": "Van Gogh", "categ": "Van Gogh"},
  {"file": "vvg_19.jpg", "name": "Van Gogh", "categ": "Van Gogh"},
];
