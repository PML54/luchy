// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizScore _$QuizScoreFromJson(Map<String, dynamic> json) {
  return _QuizScore.fromJson(json);
}

/// @nodoc
mixin _$QuizScore {
  int get id => throw _privateConstructorUsedError;
  String get quizCode =>
      throw _privateConstructorUsedError; // 'GEO_CAP', 'MATH_HABILETES', 'SVT_EVA', etc.
  String get quizCategory =>
      throw _privateConstructorUsedError; // 'Géographie', 'Mathématiques', 'SVT Terminale'
  int get totalQuestions =>
      throw _privateConstructorUsedError; // Nombre total de questions du quiz
  int get correctAnswers =>
      throw _privateConstructorUsedError; // Nombre de bonnes réponses
  double get score20 =>
      throw _privateConstructorUsedError; // Note sur 20 calculée
  DateTime get sessionDate =>
      throw _privateConstructorUsedError; // Date de la session
  int? get durationSeconds =>
      throw _privateConstructorUsedError; // Durée du quiz en secondes (optionnel)
  String? get levelName =>
      throw _privateConstructorUsedError; // Niveau de difficulté (optionnel)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this QuizScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizScoreCopyWith<QuizScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizScoreCopyWith<$Res> {
  factory $QuizScoreCopyWith(QuizScore value, $Res Function(QuizScore) then) =
      _$QuizScoreCopyWithImpl<$Res, QuizScore>;
  @useResult
  $Res call(
      {int id,
      String quizCode,
      String quizCategory,
      int totalQuestions,
      int correctAnswers,
      double score20,
      DateTime sessionDate,
      int? durationSeconds,
      String? levelName,
      DateTime createdAt});
}

/// @nodoc
class _$QuizScoreCopyWithImpl<$Res, $Val extends QuizScore>
    implements $QuizScoreCopyWith<$Res> {
  _$QuizScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizCode = null,
    Object? quizCategory = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? score20 = null,
    Object? sessionDate = null,
    Object? durationSeconds = freezed,
    Object? levelName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      quizCode: null == quizCode
          ? _value.quizCode
          : quizCode // ignore: cast_nullable_to_non_nullable
              as String,
      quizCategory: null == quizCategory
          ? _value.quizCategory
          : quizCategory // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      score20: null == score20
          ? _value.score20
          : score20 // ignore: cast_nullable_to_non_nullable
              as double,
      sessionDate: null == sessionDate
          ? _value.sessionDate
          : sessionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      levelName: freezed == levelName
          ? _value.levelName
          : levelName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizScoreImplCopyWith<$Res>
    implements $QuizScoreCopyWith<$Res> {
  factory _$$QuizScoreImplCopyWith(
          _$QuizScoreImpl value, $Res Function(_$QuizScoreImpl) then) =
      __$$QuizScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String quizCode,
      String quizCategory,
      int totalQuestions,
      int correctAnswers,
      double score20,
      DateTime sessionDate,
      int? durationSeconds,
      String? levelName,
      DateTime createdAt});
}

