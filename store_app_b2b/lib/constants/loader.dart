import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class AppLoader extends StatelessWidget {
  const AppLoader(
      {Key? key,
      this.opacity = 0.5,
      this.dismissibles = false,
      this.color = Colors.black})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: false, color: ColorsConst.bgColor),
        ),
        Center(child: CircularProgressIndicator(color: color ?? Colors.white)),
      ],
    );
  }
}
