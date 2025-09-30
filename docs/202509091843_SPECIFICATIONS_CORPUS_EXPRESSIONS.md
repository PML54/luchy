# 📋 SPÉCIFICATIONS COMPLÈTES - CORPUS D'EXPRESSIONS ALGÉBRIQUES

---

## 🎯 VISION GÉNÉRALE

**Créer un corpus d'expressions algébriques** stocké en **JSON**, avec progression pédagogique du **CP à la Prépa**, basé sur le concept d'**"Expressions Circonstanciées"**.

---

## 🏗️ CONCEPT CENTRAL : "EXPRESSION CIRCONSTANCIÉE"

**Définition :** `(Expression LaTeX, Domaine de définition, Fonction de calcul)`

Chaque expression = **triplet indissociable** :
- **Expression LaTeX** avec toutes variables explicites
- **Domaine** définissant précisément le type des variables
- **Fonction de calcul** dédiée et spécialisée

---

## 📚 PROGRESSION PÉDAGOGIQUE

### Structure de base : `a + b`
- **CP** : `a, b ∈ entiers naturels [1,10]`
- **CE1** : `a, b ∈ entiers naturels [1,100]`
- **CE2** : `a, b ∈ entiers relatifs`
- **CM1** : `a, b ∈ fractions`
- **6ème** : `a, b ∈ radicaux d'entiers`
- **Prépa** : `a, b ∈ {π, e, ln(n)}`

### Évolution vers complexité :
`a + b` → `a + bc` → `(a + b)` → `(a + b)(c + d)` → etc.

---

## 🎯 RÈGLES MATHÉMATIQUES STRICTES

### 1. 🚫 Aucun nombre décimal
- ❌ Pas de `0.2`
- ✅ Uniquement `2/10` (puis simplifié en `1/5`)

### 2. ✅ Résultats en forme exacte uniquement
- **Entiers** → entiers
- **Fractions** → fractions simplifiées (ou entier si dénominateur = 1)
- **Radicaux** → radicaux factorisés (`√6 + √24 = 3√6`)
- **Transcendantes** → expressions symboliques (`2π + 3ln(2)`)

### 3. 🔧 Variables explicites dans LaTeX
- Addition de fractions : `\frac{a}{b} + \frac{c}{d}` (4 variables)
- Addition de radicaux : `\sqrt{a} + \sqrt{b}` (2 variables)

---

## 📝 STRUCTURE JSON

```json
{
  "id": "identifiant_unique",
  "expression": "LaTeX avec toutes variables explicites",
  "description": "Description pédagogique",
  
  "niveau_maitrise": "cm1",
  "utilisable_depuis": ["cm1", "cm2", "6eme", "..."],
  
  "domaine": "type_mathematique_precis",
  "fonction_calcul": "nom_fonction_dediee",
  "resultat_type": "forme_canonique",
  
  "variables": [
    {
      "nom": "a",
      "description": "rôle de la variable",
      "type": "type_precis",
      "contraintes": {"min": 1, "max": 20, "exclude": [0]}
    }
  ]
}
```

---

## 🏗️ ARCHITECTURE TECHNIQUE

### 🔧 Organisation en classe statique :
```dart
class ExpressionCorpus {
  static ExpressionResult additionFractionsSimples(Map<String, dynamic> vars) { ... }
  static ExpressionResult additionRadicaux(Map<String, dynamic> vars) { ... }
  static ExpressionResult additionFractionsRadicaux(Map<String, dynamic> vars) { ... }
  
  static void registerAllFunctions() {
    ExpressionCalculatorRegistry.register('addition_fractions_simples', additionFractionsSimples);
    // Auto-registration de toutes les fonctions
  }
}
```

### 📋 Séparation claire des responsabilités :
- **`expressions_corpus.json`** → Configuration pure (domaines, contraintes, exemples)
- **`expression_corpus.dart`** → Fonctions de calcul organisées en classe statique
- **`expression_calculator.dart`** → Registre et utilitaires (validation, génération)
- **`fraction_result.dart`** → Types de résultats exacts

