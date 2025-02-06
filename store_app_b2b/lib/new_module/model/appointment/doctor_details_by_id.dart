import 'dart:convert';
import 'package:store_app_b2b/new_module/model/appointment/doctor_list_model.dart';

DoctorDetailsById doctorDetailsByIdFromJson(String str) =>
    DoctorDetailsById.fromJson(json.decode(str));

String doctorDetailsByIdToJson(DoctorDetailsById data) =>
    json.encode(data.toJson());

class DoctorDetailsById {
  bool? status;
  String? message;
  DoctorsDetails? data;
  dynamic token;

  DoctorDetailsById({this.status, this.message, this.data, this.token});

  factory DoctorDetailsById.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsById(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DoctorsDetails.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'token': token,
      };
}
