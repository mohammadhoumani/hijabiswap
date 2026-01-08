import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({required this.success, required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileData {
  @JsonKey(name: 'id')
  final String id;
  final String email;
  final String name;
  final String role;
  final String city;
  final int unreadNotificationsCount;
  final String? imageUrl;
  final Coordinates? coordinates;
  final bool emailIsConfirm;

  @JsonKey(name: 'default_ShippingAddress')
  final Map<String, dynamic>? defaultShippingAddress;

  final double averageRating;
  final int totalRatings;
  final int itemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileData({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.city,
    required this.unreadNotificationsCount,
    required this.imageUrl,
    this.coordinates,
    required this.emailIsConfirm,
    this.defaultShippingAddress,
    required this.averageRating,
    required this.totalRatings,
    required this.itemsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}

@JsonSerializable()
class Coordinates {
  @JsonKey(name: 'lat')
  final double lat;
  @JsonKey(name: 'lng')
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
