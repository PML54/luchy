// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FirebaseConfig {
  String get apiKey => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get storageBucket => throw _privateConstructorUsedError;
  String get appId => throw _privateConstructorUsedError;
  String get messagingSenderId => throw _privateConstructorUsedError;
  String? get iosClientId => throw _privateConstructorUsedError;

  /// Create a copy of FirebaseConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FirebaseConfigCopyWith<FirebaseConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseConfigCopyWith<$Res> {
  factory $FirebaseConfigCopyWith(
          FirebaseConfig value, $Res Function(FirebaseConfig) then) =
      _$FirebaseConfigCopyWithImpl<$Res, FirebaseConfig>;
  @useResult
  $Res call(
      {String apiKey,
      String projectId,
      String storageBucket,
      String appId,
      String messagingSenderId,
      String? iosClientId});
}

/// @nodoc
class _$FirebaseConfigCopyWithImpl<$Res, $Val extends FirebaseConfig>
    implements $FirebaseConfigCopyWith<$Res> {
  _$FirebaseConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FirebaseConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? projectId = null,
    Object? storageBucket = null,
    Object? appId = null,
    Object? messagingSenderId = null,
    Object? iosClientId = freezed,
  }) {
    return _then(_value.copyWith(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucket: null == storageBucket
          ? _value.storageBucket
          : storageBucket // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      messagingSenderId: null == messagingSenderId
          ? _value.messagingSenderId
          : messagingSenderId // ignore: cast_nullable_to_non_nullable
              as String,
      iosClientId: freezed == iosClientId
          ? _value.iosClientId
          : iosClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FirebaseConfigImplCopyWith<$Res>
    implements $FirebaseConfigCopyWith<$Res> {
  factory _$$FirebaseConfigImplCopyWith(_$FirebaseConfigImpl value,
          $Res Function(_$FirebaseConfigImpl) then) =
      __$$FirebaseConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String apiKey,
      String projectId,
      String storageBucket,
      String appId,
      String messagingSenderId,
      String? iosClientId});
}

/// @nodoc
class __$$FirebaseConfigImplCopyWithImpl<$Res>
    extends _$FirebaseConfigCopyWithImpl<$Res, _$FirebaseConfigImpl>
    implements _$$FirebaseConfigImplCopyWith<$Res> {
  __$$FirebaseConfigImplCopyWithImpl(
      _$FirebaseConfigImpl _value, $Res Function(_$FirebaseConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of FirebaseConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? projectId = null,
    Object? storageBucket = null,
    Object? appId = null,
    Object? messagingSenderId = null,
    Object? iosClientId = freezed,
  }) {
    return _then(_$FirebaseConfigImpl(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucket: null == storageBucket
          ? _value.storageBucket
          : storageBucket // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      messagingSenderId: null == messagingSenderId
          ? _value.messagingSenderId
          : messagingSenderId // ignore: cast_nullable_to_non_nullable
              as String,
      iosClientId: freezed == iosClientId
          ? _value.iosClientId
          : iosClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FirebaseConfigImpl
    with DiagnosticableTreeMixin
    implements _FirebaseConfig {
  const _$FirebaseConfigImpl(
      {required this.apiKey,
      required this.projectId,
      required this.storageBucket,
      required this.appId,
      required this.messagingSenderId,
      this.iosClientId});

  @override
  final String apiKey;
  @override
  final String projectId;
  @override
  final String storageBucket;
  @override
  final String appId;
  @override
  final String messagingSenderId;
  @override
  final String? iosClientId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FirebaseConfig(apiKey: $apiKey, projectId: $projectId, storageBucket: $storageBucket, appId: $appId, messagingSenderId: $messagingSenderId, iosClientId: $iosClientId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FirebaseConfig'))
      ..add(DiagnosticsProperty('apiKey', apiKey))
      ..add(DiagnosticsProperty('projectId', projectId))
      ..add(DiagnosticsProperty('storageBucket', storageBucket))
      ..add(DiagnosticsProperty('appId', appId))
      ..add(DiagnosticsProperty('messagingSenderId', messagingSenderId))
      ..add(DiagnosticsProperty('iosClientId', iosClientId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirebaseConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.storageBucket, storageBucket) ||
                other.storageBucket == storageBucket) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.messagingSenderId, messagingSenderId) ||
                other.messagingSenderId == messagingSenderId) &&
            (identical(other.iosClientId, iosClientId) ||
                other.iosClientId == iosClientId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiKey, projectId, storageBucket,
      appId, messagingSenderId, iosClientId);

  /// Create a copy of FirebaseConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FirebaseConfigImplCopyWith<_$FirebaseConfigImpl> get copyWith =>
      __$$FirebaseConfigImplCopyWithImpl<_$FirebaseConfigImpl>(
          this, _$identity);
}

abstract class _FirebaseConfig implements FirebaseConfig {
  const factory _FirebaseConfig(
      {required final String apiKey,
      required final String projectId,
      required final String storageBucket,
      required final String appId,
      required final String messagingSenderId,
      final String? iosClientId}) = _$FirebaseConfigImpl;

  @override
  String get apiKey;
  @override
  String get projectId;
  @override
  String get storageBucket;
  @override
  String get appId;
  @override
  String get messagingSenderId;
  @override
  String? get iosClientId;

  /// Create a copy of FirebaseConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FirebaseConfigImplCopyWith<_$FirebaseConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ImageConfig {
  int get maxDimension => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError;
  int get maxFileSize => throw _privateConstructorUsedError;
  List<String> get supportedFormats => throw _privateConstructorUsedError;

  /// Create a copy of ImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageConfigCopyWith<ImageConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageConfigCopyWith<$Res> {
  factory $ImageConfigCopyWith(
          ImageConfig value, $Res Function(ImageConfig) then) =
      _$ImageConfigCopyWithImpl<$Res, ImageConfig>;
  @useResult
  $Res call(
      {int maxDimension,
      int quality,
      int maxFileSize,
      List<String> supportedFormats});
}

/// @nodoc
class _$ImageConfigCopyWithImpl<$Res, $Val extends ImageConfig>
    implements $ImageConfigCopyWith<$Res> {
  _$ImageConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxDimension = null,
    Object? quality = null,
    Object? maxFileSize = null,
    Object? supportedFormats = null,
  }) {
    return _then(_value.copyWith(
      maxDimension: null == maxDimension
          ? _value.maxDimension
          : maxDimension // ignore: cast_nullable_to_non_nullable
              as int,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      maxFileSize: null == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      supportedFormats: null == supportedFormats
          ? _value.supportedFormats
          : supportedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageConfigImplCopyWith<$Res>
    implements $ImageConfigCopyWith<$Res> {
  factory _$$ImageConfigImplCopyWith(
          _$ImageConfigImpl value, $Res Function(_$ImageConfigImpl) then) =
      __$$ImageConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int maxDimension,
      int quality,
      int maxFileSize,
      List<String> supportedFormats});
}

/// @nodoc
class __$$ImageConfigImplCopyWithImpl<$Res>
    extends _$ImageConfigCopyWithImpl<$Res, _$ImageConfigImpl>
    implements _$$ImageConfigImplCopyWith<$Res> {
  __$$ImageConfigImplCopyWithImpl(
      _$ImageConfigImpl _value, $Res Function(_$ImageConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxDimension = null,
    Object? quality = null,
    Object? maxFileSize = null,
    Object? supportedFormats = null,
  }) {
    return _then(_$ImageConfigImpl(
      maxDimension: null == maxDimension
          ? _value.maxDimension
          : maxDimension // ignore: cast_nullable_to_non_nullable
              as int,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      maxFileSize: null == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      supportedFormats: null == supportedFormats
          ? _value._supportedFormats
          : supportedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ImageConfigImpl with DiagnosticableTreeMixin implements _ImageConfig {
  const _$ImageConfigImpl(
      {required this.maxDimension,
      required this.quality,
      required this.maxFileSize,
      required final List<String> supportedFormats})
      : _supportedFormats = supportedFormats;

  @override
  final int maxDimension;
  @override
  final int quality;
  @override
  final int maxFileSize;
  final List<String> _supportedFormats;
  @override
  List<String> get supportedFormats {
    if (_supportedFormats is EqualUnmodifiableListView)
      return _supportedFormats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedFormats);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ImageConfig(maxDimension: $maxDimension, quality: $quality, maxFileSize: $maxFileSize, supportedFormats: $supportedFormats)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ImageConfig'))
      ..add(DiagnosticsProperty('maxDimension', maxDimension))
      ..add(DiagnosticsProperty('quality', quality))
      ..add(DiagnosticsProperty('maxFileSize', maxFileSize))
      ..add(DiagnosticsProperty('supportedFormats', supportedFormats));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageConfigImpl &&
            (identical(other.maxDimension, maxDimension) ||
                other.maxDimension == maxDimension) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.maxFileSize, maxFileSize) ||
                other.maxFileSize == maxFileSize) &&
            const DeepCollectionEquality()
                .equals(other._supportedFormats, _supportedFormats));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxDimension, quality,
      maxFileSize, const DeepCollectionEquality().hash(_supportedFormats));

  /// Create a copy of ImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageConfigImplCopyWith<_$ImageConfigImpl> get copyWith =>
      __$$ImageConfigImplCopyWithImpl<_$ImageConfigImpl>(this, _$identity);
}

abstract class _ImageConfig implements ImageConfig {
  const factory _ImageConfig(
      {required final int maxDimension,
      required final int quality,
      required final int maxFileSize,
      required final List<String> supportedFormats}) = _$ImageConfigImpl;

  @override
  int get maxDimension;
  @override
  int get quality;
  @override
  int get maxFileSize;
  @override
  List<String> get supportedFormats;

  /// Create a copy of ImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageConfigImplCopyWith<_$ImageConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppConfig {
  String get appName => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  Environment get environment => throw _privateConstructorUsedError;
  FirebaseConfig get firebase => throw _privateConstructorUsedError;
  ImageConfig get imageConfig => throw _privateConstructorUsedError;
  bool get isDebugMode => throw _privateConstructorUsedError;
  bool get enableAnalytics => throw _privateConstructorUsedError;
  bool get enableCrashlytics => throw _privateConstructorUsedError;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call(
      {String appName,
      String version,
      Environment environment,
      FirebaseConfig firebase,
      ImageConfig imageConfig,
      bool isDebugMode,
      bool enableAnalytics,
      bool enableCrashlytics});

  $FirebaseConfigCopyWith<$Res> get firebase;
  $ImageConfigCopyWith<$Res> get imageConfig;
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? version = null,
    Object? environment = null,
    Object? firebase = null,
    Object? imageConfig = null,
    Object? isDebugMode = null,
    Object? enableAnalytics = null,
    Object? enableCrashlytics = null,
  }) {
    return _then(_value.copyWith(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as FirebaseConfig,
      imageConfig: null == imageConfig
          ? _value.imageConfig
          : imageConfig // ignore: cast_nullable_to_non_nullable
              as ImageConfig,
      isDebugMode: null == isDebugMode
          ? _value.isDebugMode
          : isDebugMode // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAnalytics: null == enableAnalytics
          ? _value.enableAnalytics
          : enableAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashlytics: null == enableCrashlytics
          ? _value.enableCrashlytics
          : enableCrashlytics // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FirebaseConfigCopyWith<$Res> get firebase {
    return $FirebaseConfigCopyWith<$Res>(_value.firebase, (value) {
      return _then(_value.copyWith(firebase: value) as $Val);
    });
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageConfigCopyWith<$Res> get imageConfig {
    return $ImageConfigCopyWith<$Res>(_value.imageConfig, (value) {
      return _then(_value.copyWith(imageConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$AppConfigImplCopyWith(
          _$AppConfigImpl value, $Res Function(_$AppConfigImpl) then) =
      __$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String appName,
      String version,
      Environment environment,
      FirebaseConfig firebase,
      ImageConfig imageConfig,
      bool isDebugMode,
      bool enableAnalytics,
      bool enableCrashlytics});

  @override
  $FirebaseConfigCopyWith<$Res> get firebase;
  @override
  $ImageConfigCopyWith<$Res> get imageConfig;
}

/// @nodoc
class __$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$AppConfigImpl>
    implements _$$AppConfigImplCopyWith<$Res> {
  __$$AppConfigImplCopyWithImpl(
      _$AppConfigImpl _value, $Res Function(_$AppConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? version = null,
    Object? environment = null,
    Object? firebase = null,
    Object? imageConfig = null,
    Object? isDebugMode = null,
    Object? enableAnalytics = null,
    Object? enableCrashlytics = null,
  }) {
    return _then(_$AppConfigImpl(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as FirebaseConfig,
      imageConfig: null == imageConfig
          ? _value.imageConfig
          : imageConfig // ignore: cast_nullable_to_non_nullable
              as ImageConfig,
      isDebugMode: null == isDebugMode
          ? _value.isDebugMode
          : isDebugMode // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAnalytics: null == enableAnalytics
          ? _value.enableAnalytics
          : enableAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashlytics: null == enableCrashlytics
          ? _value.enableCrashlytics
          : enableCrashlytics // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AppConfigImpl extends _AppConfig with DiagnosticableTreeMixin {
  const _$AppConfigImpl(
      {required this.appName,
      required this.version,
      required this.environment,
      required this.firebase,
      required this.imageConfig,
      this.isDebugMode = false,
      this.enableAnalytics = true,
      this.enableCrashlytics = true})
      : super._();

  @override
  final String appName;
  @override
  final String version;
  @override
  final Environment environment;
  @override
  final FirebaseConfig firebase;
  @override
  final ImageConfig imageConfig;
  @override
  @JsonKey()
  final bool isDebugMode;
  @override
  @JsonKey()
  final bool enableAnalytics;
  @override
  @JsonKey()
  final bool enableCrashlytics;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppConfig(appName: $appName, version: $version, environment: $environment, firebase: $firebase, imageConfig: $imageConfig, isDebugMode: $isDebugMode, enableAnalytics: $enableAnalytics, enableCrashlytics: $enableCrashlytics)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppConfig'))
      ..add(DiagnosticsProperty('appName', appName))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('environment', environment))
      ..add(DiagnosticsProperty('firebase', firebase))
      ..add(DiagnosticsProperty('imageConfig', imageConfig))
      ..add(DiagnosticsProperty('isDebugMode', isDebugMode))
      ..add(DiagnosticsProperty('enableAnalytics', enableAnalytics))
      ..add(DiagnosticsProperty('enableCrashlytics', enableCrashlytics));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigImpl &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            (identical(other.firebase, firebase) ||
                other.firebase == firebase) &&
            (identical(other.imageConfig, imageConfig) ||
                other.imageConfig == imageConfig) &&
            (identical(other.isDebugMode, isDebugMode) ||
                other.isDebugMode == isDebugMode) &&
            (identical(other.enableAnalytics, enableAnalytics) ||
                other.enableAnalytics == enableAnalytics) &&
            (identical(other.enableCrashlytics, enableCrashlytics) ||
                other.enableCrashlytics == enableCrashlytics));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appName, version, environment,
      firebase, imageConfig, isDebugMode, enableAnalytics, enableCrashlytics);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      __$$AppConfigImplCopyWithImpl<_$AppConfigImpl>(this, _$identity);
}

abstract class _AppConfig extends AppConfig {
  const factory _AppConfig(
      {required final String appName,
      required final String version,
      required final Environment environment,
      required final FirebaseConfig firebase,
      required final ImageConfig imageConfig,
      final bool isDebugMode,
      final bool enableAnalytics,
      final bool enableCrashlytics}) = _$AppConfigImpl;
  const _AppConfig._() : super._();

  @override
  String get appName;
  @override
  String get version;
  @override
  Environment get environment;
  @override
  FirebaseConfig get firebase;
  @override
  ImageConfig get imageConfig;
  @override
  bool get isDebugMode;
  @override
  bool get enableAnalytics;
  @override
  bool get enableCrashlytics;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
