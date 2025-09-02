# 🏗️ ARCHITECTURE DES QUIZZ ÉDUCATIFS

## 📊 TABLEAU RÉCAPITULATIF DES TYPES DE JEU

| **TypeDeJeu** | **puzzleType** | **Architecture** | **Logique de validation** | **UI Spécial** | **Cas d'usage** |
|---------------|----------------|------------------|--------------------------|----------------|-----------------|
| **correspondanceVisAVis** | 2 | Grille 2 colonnes | Matching par mapping éducatif | AppBar éducative | Associations simples |
| **ordreChronologique** | 2 | Grille temporelle | Vérification ordre temporel | Chronomètre | Événements historiques |
| **classementCroissant** | 2 | Grille ordonnée | Vérification ordre croissant | Indicateurs visuels | Classements numériques |
| **groupement** | 2 | Grille catégorisée | Vérification catégories | Couleurs par groupe | Classifications |
| **sequenceLogique** | 2 | Grille séquentielle | Vérification logique | Flèches directionnelles | Suites logiques |
| **combinaisonsMatematiques** | 3 | Grille 3×3 | Matching coefficients binomiaux | Calculatrice intégrée | Maths combinatoire |
| **formulairesLatex** | 4 | Grille 4×3 | Navigation spécialisée | Écrans dédiés LaTeX | Formules complexes |
| **figuresDeStyle** | 2 | Grille stylistique | Matching figures/exemples | Analyseur texte | Littérature française |

---

## 🔧 ARCHITECTURE TECHNIQUE DÉTAILLÉE

### 🎯 **NIVEAU 1 : TypeDeJeu (Logique métier)**
```dart
enum TypeDeJeu {
  correspondanceVisAVis(...),     // Type 2
  ordreChronologique(...),       // Type 2  
  combinaisonsMatematiques(...), // Type 3
  formulairesLatex(...),         // Type 4
  // ...
}
```

### 🎮 **NIVEAU 2 : Mapping vers puzzleType**
```dart
int _getPuzzleType(QuestionnairePreset questionnaire) {
  switch (questionnaire.typeDeJeu) {
    case TypeDeJeu.combinaisonsMatematiques:
      return 3;  // Grille 3×3
      
    case TypeDeJeu.formulairesLatex:
      return 4;  // Grille 4×3
      
    default:
      return 2;  // Grille 2×3 (éducatif standard)
  }
}
```

### 🧠 **NIVEAU 3 : Logique de jeu spécialisée**

#### **Type 2 (Éducatif standard)**
```dart
// Mélange spécialisé
_createType2ShuffledArrangement(columns, rows) {
  // Mélange seulement colonne droite
  // Colonne gauche reste fixe
}

// Validation spécialisée  
_isType2Complete() {
  // Vérification par mapping éducatif
  // Matching selon règles métier
}
```

#### **Type 3 (Combinaisons mathématiques)**
```dart
// Même logique que Type 2
// Grille 3×3 pour plus de pièces
// Focus maths combinatoire
```

#### **Type 4 (Formulaires LaTeX)**
```dart
// Navigation vers écrans spécialisés
if (questionnaire.id == 'prepa_math_binome') {
  Navigator → BinomeFormulesScreen()
} else if (questionnaire.id == 'prepa_math_sommes') {
  Navigator → SommesFormulesScreen()
}
```

---

## 🎨 **ARCHITECTURE UI CONDITIONNELLE**

### **AppBar Conditionnelle**
```dart
appBar: (gameState.puzzleType == 2 || gameState.puzzleType == 3)
  ? EducationalAppBar(...)  // AppBar spécialisée
  : StandardAppBar(...)    // AppBar normale
```

### **Chronométrage Conditionnel**
```dart
startTime: (puzzleType == 2 || puzzleType == 3) 
  ? DateTime.now() 
  : null
```

### **Navigation Conditionnelle**
```dart
if (questionnaire.typeDeJeu == TypeDeJeu.formulairesLatex) {
  // Écrans spécialisés LaTeX
} else if (questionnaire.typeDeJeu == TypeDeJeu.figuresDeStyle) {
  // Écrans spécialisés littérature
} else {
  // Génération d'image standard
}
```

---

## 📈 **HIÉRARCHIE ARCHITECTURALE**

```
┌─────────────────────────────────────┐
│         QuestionnairePreset         │
│   ┌─────────────────────────────┐   │
│   │        TypeDeJeu           │   │ ← Logique métier (7 types)
│   │  • correspondanceVisAVis   │   │
│   │  • formulairesLatex        │   │
│   │  • combinaisonsMath        │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         puzzleType                 │ ← Architecture technique (1,2,3,4)
│   ┌─────────────────────────────┐   │
│   │  • Type 1: Standard        │   │
│   │  • Type 2: Éducatif 2×3    │   │
│   │  • Type 3: Combinaisons 3×3│   │
│   │  • Type 4: LaTeX 4×3       │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘
               ↓
┌─────────────────────────────────────┐
│        Logique Spécialisée          │
│   ┌─────────────────────────────┐   │
│   │  • Mélange personnalisé     │   │
│   │  • Validation spécialisée   │   │
│   │  • UI conditionnelle        │   │
│   │  • Navigation spécialisée   │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## 🎯 **POINTS ARCHITECTURAUX CLÉS**

### **1. Séparation Logique/Métier**
- **TypeDeJeu** : Définit la logique éducative
- **puzzleType** : Définit l'architecture technique
- **Mapping souple** : 7 types logiques → 4 architectures

### **2. Extensibilité**
```dart
// Ajout facile de nouveaux types :
enum TypeDeJeu {
  // ... types existants
  nouveauType('Nouveau type', 'Description'),
}

// Mapping automatique :
case TypeDeJeu.nouveauType:
  return 5; // Nouvelle architecture
```

### **3. Cohérence**
- **Standards uniformes** pour tous les types
- **Logique de validation** adaptée à chaque type
- **UI spécialisée** selon les besoins éducatifs

### **4. Performance**
- **Lazy loading** des questionnaires
- **Cache intelligent** des images générées
- **Optimisation mémoire** pour grandes grilles

Cette architecture permet une grande flexibilité tout en maintenant une cohérence technique et éducative ! 🚀
