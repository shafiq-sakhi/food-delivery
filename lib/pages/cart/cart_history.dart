import 'dart:convert';
import 'package:e_commerce/base/no_data_page.dart';
import 'package:e_commerce/components/app_icon.dart';
import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/small_text.dart';
import 'package:e_commerce/controllers/cart_contorller.dart';
import 'package:e_commerce/models/cart_model.dart';
import 'package:e_commerce/routes/route_helper.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  CartHistory({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = Map();

    for (var e in getCartHistoryList) {
      if(cartItemsPerOrder.containsKey(e.time)){
        cartItemsPerOrder.update(e.time!, (v) => ++v);
      }else{
        cartItemsPerOrder.putIfAbsent(e.time!, () => 1);
      }
    }

    List<int> cartItemsPerOrderToList(){
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList(){
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> itemPerOrder = cartItemsPerOrderToList();

    int listCounter = 0;

    Widget timeWidget(int index){
      var outputDate = DateTime.now().toString();
      if(index<getCartHistoryList.length){
        DateTime parseDate = DateFormat('yyyy-mm-dd hh:mm:ss').parse(getCartHistoryList[index].time!);
        var outputFormat = DateFormat('yyyy/mm/dd hh:mm a');
        outputDate = outputFormat.format(parseDate);
      }
      return BigText(text: outputDate);
    }

    return Scaffold(
      body: Column(
        children: [
          //app bar
          Container(
             height: Dimensions.height45+55,
             color: kMainColor,
             width: double.maxFinite,
             padding: EdgeInsets.only(top: Dimensions.height45),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 BigText(text: 'Cart History',color: Colors.white,),
                 AppIcon(icon: Icons.shopping_cart_outlined,iconColor: kMainColor ,)
               ],
             ),
           ),
          //body
          GetBuilder<CartController>(builder: (_controller){
            return  _controller.getCartHistoryList().length > 0 ?
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height20-10,
                    left: Dimensions.height20,
                    right: Dimensions.height20
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    for(int i = 0; i < itemPerOrder.length; i++)
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            timeWidget(listCounter),
                            SizedBox(height: Dimensions.height10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                    children: List.generate(itemPerOrder[i], (index) {
                                      if(listCounter<getCartHistoryList.length){
                                        listCounter++;
                                      }
                                      return index <= 2 ? Container(
                                        height: Dimensions.height30*3.5,
                                        width: Dimensions.height30*3.5,
                                        margin: EdgeInsets.only(right: Dimensions.width10/2),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+getCartHistoryList[listCounter-1].img!
                                                )
                                            )
                                        ),
                                      ) : SizedBox.shrink();
                                    })
                                ),
                                Container(
                                  height: Dimensions.height45*2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SmallText(text: 'Total',color: kTitleColor,),
                                      BigText(text: itemPerOrder[i].toString()+' Items',color: kTitleColor,),
                                      GestureDetector(
                                        onTap: (){
                                          var orderTime = cartOrderTimeToList();
                                          Map<int, CartModel> moreOrder = {};
                                          getCartHistoryList.forEach((element) {
                                            if(element.time == orderTime[i]){
                                              moreOrder.putIfAbsent(element.id!, ()=>
                                                  CartModel.fromJson(jsonDecode(jsonEncode(element)))
                                              );
                                            }
                                          });
                                          Get.find<CartController>().setItems = moreOrder;
                                          Get.find<CartController>().addToCartList();
                                          Get.toNamed(RouteHelper.getCartPage());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,vertical: Dimensions.width10/2),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: kMainColor,width: 1),
                                              borderRadius: BorderRadius.circular(Dimensions.radius15/3)
                                          ),
                                          child: SmallText(text: 'one more',color: kMainColor,),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ) : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoDataPage(text: 'You didn\'t buy anything so far !',
                  imgPath: 'assets/image/empty_box.png',
                  ),
                ],
              ),
            );
          },)
        ],
      ),
    );
  }
}
