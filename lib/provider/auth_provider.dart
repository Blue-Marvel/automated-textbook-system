import 'dart:async';

import 'package:automated_texbook_system/model/librarian.dart';
import 'package:automated_texbook_system/model/user.dart';
import 'package:automated_texbook_system/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(
    authServices: AuthServices(),
  ),
);

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices;
  AuthProvider({required AuthServices authServices})
      : _authServices = authServices;

  UserModel? _userModel;
  Librarian? _librarian;

  UserModel? get userModel => _userModel;
  Librarian? get librarian => _librarian;

  FutureOr<void> studentRegister(
      {required UserModel userModel, required String password}) async {
    try {
      print('print ${userModel.toString()}');
      _userModel = await _authServices.studentRegister(userModel, password);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  FutureOr<void> librarianRegister(
      {required Librarian librarian, required String password}) async {
    try {
      _librarian = await _authServices.librarianRegister(librarian, password);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  FutureOr<void> studentLogin(
      {required String email, required String password}) async {
    try {
      _userModel = await _authServices.studentLogin(email, password);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  FutureOr<void> librarianLogin(
      {required String email, required String password}) async {
    try {
      _librarian = await _authServices.librarianLogin(email, password);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authServices.logout();
    } catch (e) {
      rethrow;
    }
  }
}
