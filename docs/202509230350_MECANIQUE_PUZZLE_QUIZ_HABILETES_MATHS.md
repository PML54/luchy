# 🧮 MÉCANIQUE TECHNIQUE DU PUZZLE QUIZ "HABILETÉ MATHS"

## 📋 ARCHITECTURE GÉNÉRALE

Le puzzle quiz "Habileté Maths" fonctionne selon un **modèle de correspondance par glisser-déposer** entre des questions mathématiques (colonne gauche) et leurs résultats (colonne droite mélangée).

## 🏗️ STRUCTURE DE DONNÉES FONDAMENTALE

### 1. Variables d'État Principales

```dart
class _ModernMathSkillsScreenState {
  List<QuizItemExact> _operations = [];     // Questions mathématiques
  List<String> _results = [];               // Résultats LaTeX canoniques
  List<int> _rightArrangement = [];         // Indices mélangés (colonne droite)
  int _itemCount = 6;                       // Nombre de questions (dynamique)
  bool _showValidation = false;             // Affichage de la validation
  late ProgressionManager _progressionManager; // Gestion de la progression
}
```

### 2. Modèle de Données Quiz

```dart
class QuizItemExact {
  final String questionLatex;           // Expression mathématique (ex: "2 + 3")
  final String answerLatexCanonical;    // Résultat canonique (ex: "5")
  final Res expected;                   // Résultat exact typé (RInt, RRational, etc.)
}
```

## 🔄 CYCLE DE VIE DU QUIZ

### 1. **INITIALISATION** (`initState`)

```dart
@override
void initState() {
  super.initState();
  _progressionManager = ProgressionManager();
  _initializeProgression(); // Charge l'état + génère le premier quiz
}
```

### 2. **GÉNÉRATION DU QUIZ** (`_generateNewQuiz`)

```dart
Future<void> _generateNewQuiz() async {
  List<QuizItemExact> newOperations;
  List<String> newResults;
  
  // BOUCLE ANTI-DOUBLONS : Régénère jusqu'à obtenir des résultats uniques
  do {
    newOperations = await _generateOperationsForLevel(_progressionManager.currentLevel);
    newResults = newOperations.map((op) => op.answerLatexCanonical).toList();
  } while (_hasDuplicateResults(newResults));
  
  setState(() {
    _operations = newOperations;
    _results = newResults;
    
    // MÉLANGE : Seule la colonne droite est mélangée
    final realCount = newOperations.length;
    _rightArrangement = List.generate(realCount, (index) => index);
    _rightArrangement.shuffle(); // ⚡ POINT CLÉ : Mélange aléatoire
    
    _showValidation = false;
    _itemCount = realCount; // Synchronisation avec la taille réelle
  });
}
```

**🔑 PRINCIPE CLÉ** : La colonne gauche (questions) reste dans l'ordre d'origine `[0,1,2,3,4,5]`, seule la colonne droite (résultats) est mélangée via `_rightArrangement`.

### 3. **DÉTECTION DES DOUBLONS** (`_hasDuplicateResults`)

```dart
bool _hasDuplicateResults(List<String> results) {
  final uniqueResults = results.toSet();
  final hasDuplicates = uniqueResults.length != results.length;
  
  if (hasDuplicates) {
    print('🚨 DOUBLONS DÉTECTÉS: $results');
    print('🔄 RÉGÉNÉRATION...');
  }
  
  return hasDuplicates;
}
```

**🛡️ PROTECTION ABSOLUE** : Le système régénère automatiquement si des résultats identiques sont détectés.

## 🎯 SYSTÈME DE GLISSER-DÉPOSER

### 1. **Structure Drag & Drop**

Chaque élément de la colonne droite est à la fois :

- **`Draggable<int>`** : Peut être déplacé (data = index dans `_rightArrangement`)
- **`DragTarget<int>`** : Peut recevoir un autre élément

### 2. **Mécanisme d'Échange** (`onAcceptWithDetails`)

