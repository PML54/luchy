# 📊 SCHÉMA DE FONCTIONNEMENT - SYSTÈME "HABILETÉ MATHS"

**Date:** 2025-09-08  
**Projet:** Luchy - Application Flutter  
**Module:** Nouveau système de quiz mathématiques  

---

## 🎯 PROCESSUS : CONSTRUCTION PUIS DÉCOUPAGE

**Le quiz puzzle est d'abord entièrement constitué puis découpé/mélangé ensuite.**

---

## 🏗️ ARCHITECTURE GÉNÉRALE

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUX COMPLET DU SYSTÈME                 │
└─────────────────────────────────────────────────────────────────┘

1. GÉNÉRATION → 2. AFFICHAGE → 3. INTERACTION → 4. VALIDATION → 5. RÉSULTATS
```

---

## 🎲 1. GÉNÉRATION DES QUIZ

### Structure de génération

```dart
ModernMathGenerator.generateSimpleQuiz(difficulty: level, numberOfQuestions: 6)
│
├── Pour Niveau 1 (1 chiffre) :
│   └── Génération normale aléatoire (1-9)
│
├── Pour Niveau 2 & 3 (2-3 chiffres) :
│   ├── _generateSameUnitsOperations() → 3 opérations même unité
│   │   ├── Choix chiffre unités (0-9)
│   │   ├── _generateNumberWithTargetUnits() → Premier nombre
│   │   ├── _generateNumberForSum() → Second nombre calculé
│   │   └── Vérification résultat % 10 == chiffre_cible
│   │
│   └── Génération normale pour questions restantes
│
└── Sortie: List<QuizItem> avec variables substituées
```

### Structure QuizItem

```dart
QuizItem {
  id: "add_23_17_timestamp"
  leftLatex: "\\VAR{a} + \\VAR{b}"     // Template
  variables: [Variable(a=23), Variable(b=17)]
  expectedValue: RationalValue(40)
  getCleanLatex(): "23 + 17"          // Rendu final
  metadata: {difficulty: 2, same_units_target: 0}
}
```

---

## 📋 2. PHASE DE CONSTRUCTION (Intégrale)

### Étape 1 : Génération complète du quiz structuré

```dart
_operations = ModernMathGenerator.generateSimpleQuiz(difficulty, 6);

// Résultat : Quiz complet avec paires parfaites
[
  QuizItem { "15 + 7", expectedValue: 22 },     // Paire 0 → 0
  QuizItem { "23 + 18", expectedValue: 41 },    // Paire 1 → 1  
  QuizItem { "34 + 29", expectedValue: 63 },    // Paire 2 → 2
  QuizItem { "45 + 16", expectedValue: 61 },    // Paire 3 → 3
  QuizItem { "52 + 28", expectedValue: 80 },    // Paire 4 → 4
  QuizItem { "67 + 14", expectedValue: 81 }     // Paire 5 → 5
]
```

### Étape 2 : Extraction des résultats (ordre parfait)

```dart
_results = _operations.map(op => op.expectedValue.toString()).toList();
// Résultat : ["22", "41", "63", "61", "80", "81"]
```

---

## ✂️ 3. PHASE DE DÉCOUPAGE/MÉLANGE

### Étape 3 : Création des arrangements (découpage logique)

```dart
_leftArrangement = [0, 1, 2, 3, 4, 5];   // ORDRE FIXE (questions)
_rightArrangement = [0, 1, 2, 3, 4, 5];  // ORDRE À MÉLANGER (réponses)
```

### Étape 4 : Mélange de la colonne droite uniquement

```dart
_rightArrangement.shuffle();
// Résultat possible : [3, 0, 5, 1, 4, 2]
```

---

## 🎭 4. AFFICHAGE FINAL (État "Découpé")

```
┌─────────────────┬─────────────┐
│ GAUCHE (fixe)   │ DROITE      │
│ Position réelle │ Position    │ ← Mélangée !
├─────────────────┼─────────────┤
│ 0: "15 + 7"     │ 3: "61"     │ ← Décalage !
│ 1: "23 + 18"    │ 0: "22"     │ ← Décalage !
│ 2: "34 + 29"    │ 5: "81"     │ ← Décalage !
│ 3: "45 + 16"    │ 1: "41"     │ ← Décalage !
│ 4: "52 + 28"    │ 4: "80"     │ ← Décalage !
│ 5: "67 + 14"    │ 2: "63"     │ ← Décalage !
└─────────────────┴─────────────┘

