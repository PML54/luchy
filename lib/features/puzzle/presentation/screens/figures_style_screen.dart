/// <curseur>
/// LUCHY - Quiz Figures de Style
///
/// Écran interactif pour apprendre les figures de style françaises.
/// 3 colonnes : Figure, Exemple, Définition (au tap).
///
/// COMPOSANTS PRINCIPAUX:
/// - Données complètes des figures de style
/// - Interface glisser-déposer pour association
/// - Définitions contextuelles au tap
/// - Chronométrage et scoring
///
/// ÉTAT ACTUEL:
/// - Interface responsive smartphone/tablette
/// - 6 questions aléatoires par session
/// - Mélange des exemples pour difficulté
/// - AppBar avec contrôles standard
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création initiale avec données utilisateur complètes
/// - Intégration architecture puzzle éducatif existante
/// - Support navigation depuis toolbar éducatif
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance: Gérer les nombreuses figures de style
/// - UX: Définitions lisibles au tap
/// - Mémoire: Optimiser chargement données
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter filtrage par niveau/difficulté
/// - Implémenter sauvegarde progression
/// - Enrichir exemples contextuels
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Navigation
/// - core/utils/educational_image_generator.dart: Structure questionnaires
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (NOUVEAU CONTENU ÉDUCATIF)
/// 📅 Dernière modification: 2025-01-27 21:30
/// </curseur>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'dart:math' as math;

/// Structure d'une figure de style
class FigureDeStyle {
  final String figure;
  final String definition;
  final String exemple;

  const FigureDeStyle({
    required this.figure,
    required this.definition, 
    required this.exemple,
  });
}

class FiguresStyleScreen extends ConsumerStatefulWidget {
  const FiguresStyleScreen({super.key});

  @override
  ConsumerState<FiguresStyleScreen> createState() => _FiguresStyleScreenState();
}

class _FiguresStyleScreenState extends ConsumerState<FiguresStyleScreen> {
  late DateTime _startTime;
  
