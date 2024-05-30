import 'dart:async';

import 'package:automated_texbook_system/model/cart.dart';
import 'package:automated_texbook_system/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider(
    cartServices: CartServices(),
  );
});

class CartProvider extends ChangeNotifier {
  final CartServices _cartServices;

  CartProvider({required CartServices cartServices})
      : _cartServices = cartServices;

  int _cart = 0;
  int get cart => _cart;

  FutureOr<String> addCart({required String uid, required Cart books}) async {
    setCart(uid: uid);
    notifyListeners();
    return await _cartServices.addBookToCart(uid: uid, books: books);
  }

  FutureOr<void> setCart({required String uid}) async {
    try {
      _cart = 0;
      notifyListeners();
      final carts = await _cartServices.getCartBooks(uid: uid);
      for (Cart cart in carts) {
        _cart += cart.quantity;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Cart>> cartBooks(uid) async =>
      await _cartServices.getCartBooks(uid: uid);

  FutureOr<void> removeCart(
      {required String bookId, required String uid}) async {
    _cart--;
    await _cartServices.removeBookFromCart(bookId: bookId, uid: uid);
    notifyListeners();
  }
}
