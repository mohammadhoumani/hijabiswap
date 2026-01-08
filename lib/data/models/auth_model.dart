import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  final bool success;
  final String? message; // present in API
  final LoginData data;

  LoginResponse({required this.success, this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LoginData {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  LoginData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RegisterResponse {
  final bool success;
  final String? message; // top-level message
  final RegisterData data;

  RegisterResponse({required this.success, this.message, required this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RegisterData {
  final UserModel user;
  final String? message; // nested message from data.message

  RegisterData({required this.user, this.message});

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
