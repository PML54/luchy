/// <cursor>
///
/// thema_operations.dart
/// Chemin: core/thema/
///
/// 🎯 OPÉRATIONS THEMA - Implémentation des opérations manquantes
/// Nouvelles opérations pour le système Thema
///
/// COMPOSANTS PRINCIPAUX:
/// - Multiplication de fractions: (a/b) × (c/d) = (a×c)/(b×d)
/// - Division de fractions: (a/b) ÷ (c/d) = (a×d)/(b×c)
/// - Multiplication de radicaux: √a × √b = √(a×b)
/// - Opérations avancées pour niveaux lycée
///
/// ÉTAT ACTUEL:
/// - Implémentation des opérations manquantes
/// - Intégration avec ExactMathEngine
/// - Support des niveaux avancés
/// - Opérations granulaires par type
///
/// HISTORIQUE RÉCENT:
/// - 2025-09-25 16:43: SOUSTRACTION ADAPTATIVE - Nouvelle opération implémentée
/// - Ajout genSoustractionEntiersAdaptive() avec niveaux progressifs
/// - Distracteurs adaptés selon niveau éducatif (CP à Bac+2)
/// - Garantie de résultats positifs (a >= b)
/// - 2025-09-24: Création opérations Thema
/// - Implémentation multiplication/division fractions
/// - Ajout multiplication radicaux
/// - Intégration avec système Thema
///
/// 🔧 POINTS D'ATTENTION:
/// - Fractions: Simplification automatique des résultats
/// - Radicaux: Extraction des carrés parfaits
/// - Performance: Calculs optimisés pour quiz temps réel
/// - Cohérence: Format LaTeX uniforme
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Tests sur tous les niveaux
/// - Optimisation des performances
/// - Ajout d'opérations supplémentaires
/// - Intégration complète avec Thema
///
/// 🔗 FICHIERS LIÉS:
/// - lib/core/thema/thema_definitions.dart: Définitions des Thema
/// - lib/core/operations/exact_math_engine.dart: Moteur de calculs
/// - lib/core/thema/thema_manager.dart: Gestionnaire des Thema
///
/// CRITICALITÉ: ⭐⭐⭐ (Opérations spécialisées)
/// 📅 Dernière modification: 2025-09-25 16:43 - Soustraction adaptative
/// </cursor>

import 'dart:math' as math;

import '../operations/exact_math_engine.dart';

