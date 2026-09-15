class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isGuest;
  bool isAdminMode;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isGuest = false,
    this.isAdminMode = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isGuest,
    bool? isAdminMode,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isAdminMode: isAdminMode ?? this.isAdminMode,
    );
  }
}
