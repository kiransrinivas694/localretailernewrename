import 'dart:developer';

import 'package:b2c/components/common_search_field_new.dart';
import 'package:b2c/components/common_snackbar_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/missed_call_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/user_details_screen_new.dart';
import 'package:b2c/utils/firebase_messaging_service_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ----------- vaishnav ---------------
//import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// ----------- vaishnav ---------------
import '../../../../controllers/GetHelperController_new.dart';
import 'controller/get_customers_controller_new.dart';
import 'controller/user_controller_new.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController searchController = TextEditingController();

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;

  @override
  void initState() {
    // TODO: implement onInit

    GetCustomersController.to.getCustomerApi(
      queryParameters: {"page": page.value, "size": 10},
    );
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      page.value = page.value + 1;
      log(
        page.value.toString(),
        name: "PAGE CHANGE",
      );
      await GetCustomersController.to.getCustomerApi(
        queryParameters: {"page": page.value, "size": 10},
      );

      isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(GetHelperController.storeID.value, name: 'storeID');
    log(getFcmToken(), name: 'token');

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.greyBgColor,
        appBar: AppBar(
          centerTitle: false,
          title: CommonText(
            content: "Users",
            boldNess: FontWeight.w600,
            textSize: width * 0.047,
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.appGradientColor,
              ),
            ),
          ),
          actions: [
            /*  IconButton(
              onPressed: () {
                Get.to(() => const MissedCallScreen());
              },
              icon: const Icon(Icons.missed_video_call),
            ),*/
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CommonSearchField(
                controller: searchController,
                onChanged: (value) {
                  GetCustomersController.to.getCustomerList.clear();
                  log(value, name: 'value');
                  if (value.isEmpty) {
                    page.value = 0;
                    GetCustomersController.to.getCustomerApi(
                      queryParameters: {
                        "page": page.value,
                        "size": 10,
                        'phoneNumber': searchController.text
                      },
                    );
                  } else {
                    page.value = 0;
                    GetCustomersController.to.getCustomerApi(
                      queryParameters: {
                        /* "page": page.value,
                      "size": 10,*/
                        'phoneNumber': searchController.text
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: height * 0.02),
            Obx(() {
              return GetCustomersController.to.getCustomerRes.isEmpty
                  ? CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount:
                            GetCustomersController.to.getCustomerList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // print(GetCustomersController.to.getCustomerList[index]["coustomerId"]);
                          // print(GetCustomersController.to.getCustomerList[index]["fcmToken"]);
                          log(
                              GetCustomersController.to.getCustomerList[index]
                                  .toString(),
                              name: index.toString());
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => UserDetailsScreen(
                                        userData: GetCustomersController
                                            .to.getCustomerList[index],
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 20,
                                      left: 20,
                                      top: index == 0 ? 10 : 0),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CommonText(
                                            content: GetCustomersController.to
                                                        .getCustomerList[index]
                                                    ['customerName'] ??
                                                '--',
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w500,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "Status :",
                                                textColor: AppColors.textColor,
                                              ),
                                              CommonText(
                                                content: (GetCustomersController
                                                                    .to
                                                                    .getCustomerList[
                                                                index]
                                                            ['customerStaus'] ??
                                                        false)
                                                    ? "Active"
                                                    : 'UnActive',
                                                textColor: Colors.green,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      CommonText(
                                        content: GetCustomersController
                                                    .to.getCustomerList[index]
                                                ['customerPhoneNumber'] ??
                                            '--',
                                        textColor: AppColors.textColor,
                                        textSize: width * 0.035,
                                      ),
                                      CommonText(
                                        content:
                                            "RANK : ${GetCustomersController.to.getCustomerList[index]['customerRank'] ?? '--'}",
                                        textColor: AppColors.textColor,
                                        boldNess: FontWeight.w500,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                              content:
                                                  "TOTAL ORDER AMT : ₹${double.parse((GetCustomersController.to.getCustomerList[index]['totalBuyValue'] ?? '0').toString()).toStringAsFixed(2)}",
                                              textColor: AppColors.textColor,
                                              boldNess: FontWeight.w500,
                                            ),
                                          ),
                                          /*sendCallButton(
                                      isVideoCall: false,
                                      inviteeUsersIDTextCtrl:
                                          TextEditingController(
                                              text: GetCustomersController
                                                      .to.getCustomerList[index]
                                                  ["coustomerId"]),
                                      onCallFinished: (code, message, p2) =>
                                          onSendCallInvitationFinished(
                                              context,
                                              code,
                                              message,
                                              p2,
                                              GetCustomersController
                                                      .to.getCustomerList[index]
                                                  ["coustomerId"],
                                              GetCustomersController
                                                          .to.getCustomerList[
                                                      index]["fcmToken"] ??
                                                  ""),
                                    ),
                                    sendCallButton(
                                      isVideoCall: true,
                                      inviteeUsersIDTextCtrl:
                                          TextEditingController(
                                              text: GetCustomersController
                                                      .to.getCustomerList[index]
                                                  ["coustomerId"]),
                                      // onCallFinished: onSendCallInvitationFinished,
                                      onCallFinished: (code, message, p2) =>
                                          onSendCallInvitationFinished(
                                              context,
                                              code,
                                              message,
                                              p2,
                                              GetCustomersController
                                                      .to.getCustomerList[index]
                                                  ["coustomerId"],
                                              GetCustomersController
                                                          .to.getCustomerList[
                                                      index]["fcmToken"] ??
                                                  ""),
                                    ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                            ],
                          );
                        },
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}

void onSendCallInvitationFinished(
  BuildContext context,
  String code,
  String message,
  List<String> errorInvitees,
  String usedId,
  String fcmToken,
) {
  userController.currentCallee.value = usedId;
  userController.currentCalleeFcm.value = fcmToken;
  print(
      "userController.currentCallee ===> ${userController.currentCallee.value}");
  if (errorInvitees.isNotEmpty) {
    var userIDs = '';
    for (var index = 0; index < errorInvitees.length; index++) {
      if (index >= 5) {
        userIDs += '... ';
        break;
      }

      final userID = errorInvitees.elementAt(index);
      userIDs += '$userID ';
    }
    if (userIDs.isNotEmpty) {
      userIDs = userIDs.substring(0, userIDs.length - 1);
    }

    var message = "User doesn't exist or is offline: $userIDs";
    if (code.isNotEmpty) {
      message += ', code: $code, message:$message';
    }
    CommonSnackBar.showError(message.toString());
  } else if (code.isNotEmpty) {
    CommonSnackBar.showError('code: $code, message:$message');
  }
}
// ----------- vaishnav ---------------
// Widget sendCallButton({
//   required bool isVideoCall,
//   required TextEditingController inviteeUsersIDTextCtrl,
//   void Function(String code, String message, List<String>)? onCallFinished,
// }) {
//   return ValueListenableBuilder<TextEditingValue>(
//     valueListenable: inviteeUsersIDTextCtrl,
//     builder: (context, inviteeUserID, _) {
//       final invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);
//       // print(invitees.first.id);
//       // if (invitees.isNotEmpty) {
//       //   userController.currentCallee.value = invitees.first.id;
//       // }
//       return ZegoSendCallInvitationButton(
//         isVideoCall: isVideoCall,
//         invitees: invitees,
//         resourceID: 'zego_data',
//         // resourceID: 'zego_uikit_call',
//         iconSize: const Size(40, 40),
//         buttonSize: const Size(50, 50),
//         // onPressed: (code, message, p2) {
//         //   if (onCallFinished != null) {
//         //     // print(p2.length);
//         //     onCallFinished(code, message, p2);
//         //   }
//         // },
//         onPressed: onCallFinished,
//         icon: ButtonIcon(
//             icon: Icon(isVideoCall ? Icons.videocam : Icons.call),
//             backgroundColor: Colors.transparent),
//       );
//     },
//   );
// }

// List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
//   final invitees = <ZegoUIKitUser>[];

//   final inviteeIDs = textCtrlText.trim().replaceAll('，', '');
//   inviteeIDs.split(',').forEach((inviteeUserID) {
//     if (inviteeUserID.isEmpty) {
//       return;
//     }

//     invitees.add(ZegoUIKitUser(
//       id: inviteeUserID,
//       name: 'user_$inviteeUserID',
//     ));
//   });

//   return invitees;
// }
// ----------- vaishnav ---------------
