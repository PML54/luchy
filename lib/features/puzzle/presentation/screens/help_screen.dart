/// <cursor>
/// LUCHY - Écran d'aide et informations
///
/// Écran d'aide avec instructions du jeu, crédits et informations
/// sur l'application avec support multilingue FR/EN.
///
/// COMPOSANTS PRINCIPAUX:
/// - HelpScreen: ConsumerStatefulWidget avec PackageInfo
/// - Markdown renderer: Affichage contenu riche formaté
/// - Localisation: Support français/anglais automatique
/// - Version display: Affichage version app et build number
/// - Message spécial: Section dédiée félicitations mariage
/// - Artist credits: Crédits Camille Pissarro et autres artistes
///
/// ÉTAT ACTUEL:
/// - Contenu: Instructions complètes, tips optimisation, crédits
/// - Localisation: FR/EN avec détection automatique langue
/// - Version: Affichage v1.1.0+3 en bas de page
/// - Message mariage: Section spéciale Mathieu & Noëllie
///
/// HISTORIQUE RÉCENT:
/// - Ajout message spécial mariage (remplace popup lancement)
/// - Intégration affichage version et build number
/// - Remplacement "PuzHub" par "Luchy" dans contenu
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - PackageInfo: Gestion async pour récupération version
/// - Markdown performance: Surveiller temps rendu gros contenu
/// - Localisation: Maintenir cohérence FR/EN
/// - Scrolling: Assurer navigation fluide sur petits écrans
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter section FAQ dynamique
/// - Implémenter recherche dans contenu aide
/// - Ajouter liens externes (site artistes, etc.)
/// - Optimiser mise en page pour tablets
///
/// 🔗 FICHIERS LIÉS:
/// - l10n/app_localizations.dart: Textes localisés
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Navigation
/// - pubspec.yaml: Configuration version affichée
///
/// CRITICALITÉ: ⭐⭐⭐ (Information utilisateur importante)
/// </cursor>
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HelpScreen extends ConsumerStatefulWidget {
  HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  final MarkdownStyleSheet styleSheet = MarkdownStyleSheet(
    h1: const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
    h2: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
    p: const TextStyle(fontSize: 16),
  );

  String appVersion = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _getVersionInfo();
  }

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        backgroundColor: Colors.blue,
        // Retirer la section actions qui contenait le bouton de changement de langue
      ),
      body: Markdown(
        data: getHelpContent(l10n),
        styleSheet: styleSheet,
      ),
    );
  }

  String getHelpContent(AppLocalizations l10n) {
    if (l10n.localeName == 'fr') {
      return '''
# Luchy - créez et partagez vos puzzles

Luchy est une application qui vous permet de transformer vos photos ou dessins en puzzles personnalisés et de les partager avec vos amis ou votre famille.

## fonctionnement

### créer un puzzle
1. choisissez une photo depuis votre galerie ou prenez une nouvelle photo
2. sélectionnez le niveau de difficulté avec les flèches < et >
   - niveau 0 : 4 pièces (2×2)
   - niveau 14 : 81 pièces (9×9)

### partager un puzzle
1. une fois votre puzzle créé, utilisez le bouton "partage"
2. l'application génère :
   - une image mélangée
   - Un code unique à 3 chiffres
3. Envoyez les deux via SMS, WhatsApp, email, etc.

### Recevoir et Jouer
1. Quand vous recevez un puzzle Luchy :
   - Sauvegardez l'image reçue
   - Notez le code à 3 chiffres
2. Dans Luchy, choisissez "Photo+Code"
3. Sélectionnez l'image reçue
4. Entrez le code reçu

## À propos des images dans Luchy

### Les artistes et illustrations présents dans l'application
Notre application s'inspire de nombreux artistes et illustrateurs renommés pour enrichir votre expérience :
* **Benjamin Rabier**, célèbre pour le logo de la Vache qui rit
* **Marguerite Calvet-Rogniat**, illustratrice des *Malheurs de Sophie*
* **Vincent van Gogh**, dont de nombreuses œuvres ont été créées à Auvers-sur-Oise, près de Pontoise, où **Camille Pissarro** a également beaucoup peint (mais dont les œuvres ne sont malheureusement pas encore dans le domaine public)

Bien que les œuvres de **Pablo Picasso** ne soient pas utilisées directement dans l'application, elles constituent un excellent choix à titre privé. Ses œuvres, aux couleurs uniformes et contrastées, sont idéales pour créer des puzzles compressés et visuellement percutants. Vous pouvez ainsi réaliser des puzzles privés à partir de ses tableaux, offrant un rendu exceptionnel.

Nous avons également inclus des tableaux de grands maîtres tels que **Johannes Vermeer**, **Raphaël**, **Léonard de Vinci**, et **Botticelli**, ainsi que des photos de famille amusantes pour varier les plaisirs.

### Conseils pour optimiser vos puzzles

#### Choix du ratio d'image en fonction de votre appareil
Les écrans des appareils iOS ont des proportions spécifiques que nous vous conseillons de respecter pour une expérience optimale :

1. **Pour un iPhone** :
   * En mode portrait : utilisez des images dont la hauteur est environ **2,2 fois la largeur**
   * En mode paysage : privilégiez des images dont la largeur est environ **2,2 fois la hauteur**

2. **Pour un iPad** :
   * En mode portrait : choisissez des images dont la hauteur est environ **1,3 fois la largeur**
   * En mode paysage : préférez des images dont la largeur est environ **1,3 fois la hauteur**

#### Pourquoi ces ratios ?
Ces proportions permettent de remplir l'écran sans bordures gênantes ni déformations majeures. L'application Puzhub respecte strictement les ratios originaux des images, ce qui signifie que vos images ne seront ni distordues ni tronquées pour s'adapter à l'écran.

#### Astuce pour les amateurs d'art
Les œuvres de styles impressionnistes, riches en détails, peuvent être moins adaptées à la compression. À l'inverse, les peintures aux couleurs franches et uniformes, comme celles de Picasso, se prêtent particulièrement bien à la création de puzzles.

Explorez les possibilités et amusez-vous à créer des puzzles uniques à partir de vos images favorites !

---

## 💐 Message Spécial

**Avec les félicitations pour ton mariage, Mathieu & Noëllie !**

*Et surtout, longue vie à l'épicerie de Luchy* 🍎 *!*

Cette application est dédiée avec beaucoup d'affection à l'occasion de votre union. Que votre bonheur soit aussi durable que les traditions de notre beau village de Luchy !

---

**Luchy v$appVersion (Build $buildNumber)**  
*Application de puzzle fait avec ❤️*
''';
    } else {
      return '''
# Luchy - Create and Share your Puzzles

Luchy lets you transform your photos or pictures into custom puzzles and share them with friends and family.

## How It Works

### Create a Puzzle
1. Select a photo from your gallery or take a new photo
2. Choose difficulty level with < and > arrows
   - Level 0: 4 pieces (2×2)
   - Level 14: 81 pieces (9×9)

### Share a Puzzle
1. Once your puzzle is ready, use the "Share" button
2. The app generates:
   - A mixed image
   - A unique 3-digit code
3. Send both via SMS, WhatsApp, email, etc.

### Receive and Play
1. When you receive a Luchy puzzle:
   - Save the received image
   - Note the 3-digit code
2. In Luchy, select "Photo+Code"
3. Choose the received image
4. Enter the received code

## About Images in Luchy

### Featured Artists and Illustrations
Our application draws inspiration from various renowned artists and illustrators to enrich your puzzle-solving experience:
* **Benjamin Rabier**, famous for creating the iconic "La Vache Qui Rit" (Laughing Cow) logo
* **Marguerite Calvet-Rogniat**, the illustrator of "Les Malheurs de Sophie" (Sophie's Misfortunes)
* **Vincent van Gogh**, who created many masterpieces in Auvers-sur-Oise, near Pontoise, where **Camille Pissarro** also painted extensively (though his works are not yet in the public domain)

While **Pablo Picasso's** works are not directly included in the application, they make excellent choices for private puzzles. His paintings, with their uniform and contrasting colors, are ideal for creating compressed, visually striking puzzles. You can create private puzzles from his paintings for an exceptional experience.

We have also included masterpieces from great artists such as **Johannes Vermeer**, **Raphael**, **Leonardo da Vinci**, and **Botticelli**, along with fun family photos to add variety.

### Tips for Optimizing Your Puzzles

#### Image Ratio Guidelines for Your Device
iOS devices have specific screen proportions that we recommend following for the best experience:

1. **For iPhone**:
   * Portrait mode: Use images with a height approximately **2.2 times the width**
   * Landscape mode: Choose images with a width approximately **2.2 times the height**

2. **For iPad**:
   * Portrait mode: Select images with a height approximately **1.3 times the width**
   * Landscape mode: Use images with a width approximately **1.3 times the height**

#### Why These Ratios Matter
These proportions allow images to fill the screen without awkward borders or major distortions. Luchy strictly respects original image ratios, meaning your images won't be distorted or cropped to fit the screen.

#### Art Enthusiasts' Tips
Impressionist artworks, rich in details, may be less suitable for compression. Conversely, paintings with bold, uniform colors, like Picasso's works, are particularly well-suited for creating puzzles.

Feel free to explore the possibilities and have fun creating unique puzzles from your favorite images!

---

## 💐 Special Message

**Congratulations on your wedding, Mathieu & Noëllie!**

*And above all, long live Luchy's grocery store* 🍎 *!*

This application is dedicated with much affection on the occasion of your union. May your happiness be as enduring as the traditions of our beautiful village of Luchy!

---

**Luchy v$appVersion (Build $buildNumber)**  
*Puzzle app made with ❤️*
''';
    }
  }
}
