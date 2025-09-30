// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizScoreImpl _$$QuizScoreImplFromJson(Map<String, dynamic> json) =>
    _$QuizScoreImpl(
      id: (json['id'] as num).toInt(),
      quizCode: json['quizCode'] as String,
      quizCategory: json['quizCategory'] as String,
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      score20: (json['score20'] as num).toDouble(),
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      levelName: json['levelName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$QuizScoreImplToJson(_$QuizScoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizCode': instance.quizCode,
      'quizCategory': instance.quizCategory,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'score20': instance.score20,
      'sessionDate': instance.sessionDate.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'levelName': instance.levelName,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$QuizStatisticsImpl _$$QuizStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$QuizStatisticsImpl(
      quizCode: json['quizCode'] as String,
      quizCategory: json['quizCategory'] as String,
      quizTitle: json['quizTitle'] as String,
      totalSessions: (json['totalSessions'] as num).toInt(),
      averageScore: (json['averageScore'] as num).toDouble(),
      bestScore: (json['bestScore'] as num).toDouble(),
      worstScore: (json['worstScore'] as num).toDouble(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num).toInt(),
      overallPercentage: (json['overallPercentage'] as num).toDouble(),
      lastSessionDate: json['lastSessionDate'] == null
          ? null
          : DateTime.parse(json['lastSessionDate'] as String),
      averageDurationSeconds: (json['averageDurationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuizStatisticsImplToJson(
        _$QuizStatisticsImpl instance) =>
    <String, dynamic>{
      'quizCode': instance.quizCode,
      'quizCategory': instance.quizCategory,
      'quizTitle': instance.quizTitle,
      'totalSessions': instance.totalSessions,
      'averageScore': instance.averageScore,
      'bestScore': instance.bestScore,
      'worstScore': instance.worstScore,
      'totalQuestions': instance.totalQuestions,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'overallPercentage': instance.overallPercentage,
      'lastSessionDate': instance.lastSessionDate?.toIso8601String(),
      'averageDurationSeconds': instance.averageDurationSeconds,
    };
