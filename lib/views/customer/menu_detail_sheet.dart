import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/menu_item.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class MenuDetailSheet extends StatefulWidget {
  final MenuItemModel menuItem;

  const MenuDetailSheet({
    Key? key,
    required this.menuItem,
  }) : super(key: key);

  @override
  State<MenuDetailSheet> createState() => _MenuDetailSheetState();
}

class _MenuDetailSheetState extends State<MenuDetailSheet> {
  String _selectedSize = 'Reguler';
  final List<String> _selectedToppings = [];
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _toppingsList = [
    {'name': 'Extra Shot Espresso', 'price': 4000.0},
    {'name': 'Boba Tapioka', 'price': 4000.0},
    {'name': 'Whipped Cream', 'price': 4000.0},
    {'name': 'Caramel Syrup', 'price': 4000.0},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  double get calculateTotalPrice {
    double sizeExtra = _selectedSize == 'Large' ? 5000.0 : 0.0;
    double toppingsExtra = _selectedToppings.length * 4000.0;
    return (widget.menuItem.price + sizeExtra + toppingsExtra) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: Image.network(
                      widget.menuItem.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.menuItem.name,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.lightCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.latteBrown.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.menuItem.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatRupiah(widget.menuItem.price),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryCoffee,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.menuItem.description,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
                  ),
                  const Divider(height: 28),

                  // Size Selection
                  Text(
                    'Pilih Ukuran',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSizeChip('Reguler', 'Standard', 0),
                      const SizedBox(width: 12),
                      _buildSizeChip('Large', '+ Rp 5.000', 5000),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Toppings Selection
                  Text(
                    'Pilihan Topping Extra',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: _toppingsList.map((topping) {
                      final name = topping['name'] as String;
                      final isChecked = _selectedToppings.contains(name);
                      return CheckboxListTile(
                        value: isChecked,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppTheme.primaryCoffee,
                        title: Text(name, style: const TextStyle(fontSize: 14)),
                        subtitle: Text('+ ${formatRupiah(topping['price'])}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedToppings.add(name);
                            } else {
                              _selectedToppings.remove(name);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Special Instructions Note
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'Catatan khusus (misal: Kurangi gula, es sedikit)...',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quantity Selector & Add Button Footer
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.warmCream,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                setState(() => _quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              cartProvider.addToCart(
                                item: widget.menuItem,
                                quantity: _quantity,
                                size: _selectedSize,
                                toppings: _selectedToppings,
                                notes: _notesController.text,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppTheme.primaryCoffee,
                                  content: Text('${widget.menuItem.name} ditambahkan ke keranjang'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(
                              'Tambah • ${formatRupiah(calculateTotalPrice)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeChip(String title, String subtitle, double extraPrice) {
    bool isSelected = _selectedSize == title;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSize = title;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryCoffee : AppTheme.warmCream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primaryCoffee : AppTheme.borderLight,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
