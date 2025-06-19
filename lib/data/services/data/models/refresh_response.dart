import 'package:json_annotation/json_annotation.dart';

part 'refresh_response.g.dart';

@JsonSerializable()
class RefreshResponse {
  @JsonKey(name: 'is_need_to_refresh')
  final bool isNeedToRefresh;

  final String message;

  RefreshResponse({
    required this.isNeedToRefresh,
    required this.message,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) => _$RefreshResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshResponseToJson(this);
}