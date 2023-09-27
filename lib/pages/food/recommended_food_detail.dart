import 'package:e_commerce/components/app_icon.dart';
import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/expandable_text_widget.dart';
import 'package:e_commerce/controllers/cart_contorller.dart';
import 'package:e_commerce/controllers/popular_product_controller.dart';
import 'package:e_commerce/controllers/recommended_product_controller.dart';
import 'package:e_commerce/pages/cart/cart_page.dart';
import 'package:e_commerce/routes/route_helper.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;
  const RecommendedFoodDetail({Key? key,required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product=Get.find<RecommendedProductController>().recommendedProductList[pageId];
    Get.find<PopularProductController>().initProduct(product,Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    if(page=='cartPage'){
                      Get.toNamed(RouteHelper.getCartPage());
                    }else{
                      Get.toNamed(RouteHelper.initial);
                    }
                  },
                  child: AppIcon(icon: Icons.clear)
                ),
                //AppIcon(icon: Icons.shopping_cart_outlined)
                GetBuilder<PopularProductController>(builder: (controller){
                  return GestureDetector(
                    onTap: (){
                      if(controller.totalItems>=1)
                        Get.toNamed(RouteHelper.getCartPage());
                    },
                    child: Stack(
                      children: [
                        AppIcon(icon: Icons.shopping_cart_outlined,),
                        controller.totalItems>=1 ?
                        Positioned(
                          top: 0, right: 0,
                          child: AppIcon(icon: Icons.circle , size: 20,
                            iconColor: Colors.transparent, backgroundColor: kMainColor,),
                        ):
                        Container(),
                        Get.find<PopularProductController>().totalItems>=1 ?
                        Positioned(
                            top:3, right: 3,
                            child: BigText(text: Get.find<PopularProductController>().totalItems.toString(),
                              size: 12, color: Colors.white,
                            )
                        ):
                        Container()
                      ],
                    ),
                  );
                })
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                child: Center(child: BigText(text: product.name!, size: Dimensions.font26,)),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20)
                  )
                ),
              ),
            ),
            pinned: true,
            backgroundColor: kYellowColor,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: ExpandableTextWidget(text: product.description!),
                  margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProduct){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //plus and minus
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20*2.5,
                  right: Dimensions.width20*2.5,
                  top: Dimensions.height10,
                  bottom: Dimensions.height10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      popularProduct.setQuantity(false);
                    },
                    child: AppIcon(
                      icon: Icons.remove,
                      backgroundColor: kMainColor,
                      iconColor: Colors.white,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  BigText(text: '\$ ${product.price!}  X  ${popularProduct.inCartItem} ',color: kMainBlackColor,size: Dimensions.font26,),
                  GestureDetector(
                    onTap: (){
                      popularProduct.setQuantity(true);
                    },
                    child: AppIcon(
                      icon: Icons.add,
                      backgroundColor: kMainColor,
                      iconColor: Colors.white,
                      iconSize: Dimensions.iconSize24,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: Dimensions.bottomHeightBar,
              padding: EdgeInsets.only(bottom: Dimensions.height30,top: Dimensions.height30,left: Dimensions.height20,right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: kButtonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20*2),
                    topRight: Radius.circular(Dimensions.radius20*2),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //plus and minus
                  Container(
                    padding: EdgeInsets.only(left: Dimensions.width20,top: Dimensions.height20/1.3,right: Dimensions.width20,bottom: Dimensions.height20/1.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white
                    ),
                    child: Icon(Icons.favorite,color: kMainColor),
                  ),
                  //add button
                  GestureDetector(
                    onTap: (){
                      popularProduct.addItem(product);
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: Dimensions.height20,top: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
                      child: BigText(text: '\$${product.price} I add to cart', color: Colors.white,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: kMainColor
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      })
    );
  }
}
