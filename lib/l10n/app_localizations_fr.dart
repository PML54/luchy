// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cancel => 'Annuler';

  @override
  String get photoGalleryLabel => 'Photos';

  @override
  String get photoGalleryOption => 'Ouvrir Galerie';

  @override
  String get levelTitleLabel => 'Niveau';

  @override
  String get levelTitle => 'Niveau';

  @override
  String get levelEasyLabel => 'Facile';

  @override
  String get levelMediumLabel => 'Moyen';

  @override
  String get levelHardLabel => 'Difficile';

  @override
  String get levelCustomLabel => 'Personnalisé';

  @override
  String get difficultyLabel => 'Difficulté';

  @override
  String get puzzleSizeLabel => 'Taille';

  @override
  String get share => 'Partager';

  @override
  String get shareTitle => 'Nouveau défi PuzHub !';

  @override
  String sharePuzzleInfo(String difficulty) {
    return 'Un puzzle passionnant en $difficulty pièces';
  }

  @override
  String get success => 'Puzzle terminé !';

  @override
  String get shareDownloadPrompt => 'Téléchargez PuzHub et rejoignez le défi !';

  @override
  String get shareHashtags => '#PuzHub #Puzzle #JeuMobile';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Erreur';

  @override
  String get sourceDialogTitle => 'Artuzz V1.1';

  @override
  String get galleryOption => 'Galerie';

  @override
  String get cameraOption => 'Photo';

  @override
  String get codeOption => 'Photo+Code';

  @override
  String get processingImage => 'Analyse de l\'image...';

  @override
  String get resizingImage => 'Redimensionnement de l\'image...';

  @override
  String photoReady(int width, int height) {
    return 'Photo : ${width}x$height px';
  }

  @override
  String get processing => 'Traitement en cours...';

  @override
  String get codeDialogTitle => 'Entrer le code';

  @override
  String get codeHint => 'Code à 3 chiffres';

  @override
  String get shareCodeTitle => 'Code du Puzzle';

  @override
  String get shareCodeMessage => 'Votre code de puzzle est :';

  @override
  String get shareWithImage => 'Partagez ce code avec vos amis !';

  @override
  String get sharingImage => 'Partage de l\'image...';

  @override
  String photoError(String message) {
    return 'Erreur photo : $message';
  }

  @override
  String imageError(String message) {
    return 'Erreur image : $message';
  }

  @override
  String sharingError(String message) {
    return 'Erreur de partage : $message';
  }

  @override
  String takePhotoError(String message) {
    return 'Erreur prise de photo : $message';
  }

  @override
  String get decodeError => 'Impossible de décoder l\'image';

  @override
  String get tempFileError => 'Le fichier temporaire n\'a pas pu être créé';

  @override
  String get selectImageHelp => 'Sélectionnez une photo ou prenez une photo';

  @override
  String get surpriseLabel => 'Pissarro';

  @override
  String get previewLabel => 'Aperçu';

  @override
  String shareCodeText(String code) {
    return 'Code : $code';
  }

  @override
  String get imageProcessingReport => 'Rapport de traitement d\'image';

  @override
  String get image => 'Image';

  @override
  String get dimensions => 'Dimensions';

  @override
  String get grid => 'Grille';

  @override
  String get originalSize => 'Taille originale';

  @override
  String get optimizedSize => 'Taille optimisée';

  @override
  String get imageEntropy => 'Complexité:';

  @override
  String get processingTimes => 'Temps de traitement';

  @override
  String get decodingTime => 'Décodage';

  @override
  String get piecesCreationTime => 'Création des pièces';

  @override
  String get shuffleTime => 'Mélange';

  @override
  String get cropTime => 'Recadrage';

  @override
  String get initTime => 'Initialisation';

  @override
  String get pickImageTime => 'Sélection de l\'image';

  @override
  String get totalTime => 'Temps total';

  @override
  String get close => 'Fermer';
}
