import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';

part 'access_token_response.g.dart';

@JsonSerializable()
class AccessTokenResponse extends BaseResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;

  AccessTokenResponse(super.message, this.accessToken);

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) => _$AccessTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}
