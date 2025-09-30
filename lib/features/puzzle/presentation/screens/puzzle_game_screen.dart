/// <cursor>
/// LUCHY - Écran principal du jeu de puzzle
///
/// Écran principal de l'application Luchy qui gère l'interface utilisateur
/// du jeu de puzzle avec gestion d'images et état de jeu.
///
/// COMPOSANTS PRINCIPAUX:
/// - PuzzleBoard: Affichage du plateau de jeu avec pièces
/// - ImagePreview: Prévisualisation de l'image complète
/// - CustomToolbar: Barre d'outils avec contrôles de jeu
/// - FloatingActionButtons: Boutons aide et prévisualisation
/// - _ErrorScaffold: Interface d'affichage d'erreurs
/// - _LoadingScaffold: Interface de chargement
/// - _InitializationMessage: Message d'aide initial
///
/// ÉTAT ACTUEL:
/// - Interface: Responsive avec support orientations
/// - Sources images: Galerie, caméra, images prédéfinies
/// - État: Stable avec gestion erreurs robuste
/// - Navigation: Intégrée avec écran d'aide
/// - Menu: Section LECTURE (bleue) uniquement - ENVOI désactivé
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: DÉSACTIVATION PARTAGE UI - Option partage masquée dans menu caméra
/// - 2025-09-28: Refonte du menu avec sections LECTURE (bleue) et ENVOI (orange)
/// - 2025-09-28: Suppression du titre du menu de sélection d'image
/// - 2025-09-28: Ajout du partage de puzzle via menu caméra
/// - 2025-09-28: Suppression des références Artuzz/PuzHub
/// - Ajout AppBar éducative conditionnelle (puzzleType==2) avec boutons spécialisés
/// - Suppression boutons flottants en mode éducatif (résout débordement iPhone)
/// - Interface adaptative: AppBar normale vs éducative selon contexte
///
/// 🔧 POINTS D'ATTENTION:
/// - ConsumerStatefulWidget: Nécessaire pour Riverpod state management
/// - Gestion orientations: Portrait/paysage adaptés automatiquement
/// - États de chargement: Bien gérer loading/error/success
/// - Memory management: Dispose proprement des ressources
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations de transition entre états
/// - Optimiser performances pour grandes images
/// - Améliorer feedback utilisateur pendant traitement
/// - Considérer sauvegarde progression automatique
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État du jeu
/// - features/puzzle/presentation/controllers/image_controller.dart: Contrôle images
/// - features/puzzle/presentation/widgets/board/puzzle_board.dart: Plateau
/// - features/puzzle/presentation/widgets/toolbar/educational_appbar.dart: AppBar éducative
/// - features/puzzle/presentation/screens/help_screen.dart: Aide
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Interface principale utilisateur)
/// 📅 Dernière modification: 2025-01-27 21:45
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
import 'package:luchy/features/puzzle/presentation/widgets/board/puzzle_board.dart';
import 'package:luchy/features/puzzle/presentation/widgets/image/image_preview.dart';
import 'package:luchy/features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart';
import 'package:luchy/features/puzzle/presentation/widgets/toolbar/educational_appbar.dart';
import 'package:luchy/l10n/app_localizations.dart';

class PuzzleGameScreen extends ConsumerStatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  ConsumerState<PuzzleGameScreen> createState() => _PuzzleGameScreenState();

  static void showImageSourceDialog(BuildContext context) {
    final state = context.findAncestorStateOfType<_PuzzleGameScreenState>();
    if (state != null) {
      state._showImageSourceDialog(context);
    }
  }

  static void toggleFullImage(BuildContext context) {
    final state = context.findAncestorStateOfType<_PuzzleGameScreenState>();
    if (state != null) {
      state._toggleFullImage();
    }
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String error;

  const _ErrorScaffold({required this.error});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}

class _InitializationMessage extends StatelessWidget {
  const _InitializationMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        //  color: Colors.blue.shade100.withOpacity(0.3),
        color: Colors.blue.shade100.withAlpha(76), // 0.3 * 255 ≈ 76

        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.camera_alt, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.photoGalleryLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
}

