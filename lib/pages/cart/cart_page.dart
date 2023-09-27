import 'package:e_commerce/base/no_data_page.dart';
import 'package:e_commerce/components/app_icon.dart';
import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/small_text.dart';
import 'package:e_commerce/controllers/cart_contorller.dart';
import 'package:e_commerce/controllers/popular_product_controller.dart';
import 'package:e_commerce/controllers/recommended_product_controller.dart';
import 'package:e_commerce/routes/route_helper.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //header
          Positioned(
            top: Dimensions.height20*3,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                    icon: Icons.arrow_back_ios,
                  backgroundColor: kMainColor,
                  iconColor: Colors.white,
                  iconSize: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width20*5,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    backgroundColor: kMainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                AppIcon(
                  icon: Icons.shopping_cart,
                  backgroundColor: kMainColor,
                  iconColor: Colors.white,
                  iconSize: Dimensions.iconSize24,
                )
              ],
            )
          ),
          //body
          GetBuilder<CartController>(builder: (_controller){
            return _controller.getItems.length > 0 ? Positioned(
              top: Dimensions.height20*5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height20),
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GetBuilder<CartController>(builder: (controller){
                      var _cartList=controller.getItems;
                      return ListView.builder(
                          itemCount: _cartList.length,
                          itemBuilder: (_,index){
                            return Container(
                              height: Dimensions.height20*5,
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      var popularIndex=Get.find<PopularProductController>()
                                          .popularProductList.indexOf(_cartList[index].product);

                                      if(popularIndex>=0){
                                        Get.toNamed(RouteHelper.getPopularFood(popularIndex,'cartPage'));
                                      }else{
                                        var recommendedIndex=Get.find<RecommendedProductController>()
                                            .recommendedProductList.indexOf(_cartList[index].product);
                                        if(recommendedIndex<0){
                                          Get.snackbar('History product',"Product review is not available",
                                              backgroundColor: kMainColor,
                                              colorText: Colors.white);
                                        }else{
                                          Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex,'cartPage'));
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: Dimensions.height20*5,
                                      width: Dimensions.height20*5,
                                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  AppConstants.BASE_URL+AppConstants.UPLOAD_URL+controller.getItems[index].img!
                                              ),
                                              fit: BoxFit.cover
                                          ),
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10,),
                                  Expanded(
                                      child: Container(
                                        height: Dimensions.radius20*5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BigText(text: controller.getItems[index].name!, color: Colors.black54,),
                                            SmallText(text: 'spicy'),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BigText(text: controller.getItems[index].price.toString(), color: Colors.redAccent,),
                                                Container(
                                                  padding: EdgeInsets.only(left: Dimensions.width10,top: Dimensions.height10/1.3,right: Dimensions.width10,bottom: Dimensions.height10/1.3),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                      color: Colors.white
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                          onTap:(){
                                                            controller.addItem(_cartList[index].product!, -1);
                                                          },
                                                          child: Icon(Icons.remove, color: kSignColor,
                                                          )
                                                      ),
                                                      SizedBox(width: Dimensions.width10/2,),
                                                      BigText(text: _cartList[index].quantity.toString()),//popularProduct.inCartItem.toString()),
                                                      SizedBox(width: Dimensions.width10/2,),
                                                      GestureDetector(
                                                          onTap: (){
                                                            controller.addItem(_cartList[index].product!, 1);
                                                          },
                                                          child: Icon(Icons.add, color: kSignColor)
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            );
                          }
                      );
                    })
                ),
              ),
            ) : NoDataPage(text: 'Your cart is empty!');
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(builder: (cartController){
          return Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(bottom: Dimensions.height30,top: Dimensions.height30,left: Dimensions.height20,right: Dimensions.height20),
            decoration: BoxDecoration(
                color: kButtonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20*2),
                  topRight: Radius.circular(Dimensions.radius20*2),
                )
            ),
            child: cartController.getItems.length > 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //plus and minus
                Container(
                  padding: EdgeInsets.only(left: Dimensions.width20,top: Dimensions.height20/1.3,right: Dimensions.width20,bottom: Dimensions.height20/1.3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.width10/2,),
                      BigText(text: '\$ '+cartController.totalAmount.toString()),
                      SizedBox(width: Dimensions.width10/2,),
                    ],
                  ),
                ),
                //add button
                GestureDetector(
                  onTap: (){
                    cartController.addToHistory();
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: Dimensions.height20,top: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
                    child: BigText(text: 'Checkout', color: Colors.white,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: kMainColor
                    ),
                  ),
                )
              ],
            ) : SizedBox.shrink(),
          );
        },)
    );
  }
}
