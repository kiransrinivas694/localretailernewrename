import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:b2c/widget/video_player_widget_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoDialog extends StatefulWidget {
  const VideoDialog({super.key, this.message = "", this.isSkippable = true});

  final String message;
  final bool isSkippable;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  GlobalMainController gmController = Get.find<GlobalMainController>();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(gmController
                .paymentAwarenessVideoUrl ==
            ""
        ? "https://acintyotech-public.s3.ap-south-1.amazonaws.com/assets/eff4ad34-0a5e-44d0-9287-4dba0d9b2514.mp4"
        : gmController.paymentAwarenessVideoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          //   vpc.isSpeakerButtonOperational(_isInitialized);
          //   if (widget.isPlaying) {
          _controller.play();
          //     _controller.setVolume(vpc.isMute ? 0 : 1);
          //   }
        });
      });
    _controller.addListener(_listener);
  }

  _listener() {
    if (_controller.value.position >= _controller.value.duration) {
      Get.back();
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 3),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        content: Container(
          // height: 180,
          width: MediaQuery.of(context).size.width * 0.9,

          child: _isInitialized
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 0),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AppText(
                                  'Payments Made Easier Now.\nCheck how it works.',
                                  color: AppColors.appblack,
                                  textAlign: widget.isSkippable
                                      ? TextAlign.left
                                      : TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              widget.isSkippable
                                  // false
                                  ? GestureDetector(
                                      onTap: () {
                                        print("onclick happened on icon");
                                        _controller.dispose();
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Icon(Icons.close),
                                      ),
                                    )
                                  : SizedBox()

                              // const SizedBox(width: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // widget.isSkippable
                    //     ? Positioned(
                    //         top: 3,
                    //         right: 3,
                    //         child: GestureDetector(
                    //           onTap: () {
                    //             print("onclick happened on container");
                    //             Get.back();
                    //           },
                    //           child: Container(
                    //             height: 40,
                    //             width: 40,
                    //             decoration: BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               color: Colors.white,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Color.fromRGBO(0, 0, 0, 0.25),
                    //                   offset: Offset(0, 0),
                    //                   blurRadius: 4,
                    //                   spreadRadius: 0,
                    //                 ),
                    //               ],
                    //             ),
                    //             child: GestureDetector(
                    //                 onTap: () {
                    //                   print("onclick happened on icon");
                    //                   Get.back();
                    //                 },
                    //                 child: Icon(Icons.close)),
                    //           ),
                    //         ))
                    //     : SizedBox()
                  ],
                )
              : AppShimmerEffectView(
                  height: 200,
                ),
        ),
      ),
    );
  }
}
