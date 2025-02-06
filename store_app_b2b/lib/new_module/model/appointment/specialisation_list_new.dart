import 'dart:convert';

SpecialisationList specialisationListFromJson(String str) =>
    SpecialisationList.fromJson(json.decode(str));

String specialisationListToJson(SpecialisationList data) =>
    json.encode(data.toJson());

class SpecialisationList {
  bool? status;
  String? message;
  List<DoctorSpecialisations>? data;
  dynamic token;

  SpecialisationList({this.status, this.message, this.data, this.token});

  factory SpecialisationList.fromJson(Map<String, dynamic> json) {
    return SpecialisationList(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => DoctorSpecialisations.fromJson(e as Map<String, dynamic>))
          .toList(),
      token: json['token'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'token': token,
      };
}

class DoctorSpecialisations {
  String? id;
  String? specialization;
  String? imageUrl;
  String? mobileImage;

  DoctorSpecialisations(
      {this.id, this.specialization, this.imageUrl, this.mobileImage});

  factory DoctorSpecialisations.fromJson(Map<String, dynamic> json) =>
      DoctorSpecialisations(
        id: json['id'] as String?,
        specialization: json['specialization'] as String?,
        imageUrl: json['imageUrl'] as String?,
        mobileImage: json["mobileImage"] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'specialization': specialization,
        'imageUrl': imageUrl,
        'mobileImage': mobileImage,
      };
}
