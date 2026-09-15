import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/menu_item.dart';
import '../../providers/menu_provider.dart';
import '../../theme/app_theme.dart';

class AdminMenuManagement extends StatelessWidget {
  const AdminMenuManagement({Key? key}) : super(key: key);

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  void _showAddEditMenuDialog(BuildContext context, {MenuItemModel? existingItem}) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

    final nameCtrl = TextEditingController(text: existingItem?.name ?? '');
    final descCtrl = TextEditingController(text: existingItem?.description ?? '');
    final priceCtrl = TextEditingController(text: existingItem != null ? existingItem.price.toStringAsFixed(0) : '');
    final imageCtrl = TextEditingController(
      text: existingItem?.image ?? 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800&auto=format&fit=crop',
    );
    String category = existingItem?.category ?? 'Kopi';
    bool isBestseller = existingItem?.isBestseller ?? false;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(
            existingItem == null ? 'Tambah Menu Baru' : 'Edit Menu',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Menu'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: const [
                    DropdownMenuItem(value: 'Kopi', child: Text('Kopi')),
                    DropdownMenuItem(value: 'Nonkopi', child: Text('Nonkopi')),
                    DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                    DropdownMenuItem(value: 'Camilan', child: Text('Camilan')),
                  ],
                  onChanged: (val) {
                    if (val != null) category = val;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageCtrl,
                  decoration: const InputDecoration(labelText: 'URL Foto Menu'),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setSS) {
                    return CheckboxListTile(
                      title: const Text('Menu Terlaris / Favorit'),
                      value: isBestseller,
                      onChanged: (val) => setSS(() => isBestseller = val ?? false),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final double parsedPrice = double.tryParse(priceCtrl.text) ?? 20000;
                if (existingItem == null) {
                  final newItem = MenuItemModel(
                    id: 'menu_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    price: parsedPrice,
                    category: category,
                    rating: 4.8,
                    image: imageCtrl.text,
                    isAvailable: true,
                    isBestseller: isBestseller,
                    moodTags: ['santai', 'manis'],
                  );
                  menuProvider.addMenuItem(newItem);
                } else {
                  final updatedItem = existingItem.copyWith(
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    price: parsedPrice,
                    category: category,
                    image: imageCtrl.text,
                    isBestseller: isBestseller,
                  );
                  menuProvider.updateMenuItem(updatedItem);
                }
                Navigator.pop(dialogCtx);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final items = menuProvider.allItems;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Menu (${items.length})',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditMenuDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah Menu'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '${item.category} • ${formatRupiah(item.price)}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 4),
                          // Stock Status Switch (Fitur D)
                          Row(
                            children: [
                              Text(
                                item.isAvailable ? 'Status: Tersedia' : 'Status: HABIS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: item.isAvailable ? AppTheme.accentGreen : Colors.redAccent,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: item.isAvailable,
                                activeColor: AppTheme.accentGreen,
                                onChanged: (_) {
                                  menuProvider.toggleAvailability(item.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: AppTheme.primaryCoffee),
                      onPressed: () => _showAddEditMenuDialog(context, existingItem: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                      onPressed: () {
                        menuProvider.deleteMenuItem(item.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
