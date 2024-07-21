import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../common/color_extension.dart';

class ProductWidget extends StatelessWidget {
  final Product pObj;
  final VoidCallback onPressed;
  final VoidCallback onCart;
  final VoidCallback onDelete;
  final VoidCallback onFav;
  final bool isCart;
  final double margin;
  final double weight;
  const ProductWidget({super.key, required this.pObj, required this.onPressed, required this.onCart, this.weight = 180,
    this.margin = 1, required this.isCart, required this.onDelete, required this.onFav});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: KColor.placeholder.withOpacity(0.5), // Border color
            width: 1, // Border width
          ),
          borderRadius: BorderRadius.circular(15),),
        child: Column(

          children: [
            Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: pObj.image,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: MediaQuery.sizeOf(context).width,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    left: -10,
                    top: -10,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, color: KColor.primary),
                      onPressed: onFav,
                    ),
                  ),
                  // Image

                  // Delete Icon
                  isCart?
                  Positioned(
                    right: -15,
                    top: -10,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ):SizedBox(),
                ],
            ),
            const Spacer(),
            Text(
              pObj.title ?? "",
              style: TextStyle(
                  color: KColor.primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 2,
            ),
            if ((pObj.rating?.rate ?? 0.0) > 0.0)
              IgnorePointer(
                ignoring: true,
                child: RatingBar.builder(
                    initialRating: pObj.rating?.rate ?? 0.0,
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
                    onRatingUpdate: (rate) {}),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${pObj.price}",
                  style: TextStyle(
                      color: KColor.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: onCart,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: KColor.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: isCart && pObj.quantity!=null && pObj.quantity!>0 ? Text("Qty: ${pObj.quantity}") :Image.asset(
                      "assets/images/add.png",
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
