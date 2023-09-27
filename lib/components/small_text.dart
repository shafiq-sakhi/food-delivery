import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color? color;
  double size;
  double height;

  SmallText({
    Key? key,
    required this.text,
    this.color=const Color(0xffccc7c5),
    this.size = 0,
    this.height=1.2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size == 0 ? Dimensions.font16-2 : size,
          height: height,
          fontWeight: FontWeight.w600
      ),
    );
  }
}
