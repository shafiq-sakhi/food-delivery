import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/icon_and_text_widgets.dart';
import 'package:e_commerce/components/small_text.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({Key? key, required this.text}) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: Dimensions.font20,),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) => Icon(Icons.star, color: kMainColor,size: 15)),
            ),
            SizedBox(width: 10,),
            SmallText(text: '4.5'),
            SizedBox(width: 10,),
            SmallText(text: '1287',),
            SizedBox(width: 10,),
            SmallText(text: 'Comments')
          ],
        ),
        SizedBox(height: Dimensions.height20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(icon: Icons.circle_sharp, text: 'Normal', iconColor: kIconColor1),
            IconAndTextWidget(icon: Icons.location_on, text: '1.7km', iconColor: kMainColor),
            IconAndTextWidget(icon: Icons.access_time_rounded, text: '32min', iconColor: kIconColor2),
          ],
        )
      ],
    );
  }
}
