// To parse this JSON data, do
//
//     final CreditNoteHistoryModel = CreditNoteHistoryModelFromJson(jsonString);

import 'dart:convert';

CreditNoteHistoryModel creditNoteHistoryModelFromJson(String str) =>
    CreditNoteHistoryModel.fromJson(json.decode(str));

String creditNoteHistoryModelToJson(CreditNoteHistoryModel data) =>
    json.encode(data.toJson());

class CreditNoteHistoryModel {
  List<CreditNoteOrderContent> content;
  Pageable? pageable;
  bool last;
  num? totalElements;
  num? totalPages;
  num? size;
  num? number;
  List<dynamic>? sort;
  bool first;
  num? numberOfElements;
  bool empty;

  CreditNoteHistoryModel({
    this.content = const <CreditNoteOrderContent>[],
    this.pageable,
    this.last = false,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.first = false,
    this.numberOfElements,
    this.empty = false,
  });

  factory CreditNoteHistoryModel.fromJson(Map<String, dynamic> json) =>
      CreditNoteHistoryModel(
        content: List<CreditNoteOrderContent>.from(
            json["content"].map((x) => CreditNoteOrderContent.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: json['sort'] as List<dynamic>?,
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable!.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort,
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class CreditNoteOrderContent {
  String? id;
  String? orderId;
  DateTime? orderDate;
  num? creditNoteAmount;
  String? giverId;
  DateTime? insertDate;
  String? receiverId;
  String? transactionType;

  CreditNoteOrderContent({
    this.id,
    this.orderId,
    this.orderDate,
    this.creditNoteAmount,
    this.giverId,
    this.insertDate,
    this.receiverId,
    this.transactionType,
  });

  factory CreditNoteOrderContent.fromJson(Map<String, dynamic> json) =>
      CreditNoteOrderContent(
        id: json["id"],
        orderId: json["orderId"],
        orderDate: DateTime.parse(json["orderDate"]),
        creditNoteAmount: json["creditNoteAmount"],
        giverId: json["giverId"],
        insertDate: DateTime.parse(json["insertDate"]),
        receiverId: json["receiverId"],
        transactionType: json["transactionType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "orderDate": orderDate!.toIso8601String(),
        "creditNoteAmount": creditNoteAmount,
        "giverId": giverId,
        "createdDate": insertDate!.toIso8601String(),
        "receiverId": receiverId,
        "transactionType": transactionType,
      };
}

class Pageable {
  List<dynamic>? sort;
  num? offset;
  num? pageNumber;
  num? pageSize;
  bool paged;
  bool unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged = false,
    this.unpaged = false,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] as List<dynamic>?,
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort,
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

// class Sort {
//   bool empty;
//   bool sorted;
//   bool unsorted;

//   Sort({
//     this.empty = false,
//     this.sorted = false,
//     this.unsorted = false,
//   });

//   factory Sort.fromJson(Map<String, dynamic> json) => Sort(
//         empty: json["empty"],
//         sorted: json["sorted"],
//         unsorted: json["unsorted"],
//       );

//   Map<String, dynamic> toJson() => {
//         "empty": empty,
//         "sorted": sorted,
//         "unsorted": unsorted,
//       };
// }
