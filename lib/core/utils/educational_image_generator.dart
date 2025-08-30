/// <cursor>
/// LUCHY - Générateur d'images éducatives
///
/// Utilitaire pour créer des images de puzzle éducatives avec
/// 2 colonnes (questions/réponses, français/anglais, etc.).
///
/// COMPOSANTS PRINCIPAUX:
/// - generateNamesGridImagqe(): Génération image grille 2 colonnes
/// - generateMultiplicationTable(): Preset tables de multiplication
/// - getVocabularyList(): Preset vocabulaire français-anglais
/// - Educational presets: Collections prêtes à utiliser
///
/// ÉTAT ACTUEL:
/// - Génération: Image PNG en mémoire avec dart:ui natif
/// - Auto-fit: Adaptation automatique taille police
/// - Customisation: Dimensions, couleurs, styles configurables
/// - Intégration: Compatible avec Image.memory() existant
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: NOUVEAU TYPE PUZZLE - Combinaisons mathématiques (type 3)
/// - Ajout TypeDeJeu.combinaisonsMatematiques pour coefficients binomiaux
/// - Générateur automatique couples (n,p) avec n≥p, n<6, résultats uniques
/// - Notation LaTeX moderne \binom{n}{p} avec flutter_math_fork
/// - Support puzzleType=3 dans architecture existante
/// - Integration complète interface utilisateur et providers
/// - 2025-01-27: RESTRUCTURATION MAJEURE: QuestionnairePreset avec niveaux français
/// - Niveaux: Primaire, Collège, Lycée, Prépa, Supérieur
/// - Catégories: Mathématiques, Français, Anglais, Histoire, Géographie, Sciences, Économie
/// - Structure: id, nom, titre, niveau, catégorie, colonnes, sousThème
/// - Couleurs par niveau: Vert→Bleu→Orange→Violet→Rouge
/// - Compatibilité: Conversion automatique vers ancien format
/// - 2025-08-25: Création initiale avec code utilisateur
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance: dart:ui peut être lourd pour grandes grilles
/// - Memory: Surveiller usage mémoire pour images complexes
/// - Text rendering: Gérer débordement texte et ellipsis
/// - Aspect ratio: Maintenir proportions pour découpage puzzle
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter plus de presets (géographie, sciences)
/// - Implémenter validation longueur textes
/// - Optimiser rendu pour grandes grilles
/// - Ajouter export/sauvegarde optionnel
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/controllers/image_controller.dart: Intégration
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: UI
/// - core/utils/image_optimizer.dart: Optimisation post-génération
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (STRUCTURE ÉDUCATIVE COMPLÈTE)
/// 📅 Dernière modification: 2025-01-27 20:05
/// </cursor>

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Résultat de génération d'image éducative
class EducationalImageResult {
  final Uint8List pngBytes;
  final int rows;
  final int columns;
  final String description;
  final List<int>? originalMapping; // Mapping des indices originaux

  const EducationalImageResult({
    required this.pngBytes,
    required this.rows,
    required this.columns,
    required this.description,
    this.originalMapping,
  });
}

/// Résultat du mélange éducatif
class EducationalShuffleResult {
  final List<String> shuffledLeft;
  final List<String> shuffledRight;
  final List<int> mapping; // Indices originaux pour chaque position

  const EducationalShuffleResult({
    required this.shuffledLeft,
    required this.shuffledRight,
    required this.mapping,
  });
}

/// Niveaux éducatifs français
enum NiveauEducatif {
  primaire('Primaire', 'CP-CM2', 1),
  college('Collège', 'Brevet', 2),
  lycee('Lycée', 'Baccalauréat', 3),
  prepa('Prépa', 'CPGE', 4),
  superieur('Supérieur', 'Licence+', 5);

  const NiveauEducatif(this.nom, this.diplome, this.ordre);
  final String nom;
  final String diplome;
  final int ordre; // Pour trier par difficulté
}

