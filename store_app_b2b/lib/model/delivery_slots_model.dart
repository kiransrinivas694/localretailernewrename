import 'dart:convert';

List<DeliverySlotsModel> deliverySlotsModelFromJson(String str) =>
    List<DeliverySlotsModel>.from(
        json.decode(str).map((x) => DeliverySlotsModel.fromJson(x)));

String deliverySlotsModelToJson(List<DeliverySlotsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliverySlotsModel {
  DeliverySlotsModel({
    this.slotId,
    this.slotName,
    this.startTime,
    this.endTime,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isChecked = false,
    this.displayOrder,
  });

  String? slotId;
  String? slotName;
  String? startTime;
  String? endTime;
  String? isActive;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool isChecked;
  int? displayOrder;

  factory DeliverySlotsModel.fromJson(Map<String, dynamic> json) =>
      DeliverySlotsModel(
        slotId: json["slotId"] ?? "",
        slotName: json["slotName"] ?? "",
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        isActive: json["isActive"] ?? "",
        createdAt:
            DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
        updatedAt: json["updatedAt"] ?? "",
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        isChecked: json["isChecked"] ?? false,
        displayOrder: json["displayOrder"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "slotId": slotId,
        "slotName": slotName,
        "startTime": startTime,
        "endTime": endTime,
        "isActive": isActive,
        "isChecked": isChecked,
        "displayOrder": displayOrder,
      };
}
