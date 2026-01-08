// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityResponse _$ActivityResponseFromJson(Map<String, dynamic> json) =>
    ActivityResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => ActivityRequest.fromJson(e as Map<String, dynamic>))
              .toList(),
      count: (json['count'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityResponseToJson(ActivityResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'limit': instance.limit,
    };

ActivityRequest _$ActivityRequestFromJson(Map<String, dynamic> json) =>
    ActivityRequest(
      id: json['_id'] as String,
      userId: PersonRef.fromDynamic(json['userId']),
      ownerId: PersonRef.fromDynamic(json['ownerId']),
      itemId:
          json['itemId'] == null
              ? null
              : ActivityItem.fromJson(json['itemId'] as Map<String, dynamic>),
      status: json['status'] as String,
      message: json['message'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['__v'] as num).toInt(),
      autoCancelScheduledAt:
          json['autoCancel_scheduledAt'] == null
              ? null
              : DateTime.parse(json['autoCancel_scheduledAt'] as String),
      respondedAt:
          json['respondedAt'] == null
              ? null
              : DateTime.parse(json['respondedAt'] as String),
      confirmedAt:
          json['confirmedAt'] == null
              ? null
              : DateTime.parse(json['confirmedAt'] as String),
      isRated: json['isRated'] as bool?,
      rate:
          json['rate'] == null
              ? null
              : ActivityRate.fromJson(json['rate'] as Map<String, dynamic>),
      cancellationReason: json['cancellationReason'] as String?,
      shippingAddress:
          json['shippingAddress'] == null
              ? null
              : ShippingAddress.fromJson(
                json['shippingAddress'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$ActivityRequestToJson(
  ActivityRequest instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': PersonRef.toDynamic(instance.userId),
  'ownerId': PersonRef.toDynamic(instance.ownerId),
  'itemId': instance.itemId?.toJson(),
  'status': instance.status,
  'message': instance.message,
  'requestedAt': instance.requestedAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  '__v': instance.version,
  'autoCancel_scheduledAt': instance.autoCancelScheduledAt?.toIso8601String(),
  'respondedAt': instance.respondedAt?.toIso8601String(),
  'confirmedAt': instance.confirmedAt?.toIso8601String(),
  'isRated': instance.isRated,
  'rate': instance.rate?.toJson(),
  'cancellationReason': instance.cancellationReason,
  'shippingAddress': instance.shippingAddress?.toJson(),
};

ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) => ActivityItem(
  id: json['_id'] as String,
  namePk: json['name_pk'] as String,
  images:
      (json['images'] as List<dynamic>)
          .map((e) => ActivityImage.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ActivityItemToJson(ActivityItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name_pk': instance.namePk,
      'images': instance.images,
    };

ActivityImage _$ActivityImageFromJson(Map<String, dynamic> json) =>
    ActivityImage(
      url: json['url'] as String,
      publicId: json['publicId'] as String,
    );

Map<String, dynamic> _$ActivityImageToJson(ActivityImage instance) =>
    <String, dynamic>{'url': instance.url, 'publicId': instance.publicId};

ActivityRate _$ActivityRateFromJson(Map<String, dynamic> json) => ActivityRate(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ActivityRateToJson(ActivityRate instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };
