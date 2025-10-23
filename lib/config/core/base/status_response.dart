class StatusResponse {
  final String code;
  final String type;
  final String text;
  final String message;
  final bool failure;

  StatusResponse({
    this.code = '',
    this.type = '',
    this.text = '',
    this.message = '',
    this.failure = false,
  });

  factory StatusResponse.fromMap(Map<String, dynamic> map) {
    return StatusResponse(
      code: map['status']?['code'] ?? '',
      type: map['status']?['type'] ?? '',
      text: map['status']?['text'] ?? '',
      message: map['message'] ?? '',
      failure: map['failure'] ?? true,
    );
  }

  factory StatusResponse.fromJson(Map<String, dynamic> map) {
    return StatusResponse(
      code: map['status']?['code'] ?? '',
      type: map['status']?['type'] ?? '',
      text: map['status']?['text'] ?? '',
      message: map['message'] ?? '',
      failure: map['code'] != 200 ? true : false,
    );
  }

  // factory StatusResponse.fromData(Map<String, dynamic> map) {
  //   return StatusResponse(
  //     code: map['data']?['status']?['code'] ?? '',
  //     type: map['data']?['status']?['type'] ?? '',
  //     text: map['data']?['status']?['text'] ?? '',
  //     message: map['data']?['message'] ?? '',
  //     failure: map['data']?['failure'] ?? true,
  //   );
  // }

  factory StatusResponse.exception(Object e) {
    return StatusResponse(
      text: "[Mobile Exception] : ${e.toString()}",
      failure: true,
    );
  }

  factory StatusResponse.plain(String text) {
    return StatusResponse(
      text: text,
      failure: true,
    );
  }

  // factory StatusResponse.cnd({String desc = '', String code = ''}) {
  //   return StatusResponse(
  //     code: code,
  //     text: desc,
  //     failure: true,
  //   );
  // }
}
