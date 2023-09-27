import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final Color? color;
  double size;
  TextOverflow textOverflow;

  BigText({
    Key? key,
    required this.text,
    this.color=const Color(0xff332d2b),
    this.size=0,
    this.textOverflow=TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontSize: size==0 ? Dimensions.font20 : size,
        overflow: textOverflow,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
