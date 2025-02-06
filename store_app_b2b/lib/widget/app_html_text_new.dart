import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AppHtmlText extends StatelessWidget {
  final String title;
  final int? maxLines;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverFlow;

  const AppHtmlText(this.title,
      {Key? key,
      this.maxLines = 1,
      this.fontSize = 16,
      this.fontWeight,
      this.textOverFlow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: title,
      shrinkWrap: true,
      style: {
        '#': Style(
            fontSize: FontSize(fontSize),
            maxLines: maxLines,
            fontWeight: fontWeight,
            textOverflow: textOverFlow),
        'ul': Style(fontSize: FontSize(fontSize)),
        'li': Style(fontSize: FontSize(fontSize)),
        "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
        'p': Style(fontSize: FontSize(fontSize)),
      },
    );
  }
}