  // Toutes les figures de style
  static const List<FigureDeStyle> _toutesLesFigures = [
    FigureDeStyle(figure: 'Métaphore', definition: 'Image sans outil de comparaison', exemple: 'mer de blé'),
    FigureDeStyle(figure: 'Métaphore', definition: 'Image sans outil de comparaison', exemple: 'pluie d\'étoiles'),
    FigureDeStyle(figure: 'Métaphore', definition: 'Image sans outil de comparaison', exemple: 'océan de verdure'),
    FigureDeStyle(figure: 'Comparaison', definition: 'Rapprochement avec « comme »', exemple: 'fort comme lion'),
    FigureDeStyle(figure: 'Comparaison', definition: 'Rapprochement avec « comme »', exemple: 'léger tel plume'),
    FigureDeStyle(figure: 'Comparaison', definition: 'Rapprochement avec « comme »', exemple: 'sage tel image'),
    FigureDeStyle(figure: 'Allégorie', definition: 'Idée abstraite incarnée', exemple: 'dame Justice'),
    FigureDeStyle(figure: 'Allégorie', definition: 'Idée abstraite incarnée', exemple: 'Cupidon armé'),
    FigureDeStyle(figure: 'Allégorie', definition: 'Idée abstraite incarnée', exemple: 'Temps vieillard'),
    FigureDeStyle(figure: 'Personnification', definition: 'Donner traits humains', exemple: 'l\'arbre pleure'),
    FigureDeStyle(figure: 'Personnification', definition: 'Donner traits humains', exemple: 'soleil sourit'),
    FigureDeStyle(figure: 'Personnification', definition: 'Donner traits humains', exemple: 'la nuit veille'),
    FigureDeStyle(figure: 'Prosopopée', definition: 'Faire parler l\'absent/abstrait', exemple: 'mort qui parle'),
    FigureDeStyle(figure: 'Prosopopée', definition: 'Faire parler l\'absent/abstrait', exemple: 'patrie qui supplie'),
    FigureDeStyle(figure: 'Prosopopée', definition: 'Faire parler l\'absent/abstrait', exemple: 'terre qui crie'),
    FigureDeStyle(figure: 'Métonymie', definition: 'Remplacer par lien logique', exemple: 'boire un verre'),
    FigureDeStyle(figure: 'Métonymie', definition: 'Remplacer par lien logique', exemple: 'lire un Molière'),
    FigureDeStyle(figure: 'Métonymie', definition: 'Remplacer par lien logique', exemple: 'manger son assiette'),
    FigureDeStyle(figure: 'Synecdoque', definition: 'Partie pour le tout', exemple: 'cent voiles'),
    FigureDeStyle(figure: 'Synecdoque', definition: 'Partie pour le tout', exemple: 'le fer'),
    FigureDeStyle(figure: 'Synecdoque', definition: 'Partie pour le tout', exemple: 'mains d\'œuvre'),
    FigureDeStyle(figure: 'Hyperbole', definition: 'Exagération volontaire', exemple: 'faim de loup'),
    FigureDeStyle(figure: 'Hyperbole', definition: 'Exagération volontaire', exemple: 'mort de rire'),
    FigureDeStyle(figure: 'Hyperbole', definition: 'Exagération volontaire', exemple: 'pleurer des torrents'),
    FigureDeStyle(figure: 'Litote', definition: 'Dire moins pour suggérer plus', exemple: 'pas mauvais'),
    FigureDeStyle(figure: 'Litote', definition: 'Dire moins pour suggérer plus', exemple: 'pas laid'),
    FigureDeStyle(figure: 'Litote', definition: 'Dire moins pour suggérer plus', exemple: 'pas rien'),
    FigureDeStyle(figure: 'Euphémisme', definition: 'Adoucir une réalité', exemple: 'il nous a quittés'),
    FigureDeStyle(figure: 'Euphémisme', definition: 'Adoucir une réalité', exemple: 'personne âgée'),
    FigureDeStyle(figure: 'Euphémisme', definition: 'Adoucir une réalité', exemple: 'non-voyant'),
    FigureDeStyle(figure: 'Pléonasme', definition: 'Répétition inutile', exemple: 'monter en haut'),
    FigureDeStyle(figure: 'Pléonasme', definition: 'Répétition inutile', exemple: 'descendre en bas'),
    FigureDeStyle(figure: 'Pléonasme', definition: 'Répétition inutile', exemple: 'prévoir d\'avance'),
    FigureDeStyle(figure: 'Accumulation', definition: 'Liste d\'éléments', exemple: 'feu, sang, cris'),
    FigureDeStyle(figure: 'Accumulation', definition: 'Liste d\'éléments', exemple: 'froid, faim, peur'),
    FigureDeStyle(figure: 'Accumulation', definition: 'Liste d\'éléments', exemple: 'pierre, bois, fer'),
    FigureDeStyle(figure: 'Gradation', definition: 'Progression croissante/décroissante', exemple: 'va, cours, vole'),
    FigureDeStyle(figure: 'Gradation', definition: 'Progression croissante/décroissante', exemple: 'petit, moyen, grand'),
    FigureDeStyle(figure: 'Gradation', definition: 'Progression croissante/décroissante', exemple: 'crier, hurler, rugir'),
    FigureDeStyle(figure: 'Anaphore', definition: 'Répétition en tête de phrase', exemple: 'j\'accuse, j\'accuse'),
    FigureDeStyle(figure: 'Anaphore', definition: 'Répétition en tête de phrase', exemple: 'partout l\'ombre'),
    FigureDeStyle(figure: 'Anaphore', definition: 'Répétition en tête de phrase', exemple: 'rien… rien… rien'),
    FigureDeStyle(figure: 'Épiphore', definition: 'Répétition en fin de phrase', exemple: '…la mer, la mer'),
    FigureDeStyle(figure: 'Épiphore', definition: 'Répétition en fin de phrase', exemple: 'je veux, tu veux'),
    FigureDeStyle(figure: 'Épiphore', definition: 'Répétition en fin de phrase', exemple: 'sans fin, pour rien'),
    FigureDeStyle(figure: 'Énumération', definition: 'Liste simple', exemple: 'chiens, chats, oiseaux'),
    FigureDeStyle(figure: 'Énumération', definition: 'Liste simple', exemple: 'pluie, vent, neige'),
    FigureDeStyle(figure: 'Énumération', definition: 'Liste simple', exemple: 'pain, vin, fromage'),
    FigureDeStyle(figure: 'Oxymore', definition: 'Contraires associés', exemple: 'silence assourdissant'),
    FigureDeStyle(figure: 'Oxymore', definition: 'Contraires associés', exemple: 'obscure clarté'),
    FigureDeStyle(figure: 'Oxymore', definition: 'Contraires associés', exemple: 'douce amertume'),
    FigureDeStyle(figure: 'Antithèse', definition: 'Opposition d\'idées', exemple: 'ombre et lumière'),
    FigureDeStyle(figure: 'Antithèse', definition: 'Opposition d\'idées', exemple: 'vie et mort'),
    FigureDeStyle(figure: 'Antithèse', definition: 'Opposition d\'idées', exemple: 'joie et peine'),
    FigureDeStyle(figure: 'Chiasme', definition: 'Croisement d\'éléments', exemple: 'vivre pour manger'),
    FigureDeStyle(figure: 'Chiasme', definition: 'Croisement d\'éléments', exemple: 'manger pour vivre'),
    FigureDeStyle(figure: 'Chiasme', definition: 'Croisement d\'éléments', exemple: 'plaire pour vivre'),
    FigureDeStyle(figure: 'Paradoxe', definition: 'Affirmation contradictoire', exemple: 'douce souffrance'),
    FigureDeStyle(figure: 'Paradoxe', definition: 'Affirmation contradictoire', exemple: 'obéissance libre'),
    FigureDeStyle(figure: 'Paradoxe', definition: 'Affirmation contradictoire', exemple: 'je sais que je ne sais rien'),
    FigureDeStyle(figure: 'Antiphrase', definition: 'Ironie (dire le contraire)', exemple: 'bravo le génie'),
    FigureDeStyle(figure: 'Antiphrase', definition: 'Ironie (dire le contraire)', exemple: 'quel courage !'),
    FigureDeStyle(figure: 'Antiphrase', definition: 'Ironie (dire le contraire)', exemple: 'super ton idée !'),
    FigureDeStyle(figure: 'Allitération', definition: 'Répétition de consonnes', exemple: 'serpents sifflants'),
    FigureDeStyle(figure: 'Allitération', definition: 'Répétition de consonnes', exemple: 'pour qui sont…'),
    FigureDeStyle(figure: 'Allitération', definition: 'Répétition de consonnes', exemple: 'faisons feu follet'),
    FigureDeStyle(figure: 'Assonance', definition: 'Répétition de voyelles', exemple: 'ô solitude'),
    FigureDeStyle(figure: 'Assonance', definition: 'Répétition de voyelles', exemple: 'qui vit rit'),
    FigureDeStyle(figure: 'Assonance', definition: 'Répétition de voyelles', exemple: 'murmure du flux'),
    FigureDeStyle(figure: 'Paronomase', definition: 'Jeux de mots proches', exemple: 'qui se ressemble'),
    FigureDeStyle(figure: 'Paronomase', definition: 'Jeux de mots proches', exemple: 'l\'homme propose'),
    FigureDeStyle(figure: 'Paronomase', definition: 'Jeux de mots proches', exemple: 'cœur qui pleure'),
    FigureDeStyle(figure: 'Ellipse', definition: 'Mots manquants sous-entendus', exemple: 'jamais vu'),
    FigureDeStyle(figure: 'Ellipse', definition: 'Mots manquants sous-entendus', exemple: 'suis pas venu'),
    FigureDeStyle(figure: 'Ellipse', definition: 'Mots manquants sous-entendus', exemple: 'envie dormir'),
    FigureDeStyle(figure: 'Zeugma', definition: 'Associer concret et abstrait', exemple: 'porter voile, espoir'),
    FigureDeStyle(figure: 'Zeugma', definition: 'Associer concret et abstrait', exemple: 'ouvrir sa porte et son cœur'),
    FigureDeStyle(figure: 'Zeugma', definition: 'Associer concret et abstrait', exemple: 'perdre portefeuille et dignité'),
    FigureDeStyle(figure: 'Antanaclase', definition: 'Même mot, sens différent', exemple: 'le temps du temps'),
    FigureDeStyle(figure: 'Antanaclase', definition: 'Même mot, sens différent', exemple: 'vivre sa vie'),
    FigureDeStyle(figure: 'Antanaclase', definition: 'Même mot, sens différent', exemple: 'cœur a ses raisons'),
    FigureDeStyle(figure: 'Polyptote', definition: 'Variations d\'un même mot', exemple: 'vivre ma vie'),
    FigureDeStyle(figure: 'Polyptote', definition: 'Variations d\'un même mot', exemple: 'manger pour manger'),
    FigureDeStyle(figure: 'Polyptote', definition: 'Variations d\'un même mot', exemple: 'savoir qu\'on sait'),
    FigureDeStyle(figure: 'Parallélisme', definition: 'Construction symétrique', exemple: 'partir pour fuir'),
    FigureDeStyle(figure: 'Parallélisme', definition: 'Construction symétrique', exemple: 'plus je t\'aime, plus je souffre'),
    FigureDeStyle(figure: 'Parallélisme', definition: 'Construction symétrique', exemple: 'aujourd\'hui je ris, demain je pleure'),
    FigureDeStyle(figure: 'Hypallage', definition: 'Attribuer à un mot ce qui revient à un autre', exemple: 'un silence vert'),
    FigureDeStyle(figure: 'Hypallage', definition: 'Attribuer à un mot ce qui revient à un autre', exemple: 'un lit malheureux'),
    FigureDeStyle(figure: 'Hypallage', definition: 'Attribuer à un mot ce qui revient à un autre', exemple: 'un vin joyeux'),
    FigureDeStyle(figure: 'Périphrase', definition: 'Remplacer par une expression détournée', exemple: 'le roi des animaux'),
    FigureDeStyle(figure: 'Périphrase', definition: 'Remplacer par une expression détournée', exemple: 'l\'astre du jour'),
    FigureDeStyle(figure: 'Périphrase', definition: 'Remplacer par une expression détournée', exemple: 'la ville lumière'),
    FigureDeStyle(figure: 'Polysyndète', definition: 'Répétition de conjonctions', exemple: 'et l\'aube, et le jour'),
    FigureDeStyle(figure: 'Polysyndète', definition: 'Répétition de conjonctions', exemple: 'et toi, et moi'),
    FigureDeStyle(figure: 'Asyndète', definition: 'Absence de conjonction', exemple: 'je suis venu, j\'ai vu, j\'ai vaincu'),
    FigureDeStyle(figure: 'Asyndète', definition: 'Absence de conjonction', exemple: 'je cours, je tombe, je pleure'),
    FigureDeStyle(figure: 'Anadiplose', definition: 'Répétition fin → début', exemple: 'il partit, partir c\'est mourir'),
    FigureDeStyle(figure: 'Anadiplose', definition: 'Répétition fin → début', exemple: 'elle sourit, sourire éclaire'),
    FigureDeStyle(figure: 'Épanorthose', definition: 'Rectification d\'un propos', exemple: 'il est laid — non, monstrueux'),
    FigureDeStyle(figure: 'Épanorthose', definition: 'Rectification d\'un propos', exemple: 'c\'est grand — immense'),
    FigureDeStyle(figure: 'Anacoluthe', definition: 'Rupture de construction', exemple: 'moi, président… je serai…'),
    FigureDeStyle(figure: 'Anacoluthe', definition: 'Rupture de construction', exemple: 'le nez de Cléopâtre… s\'il eût été plus court…'),
    FigureDeStyle(figure: 'Hyperbate', definition: 'Ajout après la phrase', exemple: 'je t\'aime, je le dis, moi'),
    FigureDeStyle(figure: 'Hyperbate', definition: 'Ajout après la phrase', exemple: 'je partirai, demain peut-être'),
    FigureDeStyle(figure: 'Inversion', definition: 'Ordre inhabituel', exemple: 'belle est la nuit'),
    FigureDeStyle(figure: 'Inversion', definition: 'Ordre inhabituel', exemple: 'grand fut son malheur'),
    FigureDeStyle(figure: 'Prétérition', definition: 'Dire qu\'on ne dira pas', exemple: 'je ne parlerai pas de sa lâcheté'),
    FigureDeStyle(figure: 'Prétérition', definition: 'Dire qu\'on ne dira pas', exemple: 'inutile de rappeler sa trahison'),
    FigureDeStyle(figure: 'Apostrophe', definition: 'Interpeller directement', exemple: 'Ô mort !'),
    FigureDeStyle(figure: 'Apostrophe', definition: 'Interpeller directement', exemple: 'Toi, lecteur !'),
    FigureDeStyle(figure: 'Apostrophe', definition: 'Interpeller directement', exemple: 'Ô rage ! Ô désespoir !'),
    FigureDeStyle(figure: 'Exclamation', definition: 'Marque d\'émotion forte', exemple: 'Horreur !'),
    FigureDeStyle(figure: 'Exclamation', definition: 'Marque d\'émotion forte', exemple: 'Quelle joie !'),
    FigureDeStyle(figure: 'Exclamation', definition: 'Marque d\'émotion forte', exemple: 'Ah ! misère !'),
    FigureDeStyle(figure: 'Interrogation oratoire', definition: 'Question sans réponse attendue', exemple: 'qui pourrait l\'ignorer ?'),
    FigureDeStyle(figure: 'Interrogation oratoire', definition: 'Question sans réponse attendue', exemple: 'est-ce une vie ?'),
    FigureDeStyle(figure: 'Catachrèse', definition: 'Mot détourné faute de terme propre', exemple: 'les ailes du nez'),
    FigureDeStyle(figure: 'Catachrèse', definition: 'Mot détourné faute de terme propre', exemple: 'les jambes de la table'),
    FigureDeStyle(figure: 'Catachrèse', definition: 'Mot détourné faute de terme propre', exemple: 'la bouche d\'un volcan'),
    FigureDeStyle(figure: 'Onomatopée', definition: 'Bruit imité', exemple: 'boum'),
    FigureDeStyle(figure: 'Onomatopée', definition: 'Bruit imité', exemple: 'tic-tac'),
    FigureDeStyle(figure: 'Onomatopée', definition: 'Bruit imité', exemple: 'miaou'),
    FigureDeStyle(figure: 'Homéotéleute', definition: 'Mêmes terminaisons sonores', exemple: 'qui rit, qui écrit'),
    FigureDeStyle(figure: 'Homéotéleute', definition: 'Mêmes terminaisons sonores', exemple: 'chantant, pleurant, mourant'),
    FigureDeStyle(figure: 'Syllepse', definition: 'Même mot, 2 sens différents', exemple: 'une femme de cœur'),
    FigureDeStyle(figure: 'Syllepse', definition: 'Même mot, 2 sens différents', exemple: 'la fin du monde (≠ finalité)'),
    FigureDeStyle(figure: 'Enthymème', definition: 'Raisonnement elliptique', exemple: 'les hommes sont mortels, or Socrate…'),
    FigureDeStyle(figure: 'Enthymème', definition: 'Raisonnement elliptique', exemple: 'qui dit voleur dit prison'),
    FigureDeStyle(figure: 'Hypozeuxe', definition: 'Répétition structurelle', exemple: 'il chantait, elle pleurait'),
    FigureDeStyle(figure: 'Hypozeuxe', definition: 'Répétition structurelle', exemple: 'tu souffres, je rêve'),
    FigureDeStyle(figure: 'Parataxe', definition: 'Juxtaposition sans lien', exemple: 'je suis venu, j\'ai vu, j\'ai vaincu'),
    FigureDeStyle(figure: 'Parataxe', definition: 'Juxtaposition sans lien', exemple: 'il rit, il pleure, il chante'),
    FigureDeStyle(figure: 'Ekphrasis', definition: 'Description d\'une œuvre d\'art', exemple: 'tableau vivant'),
    FigureDeStyle(figure: 'Ekphrasis', definition: 'Description d\'une œuvre d\'art', exemple: 'fresque parlante'),
    FigureDeStyle(figure: 'Hypotypose', definition: 'Description frappante, vivante', exemple: 'bataille sanglante'),
    FigureDeStyle(figure: 'Hypotypose', definition: 'Description frappante, vivante', exemple: 'nuit obscure et glaciale'),
    FigureDeStyle(figure: 'Prosopographie', definition: 'Portrait physique', exemple: 'grand nez, petit front'),
    FigureDeStyle(figure: 'Prosopographie', definition: 'Portrait physique', exemple: 'yeux brillants, bouche fine'),
    FigureDeStyle(figure: 'Éthopée', definition: 'Portrait moral/psychologique', exemple: 'homme généreux'),
    FigureDeStyle(figure: 'Éthopée', definition: 'Portrait moral/psychologique', exemple: 'femme perfide'),
    FigureDeStyle(figure: 'Caricature', definition: 'Portrait exagéré', exemple: 'grosses oreilles'),
    FigureDeStyle(figure: 'Caricature', definition: 'Portrait exagéré', exemple: 'ventre énorme'),
    FigureDeStyle(figure: 'Cliché', definition: 'Expression figée, banale', exemple: 'blanc comme neige'),
    FigureDeStyle(figure: 'Cliché', definition: 'Expression figée, banale', exemple: 'fort comme un bœuf'),
    FigureDeStyle(figure: 'Paralogisme', definition: 'Raisonnement faux', exemple: 'tous les chats sont mortels, Socrate est mortel, donc Socrate est un chat'),
    FigureDeStyle(figure: 'Paralogisme', definition: 'Raisonnement faux', exemple: 'les riches sont heureux, donc les pauvres sont malheureux'),
    FigureDeStyle(figure: 'Aposiopèse', definition: 'Suspension brusque', exemple: 'si je t\'attrape…'),
    FigureDeStyle(figure: 'Aposiopèse', definition: 'Suspension brusque', exemple: 'tu vas voir…'),
    FigureDeStyle(figure: 'Palindrome', definition: 'Mot/phrase identique inversée', exemple: 'Ésope reste ici et se repose'),
    FigureDeStyle(figure: 'Acrostiche', definition: 'Initiales formant un mot', exemple: 'Poème où chaque initiale = AMOUR'),
    FigureDeStyle(figure: 'Lipogramme', definition: 'Texte sans une lettre', exemple: 'roman sans « e » (ex. Perec)'),
  ];

