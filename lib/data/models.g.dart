// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ApiResponse<T>(
  status: json['status'] as bool,
  statusCode: (json['statusCode'] as num).toInt(),
  message: json['message'] as String?,
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  _ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'status': instance.status,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': toJsonT(instance.data),
};

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String,
  password: json['password'] as String?,
  profile: json['profile'] as String?,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  uploadedMedia:
      (json['uploadedMedia'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdBatches:
      (json['createdBatches'] as List<dynamic>?)
          ?.map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'profile': instance.profile,
  'role': instance.role,
  'phone': instance.phone,
  'uploadedMedia': instance.uploadedMedia,
  'createdBatches': instance.createdBatches,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
  id: json['id'] as String,
  title: json['title'] as String?,
  type: json['type'] as String,
  url: json['url'] as String,
  uploadedUser:
      json['uploadedUser'] == null
          ? null
          : User.fromJson(json['uploadedUser'] as Map<String, dynamic>),
  uploadedUserId: json['uploadedUserId'] as String?,
  reference: json['reference'] as String?,
  batchId: json['batchId'] as String?,
  batch:
      json['batch'] == null
          ? null
          : Batch.fromJson(json['batch'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'url': instance.url,
  'uploadedUser': instance.uploadedUser,
  'uploadedUserId': instance.uploadedUserId,
  'reference': instance.reference,
  'batchId': instance.batchId,
  'batch': instance.batch,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_Batch _$BatchFromJson(Map<String, dynamic> json) => _Batch(
  id: json['id'] as String,
  name: json['name'] as String?,
  reference: json['reference'] as String?,
  userId: json['userId'] as String,
  createdBy:
      json['createdBy'] == null
          ? null
          : User.fromJson(json['createdBy'] as Map<String, dynamic>),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BatchToJson(_Batch instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'reference': instance.reference,
  'userId': instance.userId,
  'createdBy': instance.createdBy,
  'media': instance.media,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
