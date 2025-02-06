import 'dart:convert';

LabTestStatusModel labTestStatusModelFromJson(String str) =>
    LabTestStatusModel.fromJson(json.decode(str));

String labTestStatusModelToJson(LabTestStatusModel data) =>
    json.encode(data.toJson());

class LabTestStatusModel {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  LabTestStatusModel({this.status, this.message, this.data, this.token});

  factory LabTestStatusModel.fromJson(Map<String, dynamic> json) {
    return LabTestStatusModel(
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
  List<BasicTestStatus>? content;
  Pageable? pageable;
  int? totalElements;
  bool? last;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalElements,
    this.last,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => BasicTestStatus.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        totalElements: json['totalElements'] as int?,
        last: json['last'] as bool?,
        totalPages: json['totalPages'] as int?,
        size: json['size'] as int?,
        number: json['number'] as int?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        numberOfElements: json['numberOfElements'] as int?,
        first: json['first'] as bool?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'totalElements': totalElements,
        'last': last,
        'totalPages': totalPages,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
}

class BasicTestStatus {
  String? id;
  String? userId;
  String? relation;
  String? firstName;
  String? lastName;
  String? appointmentDate;
  String? bookingDate;
  String? lucidOrderInvoice;
  String? tests;
  List<String>? testLists;
  List<LucidTest>? lucidTestData;
  String? location;
  dynamic umrNumber;
  dynamic vid;
  String? cancelledAt;
  String? completedAt;
  String? hv;
  num? age;
  String? address;
  String? fullAddress;
  String? gender;
  String? mobileNumber;
  String? branchId;
  String? lucidBranchId;
  dynamic dateOfBirth;
  String? city;
  String? isUrgent;
  String? status;
  String? paymentId;
  String? paymentStatus;
  num? paidAmount;
  dynamic billedDate;
  dynamic organizationId;
  dynamic paymentType;
  dynamic refoundAmount;
  dynamic refoundStatus;
  dynamic refoundId;
  num? totalAmount;
  num? totalPaidAmount;
  num? homeCollecitonCharges;
  String? organizationName;
  dynamic reason;
  String? paidDate;
  String? comments;
  dynamic entity;
  dynamic currency;
  dynamic notes;
  dynamic receipt;
  dynamic acquirerData;
  dynamic refoundDate;
  dynamic batchId;
  String? luicdReports;
  dynamic speedProcessed;
  dynamic speedRequested;
  BasicTestStatus({
    this.id,
    this.userId,
    this.relation,
    this.firstName,
    this.lastName,
    this.appointmentDate,
    this.lucidOrderInvoice,
    this.bookingDate,
    this.tests,
    this.testLists,
    this.lucidTestData,
    this.location,
    this.umrNumber,
    this.vid,
    this.reason,
    this.cancelledAt,
    this.completedAt,
    this.hv,
    this.age,
    this.totalPaidAmount,
    this.address,
    this.fullAddress,
    this.gender,
    this.mobileNumber,
    this.branchId,
    this.lucidBranchId,
    this.dateOfBirth,
    this.city,
    this.isUrgent,
    this.status,
    this.homeCollecitonCharges,
    this.paymentId,
    this.paymentStatus,
    this.paidAmount,
    this.paidDate,
    this.billedDate,
    this.organizationId,
    this.paymentType,
    this.comments,
    this.refoundId,
    this.entity,
    this.refoundAmount,
    this.currency,
    this.notes,
    this.receipt,
    this.acquirerData,
    this.refoundDate,
    this.batchId,
    this.speedProcessed,
    this.speedRequested,
    this.organizationName,
    this.totalAmount,
    this.refoundStatus,
    this.luicdReports,
  });

  factory BasicTestStatus.fromJson(Map<String, dynamic> json) =>
      BasicTestStatus(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        relation: json['relation'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        appointmentDate: json['appointmentDate'] as String?,
        bookingDate:
            json['bookingDate'] == null ? '' : json['bookingDate'] as String,
        tests: json['tests'] == null ? '' : json['tests'] as String,
        testLists: List<String>.from(json["testLists"].map((x) => x)),
        lucidTestData: (json['lucidTestData'] as List<dynamic>?)
            ?.map((e) => LucidTest.fromJson(e as Map<String, dynamic>))
            .toList(),
        location: json['location'] == null ? '' : json['location'] as String,
        umrNumber: json['umrNumber'] as dynamic,
        vid: json['vid'] as dynamic,
        reason: json['reason'] as dynamic,
        cancelledAt:
            json['cancelledAt'] == null ? '' : json['cancelledAt'] as String,
        completedAt:
            json['completedAt'] == null ? '' : json['completedAt'] as String,
        hv: json['hv'] == null ? '' : json['hv'] as String,
        age: json['age'] as num?,
        homeCollecitonCharges: json['homeCollecitonCharges'] as num?,
        address: json['address'] == null ? '' : json['address'] as String,
        fullAddress:
            json['fullAddress'] == null ? '' : json['fullAddress'] as String,
        gender: json['gender'] == null ? '' : json['gender'] as String,
        mobileNumber:
            json['mobileNumber'] == null ? '' : json['mobileNumber'] as String,
        branchId: json['branchId'] as String?,
        lucidBranchId: json['lucidBranchId'] as String?,
        dateOfBirth: json['dateOfBirth'] as dynamic,
        city: json['city'] as String?,
        isUrgent: json['isUrgent'] as String?,
        status: json['status'] as String?,
        paymentId: json['paymentId'] as String?,
        paymentStatus: json['paymentStatus'] as String?,
        paidAmount: json['paidAmount'] as num?,
        totalPaidAmount: json['totalPaidAmount'] as num?,
        paidDate: json['paidDate'] == null ? '' : json['paidDate'] as String,
        billedDate: json['billedDate'] as dynamic,
        organizationId: json['organizationId'] as dynamic,
        paymentType: json['paymentType'] as dynamic,
        comments: json['comments'] as String?,
        refoundAmount: json['refoundAmount'] as dynamic,
        currency: json['currency'] as dynamic,
        notes: json['notes'] as dynamic,
        receipt: json['receipt'] as dynamic,
        acquirerData: json['acquirerData'] as dynamic,
        refoundDate: json['refoundDate'] as dynamic,
        batchId: json['batchId'] as dynamic,
        speedProcessed: json['speedProcessed'] as dynamic,
        speedRequested: json['speedRequested'] as dynamic,
        refoundStatus: json['refoundStatus'] as dynamic,
        refoundId: json['refoundId'] as dynamic,
        entity: json['entity'] as dynamic,
        totalAmount: json['totalAmount'] as num?,
        organizationName: json['organizationName'] == null
            ? ''
            : json['organizationName'] as String,
        luicdReports: json['luicdReports'] as String?,
        lucidOrderInvoice: json['lucidOrderInvoice'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'relation': relation,
        'firstName': firstName,
        'lastName': lastName,
        'appointmentDate': appointmentDate,
        'bookingDate': bookingDate,
        'tests': tests,
        'testLists': testLists,
        'lucidTestData': lucidTestData?.map((e) => e.toJson()).toList(),
        'location': location,
        'umrNumber': umrNumber,
        'vid': vid,
        'reason': reason,
        'cancelledAt': cancelledAt,
        'completedAt': completedAt,
        'totalPaidAmount': totalPaidAmount,
        'homeCollecitonCharges': homeCollecitonCharges,
        'hv': hv,
        'age': age,
        'address': address,
        'fullAddress': fullAddress,
        'gender': gender,
        'mobileNumber': mobileNumber,
        'branchId': branchId,
        'lucidBranchId': lucidBranchId,
        'dateOfBirth': dateOfBirth,
        'city': city,
        'isUrgent': isUrgent,
        'status': status,
        'paymentId': paymentId,
        'paymentStatus': paymentStatus,
        'paidAmount': paidAmount,
        'paidDate': paidDate,
        'billedDate': billedDate,
        'organizationId': organizationId,
        'paymentType': paymentType,
        'comments': comments,
        'refoundId': refoundId,
        'entity': entity,
        'refoundAmount': refoundAmount,
        'currency': currency,
        'notes': notes,
        'receipt': receipt,
        'acquirerData': acquirerData,
        'refoundDate': refoundDate,
        'batchId': batchId,
        'speedProcessed': speedProcessed,
        'speedRequested': speedRequested,
        'organizationName': organizationName,
        'totalAmount': totalAmount,
        'refoundStatus': refoundStatus,
        'luicdReports': luicdReports,
        'lucidOrderInvoice': lucidOrderInvoice,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
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
        offset: json['offset'] as int?,
        pageNumber: json['pageNumber'] as int?,
        pageSize: json['pageSize'] as int?,
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

class LucidTest {
  String? serviceCd;
  String? serviceName;
  String? image;
  num? finalMrp;
  num? discount;
  String? hv;

  LucidTest({
    this.serviceCd,
    this.serviceName,
    this.image,
    this.finalMrp,
    this.discount,
    this.hv,
  });

  factory LucidTest.fromJson(Map<String, dynamic> json) {
    return LucidTest(
      serviceCd: json['serviceCd'] as String?,
      serviceName: json['serviceName'] as String?,
      image: json['image'] as String?,
      finalMrp: json['finalMrp'] as num?,
      discount: json['discount'] as num?,
      hv: json['hv'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'serviceCd': serviceCd,
        'serviceName': serviceName,
        'image': image,
        'finalMrp': finalMrp,
        'discount': discount,
        'hv': hv,
      };
}
