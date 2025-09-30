// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceConfig {
  /// Current screen dimensions
  Size get screenSize => throw _privateConstructorUsedError;

  /// Device pixel ratio for scaling calculations
  double get pixelRatio => throw _privateConstructorUsedError;

  /// Current device orientation
  Orientation get orientation => throw _privateConstructorUsedError;

  /// Specific device model identification
  DeviceType get deviceType => throw _privateConstructorUsedError;

  /// Safe area insets for UI adaptation
  EdgeInsets get safeArea => throw _privateConstructorUsedError;

  /// Indicates presence of a display notch
  bool get hasNotch => throw _privateConstructorUsedError;

  /// Indicates presence of Dynamic Island (iPhone 14 Pro and later)
  bool get hasDynamicIsland => throw _privateConstructorUsedError;

  /// Device hardware and software capabilities
  DeviceCapabilities get capabilities => throw _privateConstructorUsedError;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceConfigCopyWith<DeviceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceConfigCopyWith<$Res> {
  factory $DeviceConfigCopyWith(
          DeviceConfig value, $Res Function(DeviceConfig) then) =
      _$DeviceConfigCopyWithImpl<$Res, DeviceConfig>;
  @useResult
  $Res call(
      {Size screenSize,
      double pixelRatio,
      Orientation orientation,
      DeviceType deviceType,
      EdgeInsets safeArea,
      bool hasNotch,
      bool hasDynamicIsland,
      DeviceCapabilities capabilities});

  $DeviceCapabilitiesCopyWith<$Res> get capabilities;
}

