import 'dart:convert';

HealthPackageModel healthPackageModelFromJson(String str) =>
    HealthPackageModel.fromJson(json.decode(str));

String healthPackageModelToJson(HealthPackageModel data) =>
    json.encode(data.toJson());

class HealthPackageModel {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  HealthPackageModel({this.status, this.message, this.data, this.token});

  factory HealthPackageModel.fromJson(Map<String, dynamic> json) {
    return HealthPackageModel(
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
  List<BasicHealthPackageModel>? content;
  Pageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? numberOfElements;
  bool? first;
  int? size;
  int? number;
  Sort? sort;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.last,
    this.totalPages,
    this.totalElements,
    this.numberOfElements,
    this.first,
    this.size,
    this.number,
    this.sort,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) =>
                BasicHealthPackageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        last: json['last'] as bool?,
        totalPages: json['totalPages'] as int?,
        totalElements: json['totalElements'] as int?,
        numberOfElements: json['numberOfElements'] as int?,
        first: json['first'] as bool?,
        size: json['size'] as int?,
        number: json['number'] as int?,
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
        'numberOfElements': numberOfElements,
        'first': first,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'empty': empty,
      };
}

class BasicHealthPackageModel {
  String? id;
  String? serviceCd;
  String? packageName;
  List<HealthPackageType>? healthPackageTypes;
  String? image;
  num? totalAmount;
  num? discount;
  String? discountType;
  num? finalMrp;
  String? pakageNameSearch;
  String? gender;
  String? isAppointmentRequired;
  String? helpLineNumber;

  BasicHealthPackageModel({
    this.id,
    this.serviceCd,
    this.packageName,
    this.healthPackageTypes,
    this.image,
    this.totalAmount,
    this.discount,
    this.discountType,
    this.finalMrp,
    this.pakageNameSearch,
    this.gender,
    this.isAppointmentRequired,
    this.helpLineNumber,
  });

  factory BasicHealthPackageModel.fromJson(Map<String, dynamic> json) =>
      BasicHealthPackageModel(
        id: json['id'] as String?,
        serviceCd: json['serviceCd'] as String?,
        packageName: json['packageName'] as String?,
        healthPackageTypes: (json['healthPackageTypes'] as List<dynamic>?)
            ?.map((e) => HealthPackageType.fromJson(e as Map<String, dynamic>))
            .toList(),
        image: json['image'] as String?,
        totalAmount: json['totalAmount'] as num?,
        discount: json['discount'] as num?,
        discountType: json['discountType'] as String?,
        finalMrp: json['finalMrp'] as num?,
        pakageNameSearch: json['pakageNameSearch'] as String?,
        gender: json['gender'] as String?,
        isAppointmentRequired: json['isAppointmentRequired'] as String?,
        helpLineNumber: json['helpLineNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceCd': serviceCd,
        'packageName': packageName,
        'healthPackageTypes': healthPackageTypes,
        'image': image,
        'totalAmount': totalAmount,
        'discount': discount,
        'discountType': discountType,
        'finalMrp': finalMrp,
        'pakageNameSearch': pakageNameSearch,
        'gender': gender,
        'isAppointmentRequired': isAppointmentRequired,
        'helpLineNumber': helpLineNumber,
      };
}

class HealthPackageType {
  String? packageType;
  String? image;
  List<String>? testNames;

  HealthPackageType({this.packageType, this.image, this.testNames});

  factory HealthPackageType.fromJson(Map<String, dynamic> json) {
    return HealthPackageType(
      packageType: json['packageType'] as String?,
      image: json['image'] as String?,
      testNames: (json['testNames'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'packageType': packageType,
        'image': image,
        'testNames': testNames,
      };
}

class Pageable {
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  int? offset;
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
        pageNumber: json['pageNumber'] as int?,
        pageSize: json['pageSize'] as int?,
        offset: json['offset'] as int?,
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
