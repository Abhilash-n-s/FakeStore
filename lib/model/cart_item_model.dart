import 'package:hive/hive.dart';

part 'cart_item_model.g.dart'; // This will be generated by build_runner

@HiveType(typeId: 2)
class CartItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
  });

  void increment() => quantity++;
  void decrement() {
    if (quantity > 1) quantity--;
  }
}