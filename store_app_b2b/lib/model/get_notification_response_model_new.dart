// To parse this JSON data, do
//
//     final getNotificationResponseModel = getNotificationResponseModelFromJson(jsonString);

import 'dart:convert';

GetNotificationResponseModel getNotificationResponseModelFromJson(String str) =>
    GetNotificationResponseModel.fromJson(json.decode(str));

String getNotificationResponseModelToJson(GetNotificationResponseModel data) =>
    json.encode(data.toJson());

class GetNotificationResponseModel {
  List<Content> content;
  Pageable? pageable;
  bool last;
  num? totalElements;
  num? totalPages;
  num? size;
  num? number;
  bool first;
  Sort? sort;
  num? numberOfElements;
  bool empty;

  GetNotificationResponseModel({
    this.content = const <Content>[],
    this.pageable,
    this.last = false,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.first = false,
    this.sort,
    this.numberOfElements,
    this.empty = false,
  });

  factory GetNotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationResponseModel(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        first: json["first"],
        sort: Sort.fromJson(json["sort"]),
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
        "first": first,
        "sort": sort!.toJson(),
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class Content {
  String? id;
  String? messageType;
  String? title;
  String? message;
  IsActive? isApproved;
  String? imageId;
  DateTime? createdAt;
  IsActive? isActive;
  String? storeId;
  String? userId;
  IsActive? publicAlert;
  dynamic bgColor;

  Content({
    this.id,
    this.messageType,
    this.title,
    this.message,
    this.isApproved,
    this.imageId,
    this.createdAt,
    this.isActive,
    this.storeId,
    this.userId,
    this.publicAlert,
    this.bgColor,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        messageType: json["messageType"],
        title: json["title"],
        message: json["message"],
        isApproved: isActiveValues.map[json["isApproved"]],
        imageId: json["imageId"],
        createdAt: DateTime.parse(json["createdAt"]),
        isActive: isActiveValues.map[json["isActive"]],
        storeId: json["storeId"],
        userId: json["userId"],
        publicAlert: isActiveValues.map[json["publicAlert"]],
        bgColor: json["bgColor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "messageType": messageType,
        "title": title,
        "message": message,
        "isApproved": isActiveValues.reverse[isApproved],
        "imageId": imageId,
        "createdAt": createdAt!.toIso8601String(),
        "isActive": isActiveValues.reverse[isActive],
        "storeId": storeId,
        "userId": userId,
        "publicAlert": isActiveValues.reverse[publicAlert],
        "bgColor": bgColor,
      };
}

enum IsActive { N, Y }

final isActiveValues = EnumValues({"N": IsActive.N, "Y": IsActive.Y});

class Pageable {
  Sort? sort;
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
