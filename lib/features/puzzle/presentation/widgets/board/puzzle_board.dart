/// <cursor>
///
/// puzzle_board.dart
/// features/puzzle/presentation/widgets/board/
///
/// LUCHY - Plateau de jeu de puzzle principal
///
/// Widget principal pour l'affichage et l'interaction avec le plateau
/// de puzzle avec gestion drag & drop et feedback audio.
///
/// COMPOSANTS PRINCIPAUX:
/// - PuzzleBoard: Widget ConsumerStatefulWidget principal
/// - GridView: Grille interactive des pièces de puzzle
/// - Draggable: Pièces déplaçables avec feedback visuel
/// - DragTarget: Zones de dépôt pour placement pièces
/// - AudioPlayer: Effets sonores pour complétion et interactions
/// - Progress display: Affichage compteur mouvements
/// - _buildCompletionMessage(): Animation de félicitation avec TweenAnimationBuilder
///
/// ÉTAT ACTUEL:
/// - Interactions: Drag & drop fluide, double-tap shuffle
/// - Audio: Effet sonore complétion puzzle (puzgood.mp3)
/// - Performance: Optimisé pour grandes grilles et images
/// - Responsivité: Adaptation automatique taille écran
/// - NOUVEAU: Animation style gain pour completion puzzle
/// - NOUVEAU: Message "Appli Luchy, Mathieu à votre Service"
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-25 15:30: ANIMATION COMPLETION PUZZLE - Style gain
/// - Ajout TweenAnimationBuilder avec effet de zoom (scale 0.0 → 1.0)
/// - Message personnalisé: "Appli Luchy, Mathieu à votre Service"
/// - Design épuré avec icône et ombre portée
/// - Animation fluide de 1000ms pour effet de célébration
/// - Amélioration fluidité drag & drop sur tous devices
/// - Optimisation performance pour grilles 6x6
/// - Intégration feedback audio plus riche
/// - Documentation mise à jour format <cursor>
/// - 2025-09-28: TUTORIEL PREMIER LANCEMENT - Message d'aide "Déplacez les pièces avec le doigt"
/// - 2025-09-28: PARTAGE PUZZLE - Capture et partage de l'image puzzle mélangée
/// - 2025-09-29 08:59: AFFICHAGE STATS COMPLETION - Nombre de coups et difficulté
/// - Ajout affichage "${gameState.swapCount} coups" sous le pouce 👍
/// - Ajout affichage "Force ${gameState.columns}x${gameState.rows}" pour la difficulté
/// - Design en colonne avec espacement et tailles de police adaptées
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory management: Dispose AudioPlayer correctement
/// - Gesture conflicts: Gérer drag vs scroll conflicts
/// - Performance: Surveiller rebuild frequency GridView
/// - Audio permissions: Vérifier permissions sound sur device
/// - Tutoriel: SharedPreferences pour mémoriser affichage unique
/// - Overlay: Gestion des interactions (tap, drag) pour masquer tutoriel
/// - Partage: Capture RepaintBoundary + Share.shareXFiles pour partage natif
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations transition pièces
/// - Implémenter feedback haptique pour interactions
/// - Optimiser rendu pour très grandes grilles
/// - Ajouter modes accessibilité (contrôles alternatifs)
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État jeu
/// - assets/sounds/puzgood.mp3: Audio complétion
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Intégration
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Interface interaction principale)
/// 📅 Dernière modification: Mon Sep 29 08:59:49 CEST 2025
/// </cursor>
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/image_selector_screen.dart';

class PuzzleBoard extends ConsumerStatefulWidget {
  const PuzzleBoard({super.key});

  @override
  ConsumerState<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends ConsumerState<PuzzleBoard> {
  final AudioPlayer _player = AudioPlayer();
  bool _hasPlayed = false;
  bool _showTutorial = false;
  final GlobalKey _puzzleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _player.setVolume(1.0);
    _checkTutorialStatus();
  }

  /// Vérifier si le tutoriel a déjà été affiché
  Future<void> _checkTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('has_seen_puzzle_tutorial') ?? false;