  // Questions actuelles (6 sélectionnées aléatoirement)
  late List<FigureDeStyle> _questionsActuelles;
  late List<String> _exemplesMelanges;
  late List<int> _ordrageActuel; // Ordre actuel des exemples
  String? _definitionAffichee; // Index de la définition affichée

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _selectRandomQuestions();
    _initializePuzzle();
  }

  /// Sélectionne 6 questions aléatoires parmi toutes les figures
  void _selectRandomQuestions() {
    final random = math.Random();
    final allFigures = List<FigureDeStyle>.from(_toutesLesFigures);
    allFigures.shuffle(random);
    
    // Prendre 6 figures distinctes (par nom de figure)
    final figuresDistinctes = <String, FigureDeStyle>{};
    for (final figure in allFigures) {
      if (figuresDistinctes.length >= 6) break;
      if (!figuresDistinctes.containsKey(figure.figure)) {
        figuresDistinctes[figure.figure] = figure;
      }
    }
    
    _questionsActuelles = figuresDistinctes.values.toList();
  }

  /// Initialise le puzzle avec mélange des exemples
  void _initializePuzzle() {
    // Créer les exemples dans l'ordre original
    final exemplesOriginaux = _questionsActuelles.map((f) => f.exemple).toList();
    
    // Créer l'ordre actuel (commence mélangé)
    _ordrageActuel = List.generate(_questionsActuelles.length, (index) => index);
    _ordrageActuel.shuffle();
    
    // Créer la liste des exemples mélangés
    _exemplesMelanges = _ordrageActuel.map((index) => exemplesOriginaux[index]).toList();
    
    _definitionAffichee = null;
  }

  /// Affiche/cache la définition d'une figure
  void _toggleDefinition(int index) {
    setState(() {
      if (_definitionAffichee == _questionsActuelles[index].figure) {
        _definitionAffichee = null;
      } else {
        _definitionAffichee = _questionsActuelles[index].figure;
      }
    });
  }

  /// Gère l'échange de deux éléments dans la colonne des exemples
  void _swapExemples(int fromIndex, int toIndex) {
    setState(() {
      // Échanger dans la liste des exemples mélangés
      final temp = _exemplesMelanges[fromIndex];
      _exemplesMelanges[fromIndex] = _exemplesMelanges[toIndex];
      _exemplesMelanges[toIndex] = temp;
      
      // Échanger dans l'ordre actuel
      final tempOrder = _ordrageActuel[fromIndex];
      _ordrageActuel[fromIndex] = _ordrageActuel[toIndex];
      _ordrageActuel[toIndex] = tempOrder;
    });
  }

  /// Vérifie si le puzzle est complet
  bool _isComplete() {
    for (int i = 0; i < _questionsActuelles.length; i++) {
      if (_ordrageActuel[i] != i) return false;
    }
    return true;
  }

  /// Compte le nombre de bonnes correspondances
  int _getCorrectCount() {
    int count = 0;
    for (int i = 0; i < _questionsActuelles.length; i++) {
      if (_ordrageActuel[i] == i) count++;
    }
    return count;
  }

  /// Calcule le temps écoulé
  Duration _getElapsedTime() {
    return DateTime.now().difference(_startTime);
  }

  /// Renouvelle les questions avec 6 nouvelles figures
  void _renewQuestions() {
    setState(() {
      _startTime = DateTime.now();
      _selectRandomQuestions();
      _initializePuzzle();
    });
  }

  /// Quitte vers un puzzle normal
  void _quitToNormalPuzzle() {
    final gameSettingsNotifier = ref.read(gameSettingsProvider.notifier);
    gameSettingsNotifier.setDifficulty(3, 3);
    gameSettingsNotifier.setPuzzleType(1);
    Navigator.of(context).pop();
  }

  /// Calcule la taille de police adaptative
  double _getAdaptiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) { // Tablette
      return 24.0;
    } else { // Smartphone
      return 18.0;
    }
  }

  /// Calcule la hauteur de cellule adaptative
  double _getAdaptiveCellHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) { // Tablette
      return 100.0;
    } else { // Smartphone
      return 80.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final correctCount = _getCorrectCount();
    final totalCount = _questionsActuelles.length;
    final isComplete = _isComplete();
    final elapsedTime = _getElapsedTime();
    
    final fontSize = _getAdaptiveFontSize(context);
    final cellHeight = _getAdaptiveCellHeight(context);

    return WillPopScope(
      onWillPop: () async {
        _quitToNormalPuzzle();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Figures de Style'),
          backgroundColor: Colors.purple[100],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _quitToNormalPuzzle,
          ),
          actions: [
            // Bouton de vérification
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('📊 Résultats'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Score: $correctCount/$totalCount'),
                          const SizedBox(height: 8),
                          Text('Temps: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}'),
                          if (isComplete) ...[
                            const SizedBox(height: 16),
                            const Text('🎉 Parfait !', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _renewQuestions();
                          },
                          child: const Text('Recommencer'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bouton de renouvellement
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _renewQuestions,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.0, // Cellules plus larges
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: _questionsActuelles.length * 2, // 2 colonnes
            itemBuilder: (context, index) {
              final isLeftColumn = index.isEven;
              final rowIndex = index ~/ 2;
              
              if (isLeftColumn) {
                // Colonne gauche : Figure (avec tap pour définition)
                final figure = _questionsActuelles[rowIndex];
                return GestureDetector(
                  onTap: () => _toggleDefinition(rowIndex),
                  child: Container(
                    height: cellHeight,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              figure.figure,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Overlay de définition
                        if (_definitionAffichee == figure.figure)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    figure.definition,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                // Colonne droite : Exemple (draggable)
                final exemple = _exemplesMelanges[rowIndex];
                return DragTarget<int>(
                  onAcceptWithDetails: (details) {
                    _swapExemples(details.data, rowIndex);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Draggable<int>(
                      data: rowIndex,
                      feedback: Material(
                        child: Container(
                          width: 150,
                          height: cellHeight,
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              exemple,
                              style: TextStyle(fontSize: fontSize),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        height: cellHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Container(
                        height: cellHeight,
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              exemple,
                              style: TextStyle(fontSize: fontSize),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
