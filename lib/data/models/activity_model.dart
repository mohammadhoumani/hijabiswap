import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityResponse {
  final bool success;

  final List<ActivityRequest> data;
  final int? count;
  final int? page;
  final int? limit;

  ActivityResponse({
    required this.success,
    required this.data,
    this.count,
    this.page,
    this.limit,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ActivityRequest {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(fromJson: PersonRef.fromDynamicNullable, toJson: PersonRef.toDynamicNullable)
  final PersonRef? userId;

  @JsonKey(fromJson: PersonRef.fromDynamicNullable, toJson: PersonRef.toDynamicNullable)
  final PersonRef? ownerId;
  final ActivityItem? itemId;
  final String status;
  final String? message;
  final DateTime requestedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  @JsonKey(name: 'autoCancel_scheduledAt')
  final DateTime? autoCancelScheduledAt;

  final DateTime? respondedAt;
  final DateTime? confirmedAt;
  final bool? isRated;
  final ActivityRate? rate;
  final String? cancellationReason;
  final ShippingAddress? shippingAddress;

  ActivityRequest({
    required this.id,
    this.userId,
    this.ownerId,
    required this.itemId,
    required this.status,
    this.message,
    required this.requestedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.autoCancelScheduledAt,
    this.respondedAt,
    this.confirmedAt,
    this.isRated,
    this.rate,
    this.cancellationReason,
    this.shippingAddress,
  });

  factory ActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityRequestToJson(this);
}

class PersonRef {
  final String id;
  final String? name;
  final String? city;
  final bool? emailIsConfirm;

  const PersonRef({
    required this.id,
    this.name,
    this.city,
    this.emailIsConfirm,
  });

  static PersonRef fromDynamic(dynamic value) {
    if (value is String) {
      return PersonRef(id: value);
    }
    if (value is Map<String, dynamic>) {
      final id = (value['_id'] ?? value['id'] ?? '').toString();
      return PersonRef(
        id: id,
        name: value['name'] as String?,
        city: value['city'] as String?,
        emailIsConfirm: value['emailIsConfirm'] as bool?,
      );
    }
    throw ArgumentError('Invalid PersonRef value: $value');
  }

  static dynamic toDynamic(PersonRef ref) {
    // For outbound, include id plus any known fields
    return {
      '_id': ref.id,
      if (ref.name != null) 'name': ref.name,
      if (ref.city != null) 'city': ref.city,
      if (ref.emailIsConfirm != null) 'emailIsConfirm': ref.emailIsConfirm,
    };
  }

  /// Nullable version that handles null input gracefully
  static PersonRef? fromDynamicNullable(dynamic value) {
    if (value == null) return null;
    return fromDynamic(value);
  }

  /// Nullable version for serialization
  static dynamic toDynamicNullable(PersonRef? ref) {
    if (ref == null) return null;
    return toDynamic(ref);
  }
}

@JsonSerializable()
class ActivityItem {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'name_pk')
  final String namePk;

  final List<ActivityImage> images;

  ActivityItem({required this.id, required this.namePk, required this.images});

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityItemToJson(this);
}

@JsonSerializable()
class ActivityImage {
  final String url;
  final String publicId;

  ActivityImage({required this.url, required this.publicId});

  factory ActivityImage.fromJson(Map<String, dynamic> json) =>
      _$ActivityImageFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityImageToJson(this);
}

@JsonSerializable()
class ActivityRate {
  final int rating;
  final String? comment;
  final DateTime createdAt;

  ActivityRate({required this.rating, this.comment, required this.createdAt});

  factory ActivityRate.fromJson(Map<String, dynamic> json) =>
      _$ActivityRateFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityRateToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  final String street;
  final String city;
  final String postalCode;
  final String country;

  ShippingAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}