```dart
onAcceptWithDetails: (details) {
  setState(() {
    final draggedIndex = details.data;           // Index de l'élément déplacé
    final temp = _rightArrangement[row];         // Sauvegarde position cible
    final draggedRow = _rightArrangement.indexOf(draggedIndex); // Position source
    
    // ÉCHANGE BIDIRECTIONNEL
    _rightArrangement[row] = draggedIndex;       // Mettre l'élément déplacé
    _rightArrangement[draggedRow] = temp;        // Mettre l'ancien élément
  });
}
```

### 3. **Feedback Visuel**

```dart
feedback: Material(
  elevation: 6,
  borderRadius: BorderRadius.circular(12),
  child: Container(
    width: 120, height: 80,
    decoration: BoxDecoration(
      color: Colors.green.shade200, // Couleur distinctive pendant le drag
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(child: Math.tex(_results[_rightArrangement[row]])),
  ),
)
```

## ✅ SYSTÈME DE VALIDATION

### 1. **Calcul du Score** (`_checkResults`)

```dart
void _checkResults() {
  int correctAnswers = 0;
  
  // VÉRIFICATION : Position dans _rightArrangement == position originale
  for (int i = 0; i < _operations.length; i++) {
    if (_rightArrangement[i] == i) { // 🎯 CONDITION DE RÉUSSITE
      correctAnswers++;
    }
  }
  
  // Validation avec le gestionnaire de progression
  final result = _progressionManager.validateQuiz(correctAnswers, _operations.length);
  
  setState(() => _showValidation = true);
  _showProgressionDialog(result, correctAnswers, _operations.length);
}
```

**🧠 LOGIQUE DE VALIDATION** :

