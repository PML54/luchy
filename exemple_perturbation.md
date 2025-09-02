# 🎯 EXEMPLE DE LA PERTURBATION DANS LES COMBINAISONS

## 📋 SCÉNARIO TYPIQUE

**Génération aléatoire d'un puzzle de combinaisons :**

### Étape 1 : Génération des 5 combinaisons uniques
```
C(5,2) = 10
C(4,1) = 4  
C(6,3) = 20
C(3,2) = 3
C(7,4) = 35
```

### Étape 2 : Ajout de la perturbation
**Sélection aléatoire** : C(5,2) = 10
**Ajout de l'inverse** : C(2,5) = 10

### Étape 3 : Résultat final mélangé
```
Colonne gauche          Colonne droite
C(4,1) = 4              C(6,3) = 20
C(2,5) = 10            C(3,2) = 3  
C(7,4) = 35            C(5,2) = 10
C(3,2) = 3             C(4,1) = 4
C(6,3) = 20            C(7,4) = 35
C(5,2) = 10            C(2,5) = 10  ← PERTURBATION !
```

## 🎓 OBJECTIF PÉDAGOGIQUE

**Cette perturbation permet de :**
- ✅ **Évaluer la compréhension** : L'élève doit reconnaître que C(n,k) = C(k,n)
- ✅ **Développer la réflexion** : Ne pas se fier uniquement aux apparences
- ✅ **Renforcer les concepts** : Comprendre la symétrie des coefficients binomiaux
- ✅ **Créer l'attention** : Perturber le pattern de résolution automatique

## 🔍 LOGIQUE TECHNIQUE

```dart
// 1. Générer 5 combinaisons uniques
final selectedCouples = [couple1, couple2, couple3, couple4, couple5];

// 2. Choisir aléatoirement une combinaison
final randomCouple = selectedCouples[random.nextInt(5)]; // Ex: (n:5, p:2)

// 3. Créer l'inverse
final invertedCouple = (n: randomCouple.p, p: randomCouple.n); // (n:2, p:5)

// 4. Ajouter à la liste
selectedCouples.add(invertedCouple);

// 5. Résultat : C(5,2) ET C(2,5) dans le même puzzle !
```

## 📊 STATISTIQUES D'APPARITION

- **Fréquence** : ~16.7% (1 chance sur 6 d'être la combinaison dupliquée)
- **Impact** : Perturbation ciblée sans rendre le puzzle impossible
- **Éducatif** : Renforce la compréhension des propriétés mathématiques

Cette fonctionnalité transforme un simple puzzle en **outil pédagogique avancé** ! 🧮✨
