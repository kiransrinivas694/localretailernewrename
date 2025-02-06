import 'dart:convert';

AppointmentHistory appointmentHistoryFromJson(String str) =>
    AppointmentHistory.fromJson(json.decode(str));

String appointmentHistoryToJson(AppointmentHistory data) =>
    json.encode(data.toJson());

class AppointmentHistory {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  AppointmentHistory({this.status, this.message, this.data, this.token});

  factory AppointmentHistory.fromJson(Map<String, dynamic> json) {
    return AppointmentHistory(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
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

class Data {
  List<AppointmentDetails>? content;
  Pageable? pageable;
  bool? last;
  num? totalElements;
  num? totalPages;
  num? size;
  num? number;
  Sort? sort;
  bool? first;
  num? numberOfElements;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => AppointmentDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        last: json['last'] as bool?,
        totalElements: json['totalElements'] as num?,
        totalPages: json['totalPages'] as num?,
        size: json['size'] as num?,
        number: json['number'] as num?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        first: json['first'] as bool?,
        numberOfElements: json['numberOfElements'] as num?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'last': last,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'first': first,
        'numberOfElements': numberOfElements,
        'empty': empty,
      };
}

class AppointmentDetails {
  String? id;
  String? appointmentDate;
  String? bookingDateTime;
  dynamic appointmentTime;
  String? doctorId;
  dynamic doctorName;
  dynamic doctorEducation;
  dynamic doctorImageUrl;
  dynamic hospitalName;
  dynamic hospitalImageUrl;
  dynamic doctorExperience;
  dynamic specializationId;
  String? userId;
  String? userName;
  dynamic userEmail;
  dynamic userMobileNumber;
  String? dateOfBirth;
  String? patientCurrentStatus;
  num? age;
  String? relation;
  double? height;
  num? weight;
  num? status;
  dynamic consultationFees;
  String? spocId;
  String? spocName;
  dynamic spocContactNUmber;
  dynamic spocEmail;
  String? specialization;
  String? isSpocAssigned;
  String? languages;
  List<PrescList>? prescList;
  String? gender;

  AppointmentDetails(
      {this.id,
      this.appointmentDate,
      this.appointmentTime,
      this.bookingDateTime,
      this.doctorId,
      this.doctorName,
      this.doctorEducation,
      this.doctorImageUrl,
      this.hospitalName,
      this.hospitalImageUrl,
      this.doctorExperience,
      this.specializationId,
      this.userId,
      this.userName,
      this.userEmail,
      this.isSpocAssigned,
      this.patientCurrentStatus,
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
      this.languages,
      this.specialization,
      this.prescList,
      this.gender});

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) =>
      AppointmentDetails(
        id: json['id'] as String?,
        appointmentDate: json['appointmentDate'] as String?,
        appointmentTime: json['appointmentTime'] as dynamic,
        bookingDateTime: json['bookingDateTime'] as String?,
        doctorId: json['doctorId'] as String?,
        doctorName: json['doctorName'] as dynamic,
        specialization: json['specialization'] as String?,
        patientCurrentStatus: json["patientCurrentStatus"] as String?,
        languages: json['languages'] as String?,
        doctorEducation: json['doctorEducation'] as dynamic,
        doctorImageUrl: json['doctorImageUrl'] as dynamic,
        hospitalName: json['hospitalName'] as dynamic,
        hospitalImageUrl: json['hospitalImageUrl'] as dynamic,
        doctorExperience: json['doctorExperience'] as dynamic,
        specializationId: json['specializationId'] as dynamic,
        userId: json['userId'] as String?,
        userName: json['userName'] as String?,
        userEmail: json['userEmail'] as dynamic,
        isSpocAssigned: json["isSpocAssigned"] as String?,
        userMobileNumber: json['userMobileNumber'] as dynamic,
        dateOfBirth: json['dateOfBirth'] as String?,
        age: json['age'] as num?,
        relation: json['relation'] as String?,
        height: (json['height'] as num?)?.toDouble(),
        weight: json['weight'] as num?,
        status: json['status'] as num?,
        gender: json['gender'] as String?,
        consultationFees: json['consultationFees'] as dynamic,
        spocId: json['spocId'] as String?,
        spocName: json['spocName'] as String?,
        spocContactNUmber: json['spocContactNUmber'] as dynamic,
        spocEmail: json['spocEmail'] as dynamic,
        prescList: (json['prescList'] as List<dynamic>?)
            ?.map((e) => PrescList.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'appointmentDate': appointmentDate,
        'appointmentTime': appointmentTime,
        'bookingDateTime': bookingDateTime,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'languages': languages,
        "patientCurrentStatus": patientCurrentStatus,
        'specialization': specialization,
        'doctorEducation': doctorEducation,
        'doctorImageUrl': doctorImageUrl,
        'hospitalName': hospitalName,
        'hospitalImageUrl': hospitalImageUrl,
        'doctorExperience': doctorExperience,
        'specializationId': specializationId,
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
        'gender': gender,
        'spocName': spocName,
        'spocContactNUmber': spocContactNUmber,
        'spocEmail': spocEmail,
        'isSpocAssigned': isSpocAssigned,
        'prescList': prescList?.map((e) => e.toJson()).toList(),
      };
}

class Pageable {
  Sort? sort;
  num? offset;
  num? pageNumber;
  num? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as num?,
        pageNumber: json['pageNumber'] as num?,
        pageSize: json['pageSize'] as num?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort?.toJson(),
        'offset': offset,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'paged': paged,
        'unpaged': unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json['empty'] as bool?,
        sorted: json['sorted'] as bool?,
        unsorted: json['unsorted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'empty': empty,
        'sorted': sorted,
        'unsorted': unsorted,
      };
}

class PrescList {
  String? prescriptionId;
  String? imageId;

  PrescList({this.prescriptionId, this.imageId});

  PrescList.fromJson(Map<String, dynamic> json) {
    prescriptionId = json['prescriptionId'];
    imageId = json['imageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prescriptionId'] = this.prescriptionId;
    data['imageId'] = this.imageId;
    return data;
  }
}
