import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  int _queueCounter = 12;
  OrderModel? _activeOrder;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  OrderModel? get activeOrder => _activeOrder;

  OrderProvider() {
    _loadInitialDummyOrders();
  }

  void _loadInitialDummyOrders() {
    final sampleItem1 = MenuItemModel(
      id: 'k1',
      name: 'Kopi Susu Aren Heritage',
      description: 'Espresso robusta pilihan dipadu dengan susu segar.',
      price: 22000,
      category: 'Kopi',
      rating: 4.9,
      image: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800&auto=format&fit=crop',
      moodTags: ['energi', 'manis'],
    );
    final sampleItem2 = MenuItemModel(
      id: 'c2',
      name: 'Croissant Butter Melt',
      description: 'Pastry khas Perancis berlapis renyah luar.',
      price: 23000,
      category: 'Camilan',
      rating: 4.8,
      image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=800&auto=format&fit=crop',
      moodTags: ['santai', 'manis'],
    );

    final pastOrder = OrderModel(
      id: 'ORD-20260915-001',
      queueNumber: 'A-010',
      items: [
        CartItemModel(item: sampleItem1, quantity: 2, size: 'Large', toppings: ['Extra Shot']),
        CartItemModel(item: sampleItem2, quantity: 1),
      ],
      subtotal: 73000,
      taxAndService: 9300,
      total: 82300,
      orderType: 'Makan di Tempat',
      tableNumber: '04',
      paymentMethod: 'QRIS',
      status: OrderStatusStep.selesai,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    );

    _orders.add(pastOrder);
  }

  OrderModel createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double taxAndService,
    required double total,
    required String orderType,
    String? tableNumber,
    required String paymentMethod,
  }) {
    _queueCounter++;
    final formattedQueue = 'A-${_queueCounter.toString().padLeft(3, '0')}';
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final newOrder = OrderModel(
      id: orderId,
      queueNumber: formattedQueue,
      items: items.map((e) => e.copyWith()).toList(),
      subtotal: subtotal,
      taxAndService: taxAndService,
      total: total,
      orderType: orderType,
      tableNumber: tableNumber,
      paymentMethod: paymentMethod,
      status: OrderStatusStep.diterima,
      createdAt: DateTime.now(),
      estimatedMinutes: 15,
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;
    notifyListeners();
    return newOrder;
  }

  void setActiveOrder(OrderModel order) {
    _activeOrder = order;
    notifyListeners();
  }

  // Admin or simulation status advance
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final currentStatus = _orders[index].status;
      if (currentStatus != OrderStatusStep.selesai) {
        final nextStatusIndex = currentStatus.index + 1;
        _orders[index].status = OrderStatusStep.values[nextStatusIndex];
        
        if (_activeOrder?.id == orderId) {
          _activeOrder = _orders[index];
        }
        notifyListeners();
      }
    }
  }

  // Live simulation: advance status every 8 seconds for demo
  void simulateOrderProgress(String orderId) {
    Timer.periodic(const Duration(seconds: 8), (timer) {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index == -1 || _orders[index].status == OrderStatusStep.selesai) {
        timer.cancel();
      } else {
        advanceOrderStatus(orderId);
      }
    });
  }

  // Get active queue length
  int get activeQueueCount {
    return _orders.where((o) => o.status != OrderStatusStep.selesai).length;
  }

  double get totalRevenue {
    double sum = 0;
    for (var o in _orders) {
      sum += o.total;
    }
    return sum;
  }
}
