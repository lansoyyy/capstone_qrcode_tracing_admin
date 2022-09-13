import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  String text = '';
  double fontSize = 0;
  late final Color color;
  late final FontWeight fontWeight;

  TextWidget({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          fontFamily: 'QRegular'),
    );
  }
}
