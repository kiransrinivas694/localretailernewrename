import 'dart:convert';

DliveryBoyListModel dliveryBoyListModelFromJson(String str) =>
    DliveryBoyListModel.fromJson(json.decode(str));

String dliveryBoyListModelToJson(DliveryBoyListModel data) =>
    json.encode(data.toJson());

class DliveryBoyListModel {
  List<Content> content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool first;
  bool empty;

  DliveryBoyListModel({
    this.content = const <Content>[],
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last = false,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first = false,
    this.empty = false,
  });

  factory DliveryBoyListModel.fromJson(Map<String, dynamic> json) =>
      DliveryBoyListModel(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable!.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort!.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  String? employeeProfileId;
  String? empName;
  String? phoneNumber;
  String? alterNativephoneNumber;
  String? delivaryArea;
  String? fcmToken;
  String? distance;
  DateTime? empJoinDate;

  Content({
    this.employeeProfileId,
    this.empName,
    this.phoneNumber,
    this.alterNativephoneNumber,
    this.delivaryArea,
    this.fcmToken,
    this.distance,
    this.empJoinDate,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        employeeProfileId: json["employeeProfileId"],
        empName: json["empName"],
        phoneNumber: json["phoneNumber"],
        alterNativephoneNumber: json["alterNativephoneNumber"],
        delivaryArea: json["delivaryArea"],
        fcmToken: json["fcmToken"],
        distance: json["distance"],
        empJoinDate: DateTime.parse(json["empJoinDate"]),
      );

  Map<String, dynamic> toJson() => {
        "employeeProfileId": employeeProfileId,
        "empName": empName,
        "phoneNumber": phoneNumber,
        "alterNativephoneNumber": alterNativephoneNumber,
        "delivaryArea": delivaryArea,
        "fcmToken": fcmToken,
        "distance": distance,
        "empJoinDate":
            "${empJoinDate!.year.toString().padLeft(4, '0')}-${empJoinDate!.month.toString().padLeft(2, '0')}-${empJoinDate!.day.toString().padLeft(2, '0')}",
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
        sort: Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort!.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? unsorted;
  bool? sorted;

  Sort({
    this.empty,
    this.unsorted,
    this.sorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        unsorted: json["unsorted"],
        sorted: json["sorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "unsorted": unsorted,
        "sorted": sorted,
      };
}
