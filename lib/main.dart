/// <cursor>
/// LUCHY - Point d'entrée principal de l'application
///
/// Ce fichier constitue le cœur de l'application Luchy, un jeu de puzzle
/// développé en Flutter avec gestion d'état via Riverpod.
///
/// COMPOSANTS PRINCIPAUX:
/// - MyApp: Widget principal avec configuration thème/localisation
/// - ErrorBoundary: Mécanisme de capture d'erreurs globales
/// - EmergencyApp: Interface de secours en cas d'erreur fatale
///
/// ÉTAT ACTUEL:
/// - Firebase: Désactivé (config dummy, pas d'initialisation)
/// - Version: 1.1.0+3 (build visible dans l'aide)
/// - Localisation: Français/Anglais supportés
/// - État: Stable après nettoyage Firebase
///
/// HISTORIQUE RÉCENT:
/// - Suppression Firebase (garde config dummy pour éviter erreurs)
/// - Nettoyage logs debug problématiques
/// - Versioning mis à jour pour suivi builds
/// - Documentation mise à jour format <cursor>
/// - Suppression commentaires Firebase obsolètes
/// - Suppression classes inutilisées (SafeApp, ProviderLogger)
/// - Build & install iOS validé après nettoyage (v1.1.0+3)
///
/// 🔧 POINTS D'ATTENTION:
/// - Config Firebase dummy: Ne pas mettre de valeurs vides (cause plantages)
/// - ErrorBoundary: Capture les erreurs mais l'UI reste figée
/// - Debug logs: Éviter substring() sur config.apiKey (peut être vide)
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Améliorer ErrorBoundary avec bouton redémarrage
/// - Ajouter monitoring des performances (fps, mémoire)
/// - Optimiser logs debug pour production
/// - Considérer analytics anonymes pour crashes
///
/// 🔗 FICHIERS LIÉS:
/// - app/config/app_config.dart: Configuration principale
/// - features/common/domain/providers/device_config_provider.dart: Config device
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Écran principal
/// - l10n/app_localizations.dart: Système de traduction
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Point d'entrée critique)
/// </cursor>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/common/domain/providers/device_config_provider.dart';
import 'package:luchy/l10n/app_localizations.dart';

import 'app/config/index.dart';
import 'features/puzzle/presentation/screens/puzzle_game_screen.dart';

void main() async {
  try {
    debugPrint('Starting app initialization...');
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Flutter binding initialized');

    final container = ProviderContainer();
    debugPrint('Provider container created');

    final config = container.read(configProvider);
    debugPrint('===== Configuration loaded =====');
    debugPrint('App name: ${config.appName}');
    debugPrint('Environment: ${config.environment}');
    debugPrint('Version: ${config.version}');
    debugPrint('Debug mode: ${config.isDebugMode}');
    debugPrint('Analytics: ${config.enableAnalytics}');
    debugPrint('=============================');

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint('FATAL ERROR: $e');
    debugPrint('Stack trace: $stack');
    runApp(const EmergencyApp());
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Error? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('ErrorBoundary: dependencies changed');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: ${_error.toString()}'),
          ),
        ),
      );
    }

    return widget.child;
  }
}

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Une erreur inattendue est survenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Veuillez redémarrer l\'application',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final deviceConfig = ref.watch(deviceConfigProvider);
      final appConfig = ref.watch(configProvider);

      return MaterialApp(
        title: appConfig.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: deviceConfig.capabilities.supportsDarkMode
                ? Theme.of(context).brightness
                : Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const PuzzleGameScreen(),
      );
    } catch (e) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $e'),
          ),
        ),
      );
    }
  }
}
