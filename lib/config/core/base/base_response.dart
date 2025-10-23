import 'package:you_app/config/core/base/status_response.dart';

class BaseResponse {
  final StatusResponse statusResponse;
  final dynamic datas;

  BaseResponse({
    StatusResponse? statusResponse,
    this.datas,
  }) : statusResponse = statusResponse ?? StatusResponse();

  factory BaseResponse.fromJson(Map<String, dynamic> datas) {
    return BaseResponse(
      statusResponse: StatusResponse.fromMap(datas),
      datas: datas,
    );
  }

  // factory BaseResponse.status(StatusResponse status) {
  //   return BaseResponse(statusResponse: status);
  // }

  // factory BaseResponse.exception(e) {
  //   return BaseResponse(
  //     statusResponse: StatusResponse.exception(e),
  //   );
  // }
}
