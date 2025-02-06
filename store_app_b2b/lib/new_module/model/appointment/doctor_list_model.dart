import 'dart:convert';

DoctorsListModel doctorsListModelFromJson(String str) =>
    DoctorsListModel.fromJson(json.decode(str));

String doctorsListModelToJson(DoctorsListModel data) =>
    json.encode(data.toJson());

class DoctorsListModel {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  DoctorsListModel({this.status, this.message, this.data, this.token});

  factory DoctorsListModel.fromJson(Map<String, dynamic> json) {
    return DoctorsListModel(
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
  List<DoctorsDetails>? content;
  Pageable? pageable;
  bool? last;
  num? totalPages;
  num? totalElements;
  bool? first;
  num? numberOfElements;
  num? size;
  num? number;
  Sort? sort;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.last,
    this.totalPages,
    this.totalElements,
    this.first,
    this.numberOfElements,
    this.size,
    this.number,
    this.sort,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => DoctorsDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        last: json['last'] as bool?,
        totalPages: json['totalPages'] as num?,
        totalElements: json['totalElements'] as num?,
        first: json['first'] as bool?,
        numberOfElements: json['numberOfElements'] as num?,
        size: json['size'] as num?,
        number: json['number'] as num?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'last': last,
        'totalPages': totalPages,
        'totalElements': totalElements,
        'first': first,
        'numberOfElements': numberOfElements,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'empty': empty,
      };
}

class DoctorsDetails {
  String? id;
  dynamic loginId;
  String? hospitalId;
  String? hospitalName;
  String? name;
  String? phoneNumber;
  String? topDoctor;
  String? alterMobilenumber;
  String? email;
  num? rating;
  num? noOfPatents;
  num? experience;
  String? userImageId;
  dynamic isDeleted;
  String? isActive;
  DateTime? createdAt;
  dynamic createdBy;
  dynamic modifiedBy;
  dynamic modifiedDate;
  String? displayId;
  String? fcmToken;
  String? specialization;
  String? specializationId;
  Address? address;
  List<dynamic>? education;
  String? about;
  List<dynamic>? languages;
  List<dynamic>? services;
  List<Slot>? slots;
  num? consultationFees;
  String? days;

  DoctorsDetails(
      {this.id,
      this.loginId,
      this.hospitalId,
      this.hospitalName,
      this.name,
      this.phoneNumber,
      this.topDoctor,
      this.alterMobilenumber,
      this.email,
      this.rating,
      this.noOfPatents,
      this.experience,
      this.userImageId,
      this.isDeleted,
      this.isActive,
      this.createdAt,
      this.createdBy,
      this.modifiedBy,
      this.modifiedDate,
      this.displayId,
      this.fcmToken,
      this.specialization,
      this.specializationId,
      this.address,
      this.education,
      this.about,
      this.languages,
      this.services,
      this.slots,
      this.consultationFees,
      this.days});

