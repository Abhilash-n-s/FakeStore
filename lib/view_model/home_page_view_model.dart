import 'dart:convert';

import 'package:fake_store/common/utils.dart';
import 'package:fake_store/model/product_model.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class HomePageViewModel extends GetxController{
  var productsList=<Product>[].obs;
  var filteredProductsList = <Product>[].obs;
  late Box<Product> productsBox;

  @override
  void onInit() {
    super.onInit();
    productsBox = Hive.box<Product>('productsBox');
    getProductsList();
  }

  void getProductsList() async {
    Utils.showLoader();
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      Utils.hideLoader();
      List<dynamic> jsonResponse = jsonDecode(response.body);
      productsList.value= jsonResponse.map((product) => Product.fromJson(product)).toList();
      saveProductsToHive(productsList);
      filteredProductsList.value = productsList;
    } else {
      Utils.hideLoader();
      throw Exception('Failed to load products');
    }
  }

  void saveProductsToHive(List<Product> products) {
    for (var product in products) {
      productsBox.put(product.id, product);
    }
  }

  List<Product> getProductsFromHive() {
    return productsBox.values.toList();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProductsList.value = productsList;
    } else {
      filteredProductsList.value = productsList
          .where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

