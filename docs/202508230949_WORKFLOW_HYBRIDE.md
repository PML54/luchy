# 🎯 WORKFLOW HYBRIDE CLAUDE + CHATGPT POUR LUCHY

## 🔧 CONFIGURATION CURSOR

### Modèles configurés
- **Claude 3.5 Sonnet** (Anthropic) - Par défaut
- **GPT-4** (OpenAI) - Avec votre API key

### Raccourcis clavier
- `Cmd + K` → **Claude** (technique/code)
- `Cmd + Shift + K` → **ChatGPT** (créatif/idées)
- `Cmd + L` → Chat (sélection modèle)

## 📋 QUAND UTILISER QUOI

### 🔧 CLAUDE - TECHNIQUE & ARCHITECTURE
✅ **Utilisez Claude pour :**
- Debugging et résolution erreurs
- Refactoring et architecture code
- Optimisation performance
- Documentation technique
- Tests et intégration
- Code review et qualité
- Gestion d'état complexe (Riverpod)
- Migration et mise à jour dépendances

**Exemple prompts Claude :**
```
"Optimise ce code Riverpod pour de meilleures performances"
"Refactorise cette classe en suivant les bonnes pratiques"
"Debug cette erreur de build iOS"
"Crée une documentation technique pour cette feature"
```

### 💡 CHATGPT - CRÉATIVITÉ & DESIGN  
✅ **Utilisez ChatGPT pour :**
- Brainstorming nouvelles features
- Concepts UI/UX et design
- Rédaction contenu utilisateur
- Idées innovation et exploration
- Stratégie produit
- Recherche et inspiration
- Marketing et communication

**Exemple prompts ChatGPT :**
```
"Quelles features innovantes pour un jeu de puzzle mobile ?"
"Comment améliorer l'engagement utilisateur dans Luchy ?"
"Idées d'animations pour rendre le jeu plus dynamique"
"Concepts de gamification pour fidéliser les joueurs"
```

## 🚀 WORKFLOW CONCRET LUCHY

### Cycle de développement optimal

1. **💭 EXPLORATION (ChatGPT)**
   ```
   "Je veux ajouter un mode collaboratif à Luchy.
   Quelles seraient les meilleures approches UX ?"
   ```

2. **🏗️ ARCHITECTURE (Claude)**
   ```
   "Implémente l'architecture pour un système multijoueur
   en temps réel avec cette UX [copier réponse ChatGPT]"
   ```

3. **🎨 RAFFINEMENT (ChatGPT)**
   ```
   "Comment améliorer cette interface technique
   pour la rendre plus intuitive ?"
   ```

4. **⚡ OPTIMISATION (Claude)**
   ```
   "Optimise ce code multijoueur et ajoute
   la gestion d'erreurs réseau"
   ```

## 📁 ORGANISATION PROJET

### Structure recommandée
```
docs/
├── TECHNICAL.md        ← Claude (architecture)
├── FEATURES.md         ← ChatGPT (roadmap créative)
├── UX_RESEARCH.md      ← ChatGPT (user experience)
└── PERFORMANCE.md      ← Claude (optimisations)
```

### Commits et documentation
- **Commits techniques** : Claude (détails implémentation)
- **Commits features** : ChatGPT (description utilisateur)

## 🎯 EXEMPLES PRATIQUES

### Feature "Mode Nuit"
1. **ChatGPT** : "Design du dark mode, psychologie couleurs, UX"
2. **Claude** : "Implémentation ThemeData, gestion état, tests"

### Feature "Partage Social"  
1. **ChatGPT** : "Mécaniques sociales, engagement, viral loops"
2. **Claude** : "API integration, gestion permissions, optimisation"

### Bug Performance
1. **Claude** : "Profiling, analyse, optimisation technique"
2. **ChatGPT** : "Améliorer feedback utilisateur pendant loading"

## 💡 CONSEILS D'UTILISATION

### Bonnes pratiques
- **Contexte partagé** : Copiez les réponses entre les deux
- **Session focus** : Une tâche = un modèle principal
- **Documentation** : Claude pour technique, ChatGPT pour utilisateur
- **Itération** : Alternez pour raffiner progressivement

### À éviter
- ❌ Mélanger les rôles (technique ↔ créatif)
- ❌ Demander du code créatif à ChatGPT
- ❌ Demander de l'innovation UX à Claude
- ❌ Switcher constamment sans raison

---
*Dernière mise à jour : 23 août 2025*
*Configuration testée avec Luchy v1.1.0+3*


