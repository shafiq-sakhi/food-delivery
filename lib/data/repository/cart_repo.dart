import 'dart:convert';
import 'package:e_commerce/models/cart_model.dart';
import 'package:e_commerce/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
 final SharedPreferences sharedPreferences;


 CartRepo({required this.sharedPreferences});

 List<String> cart = [];
 List<String> cartHistoryList = [];

 void addToCartList(List<CartModel> cartList){
   cart=[];
   /*
   covert object to string because sharedPreferences only accept string
   */
   var time = DateTime.now();
   cartList.forEach((element) {
    element.time = time.toString();
    return cart.add(jsonEncode(element));
   });

   sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
   // print(sharedPreferences.getStringList(AppConstants.CART_LIST));
   getCartList();
 }

 List<CartModel> getCartList(){
   List<String> carts = [];

   if(sharedPreferences.containsKey(AppConstants.CART_LIST)){
     carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
   }

   List<CartModel> cartList = [];

   carts.forEach((element) {
     cartList.add(CartModel.fromJson(jsonDecode(element)));
   });

   return cartList;
 }

 List<CartModel> getCartHistoryList(){
   if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
     cartHistoryList = [];
     cartHistoryList = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
   }

   List<CartModel> cartHistory = [];

   cartHistoryList.forEach((element) => cartHistory.add(CartModel.fromJson(jsonDecode(element))));

   return cartHistory;
 }

 void addToCardHistory(){
   if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
     cartHistoryList = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
     print(cartHistoryList);
   }
   cart.forEach((e)=> cartHistoryList.add(e));
   removeCart();
   sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistoryList);
 }

 void removeCart(){
   cart = [];
   sharedPreferences.remove(AppConstants.CART_LIST);
 }

}