    if (!hasSeenTutorial) {
      setState(() {
        _showTutorial = true;
      });
    }
  }

  /// Masquer le tutoriel et mémoriser que l'utilisateur l'a vu
  Future<void> _hideTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_puzzle_tutorial', true);

    setState(() {
      _showTutorial = false;
    });
  }

  /// Capturer et partager l'image puzzle (mélangée/codée)
  Future<void> _captureAndSharePuzzle() async {
    try {
      // 1. Capturer le widget puzzle
      RenderRepaintBoundary boundary = _puzzleKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(
          pixelRatio: 2.0); // Réduire la résolution pour un fichier plus léger
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2. Partager via le système natif
      final gameState = ref.read(gameStateProvider);

      // 3. Créer un fichier temporaire PNG optimisé
      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/puzzle_luchy_${gameState.columns}x${gameState.rows}.png');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text:
              'Puzzle Luchy - Niveau ${gameState.columns}x${gameState.rows} - Image mélangée',
        ),
      );
    } catch (e) {
      print('Erreur capture puzzle: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du partage: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    try {
      await _player.play(AssetSource('sounds/puzgood.mp3'));
    } catch (e) {
      debugPrint("Erreur lors de la lecture du son: $e");
    }
  }

  Widget _buildCompletionMessage(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    // Message personnalisé pour l'image d'ouverture Mathieu
    final bool isMathieuImage =
        gameState.currentImageName == 'Mathieu Chanceux';

    if (isMathieuImage) {
      // Message spécial pour Mathieu
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1200),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.orange.shade600,
                    Colors.orange.shade800
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade300,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Epicerie Luchy",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mathieu à votre Service",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Message avec pouce, nombre de coups et difficulté pour les autres puzzles
      return AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 2000),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "👍",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "${gameState.swapCount} coups",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Force ${gameState.columns}x${gameState.rows}",
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final isComplete = ref.read(gameStateProvider.notifier).isGameComplete();

    // Écouter le déclencheur de partage depuis le menu
    ref.listen<bool>(
        gameStateProvider.select((state) => state.shouldTriggerShare),
        (previous, shouldTrigger) {
      if (shouldTrigger) {
        // Réinitialiser le flag et déclencher le partage
        ref.read(gameStateProvider.notifier).resetShareTrigger();
        _captureAndSharePuzzle();
      }
    });

    if (!gameState.isInitialized || gameState.columns == 0) {
      return const Center(child: CircularProgressIndicator());
    }

    // Gestion du son
    if (isComplete && !_hasPlayed) {
      _hasPlayed = true;
      _playSuccessSound();
    } else if (!isComplete) {
      _hasPlayed = false;
    }

    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final availableHeight = screenSize.height - appBarHeight;
    final imageAspectRatio =
        gameState.imageSize.width / gameState.imageSize.height;

    double puzzleWidth, puzzleHeight;
    if (imageAspectRatio > screenSize.width / availableHeight) {
      puzzleWidth = screenSize.width;
      puzzleHeight = screenSize.width / imageAspectRatio;
    } else {
      puzzleHeight = availableHeight;
      puzzleWidth = availableHeight * imageAspectRatio;
    }

    double pieceWidth = puzzleWidth / gameState.columns;
    double pieceHeight = puzzleHeight / gameState.rows;

    // Vérification de sécurité pour éviter les erreurs de childAspectRatio
    if (pieceWidth <= 0 || pieceHeight <= 0) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        RepaintBoundary(
          key: _puzzleKey, // Clé pour la capture
          child: GestureDetector(
            onDoubleTap: () => _navigateToImageSelector(context, ref),
            onTap: _showTutorial ? _hideTutorial : null,
            child: Center(
              child: SizedBox(
                width: puzzleWidth,
                height: puzzleHeight,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gameState.columns,
                    childAspectRatio: pieceWidth / pieceHeight,
                  ),
                  itemCount: gameState.pieces.length,
                  itemBuilder: (context, index) {
                    final pieceIndex = gameState.currentArrangement[index];
                    return DragTarget<int>(
                      onAcceptWithDetails: (details) {
                        if (_showTutorial) _hideTutorial();
                        ref
                            .read(gameStateProvider.notifier)
                            .swapPieces(details.data, index);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Draggable<int>(
                          data: index,
                          onDragStarted: _showTutorial ? _hideTutorial : null,
                          feedback: Image.memory(
                            gameState.pieces[pieceIndex],
                            width: pieceWidth,
                            height: pieceHeight,
                            fit: BoxFit.cover,
                          ),
                          childWhenDragging: Container(
                            width: pieceWidth,
                            height: pieceHeight,
                            //color: Colors.grey.withOpacity(0.5),
                            color:
                                Colors.grey.withAlpha(128), // 0.5 * 255 ≈ 128
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                            ),
                            child: Image.memory(
                              gameState.pieces[pieceIndex],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (isComplete)
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildCompletionMessage(context),
          ),
        // Overlay du tutoriel
        if (_showTutorial)
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideTutorial,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 64,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Déplacez les pièces avec le doigt',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Appuyez n\'importe où pour commencer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Naviguer vers le sélecteur d'images
  void _navigateToImageSelector(BuildContext context, WidgetRef ref) async {
    print('🔍 Ouverture du sélecteur d\'images...');

    final selectedImage = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const ImageSelectorScreen(),
      ),
    );

    print('🔍 Image sélectionnée: $selectedImage');

    if (selectedImage != null) {
      print('🔍 Mise à jour de l\'image dans le game state...');
      // Mettre à jour l'image dans le game state
      await ref.read(gameStateProvider.notifier).setImage(selectedImage);
      print('✅ Image mise à jour avec succès');
    } else {
      print('❌ Aucune image sélectionnée');
    }
  }
}
