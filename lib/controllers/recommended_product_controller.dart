import 'package:e_commerce/data/repository/recommended_product_repo.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController{
  final RecommendedProductRepo recommendedProductRepo;

  RecommendedProductController({required this.recommendedProductRepo});
  List<dynamic> _recommendedProductList=[];
  List<dynamic>  get recommendedProductList=> _recommendedProductList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getRecommendedProductList()async{
    Response response= await recommendedProductRepo.getRecommendedProductList();
    if(response.statusCode==200){
      print('got product');
      _recommendedProductList=[];
      _recommendedProductList.addAll(Product.fromJson(response.body).products);
      _isLoaded=true;
      update();
    }else{
      print('got');
    }
  }
}