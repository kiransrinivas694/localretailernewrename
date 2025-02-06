// To parse this JSON data, do
//
//     final paymentRequestModel = paymentRequestModelFromJson(jsonString);

import 'dart:convert';

PaymentRequestModel paymentRequestModelFromJson(String str) =>
    PaymentRequestModel.fromJson(json.decode(str));

String paymentRequestModelToJson(PaymentRequestModel data) =>
    json.encode(data.toJson());

class PaymentRequestModel {
  List<PaymentRequestOrderContent> content;
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

  PaymentRequestModel({
    this.content = const <PaymentRequestOrderContent>[],
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

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentRequestModel(
        content: List<PaymentRequestOrderContent>.from(
            json["content"].map((x) => PaymentRequestOrderContent.fromJson(x))),
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
        'sort': sort,
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class PaymentRequestOrderContent {
  String? id;
  String? orderId;
  String? billNumber;
  DateTime? billDate;
  DateTime? paidDate;
  DateTime? dueDate;
  num? billedAmount;
  String? dueSince;
  String? message;
  num? orderAmount;
  String? storeId;
  String? createdBy;
  DateTime? createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
  String? payerId;
  num? amountPaid;
  num? balanceToBePaid;
  num? creditNoteAmountAdjusted;
  String? payerName;
  DateTime? orderCreatedDate;
  String? storeName;
  String? orderStatus;
  num? daysUntilDue;

  PaymentRequestOrderContent({
    this.id,
    this.orderId,
    this.billNumber,
    this.billDate,
    this.dueDate,
    this.billedAmount,
    this.dueSince,
    this.message,
    this.orderAmount,
    this.storeId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.payerId,
    this.amountPaid,
    this.balanceToBePaid,
    this.creditNoteAmountAdjusted,
    this.payerName,
    this.orderCreatedDate,
    this.storeName,
    this.orderStatus,
    this.daysUntilDue,
    this.paidDate,
  });

  factory PaymentRequestOrderContent.fromJson(Map<String, dynamic> json) =>
      PaymentRequestOrderContent(
          id: json["id"],
          orderId: json["orderId"],
          billNumber: json["billNumber"],
          billDate: DateTime.parse(json["billDate"]),
          dueDate: DateTime.parse(json["dueDate"]),
          billedAmount: json["billedAmount"],
          dueSince: json["dueSince"],
          message: json["message"],
          orderAmount: json["orderAmount"].toDouble(),
          storeId: json["storeId"],
          createdBy: json["createdBy"],
          createdDate: DateTime.parse(json["createdDate"]),
          updatedBy: json["updatedBy"],
          updatedDate: json["updatedDate"],
          payerId: json["payerId"],
          amountPaid: json["amountPaid"],
          balanceToBePaid: json["balanceToBePaid"],
          creditNoteAmountAdjusted: json["creditNoteAmountAdjusted"],
          payerName: json["payerName"],
          orderCreatedDate: DateTime.parse(json["orderCreatedDate"]),
          storeName: json["storeName"],
          orderStatus: json["orderStatus"],
          daysUntilDue: json["daysUntilDue"],
          paidDate: json["paidDate"] == null
              ? null
              : DateTime.parse(json["paidDate"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "billNumber": billNumber,
        "billDate": billDate!.toIso8601String(),
        "dueDate": dueDate!.toIso8601String(),
        "billedAmount": billedAmount,
        "dueSince": dueSince,
        "message": message,
        "orderAmount": orderAmount,
        "storeId": storeId,
        "createdBy": createdBy,
        "createdDate": createdDate!.toIso8601String(),
        "updatedBy": updatedBy,
        "updatedDate": updatedDate,
        "payerId": payerId,
        "amountPaid": amountPaid,
        "balanceToBePaid": balanceToBePaid,
        "payerName": payerName,
        "creditNoteAmountAdjusted": creditNoteAmountAdjusted,
        "orderCreatedDate": orderCreatedDate!.toIso8601String(),
        "storeName": storeName,
        "orderStatus": orderStatus,
        "daysUntilDue": daysUntilDue,
        "paidDate": paidDate == null ? "" : paidDate!.toIso8601String(),
      };
}

// class Pageable {
//   Sort? sort;
//   num? offset;
//   num? pageNumber;
//   num? pageSize;
//   bool paged;
//   bool unpaged;

//   Pageable({
//     this.sort,
//     this.offset,
//     this.pageNumber,
//     this.pageSize,
//     this.paged = false,
//     this.unpaged = false,
//   });

//   factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
//         sort: Sort.fromJson(json["sort"]),
//         offset: json["offset"],
//         pageNumber: json["pageNumber"],
//         pageSize: json["pageSize"],
//         paged: json["paged"],
//         unpaged: json["unpaged"],
//       );

//   Map<String, dynamic> toJson() => {
//         "sort": sort!.toJson(),
//         "offset": offset,
//         "pageNumber": pageNumber,
//         "pageSize": pageSize,
//         "paged": paged,
//         "unpaged": unpaged,
//       };
// }

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
class Pageable {
  int? pageNumber;
  int? pageSize;
  List<dynamic>? sort;
  int? offset;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.pageNumber,
    this.pageSize,
    this.sort,
    this.offset,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        pageNumber: json['pageNumber'] as int?,
        pageSize: json['pageSize'] as int?,
        sort: json['sort'] as List<dynamic>?,
        offset: json['offset'] as int?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'sort': sort,
        'offset': offset,
        'paged': paged,
        'unpaged': unpaged,
      };
}
