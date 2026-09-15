import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/menu_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/menu_card.dart';
import 'menu_detail_sheet.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({Key? key}) : super(key: key);

  final List<String> categories = const ['Semua', 'Kopi', 'Nonkopi', 'Makanan', 'Camilan'];

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final filteredItems = menuProvider.filteredItems;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search & Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Katalog Menu',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      // Sorting Dropdown Menu
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.sort_rounded, color: AppTheme.primaryCoffee),
                        tooltip: 'Urutkan Menu',
                        onSelected: (val) {
                          menuProvider.setSortBy(val);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'default',
                            child: Text('Default'),
                          ),
                          const PopupMenuItem(
                            value: 'price_asc',
                            child: Text('Harga: Termurah ke Termahal'),
                          ),
                          const PopupMenuItem(
                            value: 'price_desc',
                            child: Text('Harga: Termahal ke Termurah'),
                          ),
                          const PopupMenuItem(
                            value: 'rating',
                            child: Text('Rating Tertinggi'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Search Bar Input
                  TextField(
                    onChanged: (val) => menuProvider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Cari kopi, makanan, camilan...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primaryCoffee),
                      suffixIcon: menuProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                              onPressed: () => menuProvider.setSearchQuery(''),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Category Horizontal Pills
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = menuProvider.selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.primaryCoffee,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryCoffee,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryCoffee : AppTheme.borderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (_) => menuProvider.setCategory(cat),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Menu Grid View / Empty State
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee_outlined, size: 64, color: AppTheme.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'Menu tidak ditemukan',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba kata kunci atau filter lain.',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return MenuCardWidget(
                          menuItem: item,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => MenuDetailSheet(menuItem: item),
                            );
                          },
                          onAddPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => MenuDetailSheet(menuItem: item),
                            );
                          },
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
