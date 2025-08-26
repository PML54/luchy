/// <cursor>
/// LUCHY - Générateur d'images éducatives
///
/// Utilitaire pour créer des images de puzzle éducatives avec
/// 2 colonnes (questions/réponses, français/anglais, etc.).
///
/// COMPOSANTS PRINCIPAUX:
/// - generateNamesGridImage(): Génération image grille 2 colonnes
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
/// - 2025-08-25: Création initiale avec code utilisateur
/// - Implémentation presets éducatifs
/// - Intégration dans flux image controller
/// - Support grilles adaptatives
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
/// CRITICALITÉ: ⭐⭐⭐ (Fonctionnalité éducative)
/// 📅 Dernière modification: 2025-08-25 15:10
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

/// Preset éducatif
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
    double cellWidth = 600, // largeur d'une cellule (colonne)
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
  }) async {
    assert(left.length == right.length,
        "Les deux listes doivent avoir la même longueur.");
    final n = left.length;

    final double width = cellWidth * 2;
    final double height = cellHeight * n;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

    // Fond général
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    // Fonds colorés par colonne
    if (leftColumnColor != null) {
      final leftColumnPaint = Paint()..color = leftColumnColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, cellWidth, height), leftColumnPaint);
    }

    if (rightColumnColor != null) {
      final rightColumnPaint = Paint()..color = rightColumnColor;
      canvas.drawRect(
          Rect.fromLTWH(cellWidth, 0, cellWidth, height), rightColumnPaint);
    }

    // Grille
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = gridStrokeWidth;
    // Contour extérieur
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), gridPaint);
    // Ligne verticale centrale
    canvas.drawLine(Offset(cellWidth, 0), Offset(cellWidth, height), gridPaint);
    // Lignes horizontales
    for (int i = 1; i < n; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Fonction d'écriture centrée avec auto-fit
    Future<void> drawCenteredTextInCell({
      required String text,
      required Rect cell,
    }) async {
      double fontSize = initialFontSize;
      TextPainter painter;
      // Essaie de réduire la taille tant que ça dépasse
      while (true) {
        final textSpan = TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontFamily: fontFamily,
          ),
        );
        painter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 1,
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

    // Remplir les cellules
    for (int i = 0; i < n; i++) {
      // Colonne gauche
      final leftCell = Rect.fromLTWH(
        0,
        i * cellHeight,
        cellWidth,
        cellHeight,
      );
      await drawCenteredTextInCell(text: left[i], cell: leftCell);

      // Colonne droite
      final rightCell = Rect.fromLTWH(
        cellWidth,
        i * cellHeight,
        cellWidth,
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

  /// Liste de tous les presets disponibles
  static List<EducationalPreset> getAllPresets() {
    final presets = <EducationalPreset>[];

    // Tables de multiplication (2 à 9)
    for (int i = 2; i <= 9; i++) {
      presets.add(generateMultiplicationTable(i));
    }

    // Vocabulaire
    presets.addAll([
      vocabularyAnimals,
      vocabularyColors,
      geographyEurope,
    ]);

    return presets;
  }

  /// Détermine les couleurs de fond selon le type de preset
  static (Color?, Color?) _getColorsForPreset(String presetId) {
    if (presetId.startsWith('multiplication_')) {
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
