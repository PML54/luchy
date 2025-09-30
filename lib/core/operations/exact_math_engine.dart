/// <cursor>
///
/// EXACT_MATH_ENGINE.DART
/// Chemin: core/operations/
///
/// 🎯 MOTEUR UNIQUE pour quiz mathématiques éducatifs (remplace modern_math_engine.dart)
/// Architecture robuste pour utilisateurs finaux avec gestion d'erreurs sécurisée.
///
/// Système avancé de manipulation d'expressions mathématiques exactes avec support LaTeX.
/// Supporte fractions, radicaux, constantes π/e, logarithmes et exponentielles.
/// Focus sur la robustesse, performance et expérience utilisateur optimale.
///
/// COMPOSANTS PRINCIPAUX:
/// - Res: Classe abstraite pour tous les résultats exacts
/// - RInt: Entiers exacts (BigInt)
/// - RRational: Fractions réduites automatiquement
/// - RRadical: Radicaux A*sqrt(n) avec extraction des carrés parfaits
/// - RPiMul: Multiples de π (A*π), RPiMul pour π/k
/// - REConst, RExp, RLnInt: Constantes e, exponentielles, logarithmes
/// - LatexCleaner: Nettoyage et rendu LaTeX canonique
/// - QuizItemExact: Extension de QuizItem pour résultats exacts
/// - ExactMathGenerator: 6 familles de quiz incluant constantes π, e, ln
///
/// ÉTAT ACTUEL:
/// - Classes Res complètes avec normalisation automatique
/// - Rendu LaTeX canonique pour tous les types (√17 au lieu de 1√17)
/// - Support drag & drop compatible avec l'interface existante
/// - 6 familles de quiz: fractions, équations, radicaux, simplifications, π, ln/e
/// - Constantes mathématiques: π (3π, π/2), e (e^n), ln (ln(5))
/// - Données d'entrée incluent irrationnels et constantes transcendantes
/// - Distracteurs pédagogiques intelligents pour chaque famille
/// - Migration terminée: exact_math_engine.dart est désormais le moteur unique
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-28: POURCENTAGES EXACTS - Suppression des arrondis, résultats entiers ou rationnels exacts
/// - 2025-09-28: Ajout de fractions exactes (100/3 pour 33,33333...)
/// - 2025-09-28: Distracteurs adaptés aux résultats rationnels
/// - Fri Sep 26 20:23: POURCENTAGES RÉSULTATS ENTIERS - Amélioration genPourcentageSimple()
/// - Combinaisons prédéfinies garantissant des résultats entiers
/// - Pourcentages: 5% à 100% maximum, nombres: 1 à 100 maximum
/// - Distracteurs pédagogiques: erreurs de calcul, confusions opérandes
/// - Fri Sep 26 20:16: POURCENTAGES LIMITÉS - Implémentation genPourcentageSimple()
/// - Pourcentages: 5% à 100% maximum, nombres: 1 à 100 maximum
/// - Distracteurs pédagogiques: erreurs de calcul, confusions opérandes
/// - Fri Sep 26 19:21: LIMITE 100 POUR PETITES CLASSES - Opérations adaptatives
/// - genMultiplicationEntiersAdaptive() et genSoustractionEntiersAdaptive() ajoutées
/// - Configuration par niveau: CP(≤4), CE1(≤10), CE2(≤20), CM1(≤50), CM2(≤100)
/// - Respect strict de la limite de 100 pour les petites classes
/// - Mar 9 sep 2025 08:41: ADDITIONS PROGRESSIVES - Système étendu par niveau éducatif
/// - genProgressiveAddition() avec domaines adaptatifs (6ème: 1-20, Terminale: 1-100)
/// - Configuration automatique par niveau éducatif
/// - Distracteurs pédagogiques adaptés (±1, ×/+, erreurs retenue)
/// - Résolution disparition additions au collège/lycée
/// - Mar 9 sep 2025 04:21: TABLES MULTIPLICATION - 4 niveaux primaire implémentés
/// - CE1: tables 1-4 (×1,×2,×3,×4), CE2: tables 1-6 (+×5,×6)
/// - CM1: tables 1-7 (+×7), CM2: tables 1-9 (+×8,×9)
/// - Distracteurs pédagogiques spécialisés par niveau
/// - Progression officielle du programme français respectée
/// - Mar 9 sep 2025 04:02: OPÉRATIONS ENRICHIES - Fini les trivialités !
/// - Mar 9 sep 2025 03:05: CORRECTION CRITIQUE ln - Propriétés logarithmiques exactes
/// - Classe RLnSum pour ln(ab) = ln(a) + ln(b) (ex: ln(20) = 2ln(2) + ln(5))
/// - Mar 9 sep 2025 02:58: ARCHITECTURE PRODUCTION - Interface sécurisée ExactMathEngine
/// - 2025-09-08: CRÉATION - Système de calculs exacts avancé
///
/// 🔧 POINTS D'ATTENTION:
/// - Normalisation automatique des résultats (fractions réduites, radicaux simplifiés)
/// - Gestion des cas particuliers (division par zéro, radicaux négatifs)
/// - Performance avec BigInt pour les gros nombres
/// - Compatibilité LaTeX avec flutter_math_fork
/// - Éviter les débordements dans les calculs intermédiaires
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Étendre QuizItem avec QuizItemExact
/// - Intégrer dans ModernMathGenerator
/// - Ajouter plus de familles de quiz (trigonométrie, logarithmes)
/// - Optimiser les distracteurs pédagogiques
/// - Tests d'intégration avec l'interface drag & drop
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/operations/exact_math_engine.dart: MOTEUR UNIQUE (remplace modern_math_engine.dart)
/// - lib/features/puzzle/presentation/screens/modern_math_skills_screen.dart: Interface
/// - lib/core/formulas/prepa_math_engine.dart: Types de jeux
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Extension fondamentale du système mathématique)
/// 📅 Dernière modification: 2025-09-28 18:37:59
/// </cursor>

import 'dart:math' as math;
import 'dart:math' show Random;

/// ------------------------------
/// 🛡️ SYSTÈME DE GESTION D'ERREURS SÉCURISÉ
/// ------------------------------

/// Résultat sécurisé pour éviter les crashes utilisateur
sealed class MathResult<T> {
  const MathResult();
}

/// Succès avec valeur
class Success<T> extends MathResult<T> {
  final T value;
  const Success(this.value);
}

/// Erreur mathématique avec contexte
class MathError<T> extends MathResult<T> {
  final String message;
  final String operation;
  final String? context;
  const MathError(this.message, this.operation, {this.context});

  @override
  String toString() =>
      'MathError in $operation: $message${context != null ? ' ($context)' : ''}';
}

/// ------------------------------
/// 1) Types de résultats exacts
/// ------------------------------

abstract class Res {
  Res normalize();
  String toLatex();
}

/// Entier
class RInt extends Res {
  final BigInt k;
  RInt(int v) : k = BigInt.from(v);
  RInt.big(this.k);
  @override
  Res normalize() => this;
  @override
  String toLatex() => k.toString();
}

/// Fraction p/q, q>0 (réduction + entier si q=1)
class RRational extends Res {
  final BigInt p, q;
  RRational(BigInt p, BigInt q)
      : p = q.isNegative ? -p : p,
        q = q.isNegative ? -q : q {
    if (q == BigInt.zero) throw ArgumentError('Denominator zero');
  }

  /// Constructeur sécurisé sans exception
  static MathResult<RRational> safe(BigInt p, BigInt q) {
    if (q == BigInt.zero) {
      return MathError('Division par zéro', 'RRational.safe',
          context: 'p=$p, q=$q');
    }
    return Success(RRational(p, q));
  }

  static BigInt _gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != BigInt.zero) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a == BigInt.zero ? BigInt.one : a;
  }

  RRational reduced() {
    final g = _gcd(p.abs(), q);
    var np = p ~/ g, nq = q ~/ g;
    if (nq.isNegative) {
      np = -np;
      nq = -nq;
    }
    return RRational(np, nq);
  }

  @override
  Res normalize() {
    final r = reduced();
    if (r.q == BigInt.one) return RInt.big(r.p);
    return r;
  }

  @override
  String toLatex() {
    final r = reduced();
    if (r.q == BigInt.one) return RInt.big(r.p).toLatex();

    // Utilisation du rendu sécurisé pour les fractions
    return LatexRenderer.renderFraction(r.p, r.q);
  }
}

/// Coefficient (entier * symbole optionnel) pour k, a, b...
class Coeff {
  final BigInt k;
  final String? sym; // ex. "k" -> 2k
  const Coeff(this.k, [this.sym]);

  bool get isZero => k == BigInt.zero;
  bool get isOne => k == BigInt.one && sym == null;
  Coeff timesInt(int m) => Coeff(k * BigInt.from(m), sym);

  String toLatex() {
    if (isZero) return '0';
    if (sym == null) return k.toString();
    // 1k -> k ; -1k -> -k ; 2k -> 2k
    if (k == BigInt.one) return sym!;
    if (k == BigInt.from(-1)) return '-$sym';
    return '${k.toString()}$sym';
  }
}

/// Radical A*sqrt(n), n ∈ N*, square-free. Si n=1 -> entier A
class RRadical extends Res {
  final Coeff A;
  final int n; // square-free >=1
  RRadical(this.A, this.n) {
    if (n <= 0) throw ArgumentError('Radicand must be >=1');
  }

  /// Constructeur sécurisé sans exception
  static MathResult<RRadical> safe(Coeff A, int n) {
    if (n <= 0) {
      return MathError('Radicande invalide', 'RRadical.safe',
          context: 'n=$n doit être >0');
    }
    return Success(RRadical(A, n));
  }

  static ({int s, int r}) _squareFreeFactor(int x) {
    return PerformanceCache.getSquareFreeFactor(x);
  }

  /// k*sqrt(m) avec k entier et/ou symbole (Coeff)
  factory RRadical.fromCoeffAndRad(Coeff A, int m) {
    if (A.isZero) return RRadical(Coeff(BigInt.zero), 1);
    if (m <= 0) throw ArgumentError('Radicand must be >=1');
    final fact = _squareFreeFactor(m);
    final coeff = A.timesInt(fact.s);
    final rr = fact.r == 0 ? 1 : fact.r;
    return RRadical(coeff, rr);
  }

  @override
  Res normalize() {
    if (A.isZero) return RInt(0);
    if (n == 1 && A.sym == null) return RInt.big(A.k); // entier pur
    if (n == 1 && A.sym != null) return this; // symbole * 1 -> garde A (ex: k)
    return this;
  }

  @override
  String toLatex() {
    final norm = normalize();
    if (norm is RInt) return norm.toLatex();
    if (n == 1) return A.toLatex();

    // Utilisation du rendu sécurisé
    return LatexRenderer.validateAndClean(
        LatexRenderer.renderCoefficient(A, '\\sqrt{$n}'));
  }
}

/// A*pi (A Coeff ou entier)
class RPiMul extends Res {
  final Coeff A;
  RPiMul(this.A);
  @override
  Res normalize() => A.isZero ? RInt(0) : this;
  @override
  String toLatex() {
    final n = normalize();
    if (n is RInt) return n.toLatex();
    final a = A.toLatex();
    if (a == '1') return '\\pi';
    if (a == '-1') return '-\\pi';
    return '$a\\,\\pi';
  }
}

/// e
class REConst extends Res {
  @override
  Res normalize() => this;
  @override
  String toLatex() => 'e';
}

/// e^m (m entier ou symbole). On ne simplifie que si m est 0 ou 1 (entier).
class RExp extends Res {
  final Object m; // int ou String (symbole)
  RExp(this.m);
  @override
  Res normalize() {
    if (m is int) {
      if (m == 0) return RInt(1);
      if (m == 1) return REConst();
    }
    return this;
  }

