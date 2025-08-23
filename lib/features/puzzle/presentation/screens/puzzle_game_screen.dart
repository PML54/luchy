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
///
/// HISTORIQUE RÉCENT:
/// - Suppression message bienvenue au lancement (causait problèmes)
/// - Amélioration gestion erreurs et états de chargement
/// - Optimisation performance et fluidité interface
/// - Documentation mise à jour format <cursor>
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
/// - features/puzzle/presentation/screens/help_screen.dart: Aide
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Interface principale utilisateur)
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
import 'package:luchy/features/puzzle/presentation/screens/help_screen.dart';
import 'package:luchy/features/puzzle/presentation/widgets/board/puzzle_board.dart';
import 'package:luchy/features/puzzle/presentation/widgets/image/image_preview.dart';
import 'package:luchy/features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart';
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
          const Icon(Icons.help_outline, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.selectImageHelp,
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
  late Future<void> _initializationFuture;
  bool _showingFullImage = false;
  late AnimationController _previewController;

  @override
  Widget build(BuildContext context) {
    final isInitialized = ref.watch(initializationProvider);
    final gameState = ref.watch(gameStateProvider);
    final imageState = ref.watch(imageProcessingProvider);

    if (isInitialized == false || imageState.isLoading == true) {
      return const _LoadingScaffold();
    }

    if (imageState.error?.isNotEmpty ?? false) {
      return _ErrorScaffold(error: imageState.error!);
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const CustomToolbar(key: Key('toolbar')),
      ),
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
                ],
              ),
            ),
          ),
          if (gameState.isInitialized == false) const _InitializationMessage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initialize();
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializationFuture.then((_) {
      if (mounted) {
        // Application initialisée
      }
    });
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final buttons = [
      FloatingActionButton(
        heroTag: 'helpButton',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpScreen()),
        ),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.help_outline, color: Colors.white),
      ),
      const SizedBox(height: 16, width: 16),
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
      ref.read(initializationProvider.notifier).state = false;
      
      // 🗃️ ATTENDRE le chargement SQLite AVANT de continuer
      print('🔄 Attente chargement paramètres SQLite...');
      await ref.read(gameSettingsProvider.notifier).ensureLoaded();
      print('✅ Paramètres SQLite chargés !');
      
      await ref.read(imageControllerProvider.notifier).loadRandomImage();
      if (mounted) {
        ref.read(initializationProvider.notifier).state = true;
      }
    } catch (e) {
      if (mounted) {
        ref.read(initializationProvider.notifier).state = false;
      }
      rethrow;
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade100,
        title: Text(l10n.sourceDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.galleryOption),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(imageControllerProvider.notifier)
                    .pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.cameraOption),
              onTap: () {
                Navigator.pop(context);
                ref.read(imageControllerProvider.notifier).takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

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
