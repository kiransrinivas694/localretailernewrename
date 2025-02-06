import 'dart:convert';

LucidListModel lucidListModelFromJson(String str) =>
    LucidListModel.fromJson(json.decode(str));

String lucidListModelToJson(LucidListModel data) => json.encode(data.toJson());

class LucidListModel {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  LucidListModel({this.status, this.message, this.data, this.token});

  factory LucidListModel.fromJson(Map<String, dynamic> json) {
    return LucidListModel(
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
  List<BasicLucidModel>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
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
    this.totalPages,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => BasicLucidModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        totalElements: json['totalElements'] as int?,
        totalPages: json['totalPages'] as int?,
        last: json['last'] as bool?,
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
        'totalPages': totalPages,
        'last': last,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
}

class BasicLucidModel {
  String? id;
  String? serviceCd;
  String? serviceName;
  String? serviceGroup;
  String? department;
  num? mrpPriceList;
  String? image;
  String? state;
  String? location;
  num? discount;
  num? finalMrp;
  String? discountType;
  String? homeCollection;
  String? isAppointmentRequired;
  String? description;
  String? turnaroundTime;
  String? helpLineNumber;

  BasicLucidModel({
    this.id,
    this.serviceCd,
    this.serviceName,
    this.serviceGroup,
    this.department,
    this.mrpPriceList,
    this.image,
    this.state,
    this.location,
    this.discount,
    this.discountType,
    this.homeCollection,
    this.finalMrp,
    this.isAppointmentRequired,
    this.description,
    this.turnaroundTime,
    required this.helpLineNumber,
  });

  factory BasicLucidModel.fromJson(Map<String, dynamic> json) =>
      BasicLucidModel(
        id: json['id'] as String?,
        serviceCd: json['serviceCd'] as String?,
        serviceName: json['serviceName'] as String?,
        serviceGroup: json['serviceGroup'] as String?,
        department: json['department'] as String?,
        mrpPriceList: json['mrpPriceList'] as num?,
        image: json['image'] as String?,
        state: json['state'] as String?,
        location: json['location'] as String?,
        discount: json['discount'] as num?,
        discountType: json['discountType'] as String?,
        homeCollection: json['homeCollection'] as String?,
        finalMrp: json['finalMrp'] as num?,
        description: json['description'] as String?,
        turnaroundTime: json['turnaroundTime'] as String?,
        isAppointmentRequired: json["isAppointmentRequired"] as String?,
        helpLineNumber: json["helpLineNumber"] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceCd': serviceCd,
        'serviceName': serviceName,
        'serviceGroup': serviceGroup,
        'department': department,
        'mrpPriceList': mrpPriceList,
        'image': image,
        'state': state,
        'location': location,
        'discount': discount,
        'discountType': discountType,
        'homeCollection': homeCollection,
        'finalMrp': finalMrp,
        'description': description,
        'turnaroundTime': turnaroundTime,
        'isAppointmentRequired': isAppointmentRequired,
        "helpLineNumber": helpLineNumber,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as int?,
        pageSize: json['pageSize'] as int?,
        pageNumber: json['pageNumber'] as int?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort?.toJson(),
        'offset': offset,
        'pageSize': pageSize,
        'pageNumber': pageNumber,
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
