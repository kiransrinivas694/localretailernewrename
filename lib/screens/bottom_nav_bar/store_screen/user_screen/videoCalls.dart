import 'dart:developer';

import 'package:b2c/components/common_search_field.dart';
import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/controller/get_calls_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/missed_call_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/user_details_screen.dart';
import 'package:b2c/utils/firebase_messaging_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ----------- vaishnav ---------------
//import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// ----------- vaishnav ---------------
import '../../../../controllers/GetHelperController.dart';
import 'controller/get_customers_controller.dart';
import 'controller/user_controller.dart';

class VideoCallsScreen extends StatefulWidget {
  VideoCallsScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallsScreen> createState() => _VideoCallsScreenState();
}

class _VideoCallsScreenState extends State<VideoCallsScreen> {
  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxInt selectedTab = 0.obs;
  RxBool isLoadingMore = false.obs;

  @override
  void initState() {
    // TODO: implement onInit
    GetCallsController.to.waitingList.clear();
    GetCallsController.to.getWaitingCallApi(
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
      await GetCallsController.to.getWaitingCallApi(
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
            content: "Video Calls",
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
            /* IconButton(
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
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: List.generate(
                    2,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedTab.value = index;
                          if (index == 1) {
                            userController
                                .getCallApi(GetHelperController.storeID.value);
                          } else {
                            page.value = 0;
                            GetCustomersController.to.getCustomerList.clear();
                            GetCustomersController.to.getCustomerApi(
                              queryParameters: {"page": page.value, "size": 10},
                            );
                          }
                        },
                        child: Column(
                          children: [
                            CommonText(
                              content:
                                  index == 0 ? "Missed Calls" : 'Call History',
                              textColor: selectedTab.value == index
                                  ? AppColors.primaryColor
                                  : AppColors.borderColor,
                              boldNess: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                              color: selectedTab.value == index
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              thickness: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: height * 0.02),
            Obx(() {
              return selectedTab.value == 0
                  ? Obx(() {
                      return GetCallsController.to.getWaitingListRes.isEmpty
                          ? Expanded(
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount:
                                    GetCallsController.to.waitingList.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // print(GetCustomersController.to.getCustomerList[index]["coustomerId"]);
                                  // print(GetCustomersController.to.getCustomerList[index]["fcmToken"]);
                                  log(
                                      GetCallsController.to.waitingList[index]
                                          .toString(),
                                      name: index.toString());
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 20,
                                            left: 20,
                                            top: index == 0 ? 10 : 0),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(500),
                                                        child: Image.network(
                                                          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                                          fit: BoxFit.cover,
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              content: GetCallsController
                                                                              .to
                                                                              .waitingList[
                                                                          index]
                                                                      [
                                                                      'senderId'] ??
                                                                  '--',
                                                              textColor:
                                                                  AppColors
                                                                      .textColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            CommonText(
                                                              content: GetCallsController
                                                                              .to
                                                                              .waitingList[
                                                                          index]
                                                                      [
                                                                      'message'] ??
                                                                  '--',
                                                              textColor: AppColors
                                                                  .primaryColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // ----------- vaishnav ---------------
                                                // sendCallButton(
                                                //   isVideoCall: false,
                                                //   inviteeUsersIDTextCtrl:
                                                //       TextEditingController(
                                                //           text: GetCallsController
                                                //                           .to
                                                //                           .waitingList[
                                                //                       index]?[
                                                //                   "senderId"] ??
                                                //               'Acintyo'),
                                                //   onCallFinished: (code,
                                                //           message, p2) =>
                                                //       onSendCallInvitationFinished(
                                                //           context,
                                                //           code,
                                                //           message,
                                                //           p2,
                                                //           GetCallsController.to
                                                //                           .waitingList[
                                                //                       index]?[
                                                //                   "senderId"] ??
                                                //               '',
                                                //           GetCallsController.to
                                                //                           .waitingList[
                                                //                       index]?[
                                                //                   "fcmToken"] ??
                                                //               ""),
                                                // ),
                                                // sendCallButton(
                                                //   isVideoCall: true,
                                                //   inviteeUsersIDTextCtrl:
                                                //       TextEditingController(
                                                //           text: GetCallsController
                                                //                           .to
                                                //                           .waitingList[
                                                //                       index]?[
                                                //                   "senderId"] ??
                                                //               ''),
                                                //   // onCallFinished: onSendCallInvitationFinished,
                                                //   onCallFinished: (code,
                                                //           message, p2) =>
                                                //       onSendCallInvitationFinished(
                                                //           context,
                                                //           code,
                                                //           message,
                                                //           p2,
                                                //           GetCallsController.to
                                                //                           .waitingList[
                                                //                       index][
                                                //                   "receiverId"] ??
                                                //               '',
                                                //           GetCallsController.to
                                                //                           .waitingList[
                                                //                       index][
                                                //                   "fcmToken"] ??
                                                //               ""),
                                                // ),
                                                // ----------- vaishnav ---------------
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                    ],
                                  );
                                },
                              ),
                            );
                    })
                  : Expanded(
                      child: StreamBuilder(
                          stream: userController.callList.stream,
                          builder: (context, snapshot) {
                            return userController.callRes.isEmpty
                                ? CupertinoActivityIndicator(
                                    color: AppColors.primaryColor,
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.all(15),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: userController.callList.length,
                                    itemBuilder: (context, index) {
                                      int itemCount =
                                          userController.callList.length;
                                      int reversedIndex = itemCount - 1 - index;
                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(500),
                                            child: Image.network(
                                              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                              fit: BoxFit.cover,
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  content:
                                                      "You received missed call...",
                                                  boldNess: FontWeight.w500,
                                                  textSize: width * 0.040,
                                                  textColor: Colors.black,
                                                ),
                                                const SizedBox(height: 5),
                                                CommonText(
                                                  content: differenceAgo(
                                                      userController
                                                              .callList[
                                                                  reversedIndex]
                                                              .createdDt ??
                                                          DateTime.now()),
                                                  boldNess: FontWeight.w500,
                                                  textSize: width * 0.035,
                                                  textColor: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ----------- vaishnav ---------------
                                          // sendCallButton(
                                          //   isVideoCall: false,
                                          //   inviteeUsersIDTextCtrl:
                                          //       TextEditingController(
                                          //           text: userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .senderId ??
                                          //               "Acintyo B2C"),
                                          //   onCallFinished: (code, message,
                                          //           p2) =>
                                          //       onSendCallInvitationFinished(
                                          //           context,
                                          //           code,
                                          //           message,
                                          //           p2,
                                          //           userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .senderId ??
                                          //               "",
                                          //           userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .fcmToken ??
                                          //               ""),
                                          // ),
                                          // sendCallButton(
                                          //   isVideoCall: true,
                                          //   inviteeUsersIDTextCtrl:
                                          //       TextEditingController(
                                          //           text: userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .senderId ??
                                          //               ""),
                                          //   // onCallFinished: onSendCallInvitationFinished,
                                          //   onCallFinished: (code, message,
                                          //           p2) =>
                                          //       onSendCallInvitationFinished(
                                          //           context,
                                          //           code,
                                          //           message,
                                          //           p2,
                                          //           userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .senderId ??
                                          //               "",
                                          //           userController
                                          //                   .callList[
                                          //                       reversedIndex]
                                          //                   .fcmToken ??
                                          //               ""),
                                          // ),
                                          // ----------- vaishnav ---------------
                                        ],
                                      );
                                    },
                                  );
                          }),
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
