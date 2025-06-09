import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';

part 'is_completed_response.g.dart';

@JsonSerializable()
class IsCompletedResponse extends BaseResponse {
  final bool? success;

  IsCompletedResponse(super.message, this.success);

  bool get isSuccess => success ?? false;

  factory IsCompletedResponse.fromJson(Map<String, dynamic> json) => _$IsCompletedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IsCompletedResponseToJson(this);
}
