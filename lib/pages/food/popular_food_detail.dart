import 'package:e_commerce/components/app_column.dart';
import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/app_icon.dart';
import 'package:e_commerce/components/expandable_text_widget.dart';
import 'package:e_commerce/controllers/cart_contorller.dart';
import 'package:e_commerce/controllers/popular_product_controller.dart';
import 'package:e_commerce/pages/cart/cart_page.dart';
import 'package:e_commerce/routes/route_helper.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodDetail extends StatelessWidget{
  final int pageId;
  final String page;
  const PopularFoodDetail({required this.pageId, Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product=Get.find<PopularProductController>().popularProductList[pageId];
    Get.find<PopularProductController>().initProduct(product,Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //image section
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: Dimensions.popularFoodImgSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!
                    )
                  )
                ),
              )
          ),
          //icon widget
          Positioned(
              top: Dimensions.height45,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
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
                    child: AppIcon(icon: Icons.arrow_back_ios)
                  ),
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
              )
          ),
          //info 
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularFoodImgSize-20,
              child: Container(
                padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius20),
                    topLeft: Radius.circular(Dimensions.radius20)
                  ),
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(text: product.name!),
                    SizedBox(height: Dimensions.height20,),
                    BigText(text: 'Introduce'),
                    SizedBox(height: Dimensions.height20,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ExpandableTextWidget(text: product.description!)
                      ),
                    )  
                  ],
                )
              )
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProduct){
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
                child: Row(
                  children: [
                    GestureDetector(
                        onTap:(){
                          popularProduct.setQuantity(false);
                        },
                        child: Icon(Icons.remove, color: kSignColor,
                        )
                    ),
                    SizedBox(width: Dimensions.width10/2,),
                    BigText(text: popularProduct.inCartItem.toString()),
                    SizedBox(width: Dimensions.width10/2,),
                    GestureDetector(
                      onTap: (){
                        popularProduct.setQuantity(true);
                      },
                      child: Icon(Icons.add, color: kSignColor)
                    )
                  ],
                ),
              ),
              //add button
              GestureDetector(
                onTap: (){
                  popularProduct.addItem(product);
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: Dimensions.height20,top: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
                  child: BigText(text: '\$ ${product.price!} I add to cart', color: Colors.white,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: kMainColor
                  ),
                ),
              )
            ],
          ),
        );
      },)
    );
  }

}
