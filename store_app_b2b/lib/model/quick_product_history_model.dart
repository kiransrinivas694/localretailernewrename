// To parse this JSON data, do
//
//     final QuickProductHistoryModel = QuickProductHistoryModelFromJson(jsonString);

import 'dart:convert';

QuickProductHistoryModel quickProductHistoryModelFromJson(String str) =>
    QuickProductHistoryModel.fromJson(json.decode(str));

String quickProductHistoryModelToJson(QuickProductHistoryModel data) =>
    json.encode(data.toJson());

class QuickProductHistoryModel {
  List<Content> content;
  Pageable? pageable;
  bool last;
  num? totalElements;
  num? totalPages;
  num? size;
  num? number;
  List<Sort>? sort;
  num? numberOfElements;
  bool first;
  bool empty;

  QuickProductHistoryModel({
    this.content = const <Content>[],
    this.pageable,
    this.last = false,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first = false,
    this.empty = false,
  });

  factory QuickProductHistoryModel.fromJson(Map<String, dynamic> json) =>
      QuickProductHistoryModel(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: (json['sort'] as List<dynamic>?)
            ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
            .toList(),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort?.map((e) => e.toJson()).toList(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  String? id;
  String? userId;
  String? userName;
  String? storeId;
  String? storeName;
  DateTime? insertDate;
  List<Item> items;
  String? checkOut;
  num? platformCharges;
  num? delivaryCharges;
  num? gstCharges;
  num? totalPayble;
  String? transId;
  num? paidDelivaryAmount;
  String? transStatus;
  dynamic orderStatus;
  String? invoiceUrl;
  String? riderId;
  String? riderName;
  String? riderContactNumber;
  dynamic invoieId;
  num? invoiceAmount;
  String? invoicePaidTransId;
  dynamic invoicePaidAmount;
  String? invoicePaidTransStatus;
  String? riderStatusEventId;
  DateTime? invoiceDate;
  String? riderStatus;
  String? riderRating;
  String? cartStatus;
  String? invoiceNumber;
  String? confirmDelivery;

  Content({
    this.id,
    this.userId,
    this.userName,
    this.storeId,
    this.storeName,
    this.insertDate,
    this.items = const <Item>[],
    this.checkOut,
    this.platformCharges,
    this.delivaryCharges,
    this.gstCharges,
    this.totalPayble,
    this.transId,
    this.paidDelivaryAmount,
    this.transStatus,
    this.orderStatus,
    this.invoiceUrl,
    this.riderId,
    this.riderName,
    this.riderContactNumber,
    this.invoieId,
    this.invoiceAmount,
    this.invoicePaidTransId,
    this.invoicePaidAmount,
    this.invoicePaidTransStatus,
    this.riderStatusEventId,
    this.invoiceDate,
    this.riderStatus,
    this.riderRating,
    this.cartStatus,
    this.invoiceNumber,
    this.confirmDelivery,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      storeId: json["storeId"],
      storeName: json["storeName"],
      insertDate: json["insertDate"] == null
          ? null
          : DateTime.parse(json["insertDate"]),
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      checkOut: json["checkOut"],
      platformCharges: json["platformCharges"],
      delivaryCharges: json["delivaryCharges"],
      gstCharges: json["gstCharges"],
      totalPayble: json["totalPayble"],
      transId: json["transId"],
      paidDelivaryAmount: json["paidDelivaryAmount"],
      transStatus: json["transStatus"],
      orderStatus: json["orderStatus"],
      invoiceUrl: json["invoiceURL"],
      riderId: json["riderId"],
      riderName: json["riderName"],
      riderContactNumber: json["riderContactNumber"],
      invoieId: json["invoieId"],
      invoiceAmount: json["invoiceAmount"],
      invoicePaidTransId: json["invoicePaidTransId"],
      invoicePaidAmount: json["invoicePaidAmount"],
      invoicePaidTransStatus: json["invoicePaidTransStatus"],
      riderStatusEventId: json["riderStatusEventId"],
      invoiceDate: json["invoiceDate"] == null
          ? null
          : DateTime.parse(json["invoiceDate"]),
      riderStatus: json["riderStatus"],
      riderRating: json["riderRating"],
      cartStatus: json["cartStatus"],
      invoiceNumber: json["invoiceNumber"],
      confirmDelivery: json["confirmDelivery"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "storeId": storeId,
        "storeName": storeName,
        "insertDate": insertDate?.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "checkOut": checkOut,
        "platformCharges": platformCharges,
        "delivaryCharges": delivaryCharges,
        "gstCharges": gstCharges,
        "totalPayble": totalPayble,
        "transId": transId,
        "paidDelivaryAmount": paidDelivaryAmount,
        "transStatus": transStatus,
        "orderStatus": orderStatus,
        "invoiceURL": invoiceUrl,
        "riderId": riderId,
        "riderName": riderName,
        "riderContactNumber": riderContactNumber,
        "invoieId": invoieId,
        "invoiceAmount": invoiceAmount,
        "invoicePaidTransId": invoicePaidTransId,
        "invoicePaidAmount": invoicePaidAmount,
        "invoicePaidTransStatus": invoicePaidTransStatus,
        "riderStatusEventId": riderStatusEventId,
        "invoiceDate": invoiceDate?.toIso8601String(),
        "riderStatus": riderStatus,
        "riderRating": riderRating,
        "cartStatus": cartStatus,
        "invoiceNumber": invoiceNumber,
        "confirmDelivery": confirmDelivery
      };
}

class Item {
  String? id;
  String? productName;
  String? manufacturer;
  num? quantity;
  num? freeQuantity;
  num? totalQuantity;

  Item({
    this.id,
    this.productName,
    this.manufacturer,
    this.quantity,
    this.freeQuantity,
    this.totalQuantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        productName: json["productName"],
        manufacturer: json["manufacturer"],
        quantity: json["quantity"],
        freeQuantity: json["freeQuantity"],
        totalQuantity: json["totalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "manufacturer": manufacturer,
        "quantity": quantity,
        "freeQuantity": freeQuantity,
        "totalQuantity": totalQuantity,
      };
}

class Pageable {
  List<Sort>? sort;
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
        sort: (json['sort'] as List<dynamic>?)
            ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
            .toList(),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.map((e) => e.toJson()).toList(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  String? direction;
  String? property;
  bool? ignoreCase;
  String? nullHandling;
  bool? ascending;
  bool? descending;

  Sort({
    this.direction,
    this.property,
    this.ignoreCase,
    this.nullHandling,
    this.ascending,
    this.descending,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        direction: json['direction'] as String?,
        property: json['property'] as String?,
        ignoreCase: json['ignoreCase'] as bool?,
        nullHandling: json['nullHandling'] as String?,
        ascending: json['ascending'] as bool?,
        descending: json['descending'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'property': property,
        'ignoreCase': ignoreCase,
        'nullHandling': nullHandling,
        'ascending': ascending,
        'descending': descending,
      };
}