### 📋 Fonctions spécialisées par domaine :
- `additionEntiers()` → entiers naturels/relatifs
- `additionFractionsSimples()` → fractions entières avec simplification
- `additionFractionsRadicaux()` → fractions avec radicaux + rationalisation
- `additionRadicaux()` → radicaux avec factorisation
- `additionTranscendantes()` → expressions symboliques (π, e, ln)

---

## 🎯 TYPES D'EXPRESSIONS DISTINCTS

### Exemple : Fractions
1. **`fractions_entieres`** : `\frac{a}{b} + \frac{c}{d}` (a,b,c,d entiers)
2. **`fractions_radicaux`** : `\frac{a}{\sqrt{b}} + \frac{c}{\sqrt{d}}` (avec rationalisation)

**Principe :** Chaque domaine = expression circonstanciée distincte + fonction dédiée

---

## 📚 NIVEAUX DE MAÎTRISE

- **`niveau_maitrise`** : Niveau où l'expression doit être acquise
- **`utilisable_depuis`** : Peut être redemandée à tous niveaux supérieurs
- **Révisions spiralées** : Une expression maîtrisée en CM1 peut revenir en 3ème

---

## 📋 EXEMPLES CONCRETS

### 1. Addition d'entiers (CP)
```json
{
  "id": "addition_entiers_cp",
  "expression": "a + b",
  "niveau_maitrise": "cp",
  "domaine": "entiers_naturels",
  "fonction_calcul": "addition_entiers",
  "variables": [
    {"nom": "a", "type": "entier_naturel", "contraintes": {"min": 1, "max": 10}},
    {"nom": "b", "type": "entier_naturel", "contraintes": {"min": 1, "max": 10}}
  ]
}
```

### 2. Addition de fractions entières (CM1)
```json
{
  "id": "addition_fractions_entieres",
  "expression": "\\frac{a}{b} + \\frac{c}{d}",
  "niveau_maitrise": "cm1",
  "domaine": "fractions_entieres",
  "fonction_calcul": "addition_fractions_simples",
  "variables": [
    {"nom": "a", "type": "entier_relatif", "contraintes": {"min": 1, "max": 20}},
    {"nom": "b", "type": "entier_naturel", "contraintes": {"min": 2, "max": 12}},
    {"nom": "c", "type": "entier_relatif", "contraintes": {"min": 1, "max": 20}},
    {"nom": "d", "type": "entier_naturel", "contraintes": {"min": 2, "max": 12}}
  ]
}
```

### 3. Addition de fractions avec radicaux (Lycée)
```json
{
  "id": "addition_fractions_radicaux",
  "expression": "\\frac{a}{\\sqrt{b}} + \\frac{c}{\\sqrt{d}}",
  "niveau_maitrise": "1ere",
  "domaine": "fractions_radicaux",
  "fonction_calcul": "addition_fractions_avec_rationalisation",
  "variables": [
    {"nom": "a", "type": "entier_relatif", "contraintes": {"min": 1, "max": 10}},
    {"nom": "b", "type": "entier_naturel_non_carre_parfait", "contraintes": {"min": 2, "max": 20, "exclude": [4, 9, 16]}},
    {"nom": "c", "type": "entier_relatif", "contraintes": {"min": 1, "max": 10}},
    {"nom": "d", "type": "entier_naturel_non_carre_parfait", "contraintes": {"min": 2, "max": 20, "exclude": [4, 9, 16]}}
  ]
}
```

---

## 🎯 OBJECTIFS FINAUX

✅ **Architecture évolutive** CP → Prépa  
✅ **Précision mathématique absolue** (forme exacte)  
✅ **Modularité** (domaines distincts)  
✅ **Réutilisabilité** (révisions spiralées)  
✅ **Extensibilité** (ajout facile de nouvelles expressions)  
✅ **Organisation claire** (JSON config + Dart classe statique)  
✅ **Auto-registration** (démarrage automatique)  
✅ **Validation intégrée** (contraintes + exemples)  

---

**Document de spécifications complet pour un système d'expressions algébriques éducatives**

**Date :** Janvier 2025  
**Projet :** Luchy - Application éducative Flutter  
**Architecture :** JSON + Dart + LaTeX  