class _PuzzleGameScreenState extends ConsumerState<PuzzleGameScreen>
    with SingleTickerProviderStateMixin {
  Future<void>? _initializationFuture;
  bool _showingFullImage = false;
  AnimationController? _previewController;

  @override
  Widget build(BuildContext context) {
    // Vérification si l'initialisation n'a pas encore commencé
    if (_initializationFuture == null) {
      debugPrint('🎓 Initialisation non démarrée, affichage LoadingScaffold');
      return const _LoadingScaffold();
    }

    final isInitialized = ref.watch(initializationProvider);
    final gameState = ref.watch(gameStateProvider);
    final imageState = ref.watch(imageProcessingProvider);
    final imageControllerState = ref.watch(imageControllerProvider);

    debugPrint('🎓 DEBUG STATES:');
    debugPrint('  - isInitialized: $isInitialized');
    debugPrint('  - imageState.isLoading: ${imageState.isLoading}');
    debugPrint(
        '  - imageControllerState.isLoading: ${imageControllerState.isLoading}');
    debugPrint('  - gameState.isInitialized: ${gameState.isInitialized}');

    // Protection contre les états incohérents
    if (isInitialized == false ||
        imageState.isLoading == true ||
        imageControllerState.isLoading == true ||
        gameState.isInitialized == false) {
      debugPrint(
          '🎓 SHOWING LoadingScaffold because: isInitialized=$isInitialized, imageState.isLoading=${imageState.isLoading}, imageControllerState.isLoading=${imageControllerState.isLoading}, gameState.isInitialized=${gameState.isInitialized}');
      return const _LoadingScaffold();
    }

    // Les vérifications précédentes garantissent que les données sont non-null

    if (imageState.error != null && imageState.error!.isNotEmpty) {
      return _ErrorScaffold(error: imageState.error!);
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: (gameState.puzzleType == 2 || gameState.puzzleType == 3)
          ? const EducationalAppBar()
              as PreferredSizeWidget // AppBar éducative pour puzzles éducatifs et combinaisons
          : AppBar(
              backgroundColor: Colors.green.shade600,
              elevation: 4,
              automaticallyImplyLeading: false,
              toolbarHeight: 56,
              title: const CustomToolbar(key: Key('toolbar')),
            ) as PreferredSizeWidget,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  if (_showingFullImage)
                    const ImagePreview()
                  else
                    const PuzzleBoard(),
                  if (imageState.isLoading == true)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  // FloatingActionButtons seulement en mode puzzle normal (pas éducatif/combinaisons)
                  if (gameState.puzzleType == 1)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: _buildFloatingActionButtons(context),
                    ),
                ],
              ),
            ),
          ),
          if (gameState.isInitialized == false) const _InitializationMessage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 PuzzleGameScreen: initState appelé');

    // Éviter les initialisations multiples
    if (_initializationFuture == null) {
      debugPrint('📋 Démarrage initialisation...');
      _initializationFuture = _initialize();
      _previewController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      _initializationFuture!.then((_) {
        if (mounted) {
          debugPrint('✅ Initialisation terminée dans initState');
        }
      }).catchError((e) {
        debugPrint('❌ Erreur dans initState: $e');
      });
    } else {
      debugPrint('⚠️ Initialisation déjà en cours, ignorée');
    }
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final gameState = ref.watch(gameStateProvider);

    // Masquer l'œil si moins de 15 essais
    if (gameState.swapCount < 15) {
      return const SizedBox.shrink();
    }

    final buttons = [
      FloatingActionButton(
        heroTag: 'shareButton',
        onPressed: _toggleFullImage,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.remove_red_eye, color: Colors.white),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: orientation == Orientation.landscape
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttons,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttons,
            ),
    );
  }

  Future<void> _initialize() async {
    try {
      debugPrint('🎯 DÉBUT INITIALISATION');
      ref.read(initializationProvider.notifier).state = false;

      // 🗃️ ATTENDRE le chargement SQLite AVANT de continuer
      debugPrint('🔄 Attente chargement paramètres SQLite...');
      await ref.read(gameSettingsProvider.notifier).ensureLoaded();
      debugPrint('✅ Paramètres SQLite chargés !');

      debugPrint('🖼️ Chargement image d\'ouverture...');
      await ref.read(imageControllerProvider.notifier).loadOpeningImage();
      debugPrint('✅ Image d\'ouverture chargée');

      if (mounted) {
        debugPrint('🎉 Initialisation terminée avec succès');
        ref.read(initializationProvider.notifier).state = true;
      } else {
        debugPrint('⚠️ Widget non monté après initialisation');
      }
    } catch (e) {
      debugPrint('❌ ERREUR INITIALISATION: $e');
      if (mounted) {
        ref.read(initializationProvider.notifier).state = false;
      }
      rethrow;
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Fallback en cas de problème de localisation
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Source d\'image'),
          content: Text('Erreur de localisation'),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade50,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section LECTURE (bleue)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    'LECTURE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading:
                        const Icon(Icons.photo_library, color: Colors.blue),
                    title: Text(l10n.galleryOption),
                    onTap: () {
                      Navigator.pop(context);
                      ref
                          .read(imageControllerProvider.notifier)
                          .pickImageFromGallery(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.blue),
                    title: Text(l10n.cameraOption),
                    onTap: () {
                      Navigator.pop(context);
                      ref
                          .read(imageControllerProvider.notifier)
                          .takePhoto(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Section ENVOI (orange) - DÉSACTIVÉE
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(8.0),
            //   decoration: BoxDecoration(
            //     color: Colors.orange.shade100,
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   child: Column(
            //     children: [
            //       Text(
            //         'ENVOI',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.orange.shade800,
            //           fontSize: 16,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       ListTile(
            //         leading: const Icon(Icons.share, color: Colors.orange),
            //         title: const Text('Partage ce Puzzle'),
            //         onTap: () {
            //           Navigator.pop(context);
            //           _shareCurrentPuzzle(context);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // /// Partager le puzzle actuel - FONCTION DÉSACTIVÉE
  // void _shareCurrentPuzzle(BuildContext context) {
  //   // Déclencher le partage depuis PuzzleBoard
  //   // On utilise un callback pour communiquer avec PuzzleBoard
  //   if (mounted) {
  //     // Émettre un événement pour déclencher le partage
  //     ref.read(gameStateProvider.notifier).triggerShare();
  //   }
  // }

  void _toggleFullImage() {
    setState(() {
      _showingFullImage = !_showingFullImage;
      if (_showingFullImage) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _showingFullImage = false);
          }
        });
      }
    });
  }
}
