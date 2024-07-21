import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store/view_model/cart_page_view_model.dart';
import 'package:fake_store/view_model/product_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../common/color_extension.dart';

class ProductDetailsPage extends StatefulWidget {
  final int pId;
  const ProductDetailsPage({super.key, required this.pId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>{
  late ProductDetailsViewModel detailsVM ;
  late CartPageViewModel cartVM;

  @override
  void initState() {
    super.initState();
    detailsVM = Get.put(ProductDetailsViewModel(widget.pId));
    cartVM = Get.put(CartPageViewModel());
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Obx(()=>Container(
                  width: double.maxFinite,
                  height: media.width * 0.8,
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F3F2),
                      borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: detailsVM.pObj.value.image ?? "",
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    width: media.width * 0.8,
                  ),
                ))
                ,
                SafeArea(
                  child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          icon: Image.asset(
                            "assets/images/back.png",
                            width: 20,
                            height: 20,
                          )),
                      actions: [
                        IconButton(
                            onPressed: () {

                            },
                            icon: Image.asset(
                              "assets/images/share.png",
                              width: 20,
                              height: 20,
                            )),
                      ]),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(()=>Row(
                    children: [
                      Expanded(
                        child: Text(
                          detailsVM.pObj.value.title ?? "",
                          style: TextStyle(
                              color: KColor.primaryText,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                        color: KColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Obx(
                        () => Text(
                      detailsVM.pObj.value.description??"",
                      style: TextStyle(
                          color: KColor.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    final rating = detailsVM.pObj.value.rating?.rate ?? 0.0;

                    return rating > 0.0
                        ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Review",
                            style: TextStyle(
                              color: KColor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating); // Handle rating update if needed
                            },
                          ),
                        ),
                      ],
                    )
                        : SizedBox.shrink(); // Return an empty widget if rating is 0
                  }),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Price",
                    style: TextStyle(
                        color: KColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Obx(
                        () => Text(
                      detailsVM.pObj.value.price!=null?"\$${detailsVM.pObj.value.price}":"",
                      style: TextStyle(
                          color: KColor.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),

                  ElevatedButton(
                    child: Text("Add to Cart"),
                    onPressed: () {
                      cartVM.addToCart(detailsVM.pObj.value);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<ProductDetailsViewModel>();
    super.dispose();
  }
}
