// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';

class VidPlayerController extends GetxController {
  bool isMute = true;
  bool isInitialised = false;

  isSpeakerButtonOperational(bool isInitialised) {
    this.isInitialised = isInitialised;
    update();
  }

  toggleMute() {
    if (isInitialised) {
      isMute = !isMute;
    }
    update();
  }
}
