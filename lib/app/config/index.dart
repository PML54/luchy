/// <cursor>
/// LUCHY - Export central des configurations
///
/// Fichier barrel pour centraliser tous les exports de configuration
/// et simplifier les imports dans le reste de l'application.
///
/// COMPOSANTS PRINCIPAUX:
/// - Export app_config.dart: Configuration principale application
/// - Import simplifié: Un seul point d'accès pour toutes les configs
/// - Organisation: Structure claire des dépendances configuration
///
/// ÉTAT ACTUEL:
/// - Exports: app_config.dart uniquement (Firebase supprimé)
/// - Import pattern: 'app/config/index.dart' dans main.dart
/// - État: Simplifié après nettoyage Firebase
///
/// HISTORIQUE RÉCENT:
/// - Suppression export firebase_config_prod.dart
/// - Simplification structure après nettoyage Firebase
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Exports: Maintenir cohérence avec structure fichiers
/// - Barrel pattern: Éviter exports circulaires
/// - Import organization: Garder structure claire et prévisible
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter exports pour nouvelles configurations si nécessaire
/// - Maintenir organisation claire des imports
/// - Considérer groupement thématique si expansion
///
/// 🔗 FICHIERS LIÉS:
/// - app/config/app_config.dart: Configuration principale exportée
/// - main.dart: Utilisation principale des exports
///
/// CRITICALITÉ: ⭐⭐ (Utilitaire import, faible complexité)
/// </cursor>

export 'app_config.dart';
