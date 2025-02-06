import 'dart:convert';

AppointmentDetailResponse appointmentDetailResponseFromJson(String str) =>
    AppointmentDetailResponse.fromJson(json.decode(str));

String appointmentDetailResponseToJson(AppointmentDetailResponse data) =>
    json.encode(data.toJson());

class AppointmentDetailResponse {
  bool? status;
  String? message;
  AppointmentDetailModel? data;
  dynamic token;

  AppointmentDetailResponse({
    this.status,
    this.message,
    this.data,
    this.token,
  });

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : AppointmentDetailModel.fromJson(
              json['data'] as Map<String, dynamic>),
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

class AppointmentDetailModel {
  String? id;
  String? appointmentDate;
  String? bookingDateTime;
  dynamic appointmentTime;
  String? doctorId;
  String? gender;
  String? doctorName;
  String? doctorEducation;
  String? languages;
  String? doctorImageUrl;
  String? hospitalId;
  String? hospitalName;
  dynamic message;
  String? patientCurrentStatus;
  String? hospitalImageUrl;
  String? doctorExperience;
  String? specializationId;
  String? specialization;
  String? userId;
  String? userName;
  dynamic userEmail;
  String? userMobileNumber;
  String? dateOfBirth;
  num? age;
  String? relation;
  String? timings;
  num? height;
  num? weight;
  num? status;
  num? consultationFees;
  String? spocId;
  String? spocName;
  String? spocContactNUmber;
  String? spocEmail;
  String? spocHospitalName;
  String? isSpocAssigned;
  List<dynamic>? comments;
  List<dynamic>? events;
  bookedSlot? bookedslot;

  AppointmentDetailModel({
    this.id,
    this.appointmentDate,
    this.bookingDateTime,
    this.appointmentTime,
    this.doctorId,
    this.gender,
    this.doctorName,
    this.doctorEducation,
    this.languages,
    this.doctorImageUrl,
    this.hospitalId,
    this.timings,
    this.hospitalName,
    this.message,
    this.hospitalImageUrl,
    this.doctorExperience,
    this.specializationId,
    this.specialization,
    this.userId,
    this.patientCurrentStatus,
    this.userName,
    this.userEmail,
    this.userMobileNumber,
    this.dateOfBirth,
    this.age,
    this.relation,
    this.height,
    this.weight,
    this.status,
    this.consultationFees,
    this.spocId,
    this.spocName,
    this.spocContactNUmber,
    this.spocEmail,
    this.isSpocAssigned,
    this.spocHospitalName,
    this.comments,
    this.events,
    this.bookedslot,
  });

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailModel(
        id: json['id'] as String?,
        appointmentDate: json['appointmentDate'] as String?,
        bookingDateTime: json['bookingDateTime'] as String?,
        appointmentTime: json['appointmentTime'] as dynamic,
        doctorId: json['doctorId'] as String?,
        gender: json['gender'] as String?,
        doctorName: json['doctorName'] as String?,
        doctorEducation: json['doctorEducation'] as String?,
        languages: json['languages'] as String?,
        patientCurrentStatus: json['patientCurrentStatus'] as String?,
        timings: json['timings'] as String?,
        doctorImageUrl: json['doctorImageUrl'] as String?,
        hospitalId: json['hospitalId'] as String?,
        hospitalName: json['hospitalName'] as String?,
        message: json['message'] as dynamic,
        hospitalImageUrl: json['hospitalImageUrl'] as String?,
        doctorExperience: json['doctorExperience'] as String?,
        specializationId: json['specializationId'] as String?,
        specialization: json['specialization'] as String?,
        userId: json['userId'] as String?,
        userName: json['userName'] as String?,
        userEmail: json['userEmail'] as dynamic,
        userMobileNumber: json['userMobileNumber'] as String?,
        dateOfBirth: json['dateOfBirth'] as String?,
        age: json['age'] as num?,
        relation: json['relation'] as String?,
        height: json['height'] as num?,
        weight: json['weight'] as num?,
        status: json['status'] as num?,
        consultationFees: json['consultationFees'] as num?,
        spocId: json['spocId'] as String?,
        spocName: json['spocName'] as String?,
        spocContactNUmber: json['spocContactNUmber'] as String?,
        spocEmail: json['spocEmail'] as String?,
        isSpocAssigned: json['isSpocAssigned'] as String?,
        spocHospitalName: json['spocHospitalName'] as String?,
        comments: json['comments'] as List<dynamic>?,
        events: json['events'] as List<dynamic>?,
        bookedslot: json['slot'] == null
            ? null
            : bookedSlot.fromJson(json['slot'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'appointmentDate': appointmentDate,
        'bookingDateTime': bookingDateTime,
        'appointmentTime': appointmentTime,
        'doctorId': doctorId,
        'gender': gender,
        'doctorName': doctorName,
        'doctorEducation': doctorEducation,
        'languages': languages,
        'doctorImageUrl': doctorImageUrl,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'patientCurrentStatus': patientCurrentStatus,
        'message': message,
        'timings': timings,
        'hospitalImageUrl': hospitalImageUrl,
        'doctorExperience': doctorExperience,
        'specializationId': specializationId,
        'specialization': specialization,
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'userMobileNumber': userMobileNumber,
        'dateOfBirth': dateOfBirth,
        'age': age,
        'relation': relation,
        'height': height,
        'weight': weight,
        'status': status,
        'consultationFees': consultationFees,
        'spocId': spocId,
        'spocName': spocName,
        'spocContactNUmber': spocContactNUmber,
        'spocEmail': spocEmail,
        'isSpocAssigned': isSpocAssigned,
        'spocHospitalName': spocHospitalName,
        'comments': comments,
        'events': events,
        'slot': bookedslot?.toJson(),
      };
}

class bookedSlot {
  String? id;
  String? slotName;
  String? startTime;
  String? endTime;
  int? displayOrder;
  bool? checked;

  bookedSlot({
    this.id,
    this.slotName,
    this.startTime,
    this.endTime,
    this.displayOrder,
    this.checked,
  });

  factory bookedSlot.fromJson(Map<String, dynamic> json) => bookedSlot(
        id: json['id'] as String?,
        slotName: json['slotName'] as String?,
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        displayOrder: json['displayOrder'] as int?,
        checked: json['checked'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slotName': slotName,
        'startTime': startTime,
        'endTime': endTime,
        'displayOrder': displayOrder,
        'checked': checked,
      };
}