État initial: Aucune paire ne correspond !
```

---

## 📱 5. AFFICHAGE INTERFACE

### ModernMathSkillsScreen

```dart
void _generateNewQuiz() {
  ├── Appel ModernMathGenerator.generateSimpleQuiz()
  ├── Extraction des résultats: operations.map(op => op.expectedValue)
  ├── _ensureUniqueResults() → Évitement doublons UI
  ├── Initialisation arrangements:
  │   ├── _leftArrangement = [0,1,2,3,4,5] (ordre fixe)
  │   └── _rightArrangement = [0,1,2,3,4,5].shuffle() (mélangé)
  └── setState() → Reconstruction UI
}
```

### Interface 2 colonnes

```
┌─────────────────┬─────────────┐
│ GAUCHE (2/3)    │ DROITE (1/3)│
│ Formules LaTeX  │ Résultats   │
│ [Fixes]         │ [Mobiles]   │
└─────────────────┴─────────────┘
```

---

## 🎮 6. INTERACTION UTILISATEUR

### Colonne gauche (Formules)

```dart
├── GestureDetector.onTap()
├── _showOperationTooltip(context, operation)
├── OverlayEntry avec fond semi-transparent
├── Affichage Math.tex() agrandi + conditions
└── Tap n'importe où → overlayEntry.remove()
```

### Colonne droite (Résultats)

```dart
├── Draggable<int> (data: index_ligne)
│   ├── feedback: Container avec Math.tex() + elevation
│   ├── childWhenDragging: Version grisée
│   └── child: Container normal
│
├── DragTarget<int>
│   ├── onAcceptWithDetails(details)
│   ├── _swapRightItems(index_actuel, details.data)
│   └── setState() → Échange positions dans _rightArrangement
│
└── Rendu conditionnel selon _showValidation:
    ├── Couleurs vert/rouge selon isCorrect
    ├── Icônes ✓/✗ 
    └── Bordures épaisses
```

---

## ✅ 7. VALIDATION ET CONTRÔLE

### Logique de validation

```dart
void _validateAnswers() {
  ├── _showValidation = true
  ├── setState() → Déclenchement rendu validation
  └── _buildValidationOverlay() → Affichage résultats
}

int _getCorrectCount() {
  ├── Parcours de _rightArrangement
  ├── Pour chaque position i: 
  │   └── if (_rightArrangement[i] == i) correctCount++
  ├── Logique: position_actuelle == position_attendue
  └── Return: nombre de bonnes réponses
}
```

### Validation des paires

```dart
// La validation vérifie que les indices correspondent
bool isCorrect = _rightArrangement[row] == row;

// État initial après mélange :
_rightArrangement = [3, 0, 5, 1, 4, 2]
//                   ↑  ↑  ↑  ↑  ↑  ↑
//  Position voulue: [0, 1, 2, 3, 4, 5]
//  
//  row 0: _rightArrangement[0] = 3 ≠ 0 → FAUX ❌
//  row 1: _rightArrangement[1] = 0 ≠ 1 → FAUX ❌  
//  row 2: _rightArrangement[2] = 5 ≠ 2 → FAUX ❌
//  etc...

