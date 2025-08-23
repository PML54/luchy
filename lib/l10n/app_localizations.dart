import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @photoGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGalleryLabel;

  /// No description provided for @photoGalleryOption.
  ///
  /// In en, this message translates to:
  /// **'Open Gallery'**
  String get photoGalleryOption;

  /// No description provided for @levelTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelTitleLabel;

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelTitle;

  /// No description provided for @levelEasyLabel.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get levelEasyLabel;

  /// No description provided for @levelMediumLabel.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get levelMediumLabel;

  /// No description provided for @levelHardLabel.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get levelHardLabel;

  /// No description provided for @levelCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get levelCustomLabel;

  /// No description provided for @difficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyLabel;

  /// No description provided for @puzzleSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get puzzleSizeLabel;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'New PuzHub Challenge!'**
  String get shareTitle;

  /// No description provided for @sharePuzzleInfo.
  ///
  /// In en, this message translates to:
  /// **'An exciting puzzle with {difficulty} pieces'**
  String sharePuzzleInfo(String difficulty);

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Puzzle completed!'**
  String get success;

  /// No description provided for @shareDownloadPrompt.
  ///
  /// In en, this message translates to:
  /// **'Download PuzHub and join the challenge!'**
  String get shareDownloadPrompt;

  /// No description provided for @shareHashtags.
  ///
  /// In en, this message translates to:
  /// **'#PuzHub #Puzzle #MobileGame'**
  String get shareHashtags;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @sourceDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'PuzHub V1.4'**
  String get sourceDialogTitle;

  /// No description provided for @galleryOption.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryOption;

  /// No description provided for @cameraOption.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraOption;

  /// No description provided for @codeOption.
  ///
  /// In en, this message translates to:
  /// **'Photo+Code'**
  String get codeOption;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// No description provided for @resizingImage.
  ///
  /// In en, this message translates to:
  /// **'Resizing image...'**
  String get resizingImage;

  /// No description provided for @photoReady.
  ///
  /// In en, this message translates to:
  /// **'Photo: {width}x{height} px'**
  String photoReady(int width, int height);

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Running...'**
  String get processing;

  /// No description provided for @codeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get codeDialogTitle;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'3-digit code'**
  String get codeHint;

  /// No description provided for @shareCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle Code'**
  String get shareCodeTitle;

  /// No description provided for @shareCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Your puzzle code is:'**
  String get shareCodeMessage;

  /// No description provided for @shareWithImage.
  ///
  /// In en, this message translates to:
  /// **'Share this Code with your Friends!'**
  String get shareWithImage;

  /// No description provided for @sharingImage.
  ///
  /// In en, this message translates to:
  /// **'Sharing image...'**
  String get sharingImage;

  /// No description provided for @photoError.
  ///
  /// In en, this message translates to:
  /// **'Photo error: {message}'**
  String photoError(String message);

  /// No description provided for @imageError.
  ///
  /// In en, this message translates to:
  /// **'Error Image: {message}'**
  String imageError(String message);

  /// No description provided for @sharingError.
  ///
  /// In en, this message translates to:
  /// **'Sharing Error: {message}'**
  String sharingError(String message);

  /// No description provided for @takePhotoError.
  ///
  /// In en, this message translates to:
  /// **'Error Take Photo: {message}'**
  String takePhotoError(String message);

  /// No description provided for @decodeError.
  ///
  /// In en, this message translates to:
  /// **'No decode'**
  String get decodeError;

  /// No description provided for @tempFileError.
  ///
  /// In en, this message translates to:
  /// **'Temporary file could not be created'**
  String get tempFileError;

  /// No description provided for @selectImageHelp.
  ///
  /// In en, this message translates to:
  /// **'Select a photo or Take photo'**
  String get selectImageHelp;

  /// No description provided for @surpriseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pissarro'**
  String get surpriseLabel;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @shareCodeText.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String shareCodeText(String code);

  /// No description provided for @imageProcessingReport.
  ///
  /// In en, this message translates to:
  /// **'Image Processing Report'**
  String get imageProcessingReport;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get grid;

  /// No description provided for @originalSize.
  ///
  /// In en, this message translates to:
  /// **'Original Size'**
  String get originalSize;

  /// No description provided for @optimizedSize.
  ///
  /// In en, this message translates to:
  /// **'Optimized Size'**
  String get optimizedSize;

  /// No description provided for @imageEntropy.
  ///
  /// In en, this message translates to:
  /// **'Image Complexity:'**
  String get imageEntropy;

  /// No description provided for @processingTimes.
  ///
  /// In en, this message translates to:
  /// **'Processing Times'**
  String get processingTimes;

  /// No description provided for @decodingTime.
  ///
  /// In en, this message translates to:
  /// **'Decoding'**
  String get decodingTime;

  /// No description provided for @piecesCreationTime.
  ///
  /// In en, this message translates to:
  /// **'Pieces Creation'**
  String get piecesCreationTime;

  /// No description provided for @shuffleTime.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffleTime;

  /// No description provided for @cropTime.
  ///
  /// In en, this message translates to:
  /// **'Cropping'**
  String get cropTime;

  /// No description provided for @initTime.
  ///
  /// In en, this message translates to:
  /// **'Initialization'**
  String get initTime;

  /// No description provided for @pickImageTime.
  ///
  /// In en, this message translates to:
  /// **'Image Selection'**
  String get pickImageTime;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
