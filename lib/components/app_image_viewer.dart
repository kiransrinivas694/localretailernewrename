import 'dart:developer';

import 'package:b2c/widget/app_image_assets.dart';
import 'package:flutter/material.dart';

class AppImageViewer extends StatelessWidget {
  final String? imageView;

  const AppImageViewer({super.key, required this.imageView});

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return Scaffold(body: Center(child: AppImageAsset(image: imageView)));
  }
}