/// Catégories de matières
enum CategorieMatiere {
  mathematiques('Mathématiques', '🧮'),
  francais('Français', '📝'),
  anglais('Anglais', '🇬🇧'),
  histoire('Histoire', '🏛️'),
  geographie('Géographie', '🌍'),
  sciences('Sciences', '🔬'),
  economie('Économie', '💼');

  const CategorieMatiere(this.nom, this.emoji);
  final String nom;
  final String emoji;
}

/// Types de jeux éducatifs possibles
enum TypeDeJeu {
  correspondanceVisAVis('Correspondance vis-à-vis',
      'Associer chaque élément de gauche avec son correspondant de droite'),
  ordreChronologique(
      'Ordre chronologique', 'Remettre les éléments dans l\'ordre temporel'),
  classementCroissant(
      'Classement croissant', 'Ordonner du plus petit au plus grand'),
  groupement('Groupement', 'Rassembler les éléments par catégories'),
  sequenceLogique('Séquence logique', 'Compléter une suite logique'),
  combinaisonsMatematiques('Combinaisons mathématiques',
      'Associer formules de combinaisons avec leurs résultats');

  const TypeDeJeu(this.nom, this.description);
  final String nom;
  final String description;
}

/// Structure complète d'un questionnaire éducatif
class QuestionnairePreset {
  final String id;
  final String nom;
  final String titre; // Titre affiché en haut de l'image
  final NiveauEducatif niveau;
  final CategorieMatiere categorie;
  final TypeDeJeu typeDeJeu; // Type de mécanisme de jeu
  final List<String> colonneGauche;
  final List<String> colonneDroite;
  final String? description;
  final String? sousTheme; // Ex: "Analyse combinatoire", "Conjugaison"
  final double?
      ratioLargeurColonnes; // Ratio gauche/droite (ex: 0.75 = 75%/25%)

  const QuestionnairePreset({
    required this.id,
    required this.nom,
    required this.titre,
    required this.niveau,
    required this.categorie,
    required this.typeDeJeu,
    required this.colonneGauche,
    required this.colonneDroite,
    this.description,
    this.sousTheme,
    this.ratioLargeurColonnes, // null = 50%/50% par défaut
  });

  /// Conversion vers l'ancien format pour compatibilité
  EducationalPreset toEducationalPreset() {
    return EducationalPreset(
      id: id,
      name: nom,
      description: description ?? titre,
      leftColumn: colonneGauche,
      rightColumn: colonneDroite,
    );
  }
}

/// Preset éducatif (ancien format - gardé pour compatibilité)
class EducationalPreset {
  final String id;
  final String name;
  final String description;
  final List<String> leftColumn;
  final List<String> rightColumn;

  const EducationalPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.leftColumn,
    required this.rightColumn,
  });
}

