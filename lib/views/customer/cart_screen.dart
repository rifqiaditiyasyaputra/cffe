import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: Text('Keranjang Pesanan', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                cartProvider.clearCart();
              },
              child: const Text('Kosongkan', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 72, color: AppTheme.textMuted.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Anda Masih Kosong',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih kopi dan camilan favorit Anda terlebih dahulu.',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Lihat Menu KopiKita'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryCoffee.withOpacity(0.04),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                cartItem.item.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cartItem.item.name,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                        onPressed: () => cartProvider.removeItem(index),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Ukuran: ${cartItem.size}${cartItem.toppings.isNotEmpty ? " • ${cartItem.toppings.join(', ')}" : ""}',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                  ),
                                  if (cartItem.notes.isNotEmpty)
                                    Text(
                                      'Catatan: "${cartItem.notes}"',
                                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.mochaBrown),
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatRupiah(cartItem.totalPrice),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryCoffee,
                                          fontSize: 14,
                                        ),
                                      ),
                                      // Quantity buttons
                                      Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppTheme.warmCream,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove, size: 14),
                                              onPressed: () => cartProvider.updateQuantity(index, cartItem.quantity - 1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 28),
                                            ),
                                            Text(
                                              '${cartItem.quantity}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add, size: 14),
                                              onPressed: () => cartProvider.updateQuantity(index, cartItem.quantity + 1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 28),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Price Breakdown Footer Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal Pesanan', style: TextStyle(color: AppTheme.textMuted)),
                          Text(formatRupiah(cartProvider.subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pajak (10%) & Layanan', style: TextStyle(color: AppTheme.textMuted)),
                          Text(formatRupiah(cartProvider.taxAndService), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Pembayaran', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            formatRupiah(cartProvider.grandTotal),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.primaryCoffee,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                            );
                          },
                          child: const Text('Lanjutkan Pemesanan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
