// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponse _$ProductsResponseFromJson(Map<String, dynamic> json) =>
    ProductsResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ProductsResponseToJson(ProductsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['_id'] as String,
  userId:
      json['userId'] == null
          ? null
          : ProductUser.fromJson(json['userId'] as Map<String, dynamic>),
  namePk: json['name_pk'] as String,
  size: json['size'] as String,
  type: json['type'] as String,
  color: (json['color'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
  description: json['description'] as String,
  images:
      (json['images'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
  isLiked: json['isLiked'] as bool,
  isRequested: json['isRequested'] as bool,
  isAvailable: json['isAvailable'] as bool,
  condition: json['condition'] as String,
  likesCount: (json['likesCount'] as num).toInt(),
  height: (json['height'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId?.toJson(),
  'name_pk': instance.namePk,
  'size': instance.size,
  'type': instance.type,
  'color': instance.color,
  'category': instance.category,
  'description': instance.description,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'isAvailable': instance.isAvailable,
  'condition': instance.condition,
  'likesCount': instance.likesCount,
  'isLiked': instance.isLiked,
  'isRequested': instance.isRequested,
  'height': instance.height,
  'weight': instance.weight,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  '__v': instance.version,
};

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
  url: json['url'] as String,
  publicId: json['publicId'] as String,
);

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{'url': instance.url, 'publicId': instance.publicId};

ProductUser _$ProductUserFromJson(Map<String, dynamic> json) => ProductUser(
  id: json['_id'] as String,
  name: json['name'] as String,
  city: json['city'] as String,
  ratings:
      (json['ratings'] as List<dynamic>?)
          ?.map((e) => UserRating.fromJson(e as Map<String, dynamic>))
          .toList(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProductUserToJson(ProductUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'ratings': instance.ratings?.map((e) => e.toJson()).toList(),
      'averageRating': instance.averageRating,
    };

UserRating _$UserRatingFromJson(Map<String, dynamic> json) => UserRating(
  id: json['_id'] as String,
  userIdPk: json['userId_pk'] as String,
  rating: (json['rating'] as num).toInt(),
);

Map<String, dynamic> _$UserRatingToJson(UserRating instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId_pk': instance.userIdPk,
      'rating': instance.rating,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'pages': instance.pages,
    };

MyProductsResponse _$MyProductsResponseFromJson(Map<String, dynamic> json) =>
    MyProductsResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => MyProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$MyProductsResponseToJson(MyProductsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

MyProduct _$MyProductFromJson(Map<String, dynamic> json) => MyProduct(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  namePk: json['name_pk'] as String,
  size: json['size'] as String,
  type: json['type'] as String,
  color: (json['color'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
  description: json['description'] as String,
  images:
      (json['images'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
  isAvailable: json['isAvailable'] as bool,
  condition: json['condition'] as String,
  likesCount: (json['likesCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$MyProductToJson(MyProduct instance) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId,
  'name_pk': instance.namePk,
  'size': instance.size,
  'type': instance.type,
  'color': instance.color,
  'category': instance.category,
  'description': instance.description,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'isAvailable': instance.isAvailable,
  'condition': instance.condition,
  'likesCount': instance.likesCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  '__v': instance.version,
};
