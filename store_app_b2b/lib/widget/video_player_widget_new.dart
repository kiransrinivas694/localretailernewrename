// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:store_app_b2b/main.dart';
// import 'package:video_player/video_player.dart';

// class VideoListWidget extends StatefulWidget {
//   final List videoUrls;

//   VideoListWidget({required this.videoUrls});

//   @override
//   _VideoListWidgetState createState() => _VideoListWidgetState();
// }

// class _VideoListWidgetState extends State<VideoListWidget> {
//   late PageController _swiperController;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _swiperController = PageController();
//   }

//   @override
//   void dispose() {
//     _swiperController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: PageView.builder(
//         controller: _swiperController,
//         itemCount: widget.videoUrls.length,
//         itemBuilder: (context, index) {
//           return VideoPlayerWidget(
//             videoUrl: widget.videoUrls[index],
//             controller: _swiperController,
//             isPlaying: index == _currentIndex,
//             onVideoEnded: () {
//               if (index == widget.videoUrls.length - 1) {
//                 _swiperController.jumpToPage(0);
//               } else {
//                 _swiperController.nextPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.bounceInOut);
//               }
//             },
//           );
//         },
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         // allowImplicitScrolling: true,
//         // autoplayDelay: Duration(seconds: 3),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   final PageController controller;
//   final bool isPlaying;
//   final VoidCallback? onVideoEnded;

//   VideoPlayerWidget({
//     required this.videoUrl,
//     required this.controller,
//     this.isPlaying = false,
//     this.onVideoEnded,
//   });

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late bool _isInitialized;

//   @override
//   void initState() {
//     super.initState();
//     _isInitialized = false;
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//           if (widget.isPlaying) {
//             _controller.play();
//           }
//         });
//       });
//     _controller.addListener(() {
//       if (_controller.value.position >= _controller.value.duration) {
//         if (widget.onVideoEnded != null) {
//           widget.onVideoEnded!();
//         }
//       }
//     });
//     if (!volumeMute) {
//       _controller.setVolume(0);
//     } else {
//       _controller.setVolume(1);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       return Container(); // Show a loading indicator if the video is not yet initialized
//     }

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Stack(
//         children: [
//           SizedBox(
//             width: Get.width,
//             height: Get.height,
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             right: 10,
//             child: GestureDetector(
//               onTap: () {
//                 if (volumeMute) {
//                   _controller.setVolume(0);
//                   volumeMute = false;
//                 } else {
//                   _controller.setVolume(1);
//                   volumeMute = true;
//                 }
//                 // _controller.value.v
//                 setState(() {});
//               },
//               child: Icon(
//                 volumeMute ? Icons.volume_up : Icons.volume_off,
//                 color: Color(0xff555555),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_app_b2b/controllers/video_player_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';
import 'package:video_player/video_player.dart';

import '../main_new.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListWidget extends StatefulWidget {
  List<dynamic> videoUrls;

  VideoListWidget({required this.videoUrls});

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late PageController _swiperController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _swiperController = PageController();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  // final vidController = Get.put(VidPlayerController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: GetBuilder<VidPlayerController>(
          init: VidPlayerController(),
          builder: (vpc) {
            return Stack(
              children: [
                PageView.builder(
                  controller: _swiperController,
                  itemCount: widget.videoUrls.length,
                  itemBuilder: (context, index) {
                    return VideoPlayerWidget(
                      videoUrl: widget.videoUrls[index],
                      controller: _swiperController,
                      isPlaying: index == _currentIndex,
                      onVideoEnded: () {
                        print('video ended');
                        if (_currentIndex == widget.videoUrls.length - 1) {
                          _swiperController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut,
                          );
                        } else if (_currentIndex ==
                            widget.videoUrls.length - 1) {
                          _swiperController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut,
                          );
                        }
                      },
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      // if (index == widget.videoUrls.length - 1) {
                      //   _currentIndex = 0;
                      // }
                    });
                  },
                  //allowImplicitScrolling: true,
                  //autoplayDelay: Duration(seconds: 3),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnimatedSmoothIndicator(
                        activeIndex: _currentIndex,
                        count: widget.videoUrls.length,
                        effect: WormEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          activeDotColor: AppColors.primaryColor,
                        ),
                        onDotClicked: (index) {}),
                  ),
                ),
                Positioned(
                  bottom: 7,
                  right: 7,
                  child: InkWell(
                    onTap: () => vpc.toggleMute(),
                    child: Icon(
                      (vpc.isMute)
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      color: vpc.isInitialised
                          ? AppColors.primaryColor
                          : AppColors.greyBorderColor,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final PageController controller;
  final bool isPlaying;
  final VoidCallback? onVideoEnded;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.controller,
    this.isPlaying = false,
    this.onVideoEnded,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isInitialized;

  final vpc = Get.find<VidPlayerController>();

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.removeListener(_listener);
      _controller.dispose();
    }
    print("dispose of vid player in lib is called");
    super.dispose();
  }

  _listener() {
    if (_controller.value.position >= _controller.value.duration) {
      if (widget.onVideoEnded != null) {
        widget.onVideoEnded!();
        _controller.play();
      }
    }

    // print("printing currentRoute -> ${Get.currentRoute}");
    // if (Get.currentRoute == '/HomeScreen' && _controller.value.volume != 0) {
    //   _controller.setVolume(1);
    // }
    // if (Get.currentRoute != '/HomeScreen') {
    //   if (_controller.value.volume != 0) _controller.setVolume(0);
    // print("printing currentRoute ---> changed to ${Get.currentRoute}");
    // _controller.dispose();
    // }
    setState(() {
      if (vpc.isMute) {
        _controller.setVolume(0);
      } else {
        _controller.setVolume(1);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isInitialized = false;
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          vpc.isSpeakerButtonOperational(_isInitialized);
          if (widget.isPlaying) {
            _controller.play();
            _controller.setVolume(vpc.isMute ? 0 : 1);
          }
        });
      });
    _controller.addListener(_listener);

    // if (!volumeMute) {
    //   _controller.setVolume(0);
    // } else {
    //   _controller.setVolume(1);
    // }
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return AppShimmerEffectView(); // Show a loading indicator if the video is not yet initialized
    }

    return VisibilityDetector(
      key: Key("vid player 1 unique"),
      onVisibilityChanged: (VisibilityInfo info) {
        if (mounted) {
          if (info.visibleFraction == 0) {
            _controller.pause();
            print("video controller is paused");
          } else {
            if (mounted) _controller.play();
            print("video controller is played");
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            // Positioned(
            //   bottom: 10,
            //   right: 10,
            //   child: GestureDetector(
            //     onTap: () {
            //       if (volumeMute) {
            //         _controller.setVolume(0);
            //         volumeMute = false;
            //       } else {
            //         _controller.setVolume(1);
            //         volumeMute = true;
            //       }
            //       _controller.value;
            //       setState(() {});
            //     },
            //     child: Icon(
            //       volumeMute ? Icons.volume_up : Icons.volume_off,
            //       color: Colors.orange,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