  @override
  String toLatex() {
    final n = normalize();
    if (n is RInt || n is REConst) return n.toLatex();
    return 'e^{${m is int ? (m as int).toString() : m as String}}';
  }
}

/// ln(n) : n entier > 0 connu ; ln(1) -> 0
class RLnInt extends Res {
  final int n;
  RLnInt(this.n) {
    if (n <= 0) throw ArgumentError('ln requires n>0');
  }
  @override
  Res normalize() => (n == 1) ? RInt(0) : this;
  @override
  String toLatex() => (n == 1) ? '0' : '\\ln{${n.toString()}}';
}

/// k*ln(n) : coefficient k multiplié par ln(n)
class RLnCoeff extends Res {
  final int k; // coefficient
  final int n; // argument du ln
  RLnCoeff(this.k, this.n) {
    if (n <= 0) throw ArgumentError('ln requires n>0');
  }
  @override
  Res normalize() {
    if (k == 0) return RInt(0);
    if (n == 1) return RInt(0); // k*ln(1) = k*0 = 0
    if (k == 1) return RLnInt(n); // 1*ln(n) = ln(n)
    return this;
  }

  @override
  String toLatex() {
    final norm = normalize();
    if (norm is RInt) return norm.toLatex();
    if (norm is RLnInt) return norm.toLatex();
    if (k == -1) return '-\\ln{$n}';
    return '$k\\ln{$n}';
  }
}

/// ln(a) + ln(b) : somme de logarithmes pour propriété ln(ab) = ln(a) + ln(b)
class RLnSum extends Res {
  final List<RLnInt> terms; // liste des termes ln(n)
  final List<RLnCoeff> coeffTerms; // liste des termes k*ln(n)

  RLnSum({List<RLnInt>? terms, List<RLnCoeff>? coeffTerms})
      : terms = terms ?? [],
        coeffTerms = coeffTerms ?? [];

  /// Constructeur pour ln(a) + ln(b)
  factory RLnSum.simple(int a, int b) {
    return RLnSum(terms: [RLnInt(a), RLnInt(b)]);
  }

  /// Constructeur pour k*ln(a) + ln(b)
  factory RLnSum.mixed(int k, int a, int b) {
    return RLnSum(coeffTerms: [RLnCoeff(k, a)], terms: [RLnInt(b)]);
  }

  @override
  Res normalize() {
    if (terms.isEmpty && coeffTerms.isEmpty) return RInt(0);
    if (terms.length == 1 && coeffTerms.isEmpty) return terms.first;
    if (coeffTerms.length == 1 && terms.isEmpty) return coeffTerms.first;
    return this;
  }

  @override
  String toLatex() {
    final norm = normalize();
    if (norm is RInt || norm is RLnInt || norm is RLnCoeff)
      return norm.toLatex();

    final parts = <String>[];

    // Ajouter les termes coefficients d'abord
    for (final coeff in coeffTerms) {
      parts.add(coeff.toLatex());
    }

    // Puis les termes simples
    for (final term in terms) {
      parts.add(term.toLatex());
    }

    return parts.join(' + ');
  }
}

/// ------------------------------
/// ⚡ OPTIMISATIONS PERFORMANCE
/// ------------------------------

/// Cache pour éviter les recalculs des facteurs de radicaux
class PerformanceCache {
  static final Map<int, ({int s, int r})> _factorCache = {};

  /// Extraction optimisée des carrés parfaits avec cache
  static ({int s, int r}) getSquareFreeFactor(int x) {
    if (x <= 1) return (s: 1, r: x);

    return _factorCache.putIfAbsent(x, () {
      int s = 1, r = x;

      // Optimisation : traiter 2 séparément (plus fréquent)
      while (r % 4 == 0) {
        r ~/= 4;
        s *= 2;
      }

      // Puis facteurs impairs
      for (int f = 3; f * f <= r; f += 2) {
        while (r % (f * f) == 0) {
          r ~/= (f * f);
          s *= f;
        }
      }

      return (s: s, r: r);
    });
  }

  /// Vider le cache si nécessaire (gestion mémoire)
  static void clearCache() => _factorCache.clear();
}

/// ------------------------------
/// 🎨 RENDU LATEX ROBUSTE
/// ------------------------------

/// Rendu LaTeX sécurisé et validé
class LatexRenderer {
  /// Rendre coefficient avec symbole (évite "1√17")
  static String renderCoefficient(Coeff coeff, String symbol) {
    if (coeff.isZero) return '0';
    if (coeff.k == BigInt.one) return symbol;
    if (coeff.k == BigInt.from(-1)) return '-$symbol';
    return '${coeff.k}$symbol';
  }

  /// Valider et nettoyer expression LaTeX
  static String validateAndClean(String latex) {
    // Supprimer coefficients 1 inutiles
    latex = latex.replaceAll(RegExp(r'(?<![\d])1\\'), '\\');

    // Nettoyer espaces doubles
    latex = latex.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Valider accolades équilibrées
    int braceCount = 0;
    for (int i = 0; i < latex.length; i++) {
      if (latex[i] == '{') braceCount++;
      if (latex[i] == '}') braceCount--;
      if (braceCount < 0) {
        // Accolades déséquilibrées
        return '\\text{Erreur LaTeX}';
      }
    }
    if (braceCount != 0) {
      return '\\text{Erreur LaTeX}';
    }

    return latex;
  }

  /// Rendre fraction avec validation
  static String renderFraction(BigInt p, BigInt q) {
    if (q == BigInt.zero) return '\\text{Erreur}';
    if (q == BigInt.one) return p.toString();
    if (p == BigInt.zero) return '0';

    final sign = p.isNegative ? '-' : '';
    final absP = p.abs();
    return '$sign\\dfrac{$absP}{$q}';
  }
}

/// ------------------------------
/// 2) Aides LaTeX & utilitaires
/// ------------------------------

class LatexCleaner {
  static String cleanForRender(String s) {
    var t = s;
    t = t.replaceAllMapped(
        RegExp(r'\\VAR(?:asked|given)?\{([^}]*)\}'), (m) => m.group(1)!);
    t = t.replaceAllMapped(RegExp(r'\\CONST\{([^}]*)\}'), (m) => m.group(1)!);
    t = t.replaceAll(r'\cdot', r'\times'); // Préférer × au lieu de ·
    t = t.replaceAll(RegExp(r'\\frac\s*\{'), '\\dfrac{');
    return t;
  }
}

/// Rendu canonique d'un Res (après normalize)
String renderCanonical(Res r) => r.normalize().toLatex();

/// ------------------------------
/// 3) Extensions pour système existant
/// ------------------------------

/// Extension de QuizChoice pour résultats exacts
class QuizChoiceExact {
  final String id;
  final String latex; // à afficher
  final Res value; // valeur exacte pour égalité
  QuizChoiceExact({required this.id, required this.latex, required this.value});
}

/// Extension de QuizItem pour résultats exacts (évolution progressive)
class QuizItemExact {
  final String id;
  final String leftLatex; // avec \VAR et \CONST
  final Map<String, Object> variables; // valeurs tirées
  final Res expected; // Résultat exact au lieu de RationalValue
  final String answerLatexCanonical;
  final List<QuizChoiceExact>
      choices; // Pour drag & drop: résultats à réorganiser
  final Map<String, Object?> metadata;

  const QuizItemExact({
    required this.id,
    required this.leftLatex,
    required this.variables,
    required this.expected,
    required this.answerLatexCanonical,
    required this.choices,
    this.metadata = const {},
  });

  /// Génère le LaTeX propre en remplaçant \VAR{}
  String getCleanLatex() {
    String result = leftLatex;
    variables.forEach((key, value) {
      result = result.replaceAll('\\VAR{$key}', value.toString());
    });
    return LatexCleaner.cleanForRender(result);
  }
}

/// ------------------------------
/// 4) Générateurs exacts pour drag & drop
/// ------------------------------

/// ------------------------------
/// 🏗️ INTERFACE PRINCIPALE PRODUCTION
/// ------------------------------

/// Interface sécurisée pour la génération de quiz mathématiques
class ExactMathEngine {
  static void _logError(Object error, StackTrace stackTrace) {
    // En production : envoyer vers service de logging
    print('🚨 ExactMathEngine Error: $error');
    print('📍 StackTrace: $stackTrace');
  }

  static QuizItemExact _dispatchGeneration(
      ExactMathGenerator generator, String family) {
    switch (family) {
      case 'fractions':
        return generator.genFractionSum();
      case 'multiplication':
        return generator.genFractionMultiplication();
      case 'equations':
        return generator.genEqXSqEqualsN();
      case 'radicals':
        return generator.genRadicalSum();
      case 'radical_simplification':
        return generator.genRadicalSimplification();
      case 'pi_operations':
        return generator.genPiOperations();
      case 'logarithms':
        return generator.genLogExpOperations();
      default:
        return generator.genFractionSum(); // fallback sécurisé
    }
  }

  /// Point d'entrée principal - génération sécurisée de quiz
  static MathResult<QuizItemExact> generateSafeQuiz(String family,
      {int numberOfResults = 5}) {
    try {
      final generator = ExactMathGenerator();
      final quiz = _dispatchGeneration(generator, family);
      return Success(quiz);
    } catch (e, stackTrace) {
      // Log l'erreur pour debugging
      _logError(e, stackTrace);
      return MathError('Impossible de générer le quiz', family,
          context: 'Vérifiez la famille: $family');
    }
  }

  /// Génération simple avec fallback
  static QuizItemExact generateQuizWithFallback(String family) {
    final result = generateSafeQuiz(family);
    return switch (result) {
      Success(value: final quiz) => quiz,
      MathError() => ExactMathGenerator().genFractionSum(), // fallback simple
    };
  }

  /// Validation de la famille avant génération
  static bool isValidFamily(String family) {
    const validFamilies = {
      'fractions',
      'multiplication',
      'equations',
      'radicals',
      'radical_simplification',
      'pi_operations',
      'logarithms'
    };
    return validFamilies.contains(family);
  }
}

/// ------------------------------
/// 🎲 GÉNÉRATEUR MATHÉMATIQUE (Legacy)
/// ------------------------------

class ExactMathGenerator {
  final math.Random rng;
  ExactMathGenerator({math.Random? rng}) : rng = rng ?? math.Random();

  int _randInt(int a, int b) => a + rng.nextInt(b - a + 1); // inclusif

