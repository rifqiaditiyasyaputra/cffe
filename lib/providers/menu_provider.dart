import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuItemModel> _items = [];
  String _selectedCategory = 'Semua';
  String _selectedMood = 'Semua';
  String _searchQuery = '';
  String _sortBy = 'default'; // 'default', 'price_asc', 'price_desc', 'rating'

  List<MenuItemModel> get allItems => _items;
  String get selectedCategory => _selectedCategory;
  String get selectedMood => _selectedMood;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  MenuProvider() {
    _loadInitialDummyData();
  }

  void _loadInitialDummyData() {
    _items = [
      MenuItemModel(
        id: 'k1',
        name: 'Kopi Susu Aren Heritage',
        description: 'Espresso robusta pilihan dipadu dengan susu segar manis gurih dan gula aren asli Tuban.',
        price: 22000,
        category: 'Kopi',
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: true,
        moodTags: ['energi', 'manis'],
      ),
      MenuItemModel(
        id: 'k2',
        name: 'Americano Double Shot',
        description: 'Dua shot espresso premium arabika Sumatra dengan air mineral dingin dan aroma floral intense.',
        price: 18000,
        category: 'Kopi',
        rating: 4.7,
        image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: false,
        moodTags: ['energi', 'segar'],
      ),
      MenuItemModel(
        id: 'k3',
        name: 'Caramel Macchiato Velvet',
        description: 'Paduan vanila lembut, susu steam creamy, espresso rich, dan saus karamel lumer.',
        price: 28000,
        category: 'Kopi',
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: true,
        moodTags: ['manis', 'santai'],
      ),
      MenuItemModel(
        id: 'k4',
        name: 'Warm Vanilla Cappuccino',
        description: 'Espresso seimbang dengan buih susu tebal dan taburan bubuk cokelat aroma kayu manis.',
        price: 25000,
        category: 'Kopi',
        rating: 4.6,
        image: 'https://images.unsplash.com/photo-1534778101976-62847782c213?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: false,
        moodTags: ['santai', 'manis'],
      ),
      MenuItemModel(
        id: 'nk1',
        name: 'Matcha Uji Premium Latte',
        description: 'Bubuk green tea Uji asli Jepang yang diproduksi secara tradisional dengan foam susu gurih.',
        price: 27000,
        category: 'Nonkopi',
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: true,
        moodTags: ['santai', 'segar'],
      ),
      MenuItemModel(
        id: 'nk2',
        name: 'Signature Dark Chocolate',
        description: 'Cokelat hitam 70% kakao melimpah dipadukan dengan milk microfoam lembut yang menenangkan.',
        price: 26000,
        category: 'Nonkopi',
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: false,
        moodTags: ['manis', 'santai'],
      ),
      MenuItemModel(
        id: 'nk3',
        name: 'Sparkling Berry Mojito',
        description: 'Minuman soda segar dengan campuran stroberi alami, ekstrak mint, dan irisan lemon segar.',
        price: 24000,
        category: 'Nonkopi',
        rating: 4.7,
        image: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: false,
        moodTags: ['segar'],
      ),
      MenuItemModel(
        id: 'm1',
        name: 'Nasi Goreng KopiKita Special',
        description: 'Nasi goreng bumbu racik istimewa dengan sosis, bakso, telur mata sapi, dan kerupuk renyah.',
        price: 35000,
        category: 'Makanan',
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: true,
        moodTags: ['energi'],
      ),
      MenuItemModel(
        id: 'm2',
        name: 'Beef Teriyaki Rice Bowl',
        description: 'Daging sapi iris saus teriyaki gurih manis di atas nasi hangat wijen saus khas kafe.',
        price: 38000,
        category: 'Makanan',
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=800&auto=format&fit=crop',
        isAvailable: false, // Out of stock example
        isBestseller: true,
        moodTags: ['energi'],
      ),
      MenuItemModel(
        id: 'c1',
        name: 'Crispy French Fries Truffle',
        description: 'Kentang goreng renyah bumbu truffle oil dan taburan keju parmesan gurih menggugah selera.',
        price: 20000,
        category: 'Camilan',
        rating: 4.6,
        image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: false,
        moodTags: ['santai'],
      ),
      MenuItemModel(
        id: 'c2',
        name: 'Croissant Butter Melt',
        description: 'Pastry khas Perancis berlapis renyah luar lembut dalam dengan aroma mentega premium.',
        price: 23000,
        category: 'Camilan',
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=800&auto=format&fit=crop',
        isAvailable: true,
        isBestseller: true,
        moodTags: ['santai', 'manis'],
      ),
    ];
  }

  // Filtered menu items
  List<MenuItemModel> get filteredItems {
    return _items.where((item) {
      // Category filter
      if (_selectedCategory != 'Semua' && item.category != _selectedCategory) {
        return false;
      }
      // Mood filter
      if (_selectedMood != 'Semua' && !item.moodTags.contains(_selectedMood.toLowerCase())) {
        return false;
      }
      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = item.name.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        if (!matchName && !matchDesc) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'price_asc') return a.price.compareTo(b.price);
        if (_sortBy == 'price_desc') return b.price.compareTo(a.price);
        if (_sortBy == 'rating') return b.rating.compareTo(a.rating);
        return 0;
      });
  }

  List<MenuItemModel> get bestsellerItems {
    return _items.where((item) => item.isBestseller).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setMood(String mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  // Admin CRUD Functions
  void toggleAvailability(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isAvailable = !_items[index].isAvailable;
      notifyListeners();
    }
  }

  void addMenuItem(MenuItemModel newItem) {
    _items.add(newItem);
    notifyListeners();
  }

  void updateMenuItem(MenuItemModel updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteMenuItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
