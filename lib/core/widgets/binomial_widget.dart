/// <curseur>
/// LUCHY - Widget pour coefficients binomiaux
///
/// Widget spécialisé pour l'affichage des coefficients binomiaux
/// en notation mathématique moderne avec flutter_math_fork.
///
/// COMPOSANTS PRINCIPAUX:
/// - binomWidget(): Widget LaTeX pour affichage coefficients binomiaux
/// - Support notation moderne (n p) avec parenthèses
/// - Integration flutter_math_fork pour rendu mathématique
///
/// ÉTAT ACTUEL:
/// - Rendu: LaTeX avec flutter_math_fork
/// - Notation: Moderne (n p) selon préférences utilisateur
/// - Style: Taille et couleur configurables
/// - Performance: Optimisé pour affichage puzzle
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création pour puzzle combinaisons
/// - Adaptation fonction fournie par l'utilisateur
/// - Intégration système puzzle éducatif type 3
/// - Support notation LaTeX moderne préférée
///
/// 🔧 POINTS D'ATTENTION:
/// - Dépendance: Requiert flutter_math_fork package
/// - Performance: Peut être lourd pour grandes grilles
/// - Rendu: Vérifier compatibilité versions Flutter
/// - Notation: Respecter préférences utilisateur LaTeX
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter configurations avancées (couleurs, tailles)
/// - Intégrer animations pour transitions
/// - Optimiser performances pour grilles grandes
/// - Ajouter support autres notations mathématiques
///
/// 🔗 FICHIERS LIÉS:
/// - core/utils/educational_image_generator.dart: Génération puzzles
/// - features/puzzle/presentation/widgets/board/puzzle_board.dart: Affichage
/// - pubspec.yaml: Configuration dépendances
///
/// CRITICALITÉ: ⭐⭐⭐ (Widget spécialisé mathématiques)
/// </curseur>

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Widget pour afficher les coefficients binomiaux avec la notation moderne
/// Utilise flutter_math_fork pour le rendu LaTeX optimal
///
/// Notation utilisée: \binom{n}{k} qui produit la notation moderne (n k)
/// avec n au-dessus de k dans des parenthèses, conforme aux préférences
/// utilisateur pour les coefficients binomiaux.
///
/// Exemple d'utilisation:
/// ```dart
/// binomWidget(5, 2) // Affiche (5 2) = 10
/// ```
Widget binomWidget(
  int n,
  int k, {
  double fontSize = 32,
  Color? textColor,
  String? fontFamily,
}) {
  return Math.tex(
    r'\binom{' '$n' '}{' '$k' '}',
    textStyle: TextStyle(
      fontSize: fontSize,
      color: textColor ?? Colors.black,
      fontFamily: fontFamily,
    ),
  );
}

/// Widget alternatif pour affichage simple sans LaTeX
/// Fallback si flutter_math_fork pose problème
Widget simpleBinomWidget(
  int n,
  int k, {
  double fontSize = 24,
  Color? textColor,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '($n',
        style: TextStyle(
          fontSize: fontSize,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        ' $k)',
        style: TextStyle(
          fontSize: fontSize * 0.8,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

/// Calcule la valeur du coefficient binomial C(n,k)
/// Utilisé pour vérification ou affichage du résultat
int calculateBinomial(int n, int k) {
  if (k > n || k < 0) return 0;
  if (k == 0 || k == n) return 1;

  // Optimisation: C(n,k) = C(n,n-k)
  if (k > n - k) k = n - k;

  int result = 1;
  for (int i = 0; i < k; i++) {
    result = result * (n - i) ~/ (i + 1);
  }
  return result;
}
