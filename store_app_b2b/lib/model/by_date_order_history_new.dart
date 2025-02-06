import 'dart:convert';

ByDateOrderHistory byDateOrderHistoryFromJson(String str) =>
    ByDateOrderHistory.fromJson(json.decode(str));

String byDateOrderHistoryToJson(ByDateOrderHistory data) =>
    json.encode(data.toJson());

class ByDateOrderHistory {
  List<ByDateOfHistoryContent> content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  List<dynamic>? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  ByDateOrderHistory({
    this.content = const <ByDateOfHistoryContent>[],
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory ByDateOrderHistory.fromJson(Map<String, dynamic> json) =>
      ByDateOrderHistory(
        content: List<ByDateOfHistoryContent>.from(
            json["content"].map((x) => ByDateOfHistoryContent.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
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
        "pageable": pageable!.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort,
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class ByDateOfHistoryContent {
  DateTime? date;
  int? totalItem;
  int? totalOrders;
  double? totalOrdersValue;
  List<UserOrderMobileDisplay> userOrderMobileDisplay;

  ByDateOfHistoryContent({
    this.date,
    this.totalItem,
    this.totalOrders,
    this.totalOrdersValue,
    this.userOrderMobileDisplay = const <UserOrderMobileDisplay>[],
  });

  factory ByDateOfHistoryContent.fromJson(Map<String, dynamic> json) =>
      ByDateOfHistoryContent(
        date: DateTime.parse(json["date"]),
        totalItem: json["totalItem"],
        totalOrders: json["totalOrders"],
        totalOrdersValue: json["totalOrdersValue"].toDouble(),
        userOrderMobileDisplay: List<UserOrderMobileDisplay>.from(
            json["userOrderMobileDisplay"]
                .map((x) => UserOrderMobileDisplay.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "totalItem": totalItem,
        "totalOrders": totalOrders,
        "totalOrdersValue": totalOrdersValue,
        "userOrderMobileDisplay":
            List<dynamic>.from(userOrderMobileDisplay!.map((x) => x.toJson())),
      };
}

class UserOrderMobileDisplay {
  String? orderId;
  String? storeId;
  String? storeName;
  String? orderStatus;
  String? orderStautsId;
  DateTime? orderDate;
  String? customerId;
  double? orderValue;
  String? payMode;
  int? totalItems;
  String? supplierAddr;
  String? orderTime;

  UserOrderMobileDisplay({
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

  factory UserOrderMobileDisplay.fromJson(Map<String, dynamic> json) =>
      UserOrderMobileDisplay(
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
  List<dynamic>? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? unpaged;
  bool? paged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.unpaged,
    this.paged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: (json['sort'] as List<dynamic>?)
            ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
            .toList(),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort,
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "unpaged": unpaged,
        "paged": paged,
      };
}

class Sort {
  String? direction;
  String? property;
  bool? ignoreCase;
  String? nullHandling;
  bool? descending;
  bool? ascending;

  Sort({
    this.direction,
    this.property,
    this.ignoreCase,
    this.nullHandling,
    this.descending,
    this.ascending,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        direction: json['direction'] as String?,
        property: json['property'] as String?,
        ignoreCase: json['ignoreCase'] as bool?,
        nullHandling: json['nullHandling'] as String?,
        descending: json['descending'] as bool?,
        ascending: json['ascending'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'property': property,
        'ignoreCase': ignoreCase,
        'nullHandling': nullHandling,
        'descending': descending,
        'ascending': ascending,
      };
}
