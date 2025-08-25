/// <cursor>
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
///
/// ÉTAT ACTUEL:
/// - Interactions: Drag & drop fluide, double-tap shuffle
/// - Audio: Effet sonore complétion puzzle (puzgood.mp3)
/// - Performance: Optimisé pour grandes grilles et images
/// - Responsivité: Adaptation automatique taille écran
///
/// HISTORIQUE RÉCENT:
/// - Amélioration fluidité drag & drop sur tous devices
/// - Optimisation performance pour grilles 6x6
/// - Intégration feedback audio plus riche
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory management: Dispose AudioPlayer correctement
/// - Gesture conflicts: Gérer drag vs scroll conflicts
/// - Performance: Surveiller rebuild frequency GridView
/// - Audio permissions: Vérifier permissions sound sur device
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
/// </cursor>
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';

class PuzzleBoard extends ConsumerStatefulWidget {
  const PuzzleBoard({super.key});

  @override
  ConsumerState<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends ConsumerState<PuzzleBoard> {
  final AudioPlayer _player = AudioPlayer();
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _player.setVolume(1.0);
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
    
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 2000),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(200), // Fond vert victoire
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          "👍 en ${gameState.swapCount} coups",
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final isComplete = ref.read(gameStateProvider.notifier).isGameComplete();

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

    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () =>
              ref.read(gameStateProvider.notifier).shufflePieces(),
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
                      ref
                          .read(gameStateProvider.notifier)
                          .swapPieces(details.data, index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Draggable<int>(
                        data: index,
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
                          color: Colors.grey.withAlpha(128), // 0.5 * 255 ≈ 128
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
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
        if (isComplete)
          Positioned(
            left: 20,
            top: 20,
            child: _buildCompletionMessage(context),
          ),
      ],
    );
  }
}
