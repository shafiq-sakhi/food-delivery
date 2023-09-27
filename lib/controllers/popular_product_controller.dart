import 'package:e_commerce/data/repository/popular_product_repo.dart';
import 'package:e_commerce/models/cart_model.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_contorller.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo;

  PopularProductController({required this.popularProductRepo});
  List<dynamic> _popularProductList=[];
  List<dynamic>  get popularProductList=> _popularProductList;
  late CartController _cart;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getPopularProductList()async{
    Response response= await popularProductRepo.getPopularProductList();
    if(response.statusCode==200){

      _popularProductList=[];
      _popularProductList.addAll(Product.fromJson(response.body).products);
      _isLoaded=true;
      update();
    }else{
    }
  }

  int _quantity=0;
  int get quantity=> _quantity;
  int _inCartItem=0;
  int get inCartItem=>_inCartItem+_quantity;

  void setQuantity(bool isIncrement){
    if(isIncrement){
      _quantity=checkQuantity(_quantity+1);
    }else{
      _quantity=checkQuantity(_quantity-1);
    }
    update();
  }
  
  int checkQuantity(int quantity){
    print(_inCartItem+_quantity);
    if((_inCartItem+_quantity)<0){
      Get.snackbar('Item count',"You can't reduce more !",
      backgroundColor: kMainColor,
      colorText: Colors.white
      );
      if(_inCartItem>0){
        _quantity= -_inCartItem;
        return _quantity;
      }
      return 0;
    }else if((_inCartItem+_quantity)>20){
      Get.snackbar('Item count',"You can't add more !",
          backgroundColor: kMainColor,
          colorText: Colors.white
      );
      return 20;
    }else{
      return quantity;
    }
  }

  void initProduct(ProductModel product,CartController cart){
    _quantity=0;
    _inCartItem=0;
    _cart=cart;
    var exist=false;
    exist = _cart.existInCart(product);

    if(exist){
      _inCartItem=_cart.getQuantity(product);
    }
    //get from storage
  }

  void addItem(ProductModel product) {
    _cart.addItem(product, _quantity);

    _quantity=0;
    _inCartItem = _cart.getQuantity(product);
    _cart.items.forEach((key, value) {
      print(
          'The product id $key and the value is ' + value.quantity.toString());
    });

    update();
  }

  int get totalItems{
    return _cart.totalItems;
  }

  List<CartModel> get getItems{
    return _cart.getItems;
  }

}