// État résolu (après drag & drop) :
_rightArrangement = [0, 1, 2, 3, 4, 5]
//  row 0: _rightArrangement[0] = 0 = 0 → VRAI ✅
//  row 1: _rightArrangement[1] = 1 = 1 → VRAI ✅
//  etc...
```

### Rendu conditionnel

```dart
├── isCorrect = _showValidation && _rightArrangement[row] == row
├── Couleur = isCorrect ? Colors.green : Colors.red
├── Icône = isCorrect ? Icons.check : Icons.close
└── Bordure = isCorrect ? vert épais : rouge épais
```

---

## 📊 8. FEEDBACK ET RÉSULTATS

### Overlay de validation

```dart
Widget _buildValidationOverlay() {
  ├── correctCount = _getCorrectCount()
  ├── percentage = (correctCount / _itemCount * 100).toInt()
  ├── Condition: percentage >= 70 ? "🎉 Bravo !" : "💪 Continue !"
  ├── Couleurs: vert si ≥70%, orange sinon
  └── Affichage: "Résultat: X/6 (Y%)"
}
```

### Container positionné en overlay

```
┌─────────────────────────────────┐
│ 🎉 Bravo ! / 💪 Continue !      │
│ Résultat: 4/6 (67%)             │
└─────────────────────────────────┘
```

---

## 🔄 9. CYCLE DE VIE COMPLET

```
Lancement Screen
│
├── initState()
├── _generateNewQuiz() ← Premier chargement
│   ├── Génération 6 QuizItem
│   ├── Shuffle colonne droite
│   └── Affichage initial
│
├── User: Tap "Niveau = X" → _cycleDifficulty()
│   ├── _currentDifficulty = _currentDifficulty.nextLevel
│   └── _generateNewQuiz() ← Régénération
│
├── User: Drag & Drop → _swapRightItems()
│   ├── Échange dans _rightArrangement
│   └── setState() ← Mise à jour visuelle
│
├── User: Tap ✓ → _validateAnswers()
│   ├── _showValidation = true
│   ├── Calcul correctCount
│   └── Affichage overlay résultats
│
└── User: Tap 🔄 → _generateNewQuiz()
    ├── Reset _showValidation = false
    ├── Nouvelles questions
    └── Nouveau shuffle
```

---

## ⚙️ 10. POINTS TECHNIQUES CLÉS

### Gestion d'état

```dart
GESTION D'ÉTAT:
├── _operations: List<QuizItem> (données source)
├── _results: List<String> (résultats extraits)
├── _leftArrangement: List<int> (ordre fixe [0,1,2,3,4,5])
├── _rightArrangement: List<int> (ordre mobile, shuffle)
├── _showValidation: bool (mode validation actif)
└── _currentDifficulty: DifficultyLevel (niveau actuel)
```

### Rendu LaTeX

```dart
RENDU LATEX:
├── Math.tex(operation.getCleanLatex()) ← Substitution variables
├── Math.tex(result) ← Affichage résultats  
├── Polices adaptatives selon MediaQuery.size.width
└── Couleurs conditionnelles selon validation
```

### Drag & Drop

```dart
DRAG & DROP:
├── Draggable<int> avec data = index ligne
├── DragTarget<int> avec onAcceptWithDetails
├── Feedback visuel pendant drag
└── Swap dans _rightArrangement uniquement
```

---

## 💡 11. COMPARAISON AVEC PUZZLE CLASSIQUE

```
PUZZLE IMAGE CLASSIQUE:        PUZZLE HABILETÉ MATHS:
┌─────────────────────┐        ┌─────────────────────┐
│ 1. Photo complète   │   VS   │ 1. Quiz complet     │
│ 2. Découpage 3x3    │        │ 2. Mélange droite   │ 
│ 3. Mélange pièces   │        │ 3. Drag & drop      │
│ 4. Reconstitution   │        │ 4. Réassociation    │
└─────────────────────┘        └─────────────────────┘
```

---

## 📱 12. NAVIGATION VERS LE PUZZLE

### Étapes pour accéder au puzzle

1. **Lancez l'application Luchy** 
   - Vous arrivez sur l'écran principal avec l'interface de puzzle

2. **Cliquez sur le bouton École** 🏫
   - Dans la barre d'outils en haut, il y a une icône `school_outlined`
   - Ce bouton s'appelle "Puzzle Habileté"

3. **Sélectionnez "Habileté Maths"** 
   - Une liste s'ouvre avec tous les types de puzzle habileté
   - Cherchez et cliquez sur **"Habileté Maths"** (avec icône `functions`)

4. **Vous arrivez sur l'écran moderne** ✨
   - Interface avec bouton "Niveau = 1" dans la barre de titre
   - Colonne gauche (formules LaTeX) et colonne droite (résultats à déplacer)

### Interface de navigation

```
┌─────────────────────────────────────────────┐
│ 📷  🏫  [◀ Niveau ▶]     🔄 ✓ ⚙️ ❓        │ ← Barre d'outils
└─────────────────────────────────────────────┘
     ↑
   Bouton École (Puzzle Habileté)
