import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import 'order_status_screen.dart';

class OrdersTab extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const OrdersTab({
    Key? key,
    required this.onNavigateToTab,
  }) : super(key: key);

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  String _filterStatus = 'Semua';

  final List<String> _statusFilters = ['Semua', 'Berlangsung', 'Selesai'];

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    List<OrderModel> filteredOrders = orderProvider.orders.where((o) {
      if (_filterStatus == 'Berlangsung') {
        return o.status != OrderStatusStep.selesai;
      } else if (_filterStatus == 'Selesai') {
        return o.status == OrderStatusStep.selesai;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Pesanan',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter Chips
                  Row(
                    children: _statusFilters.map((st) {
                      bool isSelected = _filterStatus == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            st,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.primaryCoffee,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryCoffee,
                          backgroundColor: Colors.white,
                          onSelected: (_) {
                            setState(() {
                              _filterStatus = st;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off, size: 64, color: AppTheme.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'Belum Ada Pesanan',
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Pesanan Anda akan muncul di sini.',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final orderItem = filteredOrders[index];
                        final bool isCompleted = orderItem.status == OrderStatusStep.selesai;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderStatusScreen(order: orderItem),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryCoffee.withOpacity(0.04),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryCoffee,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            orderItem.queueNumber,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('dd MMM yyyy, HH:mm').format(orderItem.createdAt),
                                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isCompleted ? AppTheme.accentGreen.withOpacity(0.15) : Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        orderItem.status.title,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isCompleted ? AppTheme.accentGreen : Colors.orange.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Text(
                                  '${orderItem.items.length} Menu: ${orderItem.items.map((i) => i.item.name).join(', ')}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatRupiah(orderItem.total),
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryCoffee),
                                    ),
                                    // Reorder button
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        for (var cartItem in orderItem.items) {
                                          cartProvider.addToCart(
                                            item: cartItem.item,
                                            quantity: cartItem.quantity,
                                            size: cartItem.size,
                                            toppings: cartItem.toppings,
                                            notes: cartItem.notes,
                                          );
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Menu ditambahkan ke keranjang!')),
                                        );
                                      },
                                      icon: const Icon(Icons.replay, size: 14),
                                      label: const Text('Pesan Lagi', style: TextStyle(fontSize: 12)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        minimumSize: Size.zero,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
