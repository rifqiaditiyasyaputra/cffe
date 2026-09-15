import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/menu_card.dart';
import 'menu_detail_sheet.dart';

class HomeTab extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeTab({
    Key? key,
    required this.onNavigateToTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Greeting Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryCoffee,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${authProvider.currentUser?.name ?? "Pelanggan"} 👋',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            Text(
                              'Mau ngopi apa hari ini?',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: AppTheme.primaryCoffee, size: 26),
                      onPressed: () => onNavigateToTab(1), // Switch to Menu Tab
                    ),
                  ],
                ),
              ),

              // Promo Banners
              const BannerCarouselWidget(),
              const SizedBox(height: 16),

              // Mood Selector Component (Feature C)
              MoodSelectorWidget(
                selectedMood: menuProvider.selectedMood,
                onMoodSelected: (mood) {
                  menuProvider.setMood(mood);
                  onNavigateToTab(1); // Jump to Menu tab filtered by mood
                },
              ),
              const SizedBox(height: 18),

              // Bestseller Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu Terlaris 🔥',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateToTab(1),
                      child: Text(
                        'Lihat Semua',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryCoffee,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bestsellers Grid / List
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: menuProvider.bestsellerItems.length,
                itemBuilder: (context, index) {
                  final item = menuProvider.bestsellerItems[index];
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
