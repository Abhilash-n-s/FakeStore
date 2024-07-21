import 'dart:convert';

import 'package:fake_store/model/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common/utils.dart';

class ProductDetailsViewModel extends GetxController{
  final int pId;
  var pObj = Product(
    id: 0,
    title: '',
    price: 0.0,
    description: '',
    category: '',
    image: '',
    rating: Rating(rate: 0.0, count: 0),
  ).obs;

  ProductDetailsViewModel(this.pId){

  }

  @override
  void onInit() {
    super.onInit();

    getProductsDetails(pId);

  }

  void getProductsDetails(int productId) async {
    Utils.showLoader();
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));

    if (response.statusCode == 200) {
      Utils.hideLoader();
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      pObj.value= Product.fromJson(jsonResponse);
    } else {
      Utils.hideLoader();
      throw Exception('Failed to load product');
    }
  }
}