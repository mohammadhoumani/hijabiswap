// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesResponse _$FavoritesResponseFromJson(Map<String, dynamic> json) =>
    FavoritesResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => FavoriteProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$FavoritesResponseToJson(FavoritesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

FavoriteProduct _$FavoriteProductFromJson(Map<String, dynamic> json) =>
    FavoriteProduct(
      id: json['_id'] as String,
      userId: ProductUser.fromJson(json['userId'] as Map<String, dynamic>),
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
      height: (json['height'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool,
      condition: json['condition'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['__v'] as num).toInt(),
    );

Map<String, dynamic> _$FavoriteProductToJson(FavoriteProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId.toJson(),
      'name_pk': instance.namePk,
      'size': instance.size,
      'type': instance.type,
      'color': instance.color,
      'category': instance.category,
      'description': instance.description,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'height': instance.height,
      'weight': instance.weight,
      'isAvailable': instance.isAvailable,
      'condition': instance.condition,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.version,
    };
