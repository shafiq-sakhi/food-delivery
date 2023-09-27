import 'package:e_commerce/data/repository/cart_repo.dart';
import 'package:e_commerce/models/cart_model.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:e_commerce/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  final CartRepo cartRepo;

  List<CartModel> storageItems = [];

  CartController({required this.cartRepo});
  Map<int,CartModel> _items={};

  Map<int,CartModel> get items{
    return _items;
  }

  void addItem(ProductModel productModel, int quantity){
    var totalQuantity=0;
    if(_items.containsKey(productModel.id)){
      _items.update(productModel.id!, (value) {
        totalQuantity= value.quantity!+quantity;
        return CartModel(
            id: value.id,
            name: value.name,
            price: value.price,
            img: value.img,
            quantity: value.quantity!+quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: productModel
        );
      });

      if(totalQuantity<=0){
        _items.remove(productModel.id);
      }
    }else{
      if(quantity>0){
        _items.putIfAbsent(productModel.id!, () {
          return CartModel(
              id: productModel.id,
              name: productModel.name,
              price: productModel.price,
              img: productModel.img,
              quantity: quantity,
              isExist: true,
              time: DateTime.now().toString(),
              product: productModel
          );
        });
      }else{
        Get.snackbar('Item count',"You should at least add an item in the cart !",
        backgroundColor: kMainColor,
        colorText: Colors.white);
      }
    }
    cartRepo.addToCartList(getItems);
    update();
  }

  bool existInCart(ProductModel product){
    if(_items.containsKey(product.id)){
      return true;
    }
    return false;
  }

  getQuantity(ProductModel product){
    var quantity=0;
    if(_items.containsKey(product.id)){
      _items.forEach((key, value) {
        if(key == product.id){
          quantity= value.quantity!;
        }
      });
    }
    return quantity;
  }

  int get totalItems{
    var totalQuantity=0;

    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getItems{
    return _items.entries.map((e){
      return e.value;
    }).toList();
  }

  int get totalAmount{
    var total=0;

    _items.forEach((key, value) {
      total += value.quantity!*value.price!;
    });
    return total;
  }

  List<CartModel> getCartData(){
    setStorageItems = cartRepo.getCartList();
    return storageItems;
  }

  set setStorageItems(List<CartModel> items){
    storageItems = items;

    storageItems.forEach((element) => _items.putIfAbsent(element.product!.id!, () => element));
  }

  void addToHistory(){
    cartRepo.addToCardHistory();
    clearCart();
  }

  void clearCart(){
    _items={};
    update();
  }

  List<CartModel> getCartHistoryList(){
    return cartRepo.getCartHistoryList();
  }

  set setItems(Map<int, CartModel> setItems){
    _items = {};
    _items = setItems;
  }

  void addToCartList(){
    cartRepo.addToCartList(getItems);
    update();
  }

}