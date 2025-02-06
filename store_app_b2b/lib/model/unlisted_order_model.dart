// To parse this JSON data, do
//
//     final getUnlistedProductResponseModel = getUnlistedProductResponseModelFromJson(jsonString);

import 'dart:convert';

GetUnlistedProductResponseModel getUnlistedProductResponseModelFromJson(
        String str) =>
    GetUnlistedProductResponseModel.fromJson(json.decode(str));

String getUnlistedProductResponseModelToJson(
        GetUnlistedProductResponseModel data) =>
    json.encode(data.toJson());

class GetUnlistedProductResponseModel {
  List<Content> content;
  Pageable? pageable;
  bool last;
  num? totalElements;
  num? totalPages;
  num? size;
  num? number;
  Sort? sort;
  bool first;
  num? numberOfElements;
  bool empty;

  GetUnlistedProductResponseModel({
    this.content = const <Content>[],
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

  factory GetUnlistedProductResponseModel.fromJson(Map<String, dynamic> json) =>
      GetUnlistedProductResponseModel(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: Sort.fromJson(json["sort"]),
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
        "sort": sort!.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class Content {
  String? orderId;
  String? storeId;
  String? storeName;
  String? orderStatus;
  String? orderStautsId;
  DateTime? orderDate;
  String? customerId;
  num? orderValue;
  String? payMode;
  num? totalItems;
  String? supplierAddr;
  String? orderTime;

  Content({
    this.orderId,
    this.storeId,
    this.storeName,
    this.orderStatus,
    this.orderStautsId,
    this.orderDate,
    this.customerId,
    this.orderValue,
    this.payMode,
    this.totalItems,
    this.supplierAddr,
    this.orderTime,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        orderId: json["orderId"],
        storeId: json["storeId"],
        storeName: json["storeName"],
        orderStatus: json["orderStatus"],
        orderStautsId: json["orderStautsId"],
        orderDate: DateTime.parse(json["orderDate"]),
        customerId: json["customerId"],
        orderValue: json["orderValue"].toDouble(),
        payMode: json["payMode"],
        totalItems: json["totalItems"],
        supplierAddr: json["supplierAddr"],
        orderTime: json["orderTime"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "storeId": storeId,
        "storeName": storeName,
        "orderStatus": orderStatus,
        "orderStautsId": orderStautsId,
        "orderDate": orderDate!.toIso8601String(),
        "customerId": customerId,
        "orderValue": orderValue,
        "payMode": payMode,
        "totalItems": totalItems,
        "supplierAddr": supplierAddr,
        "orderTime": orderTime,
      };
}

class Pageable {
  Sort? sort;
  num? offset;
  num? pageSize;
  num? pageNumber;
  bool paged;
  bool unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.paged = false,
    this.unpaged = false,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort!.toJson(),
        "offset": offset,
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool empty;
  bool sorted;
  bool unsorted;

  Sort({
    this.empty = false,
    this.sorted = false,
    this.unsorted = false,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
      };
}
