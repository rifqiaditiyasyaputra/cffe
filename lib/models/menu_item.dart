class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // Kopi, Nonkopi, Makanan, Camilan
  final double rating;
  final String image;
  bool isAvailable;
  final bool isBestseller;
  final List<String> moodTags; // 'energi', 'santai', 'manis', 'segar'

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.rating,
    required this.image,
    this.isAvailable = true,
    this.isBestseller = false,
    required this.moodTags,
  });

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    double? rating,
    String? image,
    bool? isAvailable,
    bool? isBestseller,
    List<String>? moodTags,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      isBestseller: isBestseller ?? this.isBestseller,
      moodTags: moodTags ?? this.moodTags,
    );
  }
}