/// @nodoc
class _$DeviceConfigCopyWithImpl<$Res, $Val extends DeviceConfig>
    implements $DeviceConfigCopyWith<$Res> {
  _$DeviceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenSize = null,
    Object? pixelRatio = null,
    Object? orientation = null,
    Object? deviceType = null,
    Object? safeArea = null,
    Object? hasNotch = null,
    Object? hasDynamicIsland = null,
    Object? capabilities = null,
  }) {
    return _then(_value.copyWith(
      screenSize: null == screenSize
          ? _value.screenSize
          : screenSize // ignore: cast_nullable_to_non_nullable
              as Size,
      pixelRatio: null == pixelRatio
          ? _value.pixelRatio
          : pixelRatio // ignore: cast_nullable_to_non_nullable
              as double,
      orientation: null == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as Orientation,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      safeArea: null == safeArea
          ? _value.safeArea
          : safeArea // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      hasNotch: null == hasNotch
          ? _value.hasNotch
          : hasNotch // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDynamicIsland: null == hasDynamicIsland
          ? _value.hasDynamicIsland
          : hasDynamicIsland // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as DeviceCapabilities,
    ) as $Val);
  }

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeviceCapabilitiesCopyWith<$Res> get capabilities {
    return $DeviceCapabilitiesCopyWith<$Res>(_value.capabilities, (value) {
      return _then(_value.copyWith(capabilities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeviceConfigImplCopyWith<$Res>
    implements $DeviceConfigCopyWith<$Res> {
  factory _$$DeviceConfigImplCopyWith(
          _$DeviceConfigImpl value, $Res Function(_$DeviceConfigImpl) then) =
      __$$DeviceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Size screenSize,
      double pixelRatio,
      Orientation orientation,
      DeviceType deviceType,
      EdgeInsets safeArea,
      bool hasNotch,
      bool hasDynamicIsland,
      DeviceCapabilities capabilities});

  @override
  $DeviceCapabilitiesCopyWith<$Res> get capabilities;
}

/// @nodoc
class __$$DeviceConfigImplCopyWithImpl<$Res>
    extends _$DeviceConfigCopyWithImpl<$Res, _$DeviceConfigImpl>
    implements _$$DeviceConfigImplCopyWith<$Res> {
  __$$DeviceConfigImplCopyWithImpl(
      _$DeviceConfigImpl _value, $Res Function(_$DeviceConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenSize = null,
    Object? pixelRatio = null,
    Object? orientation = null,
    Object? deviceType = null,
    Object? safeArea = null,
    Object? hasNotch = null,
    Object? hasDynamicIsland = null,
    Object? capabilities = null,
  }) {
    return _then(_$DeviceConfigImpl(
      screenSize: null == screenSize
          ? _value.screenSize
          : screenSize // ignore: cast_nullable_to_non_nullable
              as Size,
      pixelRatio: null == pixelRatio
          ? _value.pixelRatio
          : pixelRatio // ignore: cast_nullable_to_non_nullable
              as double,
      orientation: null == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as Orientation,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      safeArea: null == safeArea
          ? _value.safeArea
          : safeArea // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      hasNotch: null == hasNotch
          ? _value.hasNotch
          : hasNotch // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDynamicIsland: null == hasDynamicIsland
          ? _value.hasDynamicIsland
          : hasDynamicIsland // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as DeviceCapabilities,
    ));
  }
}

/// @nodoc

class _$DeviceConfigImpl implements _DeviceConfig {
  const _$DeviceConfigImpl(
      {required this.screenSize,
      required this.pixelRatio,
      required this.orientation,
      required this.deviceType,
      required this.safeArea,
      required this.hasNotch,
      required this.hasDynamicIsland,
      required this.capabilities});

  /// Current screen dimensions
  @override
  final Size screenSize;

  /// Device pixel ratio for scaling calculations
  @override
  final double pixelRatio;

  /// Current device orientation
  @override
  final Orientation orientation;

  /// Specific device model identification
  @override
  final DeviceType deviceType;

  /// Safe area insets for UI adaptation
  @override
  final EdgeInsets safeArea;

  /// Indicates presence of a display notch
  @override
  final bool hasNotch;

  /// Indicates presence of Dynamic Island (iPhone 14 Pro and later)
  @override
  final bool hasDynamicIsland;

  /// Device hardware and software capabilities
  @override
  final DeviceCapabilities capabilities;

  @override
  String toString() {
    return 'DeviceConfig(screenSize: $screenSize, pixelRatio: $pixelRatio, orientation: $orientation, deviceType: $deviceType, safeArea: $safeArea, hasNotch: $hasNotch, hasDynamicIsland: $hasDynamicIsland, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceConfigImpl &&
            (identical(other.screenSize, screenSize) ||
                other.screenSize == screenSize) &&
            (identical(other.pixelRatio, pixelRatio) ||
                other.pixelRatio == pixelRatio) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.safeArea, safeArea) ||
                other.safeArea == safeArea) &&
            (identical(other.hasNotch, hasNotch) ||
                other.hasNotch == hasNotch) &&
            (identical(other.hasDynamicIsland, hasDynamicIsland) ||
                other.hasDynamicIsland == hasDynamicIsland) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      screenSize,
      pixelRatio,
      orientation,
      deviceType,
      safeArea,
      hasNotch,
      hasDynamicIsland,
      capabilities);

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      __$$DeviceConfigImplCopyWithImpl<_$DeviceConfigImpl>(this, _$identity);
}

abstract class _DeviceConfig implements DeviceConfig {
  const factory _DeviceConfig(
      {required final Size screenSize,
      required final double pixelRatio,
      required final Orientation orientation,
      required final DeviceType deviceType,
      required final EdgeInsets safeArea,
      required final bool hasNotch,
      required final bool hasDynamicIsland,
      required final DeviceCapabilities capabilities}) = _$DeviceConfigImpl;

  /// Current screen dimensions
  @override
  Size get screenSize;

  /// Device pixel ratio for scaling calculations
  @override
  double get pixelRatio;

  /// Current device orientation
  @override
  Orientation get orientation;

  /// Specific device model identification
  @override
  DeviceType get deviceType;

  /// Safe area insets for UI adaptation
  @override
  EdgeInsets get safeArea;

  /// Indicates presence of a display notch
  @override
  bool get hasNotch;

  /// Indicates presence of Dynamic Island (iPhone 14 Pro and later)
  @override
  bool get hasDynamicIsland;

  /// Device hardware and software capabilities
  @override
  DeviceCapabilities get capabilities;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeviceCapabilities {
  /// Indicates if device has a camera
  bool get hasCamera => throw _privateConstructorUsedError;

  /// Indicates if app has gallery access permissions
  bool get hasGalleryAccess => throw _privateConstructorUsedError;

  /// Indicates if device supports haptic feedback
  bool get hasHapticFeedback => throw _privateConstructorUsedError;

  /// Indicates if device supports dark mode
  bool get supportsDarkMode => throw _privateConstructorUsedError;

  /// Indicates if device supports file sharing
  bool get hasFileSharing => throw _privateConstructorUsedError;

  /// Create a copy of DeviceCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceCapabilitiesCopyWith<DeviceCapabilities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceCapabilitiesCopyWith<$Res> {
  factory $DeviceCapabilitiesCopyWith(
          DeviceCapabilities value, $Res Function(DeviceCapabilities) then) =
      _$DeviceCapabilitiesCopyWithImpl<$Res, DeviceCapabilities>;
  @useResult
  $Res call(
      {bool hasCamera,
      bool hasGalleryAccess,
      bool hasHapticFeedback,
      bool supportsDarkMode,
      bool hasFileSharing});
}

/// @nodoc
class _$DeviceCapabilitiesCopyWithImpl<$Res, $Val extends DeviceCapabilities>
    implements $DeviceCapabilitiesCopyWith<$Res> {
  _$DeviceCapabilitiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasCamera = null,
    Object? hasGalleryAccess = null,
    Object? hasHapticFeedback = null,
    Object? supportsDarkMode = null,
    Object? hasFileSharing = null,
  }) {
    return _then(_value.copyWith(
      hasCamera: null == hasCamera
          ? _value.hasCamera
          : hasCamera // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGalleryAccess: null == hasGalleryAccess
          ? _value.hasGalleryAccess
          : hasGalleryAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasHapticFeedback: null == hasHapticFeedback
          ? _value.hasHapticFeedback
          : hasHapticFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDarkMode: null == supportsDarkMode
          ? _value.supportsDarkMode
          : supportsDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFileSharing: null == hasFileSharing
          ? _value.hasFileSharing
          : hasFileSharing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceCapabilitiesImplCopyWith<$Res>
    implements $DeviceCapabilitiesCopyWith<$Res> {
  factory _$$DeviceCapabilitiesImplCopyWith(_$DeviceCapabilitiesImpl value,
          $Res Function(_$DeviceCapabilitiesImpl) then) =
      __$$DeviceCapabilitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasCamera,
      bool hasGalleryAccess,
      bool hasHapticFeedback,
      bool supportsDarkMode,
      bool hasFileSharing});
}

/// @nodoc
class __$$DeviceCapabilitiesImplCopyWithImpl<$Res>
    extends _$DeviceCapabilitiesCopyWithImpl<$Res, _$DeviceCapabilitiesImpl>
    implements _$$DeviceCapabilitiesImplCopyWith<$Res> {
  __$$DeviceCapabilitiesImplCopyWithImpl(_$DeviceCapabilitiesImpl _value,
      $Res Function(_$DeviceCapabilitiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasCamera = null,
    Object? hasGalleryAccess = null,
    Object? hasHapticFeedback = null,
    Object? supportsDarkMode = null,
    Object? hasFileSharing = null,
  }) {
    return _then(_$DeviceCapabilitiesImpl(
      hasCamera: null == hasCamera
          ? _value.hasCamera
          : hasCamera // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGalleryAccess: null == hasGalleryAccess
          ? _value.hasGalleryAccess
          : hasGalleryAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasHapticFeedback: null == hasHapticFeedback
          ? _value.hasHapticFeedback
          : hasHapticFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDarkMode: null == supportsDarkMode
          ? _value.supportsDarkMode
          : supportsDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFileSharing: null == hasFileSharing
          ? _value.hasFileSharing
          : hasFileSharing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DeviceCapabilitiesImpl implements _DeviceCapabilities {
  const _$DeviceCapabilitiesImpl(
      {required this.hasCamera,
      required this.hasGalleryAccess,
      required this.hasHapticFeedback,
      required this.supportsDarkMode,
      required this.hasFileSharing});

  /// Indicates if device has a camera
  @override
  final bool hasCamera;

  /// Indicates if app has gallery access permissions
  @override
  final bool hasGalleryAccess;

  /// Indicates if device supports haptic feedback
  @override
  final bool hasHapticFeedback;

  /// Indicates if device supports dark mode
  @override
  final bool supportsDarkMode;

  /// Indicates if device supports file sharing
  @override
  final bool hasFileSharing;

  @override
  String toString() {
    return 'DeviceCapabilities(hasCamera: $hasCamera, hasGalleryAccess: $hasGalleryAccess, hasHapticFeedback: $hasHapticFeedback, supportsDarkMode: $supportsDarkMode, hasFileSharing: $hasFileSharing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceCapabilitiesImpl &&
            (identical(other.hasCamera, hasCamera) ||
                other.hasCamera == hasCamera) &&
            (identical(other.hasGalleryAccess, hasGalleryAccess) ||
                other.hasGalleryAccess == hasGalleryAccess) &&
            (identical(other.hasHapticFeedback, hasHapticFeedback) ||
                other.hasHapticFeedback == hasHapticFeedback) &&
            (identical(other.supportsDarkMode, supportsDarkMode) ||
                other.supportsDarkMode == supportsDarkMode) &&
            (identical(other.hasFileSharing, hasFileSharing) ||
                other.hasFileSharing == hasFileSharing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasCamera, hasGalleryAccess,
      hasHapticFeedback, supportsDarkMode, hasFileSharing);

  /// Create a copy of DeviceCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceCapabilitiesImplCopyWith<_$DeviceCapabilitiesImpl> get copyWith =>
      __$$DeviceCapabilitiesImplCopyWithImpl<_$DeviceCapabilitiesImpl>(
          this, _$identity);
}

abstract class _DeviceCapabilities implements DeviceCapabilities {
  const factory _DeviceCapabilities(
      {required final bool hasCamera,
      required final bool hasGalleryAccess,
      required final bool hasHapticFeedback,
      required final bool supportsDarkMode,
      required final bool hasFileSharing}) = _$DeviceCapabilitiesImpl;

  /// Indicates if device has a camera
  @override
  bool get hasCamera;

  /// Indicates if app has gallery access permissions
  @override
  bool get hasGalleryAccess;

  /// Indicates if device supports haptic feedback
  @override
  bool get hasHapticFeedback;

  /// Indicates if device supports dark mode
  @override
  bool get supportsDarkMode;

  /// Indicates if device supports file sharing
  @override
  bool get hasFileSharing;

  /// Create a copy of DeviceCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceCapabilitiesImplCopyWith<_$DeviceCapabilitiesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
