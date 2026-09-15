import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];
  String _orderNote = '';

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);
  String get orderNote => _orderNote;

  int get itemCount {
    int total = 0;
    for (var item in _cartItems) {
      total += item.quantity;
    }
    return total;
  }

  double get subtotal {
    double sum = 0.0;
    for (var item in _cartItems) {
      sum += item.totalPrice;
    }
    return sum;
  }

  double get taxAndService {
    if (subtotal == 0) return 0.0;
    return subtotal * 0.10 + 2000.0; // 10% tax + Rp 2.000 service fee
  }

  double get grandTotal {
    return subtotal + taxAndService;
  }

  void addToCart({
    required MenuItemModel item,
    int quantity = 1,
    String size = 'Reguler',
    List<String>? toppings,
    String notes = '',
  }) {
    if (!item.isAvailable) return;

    final toppingsList = toppings ?? [];
    toppingsList.sort();

    // Find existing item with same id, size, and toppings
    int index = _cartItems.indexWhere((c) =>
        c.item.id == item.id &&
        c.size == size &&
        c.toppings.join(',') == toppingsList.join(','));

    if (index != -1) {
      _cartItems[index].quantity += quantity;
      if (notes.isNotEmpty) {
        _cartItems[index].notes = notes;
      }
    } else {
      _cartItems.add(
        CartItemModel(
          item: item,
          quantity: quantity,
          size: size,
          toppings: toppingsList,
          notes: notes,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void setOrderNote(String note) {
    _orderNote = note;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _orderNote = '';
    notifyListeners();
  }
}