  factory DoctorsDetails.fromJson(Map<String, dynamic> json) => DoctorsDetails(
        id: json['id'] as String?,
        loginId: json['loginId'] as dynamic,
        hospitalId: json['hospitalId'] as String?,
        hospitalName: json['hospitalName'] as String?,
        name: json['name'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        topDoctor: json['topDoctor'] as String?,
        alterMobilenumber: json['alterMobilenumber'] as String?,
        email: json['email'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        noOfPatents: json['noOfPatents'] as num?,
        experience: json['experience'] as num?,
        userImageId: json['userImageId'] as String?,
        isDeleted: json['isDeleted'] as dynamic,
        isActive: json['isActive'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        createdBy: json['createdBy'] as dynamic,
        modifiedBy: json['modifiedBy'] as dynamic,
        modifiedDate: json['modifiedDate'] as dynamic,
        displayId: json['displayId'] as String?,
        fcmToken: json['fcmToken'] as String?,
        specialization: json['specialization'] as String?,
        specializationId: json['specializationId'] as String?,
        address: json['address'] == null
            ? null
            : Address.fromJson(json['address'] as Map<String, dynamic>),
        education: json['education'] as List<dynamic>?,
        about: json['about'] as String?,
        languages: json['languages'] as List<dynamic>?,
        services: json['services'] as List<dynamic>?,
        slots: (json['slots'] as List<dynamic>?)
            ?.map((e) => Slot.fromJson(e as Map<String, dynamic>))
            .toList(),
        consultationFees: json['consultationFees'] as num?,
        days: json['days'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'loginId': loginId,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'name': name,
        'phoneNumber': phoneNumber,
        'topDoctor': topDoctor,
        'alterMobilenumber': alterMobilenumber,
        'email': email,
        'rating': rating,
        'noOfPatents': noOfPatents,
        'experience': experience,
        'userImageId': userImageId,
        'isDeleted': isDeleted,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'createdBy': createdBy,
        'modifiedBy': modifiedBy,
        'modifiedDate': modifiedDate,
        'displayId': displayId,
        'fcmToken': fcmToken,
        'specialization': specialization,
        'specializationId': specializationId,
        'address': address?.toJson(),
        'education': education,
        'about': about,
        'languages': languages,
        'services': services,
        'slots': slots?.map((e) => e.toJson()).toList(),
        'consultationFees': consultationFees,
        'days': days
      };
}

class GeoLocation {
  num? x;
  num? y;
  List<dynamic>? coordinates;
  String? type;

  GeoLocation({this.x, this.y, this.coordinates, this.type});

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        x: (json['x'] as num?)?.toDouble(),
        y: (json['y'] as num?)?.toDouble(),
        coordinates: json['coordinates'] as List<dynamic>?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'coordinates': coordinates,
        'type': type,
      };
}

class Address {
  String? mobileNumber;
  String? name;
  String? houseNum;
  String? addresslineMobileOne;
  String? addresslineMobileTwo;
  String? addressType;
  String? alterNateMobileNumber;
  String? emailId;
  String? pinCode;
  String? addressLine1;
  String? addressLine2;
  dynamic landMark;
  dynamic city;
  dynamic region;
  dynamic state;
  String? latitude;
  String? longitude;
  String? countrycode;
  GeoLocation? geoLocation;

  Address({
    this.mobileNumber,
    this.name,
    this.houseNum,
    this.addresslineMobileOne,
    this.addresslineMobileTwo,
    this.addressType,
    this.alterNateMobileNumber,
    this.emailId,
    this.pinCode,
    this.addressLine1,
    this.addressLine2,
    this.landMark,
    this.city,
    this.region,
    this.state,
    this.latitude,
    this.longitude,
    this.countrycode,
    this.geoLocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        mobileNumber: json['mobileNumber'] as String?,
        name: json['name'] as String?,
        houseNum: json['houseNum'] as String?,
        addresslineMobileOne: json['addresslineMobileOne'] as String?,
        addresslineMobileTwo: json['addresslineMobileTwo'] as String?,
        addressType: json['addressType'] as String?,
        alterNateMobileNumber: json['alterNateMobileNumber'] as String?,
        emailId: json['emailId'] as String?,
        pinCode: json['pinCode'] as String?,
        addressLine1: json['addressLine1'] as String?,
        addressLine2: json['addressLine2'] as String?,
        landMark: json['landMark'] as dynamic,
        city: json['city'] as dynamic,
        region: json['region'] as dynamic,
        state: json['state'] as dynamic,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
        countrycode: json['countrycode'] as String?,
        geoLocation: json['geoLocation'] == null
            ? null
            : GeoLocation.fromJson(json['geoLocation'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'name': name,
        'houseNum': houseNum,
        'addresslineMobileOne': addresslineMobileOne,
        'addresslineMobileTwo': addresslineMobileTwo,
        'addressType': addressType,
        'alterNateMobileNumber': alterNateMobileNumber,
        'emailId': emailId,
        'pinCode': pinCode,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'landMark': landMark,
        'city': city,
        'region': region,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'countrycode': countrycode,
        'geoLocation': geoLocation?.toJson(),
      };
}

class Pageable {
  Sort? sort;
  num? pageNumber;
  num? pageSize;
  num? offset;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.pageNumber,
    this.pageSize,
    this.offset,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        pageNumber: json['pageNumber'] as num?,
        pageSize: json['pageSize'] as num?,
        offset: json['offset'] as num?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort?.toJson(),
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'offset': offset,
        'paged': paged,
        'unpaged': unpaged,
      };
}

class Slot {
  String? doctorId;
  String? slotName;
  String? startTime;
  String? endTime;
  bool? isChecked;
  num? displayOrder;

  Slot({
    this.doctorId,
    this.slotName,
    this.startTime,
    this.endTime,
    this.isChecked,
    this.displayOrder,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        doctorId: json['doctorId'] as String?,
        slotName: json['slotName'] as String?,
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        isChecked: json['isChecked'] as bool?,
        displayOrder: json['displayOrder'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'slotName': slotName,
        'startTime': startTime,
        'endTime': endTime,
        'isChecked': isChecked,
        'displayOrder': displayOrder,
      };
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json['sorted'] as bool?,
        unsorted: json['unsorted'] as bool?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sorted': sorted,
        'unsorted': unsorted,
        'empty': empty,
      };
}
