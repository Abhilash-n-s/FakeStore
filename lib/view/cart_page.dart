import 'package:fake_store/view_model/cart_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../widgets/product_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartVM = Get.put(CartPageViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Obx(() => Text(
              "Total Price: \$${cartVM.totalPrice.value.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20),
            )),
            Expanded(
              child: Obx(
                    () => cartVM.cartItems.isNotEmpty?GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cartVM.cartItems.length,
                  itemBuilder: (context, index) {
                    var pObj = cartVM.cartItems[index];
                    return ProductWidget(
                      pObj: pObj,
                      onPressed: ()  {
                        GoRouter.of(context).push('/product/${pObj.id}');
                      },
                      onCart: () {
                        cartVM.addToCart(pObj);
                      },
                      onDelete: (){
                        cartVM.removeFromCart(pObj);
                      },
                      onFav: (){

                      },
                      isCart: true,
                    );
                  },
                ):const Center(
                      child: Text(
                        'No items in cart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CartPageViewModel>();
    super.dispose();
  }
}
