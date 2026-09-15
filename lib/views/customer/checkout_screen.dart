import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import 'order_status_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _orderType = 'Makan di Tempat'; // 'Makan di Tempat' or 'Bawa Pulang'
  final TextEditingController _tableNumberController = TextEditingController(text: '05');
  String _paymentMethod = 'QRIS';

  final List<String> _paymentMethods = ['QRIS', 'Tunai', 'Digital Payment'];

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: Text('Checkout Pesanan', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Type Segmented Choice (Feature A: Nomor Meja)
            Text(
              'Jenis Pemesanan',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildOrderTypeTile('Makan di Tempat', Icons.restaurant),
                const SizedBox(width: 12),
                _buildOrderTypeTile('Bawa Pulang', Icons.takeout_dining),
              ],
            ),
            const SizedBox(height: 16),

            // Table Number Input (Conditional on Dine-in)
            if (_orderType == 'Makan di Tempat') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.warmCream,
                      child: Icon(Icons.table_restaurant, color: AppTheme.accentGreen),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nomor Meja Kafe', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          TextField(
                            controller: _tableNumberController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: 'Contoh: 05',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Payment Method Selection
            Text(
              'Metode Pembayaran',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _paymentMethods.map((method) {
                  return RadioListTile<String>(
                    value: method,
                    groupValue: _paymentMethod,
                    activeColor: AppTheme.primaryCoffee,
                    title: Text(method, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    secondary: Icon(
                      method == 'QRIS'
                          ? Icons.qr_code_scanner
                          : (method == 'Tunai' ? Icons.payments_outlined : Icons.account_balance_wallet_outlined),
                      color: AppTheme.primaryCoffee,
                    ),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // QRIS Code Simulator view
            if (_paymentMethod == 'QRIS') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2, size: 100, color: AppTheme.primaryCoffee),
                    const SizedBox(height: 6),
                    const Text('Scan QRIS KopiKita (Simulasi)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const Text('Mendukung GoPay, OVO, Dana, ShopeePay, & Mobile Banking', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Summary Review
            Text(
              'Ringkasan Pesanan',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...cartProvider.cartItems.map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${c.quantity}x ${c.item.name} (${c.size})', style: const TextStyle(fontSize: 13)),
                            Text(formatRupiah(c.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        formatRupiah(cartProvider.grandTotal),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryCoffee),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  final newOrder = orderProvider.createOrder(
                    items: cartProvider.cartItems,
                    subtotal: cartProvider.subtotal,
                    taxAndService: cartProvider.taxAndService,
                    total: cartProvider.grandTotal,
                    orderType: _orderType,
                    tableNumber: _orderType == 'Makan di Tempat' ? _tableNumberController.text : null,
                    paymentMethod: _paymentMethod,
                  );
                  cartProvider.clearCart();

                  // Start live simulator for order progress
                  orderProvider.simulateOrderProgress(newOrder.id);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusScreen(order: newOrder),
                    ),
                  );
                },
                child: const Text('Buat Pesanan Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeTile(String type, IconData icon) {
    bool isSelected = _orderType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _orderType = type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryCoffee : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppTheme.primaryCoffee : AppTheme.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppTheme.primaryCoffee),
              const SizedBox(height: 6),
              Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
