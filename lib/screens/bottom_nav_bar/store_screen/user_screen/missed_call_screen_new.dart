import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/controller/user_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/user_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../components/common_text_new.dart';
import '../../../../controllers/GetHelperController_new.dart';

class MissedCallScreen extends StatefulWidget {
  const MissedCallScreen({Key? key}) : super(key: key);

  @override
  State<MissedCallScreen> createState() => _MissedCallScreenState();
}

class _MissedCallScreenState extends State<MissedCallScreen> {
  @override
  void initState() {
    super.initState();
    userController.getCallApi(GetHelperController.storeID.value);
    // userController.getCallApi("AL-C202305-669");
  }

  static List<Color> appGradientColor = const [
    Color(0xff2E384A),
    Color(0xff0B111D)
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "Call History",
          boldNess: FontWeight.w600,
          textSize: width * 0.047,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: appGradientColor,
            ),
          ),
        ),
      ),
      body: StreamBuilder<Object>(
          stream: userController.callList.stream,
          builder: (context, snapshot) {
            return RefreshIndicator(
              onRefresh: () async {
                userController.getCallApi(GetHelperController.storeID.value);
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: userController.callList.length,
                itemBuilder: (context, index) {
                  int itemCount = userController.callList.length;
                  int reversedIndex = itemCount - 1 - index;
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(500),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              content: "You received missed call...",
                              boldNess: FontWeight.w500,
                              textSize: width * 0.040,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 5),
                            CommonText(
                              content: differenceAgo(userController
                                      .callList[reversedIndex].createdDt ??
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
                      //   inviteeUsersIDTextCtrl: TextEditingController(text: userController.callList[reversedIndex].senderId ?? ""),
                      //   onCallFinished: (code, message, p2) => onSendCallInvitationFinished(context, code, message, p2, userController.callList[reversedIndex].senderId ?? "", userController.callList[reversedIndex].fcmToken ?? ""),
                      // ),
                      // sendCallButton(
                      //   isVideoCall: true,
                      //   inviteeUsersIDTextCtrl: TextEditingController(text: userController.callList[reversedIndex].senderId ?? ""),
                      //   // onCallFinished: onSendCallInvitationFinished,
                      //   onCallFinished: (code, message, p2) => onSendCallInvitationFinished(context, code, message, p2, userController.callList[reversedIndex].senderId ?? "", userController.callList[reversedIndex].fcmToken ?? ""),
                      // ),
                      // ----------- vaishnav ---------------
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}

String differenceAgo(DateTime dateTime) {
  return dateTime.day == DateTime.now().day
      ? convertToAgo(dateTime)
      : DateFormat("dd MMMM yy").format(dateTime);
}

String convertToAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inHours >= 1) {
    return diff.inHours > 1
        ? '${diff.inHours} hour ago'
        : '${diff.inHours} hours ago';
  } else if (diff.inMinutes >= 1) {
    return diff.inMinutes > 1
        ? '${diff.inMinutes} minute ago'
        : '${diff.inMinutes} minutes ago';
  } else if (diff.inSeconds >= 1) {
    return diff.inSeconds > 1
        ? '${diff.inSeconds} second ago'
        : '${diff.inSeconds} seconds ago';
  } else {
    return 'just now';
  }
}
