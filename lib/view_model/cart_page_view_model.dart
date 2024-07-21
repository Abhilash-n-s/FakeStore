import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/product_model.dart';

class CartPageViewModel extends GetxController {
  var cartItems = <Product>[].obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    calculateTotalPrice();
  }

  void loadCart() {
    final box = Hive.box<Product>('cartBox');
    cartItems.value = box.values.toList();
  }

  void addToCart(Product product) async {
    final box = await Hive.openBox<Product>('cartBox');

    final existingProduct = box.values.firstWhere(
          (item) => item.id == product.id,
      orElse: () => Product(
        id: -1,
        title: '',
        price: 0.0,
        description: '',
        category: '',
        image: '',
        rating: Rating(rate: 0.0, count: 0),
        quantity: 0,
      ),
    );

    if (existingProduct.id == product.id) {
      final index = box.values.toList().indexOf(existingProduct);
      final updatedProduct = existingProduct.copyWith(
        quantity: existingProduct.quantity! + 1,
      );
      await box.putAt(index, updatedProduct);
    } else {
      final newProduct = product.copyWith(quantity: 1);
      await box.add(newProduct);
    }
    loadCart();
    calculateTotalPrice();
  }


  void removeFromCart(Product product) async {
    final box = await Hive.openBox<Product>('cartBox');

    final index = box.values.toList().indexWhere((item) => item.id == product.id);

    if (index != -1) {
      final existingProduct = box.getAt(index)!;

      if (existingProduct.quantity! > 1) {
        final updatedProduct = existingProduct.copyWith(quantity: existingProduct.quantity! - 1);
        await box.putAt(index, updatedProduct);
      } else {
        await box.deleteAt(index);
      }
      refreshCart();
      calculateTotalPrice();
    }
  }

  void refreshCart() async {
    final box = await Hive.openBox<Product>('cartBox');
    cartItems.value = box.values.toList();
  }

  void saveCart() {
    final box = Hive.box<Product>('cartBox');
    box.clear();
    box.addAll(cartItems);
  }

  void calculateTotalPrice() async {
    final box = await Hive.openBox<Product>('cartBox');
    double total = 0.0;

    for (var product in box.values) {
      total += product.price * product.quantity!;
    }

    totalPrice.value = total;
  }
}