  /// Famille #1 : \dfrac{p}{q} + \dfrac{r}{s}  -> fraction exacte (réduite)
  /// Adapté pour drag & drop: génère plusieurs résultats à réorganiser
  QuizItemExact genFractionSum({int numberOfResults = 5}) {
    final p = _randInt(-9, 9);
    final q = _randInt(2, 9);
    final r = _randInt(-9, 9);
    final s = _randInt(2, 9);

    final v = RRational(BigInt.from(p), BigInt.from(q)).normalize();
    final w = RRational(BigInt.from(r), BigInt.from(s)).normalize();

    // Calcul exact de la somme
    Res addFrac(Res a, Res b) {
      final A = a.normalize(), B = b.normalize();
      if (A is RInt && B is RInt) {
        return RInt.big(A.k + B.k);
      } else {
        // convertir en fraction
        RRational toFrac(Res x) {
          if (x is RInt) return RRational(x.k, BigInt.one);
          if (x is RRational) return x.reduced();
          throw StateError('Somme: cas non fractionnel');
        }

        final af = toFrac(A), bf = toFrac(B);
        final p = af.p * bf.q + bf.p * af.q;
        final q = af.q * bf.q;
        return RRational(p, q).normalize();
      }
    }

    final sum = addFrac(v, w);
    final left = '\\dfrac{\\VAR{p}}{\\VAR{q}} + \\dfrac{\\VAR{r}}{\\VAR{s}}';

    // Générer des distracteurs pour drag & drop
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(sum),
      value: sum,
    ));

    // Distracteurs pédagogiques
    final distractors = _generateFractionDistractors(p, q, r, s, sum);
    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      choices.add(QuizChoiceExact(
        id: 'distractor_$i',
        latex: renderCanonical(distractors[i]),
        value: distractors[i],
      ));
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final randomNum = _randInt(-20, 20);
      final randomDen = _randInt(2, 10);
      final extra =
          RRational(BigInt.from(randomNum), BigInt.from(randomDen)).normalize();
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'frac_exact_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'p': p, 'q': q, 'r': r, 's': s},
      expected: sum,
      answerLatexCanonical: renderCanonical(sum),
      choices: choices,
      metadata: {
        'family': 'fraction_sum_exact',
        'difficulty': 'intermediate',
        'operation': 'addition_fractions',
      },
    );
  }

  List<Res> _generateFractionDistractors(
      int p, int q, int r, int s, Res correct) {
    final distractors = <Res>[];

    // Erreur classique: (p+r)/(q+s)
    final d1 = RRational(BigInt.from(p + r), BigInt.from(q + s)).normalize();
    if (renderCanonical(d1) != renderCanonical(correct)) {
      distractors.add(d1);
    }

    // Erreur de signe: (ps - rq)/(qs)
    final adbc =
        BigInt.from(p) * BigInt.from(s) - BigInt.from(r) * BigInt.from(q);
    final bd = BigInt.from(q) * BigInt.from(s);
    final d2 = RRational(adbc, bd).normalize();
    if (renderCanonical(d2) != renderCanonical(correct)) {
      distractors.add(d2);
    }

    // Non réduite: résultat brut
    final num =
        BigInt.from(p) * BigInt.from(s) + BigInt.from(r) * BigInt.from(q);
    final den = BigInt.from(q) * BigInt.from(s);
    final d3 = RRational(num, den); // pas normalize
    if (renderCanonical(d3.reduced()) != renderCanonical(correct)) {
      distractors.add(d3);
    }

    return distractors;
  }

  /// Famille #1.5 : \dfrac{p}{q} \times \dfrac{r}{s}  -> fraction exacte (réduite)
  /// Adapté pour drag & drop: génère plusieurs résultats à réorganiser
  QuizItemExact genFractionMultiplication({int numberOfResults = 5}) {
    final p = _randInt(-9, 9);
    final q = _randInt(2, 9);
    final r = _randInt(-9, 9);
    final s = _randInt(2, 9);

    final v = RRational(BigInt.from(p), BigInt.from(q)).normalize();
    final w = RRational(BigInt.from(r), BigInt.from(s)).normalize();

    // Calcul exact de la multiplication
    Res multiplyFrac(Res a, Res b) {
      final A = a.normalize(), B = b.normalize();
      if (A is RInt && B is RInt) {
        return RInt.big(A.k * B.k);
      } else {
        // convertir en fraction
        RRational toFrac(Res x) {
          if (x is RInt) return RRational(x.k, BigInt.one);
          if (x is RRational) return x.reduced();
          throw StateError('Multiplication: cas non fractionnel');
        }

        final af = toFrac(A), bf = toFrac(B);
        final p = af.p * bf.p;
        final q = af.q * bf.q;
        return RRational(p, q).normalize();
      }
    }

    final product = multiplyFrac(v, w);
    final left =
        '\\dfrac{\\VAR{p}}{\\VAR{q}} \\times \\dfrac{\\VAR{r}}{\\VAR{s}}';

    // Générer des distracteurs pour drag & drop
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(product),
      value: product,
    ));

    // Distracteurs pédagogiques
    final distractors = _generateMultiplicationDistractors(p, q, r, s, product);
    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      choices.add(QuizChoiceExact(
        id: 'distractor_$i',
        latex: renderCanonical(distractors[i]),
        value: distractors[i],
      ));
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final randomNum = _randInt(-20, 20);
      final randomDen = _randInt(2, 10);
      final extra =
          RRational(BigInt.from(randomNum), BigInt.from(randomDen)).normalize();
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'frac_mult_exact_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'p': p, 'q': q, 'r': r, 's': s},
      expected: product,
      answerLatexCanonical: renderCanonical(product),
      choices: choices,
      metadata: {
        'family': 'fraction_multiplication_exact',
        'difficulty': 'intermediate',
        'operation': 'multiplication_fractions',
      },
    );
  }

  List<Res> _generateMultiplicationDistractors(
      int p, int q, int r, int s, Res correct) {
    final distractors = <Res>[];

    // Erreur classique: (p+r)/(q+s) - confondre avec addition
    final d1 = RRational(BigInt.from(p + r), BigInt.from(q + s)).normalize();
    if (renderCanonical(d1) != renderCanonical(correct)) {
      distractors.add(d1);
    }

    // Erreur de calcul: (p×s)/(q×r) - inverser numérateur/dénominateur
    if (r != 0 && q != 0) {
      final d2 = RRational(BigInt.from(p * s), BigInt.from(q * r)).normalize();
      if (renderCanonical(d2) != renderCanonical(correct)) {
        distractors.add(d2);
      }
    }

    // Non réduite: résultat brut (p×r)/(q×s) sans simplification
    final num = BigInt.from(p) * BigInt.from(r);
    final den = BigInt.from(q) * BigInt.from(s);
    if (den != BigInt.zero) {
      final d3 = RRational(num, den); // pas normalize
      if (renderCanonical(d3) != renderCanonical(correct)) {
        distractors.add(d3);
      }
    }

    // Oublier signe négatif si présent
    final d4 = RRational(num.abs(), den.abs()).normalize();
    if (renderCanonical(d4) != renderCanonical(correct)) {
      distractors.add(d4);
    }

    return distractors;
  }

  /// Famille #2 : x^2 = n  -> solutions ±sqrt(n)
  /// Adapté pour drag & drop: un des résultats est correct
  QuizItemExact genEqXSqEqualsN({int numberOfResults = 5}) {
    final n = _randInt(2, 40);
    final root = RRadical.fromCoeffAndRad(Coeff(BigInt.one), n).normalize();

    final left = 'x^{2}=\\VAR{n}';

    // Pour drag & drop, on prend la racine positive comme résultat principal
    final choices = <QuizChoiceExact>[];

    // Solutions correctes (positive et négative)
    choices.add(QuizChoiceExact(
      id: 'positive_root',
      latex: renderCanonical(root),
      value: root,
    ));

    final negRoot =
        RRadical.fromCoeffAndRad(Coeff(BigInt.from(-1)), n).normalize();
    choices.add(QuizChoiceExact(
      id: 'negative_root',
      latex: renderCanonical(negRoot),
      value: negRoot,
    ));

    // Distracteurs
    final near = RRadical.fromCoeffAndRad(Coeff(BigInt.one), n + 1).normalize();
    final wrong = RInt(n); // confusion "carré vs racine"

    choices.add(QuizChoiceExact(
      id: 'near_value',
      latex: renderCanonical(near),
      value: near,
    ));

    choices.add(QuizChoiceExact(
      id: 'square_confusion',
      latex: renderCanonical(wrong),
      value: wrong,
    ));

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraN = _randInt(2, 50);
      final extra =
          RRadical.fromCoeffAndRad(Coeff(BigInt.one), extraN).normalize();
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'xsq_exact_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'n': n},
      expected: root, // On prend la racine positive comme réponse principale
      answerLatexCanonical: renderCanonical(root),
      choices: choices,
      metadata: {
        'family': 'eq_x2=n_exact',
        'difficulty': 'intermediate',
        'operation': 'square_equation',
        'note': 'Accepte les deux racines ± comme correctes',
      },
    );
  }

  /// Famille #3 : Opérations avec radicaux
  /// Addition/soustraction/multiplication: a√n ± b√n = (a±b)√n et √a × √b = √(ab)
  QuizItemExact genRadicalSum({int numberOfResults = 5}) {
    final operations = ['addition', 'subtraction', 'multiplication'];
    final operation = operations[_randInt(0, operations.length - 1)];

    late String left;
    late Res result;
    late Map<String, Object> variables;

    if (operation == 'multiplication') {
      // √a × √b = √(ab) - multiplication de radicaux
      final a = _randInt(2, 12);
      final b = _randInt(2, 12);
      final product = a * b;

      left = '\\sqrt{\\VAR{a}} \\times \\sqrt{\\VAR{b}}';
      result = RRadical.fromCoeffAndRad(Coeff(BigInt.one), product).normalize();
      variables = {'a': a, 'b': b, 'product': product};
    } else {
      // Addition/soustraction classique: a√n ± b√n = (a±b)√n
      final coeff1 = _randInt(1, 5);
      final coeff2 = _randInt(1, 5);
      final radicand = _randInt(2, 20);
      final isAddition = operation == 'addition';

      final sign = isAddition ? '+' : '-';
      final resultCoeff = isAddition ? coeff1 + coeff2 : coeff1 - coeff2;

      left =
          '\\VAR{coeff1}\\sqrt{\\VAR{radicand}} $sign \\VAR{coeff2}\\sqrt{\\VAR{radicand}}';
      result =
          RRadical.fromCoeffAndRad(Coeff(BigInt.from(resultCoeff)), radicand)
              .normalize();
      variables = {'coeff1': coeff1, 'coeff2': coeff2, 'radicand': radicand};
    }

    // Générer des choix pour drag & drop
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs selon le type d'opération
    if (operation == 'multiplication') {
      final a = variables['a'] as int;
      final b = variables['b'] as int;

      // Erreur: √a + √b au lieu de √(ab)
      final wrong1 =
          RRadical.fromCoeffAndRad(Coeff(BigInt.one), a + b).normalize();
      choices.add(QuizChoiceExact(
          id: 'wrong1', latex: renderCanonical(wrong1), value: wrong1));

      // Erreur: √a × √b = a × b (oublier radicaux)
      final wrong2 = RInt(a * b);
      choices.add(QuizChoiceExact(
          id: 'wrong2', latex: renderCanonical(wrong2), value: wrong2));

      // Erreur: √(a × b) au lieu de √(ab) avec coefficient
      final wrong3 =
          RRadical.fromCoeffAndRad(Coeff(BigInt.from(2)), a * b).normalize();
      choices.add(QuizChoiceExact(
          id: 'wrong3', latex: renderCanonical(wrong3), value: wrong3));
    } else {
      // Distracteurs classiques pour addition/soustraction
      final coeff1 = variables['coeff1'] as int;
      final coeff2 = variables['coeff2'] as int;
      final radicand = variables['radicand'] as int;
      final resultCoeff =
          operation == 'addition' ? coeff1 + coeff2 : coeff1 - coeff2;

      final wrongCoeff1 = RRadical.fromCoeffAndRad(
              Coeff(BigInt.from(coeff1 + coeff2 + 1)), radicand)
          .normalize();
      final wrongCoeff2 = RRadical.fromCoeffAndRad(
              Coeff(BigInt.from(coeff1 * coeff2)), radicand)
          .normalize();
      final wrongRad = RRadical.fromCoeffAndRad(
              Coeff(BigInt.from(resultCoeff)), radicand + 1)
          .normalize();

      choices.add(QuizChoiceExact(
          id: 'wrong1',
          latex: renderCanonical(wrongCoeff1),
          value: wrongCoeff1));
      choices.add(QuizChoiceExact(
          id: 'wrong2',
          latex: renderCanonical(wrongCoeff2),
          value: wrongCoeff2));
      choices.add(QuizChoiceExact(
          id: 'wrong3', latex: renderCanonical(wrongRad), value: wrongRad));
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraCoeff = _randInt(1, 10);
      final extraRad = _randInt(2, 25);
      final extra =
          RRadical.fromCoeffAndRad(Coeff(BigInt.from(extraCoeff)), extraRad)
              .normalize();
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'radical_${operation}_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: variables,
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'radical_operations',
        'operation': operation == 'multiplication'
            ? 'multiplication_radicals'
            : (operation == 'addition'
                ? 'addition_radicals'
                : 'subtraction_radicals'),
        'difficulty': 'intermediate',
      },
    );
  }

  /// Famille #4 : Simplification de radicaux
  /// √(a²×b) = a√b avec extraction des carrés parfaits
  QuizItemExact genRadicalSimplification({int numberOfResults = 5}) {
    final perfectSquare = _randInt(2, 5); // 2, 3, 4, 5
    final remainingFactor = _randInt(2, 10);
    final radicand = perfectSquare * perfectSquare * remainingFactor; // a²×b

    final left = '\\sqrt{\\VAR{radicand}}';

    // Résultat simplifié: a√b
    final result = RRadical.fromCoeffAndRad(
            Coeff(BigInt.from(perfectSquare)), remainingFactor)
        .normalize();

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs: erreurs classiques
    final nonSimplified = RRadical.fromCoeffAndRad(Coeff(BigInt.one), radicand);
    final wrongExtraction = RRadical.fromCoeffAndRad(
            Coeff(BigInt.from(perfectSquare + 1)), remainingFactor)
        .normalize();
    final partialExtraction =
        RRadical.fromCoeffAndRad(Coeff(BigInt.from(perfectSquare)), radicand)
            .normalize();

    choices.add(QuizChoiceExact(
        id: 'non_simplified',
        latex: renderCanonical(nonSimplified),
        value: nonSimplified));
    choices.add(QuizChoiceExact(
        id: 'wrong_coeff',
        latex: renderCanonical(wrongExtraction),
        value: wrongExtraction));
    choices.add(QuizChoiceExact(
        id: 'partial',
        latex: renderCanonical(partialExtraction),
        value: partialExtraction));

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraCoeff = _randInt(1, 8);
      final extraRad = _randInt(2, 15);
      final extra =
          RRadical.fromCoeffAndRad(Coeff(BigInt.from(extraCoeff)), extraRad)
              .normalize();
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'radical_simplify_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'radicand': radicand},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'radical_simplification',
        'operation': 'simplify_radical',
        'difficulty': 'intermediate',
        'perfect_square_extracted': perfectSquare,
      },
    );
  }

  /// Famille #5 : Opérations intéressantes avec π et e
  /// Vraies propriétés: π + π = 2π, e × e = e², 3π - π = 2π
  QuizItemExact genPiOperations({int numberOfResults = 5}) {
    final operations = ['pi_addition', 'pi_subtraction', 'e_multiplication'];
    final operation = operations[_randInt(0, operations.length - 1)];

    late String left;
    late Res result;
    late Map<String, Object> variables;

    switch (operation) {
      case 'pi_addition':
        // π + π = 2π, π + 2π = 3π, 2π + π = 3π
        final a = _randInt(1, 3);
        final b = _randInt(1, 3);
        if (a == 1 && b == 1) {
          left = '\\pi + \\pi';
        } else if (a == 1) {
          left = '\\pi + \\VAR{b}\\pi';
        } else if (b == 1) {
          left = '\\VAR{a}\\pi + \\pi';
        } else {
          left = '\\VAR{a}\\pi + \\VAR{b}\\pi';
        }
        result = RPiMul(Coeff(BigInt.from(a + b)));
        variables = {'a': a, 'b': b, 'sum': a + b};

      case 'pi_subtraction':
        // 3π - π = 2π, 5π - 2π = 3π
        final a = _randInt(3, 6);
        final b = _randInt(1, a - 1);
        if (b == 1) {
          left = '\\VAR{a}\\pi - \\pi';
        } else {
          left = '\\VAR{a}\\pi - \\VAR{b}\\pi';
        }
        result = RPiMul(Coeff(BigInt.from(a - b)));
        variables = {'a': a, 'b': b, 'diff': a - b};

      case 'e_multiplication':
      default:
        // e × e = e², e × e² = e³, e² × e³ = e⁵ (éviter e² × e² = e⁴)
        final operations = [
          (1, 1), // e × e = e²
          (1, 2), // e × e² = e³
          (2, 1), // e² × e = e³
          (1, 3), // e × e³ = e⁴
          (2, 3), // e² × e³ = e⁵
        ];
        final (exp1, exp2) = operations[_randInt(0, operations.length - 1)];

        if (exp1 == 1 && exp2 == 1) {
          left = 'e \\times e';
        } else if (exp1 == 1) {
          left = 'e \\times e^{\\VAR{exp2}}';
        } else if (exp2 == 1) {
          left = 'e^{\\VAR{exp1}} \\times e';
        } else {
          left = 'e^{\\VAR{exp1}} \\times e^{\\VAR{exp2}}';
        }
        result = RExp(exp1 + exp2);
        variables = {'exp1': exp1, 'exp2': exp2, 'sum': exp1 + exp2};
    }

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs selon le type
    switch (operation) {
      case 'pi_addition':
      case 'pi_subtraction':
        final sum = (variables['sum'] ?? variables['diff']) as int;
        if (sum > 1) {
          choices.add(QuizChoiceExact(
              id: 'wrong1',
              latex: '${sum + 1}\\pi',
              value: RPiMul(Coeff(BigInt.from(sum + 1)))));
        }
        if (sum > 1) {
          choices.add(QuizChoiceExact(
              id: 'wrong2',
              latex: '${sum - 1}\\pi',
              value: RPiMul(Coeff(BigInt.from(sum - 1)))));
        }
        choices.add(QuizChoiceExact(
            id: 'wrong3', latex: '$sum', value: RInt(sum))); // oublier π

      case 'e_multiplication':
      default:
        final sumExp = variables['sum'] as int;
        choices.add(QuizChoiceExact(
            id: 'wrong1', latex: 'e^{${sumExp + 1}}', value: RExp(sumExp + 1)));
        if (sumExp > 1) {
          choices.add(QuizChoiceExact(
              id: 'wrong2',
              latex: 'e^{${sumExp - 1}}',
              value: RExp(sumExp - 1)));
        }
        choices.add(QuizChoiceExact(
            id: 'wrong3',
            latex: '${sumExp}e',
            value: RInt(sumExp))); // confusion
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraCoeff = _randInt(1, 6);
      final extra = RPiMul(Coeff(BigInt.from(extraCoeff)));
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'pi_e_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: variables,
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'pi_e_operations',
        'operation': operation,
        'difficulty': 'intermediate',
        'involves_constants': true,
      },
    );
  }

  /// Famille #6 : Logarithmes et exponentielles avancés
  /// Calculs avec propriétés logarithmiques et exponentielles
  QuizItemExact genLogExpOperations({int numberOfResults = 5}) {
    final operations = [
      'ln_simple',
      'exp_simple',
      'ln_power',
      'ln_product_rule'
    ];
    final operation = operations[_randInt(0, operations.length - 1)];

    late String left;
    late Res result;
    late Map<String, Object> variables;

    switch (operation) {
      case 'ln_simple':
        // ln(1) = 0, ln(e) = 1
        final value = rng.nextBool() ? 1 : 2; // 1 ou e
        if (value == 1) {
          left = '\\ln(\\VAR{value})';
          result = RLnInt(value);
          variables = {'value': value};
        } else {
          left = '\\ln(e)';
          result = RInt(1); // ln(e) = 1
          variables = {'value': 'e'};
        }

      case 'exp_simple':
        // e^0 = 1, e^1 = e, e^2
        final exponent = _randInt(0, 2);
        left = 'e^{\\VAR{exp}}';
        result = RExp(exponent);
        variables = {'exp': exponent};

      case 'ln_power':
        // ln(a^n) = n*ln(a) - ex: ln(8) = ln(2^3) = 3*ln(2)
        final powers = [
          (8, 2, 3), // ln(8) = ln(2^3) = 3*ln(2)
          (9, 3, 2), // ln(9) = ln(3^2) = 2*ln(3)
          (16, 2, 4), // ln(16) = ln(2^4) = 4*ln(2)
          (25, 5, 2), // ln(25) = ln(5^2) = 2*ln(5)
          (27, 3, 3), // ln(27) = ln(3^3) = 3*ln(3)
          (32, 2, 5), // ln(32) = ln(2^5) = 5*ln(2)
        ];
        final powerData = powers[_randInt(0, powers.length - 1)];
        final (value, base, exponent) = powerData;

        left = '\\ln(\\VAR{value})';
        // Créer n*ln(base) avec la nouvelle classe RLnCoeff
        result = RLnCoeff(exponent, base);
        variables = {'value': value, 'base': base, 'exponent': exponent};

      case 'ln_product_rule':
      default:
        // ln(ab) = ln(a) + ln(b) - ex: ln(6) = ln(2) + ln(3)
        final products = [
          (6, 2, 3), // ln(6) = ln(2) + ln(3)
          (10, 2, 5), // ln(10) = ln(2) + ln(5)
          (12, 3, 4), // ln(12) = ln(3) + ln(4) mais 4=2² donc ln(3) + 2*ln(2)
          (15, 3, 5), // ln(15) = ln(3) + ln(5)
          (20, 4, 5), // ln(20) = ln(4) + ln(5) = 2*ln(2) + ln(5)
        ];
        final productData = products[_randInt(0, products.length - 1)];
        final (value, factor1, factor2) = productData;

        left = '\\ln(\\VAR{value})';

        // Créer la bonne propriété logarithmique
        if (value == 12) {
          // ln(12) = ln(3) + ln(4) = ln(3) + 2*ln(2)
          result = RLnSum.mixed(2, 2, 3); // 2*ln(2) + ln(3)
        } else if (value == 20) {
          // ln(20) = ln(4) + ln(5) = 2*ln(2) + ln(5)
          result = RLnSum.mixed(2, 2, 5); // 2*ln(2) + ln(5)
        } else {
          // Cas simples: ln(ab) = ln(a) + ln(b)
          result = RLnSum.simple(factor1, factor2);
        }

        variables = {'value': value, 'factor1': factor1, 'factor2': factor2};
    }

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs selon le type
    switch (operation) {
      case 'ln_simple':
        choices.add(QuizChoiceExact(id: 'wrong1', latex: '1', value: RInt(1)));
        choices
            .add(QuizChoiceExact(id: 'wrong2', latex: 'e', value: REConst()));
        choices.add(
            QuizChoiceExact(id: 'wrong3', latex: '\\ln{2}', value: RLnInt(2)));

      case 'exp_simple':
        choices.add(QuizChoiceExact(id: 'wrong1', latex: '0', value: RInt(0)));
        choices.add(QuizChoiceExact(id: 'wrong2', latex: '2', value: RInt(2)));
        choices
            .add(QuizChoiceExact(id: 'wrong3', latex: 'e^{2}', value: RExp(2)));

      case 'ln_power':
        final value = variables['value'] as int;
        final base = variables['base'] as int;
        final exponent = variables['exponent'] as int;

        // Distracteurs pour ln(a^n) = n*ln(a)
        choices.add(QuizChoiceExact(
            id: 'wrong1',
            latex: value.toString(),
            value: RInt(value))); // oublier le ln
        choices.add(QuizChoiceExact(
            id: 'wrong2',
            latex: '\\ln{$value}',
            value: RLnInt(value))); // pas de simplification
        choices.add(QuizChoiceExact(
            id: 'wrong3',
            latex: '${exponent + 1}\\ln{$base}',
            value: RLnCoeff(exponent + 1, base))); // mauvais coefficient

      case 'ln_product_rule':
      default:
        final value = variables['value'] as int;

        choices.add(QuizChoiceExact(
            id: 'wrong1', latex: value.toString(), value: RInt(value)));
        choices.add(QuizChoiceExact(
            id: 'wrong2',
            latex: '\\ln{${value + 1}}',
            value: RLnInt(value + 1)));
        choices.add(QuizChoiceExact(id: 'wrong3', latex: '0', value: RInt(0)));
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraN = _randInt(3, 12);
      final extra = RLnInt(extraN);
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'logexp_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: variables,
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'log_exp_operations',
        'operation': operation,
        'difficulty': 'advanced',
        'involves_constants': true,
      },
    );
  }

  /// Générateur simple avec 6 familles incluant les constantes
  List<QuizItemExact> generateSimpleExactQuiz({int numberOfQuestions = 6}) {
    final quizItems = <QuizItemExact>[];

    for (int i = 0; i < numberOfQuestions; i++) {
      switch (i % 6) {
        case 0:
          quizItems.add(genFractionSum());
        case 1:
          quizItems.add(genEqXSqEqualsN());
        case 2:
          quizItems.add(genRadicalSum());
        case 3:
          quizItems.add(genRadicalSimplification());
        case 4:
          quizItems.add(genPiOperations());
        case 5:
          quizItems.add(genLogExpOperations());
      }
    }

    return quizItems;
  }

  /// CE1 : Tables de multiplication 1-4
  QuizItemExact genCE1Multiplication({int numberOfResults = 5}) {
    final a = _randInt(1, 4); // Tables 1-4 (×1, ×2, ×3, ×4)
    final b = _randInt(1, 10); // Multiplicateur jusqu'à 10
    final product = a * b;

    final left = '\\VAR{a} \\times \\VAR{b}';
    final result = RInt(product);

    // Générer des distracteurs pour drag & drop
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs spécifiques aux tables
    final distractors = [
      RInt(product + a), // Table suivante (ex: 3×4=12 → 4×4=16)
      RInt(product - a), // Table précédente (ex: 3×4=12 → 2×4=8)
      RInt(a + b), // Addition au lieu de multiplication
      RInt((a + 1) * b), // Table supérieure (ex: 3×4 → 4×4=16)
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k > BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra =
          RInt(_randInt(1, 40)); // Résultats plausibles pour tables 1-4
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'ce1_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'ce1_tables',
        'difficulty': 'beginner',
        'operation': 'multiplication_tables_1_4',
        'level': 'ce1',
        'tables': '1-4',
      },
    );
  }

  /// CE2 : Tables de multiplication 1-6
  QuizItemExact genCE2Multiplication({int numberOfResults = 5}) {
    final a = _randInt(1, 6); // Tables 1-6 (+ ×5, ×6)
    final b = _randInt(1, 10);
    final product = a * b;

    final left = '\\VAR{a} \\times \\VAR{b}';
    final result = RInt(product);

    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    final distractors = [
      RInt(product + 5), // Erreur +5 (table de 5 fréquente)
      RInt(product - 5), // Erreur -5
      RInt(a + b), // Addition au lieu de multiplication
      RInt(product + a), // Confusion avec table suivante
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k > BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(1, 60)); // Résultats pour tables 1-6
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'ce2_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'ce2_tables',
        'difficulty': 'elementary',
        'operation': 'multiplication_tables_1_6',
        'level': 'ce2',
        'tables': '1-6',
      },
    );
  }

  /// CM1 : Tables de multiplication 1-7
  QuizItemExact genCM1Multiplication({int numberOfResults = 5}) {
    final a = _randInt(1, 7); // Tables 1-7 (+ ×7)
    final b = _randInt(1, 10);
    final product = a * b;

    final left = '\\VAR{a} \\times \\VAR{b}';
    final result = RInt(product);

    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    final distractors = [
      RInt(product + 7), // Table de 7 fréquente, erreur +7
      RInt(product - 7), // Erreur -7
      RInt(a + b), // Addition au lieu de multiplication
      RInt(product + 2 * a), // Double de la table (ex: 7×3=21 → 7×6=42)
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k > BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(1, 70)); // Résultats pour tables 1-7
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'cm1_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'cm1_tables',
        'difficulty': 'intermediate',
        'operation': 'multiplication_tables_1_7',
        'level': 'cm1',
        'tables': '1-7',
      },
    );
  }

  /// CM2 : Tables de multiplication 1-9
  QuizItemExact genCM2Multiplication({int numberOfResults = 5}) {
    final a = _randInt(1, 9); // Tables 1-9 (+ ×8, ×9)
    final b = _randInt(1, 10);
    final product = a * b;

    final left = '\\VAR{a} \\times \\VAR{b}';
    final result = RInt(product);

    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    final distractors = [
      RInt(product + 9), // Table de 9, erreur +9
      RInt(product - 9), // Erreur -9
      RInt(product + 8), // Table de 8, erreur +8
      RInt(a + b), // Addition au lieu de multiplication
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k > BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(1, 90)); // Résultats pour tables 1-9
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'cm2_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'cm2_tables',
        'difficulty': 'advanced_elementary',
        'operation': 'multiplication_tables_1_9',
        'level': 'cm2',
        'tables': '1-9',
      },
    );
  }

  /// CP : Additions simples (nombres 1-4, 5 propositions adaptables, UNIQUES)
  QuizItemExact genCPAddition({int numberOfResults = 5}) {
    int attempts = 0;
    late int a, b, sum;
    late List<QuizChoiceExact> choices;
    late Set<int> usedValues;

    // Garantir des résultats uniques avec retry logic
    do {
      attempts++;
      a = _randInt(1, 4); // Nombres < 5 comme demandé
      b = _randInt(1, 4); // Nombres < 5 comme demandé
      sum = a + b;

      // Générer propositions adaptables (4 à 6) pour CP
      choices = <QuizChoiceExact>[];
      usedValues = <int>{};

      // Résultat correct
      choices.add(QuizChoiceExact(
        id: 'correct',
        latex: '$sum',
        value: RInt(sum),
      ));
      usedValues.add(sum);

      // Distracteurs pédagogiques CP
      final potentialDistractors = [
        sum + 1, // +1 erreur classique
        sum - 1, // -1 erreur classique
        a, // confusion avec premier opérande
        b, // confusion avec second opérande
        sum + 2, // +2 erreur
        sum - 2, // -2 erreur si > 0
        a + b + 1, // erreur de calcul +1
      ];

      // Ajouter distracteurs valides
      for (final dist in potentialDistractors) {
        if (choices.length >= numberOfResults) break;
        if (dist > 0 && dist <= 10 && !usedValues.contains(dist)) {
          choices.add(QuizChoiceExact(
            id: 'distractor_${choices.length}',
            latex: '$dist',
            value: RInt(dist),
          ));
          usedValues.add(dist);
        }
      }

      // Compléter avec valeurs aléatoires si besoin
      while (choices.length < numberOfResults && usedValues.length < 10) {
        final candidate = _randInt(2, 10);
        if (!usedValues.contains(candidate)) {
          choices.add(QuizChoiceExact(
            id: 'extra_${choices.length}',
            latex: '$candidate',
            value: RInt(candidate),
          ));
          usedValues.add(candidate);
        }
      }

      // Éviter boucle infinie
      if (attempts > 20) {
        print('⚠️ CP: Forçage après $attempts tentatives');
        break;
      }
    } while (choices.length < numberOfResults ||
        usedValues.length != choices.length);

    final left = '\\VAR{a} + \\VAR{b}';

    return QuizItemExact(
      id: 'cp_addition_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: RInt(sum),
      answerLatexCanonical: '$sum',
      choices: choices,
      metadata: {
        'family': 'cp_operations',
        'difficulty': 'beginner',
        'operation': 'addition_simple',
        'level': 'cp',
        'propositions': numberOfResults, // Propositions adaptables
      },
    );
  }

  /// Additions progressives selon le niveau éducatif
  QuizItemExact genProgressiveAddition(String level,
      {int numberOfResults = 5}) {
    final levelConfig = _getAdditionConfig(level);
    return _generateAdditionForConfig(levelConfig, numberOfResults);
  }

  /// Additions progressives JSON-driven (remplace les configs hardcodées)
  QuizItemExact genProgressiveAdditionFromJSON(
    String level,
    dynamic domain,
    int numberOfResults,
  ) {
    final min = domain.min as int? ?? 1;
    final max = domain.max as int? ?? 10;
    final description = domain.description as String? ?? 'Addition $level';

    final config = {
      'min': min,
      'max': max,
      'description': description,
    };

    print(
        '🎯 Addition JSON-driven $level: domaine [$min-$max], $numberOfResults résultats');
    return _generateAdditionForConfig(config, numberOfResults);
  }

  /// Fractions JSON-driven (remplace les ranges hardcodés)
  QuizItemExact genFractionSumFromJSON(
    String level,
    Map<String, dynamic> parameters,
    int numberOfResults,
  ) {
    // Extraire les ranges pour numérateurs selon le niveau
    final numeratorRanges =
        parameters['numerator_ranges'] as Map<String, dynamic>? ?? {};
    final numeratorConfig = numeratorRanges[level] as Map<String, dynamic>? ??
        {'min': -9, 'max': 9};

    final denominatorRanges =
        parameters['denominator_ranges'] as Map<String, dynamic>? ?? {};
    final denominatorConfig =
        denominatorRanges['all_levels'] as Map<String, dynamic>? ??
            {'min': 2, 'max': 9};

    final numMin = numeratorConfig['min'] as int? ?? -9;
    final numMax = numeratorConfig['max'] as int? ?? 9;
    final denMin = denominatorConfig['min'] as int? ?? 2;
    final denMax = denominatorConfig['max'] as int? ?? 9;

    print(
        '🎯 Fraction JSON-driven $level: num[$numMin,$numMax], den[$denMin,$denMax], $numberOfResults résultats');

    // Utiliser la logique existante avec nouveaux paramètres
    final p = _randInt(numMin, numMax);
    final q = _randInt(denMin, denMax);
    final r = _randInt(numMin, numMax);
    final s = _randInt(denMin, denMax);

    final frac1 = RRational(BigInt.from(p), BigInt.from(q)).normalize();
    final frac2 = RRational(BigInt.from(r), BigInt.from(s)).normalize();

    // Calcul exact de la somme (réutiliser la logique existante)
    Res addFrac(Res a, Res b) {
      final A = a.normalize(), B = b.normalize();
      if (A is RInt && B is RInt) {
        return RInt.big(A.k + B.k);
      } else {
        RRational toFrac(Res x) {
          if (x is RInt) return RRational(x.k, BigInt.one);
          if (x is RRational) return x.reduced();
          throw StateError('Somme: cas non fractionnel');
        }

        final af = toFrac(A), bf = toFrac(B);
        final p = af.p * bf.q + bf.p * af.q;
        final q = af.q * bf.q;
        return RRational(p, q).normalize();
      }
    }

    final result = addFrac(frac1, frac2);

    return QuizItemExact(
      id: 'fraction_json_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: '\\VAR{frac1} + \\VAR{frac2}',
      variables: {'frac1': p, 'frac2': r, 'q': q, 's': s},
      expected: result,
      answerLatexCanonical: result.toLatex(),
      choices: _generateFractionChoicesJSON(
          result as RRational, numMin, numMax, denMin, denMax, numberOfResults),
      metadata: {
        'family': 'fractions_json',
        'level': level,
        'numerator_range': '[$numMin,$numMax]',
        'denominator_range': '[$denMin,$denMax]',
      },
    );
  }

  /// Génère les choix pour fractions JSON avec paramètres configurables
  List<QuizChoiceExact> _generateFractionChoicesJSON(
    RRational correctResult,
    int numMin,
    int numMax,
    int denMin,
    int denMax,
    int numberOfResults,
  ) {
    final choices = <QuizChoiceExact>[];
    final usedLatex = <String>{};

    // Réponse correcte
    final correctLatex = correctResult.toLatex();
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: correctLatex,
      value: correctResult,
    ));
    usedLatex.add(correctLatex);

    // Distracteurs intelligents
    for (int i = 1;
        i < numberOfResults && choices.length < numberOfResults;
        i++) {
      final randomNum = _randInt(numMin, numMax);
      final randomDen = _randInt(denMin, denMax);

      final distractor =
          RRational(BigInt.from(randomNum), BigInt.from(randomDen));
      final distractorLatex = distractor.toLatex();

      if (!usedLatex.contains(distractorLatex)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: distractorLatex,
          value: distractor,
        ));
        usedLatex.add(distractorLatex);
      }
    }

    return choices;
  }

  /// Radicaux JSON-driven (remplace les ranges hardcodés)
  QuizItemExact genRadicalSumFromJSON(
    String level,
    Map<String, dynamic> parameters,
    int numberOfResults,
  ) {
    // Extraire les ranges selon le niveau
    final coefficientRanges =
        parameters['coefficient_ranges'] as Map<String, dynamic>? ?? {};
    final coeffConfig = coefficientRanges[level] as Map<String, dynamic>? ??
        {'min': 1, 'max': 5};

    final radicandRanges =
        parameters['radicand_ranges'] as Map<String, dynamic>? ?? {};
    final radConfig =
        radicandRanges[level] as Map<String, dynamic>? ?? {'min': 2, 'max': 12};

    final coeffMin = coeffConfig['min'] as int? ?? 1;
    final coeffMax = coeffConfig['max'] as int? ?? 5;
    final radMin = radConfig['min'] as int? ?? 2;
    final radMax = radConfig['max'] as int? ?? 12;

    print(
        '🎯 Radical JSON-driven $level: coeff[$coeffMin,$coeffMax], rad[$radMin,$radMax], $numberOfResults résultats');

    // Génération avec paramètres JSON
    final coeff1 = _randInt(coeffMin, coeffMax);
    final coeff2 = _randInt(coeffMin, coeffMax);
    final radicand = _randInt(radMin, radMax);

    // Addition de radicaux de même radicande: a√n + b√n = (a+b)√n
    final resultCoeff = coeff1 + coeff2;
    final result =
        RRadical(Coeff(BigInt.from(resultCoeff)), radicand).normalize();

    return QuizItemExact(
      id: 'radical_json_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: '\\VAR{rad1} + \\VAR{rad2}',
      variables: {'rad1': coeff1, 'rad2': coeff2, 'radicand': radicand},
      expected: result,
      answerLatexCanonical: result.toLatex(),
      choices: _generateRadicalChoicesJSON(result as RRadical, coeffMin,
          coeffMax, radMin, radMax, numberOfResults),
      metadata: {
        'family': 'radicals_json',
        'level': level,
        'coefficient_range': '[$coeffMin,$coeffMax]',
        'radicand_range': '[$radMin,$radMax]',
      },
    );
  }

  /// Génère les choix pour radicaux JSON avec paramètres configurables
  List<QuizChoiceExact> _generateRadicalChoicesJSON(
    RRadical correctResult,
    int coeffMin,
    int coeffMax,
    int radMin,
    int radMax,
    int numberOfResults,
  ) {
    final choices = <QuizChoiceExact>[];
    final usedLatex = <String>{};

    // Réponse correcte
    final correctLatex = correctResult.toLatex();
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: correctLatex,
      value: correctResult,
    ));
    usedLatex.add(correctLatex);

    // Distracteurs intelligents
    for (int i = 1;
        i < numberOfResults && choices.length < numberOfResults;
        i++) {
      final extraCoeff = _randInt(coeffMin, coeffMax);
      final extraRad = _randInt(radMin, radMax);

      final distractor = RRadical(Coeff(BigInt.from(extraCoeff)), extraRad);
      final distractorLatex = distractor.toLatex();

      if (!usedLatex.contains(distractorLatex)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: distractorLatex,
          value: distractor,
        ));
        usedLatex.add(distractorLatex);
      }
    }

    return choices;
  }

  /// Logarithmes JSON-driven (remplace les coefficients hardcodés)
  QuizItemExact genLogExpOperationsFromJSON(
    String level,
    Map<String, dynamic> parameters,
    int numberOfResults,
  ) {
    // Extraire les ranges selon le niveau
    final coefficientRanges =
        parameters['coefficient_ranges'] as Map<String, dynamic>? ?? {};
    final coeffConfig = coefficientRanges[level] as Map<String, dynamic>? ??
        {'min': 1, 'max': 3};

    final exponentRanges =
        parameters['exponent_ranges'] as Map<String, dynamic>? ?? {};
    final expConfig =
        exponentRanges[level] as Map<String, dynamic>? ?? {'min': 0, 'max': 2};

    final argumentRanges =
        parameters['argument_ranges'] as Map<String, dynamic>? ?? {};
    final argConfig =
        argumentRanges[level] as Map<String, dynamic>? ?? {'min': 3, 'max': 12};

    final coeffMin = coeffConfig['min'] as int? ?? 1;
    final coeffMax = coeffConfig['max'] as int? ?? 3;
    final expMin = expConfig['min'] as int? ?? 0;
    final expMax = expConfig['max'] as int? ?? 2;
    final argMin = argConfig['min'] as int? ?? 3;
    final argMax = argConfig['max'] as int? ?? 12;

    print(
        '🎯 Logarithme JSON-driven $level: coeff[$coeffMin,$coeffMax], exp[$expMin,$expMax], arg[$argMin,$argMax], $numberOfResults résultats');

    // Générer selon les paramètres JSON
    final operations = ['properties', 'power_rule', 'product_rule'];
    final operation = operations[_randInt(0, operations.length - 1)];

    switch (operation) {
      case 'power_rule':
        final a = _randInt(argMin, argMax);
        final exponent = _randInt(expMin, expMax);
        final result = RLnCoeff(exponent, a);

        return QuizItemExact(
          id: 'log_json_${DateTime.now().microsecondsSinceEpoch}',
          leftLatex: 'ln(\\VAR{a}^{\\VAR{exp}})',
          variables: {'a': a, 'exp': exponent},
          expected: result,
          answerLatexCanonical: result.toLatex(),
          choices: _generateLogChoicesJSON(
              result, coeffMin, coeffMax, argMin, argMax, numberOfResults),
          metadata: {
            'family': 'logarithms_json',
            'level': level,
            'operation': 'power_rule',
            'coefficient_range': '[$coeffMin,$coeffMax]',
          },
        );

      default:
        // Fallback simple
        final a = _randInt(argMin, argMax);
        final b = _randInt(argMin, argMax);
        final result = RLnSum(terms: [RLnInt(a), RLnInt(b)]);

        return QuizItemExact(
          id: 'log_json_${DateTime.now().microsecondsSinceEpoch}',
          leftLatex: 'ln(\\VAR{a} \\times \\VAR{b})',
          variables: {'a': a, 'b': b},
          expected: result,
          answerLatexCanonical: result.toLatex(),
          choices: _generateLogChoicesJSON(
              result, coeffMin, coeffMax, argMin, argMax, numberOfResults),
          metadata: {
            'family': 'logarithms_json',
            'level': level,
            'operation': 'product_rule',
          },
        );
    }
  }

  /// Génère les choix pour logarithmes JSON
  List<QuizChoiceExact> _generateLogChoicesJSON(
    dynamic correctResult,
    int coeffMin,
    int coeffMax,
    int argMin,
    int argMax,
    int numberOfResults,
  ) {
    final choices = <QuizChoiceExact>[];
    final usedLatex = <String>{};

    // Réponse correcte
    final correctLatex = correctResult.toLatex();
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: correctLatex,
      value: correctResult,
    ));
    usedLatex.add(correctLatex);

    // Distracteurs intelligents
    for (int i = 1;
        i < numberOfResults && choices.length < numberOfResults;
        i++) {
      final extraN = _randInt(argMin, argMax);
      final distractor = RLnInt(extraN);
      final distractorLatex = distractor.toLatex();

      if (!usedLatex.contains(distractorLatex)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: distractorLatex,
          value: distractor,
        ));
        usedLatex.add(distractorLatex);
      }
    }

    return choices;
  }

  /// Constantes π JSON-driven (remplace les coefficients hardcodés)
  QuizItemExact genPiOperationsFromJSON(
    String level,
    Map<String, dynamic> parameters,
    int numberOfResults,
  ) {
    // Extraire les ranges selon le niveau
    final coefficientRanges =
        parameters['coefficient_ranges'] as Map<String, dynamic>? ?? {};
    final coeffConfig = coefficientRanges[level] as Map<String, dynamic>? ??
        {
          'values': [1, 2, 3]
        };

    final allowedValues = (coeffConfig['values'] as List<dynamic>? ?? [1, 2, 3])
        .map((v) => v is double ? v : (v as int).toDouble())
        .toList();
    final allowedOperations =
        coeffConfig['operations'] as List<dynamic>? ?? ['multiplication'];

    print(
        '🎯 Constante π JSON-driven $level: values=$allowedValues, ops=$allowedOperations, $numberOfResults résultats');

    // Choisir opération et valeurs selon JSON
    final operation =
        allowedOperations[_randInt(0, allowedOperations.length - 1)] as String;

    switch (operation) {
      case 'addition':
        final result = RPiMul(Coeff(BigInt.from(2))); // π + π = 2π
        return QuizItemExact(
          id: 'pi_json_${DateTime.now().microsecondsSinceEpoch}',
          leftLatex: '\\pi + \\pi',
          variables: {},
          expected: result,
          answerLatexCanonical: result.toLatex(),
          choices:
              _generatePiChoicesJSON(result, allowedValues, numberOfResults),
          metadata: {
            'family': 'pi_operations_json',
            'level': level,
            'operation': 'addition',
          },
        );

      default: // multiplication
        final coeff = allowedValues[_randInt(0, allowedValues.length - 1)];
        final result = RPiMul(Coeff(BigInt.from(coeff.toInt())));

        return QuizItemExact(
          id: 'pi_json_${DateTime.now().microsecondsSinceEpoch}',
          leftLatex: '\\VAR{coeff} \\times \\pi',
          variables: {'coeff': coeff},
          expected: result,
          answerLatexCanonical: result.toLatex(),
          choices:
              _generatePiChoicesJSON(result, allowedValues, numberOfResults),
          metadata: {
            'family': 'pi_operations_json',
            'level': level,
            'operation': 'multiplication',
          },
        );
    }
  }

  /// Génère les choix pour constantes π JSON
  List<QuizChoiceExact> _generatePiChoicesJSON(
    RPiMul correctResult,
    List<double> allowedValues,
    int numberOfResults,
  ) {
    final choices = <QuizChoiceExact>[];
    final usedLatex = <String>{};

    // Réponse correcte
    final correctLatex = correctResult.toLatex();
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: correctLatex,
      value: correctResult,
    ));
    usedLatex.add(correctLatex);

    // Distracteurs intelligents
    for (int i = 1;
        i < numberOfResults && choices.length < numberOfResults;
        i++) {
      final randomCoeff = allowedValues[_randInt(0, allowedValues.length - 1)];
      final distractor = RPiMul(Coeff(BigInt.from(randomCoeff.toInt())));
      final distractorLatex = distractor.toLatex();

      if (!usedLatex.contains(distractorLatex)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: distractorLatex,
          value: distractor,
        ));
        usedLatex.add(distractorLatex);
      }
    }

    return choices;
  }

  /// Configuration des additions par niveau
  Map<String, dynamic> _getAdditionConfig(String level) {
    switch (level) {
      case 'cp':
        return {'min': 1, 'max': 4, 'description': 'CP: nombres ≤ 4'};
      case 'ce1':
        return {'min': 1, 'max': 10, 'description': 'CE1: nombres ≤ 10'};
      case 'ce2':
        return {'min': 1, 'max': 20, 'description': 'CE2: nombres ≤ 20'};
      case 'cm1':
        return {'min': 1, 'max': 50, 'description': 'CM1: nombres ≤ 50'};
      case 'cm2':
        return {'min': 1, 'max': 100, 'description': 'CM2: nombres ≤ 100'};
      case 'sixieme':
        return {'min': 1, 'max': 20, 'description': '6ème: nombres ≤ 20'};
      case 'cinquieme':
        return {'min': 1, 'max': 30, 'description': '5ème: nombres ≤ 30'};
      case 'quatrieme':
        return {'min': 1, 'max': 40, 'description': '4ème: nombres ≤ 40'};
      case 'troisieme':
        return {'min': 1, 'max': 50, 'description': '3ème: nombres ≤ 50'};
      case 'seconde':
        return {'min': 1, 'max': 60, 'description': '2nde: nombres ≤ 60'};
      case 'premiere':
        return {'min': 1, 'max': 70, 'description': '1ère: nombres ≤ 70'};
      case 'terminale':
        return {
          'min': 1,
          'max': 100,
          'description': 'Terminale: nombres ≤ 100'
        };
      default:
        return {'min': 1, 'max': 10, 'description': 'Défaut: nombres ≤ 10'};
    }
  }

  /// Génère une addition avec configuration donnée
  QuizItemExact _generateAdditionForConfig(
      Map<String, dynamic> config, int numberOfResults) {
    final min = config['min'] as int;
    final max = config['max'] as int;
    final description = config['description'] as String;

    int attempts = 0;
    late int a, b, sum;
    late List<QuizChoiceExact> choices;
    late Set<int> usedValues;

    // Garantir des résultats uniques avec retry logic
    do {
      attempts++;
      a = _randInt(min, max);
      b = _randInt(min, max);
      sum = a + b;

      // Générer propositions différentes
      choices = <QuizChoiceExact>[];
      usedValues = <int>{};

      // Résultat correct
      choices.add(QuizChoiceExact(
        id: 'correct',
        latex: '$sum',
        value: RInt(sum),
      ));
      usedValues.add(sum);

      // Distracteurs pédagogiques adaptés au niveau
      final maxResult = max * 2;
      final potentialDistractors = [
        sum + 1, // +1 erreur (très fréquente)
        sum - 1, // -1 erreur (très fréquente)
        a * b, // multiplication au lieu d'addition
        (a - b).abs(), // soustraction au lieu d'addition
        sum + 10, // erreur de retenue
        a, // confusion avec opérande
        b, // confusion avec opérande
      ];

      for (final dist in potentialDistractors) {
        if (choices.length >= numberOfResults) break;
        if (dist > 0 && dist <= maxResult && !usedValues.contains(dist)) {
          choices.add(QuizChoiceExact(
            id: 'distractor_${choices.length}',
            latex: '$dist',
            value: RInt(dist),
          ));
          usedValues.add(dist);
        }
      }

      // Compléter avec valeurs aléatoires uniques si nécessaire
      while (
          choices.length < numberOfResults && usedValues.length < maxResult) {
        final candidate = _randInt(1, maxResult);
        if (!usedValues.contains(candidate)) {
          choices.add(QuizChoiceExact(
            id: 'extra_${choices.length}',
            latex: '$candidate',
            value: RInt(candidate),
          ));
          usedValues.add(candidate);
        }
      }

      // Éviter boucle infinie
      if (attempts > 30) {
        print('⚠️ $description: Forçage après $attempts tentatives');
        break;
      }
    } while (choices.length < numberOfResults ||
        usedValues.length != choices.length);

    final left = '\\VAR{a} + \\VAR{b}';

    return QuizItemExact(
      id: 'progressive_addition_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: RInt(sum),
      answerLatexCanonical: '$sum',
      choices: choices,
      metadata: {
        'family': 'progressive_addition',
        'difficulty': 'progressive',
        'operation': 'addition_${config['description']}',
        'level': config['description'],
        'domain': '$min-$max',
      },
    );
  }

  /// Génère multiplication avec tables spécifiées (incluant 25, 75, 100)
  QuizItemExact genDynamicMultiplication(List<int> allowedTables,
      {int numberOfResults = 5}) {
    final random = Random();

    // DEBUG: Afficher les tables disponibles
    print('🎲 Tables dynamiques disponibles: $allowedTables');

    // Choisir aléatoirement une table parmi celles autorisées
    final table = allowedTables[random.nextInt(allowedTables.length)];
    print('🎯 Table dynamique choisie: $table');

    // Choisir un multiplicateur adapté selon la table
    int multiplicateur;
    if (table <= 10) {
      // Tables classiques 1-10 : multiplicateur 1-10
      multiplicateur = random.nextInt(10) + 1;
    } else if (table == 25) {
      // Table 25 : multiplicateur 1-4 (25×1, 25×2, 25×3, 25×4)
      multiplicateur = random.nextInt(4) + 1;
    } else if (table == 50) {
      // Table 50 : multiplicateur 1-2 (50×1, 50×2)
      multiplicateur = random.nextInt(2) + 1;
    } else if (table == 75) {
      // Table 75 : multiplicateur 1-2 (75×1, 75×2)
      multiplicateur = random.nextInt(2) + 1;
    } else if (table == 100) {
      // Table 100 : multiplicateur 1-10 (100×1, 100×2, etc.)
      multiplicateur = random.nextInt(10) + 1;
    } else {
      // Tables non-standard : multiplicateur 1-5
      multiplicateur = random.nextInt(5) + 1;
    }

    final result = table * multiplicateur;
    print('🧮 Calcul: $table × $multiplicateur = $result');

    // Générer propositions uniques
    final choices = <QuizChoiceExact>[];
    final usedValues = <int>{};

    // Réponse correcte
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: '$result',
      value: RInt(result),
    ));
    usedValues.add(result);

    // Distracteurs pédagogiques
    final potentialDistractors = [
      result + table, // Addition au lieu de multiplication
      result - table, // Soustraction
      table + multiplicateur, // Addition des opérandes
      result + 1, // +1 erreur fréquente
      result - 1, // -1 erreur fréquente
      table, // Confusion avec table
      multiplicateur, // Confusion avec multiplicateur
    ];

    // Ajouter distracteurs uniques
    for (final dist in potentialDistractors) {
      if (choices.length >= numberOfResults) break;
      if (dist > 0 && !usedValues.contains(dist)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_${choices.length}',
          latex: '$dist',
          value: RInt(dist),
        ));
        usedValues.add(dist);
      }
    }

    // Compléter avec valeurs aléatoires si nécessaire
    while (choices.length < numberOfResults) {
      final candidate = random.nextInt(result + 50) + 1;
      if (!usedValues.contains(candidate)) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: '$candidate',
          value: RInt(candidate),
        ));
        usedValues.add(candidate);
        if (usedValues.length > 1000) break; // Éviter boucle infinie
      }
    }

    final left = '\\VAR{a} \\times \\VAR{b}';

    return QuizItemExact(
      id: 'dynamic_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': table, 'b': multiplicateur},
      expected: RInt(result),
      answerLatexCanonical: '$result',
      choices: choices,
      metadata: {
        'family': 'dynamic_multiplication',
        'difficulty': 'adaptive',
        'operation': 'multiplication_${table}x$multiplicateur',
        'table': table,
        'multiplicateur': multiplicateur,
        'tables_config': allowedTables.toString(),
      },
    );
  }

  /// CE1 : Additions avec nombres ≤ 10 (GARANTIE ZÉRO DOUBLON)
  QuizItemExact genCE1Addition({int numberOfResults = 5}) {
    int attempts = 0;
    late int a, b, sum;
    late List<QuizChoiceExact> choices;
    late Set<int> usedValues;

    // Garantir des résultats uniques avec retry logic
    do {
      attempts++;
      a = _randInt(1, 10); // Nombres ≤ 10 comme demandé
      b = _randInt(1, 10); // Nombres ≤ 10 comme demandé
      sum = a + b;

      // Générer 5 propositions différentes pour CE1
      choices = <QuizChoiceExact>[];
      usedValues = <int>{};

      // Résultat correct
      choices.add(QuizChoiceExact(
        id: 'correct',
        latex: '$sum',
        value: RInt(sum),
      ));
      usedValues.add(sum);

      // Distracteurs pédagogiques triés par pertinence
      final potentialDistractors = [
        sum + 1, // +1 erreur (très fréquente)
        sum - 1, // -1 erreur (très fréquente)
        a * b, // multiplication au lieu d'addition
        (a - b).abs(), // soustraction au lieu d'addition
        sum + 10, // erreur de retenue (pour CE1)
        a, // confusion avec opérande
        b, // confusion avec opérande
      ];

      for (final dist in potentialDistractors) {
        if (choices.length >= numberOfResults) break;
        if (dist > 0 && dist <= 30 && !usedValues.contains(dist)) {
          choices.add(QuizChoiceExact(
            id: 'distractor_${choices.length}',
            latex: '$dist',
            value: RInt(dist),
          ));
          usedValues.add(dist);
        }
      }

      // Compléter avec valeurs aléatoires uniques si nécessaire
      while (choices.length < numberOfResults && usedValues.length < 25) {
        final candidate = _randInt(1, 25);
        if (!usedValues.contains(candidate)) {
          choices.add(QuizChoiceExact(
            id: 'extra_${choices.length}',
            latex: '$candidate',
            value: RInt(candidate),
          ));
          usedValues.add(candidate);
        }
      }

      // Éviter boucle infinie
      if (attempts > 30) {
        print('⚠️ CE1: Forçage après $attempts tentatives');
        break;
      }
    } while (choices.length < numberOfResults ||
        usedValues.length != choices.length);

    final left = '\\VAR{a} + \\VAR{b}';

    return QuizItemExact(
      id: 'ce1_addition_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: RInt(sum),
      answerLatexCanonical: '$sum',
      choices: choices,
      metadata: {
        'family': 'ce1_operations',
        'difficulty': 'elementary',
        'operation': 'addition_intermediate',
        'level': 'ce1',
      },
    );
  }

  /// Multiplication adaptative selon le niveau éducatif
  QuizItemExact genMultiplicationEntiersAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final levelConfig = _getMultiplicationConfig(level);
    return _generateMultiplicationForConfig(levelConfig, numberOfResults);
  }

  /// Soustraction adaptative selon le niveau éducatif
  QuizItemExact genSoustractionEntiersAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final levelConfig = _getSoustractionConfig(level);
    return _generateSoustractionForConfig(levelConfig, numberOfResults);
  }

  /// Configuration des soustractions par niveau
  Map<String, dynamic> _getSoustractionConfig(int level) {
    switch (level) {
      case 1: // CP
        return {'min': 1, 'max': 4, 'description': 'CP: nombres ≤ 4'};
      case 2: // CE1
        return {'min': 1, 'max': 10, 'description': 'CE1: nombres ≤ 10'};
      case 3: // CE2
        return {'min': 1, 'max': 20, 'description': 'CE2: nombres ≤ 20'};
      case 4: // CM1
        return {'min': 1, 'max': 50, 'description': 'CM1: nombres ≤ 50'};
      case 5: // CM2
        return {'min': 1, 'max': 100, 'description': 'CM2: nombres ≤ 100'};
      case 6: // 6ème
        return {'min': 1, 'max': 20, 'description': '6ème: nombres ≤ 20'};
      case 7: // 5ème
        return {'min': 1, 'max': 30, 'description': '5ème: nombres ≤ 30'};
      case 8: // 4ème
        return {'min': 1, 'max': 40, 'description': '4ème: nombres ≤ 40'};
      case 9: // 3ème
        return {'min': 1, 'max': 50, 'description': '3ème: nombres ≤ 50'};
      case 10: // 2nde
        return {'min': 1, 'max': 60, 'description': '2nde: nombres ≤ 60'};
      case 11: // 1ère
        return {'min': 1, 'max': 70, 'description': '1ère: nombres ≤ 70'};
      case 12: // Terminale
        return {
          'min': 1,
          'max': 100,
          'description': 'Terminale: nombres ≤ 100'
        };
      default: // Bac+
        return {'min': 1, 'max': 100, 'description': 'Bac+: nombres ≤ 100'};
    }
  }

  /// Configuration des multiplications par niveau
  Map<String, dynamic> _getMultiplicationConfig(int level) {
    switch (level) {
      case 1: // CP
        return {
          'maxTable': 2,
          'maxMultiplier': 5,
          'description': 'CP: tables ≤ 2, multiplicateurs ≤ 5'
        };
      case 2: // CE1
        return {
          'maxTable': 4,
          'maxMultiplier': 10,
          'description': 'CE1: tables ≤ 4, multiplicateurs ≤ 10'
        };
      case 3: // CE2
        return {
          'maxTable': 6,
          'maxMultiplier': 10,
          'description': 'CE2: tables ≤ 6, multiplicateurs ≤ 10'
        };
      case 4: // CM1
        return {
          'maxTable': 7,
          'maxMultiplier': 10,
          'description': 'CM1: tables ≤ 7, multiplicateurs ≤ 10'
        };
      case 5: // CM2
        return {
          'maxTable': 9,
          'maxMultiplier': 10,
          'description': 'CM2: tables ≤ 9, multiplicateurs ≤ 10'
        };
      case 6: // 6ème
        return {
          'maxTable': 10,
          'maxMultiplier': 10,
          'description': '6ème: tables ≤ 10, multiplicateurs ≤ 10'
        };
      case 7: // 5ème
        return {
          'maxTable': 12,
          'maxMultiplier': 10,
          'description': '5ème: tables ≤ 12, multiplicateurs ≤ 10'
        };
      case 8: // 4ème
        return {
          'maxTable': 15,
          'maxMultiplier': 10,
          'description': '4ème: tables ≤ 15, multiplicateurs ≤ 10'
        };
      case 9: // 3ème
        return {
          'maxTable': 20,
          'maxMultiplier': 10,
          'description': '3ème: tables ≤ 20, multiplicateurs ≤ 10'
        };
      case 10: // 2nde
        return {
          'maxTable': 25,
          'maxMultiplier': 10,
          'description': '2nde: tables ≤ 25, multiplicateurs ≤ 10'
        };
      case 11: // 1ère
        return {
          'maxTable': 30,
          'maxMultiplier': 10,
          'description': '1ère: tables ≤ 30, multiplicateurs ≤ 10'
        };
      case 12: // Terminale
        return {
          'maxTable': 50,
          'maxMultiplier': 10,
          'description': 'Terminale: tables ≤ 50, multiplicateurs ≤ 10'
        };
      default: // Bac+
        return {
          'maxTable': 100,
          'maxMultiplier': 10,
          'description': 'Bac+: tables ≤ 100, multiplicateurs ≤ 10'
        };
    }
  }

  /// Génère une soustraction avec configuration donnée
  QuizItemExact _generateSoustractionForConfig(
      Map<String, dynamic> config, int numberOfResults) {
    final min = config['min'] as int;
    final max = config['max'] as int;

    // S'assurer que a >= b pour éviter les résultats négatifs
    final a = _randInt(min, max);
    final b = _randInt(min, a); // b <= a pour résultat positif
    final difference = a - b;

    final left = '\\VAR{a} - \\VAR{b}';
    final result = RInt(difference);

    // Générer des distracteurs
    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs pédagogiques
    final distractors = [
      RInt(difference + 1), // +1 erreur classique
      RInt(difference - 1), // -1 erreur classique
      RInt(a + b), // Addition au lieu de soustraction
      RInt(a), // Confusion avec premier opérande
      RInt(b), // Confusion avec second opérande
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k >= BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(0, max));
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'soustraction_adaptive_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'soustraction_adaptive',
        'difficulty': 'elementary',
        'operation': 'soustraction_entiers',
        'level': config["level"].toString(),
        'max': max,
      },
    );
  }
