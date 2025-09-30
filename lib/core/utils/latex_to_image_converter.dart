/// <cursor>
/// LUCHY - Convertisseur LaTeX vers Image
///
/// Utilitaire pour convertir du code LaTeX en images PNG
/// utilisables dans les puzzles éducatifs générés.
///
/// COMPOSANTS PRINCIPAUX:
/// - LatexToImageConverter: Classe principale de conversion
/// - renderLatexToImage(): Conversion LaTeX → PNG bytes
/// - _createLatexWidget(): Création widget Math.tex
/// - _captureWidgetAsImage(): Capture widget → image
///
/// ÉTAT ACTUEL:
/// - Rendu: flutter_math_fork pour LaTeX natif
/// - Export: PNG bytes pour intégration puzzle
/// - Qualité: Haute résolution pour lisibilité
/// - Performance: Cache possible pour optimisation
///
/// HISTORIQUE RÉCENT:
/// - Création pour résoudre affichage LaTeX brut
/// - Intégration avec système puzzles éducatifs
/// - Support formules binôme de Newton
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance flutter_math_fork requise
/// - Taille image adaptée à la cellule puzzle
/// - Gestion erreurs LaTeX malformé
/// - Performance pour multiples conversions
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Cache des images générées
/// - Support autres types LaTeX
/// - Optimisation taille/qualité
///
/// 🔗 FICHIERS LIÉS:
/// - core/utils/educational_image_generator.dart: Utilisation
/// - features/puzzle/presentation/screens/binome_formules_screen.dart: Référence
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Rendu mathématique essentiel)
/// 📅 Dernière modification: 2025-01-30 18:45
/// </cursor>

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Convertisseur LaTeX vers image PNG
class LatexToImageConverter {
  /// Convertit du code LaTeX en image PNG
  ///
  /// [latexCode] - Code LaTeX à convertir (ex: r'\binom{n}{k}')
  /// [fontSize] - Taille de police pour le rendu (défaut: 20)
  /// [textColor] - Couleur du texte (défaut: noir)
  /// [backgroundColor] - Couleur de fond (défaut: transparent)
  /// [padding] - Espacement autour du contenu (défaut: 8)
  ///
  /// Retourne les bytes PNG de l'image générée
  static Future<Uint8List> renderLatexToImage(
    String latexCode, {
    double fontSize = 20,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.transparent,
    double padding = 8,
  }) async {
    try {
      // Créer le widget Math.tex
      final mathWidget = _createLatexWidget(
        latexCode,
        fontSize: fontSize,
        textColor: textColor,
      );

      // Capturer le widget comme image
      final imageBytes = await _captureWidgetAsImage(
        mathWidget,
        backgroundColor: backgroundColor,
        padding: padding,
      );

      return imageBytes;
    } catch (e) {
      // En cas d'erreur LaTeX, créer une image avec le texte brut
      return _createFallbackImage(
        latexCode,
        fontSize: fontSize,
        textColor: textColor,
        backgroundColor: backgroundColor,
        padding: padding,
      );
    }
  }

  /// Crée le widget Math.tex pour le rendu LaTeX
  static Widget _createLatexWidget(
    String latexCode, {
    required double fontSize,
    required Color textColor,
  }) {
    return Math.tex(
      latexCode,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
    );
  }

  /// Capture un widget Flutter comme image PNG
  static Future<Uint8List> _captureWidgetAsImage(
    Widget widget, {
    required Color backgroundColor,
    required double padding,
  }) async {
    // Créer une clé globale pour le RepaintBoundary
    final GlobalKey repaintBoundaryKey = GlobalKey();

    // Préparer le widget avec RepaintBoundary pour capture
    // Note: Cette fonction nécessite un contexte de rendu Flutter pour fonctionner
    RepaintBoundary(
      key: repaintBoundaryKey,
      child: Container(
        padding: EdgeInsets.all(padding),
        color: backgroundColor,
        child: widget,
      ),
    );

    // Obtenir les dimensions du widget
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject();
    if (renderObject == null) {
      throw Exception('Impossible d\'obtenir le RenderObject pour la conversion LaTeX');
    }
    final RenderRepaintBoundary boundary = renderObject as RenderRepaintBoundary;

    // Capturer l'image
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Impossible de convertir l\'image en données binaires');
    }

    return byteData.buffer.asUint8List();
  }

  /// Crée une image de fallback avec du texte simple en cas d'erreur LaTeX
  static Future<Uint8List> _createFallbackImage(
    String text, {
    required double fontSize,
    required Color textColor,
    required Color backgroundColor,
    required double padding,
  }) async {
    final fallbackWidget = Container(
      padding: EdgeInsets.all(padding),
      color: backgroundColor,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: 'monospace',
        ),
      ),
    );

    return _captureWidgetAsImage(
      fallbackWidget,
      backgroundColor: backgroundColor,
      padding: 0, // Déjà inclus dans le Container
    );
  }

  /// Convertit une liste de codes LaTeX en images
  /// Utile pour traiter plusieurs formules d'un coup
  static Future<List<Uint8List>> renderLatexListToImages(
    List<String> latexCodes, {
    double fontSize = 20,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.transparent,
    double padding = 8,
  }) async {
    final List<Uint8List> images = [];

    for (final latexCode in latexCodes) {
      final imageBytes = await renderLatexToImage(
        latexCode,
        fontSize: fontSize,
        textColor: textColor,
        backgroundColor: backgroundColor,
        padding: padding,
      );
      images.add(imageBytes);
    }

    return images;
  }
}
