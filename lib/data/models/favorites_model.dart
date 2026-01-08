import 'package:json_annotation/json_annotation.dart';
import 'package:hijabiswap/data/models/products_model.dart';

part 'favorites_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoritesResponse {
  final bool success;
  final List<FavoriteProduct> data;

  FavoritesResponse({required this.success, required this.data});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoritesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FavoriteProduct {
  @JsonKey(name: '_id')
  final String id;

  final ProductUser userId;

  @JsonKey(name: 'name_pk')
  final String namePk;

  final String size;
  final String type;
  final List<String> color;
  final String category;
  final String description;
  final List<ProductImage> images;
  final int? height;
  final int? weight;
  final bool isAvailable;
  final String condition;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  FavoriteProduct({
    required this.id,
    required this.userId,
    required this.namePk,
    required this.size,
    required this.type,
    required this.color,
    required this.category,
    required this.description,
    required this.images,
    this.height,
    this.weight,
    required this.isAvailable,
    required this.condition,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) =>
      _$FavoriteProductFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteProductToJson(this);
}
