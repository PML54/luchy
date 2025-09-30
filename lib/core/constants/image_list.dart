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
/// - Collection: 15 œuvres sélectionnées (Pissarro, Van Gogh, classiques, BD)
/// - Image d'ouverture: Mathieu The Sailor Man (découpage 2x2)
/// - Métadonnées: Artiste, titre, année, style, localisation assets
/// - Qualité: Images haute résolution optimisées puzzle
/// - Organisation: Structure claire par artiste et catégorie
///
/// HISTORIQUE RÉCENT:
/// - Mon Sep 29 08:00: NETTOYAGE IMAGES SUPPRIMÉES - Mise à jour des listes
/// - Suppression des références aux images supprimées: Picasso-Revefemme, VVG-13, VVG-3, famille3, icluchy
/// - Mise à jour des listes dans image_selector_screen.dart et image_list.dart
/// - Mon Sep 29 07:53: OPTIMISATION COMPLÈTE - Toutes les images sous 500KB
/// - Ajout de toutes les nouvelles images: Picasso, Van Gogh, Mona Lisa, etc.
/// - Suppression des références aux images supprimées (epicerie-18, 25, 37)
/// - Conversion PNG vers JPG pour optimisation (mathieu_chanceux, etc.)
/// - Mon Sep 29 07:43: AJOUT 3 NOUVELLES IMAGES - Eva, Clémence Chat, 2CV
/// - Ajout catégories: Portraits (Eva, Clémence Chat), Véhicules (2CV)
/// - Images optimisées sous 500KB pour performance store
/// - Fri Sep 26 19:26: NETTOYAGE IMAGES SUPPRIMÉES - Correction affichage noir
/// - Suppression références aux 9 images épicerie supprimées (01,03,17,24,31,32,38,42,44)
/// - Conservation des 26 images épicerie restantes
/// - Résolution problème d'affichage noir pour images manquantes
/// - Ajout image d'ouverture : Mathieu The Sailor Man (puzzle 2x2)
/// - Désactivation temporaire sauvegarde des découpages
/// - Diversification : art classique + illustrations modernes/BD
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
/// 📅 Dernière modification: Mon Sep 29 08:00:40 CEST 2025
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
    "file": "mathieu_chanceux.jpg",
    "name": "Mathieu Chanceux",
    "categ": "Présentation"
  },
  // === COLLECTION ÉPICERIE DALL-E ===
  {
    "file": "epicerie-02.jpg",
    "name": "Épicerie Mathieu 02",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-04.jpg",
    "name": "Épicerie Mathieu 04",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-05.jpg",
    "name": "Épicerie Mathieu 05",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-06.jpg",
    "name": "Épicerie Mathieu 06",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-07.jpg",
    "name": "Épicerie Mathieu 07",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-08.jpg",
    "name": "Épicerie Mathieu 08",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-09.jpg",
    "name": "Épicerie Mathieu 09",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-10.jpg",
    "name": "Épicerie Mathieu 10",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-11.jpg",
    "name": "Épicerie Mathieu 11",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-12.jpg",
    "name": "Épicerie Mathieu 12",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-14.jpg",
    "name": "Épicerie Mathieu 14",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-15.jpg",
    "name": "Épicerie Mathieu 15",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-16.jpg",
    "name": "Épicerie Mathieu 16",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-19.jpg",
    "name": "Épicerie Mathieu 19",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-20.jpg",
    "name": "Épicerie Mathieu 20",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-21.jpg",
    "name": "Épicerie Mathieu 21",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-22.jpg",
    "name": "Épicerie Mathieu 22",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-23.jpg",
    "name": "Épicerie Mathieu 23",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-26.jpg",
    "name": "Épicerie Mathieu 26",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-27.jpg",
    "name": "Épicerie Mathieu 27",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-28.jpg",
    "name": "Épicerie Mathieu 28",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-29.jpg",
    "name": "Épicerie Mathieu 29",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-30.jpg",
    "name": "Épicerie Mathieu 30",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-33.jpg",
    "name": "Épicerie Mathieu 33",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-34.jpg",
    "name": "Épicerie Mathieu 34",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-35.jpg",
    "name": "Épicerie Mathieu 35",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-36.jpg",
    "name": "Épicerie Mathieu 36",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-39.jpg",
    "name": "Épicerie Mathieu 39",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-40.jpg",
    "name": "Épicerie Mathieu 40",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-41.jpg",
    "name": "Épicerie Mathieu 41",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-43.jpg",
    "name": "Épicerie Mathieu 43",
    "categ": "Épiceries DALL-E"
  },
  {
    "file": "epicerie-45.jpg",
    "name": "Épicerie Mathieu 45",
    "categ": "Épiceries DALL-E"
  },
  // === IMAGES ARTISTIQUES ===
  {
    "file": "Picasso-FemmeAssiseAuBraceletMontre.jpg",
    "name": "Picasso - Femme Assise",
    "categ": "Art Moderne"
  },
  {
    "file": "Picasso-FemmeTenantUnLivre.jpg",
    "name": "Picasso - Femme au Livre",
    "categ": "Art Moderne"
  },
  {
    "file": "VVG-10.jpg",
    "name": "Van Gogh - Œuvre 10",
    "categ": "Art Classique"
  },
  {
    "file": "mona_lisa_vinci.jpg",
    "name": "Mona Lisa - Léonard de Vinci",
    "categ": "Art Classique"
  },

  // === IMAGES PERSONNELLES ET FAMILIALES ===
  {"file": "eva - 1.jpeg", "name": "Eva", "categ": "Portraits"},
  {"file": "clemchat - 1.jpeg", "name": "Clémence Chat", "categ": "Portraits"},
  {
    "file": "HISTOIRE-CE1 - 3.jpeg",
    "name": "Histoire CE1",
    "categ": "Éducation"
  },

  // === VÉHICULES ===
  {"file": "2cv - 1.jpeg", "name": "2CV Citroën", "categ": "Véhicules"},

  // === PERSONNAGES ET MASCOTTES ===
  {
    "file": "mathieu_sailor_man.jpg",
    "name": "Mathieu Sailor Man",
    "categ": "Personnages"
  },
  {"file": "pokemon9.jpg", "name": "Pokémon", "categ": "Personnages"},

  // === IMAGES DE L'APP ===
  {"file": "icartuzz.jpg", "name": "Icône Cartuzz", "categ": "Application"},
  {
    "file": "luchy_village_sign.jpg",
    "name": "Panneau Village Luchy",
    "categ": "Application"
  },
];
