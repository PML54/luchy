// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameSettings {
  int get difficultyCols => throw _privateConstructorUsedError;
  int get difficultyRows => throw _privateConstructorUsedError;
  bool get useCustomGridSize => throw _privateConstructorUsedError;
  bool get hasSeenDocumentation => throw _privateConstructorUsedError;
  int get puzzleType => throw _privateConstructorUsedError;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSettingsCopyWith<GameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSettingsCopyWith<$Res> {
  factory $GameSettingsCopyWith(
          GameSettings value, $Res Function(GameSettings) then) =
      _$GameSettingsCopyWithImpl<$Res, GameSettings>;
  @useResult
  $Res call(
      {int difficultyCols,
      int difficultyRows,
      bool useCustomGridSize,
      bool hasSeenDocumentation,
      int puzzleType});
}

/// @nodoc
class _$GameSettingsCopyWithImpl<$Res, $Val extends GameSettings>
    implements $GameSettingsCopyWith<$Res> {
  _$GameSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficultyCols = null,
    Object? difficultyRows = null,
    Object? useCustomGridSize = null,
    Object? hasSeenDocumentation = null,
    Object? puzzleType = null,
  }) {
    return _then(_value.copyWith(
      difficultyCols: null == difficultyCols
          ? _value.difficultyCols
          : difficultyCols // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyRows: null == difficultyRows
          ? _value.difficultyRows
          : difficultyRows // ignore: cast_nullable_to_non_nullable
              as int,
      useCustomGridSize: null == useCustomGridSize
          ? _value.useCustomGridSize
          : useCustomGridSize // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSeenDocumentation: null == hasSeenDocumentation
          ? _value.hasSeenDocumentation
          : hasSeenDocumentation // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzleType: null == puzzleType
          ? _value.puzzleType
          : puzzleType // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameSettingsImplCopyWith<$Res>
    implements $GameSettingsCopyWith<$Res> {
  factory _$$GameSettingsImplCopyWith(
          _$GameSettingsImpl value, $Res Function(_$GameSettingsImpl) then) =
      __$$GameSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int difficultyCols,
      int difficultyRows,
      bool useCustomGridSize,
      bool hasSeenDocumentation,
      int puzzleType});
}

/// @nodoc
class __$$GameSettingsImplCopyWithImpl<$Res>
    extends _$GameSettingsCopyWithImpl<$Res, _$GameSettingsImpl>
    implements _$$GameSettingsImplCopyWith<$Res> {
  __$$GameSettingsImplCopyWithImpl(
      _$GameSettingsImpl _value, $Res Function(_$GameSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficultyCols = null,
    Object? difficultyRows = null,
    Object? useCustomGridSize = null,
    Object? hasSeenDocumentation = null,
    Object? puzzleType = null,
  }) {
    return _then(_$GameSettingsImpl(
      difficultyCols: null == difficultyCols
          ? _value.difficultyCols
          : difficultyCols // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyRows: null == difficultyRows
          ? _value.difficultyRows
          : difficultyRows // ignore: cast_nullable_to_non_nullable
              as int,
      useCustomGridSize: null == useCustomGridSize
          ? _value.useCustomGridSize
          : useCustomGridSize // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSeenDocumentation: null == hasSeenDocumentation
          ? _value.hasSeenDocumentation
          : hasSeenDocumentation // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzleType: null == puzzleType
          ? _value.puzzleType
          : puzzleType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$GameSettingsImpl with DiagnosticableTreeMixin implements _GameSettings {
  const _$GameSettingsImpl(
      {required this.difficultyCols,
      required this.difficultyRows,
      required this.useCustomGridSize,
      required this.hasSeenDocumentation,
      required this.puzzleType});

  @override
  final int difficultyCols;
  @override
  final int difficultyRows;
  @override
  final bool useCustomGridSize;
  @override
  final bool hasSeenDocumentation;
  @override
  final int puzzleType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GameSettings(difficultyCols: $difficultyCols, difficultyRows: $difficultyRows, useCustomGridSize: $useCustomGridSize, hasSeenDocumentation: $hasSeenDocumentation, puzzleType: $puzzleType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GameSettings'))
      ..add(DiagnosticsProperty('difficultyCols', difficultyCols))
      ..add(DiagnosticsProperty('difficultyRows', difficultyRows))
      ..add(DiagnosticsProperty('useCustomGridSize', useCustomGridSize))
      ..add(DiagnosticsProperty('hasSeenDocumentation', hasSeenDocumentation))
      ..add(DiagnosticsProperty('puzzleType', puzzleType));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSettingsImpl &&
            (identical(other.difficultyCols, difficultyCols) ||
                other.difficultyCols == difficultyCols) &&
            (identical(other.difficultyRows, difficultyRows) ||
                other.difficultyRows == difficultyRows) &&
            (identical(other.useCustomGridSize, useCustomGridSize) ||
                other.useCustomGridSize == useCustomGridSize) &&
            (identical(other.hasSeenDocumentation, hasSeenDocumentation) ||
                other.hasSeenDocumentation == hasSeenDocumentation) &&
            (identical(other.puzzleType, puzzleType) ||
                other.puzzleType == puzzleType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, difficultyCols, difficultyRows,
      useCustomGridSize, hasSeenDocumentation, puzzleType);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      __$$GameSettingsImplCopyWithImpl<_$GameSettingsImpl>(this, _$identity);
}

abstract class _GameSettings implements GameSettings {
  const factory _GameSettings(
      {required final int difficultyCols,
      required final int difficultyRows,
      required final bool useCustomGridSize,
      required final bool hasSeenDocumentation,
      required final int puzzleType}) = _$GameSettingsImpl;

  @override
  int get difficultyCols;
  @override
  int get difficultyRows;
  @override
  bool get useCustomGridSize;
  @override
  bool get hasSeenDocumentation;
  @override
  int get puzzleType;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GameState {
  bool get isInitialized => throw _privateConstructorUsedError;
  List<Uint8List> get pieces => throw _privateConstructorUsedError;
  int get columns => throw _privateConstructorUsedError;
  int get rows => throw _privateConstructorUsedError;
  List<int> get initialArrangement => throw _privateConstructorUsedError;
  List<int> get currentArrangement => throw _privateConstructorUsedError;
  int get swapCount => throw _privateConstructorUsedError;
  int get minimalMoves => throw _privateConstructorUsedError;
  Size get imageSize => throw _privateConstructorUsedError;
  bool get isPUZType => throw _privateConstructorUsedError;
  String get puzzCode => throw _privateConstructorUsedError;
  bool get isCoded => throw _privateConstructorUsedError;
  int get puzzleType =>
      throw _privateConstructorUsedError; // Type de puzzle : 1=classique, 2=éducatif, 3=combinaisons
  List<int>? get educationalMapping =>
      throw _privateConstructorUsedError; // Mapping original pour puzzles éducatifs
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {bool isInitialized,
      List<Uint8List> pieces,
      int columns,
      int rows,
      List<int> initialArrangement,
      List<int> currentArrangement,
      int swapCount,
      int minimalMoves,
      Size imageSize,
      bool isPUZType,
      String puzzCode,
      bool isCoded,
      int puzzleType,
      List<int>? educationalMapping,
      DateTime? startTime});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitialized = null,
    Object? pieces = null,
    Object? columns = null,
    Object? rows = null,
    Object? initialArrangement = null,
    Object? currentArrangement = null,
    Object? swapCount = null,
    Object? minimalMoves = null,
    Object? imageSize = null,
    Object? isPUZType = null,
    Object? puzzCode = null,
    Object? isCoded = null,
    Object? puzzleType = null,
    Object? educationalMapping = freezed,
    Object? startTime = freezed,
  }) {
    return _then(_value.copyWith(
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      pieces: null == pieces
          ? _value.pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<Uint8List>,
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      initialArrangement: null == initialArrangement
          ? _value.initialArrangement
          : initialArrangement // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentArrangement: null == currentArrangement
          ? _value.currentArrangement
          : currentArrangement // ignore: cast_nullable_to_non_nullable
              as List<int>,
      swapCount: null == swapCount
          ? _value.swapCount
          : swapCount // ignore: cast_nullable_to_non_nullable
              as int,
      minimalMoves: null == minimalMoves
          ? _value.minimalMoves
          : minimalMoves // ignore: cast_nullable_to_non_nullable
              as int,
      imageSize: null == imageSize
          ? _value.imageSize
          : imageSize // ignore: cast_nullable_to_non_nullable
              as Size,
      isPUZType: null == isPUZType
          ? _value.isPUZType
          : isPUZType // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzCode: null == puzzCode
          ? _value.puzzCode
          : puzzCode // ignore: cast_nullable_to_non_nullable
              as String,
      isCoded: null == isCoded
          ? _value.isCoded
          : isCoded // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzleType: null == puzzleType
          ? _value.puzzleType
          : puzzleType // ignore: cast_nullable_to_non_nullable
              as int,
      educationalMapping: freezed == educationalMapping
          ? _value.educationalMapping
          : educationalMapping // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isInitialized,
      List<Uint8List> pieces,
      int columns,
      int rows,
      List<int> initialArrangement,
      List<int> currentArrangement,
      int swapCount,
      int minimalMoves,
      Size imageSize,
      bool isPUZType,
      String puzzCode,
      bool isCoded,
      int puzzleType,
      List<int>? educationalMapping,
      DateTime? startTime});
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitialized = null,
    Object? pieces = null,
    Object? columns = null,
    Object? rows = null,
    Object? initialArrangement = null,
    Object? currentArrangement = null,
    Object? swapCount = null,
    Object? minimalMoves = null,
    Object? imageSize = null,
    Object? isPUZType = null,
    Object? puzzCode = null,
    Object? isCoded = null,
    Object? puzzleType = null,
    Object? educationalMapping = freezed,
    Object? startTime = freezed,
  }) {
    return _then(_$GameStateImpl(
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      pieces: null == pieces
          ? _value._pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<Uint8List>,
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      initialArrangement: null == initialArrangement
          ? _value._initialArrangement
          : initialArrangement // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentArrangement: null == currentArrangement
          ? _value._currentArrangement
          : currentArrangement // ignore: cast_nullable_to_non_nullable
              as List<int>,
      swapCount: null == swapCount
          ? _value.swapCount
          : swapCount // ignore: cast_nullable_to_non_nullable
              as int,
      minimalMoves: null == minimalMoves
          ? _value.minimalMoves
          : minimalMoves // ignore: cast_nullable_to_non_nullable
              as int,
      imageSize: null == imageSize
          ? _value.imageSize
          : imageSize // ignore: cast_nullable_to_non_nullable
              as Size,
      isPUZType: null == isPUZType
          ? _value.isPUZType
          : isPUZType // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzCode: null == puzzCode
          ? _value.puzzCode
          : puzzCode // ignore: cast_nullable_to_non_nullable
              as String,
      isCoded: null == isCoded
          ? _value.isCoded
          : isCoded // ignore: cast_nullable_to_non_nullable
              as bool,
      puzzleType: null == puzzleType
          ? _value.puzzleType
          : puzzleType // ignore: cast_nullable_to_non_nullable
              as int,
      educationalMapping: freezed == educationalMapping
          ? _value._educationalMapping
          : educationalMapping // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$GameStateImpl with DiagnosticableTreeMixin implements _GameState {
  const _$GameStateImpl(
      {required this.isInitialized,
      required final List<Uint8List> pieces,
      required this.columns,
      required this.rows,
      required final List<int> initialArrangement,
      required final List<int> currentArrangement,
      required this.swapCount,
      required this.minimalMoves,
      required this.imageSize,
      required this.isPUZType,
      required this.puzzCode,
      required this.isCoded,
      required this.puzzleType,
      final List<int>? educationalMapping,
      this.startTime})
      : _pieces = pieces,
        _initialArrangement = initialArrangement,
        _currentArrangement = currentArrangement,
        _educationalMapping = educationalMapping;

  @override
  final bool isInitialized;
  final List<Uint8List> _pieces;
  @override
  List<Uint8List> get pieces {
    if (_pieces is EqualUnmodifiableListView) return _pieces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pieces);
  }

  @override
  final int columns;
  @override
  final int rows;
  final List<int> _initialArrangement;
  @override
  List<int> get initialArrangement {
    if (_initialArrangement is EqualUnmodifiableListView)
      return _initialArrangement;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_initialArrangement);
  }

  final List<int> _currentArrangement;
  @override
  List<int> get currentArrangement {
    if (_currentArrangement is EqualUnmodifiableListView)
      return _currentArrangement;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentArrangement);
  }

  @override
  final int swapCount;
  @override
  final int minimalMoves;
  @override
  final Size imageSize;
  @override
  final bool isPUZType;
  @override
  final String puzzCode;
  @override
  final bool isCoded;
  @override
  final int puzzleType;
// Type de puzzle : 1=classique, 2=éducatif, 3=combinaisons
  final List<int>? _educationalMapping;
// Type de puzzle : 1=classique, 2=éducatif, 3=combinaisons
  @override
  List<int>? get educationalMapping {
    final value = _educationalMapping;
    if (value == null) return null;
    if (_educationalMapping is EqualUnmodifiableListView)
      return _educationalMapping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Mapping original pour puzzles éducatifs
  @override
  final DateTime? startTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GameState(isInitialized: $isInitialized, pieces: $pieces, columns: $columns, rows: $rows, initialArrangement: $initialArrangement, currentArrangement: $currentArrangement, swapCount: $swapCount, minimalMoves: $minimalMoves, imageSize: $imageSize, isPUZType: $isPUZType, puzzCode: $puzzCode, isCoded: $isCoded, puzzleType: $puzzleType, educationalMapping: $educationalMapping, startTime: $startTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GameState'))
      ..add(DiagnosticsProperty('isInitialized', isInitialized))
      ..add(DiagnosticsProperty('pieces', pieces))
      ..add(DiagnosticsProperty('columns', columns))
      ..add(DiagnosticsProperty('rows', rows))
      ..add(DiagnosticsProperty('initialArrangement', initialArrangement))
      ..add(DiagnosticsProperty('currentArrangement', currentArrangement))
      ..add(DiagnosticsProperty('swapCount', swapCount))
      ..add(DiagnosticsProperty('minimalMoves', minimalMoves))
      ..add(DiagnosticsProperty('imageSize', imageSize))
      ..add(DiagnosticsProperty('isPUZType', isPUZType))
      ..add(DiagnosticsProperty('puzzCode', puzzCode))
      ..add(DiagnosticsProperty('isCoded', isCoded))
      ..add(DiagnosticsProperty('puzzleType', puzzleType))
      ..add(DiagnosticsProperty('educationalMapping', educationalMapping))
      ..add(DiagnosticsProperty('startTime', startTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            const DeepCollectionEquality().equals(other._pieces, _pieces) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.rows, rows) || other.rows == rows) &&
            const DeepCollectionEquality()
                .equals(other._initialArrangement, _initialArrangement) &&
            const DeepCollectionEquality()
                .equals(other._currentArrangement, _currentArrangement) &&
            (identical(other.swapCount, swapCount) ||
                other.swapCount == swapCount) &&
            (identical(other.minimalMoves, minimalMoves) ||
                other.minimalMoves == minimalMoves) &&
            (identical(other.imageSize, imageSize) ||
                other.imageSize == imageSize) &&
            (identical(other.isPUZType, isPUZType) ||
                other.isPUZType == isPUZType) &&
            (identical(other.puzzCode, puzzCode) ||
                other.puzzCode == puzzCode) &&
            (identical(other.isCoded, isCoded) || other.isCoded == isCoded) &&
            (identical(other.puzzleType, puzzleType) ||
                other.puzzleType == puzzleType) &&
            const DeepCollectionEquality()
                .equals(other._educationalMapping, _educationalMapping) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isInitialized,
      const DeepCollectionEquality().hash(_pieces),
      columns,
      rows,
      const DeepCollectionEquality().hash(_initialArrangement),
      const DeepCollectionEquality().hash(_currentArrangement),
      swapCount,
      minimalMoves,
      imageSize,
      isPUZType,
      puzzCode,
      isCoded,
      puzzleType,
      const DeepCollectionEquality().hash(_educationalMapping),
      startTime);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {required final bool isInitialized,
      required final List<Uint8List> pieces,
      required final int columns,
      required final int rows,
      required final List<int> initialArrangement,
      required final List<int> currentArrangement,
      required final int swapCount,
      required final int minimalMoves,
      required final Size imageSize,
      required final bool isPUZType,
      required final String puzzCode,
      required final bool isCoded,
      required final int puzzleType,
      final List<int>? educationalMapping,
      final DateTime? startTime}) = _$GameStateImpl;

  @override
  bool get isInitialized;
  @override
  List<Uint8List> get pieces;
  @override
  int get columns;
  @override
  int get rows;
  @override
  List<int> get initialArrangement;
  @override
  List<int> get currentArrangement;
  @override
  int get swapCount;
  @override
  int get minimalMoves;
  @override
  Size get imageSize;
  @override
  bool get isPUZType;
  @override
  String get puzzCode;
  @override
  bool get isCoded;
  @override
  int get puzzleType; // Type de puzzle : 1=classique, 2=éducatif, 3=combinaisons
  @override
  List<int>? get educationalMapping; // Mapping original pour puzzles éducatifs
  @override
  DateTime? get startTime;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
