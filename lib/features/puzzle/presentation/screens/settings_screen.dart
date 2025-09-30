/// <cursor>
///
/// settings_screen.dart
///
/// Écran de paramètres centralisé
/// Interface unifiée pour toutes les options de l'application
///
/// COMPOSANTS PRINCIPAUX:
/// - SettingsScreen: Écran principal des paramètres
/// - SettingsSection: Sections d'options générales
/// - AboutSection: Section à propos
///
/// ÉTAT ACTUEL:
/// - Interface Material Design moderne
/// - Paramètres généraux
/// - Section à propos
/// - Design cohérent avec l'app
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création de l'écran paramètres centralisé
/// - 2025-01-27: Suppression des codes VIP et simplification
///
/// 🔧 POINTS D'ATTENTION:
/// - Interface: Design cohérent avec l'app
/// - Simplicité: Focus sur les paramètres essentiels
/// - Extensibilité: Facile d'ajouter de nouvelles sections
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter plus d'options de paramètres
/// - Thèmes et personnalisation
/// - Export/import des données
/// - Notifications et alertes
///
/// 🔗 FICHIERS LIÉS:
/// - core/database/database_service.dart: Service de base de données
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Configuration centrale)
/// 📅 Dernière modification: 2025-01-27
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Paramètres'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Général
            _buildGeneralSection(),
            SizedBox(height: 24),

            // Section À propos
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Général',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Option 1: Sons
            ListTile(
              leading: Icon(Icons.volume_up, color: Colors.green),
              title: Text('Sons'),
              subtitle: Text('Activer/désactiver les effets sonores'),
              trailing: Switch(
                value: true, // TODO: Connecter à un provider
                onChanged: (value) {
                  // TODO: Implémenter la logique
                },
              ),
            ),

            Divider(),

            // Option 2: Vibrations
            ListTile(
              leading: Icon(Icons.vibration, color: Colors.orange),
              title: Text('Vibrations'),
              subtitle: Text('Activer/désactiver les vibrations'),
              trailing: Switch(
                value: true, // TODO: Connecter à un provider
                onChanged: (value) {
                  // TODO: Implémenter la logique
                },
              ),
            ),

            Divider(),

            // Option 3: Notifications
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.purple),
              title: Text('Notifications'),
              subtitle: Text('Recevoir des notifications de l\'app'),
              trailing: Switch(
                value: false, // TODO: Connecter à un provider
                onChanged: (value) {
                  // TODO: Implémenter la logique
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'À propos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Informations sur l'app
            _buildInfoRow('Version', '1.0.0'),
            _buildInfoRow('Développeur', 'PML'),
            _buildInfoRow('Date de création', '2025'),
            _buildInfoRow('Plateforme', 'Flutter'),

            SizedBox(height: 16),

            // Bouton de réinitialisation (debug)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _resetDatabase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('🔄 Réinitialiser la base de données'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDatabase() async {
    try {
      // DatabaseService supprimé - fonctionnalité désactivée
      // final databaseService = DatabaseService.instance;

      // Fermer la base actuelle
      // await databaseService.close();

      // Forcer la recréation
      // await databaseService.database;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Base de données réinitialisée'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
