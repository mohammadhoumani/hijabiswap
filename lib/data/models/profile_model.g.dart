// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      success: json['success'] as bool,
      data: ProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  city: json['city'] as String,
  unreadNotificationsCount: (json['unreadNotificationsCount'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
  coordinates:
      json['coordinates'] == null
          ? null
          : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
  emailIsConfirm: json['emailIsConfirm'] as bool,
  defaultShippingAddress:
      json['default_ShippingAddress'] as Map<String, dynamic>?,
  averageRating: (json['averageRating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  itemsCount: (json['itemsCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'city': instance.city,
      'unreadNotificationsCount': instance.unreadNotificationsCount,
      'imageUrl': instance.imageUrl,
      'coordinates': instance.coordinates?.toJson(),
      'emailIsConfirm': instance.emailIsConfirm,
      'default_ShippingAddress': instance.defaultShippingAddress,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
      'itemsCount': instance.itemsCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