```

### Menu "Puzzle Habileté"

- **Habileté Séries** (ancien système LaTeX)
- **Habileté Numérique** (ancien système)  
- **Habileté Fractions** (ancien système)
- ⭐ **Habileté Maths** (nouveau système moderne) ← **CIBLE**

### Une fois dans "Habileté Maths"

- Bouton **"Niveau = 1"** → cliquez pour passer à 2, puis 3, puis retour à 1
- **Colonne gauche** : Formules (tapez pour voir tooltip)
- **Colonne droite** : Résultats à réorganiser par drag & drop
- **Boutons** : 🔄 (nouvelles questions), ✓ (validation)

---

## 🎯 13. RÉPONSE DIRECTE À LA QUESTION

**OUI**, le processus est exactement :

1. **🏗️ CONSTRUCTION** : Quiz complet avec paires parfaites
2. **✂️ DÉCOUPAGE** : Mélange de la colonne droite uniquement  
3. **🎮 RECONSTITUTION** : L'utilisateur doit retrouver l'ordre original

C'est la même logique qu'un puzzle image : on a d'abord l'image complète, puis on la découpe et mélange, puis l'utilisateur reconstitue ! 🧩

La différence : ici le "découpage" est **logique** (mélange d'indices) plutôt que **physique** (découpe d'image).

---

## 📚 14. ARCHITECTURE DES FORMULES

### Nouveau système - "Habileté Maths"

#### Classe principale : QuizItem

```dart
class QuizItem {
  final String id;                    // Identifiant unique
  final String leftLatex;            // Formule LaTeX avec \VAR{}
  final List<Variable> variables;    // Variables de la formule
  final RationalValue expectedValue; // Résultat attendu
  final String answerLatexCanonical; // Réponse canonique
  final Map<String, dynamic> formatHints;     // Format d'affichage
  final InteractionType interactionType;     // Type d'interaction
  final List<QuizChoice> choices;            // Choix (vide pour drag&drop)
  final Map<String, dynamic> metadata;      // Métadonnées
}
```

#### Classes de support

```dart
// Variables avec domaines
class Variable {
  final String name;       // "a", "b", etc.
  final int value;         // Valeur actuelle
  final int minValue;      // Valeur minimale
  final int maxValue;      // Valeur maximale
  final String? role;      // Rôle optionnel
}

// Valeurs rationnelles exactes
class RationalValue {
  final BigInt numerator;   // Numérateur
  final BigInt denominator; // Dénominateur
}

// Niveaux de difficulté
enum DifficultyLevel {
  level1(1, "1 chiffre", 1, 9),
  level2(2, "2 chiffres", 10, 99), 
  level3(3, "3 chiffres", 100, 999);
}
```

#### Syntaxe LaTeX moderne

```dart
// NOUVEAU: \VAR{nom_variable}
leftLatex: '\\VAR{a} + \\VAR{b}'

// Génération propre avec getCleanLatex()
// \VAR{a} + \VAR{b} → 15 + 7
```

### Ancien système - "Habileté Numérique/Fractions"

#### Template d'opération

```dart
class NumericalOperationTemplate {
  final String operationType;        // "somme", "produit", etc.
  final String latexPattern;         // Pattern avec {VAR:nom}
  final String description;          // Description humaine
  final List<NumericalOperationParameter> parameters; // Paramètres
  final int difficulty;              // Niveau de difficulté
  final int Function(Map<String, int>) calculateResult; // Calcul
}
```

#### Syntaxe LaTeX ancienne

```dart
// ANCIEN: {VAR:nom_variable}
latexPattern: '{VAR:a} + {VAR:b}'
latexPattern: '\\frac{{{VAR:a}}}{{{VAR:b}}}'
latexPattern: '\\binom{{{VAR:n}}}{{{VAR:p}}}'
```

### Différences clés

| Aspect | Ancien Système | Nouveau Système |
|--------|----------------|-----------------|
| **Syntaxe LaTeX** | `{VAR:nom}` | `\\VAR{nom}` |
| **Structure** | Template fixe | QuizItem flexible |
| **Précision** | `int` simple | `RationalValue` (BigInt) |
| **Difficulté** | Niveau fixe | `DifficultyLevel` enum |
| **Interaction** | QCM/fixe | Drag & drop dynamique |
| **Variables** | Paramètres simples | Classe `Variable` complète |

---

## 📄 CONCLUSION

Le nouveau système "Habileté Maths" est **plus moderne, flexible et précis** que l'ancien système. Il suit une logique de puzzle classique avec construction complète puis découpage/mélange, offrant une expérience utilisateur intuitive et éducative.

**Date de création:** 2025-09-08  
**Auteur:** Assistant Claude Sonnet  
**Projet:** Luchy Flutter App  