/// 🎯 EXTENSIONS POUR OPÉRATIONS THEMA
/// Nouvelles opérations pour le système Thema
extension ThemaOperations on ExactMathGenerator {
  /// Multiplication de fractions: (a/b) × (c/d) = (a×c)/(b×d)
  QuizItemExact genFractionMultiplication({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des fractions simples
    final a = random.nextInt(8) + 2; // 2-9
    final b = random.nextInt(8) + 2; // 2-9
    final c = random.nextInt(8) + 2; // 2-9
    final d = random.nextInt(8) + 2; // 2-9

    // Calculer le résultat
    final numerator = a * c;
    final denominator = b * d;

    // Simplifier la fraction
    final gcd = _gcd(numerator, denominator);
    final simplifiedNum = numerator ~/ gcd;
    final simplifiedDen = denominator ~/ gcd;

    final left = '\\frac{$a}{$b} \\times \\frac{$c}{$d}';
    final result =
        RRational(BigInt.from(simplifiedNum), BigInt.from(simplifiedDen));

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RRational(
          BigInt.from(numerator), BigInt.from(denominator)), // Non simplifié
      RRational(BigInt.from(a * c), BigInt.from(b * d + 1)), // Dénominateur +1
      RRational(BigInt.from(a * c + 1), BigInt.from(b * d)), // Numérateur +1
      RRational(BigInt.from(a + c),
          BigInt.from(b + d)), // Addition des numérateurs/dénominateurs
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraNum = random.nextInt(20) + 1;
      final extraDen = random.nextInt(20) + 1;
      final extra = RRational(BigInt.from(extraNum), BigInt.from(extraDen));
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
      id: 'fraction_mult_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b, 'c': c, 'd': d},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'fraction_multiplication',
        'operation': 'multiplication',
        'difficulty': 'intermediate',
        'involves_fractions': true,
      },
    );
  }

  /// Division de fractions: (a/b) ÷ (c/d) = (a×d)/(b×c)
  QuizItemExact genFractionDivision({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des fractions simples
    final a = random.nextInt(8) + 2; // 2-9
    final b = random.nextInt(8) + 2; // 2-9
    final c = random.nextInt(8) + 2; // 2-9
    final d = random.nextInt(8) + 2; // 2-9

    // Calculer le résultat
    final numerator = a * d;
    final denominator = b * c;

    // Simplifier la fraction
    final gcd = _gcd(numerator, denominator);
    final simplifiedNum = numerator ~/ gcd;
    final simplifiedDen = denominator ~/ gcd;

    final left = '\\frac{$a}{$b} \\div \\frac{$c}{$d}';
    final result =
        RRational(BigInt.from(simplifiedNum), BigInt.from(simplifiedDen));

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RRational(
          BigInt.from(numerator), BigInt.from(denominator)), // Non simplifié
      RRational(BigInt.from(a * c),
          BigInt.from(b * d)), // Multiplication au lieu de division
      RRational(BigInt.from(a + c),
          BigInt.from(b + d)), // Addition des numérateurs/dénominateurs
      RRational(BigInt.from(a - c),
          BigInt.from(b - d)), // Soustraction des numérateurs/dénominateurs
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraNum = random.nextInt(20) + 1;
      final extraDen = random.nextInt(20) + 1;
      final extra = RRational(BigInt.from(extraNum), BigInt.from(extraDen));
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
      id: 'fraction_div_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b, 'c': c, 'd': d},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'fraction_division',
        'operation': 'division',
        'difficulty': 'intermediate',
        'involves_fractions': true,
      },
    );
  }

  /// Multiplication de radicaux: √a × √b = √(a×b)
  QuizItemExact genRadicalMultiplication({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des radicaux simples
    final a = random.nextInt(10) + 2; // 2-11
    final b = random.nextInt(10) + 2; // 2-11

    // Calculer le résultat
    final product = a * b;

    // Extraire les carrés parfaits
    final simplified = _simplifyRadical(product);

    final left = '\\sqrt{$a} \\times \\sqrt{$b}';
    final result = RRadical(
        Coeff(BigInt.from(simplified.coefficient)), simplified.radicand);

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RRadical(Coeff(BigInt.one), product), // Non simplifié
      RRadical(Coeff(BigInt.one), a + b), // Addition au lieu de multiplication
      RRadical(
          Coeff(BigInt.one), a - b), // Soustraction au lieu de multiplication
      RRadical(Coeff(BigInt.one), a * b + 1), // Produit +1
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extraCoeff = random.nextInt(5) + 1;
      final extraRad = random.nextInt(20) + 2;
      final extra = RRadical(Coeff(BigInt.from(extraCoeff)), extraRad);
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
      id: 'radical_mult_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'radical_multiplication',
        'operation': 'multiplication',
        'difficulty': 'intermediate',
        'involves_radicals': true,
      },
    );
  }

  /// Division d'entiers : a ÷ b = c
  QuizItemExact genDivisionEntiers({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des divisions simples
    final divisor = random.nextInt(8) + 2; // 2-9
    final quotient = random.nextInt(8) + 2; // 2-9
    final dividend = divisor * quotient; // Résultat exact

    final left = '$dividend \\div $divisor';
    final result = RInt(quotient);

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RInt(dividend), // Le dividende au lieu du quotient
      RInt(divisor), // Le diviseur au lieu du quotient
      RInt(dividend + divisor), // Somme au lieu de quotient
      RInt(dividend - divisor), // Différence au lieu de quotient
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(20) + 1);
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
      id: 'division_entiers_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'dividend': dividend, 'divisor': divisor},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'division_entiers',
        'operation': 'division',
        'difficulty': 'intermediate',
        'involves_integers': true,
      },
    );
  }

  /// Puissance simple : a^n = b
  QuizItemExact genPuissanceSimple({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des puissances simples
    final base = random.nextInt(8) + 2; // 2-9
    final exponent = random.nextInt(4) + 2; // 2-5
    final result = RInt(math.pow(base, exponent).toInt());

    final left = '$base^{$exponent}';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RInt(base), // La base au lieu du résultat
      RInt(exponent), // L'exposant au lieu du résultat
      RInt(base * exponent), // Multiplication au lieu de puissance
      RInt(base + exponent), // Addition au lieu de puissance
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(100) + 1);
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
      id: 'puissance_simple_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'base': base, 'exponent': exponent},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'puissance_simple',
        'operation': 'power',
        'difficulty': 'intermediate',
        'involves_powers': true,
      },
    );
  }

  /// Combinaisons simples : (n k) = n!/(k!(n-k)!)
  QuizItemExact genCombinationsSimple({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer des combinaisons simples
    final n = random.nextInt(8) + 5; // 5-12
    final k = random.nextInt(3) + 2; // 2-4

    // Calcul simple de C(n,k)
    int combination = 1;
    for (int i = 0; i < k; i++) {
      combination = combination * (n - i) ~/ (i + 1);
    }

    final result = RInt(combination);
    final left = '\\binom{$n}{$k}';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RInt(n), // n au lieu de C(n,k)
      RInt(k), // k au lieu de C(n,k)
      RInt(n * k), // n*k au lieu de C(n,k)
      RInt(n + k), // n+k au lieu de C(n,k)
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(50) + 1);
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
      id: 'combination_simple_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'n': n, 'k': k},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'combination_simple',
        'operation': 'combination',
        'difficulty': 'advanced',
        'involves_combinations': true,
      },
    );
  }

  /// Trigonométrie simple : sin, cos, tan avec valeurs exactes
  QuizItemExact genTrigonometryCircle({int numberOfResults = 5}) {
    final random = math.Random();

    // Angles avec valeurs exactes connues (en radians)
    final angleData = [
      {'angle': 0, 'rad': 0, 'sin': 0, 'cos': 1, 'tan': 0},
      {'angle': 30, 'rad': 'π/6', 'sin': '1/2', 'cos': '√3/2', 'tan': '√3/3'},
      {'angle': 45, 'rad': 'π/4', 'sin': '√2/2', 'cos': '√2/2', 'tan': 1},
      {'angle': 60, 'rad': 'π/3', 'sin': '√3/2', 'cos': '1/2', 'tan': '√3'},
      {'angle': 90, 'rad': 'π/2', 'sin': 1, 'cos': 0, 'tan': '∞'},
      {'angle': 120, 'rad': '2π/3', 'sin': '√3/2', 'cos': '-1/2', 'tan': '-√3'},
      {'angle': 135, 'rad': '3π/4', 'sin': '√2/2', 'cos': '-√2/2', 'tan': -1},
      {
        'angle': 150,
        'rad': '5π/6',
        'sin': '1/2',
        'cos': '-√3/2',
        'tan': '-√3/3'
      },
      {'angle': 180, 'rad': 'π', 'sin': 0, 'cos': -1, 'tan': 0},
    ];

    final selectedAngle = angleData[random.nextInt(angleData.length)];
    final function = ['sin', 'cos', 'tan'][random.nextInt(3)];

    // Obtenir la valeur exacte
    String exactValue;
    String left;

    switch (function) {
      case 'sin':
        exactValue = selectedAngle['sin'].toString();
        left = '\\sin(${selectedAngle['angle']}°)';
        break;
      case 'cos':
        exactValue = selectedAngle['cos'].toString();
        left = '\\cos(${selectedAngle['angle']}°)';
        break;
      case 'tan':
        exactValue = selectedAngle['tan'].toString();
        left = '\\tan(${selectedAngle['angle']}°)';
        break;
      default:
        exactValue = '0';
        left = '\\sin(0°)';
    }

    // Convertir en RRational pour les calculs
    RRational result;
    if (exactValue == '∞') {
      // Pour tan(90°), utiliser un grand nombre
      result = RRational(BigInt.from(999999), BigInt.one);
    } else if (exactValue == '1') {
      result = RRational(BigInt.one, BigInt.one);
    } else if (exactValue == '0') {
      result = RRational(BigInt.zero, BigInt.one);
    } else if (exactValue == '-1') {
      result = RRational(BigInt.from(-1), BigInt.one);
    } else if (exactValue == '1/2') {
      result = RRational(BigInt.one, BigInt.from(2));
    } else if (exactValue == '-1/2') {
      result = RRational(BigInt.from(-1), BigInt.from(2));
    } else if (exactValue == '√2/2') {
      result = RRational(
          BigInt.from(1414), BigInt.from(2000)); // Approximation de √2/2
    } else if (exactValue == '-√2/2') {
      result = RRational(BigInt.from(-1414), BigInt.from(2000));
    } else if (exactValue == '√3/2') {
      result = RRational(
          BigInt.from(1732), BigInt.from(2000)); // Approximation de √3/2
    } else if (exactValue == '-√3/2') {
      result = RRational(BigInt.from(-1732), BigInt.from(2000));
    } else if (exactValue == '√3/3') {
      result = RRational(
          BigInt.from(577), BigInt.from(1000)); // Approximation de √3/3
    } else if (exactValue == '-√3/3') {
      result = RRational(BigInt.from(-577), BigInt.from(1000));
    } else if (exactValue == '√3') {
      result = RRational(
          BigInt.from(1732), BigInt.from(1000)); // Approximation de √3
    } else if (exactValue == '-√3') {
      result = RRational(BigInt.from(-1732), BigInt.from(1000));
    } else {
      result = RRational(BigInt.zero, BigInt.one);
    }

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: exactValue, // Utiliser la valeur exacte en LaTeX
      value: result,
    ));

    // Distracteurs basés sur les valeurs exactes connues
    final commonValues = [
      RRational(BigInt.zero, BigInt.one), // 0
      RRational(BigInt.one, BigInt.one), // 1
      RRational(BigInt.from(-1), BigInt.one), // -1
      RRational(BigInt.one, BigInt.from(2)), // 1/2
      RRational(BigInt.from(-1), BigInt.from(2)), // -1/2
      RRational(BigInt.from(1414), BigInt.from(2000)), // √2/2
      RRational(BigInt.from(1732), BigInt.from(2000)), // √3/2
      RRational(BigInt.from(577), BigInt.from(1000)), // √3/3
      RRational(BigInt.from(1732), BigInt.from(1000)), // √3
    ];

    for (int i = 0;
        i < commonValues.length && choices.length < numberOfResults;
        i++) {
      final distractor = commonValues[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra =
          RRational(BigInt.from(random.nextInt(20) + 1), BigInt.from(10));
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
      id: 'trigonometry_simple_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'angle': selectedAngle['angle'] as int, 'function': function},
      expected: result,
      answerLatexCanonical: exactValue, // Utiliser la valeur exacte
      choices: choices,
      metadata: {
        'family': 'trigonometry_simple',
        'operation': 'trigonometry',
        'difficulty': 'advanced',
        'involves_trigonometry': true,
        'exact_value': exactValue,
      },
    );
  }

  /// Pourcentages simples : x% de y = z (garantie d'exactitude)
  QuizItemExact genPourcentageSimple({int numberOfResults = 5}) {
    final random = math.Random();

    int number, percentage, result;

    // 50% de chance pour pourcentages < 100%, 50% pour >= 100%
    if (random.nextBool()) {
      // POURCENTAGES < 100% : Logique existante
      final diviseurs100 = [1, 2, 4, 5, 10, 20, 25, 50, 100];
      final entier = random.nextInt(99) + 1; // 1 à 99
      final multiplicateur = diviseurs100[random.nextInt(diviseurs100.length)];

      number = entier * multiplicateur;
      percentage = 100 ~/ multiplicateur;
      result = entier;
    } else {
      // POURCENTAGES >= 100% : (100+p)% avec p tel que le résultat soit entier
      final p = random.nextInt(9) + 1; // p de 1 à 9 (donc 101% à 109%)
      final a = random.nextInt(99) + 1; // a de 1 à 99

      // Calculer le nombre tel que a × (100+p) / 100 soit entier
      // On choisit un nombre qui est multiple de 100 pour simplifier
      number = a * 100; // Multiple de 100
      percentage = 100 + p;
      result = a * (100 + p); // Résultat exact

      // Vérification : result = number × percentage ÷ 100
      // result = (a × 100) × (100 + p) ÷ 100 = a × (100 + p) ✅
    }

    final left = '\\VAR{percentage}\\% \\text{ de } \\VAR{number}';
    final resultValue = RInt(result);

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(resultValue),
      value: resultValue,
    ));

    // Distracteurs pédagogiques
    final distractors = [
      RInt(number), // Le nombre de base
      RInt(percentage), // Le pourcentage
      RInt(number + percentage), // Somme
      RInt(result + 10), // Résultat + 10
      RInt(result - 10), // Résultat - 10
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(1000) + 1);
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
      id: 'pourcentage_simple_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'percentage': percentage, 'number': number},
      expected: resultValue,
      answerLatexCanonical: renderCanonical(resultValue),
      choices: choices,
      metadata: {
        'family': 'pourcentage_simple',
        'operation': 'percentage',
        'difficulty': 'intermediate',
        'involves_percentages': true,
        'pedagogical': true,
      },
    );
  }

  /// Multiplications d'entiers adaptées au niveau éducatif
  QuizItemExact genMultiplicationEntiersAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final random = math.Random();

    // Définir les limites selon le niveau
    int maxTable, maxMultiplier;
    switch (level) {
      case 1: // CP
        maxTable = 2;
        maxMultiplier = 2;
        break;
      case 2: // CE1
        maxTable = 3;
        maxMultiplier = 3;
        break;
      case 3: // CE2
        maxTable = 5;
        maxMultiplier = 5;
        break;
      case 4: // CM1
        maxTable = 7;
        maxMultiplier = 7;
        break;
      case 5: // CM2
        maxTable = 10;
        maxMultiplier = 10;
        break;
      case 6: // 6ème
        maxTable = 10;
        maxMultiplier = 10;
        break;
      case 7: // 5ème
        maxTable = 11;
        maxMultiplier = 11;
        break;
      case 8: // 4ème
        maxTable = 11;
        maxMultiplier = 11;
        break;
      case 9: // 3ème
        maxTable = 12;
        maxMultiplier = 12;
        break;
      case 10: // Seconde
        maxTable = 13;
        maxMultiplier = 13;
        break;
      case 11: // 1ère
        maxTable = 14;
        maxMultiplier = 14;
        break;
      case 12: // Terminale
        maxTable = 15;
        maxMultiplier = 15;
        break;
      default: // Bac+1, Bac+2
        maxTable = 10;
        maxMultiplier = 20;
        break;
    }

    final a = random.nextInt(maxTable) + 1;
    final b = random.nextInt(maxMultiplier) + 1;
    final product = a * b;

    final result = RInt(product);
    final left = '$a \\times $b';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs adaptés au niveau
    final distractors = <RInt>[];

    if (level <= 3) {
      // CP-CE2 : Distracteurs simples
      distractors.addAll([
        RInt(product + a), // Table suivante
        RInt(product - a), // Table précédente
        RInt(a + b), // Addition au lieu de multiplication
        RInt(a * (b + 1)), // Multiplicateur +1
      ]);
    } else if (level <= 6) {
      // CM1-6ème : Distracteurs intermédiaires
      distractors.addAll([
        RInt(product + a), // Table suivante
        RInt(product - a), // Table précédente
        RInt(a + b), // Addition
        RInt(a * (b + 1)), // Multiplicateur +1
        RInt((a + 1) * b), // Table +1
        RInt(a * b + 1), // Résultat +1
      ]);
    } else {
      // 5ème et plus : Distracteurs avancés
      distractors.addAll([
        RInt(product + a), // Table suivante
        RInt(product - a), // Table précédente
        RInt(a + b), // Addition
        RInt(a * (b + 1)), // Multiplicateur +1
        RInt((a + 1) * b), // Table +1
        RInt(a * b + 1), // Résultat +1
        RInt(a * b - 1), // Résultat -1
        RInt((a - 1) * b), // Table -1
      ]);
    }

    // Ajouter les distracteurs
    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (distractor.k > BigInt.zero &&
          !choices.any(
              (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(product + 50) + 1);
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
        'family': 'multiplication_entiers',
        'operation': 'multiplication_entiers',
        'difficulty': 'adaptive',
        'level': level,
        'max_table': maxTable,
        'max_multiplier': maxMultiplier,
      },
    );
  }

  /// Addition d'entiers adaptée au niveau éducatif
  QuizItemExact genAdditionEntiersAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final random = math.Random();

    // Définir les limites selon le niveau
    int maxA, maxB;
    switch (level) {
      case 1: // CP
        maxA = 5;
        maxB = 5;
        break;
      case 2: // CE1
        maxA = 10;
        maxB = 10;
        break;
      case 3: // CE2
        maxA = 20;
        maxB = 20;
        break;
      case 4: // CM1
        maxA = 50;
        maxB = 50;
        break;
      case 5: // CM2
        maxA = 100;
        maxB = 100;
        break;
      case 6: // 6ème
        maxA = 200;
        maxB = 200;
        break;
      case 7: // 5ème
        maxA = 500;
        maxB = 500;
        break;
      case 8: // 4ème
        maxA = 1000;
        maxB = 1000;
        break;
      case 9: // 3ème
        maxA = 2000;
        maxB = 2000;
        break;
      case 10: // Seconde
        maxA = 5000;
        maxB = 5000;
        break;
      case 11: // 1ère
        maxA = 10000;
        maxB = 10000;
        break;
      case 12: // Terminale
        maxA = 20000;
        maxB = 20000;
        break;
      default: // Bac+1, Bac+2
        maxA = 50000;
        maxB = 50000;
        break;
    }

    final a = random.nextInt(maxA) + 1;
    final b = random.nextInt(maxB) + 1;
    final sum = a + b;

    final result = RInt(sum);
    final left = '$a + $b';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs adaptés au niveau
    final distractors = <RInt>[];

    if (level <= 3) {
      // CP-CE2 : Distracteurs simples
      distractors.addAll([
        RInt(sum + 1), // Résultat +1
        RInt(sum - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b + 1), // Addition +1
      ]);
    } else if (level <= 6) {
      // CM1-6ème : Distracteurs intermédiaires
      distractors.addAll([
        RInt(sum + 1), // Résultat +1
        RInt(sum - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b + 1), // Addition +1
        RInt(a + b - 1), // Addition -1
        RInt(a * 2), // Premier nombre ×2
        RInt(b * 2), // Deuxième nombre ×2
      ]);
    } else {
      // 5ème et plus : Distracteurs avancés
      distractors.addAll([
        RInt(sum + 1), // Résultat +1
        RInt(sum - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b + 1), // Addition +1
        RInt(a + b - 1), // Addition -1
        RInt(a * 2), // Premier nombre ×2
        RInt(b * 2), // Deuxième nombre ×2
        RInt(sum + 10), // Résultat +10
        RInt(sum - 10), // Résultat -10
        RInt(a + b + a), // a + b + a
        RInt(a + b + b), // a + b + b
      ]);
    }

    // Ajouter les distracteurs
    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (distractor.k > BigInt.zero &&
          !choices.any(
              (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(sum + 100) + 1);
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
      id: 'addition_adaptive_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'addition_entiers',
        'operation': 'addition_entiers',
        'difficulty': 'adaptive',
        'level': level,
        'max_a': maxA,
        'max_b': maxB,
      },
    );
  }

  /// Soustraction d'entiers adaptée au niveau éducatif
  QuizItemExact genSoustractionEntiersAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final random = math.Random();

    // Définir les limites selon le niveau
    int maxA, maxB;
    switch (level) {
      case 1: // CP
        maxA = 10;
        maxB = 5;
        break; // Résultat positif garanti
      case 2: // CE1
        maxA = 20;
        maxB = 10;
        break;
      case 3: // CE2
        maxA = 50;
        maxB = 20;
        break;
      case 4: // CM1
        maxA = 100;
        maxB = 50;
        break;
      case 5: // CM2
        maxA = 200;
        maxB = 100;
        break;
      case 6: // 6ème
        maxA = 500;
        maxB = 200;
        break;
      case 7: // 5ème
        maxA = 1000;
        maxB = 500;
        break;
      case 8: // 4ème
        maxA = 2000;
        maxB = 1000;
        break;
      case 9: // 3ème
        maxA = 5000;
        maxB = 2000;
        break;
      case 10: // Seconde
        maxA = 10000;
        maxB = 5000;
        break;
      case 11: // 1ère
        maxA = 20000;
        maxB = 10000;
        break;
      case 12: // Terminale
        maxA = 50000;
        maxB = 20000;
        break;
      default: // Bac+1, Bac+2
        maxA = 100000;
        maxB = 50000;
        break;
    }

    // Générer a et b pour que a >= b (résultat positif)
    final a = random.nextInt(maxA) + maxB; // Garantir a >= maxB
    final b = random.nextInt(maxB) + 1;
    final difference = a - b;

    final result = RInt(difference);
    final left = '$a - $b';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs adaptés au niveau
    final distractors = <RInt>[];

    if (level <= 3) {
      // CP-CE2 : Distracteurs simples
      distractors.addAll([
        RInt(difference + 1), // Résultat +1
        RInt(difference - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b), // Addition au lieu de soustraction
        RInt(a - b + 1), // Soustraction +1
      ]);
    } else if (level <= 6) {
      // CM1-6ème : Distracteurs intermédiaires
      distractors.addAll([
        RInt(difference + 1), // Résultat +1
        RInt(difference - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b), // Addition au lieu de soustraction
        RInt(a - b + 1), // Soustraction +1
        RInt(a - b - 1), // Soustraction -1
        RInt(a * 2 - b), // Premier nombre ×2 - deuxième
        RInt(a - b * 2), // Premier - deuxième ×2
      ]);
    } else {
      // 5ème et plus : Distracteurs avancés
      distractors.addAll([
        RInt(difference + 1), // Résultat +1
        RInt(difference - 1), // Résultat -1
        RInt(a), // Premier nombre
        RInt(b), // Deuxième nombre
        RInt(a + b), // Addition au lieu de soustraction
        RInt(a - b + 1), // Soustraction +1
        RInt(a - b - 1), // Soustraction -1
        RInt(a * 2 - b), // Premier nombre ×2 - deuxième
        RInt(a - b * 2), // Premier - deuxième ×2
        RInt(difference + 10), // Résultat +10
        RInt(difference - 10), // Résultat -10
        RInt(a - b + a), // a - b + a
        RInt(a - b - b), // a - b - b
      ]);
    }

    // Ajouter les distracteurs
    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (distractor.k > BigInt.zero &&
          !choices.any(
              (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(difference + 100) + 1);
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
        'family': 'soustraction_entiers',
        'operation': 'soustraction_entiers',
        'difficulty': 'adaptive',
        'level': level,
        'max_a': maxA,
        'max_b': maxB,
      },
    );
  }

  /// Trigonométrie adaptée au niveau éducatif
  QuizItemExact genTrigonometryAdaptive(
      {int numberOfResults = 5, int level = 1}) {
    final random = math.Random();

    // Définir les angles disponibles selon le niveau
    List<Map<String, dynamic>> availableAngles;

    if (level <= 7) {
      // CP à 4ème : Pas de trigonométrie
      // Fallback vers additions simples
      return genAdditionEntiersAdaptive(
          numberOfResults: numberOfResults, level: level);
    } else if (level <= 11) {
      // Seconde à 1ère : Angles de base
      availableAngles = [
        {'angle': 0, 'rad': '0', 'sin': 0, 'cos': 1, 'tan': 0},
        {
          'angle': 30,
          'rad': '\\pi/6',
          'sin': '1/2',
          'cos': '\\sqrt{3}/2',
          'tan': '\\sqrt{3}/3'
        },
        {
          'angle': 45,
          'rad': '\\pi/4',
          'sin': '\\sqrt{2}/2',
          'cos': '\\sqrt{2}/2',
          'tan': '1'
        },
        {
          'angle': 60,
          'rad': '\\pi/3',
          'sin': '\\sqrt{3}/2',
          'cos': '1/2',
          'tan': '\\sqrt{3}'
        },
        {'angle': 90, 'rad': '\\pi/2', 'sin': 1, 'cos': 0, 'tan': '\\infty'},
      ];
    } else if (level <= 12) {
      // Terminale : Angles étendus
      availableAngles = [
        {'angle': 0, 'rad': '0', 'sin': 0, 'cos': 1, 'tan': 0},
        {
          'angle': 30,
          'rad': '\\pi/6',
          'sin': '1/2',
          'cos': '\\sqrt{3}/2',
          'tan': '\\sqrt{3}/3'
        },
        {
          'angle': 45,
          'rad': '\\pi/4',
          'sin': '\\sqrt{2}/2',
          'cos': '\\sqrt{2}/2',
          'tan': '1'
        },
        {
          'angle': 60,
          'rad': '\\pi/3',
          'sin': '\\sqrt{3}/2',
          'cos': '1/2',
          'tan': '\\sqrt{3}'
        },
        {'angle': 90, 'rad': '\\pi/2', 'sin': 1, 'cos': 0, 'tan': '\\infty'},
        {
          'angle': 120,
          'rad': '2\\pi/3',
          'sin': '\\sqrt{3}/2',
          'cos': '-1/2',
          'tan': '-\\sqrt{3}'
        },
        {
          'angle': 135,
          'rad': '3\\pi/4',
          'sin': '\\sqrt{2}/2',
          'cos': '-\\sqrt{2}/2',
          'tan': '-1'
        },
        {
          'angle': 150,
          'rad': '5\\pi/6',
          'sin': '1/2',
          'cos': '-\\sqrt{3}/2',
          'tan': '-\\sqrt{3}/3'
        },
        {'angle': 180, 'rad': '\\pi', 'sin': 0, 'cos': -1, 'tan': 0},
      ];
    } else {
      // Bac+ : Tous les angles
      availableAngles = [
        {'angle': 0, 'rad': '0', 'sin': 0, 'cos': 1, 'tan': 0},
        {
          'angle': 30,
          'rad': '\\pi/6',
          'sin': '1/2',
          'cos': '\\sqrt{3}/2',
          'tan': '\\sqrt{3}/3'
        },
        {
          'angle': 45,
          'rad': '\\pi/4',
          'sin': '\\sqrt{2}/2',
          'cos': '\\sqrt{2}/2',
          'tan': '1'
        },
        {
          'angle': 60,
          'rad': '\\pi/3',
          'sin': '\\sqrt{3}/2',
          'cos': '1/2',
          'tan': '\\sqrt{3}'
        },
        {'angle': 90, 'rad': '\\pi/2', 'sin': 1, 'cos': 0, 'tan': '\\infty'},
        {
          'angle': 120,
          'rad': '2\\pi/3',
          'sin': '\\sqrt{3}/2',
          'cos': '-1/2',
          'tan': '-\\sqrt{3}'
        },
        {
          'angle': 135,
          'rad': '3\\pi/4',
          'sin': '\\sqrt{2}/2',
          'cos': '-\\sqrt{2}/2',
          'tan': '-1'
        },
        {
          'angle': 150,
          'rad': '5\\pi/6',
          'sin': '1/2',
          'cos': '-\\sqrt{3}/2',
          'tan': '-\\sqrt{3}/3'
        },
        {'angle': 180, 'rad': '\\pi', 'sin': 0, 'cos': -1, 'tan': 0},
        {
          'angle': 210,
          'rad': '7\\pi/6',
          'sin': '-1/2',
          'cos': '-\\sqrt{3}/2',
          'tan': '\\sqrt{3}/3'
        },
        {
          'angle': 225,
          'rad': '5\\pi/4',
          'sin': '-\\sqrt{2}/2',
          'cos': '-\\sqrt{2}/2',
          'tan': '1'
        },
        {
          'angle': 240,
          'rad': '4\\pi/3',
          'sin': '-\\sqrt{3}/2',
          'cos': '-1/2',
          'tan': '\\sqrt{3}'
        },
        {'angle': 270, 'rad': '3\\pi/2', 'sin': -1, 'cos': 0, 'tan': '\\infty'},
        {
          'angle': 300,
          'rad': '5\\pi/3',
          'sin': '-\\sqrt{3}/2',
          'cos': '1/2',
          'tan': '-\\sqrt{3}'
        },
        {
          'angle': 315,
          'rad': '7\\pi/4',
          'sin': '-\\sqrt{2}/2',
          'cos': '\\sqrt{2}/2',
          'tan': '-1'
        },
        {
          'angle': 330,
          'rad': '11\\pi/6',
          'sin': '-1/2',
          'cos': '\\sqrt{3}/2',
          'tan': '-\\sqrt{3}/3'
        },
      ];
    }

    // Sélectionner une fonction trigonométrique selon le niveau
    List<String> availableFunctions;
    if (level <= 11) {
      // Seconde à 1ère : sin et cos seulement
      availableFunctions = ['sin', 'cos'];
    } else {
      // Terminale et plus : sin, cos, tan
      availableFunctions = ['sin', 'cos', 'tan'];
    }

    final function =
        availableFunctions[random.nextInt(availableFunctions.length)];
    final selectedAngle =
        availableAngles[random.nextInt(availableAngles.length)];

    // Éviter tan(90°) et tan(270°)
    if (function == 'tan' &&
        (selectedAngle['angle'] == 90 || selectedAngle['angle'] == 270)) {
      return genTrigonometryAdaptive(
          numberOfResults: numberOfResults, level: level);
    }

    final angle = selectedAngle['angle'] as int;
    final rad = selectedAngle['rad'] as String;
    final exactValue = selectedAngle[function];

    // Convertir en RRational pour les calculs
    RRational result;
    if (exactValue == '∞') {
      // Pour tan(90°), utiliser un grand nombre
      result = RRational(BigInt.from(999999), BigInt.one);
    } else if (exactValue == 1) {
      result = RRational(BigInt.one, BigInt.one);
    } else if (exactValue == 0) {
      result = RRational(BigInt.zero, BigInt.one);
    } else if (exactValue == -1) {
      result = RRational(BigInt.from(-1), BigInt.one);
    } else if (exactValue == '1/2') {
      result = RRational(BigInt.one, BigInt.from(2));
    } else if (exactValue == '-1/2') {
      result = RRational(BigInt.from(-1), BigInt.from(2));
    } else if (exactValue == '√2/2') {
      result = RRational(
          BigInt.from(1414), BigInt.from(2000)); // Approximation de √2/2
    } else if (exactValue == '-√2/2') {
      result = RRational(BigInt.from(-1414), BigInt.from(2000));
    } else if (exactValue == '√3/2') {
      result = RRational(
          BigInt.from(1732), BigInt.from(2000)); // Approximation de √3/2
    } else if (exactValue == '-√3/2') {
      result = RRational(BigInt.from(-1732), BigInt.from(2000));
    } else if (exactValue == '√3/3') {
      result = RRational(
          BigInt.from(577), BigInt.from(1000)); // Approximation de √3/3
    } else if (exactValue == '-√3/3') {
      result = RRational(BigInt.from(-577), BigInt.from(1000));
    } else if (exactValue == '√3') {
      result = RRational(
          BigInt.from(1732), BigInt.from(1000)); // Approximation de √3
    } else if (exactValue == '-√3') {
      result = RRational(BigInt.from(-1732), BigInt.from(1000));
    } else {
      result = RRational(BigInt.zero, BigInt.one);
    }

    final left = '\\$function(${angle}°)';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs adaptés au niveau
    final distractors = <RRational>[];

    if (level <= 11) {
      // Seconde à 1ère : Distracteurs simples
      distractors.addAll([
        RRational(BigInt.zero, BigInt.one), // 0
        RRational(BigInt.one, BigInt.one), // 1
        RRational(BigInt.from(-1), BigInt.one), // -1
        RRational(BigInt.one, BigInt.from(2)), // 1/2
        RRational(BigInt.from(-1), BigInt.from(2)), // -1/2
      ]);
    } else {
      // Terminale et plus : Distracteurs avancés
      distractors.addAll([
        RRational(BigInt.zero, BigInt.one), // 0
        RRational(BigInt.one, BigInt.one), // 1
        RRational(BigInt.from(-1), BigInt.one), // -1
        RRational(BigInt.one, BigInt.from(2)), // 1/2
        RRational(BigInt.from(-1), BigInt.from(2)), // -1/2
        RRational(BigInt.from(1414), BigInt.from(2000)), // √2/2
        RRational(BigInt.from(1732), BigInt.from(2000)), // √3/2
        RRational(BigInt.from(577), BigInt.from(1000)), // √3/3
        RRational(BigInt.from(1732), BigInt.from(1000)), // √3
      ]);
    }

    // Ajouter les distracteurs
    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (distractor != result &&
          !choices.any(
              (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra =
          RRational(BigInt.from(random.nextInt(20) + 1), BigInt.from(10));
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
      id: 'trigonometry_adaptive_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'angle': angle, 'rad': rad},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'trigonometry_operations',
        'operation': 'trigonometry_simple',
        'difficulty': 'adaptive',
        'level': level,
        'function': function,
        'angle': angle,
      },
    );
  }

  /// Factoriels simples : n! = n × (n-1) × ... × 1
  QuizItemExact genFactorialSimple({int numberOfResults = 5}) {
    final random = math.Random();

    // Générer un nombre entre 3 et 8 (factorials raisonnables)
    final n = random.nextInt(6) + 3; // 3 à 8

    // Calculer n!
    int factorial = 1;
    for (int i = 2; i <= n; i++) {
      factorial *= i;
    }

    final result = RInt(factorial);
    final left = '$n!';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: renderCanonical(result),
      value: result,
    ));

    // Distracteurs
    final distractors = [
      RInt(n), // n au lieu de n!
      RInt(n * (n - 1)), // n(n-1) au lieu de n!
      RInt(n + 1), // n+1 au lieu de n!
      RInt(n * n), // n² au lieu de n!
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      if (!choices.any(
          (c) => renderCanonical(c.value) == renderCanonical(distractor))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: renderCanonical(distractor),
          value: distractor,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RInt(random.nextInt(100) + 1);
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
      id: 'factorial_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'n': n},
      expected: result,
      answerLatexCanonical: renderCanonical(result),
      choices: choices,
      metadata: {
        'family': 'factorial_operations',
        'operation': 'factorial_simple',
        'difficulty': 'intermediate',
        'n': n,
      },
    );
  }

  /// Multiplication de logarithmes népériens : ln(e^p) × ln(rational) = ?
  QuizItemExact genLogarithmMultiplication({int numberOfResults = 5}) {
    final random = math.Random();

    // Cas qui "tombent justes" : ln(e^p) × ln(rational)
    final cases = [
      {
        'a': 'e^1',
        'a_val': math.e,
        'b': '2',
        'b_val': 2.0,
        'result': 1.0,
        'display': '\\ln(2)'
      }, // ln(e) × ln(2) = ln(2)
      {
        'a': 'e^2',
        'a_val': math.e * math.e,
        'b': '3',
        'b_val': 3.0,
        'result': 2.0 * math.log(3),
        'display': '2\\ln(3)'
      }, // ln(e²) × ln(3) = 2ln(3)
      {
        'a': 'e^1',
        'a_val': math.e,
        'b': '4',
        'b_val': 4.0,
        'result': 1.0 * math.log(4),
        'display': '\\ln(4)'
      }, // ln(e) × ln(4) = ln(4)
      {
        'a': 'e^3',
        'a_val': math.pow(math.e, 3),
        'b': '2',
        'b_val': 2.0,
        'result': 3.0 * math.log(2),
        'display': '3\\ln(2)'
      }, // ln(e³) × ln(2) = 3ln(2)
      {
        'a': 'e^1',
        'a_val': math.e,
        'b': '8',
        'b_val': 8.0,
        'result': 1.0 * math.log(8),
        'display': '\\ln(8)'
      }, // ln(e) × ln(8) = ln(8)
    ];

    final selectedCase = cases[random.nextInt(cases.length)];
    final a = selectedCase['a'] as String;
    final b = selectedCase['b'] as String;
    final resultValue = selectedCase['result'] as double;
    final displayResult = selectedCase['display'] as String;

    // Convertir en RRational avec précision raisonnable
    final roundedResult = (resultValue * 1000).round() / 1000;
    final result = RRational(
        BigInt.from((roundedResult * 1000).round()), BigInt.from(1000));

    final left = '\\ln($a) \\times \\ln($b)';

    // Générer des choix
    final choices = <QuizChoiceExact>[];

    // Résultat correct (affichage simplifié)
    choices.add(QuizChoiceExact(
      id: 'correct',
      latex: displayResult, // Utiliser l'affichage simplifié
      value: result,
    ));

    // Distracteurs pédagogiques
    final distractors = [
      {
        'latex': '\\ln(e)',
        'value': RRational(BigInt.one, BigInt.one)
      }, // ln(e) = 1
      {
        'latex': '\\ln(e^2)',
        'value': RRational(BigInt.from(2), BigInt.one)
      }, // ln(e²) = 2
      {
        'latex': '\\ln(e^3)',
        'value': RRational(BigInt.from(3), BigInt.one)
      }, // ln(e³) = 3
      {
        'latex': '\\ln(2)',
        'value': RRational(
            BigInt.from((math.log(2) * 1000).round()), BigInt.from(1000))
      }, // ln(2) seul
    ];

    for (int i = 0;
        i < distractors.length && choices.length < numberOfResults;
        i++) {
      final distractor = distractors[i];
      final distractorValue = distractor['value'] as RRational;
      if (!choices.any((c) =>
          renderCanonical(c.value) == renderCanonical(distractorValue))) {
        choices.add(QuizChoiceExact(
          id: 'distractor_$i',
          latex: distractor['latex'] as String,
          value: distractorValue,
        ));
      }
    }

    // Compléter si nécessaire
    while (choices.length < numberOfResults) {
      final extra = RRational(BigInt.from(random.nextInt(20) + 1), BigInt.one);
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
      id: 'logarithm_multiplication_${DateTime.now().microsecondsSinceEpoch}',
      leftLatex: left,
      variables: {'a': a, 'b': b, 'case_type': 'exact'},
      expected: result,
      answerLatexCanonical: displayResult, // Utiliser l'affichage simplifié
      choices: choices,
      metadata: {
        'family': 'logarithm_multiplication',
        'operation': 'logarithm_multiplication',
        'difficulty': 'advanced',
        'involves_logarithms': true,
        'exact_case': true,
        'pedagogical': true,
      },
    );
  }
}

/// 🛠️ FONCTIONS UTILITAIRES POUR THEMA OPERATIONS

/// Calcul du PGCD de deux entiers
int _gcd(int a, int b) {
  while (b != 0) {
    final temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

/// Simplification d'un radical
({int coefficient, int radicand}) _simplifyRadical(int n) {
  int coefficient = 1;
  int radicand = n;

  // Extraire les carrés parfaits
  for (int i = 2; i * i <= n; i++) {
    while (radicand % (i * i) == 0) {
      coefficient *= i;
      radicand ~/= (i * i);
    }
  }

  return (coefficient: coefficient, radicand: radicand);
}
