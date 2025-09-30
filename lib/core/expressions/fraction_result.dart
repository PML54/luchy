/// <cursor>
///
/// fraction_result.dart
/// core/expressions/
///
/// Classe pour représenter les résultats de fractions sous forme exacte.
/// Gère la simplification automatique et la conversion entier/fraction.
///
/// COMPOSANTS PRINCIPAUX:
/// - FractionResult: Classe principale pour fractions exactes
/// - Simplification automatique via PGCD
/// - Conversion automatique vers entier si dénominateur = 1
/// - Affichage LaTeX correct
///
/// ÉTAT ACTUEL:
/// - Implémentation de base des fractions
/// - Simplification automatique
/// - Conversion entier/fraction
/// - Support LaTeX
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-31: Création pour système d'expressions circonstanciées
/// - Implémentation selon spécifications fraction exacte
///
/// 🔧 POINTS D'ATTENTION:
/// - Jamais de valeurs décimales approchées
/// - Toujours simplifier les fractions
/// - Gérer le cas dénominateur = 1 → entier
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Tester avec différents cas
/// - Intégrer avec le système d'expressions
/// - Ajouter support fractions négatives
///
/// 🔗 FICHIERS LIÉS:
/// - expression_calculator.dart
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Base du calcul exact)
/// 📅 Dernière modification: 2025-01-31
/// </cursor>

/// Classe pour représenter une fraction sous forme exacte
class FractionResult {
  final int numerateur;
  final int denominateur;

  /// Constructeur avec simplification automatique
  FractionResult(int num, int den)
      : assert(den != 0, 'Le dénominateur ne peut pas être zéro'),
        numerateur = _simplifierNumerateur(num, den),
        denominateur = _simplifierDenominateur(num, den);

  /// Constructeur pour entier (dénominateur = 1)
  FractionResult.entier(int valeur)
      : numerateur = valeur,
        denominateur = 1;

  /// Simplifie le numérateur après calcul du PGCD
  static int _simplifierNumerateur(int num, int den) {
    final pgcd = _pgcd(num.abs(), den.abs());
    final signe = (num < 0) ^ (den < 0) ? -1 : 1;
    return (num.abs() ~/ pgcd) * signe;
  }

  /// Simplifie le dénominateur après calcul du PGCD
  static int _simplifierDenominateur(int num, int den) {
    final pgcd = _pgcd(num.abs(), den.abs());
    return den.abs() ~/ pgcd;
  }

  /// Calcule le PGCD de deux nombres
  static int _pgcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Vérifie si c'est un entier (dénominateur = 1)
  bool get estEntier => denominateur == 1;

  /// Retourne la valeur entière si c'est un entier
  int? get valeurEntiere => estEntier ? numerateur : null;

  /// Addition de deux fractions
  FractionResult operator +(FractionResult autre) {
    final nouveauNum =
        numerateur * autre.denominateur + autre.numerateur * denominateur;
    final nouveauDen = denominateur * autre.denominateur;
    return FractionResult(nouveauNum, nouveauDen);
  }

  /// Soustraction de deux fractions
  FractionResult operator -(FractionResult autre) {
    final nouveauNum =
        numerateur * autre.denominateur - autre.numerateur * denominateur;
    final nouveauDen = denominateur * autre.denominateur;
    return FractionResult(nouveauNum, nouveauDen);
  }

  /// Multiplication de deux fractions
  FractionResult operator *(FractionResult autre) {
    return FractionResult(
      numerateur * autre.numerateur,
      denominateur * autre.denominateur,
    );
  }

  /// Division de deux fractions
  FractionResult operator /(FractionResult autre) {
    return FractionResult(
      numerateur * autre.denominateur,
      denominateur * autre.numerateur,
    );
  }

  /// Représentation LaTeX de la fraction
  String toLatex() {
    if (estEntier) {
      return numerateur.toString();
    }

    if (numerateur < 0) {
      return '-\\frac{${(-numerateur)}}{$denominateur}';
    }

    return '\\frac{$numerateur}{$denominateur}';
  }

  /// Représentation textuelle simple
  @override
  String toString() {
    if (estEntier) {
      return numerateur.toString();
    }
    return '$numerateur/$denominateur';
  }

  /// Égalité entre fractions
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FractionResult) return false;
    return numerateur == other.numerateur && denominateur == other.denominateur;
  }

  @override
  int get hashCode => numerateur.hashCode ^ denominateur.hashCode;

  /// Convertit en valeur décimale (pour debug uniquement, pas pour affichage)
  double toDouble() => numerateur / denominateur;
}

/// Résultat d'une expression circonstanciée
abstract class ExpressionResult {
  /// Représentation LaTeX du résultat
  String toLatex();

  /// Représentation textuelle
  @override
  String toString();
}

/// Résultat sous forme de fraction
class FractionExpressionResult extends ExpressionResult {
  final FractionResult fraction;

  FractionExpressionResult(this.fraction);

  @override
  String toLatex() => fraction.toLatex();

  @override
  String toString() => fraction.toString();
}

/// Résultat sous forme d'entier
class IntegerExpressionResult extends ExpressionResult {
  final int valeur;

  IntegerExpressionResult(this.valeur);

  @override
  String toLatex() => valeur.toString();

  @override
  String toString() => valeur.toString();
}