/// @nodoc
class __$$QuizScoreImplCopyWithImpl<$Res>
    extends _$QuizScoreCopyWithImpl<$Res, _$QuizScoreImpl>
    implements _$$QuizScoreImplCopyWith<$Res> {
  __$$QuizScoreImplCopyWithImpl(
      _$QuizScoreImpl _value, $Res Function(_$QuizScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizCode = null,
    Object? quizCategory = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? score20 = null,
    Object? sessionDate = null,
    Object? durationSeconds = freezed,
    Object? levelName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$QuizScoreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      quizCode: null == quizCode
          ? _value.quizCode
          : quizCode // ignore: cast_nullable_to_non_nullable
              as String,
      quizCategory: null == quizCategory
          ? _value.quizCategory
          : quizCategory // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      score20: null == score20
          ? _value.score20
          : score20 // ignore: cast_nullable_to_non_nullable
              as double,
      sessionDate: null == sessionDate
          ? _value.sessionDate
          : sessionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      levelName: freezed == levelName
          ? _value.levelName
          : levelName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizScoreImpl implements _QuizScore {
  const _$QuizScoreImpl(
      {required this.id,
      required this.quizCode,
      required this.quizCategory,
      required this.totalQuestions,
      required this.correctAnswers,
      required this.score20,
      required this.sessionDate,
      this.durationSeconds,
      this.levelName,
      required this.createdAt});

  factory _$QuizScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizScoreImplFromJson(json);

  @override
  final int id;
  @override
  final String quizCode;
// 'GEO_CAP', 'MATH_HABILETES', 'SVT_EVA', etc.
  @override
  final String quizCategory;
// 'Géographie', 'Mathématiques', 'SVT Terminale'
  @override
  final int totalQuestions;
// Nombre total de questions du quiz
  @override
  final int correctAnswers;
// Nombre de bonnes réponses
  @override
  final double score20;
// Note sur 20 calculée
  @override
  final DateTime sessionDate;
// Date de la session
  @override
  final int? durationSeconds;
// Durée du quiz en secondes (optionnel)
  @override
  final String? levelName;
// Niveau de difficulté (optionnel)
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'QuizScore(id: $id, quizCode: $quizCode, quizCategory: $quizCategory, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, score20: $score20, sessionDate: $sessionDate, durationSeconds: $durationSeconds, levelName: $levelName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizScoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizCode, quizCode) ||
                other.quizCode == quizCode) &&
            (identical(other.quizCategory, quizCategory) ||
                other.quizCategory == quizCategory) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.score20, score20) || other.score20 == score20) &&
            (identical(other.sessionDate, sessionDate) ||
                other.sessionDate == sessionDate) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.levelName, levelName) ||
                other.levelName == levelName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quizCode,
      quizCategory,
      totalQuestions,
      correctAnswers,
      score20,
      sessionDate,
      durationSeconds,
      levelName,
      createdAt);

  /// Create a copy of QuizScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizScoreImplCopyWith<_$QuizScoreImpl> get copyWith =>
      __$$QuizScoreImplCopyWithImpl<_$QuizScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizScoreImplToJson(
      this,
    );
  }
}

abstract class _QuizScore implements QuizScore {
  const factory _QuizScore(
      {required final int id,
      required final String quizCode,
      required final String quizCategory,
      required final int totalQuestions,
      required final int correctAnswers,
      required final double score20,
      required final DateTime sessionDate,
      final int? durationSeconds,
      final String? levelName,
      required final DateTime createdAt}) = _$QuizScoreImpl;

  factory _QuizScore.fromJson(Map<String, dynamic> json) =
      _$QuizScoreImpl.fromJson;

  @override
  int get id;
  @override
  String get quizCode; // 'GEO_CAP', 'MATH_HABILETES', 'SVT_EVA', etc.
  @override
  String get quizCategory; // 'Géographie', 'Mathématiques', 'SVT Terminale'
  @override
  int get totalQuestions; // Nombre total de questions du quiz
  @override
  int get correctAnswers; // Nombre de bonnes réponses
  @override
  double get score20; // Note sur 20 calculée
  @override
  DateTime get sessionDate; // Date de la session
  @override
  int? get durationSeconds; // Durée du quiz en secondes (optionnel)
  @override
  String? get levelName; // Niveau de difficulté (optionnel)
  @override
  DateTime get createdAt;

  /// Create a copy of QuizScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizScoreImplCopyWith<_$QuizScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizStatistics _$QuizStatisticsFromJson(Map<String, dynamic> json) {
  return _QuizStatistics.fromJson(json);
}

/// @nodoc
mixin _$QuizStatistics {
  String get quizCode => throw _privateConstructorUsedError;
  String get quizCategory => throw _privateConstructorUsedError;
  String get quizTitle => throw _privateConstructorUsedError;
  int get totalSessions =>
      throw _privateConstructorUsedError; // Nombre total de sessions
  double get averageScore =>
      throw _privateConstructorUsedError; // Moyenne des scores
  double get bestScore => throw _privateConstructorUsedError; // Meilleur score
  double get worstScore => throw _privateConstructorUsedError; // Pire score
  int get totalQuestions =>
      throw _privateConstructorUsedError; // Total des questions (toutes sessions)
  int get totalCorrectAnswers =>
      throw _privateConstructorUsedError; // Total des bonnes réponses
  double get overallPercentage =>
      throw _privateConstructorUsedError; // Pourcentage global de réussite
  DateTime? get lastSessionDate =>
      throw _privateConstructorUsedError; // Date de la dernière session
  int? get averageDurationSeconds => throw _privateConstructorUsedError;

  /// Serializes this QuizStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStatisticsCopyWith<QuizStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStatisticsCopyWith<$Res> {
  factory $QuizStatisticsCopyWith(
          QuizStatistics value, $Res Function(QuizStatistics) then) =
      _$QuizStatisticsCopyWithImpl<$Res, QuizStatistics>;
  @useResult
  $Res call(
      {String quizCode,
      String quizCategory,
      String quizTitle,
      int totalSessions,
      double averageScore,
      double bestScore,
      double worstScore,
      int totalQuestions,
      int totalCorrectAnswers,
      double overallPercentage,
      DateTime? lastSessionDate,
      int? averageDurationSeconds});
}

