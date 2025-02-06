import 'dart:convert';

EntryNoteHistoryModel entryNoteHistoryModelFromJson(String str) =>
    EntryNoteHistoryModel.fromJson(json.decode(str));

String entryNoteHistoryModelToJson(EntryNoteHistoryModel data) =>
    json.encode(data.toJson());

class EntryNoteHistoryModel {
  bool? status;
  String? message;
  dynamic totalRecord;
  Data? data;

  EntryNoteHistoryModel(
      {this.status, this.message, this.totalRecord, this.data});

  factory EntryNoteHistoryModel.fromJson(Map<String, dynamic> json) =>
      EntryNoteHistoryModel(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        totalRecord: json['totalRecord'] as dynamic,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'totalRecord': totalRecord,
        'data': data?.toJson(),
      };
}

class Data {
  List<BasicEntryNoteHistoryModel>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  List<dynamic>? sort;
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
            ?.map((e) =>
                BasicEntryNoteHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        totalElements: json['totalElements'] as int?,
        totalPages: json['totalPages'] as int?,
        last: json['last'] as bool?,
        size: json['size'] as int?,
        number: json['number'] as int?,
        sort: json['sort'] as List<dynamic>?,
        // json['sort'] == null
        //     ? null
        //     : Sort.fromJson(json['sort'] as Map<String, dynamic>),
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
        'sort': sort,
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
}

class BasicEntryNoteHistoryModel {
  String? id;
  String? retailerId;
  String? retailerName;
  num? amountPaid;
  String? approvedBy;
  String? approvedDate;
  String? status;
  String? requestDate;
  String? paidDate;

  BasicEntryNoteHistoryModel({
    this.id,
    this.retailerId,
    this.retailerName,
    this.amountPaid,
    this.approvedBy,
    this.approvedDate,
    this.status,
    this.requestDate,
    this.paidDate,
  });

  factory BasicEntryNoteHistoryModel.fromJson(Map<String, dynamic> json) =>
      BasicEntryNoteHistoryModel(
        id: json['id'] as String?,
        retailerId: json['retailerId'] as String?,
        retailerName: json['retailerName'] as String?,
        amountPaid: json['paidAmount'] as num?,
        approvedBy: json['approvedBy'] as String?,
        approvedDate: json['approvedDate'] as String?,
        status: json['status'] as String?,
        requestDate: json['requestDate'] as String?,
        paidDate: json['paidDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'retailerId': retailerId,
        'retailerName': retailerName,
        'paidAmount': amountPaid,
        'approvedBy': approvedBy,
        'approvedDate': approvedDate,
        'status': status,
        'requestDate': requestDate,
        'paidDate': paidDate,
      };
}

class Pageable {
  List<dynamic>? sort;
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
        sort: json['sort'] as List<dynamic>?,
        // json['sort'] == null
        //     ? null
        //     : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as int?,
        pageNumber: json['pageNumber'] as int?,
        pageSize: json['pageSize'] as int?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort,
        'offset': offset,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'paged': paged,
        'unpaged': unpaged,
      };
}

// class Sort {
//   bool? empty;
//   bool? sorted;
//   bool? unsorted;

//   Sort({this.empty, this.sorted, this.unsorted});

//   factory Sort.fromJson(Map<String, dynamic> json) => Sort(
//         empty: json['empty'] as bool?,
//         sorted: json['sorted'] as bool?,
//         unsorted: json['unsorted'] as bool?,
//       );

//   Map<String, dynamic> toJson() => {
//         'empty': empty,
//         'sorted': sorted,
//         'unsorted': unsorted,
//       };
// }