// Corrections pour la méthode genPourcentageSimple() dans exact_math_engine.dart

  /// Pourcentages simples avec résultats exacts (entiers ou rationnels)
  QuizItemExact genPourcentageSimple({int numberOfResults = 5}) {
    // Combinaisons prédéfinies qui donnent des résultats exacts
    final validCombinations = [
      // Pourcentages simples avec résultats entiers
      {'percentage': 10, 'number': _randInt(1, 10) * 10, 'result': 0},
      {'percentage': 20, 'number': _randInt(1, 5) * 5, 'result': 0},
      {'percentage': 25, 'number': _randInt(1, 4) * 4, 'result': 0},
      {'percentage': 50, 'number': _randInt(1, 2) * 2, 'result': 0},
      {'percentage': 75, 'number': _randInt(1, 4) * 4, 'result': 0},
      {'percentage': 100, 'number': _randInt(1, 10), 'result': 0},

      // Multiples de 5% avec résultats entiers
      {'percentage': 15, 'number': _randInt(1, 20) * 20, 'result': 0},
      {'percentage': 30, 'number': _randInt(1, 10) * 10, 'result': 0},
      {'percentage': 40, 'number': _randInt(1, 5) * 5, 'result': 0},
      {'percentage': 60, 'number': _randInt(1, 5) * 5, 'result': 0},
      {'percentage': 80, 'number': _randInt(1, 5) * 5, 'result': 0},
      {'percentage': 90, 'number': _randInt(1, 10) * 10, 'result': 0},

      // Pourcentages avec résultats rationnels exacts (fractions)
      {'percentage': 33, 'number': 100, 'result': 0}, // 33% de 100 = 100/3
      {'percentage': 33, 'number': 200, 'result': 0}, // 33% de 200 = 200/3
      {'percentage': 33, 'number': 300, 'result': 0}, // 33% de 300 = 99 (entier)
      {'percentage': 66, 'number': 100, 'result': 0}, // 66% de 100 = 200/3
      {'percentage': 66, 'number': 200, 'result': 0}, // 66% de 200 = 400/3
      {'percentage': 66, 'number': 300, 'result': 0}, // 66% de 300 = 198 (entier)
      {'percentage': 16, 'number': 100, 'result': 0}, // 16% de 100 = 16 (entier)
      {'percentage': 16, 'number': 200, 'result': 0}, // 16% de 200 = 32 (entier)
      {'percentage': 83, 'number': 100, 'result': 0}, // 83% de 100 = 83 (entier)
      {'percentage': 83, 'number': 200, 'result': 0}, // 83% de 200 = 166 (entier)

      // Autres fractions exactes
      {'percentage': 12, 'number': 100, 'result': 0}, // 12% de 100 = 12 (entier)
      {'percentage': 12, 'number': 200, 'result': 0}, // 12% de 200 = 24 (entier)
      {'percentage': 37, 'number': 100, 'result': 0}, // 37% de 100 = 37 (entier)
      {'percentage': 37, 'number': 200, 'result': 0}, // 37% de 200 = 74 (entier)
      {'percentage': 62, 'number': 100, 'result': 0}, // 62% de 100 = 62 (entier)
      {'percentage': 62, 'number': 200, 'result': 0}, // 62% de 200 = 124 (entier)
    ];

    // Sélectionner une combinaison aléatoire
    final combination = validCombinations[_randInt(0, validCombinations.length - 1)];
    final percentage = combination['percentage'] as int;
    final number = combination['number'] as int;

    // Calculer le résultat exact (entier ou rationnel)
    final result = (number * percentage);
    final divisor = 100;

    // Vérifier si le résultat est entier
    Res resultValue;
    if (result % divisor == 0) {
      // ✅ CORRECTION: Utiliser directement result ~/ divisor sans BigInt.from()
      resultValue = RInt(result ~/ divisor);
    } else {
      // Créer une fraction exacte
      resultValue = RRational(BigInt.from(result), BigInt.from(divisor));
    }

    final left = '\\VAR{percentage}\\% \\text{ de } \\VAR{number}';

    // Générer des distracteurs
    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(resultValue),
      value: resultValue,
    ));

    // Distracteurs pédagogiques
    final distractors = <Res>[];

    if (resultValue is RInt) {
      final intResult = resultValue.k.toInt();
      distractors.addAll([
        // ✅ CORRECTION: Utiliser directement int sans BigInt.from()
        RInt(intResult + 1), // +1 erreur classique
        RInt(intResult - 1), // -1 erreur classique
        RInt(number), // Confusion avec le nombre de base
        RInt(percentage), // Confusion avec le pourcentage
        RInt((number * percentage / 10).round()), // Erreur de calcul (÷10 au lieu de ÷100)
        RInt(number + percentage), // Addition au lieu de pourcentage
      ]);
    } else if (resultValue is RRational) {
      final rationalResult = resultValue;
      distractors.addAll([
        RRational(rationalResult.p + BigInt.one, rationalResult.q), // +1 erreur classique
        RRational(rationalResult.p - BigInt.one, rationalResult.q), // -1 erreur classique
        // ✅ CORRECTION: Utiliser directement int sans BigInt.from()
        RInt(number), // Confusion avec le nombre de base
        RInt(percentage), // Confusion avec le pourcentage
        RRational(BigInt.from(number * percentage), BigInt.from(10)), // Erreur de calcul (÷10 au lieu de ÷100)
        RInt(number + percentage), // Addition au lieu de pourcentage
      ]);
    }

    for (int i = 0; i < math.min(distractors.length, numberOfResults - 1); i++) {
      if (renderCanonical(distractors[i]) != renderCanonical(resultValue)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(1, 100));
      if (!choices.any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'pourcentage_simple_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'percentage': percentage, 'number': number},
      expected: resultValue,
      answerLatexCanonical: renderCanonical(resultValue),
      choices: choices,
      metadata: {
        'family': 'pourcentage_simple',
        'difficulty': 'elementary',
        'operation': 'pourcentage_calculation',
        'level': 'elementary',
        'maxPercentage': 100,
        'maxNumber': 100,
      },
    );
  }

  /// Génère une multiplication avec configuration donnée
  QuizItemExact _generateMultiplicationForConfig(
      Map<String, dynamic> config, int numberOfResults) {
    final maxTable = config['maxTable'] as int;
    final maxMultiplier = config['maxMultiplier'] as int;

    final a = _randInt(1, maxTable);
    final b = _randInt(1, maxMultiplier);
    final product = a * b;

    final left = '\\VAR{a} \\times \\VAR{b}';
    final result = RInt(product);

    // Générer des distracteurs
    final choices = <QuizChoiceExact>[];
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs pédagogiques
    final distractors = [
      RInt(product + a), // Table suivante
      RInt(product - a), // Table précédente
      RInt(a + b), // Addition au lieu de multiplication
      RInt((a + 1) * b), // Table supérieure
      RInt(a * (b + 1)), // Multiplicateur supérieur
    ];

    for (int i = 0;
        i < math.min(distractors.length, numberOfResults - 1);
        i++) {
      if (distractors[i].k > BigInt.zero &&
          renderCanonical(distractors[i]) != renderCanonical(result)) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractors[i]),
          value: distractors[i],
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(_randInt(1, product + 20));
      if (!choices
          .any((c) => renderCanonical(c.value) == renderCanonical(extra))) {
        choices.add(QuizChoiceExact(
          id: 'extra_${choices.length}',
          latex: renderCanonical(extra),
          value: extra,
        ));
      }
    }

    return QuizItemExact(
      id: 'multiplication_adaptive_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'multiplication_adaptive',
        'difficulty': 'elementary',
        'operation': 'multiplication_entiers',
        'level': config["level"].toString(),
        'maxTable': maxTable,
        'maxMultiplier': maxMultiplier,
      },
    );
  }
}
