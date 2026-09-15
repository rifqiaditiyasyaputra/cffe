import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _currentUser?.isGuest ?? true;
  bool get isAdminMode => _currentUser?.isAdminMode ?? false;

  AuthProvider() {
    // Default guest session for quick trial
    loginAsGuest();
  }

  void loginAsGuest() {
    _currentUser = UserModel(
      id: 'guest_001',
      name: 'Tamu KopiKita',
      email: 'tamu@kopikita.id',
      isGuest: true,
      isAdminMode: false,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  bool login(String email, String password) {
    if (email.isNotEmpty && password.length >= 6) {
      // Check if admin login credentials
      bool isStaff = email.contains('admin') || email.contains('kasir');
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: isStaff ? 'Admin KopiKita' : 'Budi Santoso',
        email: email,
        isGuest: false,
        isAdminMode: isStaff,
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String name, String email, String password) {
    if (name.isNotEmpty && email.contains('@') && password.length >= 6) {
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        isGuest: false,
        isAdminMode: false,
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void toggleAdminMode(bool value) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isAdminMode: value);
      notifyListeners();
    }
  }

  void logout() {
    loginAsGuest();
  }
}
