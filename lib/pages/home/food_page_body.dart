import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce/components/app_column.dart';
import 'package:e_commerce/components/big_text.dart';
import 'package:e_commerce/components/icon_and_text_widgets.dart';
import 'package:e_commerce/components/small_text.dart';
import 'package:e_commerce/controllers/popular_product_controller.dart';
import 'package:e_commerce/controllers/recommended_product_controller.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:e_commerce/routes/route_helper.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:e_commerce/utilities/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController=PageController(viewportFraction: 0.85);
  var currentPageValue=0.0;
  double scaleFactor=0.8;
  var heigth=Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue=pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //slider section
        GetBuilder<PopularProductController>(builder: (popularProductController){
          return popularProductController.isLoaded?Container(
            height: Dimensions.pageView,
            child: PageView.builder(
                controller: pageController,
                itemCount: popularProductController.popularProductList.length,
                itemBuilder: (context, position) {
                  return _buildPageItem(position, popularProductController.popularProductList[position]);
                }),
          ):CircularProgressIndicator(
            color: kMainColor,
          );
        }),
        //dots
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return DotsIndicator(
            dotsCount:popularProducts.popularProductList.isEmpty?1:popularProducts.popularProductList.length,
            position: currentPageValue,
            decorator: DotsDecorator(
                activeColor: kMainColor,
                size: Size.square(9.0),
                activeSize: Size(18.0,9.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
            ),
          );
        }),
        //popular text
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: 'Recommended'),
              SizedBox(width: Dimensions.width10,),
              Container(
                //margin: EdgeInsets.only(bottom: 3),
                child: BigText(text: '.', color: Colors.black26,),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                //margin: EdgeInsets.only(bottom: 2),
                child: SmallText(text: 'food pairing'),
              )
            ],
          ),
        ),
        //list of foods and images
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct){
          return recommendedProduct.isLoaded?ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recommendedProduct.recommendedProductList.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Get.toNamed(RouteHelper.getRecommendedFood(index,'home'));
                },
                child: Container(
                  margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20, bottom: Dimensions.height10),
                  child: Row(
                    children: [
                      //image section
                      Container(
                        width: Dimensions.listViewImgSize,
                        height: Dimensions.listViewImgSize,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white38,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+recommendedProduct.recommendedProductList[index].img!
                                )
                            )
                        ),
                      ),

                      //text container
                      Expanded(
                        child: Container(
                          height: Dimensions.listViewTextContSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight: Radius.circular(Dimensions.radius20)
                              ),
                              color: Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(text: recommendedProduct.recommendedProductList[index].name!),
                                SizedBox(height: Dimensions.height10,),
                                SmallText(text: 'With Chinese characteristics'),
                                SizedBox(height: Dimensions.height10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconAndTextWidget(icon: Icons.circle_sharp, text: 'Normal', iconColor: kIconColor1),
                                    IconAndTextWidget(icon: Icons.location_on, text: '1.7km', iconColor: kMainColor),
                                    IconAndTextWidget(icon: Icons.access_time_rounded, text: '32min', iconColor: kIconColor2),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ):CircularProgressIndicator(
            color: kMainColor,
          );
        })
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct){
    Matrix4 matrix = new Matrix4.identity();
    if(index == currentPageValue.floor()){
      var currScale = 1-(currentPageValue-index)*(1-scaleFactor);
      var currentTrans = heigth*(1-currScale)/2;
      matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currentTrans, 0);
    }else if(index == currentPageValue.floor()+1){
      var currScale = scaleFactor+(currentPageValue-index+1)*(1-scaleFactor);
      var currentTrans = heigth*(1-currScale)/2;
      matrix=Matrix4.diagonal3Values(1, currScale, 1);
      matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currentTrans, 0);
    }else{
      var currScale= 0.8;
      matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, heigth*(1-currScale)/2, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              Get.toNamed(RouteHelper.getPopularFood(index,'home'));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+popularProduct.img!
                  )
                )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0,5)
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5,0)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(5,0)
                    )
                  ]
              ),
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height15,left: Dimensions.width15, right: Dimensions.width15),
                child: AppColumn(text: popularProduct.name!,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
