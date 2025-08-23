// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get photoGalleryLabel => 'Photo Gallery';

  @override
  String get photoGalleryOption => 'Open Gallery';

  @override
  String get levelTitleLabel => 'Level';

  @override
  String get levelTitle => 'Level';

  @override
  String get levelEasyLabel => 'Easy';

  @override
  String get levelMediumLabel => 'Medium';

  @override
  String get levelHardLabel => 'Hard';

  @override
  String get levelCustomLabel => 'Custom';

  @override
  String get difficultyLabel => 'Difficulty';

  @override
  String get puzzleSizeLabel => 'Size';

  @override
  String get share => 'Share';

  @override
  String get shareTitle => 'New PuzHub Challenge!';

  @override
  String sharePuzzleInfo(String difficulty) {
    return 'An exciting puzzle with $difficulty pieces';
  }

  @override
  String get success => 'Puzzle completed!';

  @override
  String get shareDownloadPrompt => 'Download PuzHub and join the challenge!';

  @override
  String get shareHashtags => '#PuzHub #Puzzle #MobileGame';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get sourceDialogTitle => 'PuzHub V1.4';

  @override
  String get galleryOption => 'Gallery';

  @override
  String get cameraOption => 'Camera';

  @override
  String get codeOption => 'Photo+Code';

  @override
  String get processingImage => 'Processing image...';

  @override
  String get resizingImage => 'Resizing image...';

  @override
  String photoReady(int width, int height) {
    return 'Photo: ${width}x$height px';
  }

  @override
  String get processing => 'Running...';

  @override
  String get codeDialogTitle => 'Enter Code';

  @override
  String get codeHint => '3-digit code';

  @override
  String get shareCodeTitle => 'Puzzle Code';

  @override
  String get shareCodeMessage => 'Your puzzle code is:';

  @override
  String get shareWithImage => 'Share this Code with your Friends!';

  @override
  String get sharingImage => 'Sharing image...';

  @override
  String photoError(String message) {
    return 'Photo error: $message';
  }

  @override
  String imageError(String message) {
    return 'Error Image: $message';
  }

  @override
  String sharingError(String message) {
    return 'Sharing Error: $message';
  }

  @override
  String takePhotoError(String message) {
    return 'Error Take Photo: $message';
  }

  @override
  String get decodeError => 'No decode';

  @override
  String get tempFileError => 'Temporary file could not be created';

  @override
  String get selectImageHelp => 'Select a photo or Take photo';

  @override
  String get surpriseLabel => 'Pissarro';

  @override
  String get previewLabel => 'Preview';

  @override
  String shareCodeText(String code) {
    return 'Code: $code';
  }

  @override
  String get imageProcessingReport => 'Image Processing Report';

  @override
  String get image => 'Image';

  @override
  String get dimensions => 'Dimensions';

  @override
  String get grid => 'Grid';

  @override
  String get originalSize => 'Original Size';

  @override
  String get optimizedSize => 'Optimized Size';

  @override
  String get imageEntropy => 'Image Complexity:';

  @override
  String get processingTimes => 'Processing Times';

  @override
  String get decodingTime => 'Decoding';

  @override
  String get piecesCreationTime => 'Pieces Creation';

  @override
  String get shuffleTime => 'Shuffle';

  @override
  String get cropTime => 'Cropping';

  @override
  String get initTime => 'Initialization';

  @override
  String get pickImageTime => 'Image Selection';

  @override
  String get totalTime => 'Total Time';

  @override
  String get close => 'Close';
}
