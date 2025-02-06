import 'dart:convert';

BookingTestDetails bookingTestDetailsFromJson(String str) =>
    BookingTestDetails.fromJson(json.decode(str));

String bookingTestDetailsToJson(BookingTestDetails data) =>
    json.encode(data.toJson());

class BookingTestDetails {
  bool? status;
  String? message;
  BookedTestData? data;
  dynamic token;

  BookingTestDetails({this.status, this.message, this.data, this.token});

  factory BookingTestDetails.fromJson(Map<String, dynamic> json) {
    return BookingTestDetails(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BookedTestData.fromJson(json['data'] as Map<String, dynamic>),
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

class BookedTestData {
  String? id;
  String? cartId;
  String? userId;
  String? relation;
  String? firstName;
  String? lastName;
  num? age;
  String? gender;
  String? mobileNumber;
  String? city;
  String? location;
  dynamic lucidOrderInvoice;
  String? comments;
  String? address;
  String? fullAddress;
  String? status;
  String? bookingDate;
  String? appointmentDate;
  String? branchId;
  String? branchName;
  String? lucidBranchId;
  LucidCart? lucidCart;
  dynamic umrNumber;
  dynamic vid;
  String? paymentId;
  String? paymentStatus;
  num? homeCollecitonCharges;
  num? paidAmount;
  dynamic reason;
  String? cancelledAt;
  dynamic billedDate;
  dynamic organizationId;
  dynamic paymentType;
  dynamic referralName;
  String? appointmentType;
  String? completedAt;
  dynamic lucidComments;
  String? isRescheduled;
  dynamic refoundId;
  dynamic entity;
  dynamic refoundAmount;
  dynamic currency;
  dynamic notes;
  dynamic receipt;
  dynamic acquirerData;
  dynamic refoundDate;
  dynamic batchId;
  dynamic speedProcessed;
  dynamic speedRequested;
  dynamic luicdReports;
  dynamic createdBy;
  DateTime? createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String? isActive;
  String? isUrgent;
  num? totalPaidAmount;
  num? refoundCreatedAt;
  dynamic dateOfBirth;
  dynamic refoundStatus;

  BookedTestData({
    this.id,
    this.cartId,
    this.userId,
    this.relation,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.mobileNumber,
    this.city,
    this.location,
    this.comments,
    this.lucidOrderInvoice,
    this.address,
    this.fullAddress,
    this.status,
    this.bookingDate,
    this.appointmentDate,
    this.branchId,
    this.branchName,
    this.lucidBranchId,
    this.lucidCart,
    this.umrNumber,
    this.vid,
    this.paymentId,
    this.paymentStatus,
    this.homeCollecitonCharges,
    this.paidAmount,
    this.reason,
    this.cancelledAt,
    this.billedDate,
    this.organizationId,
    this.paymentType,
    this.referralName,
    this.appointmentType,
    this.completedAt,
    this.lucidComments,
    this.isRescheduled,
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
    this.luicdReports,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isActive,
    this.isUrgent,
    this.totalPaidAmount,
    this.refoundCreatedAt,
    this.dateOfBirth,
    this.refoundStatus,
  });

  factory BookedTestData.fromJson(Map<String, dynamic> json) => BookedTestData(
        id: json['id'] as String?,
        cartId: json['cartId'] as String?,
        userId: json['userId'] as String?,
        relation: json['relation'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        age: json['age'] as num?,
        gender: json['gender'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        city: json['city'] as String?,
        location: json['location'] as String?,
        comments: json['comments'] as String?,
        address: json['address'] as String?,
        fullAddress: json['fullAddress'] as String?,
        status: json['status'] as String?,
        bookingDate:
            json['bookingDate'] == null ? '' : json['bookingDate'] as String,
        appointmentDate: json['appointmentDate'] as String?,
        branchId: json['branchId'] as String?,
        branchName: json['branchName'] as String?,
        lucidBranchId: json['lucidBranchId'] as String?,
        lucidCart: json['lucidCart'] == null
            ? null
            : LucidCart.fromJson(json['lucidCart'] as Map<String, dynamic>),
        umrNumber: json['umrNumber'] as dynamic,
        vid: json['vid'] as dynamic,
        paymentId: json['paymentId'] as String?,
        paymentStatus: json['paymentStatus'] as String?,
        homeCollecitonCharges: json['homeCollecitonCharges'] as num?,
        paidAmount: json['paidAmount'] as num?,
        reason: json['reason'] as dynamic,
        cancelledAt:
            json['cancelledAt'] == null ? '' : json['cancelledAt'] as String,
        billedDate: json['billedDate'] as dynamic,
        organizationId: json['organizationId'] as dynamic,
        paymentType: json['paymentType'] as dynamic,
        referralName: json['referralName'] as dynamic,
        appointmentType: json['appointmentType'] as String?,
        completedAt:
            json['completedAt'] == null ? '' : json['completedAt'] as String,
        lucidComments: json['lucidComments'] as dynamic,
        isRescheduled: json['isRescheduled'] as String?,
        refoundId: json['refoundId'] as dynamic,
        entity: json['entity'] as dynamic,
        refoundAmount: json['refoundAmount'] as dynamic,
        currency: json['currency'] as dynamic,
        notes: json['notes'] as dynamic,
        receipt: json['receipt'] as dynamic,
        acquirerData: json['acquirerData'] as dynamic,
        refoundDate: json['refoundDate'] as dynamic,
        batchId: json['batchId'] as dynamic,
        speedProcessed: json['speedProcessed'] as dynamic,
        speedRequested: json['speedRequested'] as dynamic,
        luicdReports: json['luicdReports'] as dynamic,
        lucidOrderInvoice: json['lucidOrderInvoice'] as dynamic,
        createdBy: json['createdBy'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedBy: json['updatedBy'] as dynamic,
        updatedAt: json['updatedAt'] as dynamic,
        isActive: json['isActive'] as String?,
        isUrgent: json['isUrgent'] as String?,
        totalPaidAmount: json['totalPaidAmount'] as num?,
        refoundCreatedAt: json['refoundCreatedAt'] as num?,
        dateOfBirth: json['dateOfBirth'] as dynamic,
        refoundStatus: json['refoundStatus'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cartId': cartId,
        'userId': userId,
        'relation': relation,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'mobileNumber': mobileNumber,
        'city': city,
        'location': location,
        'comments': comments,
        'address': address,
        'fullAddress': fullAddress,
        'status': status,
        'bookingDate': bookingDate,
        'appointmentDate': appointmentDate,
        'branchId': branchId,
        'branchName': branchName,
        'lucidBranchId': lucidBranchId,
        'lucidCart': lucidCart?.toJson(),
        'lucidOrderInvoice': lucidOrderInvoice,
        'umrNumber': umrNumber,
        'vid': vid,
        'paymentId': paymentId,
        'paymentStatus': paymentStatus,
        'homeCollecitonCharges': homeCollecitonCharges,
        'paidAmount': paidAmount,
        'reason': reason,
        'cancelledAt': cancelledAt,
        'billedDate': billedDate,
        'organizationId': organizationId,
        'paymentType': paymentType,
        'referralName': referralName,
        'appointmentType': appointmentType,
        'completedAt': completedAt,
        'lucidComments': lucidComments,
        'isRescheduled': isRescheduled,
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
        'luicdReports': luicdReports,
        'createdBy': createdBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedAt': updatedAt,
        'isActive': isActive,
        'isUrgent': isUrgent,
        'totalPaidAmount': totalPaidAmount,
        'refoundCreatedAt': refoundCreatedAt,
        'dateOfBirth': dateOfBirth,
        'refoundStatus': refoundStatus,
      };
}

class LucidCart {
  String? id;
  String? userId;
  List<LucidTest>? lucidTest;
  num? totalAmount;
  dynamic cretedBy;
  DateTime? createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String? isActive;

  LucidCart({
    this.id,
    this.userId,
    this.lucidTest,
    this.totalAmount,
    this.cretedBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isActive,
  });

  factory LucidCart.fromJson(Map<String, dynamic> json) => LucidCart(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        lucidTest: (json['lucidTest'] as List<dynamic>?)
            ?.map((e) => LucidTest.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: json['totalAmount'] as num?,
        cretedBy: json['cretedBy'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedBy: json['updatedBy'] as dynamic,
        updatedAt: json['updatedAt'] as dynamic,
        isActive: json['isActive'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'lucidTest': lucidTest?.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'cretedBy': cretedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedAt': updatedAt,
        'isActive': isActive,
      };
}

class LucidTest {
  String? serviceCd;
  String? serviceName;
  String? image;
  num? finalMrp;
  num? discount;
  String? hv;
  String? isHealthPackage;

  LucidTest(
      {this.serviceCd,
      this.serviceName,
      this.image,
      this.finalMrp,
      this.discount,
      this.hv,
      this.isHealthPackage});

  factory LucidTest.fromJson(Map<String, dynamic> json) => LucidTest(
        serviceCd: json['serviceCd'] as String?,
        serviceName: json['serviceName'] as String?,
        image: json['image'] as String?,
        finalMrp: json['finalMrp'] as num?,
        discount: json['discount'] as num?,
        hv: json['hv'] as String?,
        isHealthPackage: json['isHealthPackage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'serviceCd': serviceCd,
        'serviceName': serviceName,
        'image': image,
        'finalMrp': finalMrp,
        'discount': discount,
        'hv': hv,
        'isHealthPackage': isHealthPackage,
      };
}
