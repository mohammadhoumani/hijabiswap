import 'package:json_annotation/json_annotation.dart';

part 'products_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductsResponse {
  final bool success;
  final List<Product> data;
  final Pagination pagination;

  ProductsResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(name: '_id')
  final String id;

  final ProductUser? userId;

  @JsonKey(name: 'name_pk')
  final String namePk;

  final String size;
  final String type;
  final List<String> color;
  final String category;
  final String description;
  final List<ProductImage> images;
  final bool isAvailable;
  final String condition;
  final int likesCount;
  final bool isLiked;
  final bool isRequested;
  final int? height;
  final int? weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  Product({
    required this.id,
    this.userId,
    required this.namePk,
    required this.size,
    required this.type,
    required this.color,
    required this.category,
    required this.description,
    required this.images,
    required this.isLiked,
    required this.isRequested,
    required this.isAvailable,
    required this.condition,
    required this.likesCount,
    this.height,
    this.weight,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class ProductImage {
  final String url;
  final String publicId;

  ProductImage({required this.url, required this.publicId});

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductUser {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String city;
  final List<UserRating>? ratings;
  final double? averageRating;

  ProductUser({
    required this.id,
    required this.name,
    required this.city,
    this.ratings,
    this.averageRating,
  });

  factory ProductUser.fromJson(Map<String, dynamic> json) =>
      _$ProductUserFromJson(json);

  Map<String, dynamic> toJson() => _$ProductUserToJson(this);
}

@JsonSerializable()
class UserRating {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'userId_pk')
  final String userIdPk;

  final int rating;

  UserRating({required this.id, required this.userIdPk, required this.rating});

  factory UserRating.fromJson(Map<String, dynamic> json) =>
      _$UserRatingFromJson(json);

  Map<String, dynamic> toJson() => _$UserRatingToJson(this);
}

@JsonSerializable()
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MyProductsResponse {
  final bool success;
  final List<MyProduct> data;

  MyProductsResponse({required this.success, required this.data});

  factory MyProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyProductsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MyProduct {
  @JsonKey(name: '_id')
  final String id;

  final String userId;

  @JsonKey(name: 'name_pk')
  final String namePk;

  final String size;
  final String type;
  final List<String> color;
  final String category;
  final String description;
  final List<ProductImage> images;
  final bool isAvailable;
  final String condition;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  MyProduct({
    required this.id,
    required this.userId,
    required this.namePk,
    required this.size,
    required this.type,
    required this.color,
    required this.category,
    required this.description,
    required this.images,
    required this.isAvailable,
    required this.condition,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory MyProduct.fromJson(Map<String, dynamic> json) =>
      _$MyProductFromJson(json);

  Map<String, dynamic> toJson() => _$MyProductToJson(this);
}