- Question `i` (gauche) ↔ Résultat `_rightArrangement[i]` (droite)
- ✅ **Correct** si `_rightArrangement[i] == i` (résultat à sa position d'origine)
- ❌ **Incorrect** sinon

### 2. **Dialogue de Résultat** (`_showProgressionDialog`)

```dart
void _showProgressionDialog(ValidationResult result, int correctAnswers, int totalQuestions) {
  final message = _progressionManager.getResultMessage(result, correctAnswers, totalQuestions);
  
  showDialog(
    context: context,
    barrierDismissible: false, // ⚠️ Obligatoire de répondre
    builder: (context) => AlertDialog(
      title: _getDialogTitle(result),                    // Titre selon résultat
      content: _buildProgressionIndicator(result),       // Indicateur visuel
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() => _showValidation = false);
            _generateNewQuiz(); // 🔄 NOUVEAU QUIZ automatique
          },
          child: const Text('Continuer'),
        ),
      ],
    ),
  );
}
```

## 🎨 INTERFACE UTILISATEUR

### 1. **Layout Responsif**

```dart
Row(
  children: [
    // COLONNE GAUCHE (1/3) : Questions fixes
    Expanded(
      flex: 2,
      child: Math.tex(_operations[row].questionLatex, ...)
    ),
    
    // COLONNE DROITE (1/3) : Résultats glissables
    Expanded(
      flex: 1,
      child: DragTarget<int>(...) // Système drag & drop
    ),
  ],
)
```

### 2. **Tailles Adaptatives**

```dart
double _getAdaptiveFontSize(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth > 1200) return 24.0;      // Desktop large
  else if (screenWidth > 800) return 20.0;  // Desktop/Tablet
  else if (screenWidth > 600) return 18.0;  // Tablet
  else return 16.0;                         // Mobile
}
```

## 🔒 PROTECTIONS ET SÉCURITÉ

### 1. **Protection IndexError**

```dart
Widget _buildQuizRow(int row) {
  // Vérifications de sécurité
  if (row >= _operations.length || row >= _results.length || 
      row >= _rightArrangement.length) {
    return const SizedBox.shrink(); // Widget vide si données incohérentes
  }
  
  final targetIndex = _rightArrangement[row];
  if (targetIndex >= _results.length) {
    return const CircularProgressIndicator(); // Indicateur de chargement
  }
  
  return /* Construction normale du widget */;
}
```

### 2. **Chargement Asynchrone**

```dart
Widget _buildQuizContent() {
  if (_operations.isEmpty || _results.isEmpty) {
    return const Center(child: CircularProgressIndicator()); // État de chargement
  }
  
  return Column(/* Contenu normal */);
}
```

## 🎨 GÉNÉRATION D'IMAGE ÉDUCATIVE

### 1. **Processus de Création** (`EducationalImageGenerator`)

```dart
// ÉTAPE 1: Génération du contenu texte (questions + réponses)
List<String> leftColumn = ["2 + 3", "4 × 5", "7 - 2"];    // Questions
List<String> rightColumn = ["5", "20", "5"];              // Réponses

// ÉTAPE 2: Mélange éducatif (optionnel)
final shuffleResult = _applyEducationalShuffle(leftColumn, rightColumn);
// → Les deux colonnes sont mélangées de façon identique pour garder correspondance

// ÉTAPE 3: Génération image PNG en mémoire
final imageResult = await generateNamesGridImage(
  left: shuffleResult.shuffledLeft,
  right: shuffleResult.shuffledRight,
  cellWidth: 600,    // Largeur cellule
  cellHeight: 200,   // Hauteur cellule
  leftColumnColor: Colors.blue[100],
  rightColumnColor: Colors.green[100],
);
```

### 2. **Architecture de Génération**

```dart
// Structure du résultat
class EducationalImageResult {
  final Uint8List pngBytes;        // Image PNG générée
  final int rows;                  // Nombre de lignes (= questions)
  final int columns;               // Toujours 2 (gauche/droite)
  final String description;        // Description du quiz
  final List<int>? originalMapping; // Mapping de mélange pour validation
}
```

### 3. **Rendu Graphique** (`dart:ui`)

```dart
// Canvas de rendu natif Flutter
final recorder = ui.PictureRecorder();
final canvas = Canvas(recorder);

// Calcul automatique taille police
double fontSize = initialFontSize;
while (!textFitsInCell && fontSize > minFontSize) {
  fontSize -= 2; // Réduction progressive
}

// Rendu centré de chaque cellule
final textPainter = TextPainter(
  text: TextSpan(text: questionText, style: TextStyle(fontSize: fontSize)),
  textDirection: TextDirection.ltr,
  textAlign: TextAlign.center,
);
textPainter.paint(canvas, cellCenter);
```

### 4. **Intégration dans le Puzzle**

```dart
// Chargement dans ImageController
await ref.read(imageControllerProvider.notifier).loadEducationalImage(
  result.pngBytes,                    // Image générée
  rows: result.rows,                  // Grille puzzle (ex: 6 lignes)
  columns: result.columns,            // Toujours 2 colonnes
  description: result.description,
  puzzleType: 2,                     // Type éducatif
  educationalMapping: result.originalMapping, // Pour validation
);

// Découpage automatique en pièces
final pieces = await createPuzzlePieces(result.pngBytes, columns, rows);
// → Chaque "pièce" = une cellule (question ou réponse)
```

### 5. **Avantages de cette Approche**

- ✅ **Image PNG standard** : Compatible avec tout système d'affichage
- ✅ **Qualité vectorielle** : Texte net à toutes tailles
- ✅ **Mémoire efficace** : Génération à la demande
- ✅ **Responsive** : Auto-adaptation taille police
- ✅ **Réutilisable** : Peut servir pour tout type de quiz

## 🕒 SYSTÈME DE CHRONOMÉTRAGE

### 1. **Gestionnaire de Temps** (`QuizTimer`)

- Chronométrage global du quiz + temps par question individuelle
- Objectifs adaptatifs par niveau éducatif (CP: 8s, Terminale: 12s)
- Interface temps réel non-intrusive dans AppBar
- Sauvegarde automatique performances SQLite

### 2. **Métriques de Performance** (`TimingMetrics`)

```dart
class TimingMetrics {
  final Duration totalTime;           // Temps total du quiz
  final Duration averageQuestionTime; // Temps moyen par question
  final Duration fastestQuestion;     // Question la plus rapide
  final Duration slowestQuestion;     // Question la plus lente
  final List<Duration> questionTimes; // Détail par question
}
```

### 3. **Objectifs Temporels** (`TimingTargets`)

- **CP** : Excellent 8s, Bon 12s, Acceptable 18s
- **CE1-CE2** : Excellent 6s, Bon 10s, Acceptable 15s
- **CM1-CM2** : Excellent 5s, Bon 8s, Acceptable 12s
- **Collège** : Excellent 6-8s, Bon 10-12s, Acceptable 15-18s
- **Lycée** : Excellent 10-12s, Bon 15-20s, Acceptable 25-30s

## 📊 SYSTÈME DE PROGRESSION

### 1. **Gestionnaire de Niveau** (`ProgressionManager`)

- Gestion du niveau éducatif actuel (CP à Bac+2)
- Calcul automatique promotion/redoublement/rétrogradation
- Conversion score → note /20
- Persistance de l'état utilisateur

### 2. **Résultats de Validation**

```dart
enum ValidationResult {
  promoted,     // Promotion au niveau supérieur
  validated,    // Niveau validé, reste au même niveau
  failed,       // Échec, reste au même niveau
  redoublement, // Redoublement (second échec)
  demoted       // Rétrogradation (trop de redoublements)
}
```

## ⚡ WORKFLOW COMPLET TYPE

1. **Lancement** → `initState()` → Chargement progression
2. **Génération** → `_generateNewQuiz()` → Création questions + mélange droite
3. **Interaction** → Glisser-déposer → Mise à jour `_rightArrangement`
4. **Validation** → `_checkResults()` → Calcul score + dialogue
5. **Continuation** → Dialogue fermé → **Retour étape 2**

## 🎯 AVANTAGES DE CETTE MÉCANIQUE

### ✅ **Stabilité**

- Pas de dépendance externe complexe
- Gestion d'erreur robuste
- Protection contre les états incohérents

### ✅ **Flexibilité**

- Taille de quiz dynamique (`_itemCount`)
- Adaptation automatique à différents types de questions
- Support LaTeX complet

### ✅ **Performance**

- Calculs légers (comparaisons d'indices)
- Interface fluide (drag & drop natif Flutter)
- Mémoire optimisée

### ✅ **Évolutivité**

- Ajout facile de nouveaux types de questions
- Intégration simple de nouveaux niveaux
- Extension possible du système de scoring

---

**📅 Dernière modification** : Mar 23 sep 2025 03:48:52 CEST  
**🏷️ Fichier** : `docs/MECANIQUE_PUZZLE_QUIZ_HABILETES_MATHS.md`  
**🎯 Objectif** : Documentation technique complète de la mécanique du puzzle quiz

## 🔄 MISE À JOUR RÉCENTE (23/09/2025)

### ✨ **Nouvelles Fonctionnalités**

- **Système de chronométrage** intégré avec `QuizTimer`
- **Métriques de performance** détaillées par question
- **Objectifs temporels** adaptatifs par niveau éducatif
- **Sauvegarde automatique** des performances en SQLite

### 🔧 **Refactorisation Code**

- **Nouvelles méthodes** : `_generateSpecialiteMaths()` pour Bac+1/Bac+2
- **Optimisation génération** : Refactorisation `_generatePremiere()` et `_generateTerminale()`
- **Import centralisé** : `exact_math_extensions.dart` pour méthodes communes
- **Amélioration formatage** : Code plus lisible et maintenable

### 📊 **Améliorations Techniques**

- **Interface timer** non-intrusive dans AppBar
- **Feedback performance** immédiat après validation
- **Analytics progression** temporelle complète
- **Optimisation structure** pour maintenance future
