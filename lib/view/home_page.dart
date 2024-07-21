import 'package:fake_store/view_model/cart_page_view_model.dart';
import 'package:fake_store/view_model/home_page_view_model.dart';
import 'package:fake_store/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../common/color_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtSearch = TextEditingController();
  final homeVM = Get.put(HomePageViewModel());
  final cartVM = Get.put(CartPageViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F3F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: txtSearch,
                  onChanged: (query) {
                    homeVM.searchProducts(query);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Icon(Icons.search, size: 20),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(
                      color: KColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Removed the SingleChildScrollView
            Expanded(
              child: Obx(
                    () => GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: homeVM.filteredProductsList.length,
                  itemBuilder: (context, index) {
                    var pObj = homeVM.filteredProductsList[index];
                    return ProductWidget(
                      pObj: pObj,
                      onPressed: ()  {
                        GoRouter.of(context).push('/product/${pObj.id}');
                      },
                      onCart: () {
                        cartVM.addToCart(pObj);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                      },
                      onFav: (){

                      },
                      onDelete: (){
                        cartVM.removeFromCart(pObj);
                      },
                      isCart: false,
                    );
                  },
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
    Get.delete<HomePageViewModel>();
    super.dispose();
  }
}