/// Générateur d'images éducatives
class EducationalImageGenerator {
  /// Génère une image portrait avec 2 colonnes (liste gauche / liste droite)
  /// et n lignes (n = left.length = right.length). Chaque cellule a la même taille,
  /// idéale pour un découpage ultérieur en 2n sous-images.
  /// Retourne des bytes PNG (Uint8List).
  static Future<EducationalImageResult> generateNamesGridImage({
    required List<String> left,
    required List<String> right,
    double cellWidth =
        600, // largeur d'une cellule (colonne) - pour compatibilité
    double cellHeight = 200, // hauteur d'une cellule (ligne)
    double padding = 24, // marge intérieure pour le texte
    double initialFontSize = 64,
    double minFontSize = 20,
    Color backgroundColor = Colors.white,
    Color? leftColumnColor, // Couleur fond colonne gauche
    Color? rightColumnColor, // Couleur fond colonne droite
    Color gridColor = Colors.black,
    double gridStrokeWidth = 2.0,
    String? fontFamily, // éventuellement passer une police custom
    String description = "Image éducative personnalisée",
    double? ratioLargeurColonnes, // Ratio gauche/droite (null = 50%/50%)
  }) async {
    assert(left.length == right.length,
        "Les deux listes doivent avoir la même longueur.");
    final n = left.length;

    // Calcul des largeurs selon le ratio (défaut 50%/50%)
    final double ratio = ratioLargeurColonnes ?? 0.5;
    final double totalWidth = cellWidth * 2;
    final double leftCellWidth = totalWidth * ratio;
    final double rightCellWidth = totalWidth * (1.0 - ratio);

    final double width = leftCellWidth + rightCellWidth;
    final double height = cellHeight * n;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

    // Fond général
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    // Fonds colorés par colonne avec largeurs dynamiques
    if (leftColumnColor != null) {
      final leftColumnPaint = Paint()..color = leftColumnColor;
      canvas.drawRect(
          Rect.fromLTWH(0, 0, leftCellWidth, height), leftColumnPaint);
    }

    if (rightColumnColor != null) {
      final rightColumnPaint = Paint()..color = rightColumnColor;
      canvas.drawRect(Rect.fromLTWH(leftCellWidth, 0, rightCellWidth, height),
          rightColumnPaint);
    }

    // Grille
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = gridStrokeWidth;
    // Contour extérieur
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), gridPaint);
    // Ligne verticale centrale (largeur dynamique)
    canvas.drawLine(
        Offset(leftCellWidth, 0), Offset(leftCellWidth, height), gridPaint);
    // Lignes horizontales
    for (int i = 1; i < n; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Helper pour créer un TextPainter
    TextPainter _tp(String text, TextStyle style) => TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    // Dessine la notation binomiale moderne (n au-dessus de p dans des parenthèses)
    void drawBinomialNotation(
      String n,
      String p,
      Rect cell, {
      double gap = 6, // espace vertical entre n et p
    }) {
      final numberFontSize =
          (initialFontSize * 1.2).clamp(minFontSize, initialFontSize * 1.5);
      final parenFontSize =
          (initialFontSize * 1.4).clamp(minFontSize, initialFontSize * 1.8);

      final tsNumber = TextStyle(
        fontSize: numberFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      );

      final tsParen = TextStyle(
        fontSize: parenFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      );

      // Prépare les painters
      final top = _tp(n, tsNumber);
      final bot = _tp(p, tsNumber);
      final lParen = _tp("(", tsParen);
      final rParen = _tp(")", tsParen);

      top.layout();
      bot.layout();
      lParen.layout();
      rParen.layout();

      // Dimensions combinées (largeur = parenthèse gauche + max(n,p) + parenthèse droite)
      final innerWidth = top.width > bot.width ? top.width : bot.width;
      final totalWidth = lParen.width + innerWidth + rParen.width;

      // Hauteur combinée (n au-dessus, p en dessous, séparés par gap)
      final totalHeight = top.height + gap + bot.height;

      // Point de départ pour centrer dans cell
      final start = Offset(
        cell.left + (cell.width - totalWidth) / 2,
        cell.top + (cell.height - totalHeight) / 2,
      );

      // Positions
      final leftParenOffset =
          Offset(start.dx, start.dy + (totalHeight - lParen.height) / 2);
      final numbersStartX = start.dx + lParen.width;

      final topOffset = Offset(
        numbersStartX + (innerWidth - top.width) / 2,
        start.dy,
      );
      final botOffset = Offset(
        numbersStartX + (innerWidth - bot.width) / 2,
        start.dy + top.height + gap,
      );

      final rightParenOffset = Offset(
        numbersStartX + innerWidth,
        start.dy + (totalHeight - rParen.height) / 2,
      );

      // Dessin
      lParen.paint(canvas, leftParenOffset);
      top.paint(canvas, topOffset);
      bot.paint(canvas, botOffset);
      rParen.paint(canvas, rightParenOffset);
    }

    // Fonction d'écriture centrée avec auto-fit et support notation binomiale
    Future<void> drawCenteredTextInCell({
      required String text,
      required Rect cell,
    }) async {
      // Vérifier si c'est une notation binomiale C(n,p)
      final binomMatch = RegExp(r'C\((\d+),(\d+)\)').firstMatch(text);

      if (binomMatch != null) {
        // Dessiner la notation binomiale moderne
        final n = binomMatch.group(1)!;
        final p = binomMatch.group(2)!;
        drawBinomialNotation(n, p, cell);
        return;
      }

      // Sinon, dessiner le texte normal
      double fontSize = initialFontSize;
      TextPainter painter;

      final isMultiline = text.contains('\n');
      final maxLines = isMultiline ? 2 : 1;

      while (true) {
        final textSpan = TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontFamily: fontFamily,
            height: isMultiline ? 0.8 : 1.0,
          ),
        );
        painter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          ellipsis: '…',
        );
        painter.layout(maxWidth: cell.width - 2 * padding);

        final fitsWidth = painter.size.width <= (cell.width - 2 * padding);
        final fitsHeight = painter.size.height <= (cell.height - 2 * padding);

        if ((fitsWidth && fitsHeight) || fontSize <= minFontSize) {
          break;
        }
        fontSize = (fontSize - 2).clamp(minFontSize, initialFontSize);
      }

      final dx = cell.left + (cell.width - painter.size.width) / 2;
      final dy = cell.top + (cell.height - painter.size.height) / 2;
      painter.paint(canvas, Offset(dx, dy));
    }

    // Remplir les cellules avec largeurs dynamiques
    for (int i = 0; i < n; i++) {
      // Colonne gauche (largeur dynamique)
      final leftCell = Rect.fromLTWH(
        0,
        i * cellHeight,
        leftCellWidth,
        cellHeight,
      );
      await drawCenteredTextInCell(text: left[i], cell: leftCell);

      // Colonne droite (largeur dynamique)
      final rightCell = Rect.fromLTWH(
        leftCellWidth,
        i * cellHeight,
        rightCellWidth,
        cellHeight,
      );
      await drawCenteredTextInCell(text: right[i], cell: rightCell);
    }

    // Finalise l'image
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return EducationalImageResult(
      pngBytes: byteData!.buffer.asUint8List(),
      rows: n,
      columns: 2,
      description: description,
    );
  }

  /// Génère une table de multiplication
  static EducationalPreset generateMultiplicationTable(int table) {
    final left = <String>[];
    final right = <String>[];

    for (int i = 1; i <= 10; i++) {
      left.add('$table × $i =');
      right.add('${table * i}');
    }

    return EducationalPreset(
      id: 'multiplication_$table',
      name: '$table',
      description: '',
      leftColumn: left,
      rightColumn: right,
    );
  }

  /// Génère un puzzle de combinaisons mathématiques
  /// Crée des couples (n,p) avec n >= p et n < 6, en s'assurant que tous les résultats sont uniques
  static QuestionnairePreset generateCombinationsPuzzle() {
    /// Calcule C(n,p) = n! / (p! * (n-p)!)
    int combinaison(int n, int p) {
      if (p > n || p < 0) return 0;
      if (p == 0 || p == n) return 1;

      // Optimisation: C(n,p) = C(n,n-p)
      if (p > n - p) p = n - p;

      int result = 1;
      for (int i = 0; i < p; i++) {
        result = result * (n - i) ~/ (i + 1);
      }
      return result;
    }

    // Générer tous les couples (n,p) possibles avec n < 8 et n >= p pour plus de diversité
    final allCouples = <({int n, int p})>[];
    for (int n = 0; n < 8; n++) {
      for (int p = 0; p <= n; p++) {
        allCouples.add((n: n, p: p));
      }
    }

    // Calculer les résultats et créer une map pour vérifier l'unicité
    final resultCounts = <int, List<({int n, int p})>>{};
    for (final couple in allCouples) {
      final result = combinaison(couple.n, couple.p);
      if (!resultCounts.containsKey(result)) {
        resultCounts[result] = [];
      }
      resultCounts[result]!.add(couple);
    }

    // Stratégie améliorée : prendre d'abord les couples uniques, puis compléter avec des couples distincts
    final selectedCouples = <({int n, int p})>[];
    final usedResults = <int>{};

    // 1. D'abord, ajouter tous les couples avec résultats uniques
    for (final entry in resultCounts.entries) {
      if (entry.value.length == 1 && selectedCouples.length < 5) {
        selectedCouples.add(entry.value.first);
        usedResults.add(entry.key);
      }
    }

    // 2. Si on n'a pas assez, ajouter des couples avec résultats distincts des précédents
    final remainingCouples = allCouples.where((couple) {
      final result = combinaison(couple.n, couple.p);
      return !usedResults.contains(result) &&
          !selectedCouples.any(
              (selected) => selected.n == couple.n && selected.p == couple.p);
    }).toList();

    remainingCouples.shuffle();
    for (final couple in remainingCouples) {
      if (selectedCouples.length >= 5) break;
      final result = combinaison(couple.n, couple.p);
      if (!usedResults.contains(result)) {
        selectedCouples.add(couple);
        usedResults.add(result);
      }
    }

    // Mélanger la sélection finale
    selectedCouples.shuffle();

    // Créer les colonnes
    final colonneGauche = <String>[];
    final colonneDroite = <String>[];

    for (final couple in selectedCouples) {
      // Utiliser la vraie notation LaTeX pour un rendu propre
      colonneGauche.add('C(${couple.n},${couple.p})');
      colonneDroite.add('${combinaison(couple.n, couple.p)}');
    }

    return QuestionnairePreset(
      id: 'prepa_math_combinaisons_aleatoire',
      nom: 'Combinaisons aléatoires',
      titre: 'COMBINAISONS - PUZZLE ALÉATOIRE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.combinaisonsMatematiques,
      sousTheme: 'Analyse combinatoire',
      colonneGauche: colonneGauche,
      colonneDroite: colonneDroite,
      description: 'Puzzle généré aléatoirement avec combinaisons uniques',
      ratioLargeurColonnes: 0.5, // 50%/50% pour un découpage plus équilibré
    );
  }

  /// Vocabulaire français-anglais : animaux
  static const EducationalPreset vocabularyAnimals = EducationalPreset(
    id: 'vocab_animals',
    name: 'Animaux FR-EN',
    description: '',
    leftColumn: [
      'Chat',
      'Chien',
      'Oiseau',
      'Poisson',
      'Cheval',
      'Vache',
      'Cochon',
      'Mouton',
      'Lapin',
      'Souris'
    ],
    rightColumn: [
      'Cat',
      'Dog',
      'Bird',
      'Fish',
      'Horse',
      'Cow',
      'Pig',
      'Sheep',
      'Rabbit',
      'Mouse'
    ],
  );

  /// Vocabulaire français-anglais : couleurs
  static const EducationalPreset vocabularyColors = EducationalPreset(
    id: 'vocab_colors',
    name: 'Couleurs FR-EN',
    description: '',
    leftColumn: [
      'Rouge',
      'Bleu',
      'Vert',
      'Jaune',
      'Orange',
      'Violet',
      'Rose',
      'Noir',
      'Blanc',
      'Gris'
    ],
    rightColumn: [
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Orange',
      'Purple',
      'Pink',
      'Black',
      'White',
      'Gray'
    ],
  );

  /// Géographie : capitales européennes
  static const EducationalPreset geographyEurope = EducationalPreset(
    id: 'geo_europe',
    name: 'Capitales Europe',
    description: '',
    leftColumn: [
      'France',
      'Allemagne',
      'Italie',
      'Espagne',
      'Portugal',
      'Angleterre',
      'Suède',
      'Norvège',
      'Grèce',
      'Pologne'
    ],
    rightColumn: [
      'Paris',
      'Berlin',
      'Rome',
      'Madrid',
      'Lisbonne',
      'Londres',
      'Stockholm',
      'Oslo',
      'Athènes',
      'Varsovie'
    ],
  );

  // ============ QUESTIONNAIRES STRUCTURÉS ============

  /// Questionnaires organisés par niveau et matière
  static List<QuestionnairePreset> questionnaires = [
    // === PRIMAIRE ===
    QuestionnairePreset(
      id: 'primaire_math_multiplication',
      nom: 'Calcul Mental',
      titre: '',
      niveau: NiveauEducatif.primaire,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Calcul mental',
      colonneGauche: [
        '2 × 3',
        '4 × 5',
        '6 × 7',
        '3 × 8',
        '5 × 6',
        '7 × 4',
        '9 × 3',
        '8 × 2',
      ],
      colonneDroite: [
        '6',
        '20',
        '42',
        '24',
        '30',
        '28',
        '27',
        '16',
      ],
    ),

    // === PRÉPA ECG ===
    QuestionnairePreset(
      id: 'prepa_math_combinatoire',
      nom: 'Analyse combinatoire',
      titre: 'FORMULES - ANALYSE COMBINATOIRE',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.mathematiques,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Dénombrement',
      colonneGauche: [
        'Arrangements p parmi n',
        'Combinaisons \\binom{n}{p}',
        'Permutations de n',
        'Applications E→F',
        'Surjections E→F',
        'Principe tiroirs',
        'Inclusion-exclusion',
        'Dérangements Dₙ',
      ],
      colonneDroite: [
        'A_n^p = n!/(n-p)!',
        '\\binom{n}{p} = n!/[p!(n-p)!]',
        'n!',
        '|F|^n',
        'p! × S(n,p)',
        '⌈n/k⌉ ≥ 1',
        '|A∪B| = |A|+|B|-|A∩B|',
        '≈ n!/e',
      ],
    ),

    QuestionnairePreset(
      id: 'prepa_eco_concepts',
      nom: 'Concepts économiques',
      titre: 'ÉCONOMIE GÉNÉRALE - PRÉPA ECG',
      niveau: NiveauEducatif.prepa,
      categorie: CategorieMatiere.economie,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Macroéconomie',
      colonneGauche: [
        'PIB',
        'Inflation',
        'Chômage structurel',
        'Politique monétaire',
        'Déficit budgétaire',
        'Balance commerciale',
        'Taux de change',
        'Productivité',
      ],
      colonneDroite: [
        'Produit Intérieur Brut',
        'Hausse générale des prix',
        'Inadéquation offre/demande',
        'Contrôle masse monétaire',
        'Dépenses > Recettes État',
        'Exportations - Importations',
        'Prix d\'une monnaie',
        'Production/Facteur travail',
      ],
    ),

    // === COLLÈGE ===
    QuestionnairePreset(
      id: 'college_francais_conjugaison',
      nom: 'Conjugaison',
      titre: 'PASSÉ COMPOSÉ - COLLÈGE',
      niveau: NiveauEducatif.college,
      categorie: CategorieMatiere.francais,
      typeDeJeu: TypeDeJeu.correspondanceVisAVis,
      sousTheme: 'Temps composés',
      colonneGauche: [
        'Je (finir)',
        'Tu (venir)',
        'Il (prendre)',
        'Nous (aller)',
        'Vous (faire)',
        'Elles (partir)',
        'On (voir)',
        'Je (être)',
      ],
      colonneDroite: [
        'J\'ai fini',
        'Tu es venu(e)',
        'Il a pris',
        'Nous sommes allé(e)s',
        'Vous avez fait',
        'Elles sont parties',
        'On a vu',
        'J\'ai été',
      ],
    ),

    // === EXEMPLE FUTUR : ORDRE CHRONOLOGIQUE ===
    QuestionnairePreset(
      id: 'college_histoire_chronologie',
      nom: 'Chronologie médiévale',
      titre: 'ORDRE CHRONOLOGIQUE - MOYEN ÂGE',
      niveau: NiveauEducatif.college,
      categorie: CategorieMatiere.histoire,
      typeDeJeu: TypeDeJeu.ordreChronologique,
      sousTheme: 'Événements médiévaux',
      colonneGauche: [
        'Bataille de Hastings',
        'Prise de Constantinople',
        'Guerre de Cent Ans début',
        'Première croisade',
        'Couronnement Charlemagne',
        'Chute Empire romain',
        'Peste noire en Europe',
        'Découverte Amérique',
      ],
      colonneDroite: [
        '1066',
        '1453',
        '1337',
        '1096',
        '800',
        '476',
        '1347',
        '1492',
      ],
    ),
  ];

  /// Liste de tous les questionnaires disponibles (format moderne)
  /// Inclut automatiquement un puzzle de combinaisons généré aléatoirement
  static List<QuestionnairePreset> getAllQuestionnaires(
      {bool includeCombinations = true}) {
    final allQuestionnaires = List<QuestionnairePreset>.from(questionnaires);

    // Ajouter le puzzle de combinaisons généré aléatoirement
    if (includeCombinations) {
      allQuestionnaires.add(generateCombinationsPuzzle());
    }

    return allQuestionnaires;
  }

  /// Liste de tous les presets disponibles (ancien format)
  static List<EducationalPreset> getAllPresets() {
    final presets = <EducationalPreset>[];

    // Convertir les nouveaux questionnaires
    for (final questionnaire in questionnaires) {
      presets.add(questionnaire.toEducationalPreset());
    }

    // Tables de multiplication (2 à 9) - ancien format
    for (int i = 2; i <= 9; i++) {
      presets.add(generateMultiplicationTable(i));
    }

    // Vocabulaire - ancien format
    presets.addAll([
      vocabularyAnimals,
      vocabularyColors,
      geographyEurope,
    ]);

    return presets;
  }

  /// Détermine les couleurs de fond selon le type de preset
  static (Color?, Color?) _getColorsForPreset(String presetId) {
    // Nouveaux questionnaires structurés
    if (presetId.startsWith('primaire_')) {
      return (Colors.green[100], Colors.lightGreen[100]); // Vert doux primaire
    } else if (presetId.startsWith('college_')) {
      return (Colors.blue[100], Colors.lightBlue[100]); // Bleu collège
    } else if (presetId.startsWith('lycee_')) {
      return (Colors.orange[100], Colors.deepOrange[100]); // Orange lycée
    } else if (presetId.startsWith('prepa_')) {
      return (Colors.purple[100], Colors.deepPurple[100]); // Violet prépa
    } else if (presetId.startsWith('superieur_')) {
      return (Colors.red[100], Colors.pink[100]); // Rouge supérieur
    }

    // Anciens formats
    else if (presetId.startsWith('multiplication_')) {
      // Tables de multiplication : Bleu clair / Vert clair
      return (Colors.blue[50], Colors.green[50]);
    } else if (presetId.startsWith('vocab_')) {
      // Vocabulaire : Rose clair / Orange clair
      return (Colors.pink[50], Colors.orange[50]);
    } else if (presetId.startsWith('geo_')) {
      // Géographie : Violet clair / Jaune clair
      return (Colors.purple[50], Colors.yellow[50]);
    } else {
      // Par défaut : Gris très clair / Bleu très clair
      return (Colors.grey[50], Colors.blue[50]);
    }
  }

  /// Génère une image à partir d'un preset avec logique éducative
  ///
  /// Pour les puzzles éducatifs :
  /// 1. Mélange d'abord la liste 1 (colonne gauche)
  /// 2. Applique le même mélange à la liste 2 (colonne droite)
  /// 3. Génère l'image avec ces listes mélangées
  /// Cela garantit la correspondance éducative pour la vérification
  static Future<EducationalImageResult> generateFromPreset(
    EducationalPreset preset, {
    double cellWidth = 600,
    double cellHeight = 200,
    bool applyEducationalShuffle = true, // Nouveau paramètre
  }) async {
    final (leftColor, rightColor) = _getColorsForPreset(preset.id);

    List<String> leftColumn = preset.leftColumn;
    List<String> rightColumn = preset.rightColumn;
    List<int>? shuffleMapping;

    // Appliquer le mélange éducatif si demandé
    if (applyEducationalShuffle) {
      final result = _applyEducationalShuffle(leftColumn, rightColumn);
      leftColumn = result.shuffledLeft;
      rightColumn = result.shuffledRight;
      shuffleMapping = result.mapping;
    }

    final imageResult = await generateNamesGridImage(
      left: leftColumn,
      right: rightColumn,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      leftColumnColor: leftColor,
      rightColumnColor: rightColor,
      description: preset.description,
    );

    // Retourner le résultat avec les informations de mélange
    return EducationalImageResult(
      pngBytes: imageResult.pngBytes,
      rows: imageResult.rows,
      columns: imageResult.columns,
      description: imageResult.description,
      originalMapping: shuffleMapping, // Nouveau champ
    );
  }

  /// Version pour QuestionnairePreset avec support largeurs dynamiques
  static Future<EducationalImageResult> generateFromQuestionnairePreset(
    QuestionnairePreset questionnaire, {
    double cellWidth = 600,
    double cellHeight = 200,
    bool applyEducationalShuffle = true,
  }) async {
    final (leftColor, rightColor) = _getColorsForPreset(questionnaire.id);

    List<String> leftColumn = questionnaire.colonneGauche;
    List<String> rightColumn = questionnaire.colonneDroite;
    List<int>? shuffleMapping;

    // Appliquer le mélange éducatif si demandé
    if (applyEducationalShuffle) {
      final result = _applyEducationalShuffle(leftColumn, rightColumn);
      leftColumn = result.shuffledLeft;
      rightColumn = result.shuffledRight;
      shuffleMapping = result.mapping;
    }

    final imageResult = await generateNamesGridImage(
      left: leftColumn,
      right: rightColumn,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      leftColumnColor: leftColor,
      rightColumnColor: rightColor,
      description: questionnaire.description ?? questionnaire.titre,
      ratioLargeurColonnes: questionnaire.ratioLargeurColonnes, // ← NOUVEAU
    );

    return EducationalImageResult(
      pngBytes: imageResult.pngBytes,
      rows: imageResult.rows,
      columns: imageResult.columns,
      description: imageResult.description,
      originalMapping: shuffleMapping,
    );
  }

  /// Résultat du mélange éducatif
  static EducationalShuffleResult _applyEducationalShuffle(
    List<String> originalLeft,
    List<String> originalRight,
  ) {
    final length = originalLeft.length;

    // 1. Créer une liste des indices et la mélanger
    final indices = List<int>.generate(length, (index) => index);
    indices.shuffle(); // Mélange aléatoire

    // 2. Appliquer ce mélange aux deux listes
    final shuffledLeft = <String>[];
    final shuffledRight = <String>[];

    for (int i = 0; i < length; i++) {
      final originalIndex = indices[i];
      shuffledLeft.add(originalLeft[originalIndex]);
      shuffledRight.add(originalRight[originalIndex]);
    }

    return EducationalShuffleResult(
      shuffledLeft: shuffledLeft,
      shuffledRight: shuffledRight,
      mapping: indices, // Stocke le mapping pour la vérification
    );
  }
}

/// Widget pour afficher les coefficients binomiaux avec la notation moderne
/// Utilise flutter_math_fork pour le rendu LaTeX
/// Note: Cette fonction nécessite l'import de 'package:flutter_math_fork/flutter_math.dart'
/* 
Widget binomWidget(int n, int k) {
  return Math.tex(
    r'\binom{' '$n' '}{' '$k' '}',
    textStyle: const TextStyle(fontSize: 32),
  );
}
*/
