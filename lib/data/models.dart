import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool status,
    required int statusCode,
    String? message,
    required T data,
  }) = _ApiResponse<T>;

  // When using generics, you must include a function parameter to deserialize T.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}
/// User Model
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? name,
    required String email,
    String? password,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Media with _$Media {
  const factory Media({
    required String id,
    required String? title,
    required String type,
    required String url,
    required String? description,
    required User? uploadedUser,
    required String? uploadedUserId,
    required String? reference,
    required String? batchId,
    required Batch? batch,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

@freezed
abstract class Batch with _$Batch {
  const factory Batch({
    required String id,
    required String? name,
    required String? reference,
    required String userId,
    required User createdBy,
    required List<Media> media,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);
}