/// @nodoc
class _$QuizStatisticsCopyWithImpl<$Res, $Val extends QuizStatistics>
    implements $QuizStatisticsCopyWith<$Res> {
  _$QuizStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizCode = null,
    Object? quizCategory = null,
    Object? quizTitle = null,
    Object? totalSessions = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? worstScore = null,
    Object? totalQuestions = null,
    Object? totalCorrectAnswers = null,
    Object? overallPercentage = null,
    Object? lastSessionDate = freezed,
    Object? averageDurationSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      quizCode: null == quizCode
          ? _value.quizCode
          : quizCode // ignore: cast_nullable_to_non_nullable
              as String,
      quizCategory: null == quizCategory
          ? _value.quizCategory
          : quizCategory // ignore: cast_nullable_to_non_nullable
              as String,
      quizTitle: null == quizTitle
          ? _value.quizTitle
          : quizTitle // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      averageScore: null == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double,
      bestScore: null == bestScore
          ? _value.bestScore
          : bestScore // ignore: cast_nullable_to_non_nullable
              as double,
      worstScore: null == worstScore
          ? _value.worstScore
          : worstScore // ignore: cast_nullable_to_non_nullable
              as double,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectAnswers: null == totalCorrectAnswers
          ? _value.totalCorrectAnswers
          : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      overallPercentage: null == overallPercentage
          ? _value.overallPercentage
          : overallPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastSessionDate: freezed == lastSessionDate
          ? _value.lastSessionDate
          : lastSessionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      averageDurationSeconds: freezed == averageDurationSeconds
          ? _value.averageDurationSeconds
          : averageDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizStatisticsImplCopyWith<$Res>
    implements $QuizStatisticsCopyWith<$Res> {
  factory _$$QuizStatisticsImplCopyWith(_$QuizStatisticsImpl value,
          $Res Function(_$QuizStatisticsImpl) then) =
      __$$QuizStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String quizCode,
      String quizCategory,
      String quizTitle,
      int totalSessions,
      double averageScore,
      double bestScore,
      double worstScore,
      int totalQuestions,
      int totalCorrectAnswers,
      double overallPercentage,
      DateTime? lastSessionDate,
      int? averageDurationSeconds});
}

