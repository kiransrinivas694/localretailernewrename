import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../service/api_service_new.dart';

final UserController userController = Get.put(UserController());

class UserController extends GetxController {
  RxString currentCallee = "".obs;
  RxString currentCalleeFcm = "".obs;

  Future<dynamic> missedCallApi(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.missedCallApi),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(params),
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(params.toString(), name: 'params');
      log(responseBody.toString(), name: 'RES');
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      e.message.toString().showError();
    } on SocketException catch (e) {
      e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  RxList<GetCallModel> callList = <GetCallModel>[].obs;
  RxMap<String, dynamic> callRes = <String, dynamic>{}.obs;

  Future<dynamic> getCallApi(String id) async {
    print("printing store id in getCallApi --> ${id}");
    if (id.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(ApiConfig.getCallApi + id),
          headers: <String, String>{'Content-Type': 'application/json'},
          // body: jsonEncode(params),
        );
        final responseBody = jsonDecode(response.body);
        log(responseBody.toString(), name: 'RES');

        if (response.statusCode == 200) {
          callList.clear();
          final list = json.decode(response.body.toString())['content'];
          callRes.value = json.decode(response.body.toString());
          list.forEach((element) {
            callList.add(element);
            log(element.toJson().toString(), name: 'callList');
          });
          // callList.reversed.toList();
          return responseBody;
        } else {
          responseBody['message'].toString().showError();
        }
      } on TimeoutException catch (e) {
        e.message.toString().showError();
      } on SocketException catch (e) {
        e.message.toString().showError();
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    } else {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (!Get.isDialogOpen!) {
            Get.dialog(const LoginDialog());
          }
        },
      );
    }
  }
}

// To parse this JSON data, do
//
//     final getCallModel = getCallModelFromJson(jsonString);

List<GetCallModel> getCallModelFromJson(String str) => List<GetCallModel>.from(
    json.decode(str).map((x) => GetCallModel.fromJson(x)));

String getCallModelToJson(List<GetCallModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCallModel {
  String? id;
  String? senderId;
  String? receiverId;
  DateTime? createdDt;
  String? message;
  String? fcmToken;

  GetCallModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.createdDt,
    this.message,
    this.fcmToken,
  });

  factory GetCallModel.fromJson(Map<String, dynamic> json) => GetCallModel(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        createdDt: json["createdDt"] == null
            ? null
            : DateTime.parse(json["createdDt"]),
        message: json["message"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "createdDt": createdDt?.toIso8601String(),
        "message": message,
        "fcmToken": fcmToken,
      };
}
