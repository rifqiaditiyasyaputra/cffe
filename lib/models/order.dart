import 'cart_item.dart';

enum OrderStatusStep {
  diterima,
  diproses,
  disiapkan,
  siap,
  selesai,
}

extension OrderStatusStepExtension on OrderStatusStep {
  String get title {
    switch (this) {
      case OrderStatusStep.diterima:
        return 'Pesanan Diterima';
      case OrderStatusStep.diproses:
        return 'Sedang Diproses';
      case OrderStatusStep.disiapkan:
        return 'Sedang Disiapkan';
      case OrderStatusStep.siap:
        return 'Siap Diambil / Diantar';
      case OrderStatusStep.selesai:
        return 'Pesanan Selesai';
    }
  }

  String get description {
    switch (this) {
      case OrderStatusStep.diterima:
        return 'Pesanan Anda telah diterima oleh kasir KopiKita.';
      case OrderStatusStep.diproses:
        return 'Barista sedang menyiapkan pesanan makanan & minuman Anda.';
      case OrderStatusStep.disiapkan:
        return 'Pesanan sedang dikemas atau ditata di nampan.';
      case OrderStatusStep.siap:
        return 'Pesanan Anda sudah siap! Silakan ambil atau tunggu di meja.';
      case OrderStatusStep.selesai:
        return 'Pesanan selesai. Terima kasih telah menikmati KopiKita!';
    }
  }
}

class OrderModel {
  final String id;
  final String queueNumber;
  final List<CartItemModel> items;
  final double subtotal;
  final double taxAndService;
  final double total;
  final String orderType; // 'Makan di Tempat' or 'Bawa Pulang'
  final String? tableNumber;
  final String paymentMethod;
  OrderStatusStep status;
  final DateTime createdAt;
  int estimatedMinutes;

  OrderModel({
    required this.id,
    required this.queueNumber,
    required this.items,
    required this.subtotal,
    required this.taxAndService,
    required this.total,
    required this.orderType,
    this.tableNumber,
    required this.paymentMethod,
    this.status = OrderStatusStep.diterima,
    required this.createdAt,
    this.estimatedMinutes = 15,
  });

  OrderModel copyWith({
    String? id,
    String? queueNumber,
    List<CartItemModel>? items,
    double? subtotal,
    double? taxAndService,
    double? total,
    String? orderType,
    String? tableNumber,
    String? paymentMethod,
    OrderStatusStep? status,
    DateTime? createdAt,
    int? estimatedMinutes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      queueNumber: queueNumber ?? this.queueNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAndService: taxAndService ?? this.taxAndService,
      total: total ?? this.total,
      orderType: orderType ?? this.orderType,
      tableNumber: tableNumber ?? this.tableNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }
}