/// @nodoc
class __$$QuizStatisticsImplCopyWithImpl<$Res>
    extends _$QuizStatisticsCopyWithImpl<$Res, _$QuizStatisticsImpl>
    implements _$$QuizStatisticsImplCopyWith<$Res> {
  __$$QuizStatisticsImplCopyWithImpl(
      _$QuizStatisticsImpl _value, $Res Function(_$QuizStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizCode = null,
    Object? quizCategory = null,
    Object? quizTitle = null,
    Object? totalSessions = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? worstScore = null,
    Object? totalQuestions = null,
    Object? totalCorrectAnswers = null,
    Object? overallPercentage = null,
    Object? lastSessionDate = freezed,
    Object? averageDurationSeconds = freezed,
  }) {
    return _then(_$QuizStatisticsImpl(
      quizCode: null == quizCode
          ? _value.quizCode
          : quizCode // ignore: cast_nullable_to_non_nullable
              as String,
      quizCategory: null == quizCategory
          ? _value.quizCategory
          : quizCategory // ignore: cast_nullable_to_non_nullable
              as String,
      quizTitle: null == quizTitle
          ? _value.quizTitle
          : quizTitle // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      averageScore: null == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double,
      bestScore: null == bestScore
          ? _value.bestScore
          : bestScore // ignore: cast_nullable_to_non_nullable
              as double,
      worstScore: null == worstScore
          ? _value.worstScore
          : worstScore // ignore: cast_nullable_to_non_nullable
              as double,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectAnswers: null == totalCorrectAnswers
          ? _value.totalCorrectAnswers
          : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      overallPercentage: null == overallPercentage
          ? _value.overallPercentage
          : overallPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastSessionDate: freezed == lastSessionDate
          ? _value.lastSessionDate
          : lastSessionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      averageDurationSeconds: freezed == averageDurationSeconds
          ? _value.averageDurationSeconds
          : averageDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizStatisticsImpl implements _QuizStatistics {
  const _$QuizStatisticsImpl(
      {required this.quizCode,
      required this.quizCategory,
      required this.quizTitle,
      required this.totalSessions,
      required this.averageScore,
      required this.bestScore,
      required this.worstScore,
      required this.totalQuestions,
      required this.totalCorrectAnswers,
      required this.overallPercentage,
      this.lastSessionDate,
      this.averageDurationSeconds});

  factory _$QuizStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizStatisticsImplFromJson(json);

  @override
  final String quizCode;
  @override
  final String quizCategory;
  @override
  final String quizTitle;
  @override
  final int totalSessions;
// Nombre total de sessions
  @override
  final double averageScore;
// Moyenne des scores
  @override
  final double bestScore;
// Meilleur score
  @override
  final double worstScore;
// Pire score
  @override
  final int totalQuestions;
// Total des questions (toutes sessions)
  @override
  final int totalCorrectAnswers;
// Total des bonnes réponses
  @override
  final double overallPercentage;
// Pourcentage global de réussite
  @override
  final DateTime? lastSessionDate;
// Date de la dernière session
  @override
  final int? averageDurationSeconds;

  @override
  String toString() {
    return 'QuizStatistics(quizCode: $quizCode, quizCategory: $quizCategory, quizTitle: $quizTitle, totalSessions: $totalSessions, averageScore: $averageScore, bestScore: $bestScore, worstScore: $worstScore, totalQuestions: $totalQuestions, totalCorrectAnswers: $totalCorrectAnswers, overallPercentage: $overallPercentage, lastSessionDate: $lastSessionDate, averageDurationSeconds: $averageDurationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatisticsImpl &&
            (identical(other.quizCode, quizCode) ||
                other.quizCode == quizCode) &&
            (identical(other.quizCategory, quizCategory) ||
                other.quizCategory == quizCategory) &&
            (identical(other.quizTitle, quizTitle) ||
                other.quizTitle == quizTitle) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.worstScore, worstScore) ||
                other.worstScore == worstScore) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.totalCorrectAnswers, totalCorrectAnswers) ||
                other.totalCorrectAnswers == totalCorrectAnswers) &&
            (identical(other.overallPercentage, overallPercentage) ||
                other.overallPercentage == overallPercentage) &&
            (identical(other.lastSessionDate, lastSessionDate) ||
                other.lastSessionDate == lastSessionDate) &&
            (identical(other.averageDurationSeconds, averageDurationSeconds) ||
                other.averageDurationSeconds == averageDurationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      quizCode,
      quizCategory,
      quizTitle,
      totalSessions,
      averageScore,
      bestScore,
      worstScore,
      totalQuestions,
      totalCorrectAnswers,
      overallPercentage,
      lastSessionDate,
      averageDurationSeconds);

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      __$$QuizStatisticsImplCopyWithImpl<_$QuizStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizStatisticsImplToJson(
      this,
    );
  }
}

abstract class _QuizStatistics implements QuizStatistics {
  const factory _QuizStatistics(
      {required final String quizCode,
      required final String quizCategory,
      required final String quizTitle,
      required final int totalSessions,
      required final double averageScore,
      required final double bestScore,
      required final double worstScore,
      required final int totalQuestions,
      required final int totalCorrectAnswers,
      required final double overallPercentage,
      final DateTime? lastSessionDate,
      final int? averageDurationSeconds}) = _$QuizStatisticsImpl;

  factory _QuizStatistics.fromJson(Map<String, dynamic> json) =
      _$QuizStatisticsImpl.fromJson;

  @override
  String get quizCode;
  @override
  String get quizCategory;
  @override
  String get quizTitle;
  @override
  int get totalSessions; // Nombre total de sessions
  @override
  double get averageScore; // Moyenne des scores
  @override
  double get bestScore; // Meilleur score
  @override
  double get worstScore; // Pire score
  @override
  int get totalQuestions; // Total des questions (toutes sessions)
  @override
  int get totalCorrectAnswers; // Total des bonnes réponses
  @override
  double get overallPercentage; // Pourcentage global de réussite
  @override
  DateTime? get lastSessionDate; // Date de la dernière session
  @override
  int? get averageDurationSeconds;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
