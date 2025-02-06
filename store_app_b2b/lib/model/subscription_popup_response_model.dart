// To parse this JSON data, do
//
//     final subscriptionPopupResponseModel = subscriptionPopupResponseModelFromJson(jsonString);

import 'dart:convert';

SubscriptionPopupResponseModel subscriptionPopupResponseModelFromJson(
        String str) =>
    SubscriptionPopupResponseModel.fromJson(json.decode(str));

String subscriptionPopupResponseModelToJson(
        SubscriptionPopupResponseModel data) =>
    json.encode(data.toJson());

class SubscriptionPopupResponseModel {
  List<Content> content;
  Pageable? pageable;
  bool last;
  num? totalElements;
  num? totalPages;
  bool first;
  num? size;
  num? number;
  Sort? sort;
  num? numberOfElements;
  bool empty;

  SubscriptionPopupResponseModel({
    this.content = const <Content>[],
    this.pageable,
    this.last = false,
    this.totalElements,
    this.totalPages,
    this.first = false,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.empty = false,
  });

  factory SubscriptionPopupResponseModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPopupResponseModel(
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
        first: json["first"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "first": first,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class Content {
  String? id;
  String? planType;
  DateTime? planStartDate;
  DateTime? planEndDate;
  String? planRate;
  String? planTenure;
  List<String> planTermsConditions;
  List<String> features;
  List<String> nofeatures;
  String? planDescription;
  bool status;
  DateTime? createdAt;
  DateTime? createdBy;
  DateTime? updatedAt;
  DateTime? updatedBy;

  Content({
    this.id,
    this.planType,
    this.planStartDate,
    this.planEndDate,
    this.planRate,
    this.planTenure,
    this.planTermsConditions = const <String>[],
    this.features = const <String>[],
    this.nofeatures = const <String>[],
    this.planDescription,
    this.status = false,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        planType: json["planType"],
        planStartDate: json["planStartDate"] == null
            ? null
            : DateTime.parse(json["planStartDate"]),
        planEndDate: json["planEndDate"] == null
            ? null
            : DateTime.parse(json["planEndDate"]),
        planRate: json["planRate"],
        planTenure: json["planTenure"],
        planTermsConditions: json["planTermsConditions"] == null
            ? []
            : List<String>.from(json["planTermsConditions"]!.map((x) => x)),
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        nofeatures: json["nofeatures"] == null
            ? []
            : List<String>.from(json["nofeatures"]!.map((x) => x)),
        planDescription: json["planDescription"],
        status: json["status"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"],
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "planType": planType,
        "planStartDate":
            "${planStartDate!.year.toString().padLeft(4, '0')}-${planStartDate!.month.toString().padLeft(2, '0')}-${planStartDate!.day.toString().padLeft(2, '0')}",
        "planEndDate":
            "${planEndDate!.year.toString().padLeft(4, '0')}-${planEndDate!.month.toString().padLeft(2, '0')}-${planEndDate!.day.toString().padLeft(2, '0')}",
        "planRate": planRate,
        "planTenure": planTenure,
        "planTermsConditions":
            List<dynamic>.from(planTermsConditions.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x)),
        "nofeatures": List<dynamic>.from(nofeatures.map((x) => x)),
        "planDescription": planDescription,
        "status": status,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
      };
}

class Pageable {
  Sort? sort;
  num? offset;
  num? pageNumber;
  num? pageSize;
  bool unpaged;
  bool paged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.unpaged = false,
    this.paged = false,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "unpaged": unpaged,
        "paged": paged,
      };
}

class Sort {
  bool empty;
  bool unsorted;
  bool sorted;

  Sort({
    this.empty = false,
    this.unsorted = false,
    this.sorted = false,
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
