import 'menu_item.dart';

class CartItemModel {
  final MenuItemModel item;
  int quantity;
  String size; // 'Reguler' or 'Large'
  List<String> toppings;
  String notes;

  CartItemModel({
    required this.item,
    this.quantity = 1,
    this.size = 'Reguler',
    List<String>? toppings,
    this.notes = '',
  }) : toppings = toppings ?? [];

  double get extraPrice {
    double extra = 0.0;
    if (size == 'Large') extra += 5000.0;
    extra += toppings.length * 4000.0;
    return extra;
  }

  double get unitPrice => item.price + extraPrice;

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    MenuItemModel? item,
    int? quantity,
    String? size,
    List<String>? toppings,
    String? notes,
  }) {
    return CartItemModel(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      toppings: toppings ?? List.from(this.toppings),
      notes: notes ?? this.notes,
    );
  }
}
