import 'dart:convert';

RelationsModel relationsModelFromJson(String str) =>
    RelationsModel.fromJson(json.decode(str));

String relationsModelToJson(RelationsModel data) => json.encode(data.toJson());

class RelationsModel {
  bool? status;
  String? message;
  List<String>? data;
  dynamic token;

  RelationsModel({this.status, this.message, this.data, this.token});

  factory RelationsModel.fromJson(Map<String, dynamic> json) {
    return RelationsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      token: json['token'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data,
        'token': token,
      };
}
