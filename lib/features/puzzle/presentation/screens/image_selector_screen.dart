/// <cursor>
///
/// image_selector_screen.dart
///
/// Écran de sélection d'images pour les puzzles
/// Interface de navigation avec boutons gauche/droite
///
/// COMPOSANTS PRINCIPAUX:
/// - ImageSelectorScreen : Écran principal de sélection
/// - _buildImageDisplay : Affichage de l'image courante
/// - _buildNavigationButtons : Boutons de navigation
/// - _buildImageGrid : Grille de sélection rapide
///
/// ÉTAT ACTUEL:
/// - Interface de navigation entre images
/// - Boutons gauche/droite pour balayer
/// - Sélection d'image pour puzzle
/// - Affichage en plein écran
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-26 : Création de l'écran de sélection
/// - 2025-09-26 : Interface de navigation intuitive
/// - 2025-09-26 : Intégration avec le système de puzzle
///
/// 🔧 POINTS D'ATTENTION:
/// - Navigation fluide entre images
/// - Interface tactile intuitive
/// - Retour vers le puzzle avec image sélectionnée
/// - Gestion des gestes (swipe, tap)
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Intégration avec le système de puzzle
/// - Animations de transition
/// - Filtres par catégorie
///
/// 🔗 FICHIERS LIÉS:
/// - puzzle_game_screen.dart (écran principal)
/// - image_controller.dart (gestion des images)
///
/// CRITICALITÉ: ⭐⭐⭐⭐
/// 📅 Dernière modification: 2025-09-26 11:26
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageSelectorScreen extends ConsumerStatefulWidget {
  const ImageSelectorScreen({super.key});

  @override
  ConsumerState<ImageSelectorScreen> createState() =>
      _ImageSelectorScreenState();
}

class _ImageSelectorScreenState extends ConsumerState<ImageSelectorScreen> {
  int _currentImageIndex = 0;
  late List<String> _availableImages;

  @override
  void initState() {
    super.initState();
    _availableImages = [
      // Images épicerie (série principale)
      'assets/epicerie-02.jpg',
      'assets/epicerie-04.jpg',
      'assets/epicerie-05.jpg',
      'assets/epicerie-06.jpg',
      'assets/epicerie-07.jpg',
      'assets/epicerie-08.jpg',
      'assets/epicerie-09.jpg',
      'assets/epicerie-10.jpg',
      'assets/epicerie-11.jpg',
      'assets/epicerie-12.jpg',
      'assets/epicerie-14.jpg',
      'assets/epicerie-15.jpg',
      'assets/epicerie-16.jpg',
      'assets/epicerie-19.jpg',
      'assets/epicerie-20.jpg',
      'assets/epicerie-21.jpg',
      'assets/epicerie-22.jpg',
      'assets/epicerie-23.jpg',
      'assets/epicerie-26.jpg',
      'assets/epicerie-27.jpg',
      'assets/epicerie-28.jpg',
      'assets/epicerie-29.jpg',
      'assets/epicerie-30.jpg',
      'assets/epicerie-33.jpg',
      'assets/epicerie-34.jpg',
      'assets/epicerie-35.jpg',
      'assets/epicerie-36.jpg',
      'assets/epicerie-39.jpg',
      'assets/epicerie-40.jpg',
      'assets/epicerie-41.jpg',
      'assets/epicerie-43.jpg',
      'assets/epicerie-45.jpg',

      // Images artistiques (Picasso, Van Gogh)
      'assets/Picasso-FemmeAssiseAuBraceletMontre.jpg',
      'assets/Picasso-FemmeTenantUnLivre.jpg',
      'assets/VVG-10.jpg',

      // Images personnelles et familiales
      'assets/eva - 1.jpeg',
      'assets/clemchat - 1.jpeg',
      'assets/2cv - 1.jpeg',
      'assets/HISTOIRE-CE1 - 3.jpeg',

      // Images de personnages et mascottes
      'assets/mathieu_chanceux.jpg',
      'assets/mathieu_sailor_man.jpg',
      'assets/pokemon9.jpg',

      // Images culturelles et historiques
      'assets/mona_lisa_vinci.jpg',

      // Images de l'app et icônes
      'assets/icartuzz.jpg',
      'assets/luchy_village_sign.jpg',
    ];
  }

  /// Naviguer vers l'image précédente
  void _previousImage() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });
    }
  }

  /// Naviguer vers l'image suivante
  void _nextImage() {
    if (_currentImageIndex < _availableImages.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
    }
  }

  /// Sélectionner l'image courante pour le puzzle
  void _selectImage() {
    final selectedImage = _availableImages[_currentImageIndex];
    Navigator.of(context).pop(selectedImage);
  }

  /// Construire l'affichage de l'image courante
  Widget _buildImageDisplay() {
    final imagePath = _availableImages[_currentImageIndex];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
      ),
      child: GestureDetector(
        onTap: _selectImage,
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// Construire les boutons de navigation
  Widget _buildNavigationButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton précédent
            Container(
              margin: const EdgeInsets.all(16),
              child: FloatingActionButton(
                heroTag: "previous_image_button",
                onPressed: _currentImageIndex > 0 ? _previousImage : null,
                backgroundColor: _currentImageIndex > 0
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.grey.withValues(alpha: 0.5),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _currentImageIndex > 0 ? Colors.black : Colors.grey,
                ),
              ),
            ),

            // Indicateur de position
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1} / ${_availableImages.length}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Bouton suivant
            Container(
              margin: const EdgeInsets.all(16),
              child: FloatingActionButton(
                heroTag: "next_image_button",
                onPressed: _currentImageIndex < _availableImages.length - 1
                    ? _nextImage
                    : null,
                backgroundColor:
                    _currentImageIndex < _availableImages.length - 1
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.grey.withValues(alpha: 0.5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: _currentImageIndex < _availableImages.length - 1
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construire la grille de sélection rapide
  Widget _buildImageGrid() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _availableImages.length,
          itemBuilder: (context, index) {
            final isSelected = index == _currentImageIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              child: Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    _availableImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            const Text(
              'Sélectionner une image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Touchez pour sélectionner',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Affichage principal de l'image
          _buildImageDisplay(),

          // Grille de sélection rapide en haut
          _buildImageGrid(),

          // Boutons de navigation en bas
          _buildNavigationButtons(),
        ],
      ),
    );
  }
}
