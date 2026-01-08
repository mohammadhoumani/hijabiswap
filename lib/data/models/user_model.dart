import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id; // was int; API returns string
  final String name;
  final String? city;
  final bool? emailIsConfirm;
  final DateTime? createdAt;
  final String? email; // optional: not present in login payload

  UserModel({
    required this.id,
    required this.name,
    this.city,
    this.emailIsConfirm,
    this.createdAt,
    this.email,
  });

  // FROM JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // TO JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
